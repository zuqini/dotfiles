---
name: orchestrate
description: "Run a multi-agent pipeline. Pass a pipeline expression using Unix-pipe syntax — sequential with `|`, parallel with `(A, B)`, conditional with `if/then/else`. Hands the expression and the task to the orchestrator subagent."
---

Spawn the **orchestrator** subagent to execute a multi-stage agent pipeline.

## Invocation

```
/orchestrate <pipeline expression> -- <task description>
```

The arguments are split on the first `--`:
- Left of `--`: the pipeline expression
- Right of `--`: the task description (passed to the first agent in the pipeline)

### Help mode

If `$ARGUMENTS` is empty or starts with `help`, **do not spawn the orchestrator**. Print the syntax cheat sheet (the "Pipeline syntax", "Examples", and "Available agents" sections of this skill) directly to the user as the response, then stop. This makes `/orchestrate` (no args) a self-documenting cheat sheet and `/orchestrate help` an explicit help request.

### Missing task description

If `$ARGUMENTS` is non-empty, is not `help`, and contains no `--`, treat the whole input as a pipeline expression and ask the user for the task description before spawning the orchestrator.

## Pipeline syntax

- **Sequential**: `A | B | C` — run A, hand off to B, hand off to C
- **Parallel**: `(A, B, C)` — run all in parallel, merge output
- **Conditional**: `if <cond> then X else Y` (`Y` may be `done`)

Combine freely:
```
investigation | implementer | (bug-finder, design-reviewer) | (if findings > 0 then implementer | auditor else done)
```

## Examples

```
/orchestrate investigation | implementer | auditor -- add rate limiting to /api/login, 5/min/IP
```

```
/orchestrate investigation | implementer | (bug-finder, design-reviewer, structural-completeness-reviewer) | auditor -- extract email-sending out of UserService into EmailService
```

```
/orchestrate legacy-characterizer | refactorer | implementer | auditor -- split BillingProcessor into focused classes
```

```
/orchestrate investigation | (if has_steps then implementer | auditor else done) -- determine whether the legacy webhook signing path is still used; remove it if not
```

## Available agents

- `investigation`, `implementer`, `auditor`
- `legacy-characterizer`, `refactorer`
- `bug-finder`, `structural-completeness-reviewer`, `design-reviewer`
- `architecture-reviewer`, `performance-profiler`

## What this skill does

1. Parse `$ARGUMENTS` into pipeline expression + task description (split on first `--`).
2. Spawn the `orchestrator` subagent with both.
3. The orchestrator parses the pipeline, executes each stage, manages artifact handoffs, and writes `./pipeline-status.md` for traceability.
4. Surface the final report from the orchestrator back to the user.
