---
name: arch-review
description: "System / module-scope architectural review. Pass one or more paths (project root, a module, a set of worker scripts, etc.) for a deep-dive on layering, SOLID, scalability, and maintainability. For per-change/per-diff design review, use /review instead."
---

Run a thorough **system or module-scope** architectural review using the **architecture-reviewer** subagent. This is the heavyweight pass — read structure, form a mental map, evaluate the four pillars. For per-change design feedback, route to `/review`.

## Target selection

1. **Args provided** → review exactly those paths. **Multiple paths are supported and encouraged** when the review target spans several locations (e.g. `src/workers/foo src/workers/bar src/shared`). Each path in `$ARGUMENTS` is a separate target the subagent should map and evaluate together as one logical unit.

2. **No args** → review recent git changes, in priority order:
   1. Staged: `git diff --staged`
   2. Unstaged: `git diff HEAD`
   3. Last commit: `git diff HEAD~ HEAD`

   Use the first non-empty result. Run those Bash commands yourself, then pass the diff plus a one-line note of which priority you used.

## Subagent brief

Spawn `architecture-reviewer` with:
- The target list (paths or diff content)
- When multiple paths are passed: an explicit instruction to treat them as one connected target — map them together, evaluate inter-path coupling, look for shared concerns and divergent patterns across them
- Reminder that the report should evaluate against **Separation of Concerns, SOLID, Scalability, and Maintainability**, with file paths and line numbers as evidence
- Final report format: Executive Summary, Strengths, Critical Risks, Areas for Improvement

## When to use this vs `/review`

- Use **`/arch-review`** when: evaluating the design of a whole project or a module/subsystem; auditing several related workers or services together; doing a quarterly health check; deciding whether to refactor a subsystem.
- Use **`/review`** when: you just wrote or staged a change and want bug, completeness, and design feedback on the diff itself.
