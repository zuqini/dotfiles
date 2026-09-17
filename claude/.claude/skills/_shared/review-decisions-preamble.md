Before spawning subagents, load prior decisions. Check whether beads is set up for the project by running `bd where` — exit 0 means it is.

**If beads is set up**, active beads are the source of truth. Run:

```
bd list --flat --long --no-pager
```

Include the output verbatim in each subagent's brief, prefixed with:

> **Active beads.** Beads of type `decision` are previously-resolved tradeoffs — don't re-flag them unless context has materially shifted. Other open beads are already-tracked work — don't refile them as findings; cite the bead ID if your finding relates to one.
>
> Beads labelled `recurring-false-flag` are high-recurrence — if your finding matches one, your write-up **must** explain why the pinned rationale doesn't apply to this specific instance. A bare restatement of the pattern is insufficient.
>
> If you believe a decision bead is now wrong, raise it as a `Decision to revisit` item in your report (not a normal finding) and cite the bead ID.

**If beads is not set up**, check for `.claude/review-decisions.md` in the project root. If present, read it in full and include its contents verbatim in each subagent's brief, prefixed with:

> **Previously-resolved tradeoffs.** Don't re-flag entries unless context has materially shifted.
>
> Entries under `## Recurring false flags` are high-recurrence — if your finding matches one, your write-up **must** explain why the pinned rationale doesn't apply to this specific instance. A bare restatement of the pattern is insufficient.
>
> If you believe an entry is now wrong, raise it as a `Decision to revisit` item in your report (not a normal finding) and cite the entry title.

If neither exists, proceed without prior decisions. Do not run `bd init` or create the file preemptively.
