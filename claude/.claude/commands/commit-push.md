---
description: Commit staged changes and push to remote
allowed-tools: Bash(git*:*)
---

# Commit and Push

## Current State

- **Branch**: !`git branch --show-current`
- **Upstream status**: !`git status -sb | head -1`
- **Staged changes**: !`git diff --cached --stat 2>/dev/null || echo 'None'`
- **Unstaged changes**: !`git diff --stat 2>/dev/null || echo 'None'`
- **Untracked files**: !`git ls-files --others --exclude-standard | head -10`
- **Recent commits**: !`git log --oneline -5 2>/dev/null`

## Instructions

1. Review the staged changes above. If nothing is staged, stage appropriate files first.
2. Create a concise commit message (present tense, <50 char first line).
3. Push to remote on the current branch.
