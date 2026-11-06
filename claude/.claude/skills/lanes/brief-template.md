# <slug> / <lane>: brief

Every session of this lane reads this first. The coordinator owns this file; the lane never edits it.

## Lane

- Name: `<slug>-<lane>`. Coordinator: `<coordinator session name> [<ref>]` (updated here whenever the coordinator changes).
- Untrusted input: <no | yes: what, and the sandbox settings that apply>
- Worktree: `~/workspace/<slug>/<repo>.<lane>.tmp`, branch `<slug>-<lane>`, based on `<slug>` at `<sha>`. Work only here; never in `~/projects/<repo>`.
- Log: `~/workspace/<slug>/lanes/<lane>/LOG.md`. Task spec, for context only: `~/workspace/<slug>/TASK.md`.

## Goal

<One paragraph: what is true when this lane is done.>

## Owns

- Changes: <paths, modules>
- Doesn't touch: <paths other lanes own; shared interfaces frozen at <sha>>

## Setup and tools

Run once in a fresh worktree; a worktree has no gitignored files or installed dependencies:

- `<install / build / env copy commands>`

Build and test with `<commands>`. Use <skills, subagents, docs and data sources that apply>; don't use <tools or sources that are off limits>.

## Conventions

Fixed for every lane of this task; change only through the coordinator:

- <error handling, naming, dependencies, shared interfaces at <sha>>

## Milestones

In order, one at a time. Signal MILESTONE after each and keep going, except after one marked `(wait)`.

1. <milestone>: done when `accept.sh 1` passes

## Acceptance checks

`~/workspace/<slug>/lanes/<lane>/accept.sh [N]` (coordinator-owned). It runs the checks for milestones 1..N, all of them without N, prints one `PASS`/`FAIL m<k>: <check>` line each, and exits 0 only when every one passes. The lane runs it at session start and before MILESTONE or DONE; the coordinator runs the same script to verify. Checks:

- m1: `<command>` → <expected>

## Budget

Log BLOCKED and stop when any is hit: <N> review rounds on one milestone, <H> hours without a MILESTONE, the same check failing <K> times for the same reason.

## Ledger

- Decisions and recurring false flags: <`bd list --flat --long --no-pager`, or `~/workspace/<slug>/DECISIONS.md`>. Don't re-raise a settled one without evidence that meets its revisit clause.
- Already tried or reverted, don't redo: <commits, dropped approaches, where they're written up>

## Lessons that apply

<Concrete rules from TASK.md, memory and earlier lanes, e.g. "kill only processes you started, by PID".>

## Bar

<What counts as a real finding or a done result here, and what to ignore.>

## Out of bounds

Never push, open/merge/close PRs, comment on GitHub, delete branches or worktrees, start or stop Claude sessions, or message other lanes. Ask the coordinator.
