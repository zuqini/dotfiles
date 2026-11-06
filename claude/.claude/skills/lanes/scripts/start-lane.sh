#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "usage: start-lane.sh <lane-worktree> <lane-name> <brief> [claude flags...]" >&2
  exit 2
fi

if [[ ! -f $3 ]]; then
  echo "no brief at $3" >&2
  exit 1
fi

worktree=$(realpath "$1")
name=$2
brief=$(realpath "$3")
shift 3

git_dir=$(git -C "$worktree" rev-parse --absolute-git-dir)
common_dir=$(git -C "$worktree" rev-parse --path-format=absolute --git-common-dir)
if [[ $git_dir == "$common_dir" ]]; then
  echo "$worktree is a main checkout; a lane must start in its own linked worktree" >&2
  exit 1
fi

overlap=$(claude agents --json --all | python3 -c '
import json, sys
name = sys.argv[1]
for a in json.load(sys.stdin):
    other = a.get("name") or ""
    if other and (name in other or other in name):
        print(other + " (" + str(a.get("id") or a.get("sessionId")) + ")")
' "$name")
if [[ -n $overlap ]]; then
  echo "lane name $name overlaps running session(s): $overlap" >&2
  exit 1
fi

guard="$(cd "$(dirname "$0")" && pwd -P)/lane-guard.py"
# onFailure is 2.1.295+; older versions reject the whole --settings value and the lane exits at start.
version=$(claude --version 2>/dev/null | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+' | head -1)
on_failure=',"onFailure":"block"'
if [[ -z $version || $(printf '%s\n' 2.1.295 "$version" | sort -V | head -1) != 2.1.295 ]]; then
  on_failure=''
fi
lane_dir=$(dirname "$brief")
settings='{"crossSessionInbound":"accept","permissions":{"deny":[
  "Bash(git push *)",
  "Bash(git branch -d *)", "Bash(git branch -D *)", "Bash(git worktree remove *)",
  "Bash(gh pr create *)", "Bash(gh pr merge *)", "Bash(gh pr close *)",
  "Bash(gh pr comment *)", "Bash(gh pr review *)", "Bash(gh pr edit *)",
  "Bash(gh issue create *)", "Bash(gh issue close *)",
  "Bash(gh issue comment *)", "Bash(gh issue edit *)",
  "Bash(gh release *)",
  "Bash(claude *)"
]},"hooks":{"PreToolUse":[{"matcher":"Bash","hooks":[
  {"type":"command","command":"python3 -I '"$guard"'"'"$on_failure"'}
]}]}}'

prompt="You are lane $name. Read ~/.claude/skills/lanes/worker.md, then your brief at $brief, and follow both. Commit on your branch without asking; you never push. Rebuild your state from the brief, your LOG.md and git in this worktree; nothing else carries over."

cd "$worktree"
exec claude --bg "$prompt" -n "$name" --add-dir "$lane_dir" --settings "$settings" "$@"
