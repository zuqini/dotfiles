#!/usr/bin/env python3
"""Print one line per lane event, for the Monitor tool.

usage: watch-lanes.py <task-dir> [interval-seconds]

Watches two sources: new `## ` entries in <task-dir>/lanes/*/LOG.md (lanes
write one before every signal) and session state from `claude agents --json
--all` for sessions named <slug>-*. If the CLI can't run (a sandboxed shell),
it says so once and keeps watching the logs. The last state is saved in
<task-dir>/lanes/.watch-state.json, so a re-armed watcher prints only changes.
"""
import glob
import json
import os
import subprocess
import sys
import time


def headings(task_dir):
    out = {}
    for path in glob.glob(os.path.join(task_dir, "lanes", "*", "LOG.md")):
        with open(path, errors="replace") as f:
            out[os.path.basename(os.path.dirname(path))] = [l.rstrip() for l in f if l.startswith("## ")]
    return out


def sessions(prefix):
    try:
        proc = subprocess.run(["claude", "agents", "--json", "--all"], capture_output=True, text=True, timeout=60)
    except (OSError, subprocess.SubprocessError) as e:
        return None, str(e)
    try:
        rows = json.loads(proc.stdout)
    except ValueError:
        return None, proc.stderr.strip() or f"exit {proc.returncode}"
    states = {}
    for a in rows:
        name = a.get("name") or ""
        if name.startswith(prefix):
            state = f'{a.get("status")}/{a.get("state")}'
            if a.get("waitingFor"):
                state += f' ({a["waitingFor"]})'
            states[str(a.get("id") or a.get("sessionId"))] = f"{name} {state}"
    return states, None


def main():
    task_dir = os.path.abspath(os.path.expanduser(sys.argv[1]))
    interval = int(sys.argv[2]) if len(sys.argv) > 2 else 60
    prefix = os.path.basename(task_dir) + "-"
    state_path = os.path.join(task_dir, "lanes", ".watch-state.json")
    try:
        with open(state_path) as f:
            saved = json.load(f)
    except (OSError, ValueError):
        saved = {}
    seen_logs, seen_sessions = saved.get("logs", {}), saved.get("sessions")
    cli_down = False
    while True:
        for lane, entries in sorted(headings(task_dir).items()):
            for entry in entries[len(seen_logs.get(lane, [])):]:
                print(f"[{lane}] {entry[3:]}", flush=True)
            seen_logs[lane] = entries
        cur, err = sessions(prefix)
        if cur is None:
            if not cli_down:
                print(f"claude agents unavailable ({err[:200]}); watching LOG.md only", flush=True)
            cli_down = True
        else:
            cli_down = False
            prev = seen_sessions or {}
            for sid in sorted(prev.keys() | cur.keys()):
                before, after = prev.get(sid), cur.get(sid)
                if before != after and not (after or "").split(" ", 1)[-1].startswith("busy"):
                    print(f"{sid}: {before or 'new'} -> {after or 'gone'}", flush=True)
            seen_sessions = cur
        tmp = state_path + ".tmp"
        with open(tmp, "w") as f:
            json.dump({"logs": seen_logs, "sessions": seen_sessions}, f)
        os.replace(tmp, state_path)
        time.sleep(interval)


if __name__ == "__main__":
    main()
