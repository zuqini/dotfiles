# Agent Instructions

See @~/.claude/work.md if it exists.

If the current working directory is `~/workspace/` or a subfolder of it, also load the workspace-local `CLAUDE.md` / `work.md` — that's where my multi-tasking workflow (task folders, TASK.md specs, worktrees, PR tracking) is defined. I drive end-to-end work from there.

## ast-grep

You run in an environment where ast-grep is available; whenever a search requires syntax-aware or structural matching, default to ast-grep --lang rust -p '<pattern>' (or set --lang appropriately) and avoid falling back to text-only tools like rg or grep unless I explicitly request a plain-text search.

## **Important**

When coding, ***DO NOT*** add comments unless the logic is non-obvious. Code should be self-documenting.

When pushing to version control, never force push.

## Code review

Before filing review findings, read `.claude/review-decisions.md` if it exists in the project root — accepted tradeoffs documented there should not be re-flagged.
