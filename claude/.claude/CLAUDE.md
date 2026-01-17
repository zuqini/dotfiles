# Agent Instructions

See @~/.claude/work.md if it exists.

## beads

Use `bd` for issue tracking. If `bd` is not initialized or reports `no beads database found`, prompt the user for initialization. Do **not** initialize it yourself.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with git
```

## ast-grep

You run in an environment where ast-grep is available; whenever a search requires syntax-aware or structural matching, default to ast-grep --lang rust -p '<pattern>' (or set --lang appropriately) and avoid falling back to text-only tools like rg or grep unless I explicitly request a plain-text search.

## **Important**

When coding, ***DO NOT*** add comments unless the logic is non-obvious. Code should be self-documenting.

When pushing to version control, never force push.
