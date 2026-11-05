#!/usr/bin/env python3
"""PreToolUse hook for lanes: block outward-facing commands in any spelling.

Deny rules match the command text as usually written, so `git -C . push` or
`bash -c 'git push'` slip past them. This parses each subcommand, skips git's
global options, and recurses into quoted strings. Defense in depth, not a
security boundary.
"""
import json
import os
import re
import shlex
import sys

SEPARATORS = {"&&", "||", ";", "|", "|&", "&", "(", ")", ";;"}
WRAPPERS = {"env", "command", "builtin", "exec", "nohup", "time", "nice", "xargs", "sudo", "timeout"}
GIT_OPTS_WITH_ARG = {"-C", "-c", "--git-dir", "--work-tree", "--namespace", "--exec-path", "--config-env"}
GH_READ_ONLY = {"view", "list", "status", "diff", "checks", "checkout", "clone", "search"}
GH_GUARDED = {"pr", "issue", "release", "repo", "gist", "secret", "variable", "workflow", "run", "label"}


def program(tokens):
    i = 0
    while i < len(tokens):
        tok = tokens[i]
        if re.match(r"^[A-Za-z_][A-Za-z0-9_]*=", tok):
            i += 1
        elif os.path.basename(tok) in WRAPPERS:
            i += 1
            while i < len(tokens) and tokens[i].startswith("-"):
                i += 1
            if os.path.basename(tokens[i - 1]) == "timeout" and i < len(tokens):
                i += 1
        else:
            return os.path.basename(tok), tokens[i + 1:]
    return None, []


def git_reason(args):
    i = 0
    while i < len(args) and args[i].startswith("-"):
        i += 2 if args[i] in GIT_OPTS_WITH_ARG else 1
    sub, rest = (args[i], args[i + 1:]) if i < len(args) else (None, [])
    if sub == "push" or "push" in rest and sub in {"remote", "subtree"}:
        return "git push"
    if sub == "branch" and any(a in {"-d", "-D", "--delete"} or re.match(r"^-[a-zA-Z]*[dD]", a) for a in rest):
        return "git branch delete"
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


def reasons(command, depth=0):
    if depth > 4:
        return []
    try:
        lexer = shlex.shlex(command, posix=True, punctuation_chars=True)
        lexer.whitespace_split = True
        tokens = list(lexer)
    except ValueError:
        found = []
        if re.search(r"\bgit\b.*\bpush\b", command):
            found.append("git push (unparsed)")
        if re.search(r"\bclaude\b", command):
            found.append("claude CLI (unparsed)")
        return found
    found, current = [], []
    for tok in tokens + [";"]:
        if tok in SEPARATORS:
            name, args = program(current)
            if name == "git":
                found.append(git_reason(args))
            elif name == "gh":
                found.append(gh_reason(args))
            elif name == "claude":
                found.append("claude CLI")
            current = []
        else:
            current.append(tok)
            if re.search(r"\s", tok):
                found.extend(reasons(tok, depth + 1))
    return [r for r in found if r]


def main():
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return 0
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
    sys.exit(main())
