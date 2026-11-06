#!/usr/bin/env bash
# Session control for the coordinator, so one allowlisted path covers every
# `claude` call lanes need when the shell can't run `claude` directly.
set -euo pipefail

usage() {
  echo "usage: lane-ctl.sh agents [--cwd <dir>] | stop|rm|logs <id>" >&2
  exit 2
}

[[ $# -ge 1 ]] || usage
case $1 in
  agents) shift; exec claude agents --json --all "$@" ;;
  stop | rm | logs)
    [[ $# -eq 2 && $2 =~ ^[A-Za-z0-9-]+$ ]] || usage
    exec claude "$1" "$2"
    ;;
  *) usage ;;
esac
