#!/bin/bash

# Read JSON input
input=$(cat)

# Get current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

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

# Print the status line (cyan directory, virtualenv, git branch)
printf "\033[36m%s\033[0m %s%s" "$dir_display" "$virtenv" "$git_branch"
