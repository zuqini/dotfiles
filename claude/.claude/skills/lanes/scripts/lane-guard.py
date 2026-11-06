#!/usr/bin/env python3
"""PreToolUse hook for lanes: block outward-facing commands in any spelling.

Deny rules match the command text as usually written, so `git -C . push` or
`bash -c 'git push'` slip past them. This parses each subcommand, skips git's
global options and command wrappers, and recurses into code handed to a shell
or interpreter and into command substitutions. Defense in depth, not a
security boundary. Any internal error blocks the command.
"""
import json
import os
import re
import shlex
import sys

SEPARATORS = {"&&", "||", ";", "|", "|&", "&", "(", ")", ";;", "\n", "`", "{", "}"}
KEYWORDS = {"!", "if", "then", "else", "elif", "do", "while", "until", "time"}
WRAPPERS = {
    "env", "command", "builtin", "exec", "nohup", "nice", "xargs", "sudo", "timeout", "eval",
    "stdbuf", "watch", "setsid", "flock", "ionice", "noglob", "caffeinate",
}
INTERPRETERS = {
    "sh", "bash", "zsh", "dash", "ksh", "fish", "eval", "ssh",
    "python", "python3", "perl", "ruby", "node", "osascript",
}
GUARDED = {"git", "gh", "claude"}
LANE_SCRIPTS = {"start-lane.sh", "lane-ctl.sh"}
GIT_OPTS_WITH_ARG = {"-C", "-c", "--git-dir", "--work-tree", "--namespace", "--exec-path", "--config-env"}
GH_READ_ONLY = {"view", "list", "status", "diff", "checks", "checkout", "clone", "search"}
GH_GUARDED = {"pr", "issue", "release", "repo", "gist", "secret", "variable", "workflow", "run", "label"}


def program(tokens):
    i = 0
    while i < len(tokens):
        tok = tokens[i]
        if re.match(r"^[A-Za-z_][A-Za-z0-9_]*=", tok) or tok in KEYWORDS:
            i += 1
        elif os.path.basename(tok) in WRAPPERS:
            rest = tokens[i + 1:]
            if os.path.basename(tok) == "command" and rest[:1] and rest[0] in {"-v", "-V"}:
                return None, []
            j = next((k for k, t in enumerate(rest) if os.path.basename(t) in GUARDED), None)
            if j is None:
                return os.path.basename(tok), rest
            return os.path.basename(rest[j]), rest[j + 1:]
        else:
            return os.path.basename(tok), tokens[i + 1:]
    return None, []


def git_reason(args):
    i = 0
    while i < len(args) and args[i].startswith("-"):
        if args[i] == "-c" and i + 1 < len(args) and re.match(r"^alias\..*=.*\bpush\b", args[i + 1]):
            return "git alias for push"
        i += 2 if args[i] in GIT_OPTS_WITH_ARG else 1
    sub, rest = (args[i], args[i + 1:]) if i < len(args) else (None, [])
    if sub in {"push", "send-pack"} or "push" in rest and sub in {"remote", "subtree"}:
        return "git push"
    if sub == "branch" and any(a in {"-d", "-D", "--delete"} or re.match(r"^-[a-zA-Z]*[dD]", a) for a in rest):
        return "git branch delete"
    if sub == "update-ref" and "-d" in rest:
        return "git update-ref -d"
    if sub == "worktree" and rest[:1] and rest[0] in {"remove", "prune"}:
        return "git worktree " + rest[0]
    return None


def gh_reason(args):
    if not args:
        return None
    sub = args[0]
    if sub == "api":
        writes = {"-f", "-F", "--field", "--raw-field", "--input"}
        method = next((args[j + 1] for j, a in enumerate(args[:-1]) if a in {"-X", "--method"}), None)
        method = method or next((a.split("=", 1)[1] for a in args if a.startswith("--method=")), None)
        if method and method.upper() != "GET" or any(a in writes or a.startswith(("--field=", "--raw-field=")) for a in args):
            return "gh api write"
        return None
    if sub in GH_GUARDED and not (len(args) > 1 and args[1] in GH_READ_ONLY):
        return "gh " + " ".join(args[:2])
    return None


def strip_quoted_heredocs(command):
    out, lines, i = [], command.split("\n"), 0
    while i < len(lines):
        out.append(lines[i])
        delims = re.findall(r"<<-?\s*(['\"])([^'\"\s]+)\1", lines[i])
        i += 1
        for _, delim in delims:
            while i < len(lines) and lines[i].strip() != delim:
                i += 1
            i += 1
    return "\n".join(out)


def tokenize(command):
    command = strip_quoted_heredocs(command)
    lexer = shlex.shlex(command.replace("`", " ` "), posix=True, punctuation_chars="();<>|&\n`")
    lexer.whitespace = " \t\r"
    lexer.whitespace_split = True
    return list(lexer)


def reasons(command, eager=False, depth=0):
    if depth > 4:
        return ["nesting too deep to check"]
    try:
        tokens = tokenize(command)
    except ValueError:
        found = []
        if re.search(r"\bgit\b.*\b(push|send-pack)\b", command):
            found.append("git push (unparsed)")
        if re.search(r"\bclaude\b", command):
            found.append("claude CLI (unparsed)")
        return found
    found, current = [], []
    for tok in tokens + [";"]:
        if tok not in SEPARATORS:
            current.append(tok)
            continue
        name, args = program(current)
        if name == "git":
            found.append(git_reason(args))
        elif name == "gh":
            found.append(gh_reason(args))
        elif name == "claude":
            found.append("claude CLI")
        if any(os.path.basename(t) in LANE_SCRIPTS for t in current):
            found.append("lane session control")
        nested_eager = eager or name in INTERPRETERS
        for arg in current:
            if re.search(r"\s", arg) and (nested_eager or re.search(r"\$\(|`|<\(", arg)):
                found.extend(reasons(arg, nested_eager, depth + 1))
        current = []
    return [r for r in found if r]


def main():
    payload = json.load(sys.stdin)
    command = (payload.get("tool_input") or {}).get("command") or ""
    found = reasons(command)
    if found:
        print(
            "Blocked for lanes: " + ", ".join(sorted(set(found)))
            + ". The coordinator does this. Log what you need in LOG.md and signal the coordinator.",
            file=sys.stderr,
        )
        return 2
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:
        print(f"lane-guard failed ({type(e).__name__}: {e}); blocking to be safe.", file=sys.stderr)
        sys.exit(2)
