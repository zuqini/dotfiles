When a review finding is kept as-is with a stated reason — whether the user said so directly or you concluded it during triage — record it if the rationale is non-obvious from the code *and* the pattern is likely to recur on future passes. You judge importance: capture autonomously and surface a one-line note (e.g. *"Recorded as `<title>` in `.claude/review-decisions.md`."*). Skip findings that get fixed (the commit carries the why) and casual dismissals with no rationale. Create the file (and the `.claude/` directory) if it does not exist.

### On first creation

When creating the file for the first time, write this self-documenting header and seed the two sections:

```
# Review decisions

Accepted tradeoffs reviewers should not re-flag. Before adding an entry, search for an existing one and append to its `History:` instead.

Schema: `title` / `Flagged` / `Decision` (required); `Type` / `Anchor` / `Filed` / `History` / `Revisit when` (optional). Full lifecycle in `~/.claude/skills/review/SKILL.md`.

## Recurring false flags
<entries reviewers keep raising; pinned so they're seen first>

## Decisions
<everything else>
```

### Minimal entry

Most entries should look like this:

```
## <title — what gets flagged>
- Flagged: <pattern reviewers tend to raise>
- Decision: <what we actually want, and why>
```

That's it. Don't add fields you don't need. For decisions resolved across multiple swings, the `Decision:` body can be a paragraph or numbered chain — terseness is for one-shot skips, not narratives where the chain itself is the evidence.

### Extended fields (add only when they apply)

```
- Type: enforced
- Anchor: <file:line, or list of file:lines>
- Filed: <issue/ticket URL or ID>
- History: <prior swings, oldest first>
- Revisit when: <condition that would flip the decision>
```

When to add each:
- **Anchor** — the decision is about a specific call site, not a class of code. Without it, reviewers can't tell if their finding is the same instance.
- **Filed** — the entry is tracked at the linked URL/ID; reviewers should not refile. Without a concrete pointer the entry is unverifiable.
- **History** — the entry resolves a known oscillation. The chain is the evidence.
- **Revisit when** — the decision is contingent on a condition (scale threshold, second consumer appears, etc.); surface as a finding only when the condition has become true.
- **Type** — set to `enforced` when a guard (lint, type, test) backs the decision; if a violation appears anyway, fix in place rather than file a finding. Otherwise omit.

### Maintenance rules

- Update existing entries in place — append to `History:` — rather than adding duplicates.
- Move an entry into `## Recurring false flags` once it has been raised on separate passes by different reviewers/agents. Single-agent re-flags within one session don't count — that's memory loss, not recurrence.
- When a `Revisit when:` condition fires, promote the entry: refile (move the pointer into `Filed:`) or open a live discussion. Don't leave it parked past its trigger.
- If your project tracks decisions in another system (`bd remember`, Linear, etc.), mirror the entry title there so it survives reviewers who skip the file.
- Delete entries when the code surface they describe no longer exists. Don't keep them as a museum.
