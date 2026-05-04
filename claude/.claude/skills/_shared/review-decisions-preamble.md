Before spawning subagents, check for `.claude/review-decisions.md` in the project root. If present, read it in full and include its contents verbatim in each subagent's brief, prefixed with:

> **Previously-resolved tradeoffs.** Don't re-flag entries unless context has materially shifted.
>
> Entries under `## Recurring false flags` are high-recurrence — if your finding matches one, your write-up **must** explain why the pinned rationale doesn't apply to this specific instance. A bare restatement of the pattern is insufficient.
>
> If you believe an entry is now wrong, raise it as a `Decision to revisit` item in your report (not a normal finding) and cite the entry title.

If the file is absent, proceed without it. Do not create it preemptively.
