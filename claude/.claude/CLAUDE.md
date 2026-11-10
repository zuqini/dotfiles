# Agent Instructions

See @~/.claude/work.md if it exists.

- Don't add code comments unless the logic is non-obvious; code should be self-documenting.
- Never force push.
- ast-grep is installed; use it for syntax-aware or structural searches.

## Code review

Before filing review findings, check whether beads is set up (`bd where` exits 0). If so, consider the active beads (`bd list --flat --long --no-pager`) — `decision` beads are accepted tradeoffs that should not be re-flagged, and other open beads are already-tracked work that should not be refiled. If beads is not set up, read `.claude/review-decisions.md` if it exists in the project root instead.
