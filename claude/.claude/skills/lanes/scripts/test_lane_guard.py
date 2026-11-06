#!/usr/bin/env python3
"""Spelling table for lane-guard.py. Run: python3 -I test_lane_guard.py"""
import json
import os
import subprocess
import sys

GUARD = os.path.join(os.path.dirname(os.path.abspath(__file__)), "lane-guard.py")

BLOCKED = [
    "git push", "git -C . push", "git -c a=b push origin x", "git --no-pager push", "/usr/bin/git push",
    "git push --dry-run", "git push 2>&1 | tail", "cd x; git push", "echo hi\ngit push",
    "bash -c 'git push'", "sh -c \"cd x && git push\"", "eval git push", "eval 'git push'",
    "python3 -c 'import os; os.system(\"git push\")'",
    "$(git push)", "echo `git push`", "echo \"$(git push)\"", "echo \"a `git push` b\"",
    "timeout 10 git push", "xargs git push", "sudo -u x git push", "env -i git push", "env -u X git push",
    "nice -n 5 git push", "stdbuf -o0 git push", "watch git push",
    "git -c alias.p=push p", "git -c 'alias.p=!git push' p", "f(){ git push; }; f",
    "for r in a b; do git push $r; done", "if true; then git push; fi",
    "git send-pack origin", "git subtree push --prefix x", "git remote x push",
    "git branch -D foo", "git branch -d foo", "git update-ref -d refs/heads/x",
    "git worktree remove x", "git -C . worktree prune",
    "gh pr create --fill", "GH_HOST=x gh pr comment 3 -b hi", "gh pr review 3 --approve",
    "gh api -X POST repos/x", "gh api repos/x -f a=b", "gh repo create x", "gh run rerun 3",
    "gh workflow run x", "cat <<EOF\n$(git push)\nEOF", "cat <<'EOF'\nliteral\nEOF\ngit push", "claude agents", "claude --version",
    "~/.claude/skills/lanes/scripts/start-lane.sh wt name brief", "bash scripts/lane-ctl.sh stop abc", "printf '%s' \"$(claude --version)\"",
]

ALLOWED = [
    "git status", "git log --oneline", "git branch -vv", "git branch --list", "git branch -m a b",
    "git worktree list", "git stash push -m x", "git remote prune origin", "git remote add x y",
    "git commit -m 'do not push yet'", "git commit -m \"gh pr create now waits\"",
    "git commit -m \"$(cat <<'EOF'\nlane-guard: block git push in any spelling\nEOF\n)\"",
    "grep -r 'git push' .", "rg claude", "cat ~/.claude/CLAUDE.md", "ls ~/.claude/skills",
    "echo push", "which claude", "command -v claude",
    "python3 ~/.claude/skills/lanes/scripts/watch-lanes.py ~/workspace/x",
    "gh pr view 3", "gh pr list", "gh pr checks 3", "gh issue view 3", "gh run view 3",
    "gh repo clone x", "gh search prs --author @me", "gh label list", "gh api repos/x/y/pulls",
    "find . -name '*.py' -exec wc -l {} +",
    "cat >> LOG.md <<'EOF'\n- `bash -c 'claude --version'` blocked\n- `git -C . push` blocked\nEOF",
]


def blocked(command):
    payload = json.dumps({"tool_name": "Bash", "tool_input": {"command": command}})
    return subprocess.run([sys.executable, "-I", GUARD], input=payload, capture_output=True, text=True).returncode == 2


def main():
    wrong = [("missed", c) for c in BLOCKED if not blocked(c)] + [("over-blocked", c) for c in ALLOWED if blocked(c)]
    for kind, command in wrong:
        print(f"{kind}: {command!r}")
    if subprocess.run([sys.executable, "-I", GUARD], input="not json", capture_output=True, text=True).returncode != 2:
        wrong.append(("fails open", "bad payload"))
        print("fails open on a bad payload")
    print(f"{len(BLOCKED) + len(ALLOWED) + 1 - len(wrong)} ok, {len(wrong)} wrong")
    return 1 if wrong else 0


if __name__ == "__main__":
    sys.exit(main())
