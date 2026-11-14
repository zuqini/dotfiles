#!/bin/bash

# Read JSON input
input=$(cat)

# Get current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
session_id=$(echo "$input" | jq -r '.session_id // empty')

# Messaging address as ListAgents prints it: "<name> [<ref>]".
# The ref is the first 6 hex chars of sha256("session:<messaging socket path>").
session_name=""
session_ref=""
if [ -n "$session_id" ]; then
  IFS=$'\t' read -r session_name session_sock < <(jq -r --arg id "$session_id" 'select(.sessionId == $id) | [.name // "", .messagingSocketPath // ""] | @tsv' ~/.claude/sessions/*.json 2>/dev/null | head -n1)
  if [ -n "$session_sock" ]; then
    session_ref=$(printf 'session:%s' "$session_sock" | shasum -a 256 | cut -c1-6)
  fi
fi
session_title=$(echo "$input" | jq -r '.session_name // empty')
if [ -z "$session_name" ]; then
  session_name=$session_title
fi

# Replace home directory with ~ (dynamically)
dir_display="${cwd/#$HOME/~}"

# Check for virtual environment
virtenv=""
if [ -n "$VIRTUAL_ENV" ]; then
  venv_name=$(basename "$VIRTUAL_ENV")
  virtenv=$(printf "\033[1;35m(%s)\033[0m " "$venv_name")
fi

# Get git branch (skip optional locks for performance)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fileMode=false symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" -c core.fileMode=false rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_branch=$(printf "\033[1;33m%s\033[0m " "$branch")
  fi
fi

session=""
if [ -n "$session_name" ]; then
  session=$(printf "\033[34m%s%s\033[0m" "$session_name" "${session_ref:+ [$session_ref]}")
fi

title_line=""
if [ -n "$session_title" ] && [ "$session_title" != "$session_name" ]; then
  title_line=$(printf "\n\033[3;38;5;67m%s\033[0m" "$session_title")
fi

# Line 1: cyan directory, virtualenv, git branch, blue messaging address. Line 2: muted blue italic session title.
printf "\033[36m%s\033[0m %s%s%s%s" "$dir_display" "$virtenv" "$git_branch" "$session" "$title_line"
