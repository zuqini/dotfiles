# Agent Instructions

See @~/.claude/work.md if it exists.

If the current working directory is `~/workspace/` or a subfolder of it, also load the workspace-local `CLAUDE.md` / `work.md` — that's where my multi-tasking workflow (task folders, TASK.md specs, worktrees, PR tracking) is defined. I drive end-to-end work from there.

## ast-grep

You run in an environment where ast-grep is available; whenever a search requires syntax-aware or structural matching, default to ast-grep --lang rust -p '<pattern>' (or set --lang appropriately) and avoid falling back to text-only tools like rg or grep unless I explicitly request a plain-text search.

## **Important**

When coding, ***DO NOT*** add comments unless the logic is non-obvious. Code should be self-documenting.

When pushing to version control, never force push.

## Code review

Before filing review findings, check whether beads is set up (`bd where` exits 0). If so, consider the active beads (`bd list --flat --long --no-pager`) — `decision` beads are accepted tradeoffs that should not be re-flagged, and other open beads are already-tracked work that should not be refiled. If beads is not set up, read `.claude/review-decisions.md` if it exists in the project root instead.
