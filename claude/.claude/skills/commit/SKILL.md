---
name: commit
description: "Create a single git commit from current staged + unstaged changes, following the repo's commit message style."
---

Create a single git commit covering the current changes.

## Steps

1. Gather context in parallel via Bash:
   - `git status`
   - `git diff HEAD` (staged + unstaged)
   - `git branch --show-current`
   - `git log --oneline -10` (to match commit message style)

2. Stage and commit in a single message with parallel tool calls. Do not output explanatory prose between tool calls.

## Rules

- One commit covering all current changes — do not split.
- Follow the message style observed in `git log` output.
- Never amend, never force, never skip hooks.
- Pass the message via HEREDOC for clean formatting.
