---
name: review-loop
description: "Drive a GitHub PR to a clean review: loop /code-review xhigh → fixer triage → commit → re-review until a round has no critical or should-fix findings. Use when given a PR URL and asked to review and fix it repeatedly, or to run a review/fix loop. Not for a one-off review: that is a report and fixes nothing."
argument-hint: "<PR URL or number> [--max-rounds N]"
---

You are the orchestrator of a review → fix loop on `$ARGUMENTS`. You route work and verify it; reviewers find, fixers fix. Keep your own context for routing: findings, verdicts and briefs live in files.

## Setup (once)

1. **PR facts.** `gh pr view <pr> --json url,number,title,body,baseRefName,headRefName,headRefOid,isCrossRepository,headRepositoryOwner`. Record them in the loop folder's `BRIEF.md` (below).
2. **Worktree.** Follow `~/workspace/CLAUDE.md`: never touch `~/projects/<repo>`.
   - If a task folder already tracks this PR (`grep -l <PR url> ~/workspace/*/TASK.md`), use it. If `git -C ~/projects/<repo> worktree list` shows the head branch checked out, work in that worktree.
   - Otherwise make `~/workspace/<repo>-pr<N>/` with a TASK.md (Status: repo, PR URL; Goal: drive PR to a clean review) and `git -C ~/projects/<repo> fetch origin <headRefName>`, then `git -C ~/projects/<repo> worktree add ~/workspace/<repo>-pr<N>/<repo>.tmp -b <headRefName> --track origin/<headRefName>`. Cross-repo (fork) PR: fetch `pull/<N>/head` into a local branch instead, and note you can't push to it.
   - The worktree must be clean and its tip equal to `headRefOid` or ahead of it. Report anything else before starting.
3. **Repo rules.** Read the repo's `CLAUDE.md`, `AGENTS.md` and any docs they point at for conventions, test policy and required gates. These are rules for the fixer and grading criteria for findings, not background.
4. **Ledger.** Load prior decisions as `~/.claude/skills/_shared/review-decisions-preamble.md` says (decision beads, or `.claude/review-decisions.md`). List the decision beads anchored on files the PR deletes or rewrites: each is a behaviour the new code must keep or consciously drop, and goes in the brief as a parity checklist item.
5. **Gates.** From the repo rules, README, `package.json`/Makefile and CI config, write the exact commands that must pass (build, typecheck, lint, format, tests, coverage thresholds, e2e, visual checks for UI changes). Run them once on the untouched PR so you know the baseline: a gate that already fails isn't the loop's regression, but say so in the final report.
6. **Write `<task>/review-loop/BRIEF.md`**: PR facts, base ref, repo rules that matter (paths, not copies), gates, the ledger listing, the parity checklist, the severity bar below, and the lessons section below. Every reviewer and fixer you spawn reads it first.

## Severity bar

The fixer grades every finding into exactly one of:

- **Critical**: wrong behaviour on a realistic path, data loss, security, a crash, a broken build or CI gate, a regression against the base branch.
- **Should-fix**: a real bug on a narrower but plausible path; a broken repo rule from CLAUDE.md; changed behaviour with no test that would catch its breakage; complexity the PR or the loop added that can go without losing behaviour.
- **Nit**: style, naming, preference, or a hypothetical with no realistic exposure. Not fixed. If exposure is nil, at most document it; don't build for it.
- **Invalid**: not reproducible, contradicts the PR's stated intent or the task spec, or matches a settled decision with no new evidence.

## Each round N

Files go under `<task>/review-loop/r<N>/`.

1. **Review the local tip.** `/code-review <PR url>` reads the PR's head on GitHub, so it misses the loop's unpushed commits. From the worktree, `git fetch origin <baseRefName>`, then invoke the `code-review` skill with args `xhigh origin/<baseRefName>...<headRefName>`: a three-dot range is diffed from the merge base, so a stacked PR's base is respected and local commits are included. In a terminal session the review runs as a background subagent and its findings arrive later as a message: end your turn and wait, don't poll. Save the findings verbatim to `findings.md`. If the Skill tool can't run `code-review`, run `claude -p "/code-review xhigh <range>" > r<N>/findings.md` from the worktree instead.
2. **From round 2, one extra reviewer** (fresh subagent, reads BRIEF.md): look only at the loop's own commits (`<loop start>..HEAD`) and ask whether each mechanism should exist at all, whether it narrows or contradicts the PR's intent, and what feeds the changed functions upstream (callers, configs, data shapes) that the diff-anchored review can't see. Append its findings to `findings.md`.
3. **Triage + fix.** Spawn one fixer subagent (sequential, never parallel fixers in one worktree). Brief: read BRIEF.md and `r<N>/findings.md`; for each finding, write a verdict to `r<N>/triage.md` (`<id> | grade | evidence | action`), then fix the criticals and should-fixes. Fixer rules:
   - Verify before grading: reproduce it, or trace the code path; cite file:line and command output.
   - Check the ledger and history first (`git log -S`, decision beads, reverts). Reversing an earlier decision needs new evidence, not a new reviewer's opinion.
   - A finding that removes a guard, fallback or check: find out why it was added and what external contract it serves before removing it. A test that pins the guard is evidence against the finding; never rewrite it to match the removal.
   - Smallest fix that resolves the finding, in the repo's conventions. Prefer deleting or narrowing code to adding machinery. No refactors the finding doesn't need.
   - Every fixed bug gets a test that fails without the fix: revert the fix, see the test fail, restore. Respect the repo's test policy (mock boundaries, placement).
   - Fix the class, not the instance: grep for the same pattern elsewhere in the PR's diff and fix those too, noting them in triage.
   - Run the gates. One commit per finding, in the repo's commit style, on the branch. Never push, comment on GitHub or touch other branches.
   - Record each Invalid or Nit with a non-obvious, likely-to-recur reason as the ledger says (`~/.claude/skills/_shared/review-decisions-capture.md`), so later rounds don't refile it.
4. **Verify the fixer, don't trust it.** Re-run every gate yourself. Read the round's diff: each change maps to a triaged finding, nothing else. Spot-check one mutation (revert a fix, a test fails). For UI changes, do the repo's visual check. Anything wrong goes back to the fixer as a correction.
5. **Decide.**
   - Zero critical/should-fix in triage → run the final gate.
   - Otherwise → round N+1.

## Stalls

Stop and report to the user instead of starting another round when:

- `--max-rounds` (default 6) is reached;
- two rounds in a row, most should-fixes land on code the loop itself added: the loop is polishing its own patches. Propose removing that machinery (back to the pushed behaviour plus a documented caveat) rather than patching again;
- a finding flips a decision the loop already made, twice;
- a fix needs a choice that belongs to the user (scope, product behaviour, anything irreversible).

At round 3 with real findings still coming, step back before continuing: are they one bug class? Sweep the class across the diff. Is the PR's scope the problem? Say so.

## Final gate

A clean round polishes the diff; it doesn't prove the change works. Before calling the PR done:

- All gates pass on the final tip, compared against the baseline from setup.
- Exercise the changed behaviour for real: run the app, CLI or main user journey the PR touches, and the repo's e2e/visual checks if it has them.
- Each parity checklist item from setup is checked against the final code.
- Anything found here is a finding: back to triage, then another review round.

## Report

Then stop and report:

- A round table: findings by grade, fixed, rejected.
- The commits added (`git log --oneline <headRefOid>..HEAD`).
- Decisions recorded.
- What was **not** checked.
- Baseline gate failures that predate the loop.

Ask before pushing to the PR branch. Never push to a fork PR you don't own, comment on the PR, or open a new one.

End the report with exactly one line, so a `/goal` condition can match it: `REVIEW-LOOP DONE: clean after <N> rounds` or `REVIEW-LOOP STOPPED: <reason>`. Write that line nowhere else, and only when the loop has really ended.

## Lessons (copy into BRIEF.md)

- Shrinking findings is not done. Each round is anchored on the diff; inputs from upstream and real-world configs are where late bugs hide.
- Fixes add machinery. Later rounds' findings often target code the loop added; weigh removing it.
- Tests are specs. A green suite after rewriting a test to match a change proves nothing.
- Subagents kill only processes they started, by PID. No broad `pkill`.
