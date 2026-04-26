---
name: arch-review
description: "System / module-scope architectural review. Defaults to the whole project; pass paths to scope to specific modules or workers. Heavy-duty pass on layering, SOLID, scalability, and maintainability. For per-change/per-diff design review, use /review instead."
---

Run a thorough **system or module-scope** architectural review using the **architecture-reviewer** subagent. This is the heavyweight pass — read structure, form a mental map, evaluate the four pillars. For per-change design feedback, route to `/review`.

## Target selection

1. **No args** → review the **whole project** (target: `.`). Spawn `architecture-reviewer` against the project root.

2. **Args provided** → review exactly those paths. Paths are **space-separated** in `$ARGUMENTS`; multiple paths are supported and encouraged when the review target spans several locations. The subagent should map all of them together as one logical unit, including inter-path coupling and pattern divergence across them.

   ```
   /arch-review src/workers/ingest src/workers/dispatch src/shared/queue
   ```

## Subagent brief

Spawn `architecture-reviewer` with:
- The target list (project root `.`, or the paths from `$ARGUMENTS`)
- When multiple paths are passed: an explicit instruction to treat them as one connected target — evaluate inter-path coupling and pattern divergence across them
- Reminder that the report should evaluate against **Separation of Concerns, SOLID, Scalability, and Maintainability**, with file paths and line numbers as evidence
- Final report format: Executive Summary, Strengths, Critical Risks, Areas for Improvement

## When to use this vs `/review`

- Use **`/arch-review`** when: evaluating the design of a whole project or a module/subsystem; auditing several related workers or services together; doing a quarterly health check; deciding whether to refactor a subsystem.
- Use **`/review`** when: you just wrote or staged a change and want bug, completeness, and design feedback on the diff itself.
