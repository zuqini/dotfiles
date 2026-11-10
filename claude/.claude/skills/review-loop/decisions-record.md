When a review finding is kept as-is with a stated reason — whether the user said so directly or you concluded it during triage — record it if the rationale is non-obvious from the code *and* the pattern is likely to recur on future passes. You judge importance: capture autonomously and surface a one-line note. Skip findings that get fixed (the commit carries the why) and casual dismissals with no rationale.

Record as a `decision` bead when beads is set up (`bd where` exits 0); otherwise in `.claude/review-decisions.md`. Never run `bd init` just to capture a decision.

### Minimal entry

Search for an existing entry first (`bd search`, or grep the file) and extend it instead of duplicating.

```
bd create --type decision "<title — what gets flagged>" \
  -d "Flagged: <pattern reviewers tend to raise>
Decision: <what we actually want, and why>"
```

File equivalent: a `## <title>` section with `- Flagged:` and `- Decision:` bullets. When creating the file, head it with a one-line purpose statement and seed `## Recurring false flags` and `## Decisions` sections.

Don't add fields you don't need. For decisions resolved across multiple swings, the `Decision:` body can be a numbered chain — the chain itself is the evidence.

### Extended fields (add only when they apply)

- **Anchor** `<file:line>` — the decision is about a specific call site, not a class of code.
- **Filed** — tracked elsewhere; reviewers should not refile. Bead: `--external-ref`. File: `- Filed:` bullet.
- **History** — resolves a known oscillation; list prior swings oldest first. Bead: `bd note <id>`. File: `- History:` bullet.
- **Revisit when** `<condition>` — surface as a finding only once the condition is true.
- **Enforced** — a guard (lint, type, test) backs the decision; fix violations in place rather than file findings. Bead: label `enforced`. File: `- Type: enforced`.

### Maintenance

- Mark recurrence once a decision is raised on separate passes by different reviewers/agents (bead: label `recurring-false-flag`; file: move under `## Recurring false flags`). Single-agent re-flags within one session are memory loss, not recurrence.
- When a `Revisit when:` condition fires, promote the entry into live work instead of leaving it parked.
- Retire the entry (`bd close`, or delete the section) when the code surface it describes no longer exists.
