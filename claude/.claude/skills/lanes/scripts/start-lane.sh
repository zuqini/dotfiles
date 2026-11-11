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
jobs_dir=${CLAUDE_CONFIG_DIR:-$HOME/.claude}/jobs
projects_dir=${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects

launch() {
  local out
  out=$(claude --bg "$prompt" -n "$name" --add-dir "$lane_dir" --settings "$settings" "$@")
  echo "$out" >&2
  grep -oE 'backgrounded · [0-9a-f]+' <<<"$out" | awk '{print $3}'
}

# Prints started, settled (ended without a transcript) or pending.
status() {
  python3 -I - "$jobs_dir/$1/state.json" "$projects_dir" <<'EOF'
import json, os, re, sys
try:
    job = json.load(open(sys.argv[1]))
except (OSError, ValueError):
    print("pending")
    sys.exit()
transcript = os.path.join(sys.argv[2], re.sub(r"[^A-Za-z0-9]", "-", job["cwd"]), job["sessionId"] + ".jsonl")
print("started" if os.path.exists(transcript) else "pending" if job.get("state") in (None, "working") else "settled")
EOF
}

wait_started() {
  local st
  for _ in $(seq 30); do
    st=$(status "$1")
    [[ $st != pending ]] && { echo "$st"; return; }
    sleep 2
  done
  echo hung
}

drop() {
  claude stop "$1" >/dev/null 2>&1 || true
  claude rm "$1" >/dev/null 2>&1 || true
}

# A slow CLI wrapper can bring a cold daemon's first spare up too late. The lane then either ends within seconds
# or hangs at "starting…", with no transcript either way. A hung lane keeps the daemon and its next spare warm,
# so one relaunch gets a ready spare; a lane that ended let the daemon exit, so the relaunch is cold again.
hung=() ids=()
for attempt in 1 2 3 4; do
  id=$(launch "$@")
  [[ -n $id ]] || { echo "could not read the lane id from claude --bg" >&2; exit 1; }
  ids+=("$id")
  case $(wait_started "$id") in
    started)
      for h in "${hung[@]}"; do
        if [[ $(status "$h") == started ]]; then
          echo "lane $h started late; $id is a duplicate of it, stop one" >&2
        else
          drop "$h"
        fi
      done
      echo "$id"
      exit 0
      ;;
    settled) drop "$id"; echo "lane $id ended before starting; relaunching" >&2 ;;
    hung)
      hung+=("$id")
      echo "lane $id hung at start; relaunching" >&2
      [[ ${#hung[@]} -ge 2 ]] && break
      ;;
  esac
done
echo "lane never started (ids: ${ids[*]}); stop and rm any still listed, then tell the user" >&2
exit 1
