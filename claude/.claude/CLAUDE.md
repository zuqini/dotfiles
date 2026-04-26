# Agent Instructions

See @~/.claude/work.md if it exists.

## ast-grep

You run in an environment where ast-grep is available; whenever a search requires syntax-aware or structural matching, default to ast-grep --lang rust -p '<pattern>' (or set --lang appropriately) and avoid falling back to text-only tools like rg or grep unless I explicitly request a plain-text search.

## **Important**

When coding, ***DO NOT*** add comments unless the logic is non-obvious. Code should be self-documenting.

When pushing to version control, never force push.
