---
name: review
description: "Multi-angle per-change code review of a diff or specified path(s). Fans out bug-finder, structural-completeness-reviewer, and design-reviewer in parallel and merges their reports. Use after writing or staging changes; use /arch-review for system or module-scope architectural deep-dives."
---

Run a parallel multi-reviewer pass on a **change** and merge findings into a single report.

## Target selection

1. **Args provided** → review only those paths: `$ARGUMENTS` (multiple paths supported).
2. **No args** → review recent git changes, in priority order:
   1. Staged: `git diff --staged`
   2. Unstaged: `git diff HEAD`
   3. Last commit: `git diff HEAD~ HEAD`

   Use the first non-empty result. Capture the diff with Bash before spawning subagents.

## Load prior decisions

@~/.claude/skills/_shared/review-decisions-preamble.md

## Reviewers (run in parallel)

Spawn these subagents in a **single message** with parallel Agent tool calls. Each gets the same target, the decisions-file context above (if any), and an equivalent brief:

- **bug-finder** — logical errors, async pitfalls, null/undefined, off-by-ones, unhandled edge cases.
- **structural-completeness-reviewer** — change is fully integrated: dead code removed, all layers updated, no dev artifacts (TODOs, console.logs, commented blocks), dependencies/config consistent.
- **design-reviewer** — per-change design quality: boundary leaks, SRP/DIP violations introduced, feature envy, abstraction level, pattern consistency with adjacent code.

If the changes are clearly performance-sensitive (hot paths, rendering loops, startup, memory-bound work), also spawn:

- **performance-profiler** — main-thread blocking, leaks, inefficient rendering, slow startup.

## Merge step

After all reviewers return, produce one consolidated report:

```
## Critical
- [reviewer] [file:line] — issue

## Should fix
- [reviewer] [file:line] — issue

## Nitpicks
- [reviewer] [file:line] — suggestion
```

Tag each finding with the reviewer it came from. Deduplicate when two reviewers raise the same point — keep the more specific phrasing and note both reviewers flagged it.

If any reviewer returned a `Decision to revisit` item, surface it as its own section above the findings so the user can decide whether to update `.claude/review-decisions.md`.

## Capturing decisions

@~/.claude/skills/_shared/review-decisions-capture.md

## Scope

This skill is for **per-change** review. For module or project-scope architectural analysis (deep SOLID/SoC/coupling work, multi-module audits), use `/arch-review`.
