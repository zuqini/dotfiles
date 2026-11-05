#!/usr/bin/env python3
"""Print one line per lane state change, for the Monitor tool.

usage: watch-lanes.py <lane-name-prefix> [interval-seconds]
"""
import json
import subprocess
import sys
import time


def snapshot(prefix):
    try:
        out = subprocess.run(
            ["claude", "agents", "--json"],
            capture_output=True, text=True, timeout=60,
        ).stdout
        rows = json.loads(out)
    except (subprocess.SubprocessError, ValueError):
        return None
    return {
        a["name"]: f'{a.get("status")}/{a.get("state")}'
        for a in rows
        if (a.get("name") or "").startswith(prefix)
    }


def main():
    prefix = sys.argv[1]
    interval = int(sys.argv[2]) if len(sys.argv) > 2 else 60
    prev = None
    while True:
        cur = snapshot(prefix)
        if cur is not None:
            if prev is None:
                for name, state in sorted(cur.items()):
                    print(f"{name}: {state}", flush=True)
            else:
                for name in sorted(prev.keys() | cur.keys()):
                    before, after = prev.get(name, "new"), cur.get(name, "gone")
                    if before != after and not after.startswith("busy"):
                        print(f"{name}: {before} -> {after}", flush=True)
            prev = cur
        time.sleep(interval)


if __name__ == "__main__":
    main()
