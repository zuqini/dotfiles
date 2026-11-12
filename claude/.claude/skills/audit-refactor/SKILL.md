---
name: audit-refactor
description: "Audit a codebase (or one subsystem) for bugs, architecture problems and code smells, then refactor them away: loop audit → verify → fix → re-audit until a round finds nothing worth fixing. Use when asked to audit, clean up, harden or simplify a whole repo or directory rather than review one diff. Not for a PR or a diff: that is /code-review or /review-loop."
argument-hint: "<repo or path> [scope: dir or subsystem] [--max-rounds N] [--plan-only]"
---

You are the orchestrator of an audit → refactor loop on `$ARGUMENTS`. Auditors find, a fixer fixes, you route and verify. The goal is a codebase that is more correct and simpler: fewer lines, fewer concepts, fewer special cases. A change that adds machinery needs a stronger reason than one that removes it.

Everything the loop knows lives in files, so any turn (or a fresh session) can pick it up: read `<task>/audit/AUDIT.md` first and continue from the round it names. Never restart a round that the ledger says is finished.

## Setup (once)

1. **Target.** Resolve the argument to a repo under `~/projects/` and an optional scope (a directory or subsystem). No scope on a large repo: pick the subsystems yourself in step 5 and say which you left out.
2. **Task folder and worktree.** Follow `~/workspace/CLAUDE.md`: never touch `~/projects/<repo>`. If a task folder for this audit exists (`~/workspace/<repo>-audit*/TASK.md`), resume it. Otherwise make `~/workspace/<repo>-audit/` with a TASK.md (Status: repo, no issue, no PR; Goal: audit and refactor `<scope>`) and a worktree at `<task>/<repo>.tmp` on a new branch `<repo>-audit` cut from `origin/HEAD`. Record the starting commit as `<loop start>`.
3. **Repo rules.** Read the repo's `CLAUDE.md`, `AGENTS.md` and the docs they point at. Judge the code against its own conventions, not your preferences.
4. **Ledger.** Load prior decisions as `~/.claude/skills/review-loop/decisions-load.md` says (decision beads, or `.claude/review-decisions.md`). A decision is an accepted tradeoff: don't refile it without new evidence. Open beads are already-tracked work: note them, don't refile them.
5. **Model.** Write a short system model: what the code does, its public surface (APIs, CLI, config, file formats, anything a consumer depends on), the main data flows, where state lives, and a subsystem map with rough sizes. The public surface is frozen for the whole loop.
6. **Gates.** From the repo rules, README, `package.json`/Makefile and CI config, write the exact commands that must pass (build, typecheck, lint, format, tests). Run them on the untouched tree and record the baseline, including failures that already exist and the line count of the scope.
7. **Write `<task>/audit/AUDIT.md`**: target and scope, `<loop start>`, repo rules that matter (paths, not copies), the model, gates and baseline, the ledger listing, the severity bar and rules below, a **coverage map** (each subsystem: not examined / examined in round N), and an empty **findings table** (`id | round | location | grade | status | commit`). Every auditor and fixer reads it first.

## Severity bar

- **Critical**: wrong behaviour on a realistic path, data loss, security, a crash, a resource leak or race with real exposure.
- **Should-fix**: a bug on a narrower but plausible path; a mismatch between what docs or types promise and what the code does; duplicated sources of truth; an abstraction that makes a realistic change hard and can be removed or narrowed without losing behaviour; dead code; duplication that has already drifted.
- **Nit**: style, naming, preference, anything a formatter or linter would settle, a hypothetical with no realistic exposure. Not fixed.
- **Invalid**: not reproducible, correct given what callers guarantee, or a settled decision with no new evidence.
- **Deferred**: real, but the fix changes the public surface, needs a product or scope choice, or is a rewrite too large to verify in one round. Goes in the report for the user, not to the fixer.

## Each round N

Files go under `<task>/audit/r<N>/`.

1. **Pick the round's ground.** Round 1: the subsystems that matter most (most state, most callers, most churn in `git log`). Later rounds: subsystems not yet examined, plus everything the loop changed (`<loop start>..HEAD`) and what calls it. Update the coverage map.
2. **Audit.** Spawn read-only auditor subagents in parallel, one per subsystem (at most four a round), each briefed with AUDIT.md and its paths. Each looks for, in priority order: bugs (logic, unhandled errors, races, leaks, boundary and empty inputs, contract mismatches); architecture (tangled dependencies, leaky or wrong abstractions, state mutated from too many places, pass-through layers); smells (dead code, duplication, over-general code with one caller, functions doing several jobs, misleading names, checks for conditions that cannot occur). Auditor rules:
   - Every finding: `file:line`, one sentence, evidence, proposed fix with size and risk. Evidence for a bug is a concrete input or sequence that gives the wrong result; for a design problem, the specific cost it imposes.
   - Trace inputs upstream and callers downstream before reporting. Code that looks wrong in isolation may be right given its callers.
   - Before calling anything dead or redundant, find why it exists: `git log -S`, blame, the tests that pin it, its callers, consumers outside the repo. A guard with a test is a decision.
   - Say what was not examined.

   From round 2, add one auditor that reads only the loop's own commits and asks whether each change left the code simpler, whether it narrowed or broke existing behaviour, and whether any mechanism the loop added should exist at all. Save all findings verbatim to `findings.md`.
3. **`--plan-only`**: after round 1's audit, grade the findings yourself, write them to AUDIT.md with a proposed order of fixes, report and stop with the `STOPPED` line. Don't fix anything.
4. **Triage + fix.** Spawn one fixer subagent (sequential, never parallel fixers in one worktree). Brief: read AUDIT.md and `r<N>/findings.md`; for each finding write a verdict to `r<N>/triage.md` (`<id> | grade | evidence | action`), then fix the criticals and should-fixes, bugs first. Fixer rules:
   - Verify before grading: reproduce it, or trace the path; cite `file:line` and command output. Group findings that share a root cause and fix the cause.
   - A bug fix starts with a test that fails without it: revert the fix, see the test fail, restore.
   - A refactor preserves behaviour. If the code has no tests, write characterisation tests first and commit them separately. Never edit an existing test to make a refactor pass: a test that must change means behaviour changed, so regrade the finding as Deferred.
   - Removing a guard, fallback or check: find what contract it serves first. A test that pins it is evidence against the finding.
   - Smallest change that resolves the finding, in the repo's conventions. Prefer deleting or narrowing to adding. If the result isn't simpler than what it replaced, revert it and grade the finding Nit.
   - Fix the class, not the instance: grep the scope for the same pattern and fix those, noting them in triage.
   - Public surface stays as it is. A change that grows past its finding stops and becomes a new finding.
   - Run the gates. One commit per finding, bug fixes and refactors never mixed, in the repo's commit style. Never push or touch other branches.
   - Record each Invalid or Nit with a non-obvious, likely-to-recur reason as `~/.claude/skills/review-loop/decisions-record.md` says.
5. **Verify the fixer, don't trust it.** Re-run every gate yourself and compare with the baseline. Read the round's diff: each change maps to a triaged finding, nothing else, and no test was weakened. Spot-check one mutation (revert a fix, a test fails). Anything wrong goes back to the fixer as a correction.
6. **Update AUDIT.md**: findings table, coverage map, and a one-line round summary (findings by grade, net lines changed). Then decide:
   - zero critical/should-fix this round and every in-scope subsystem examined → final gate;
   - otherwise → round N+1.

## Stalls

Stop and report instead of starting another round when:

- `--max-rounds` (default 5) is reached;
- two rounds in a row, most should-fixes land on code the loop itself changed: the loop is polishing its own patches. Propose reverting that machinery rather than patching again;
- a round's fixes are all smells with no bug or architecture finding, twice in a row: the returns have run out;
- a finding flips a decision the loop already made, twice;
- the gates can't be made to pass, or a fix needs a choice that belongs to the user.

## Final gate

A clean round polishes the code; it doesn't prove it still works.

- All gates pass on the final tip, compared against the baseline.
- Exercise the real thing: run the app, CLI or main user journey, and the repo's e2e or benchmark checks if it has them, before and after (`<loop start>` vs `HEAD`).
- Diff the public surface against the model from setup: nothing changed that wasn't meant to.
- Anything found here is a finding: back to triage, then another round.

## Report

Then stop and report:

- A round table: findings by grade, fixed, rejected, deferred.
- The commits (`git log --oneline <loop start>..HEAD`) and the net line change.
- Deferred findings, each with the choice the user has to make.
- What was **not** examined (from the coverage map), and baseline gate failures that predate the loop.
- Decisions recorded.

The branch stays local: the PR gate in `~/workspace/CLAUDE.md` applies, so show the title and description and wait before pushing or opening anything.

End the report with exactly one line, so a `/goal` condition can match it: `AUDIT-REFACTOR DONE: clean after <N> rounds` or `AUDIT-REFACTOR STOPPED: <reason>`. Write that line nowhere else, and only when the loop has really ended.
