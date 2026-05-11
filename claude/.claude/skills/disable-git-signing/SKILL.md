---
name: disable-git-signing
description: "Turn off git commit signing globally. Use when on this machine without Memento/ac-sign access (e.g. via SSH) so commits don't fail to sign."
---

Disable global git commit signing so commits work without Apple's ac-sign / Memento.

## Steps

1. Run: `git config --global commit.gpgsign false`
2. Confirm: `git config --global --get commit.gpgsign`
3. Report the new value to the user in one short line.

## Rules

- Do not touch `gpg.format` or `gpg.x509.program` — leave the signing config intact so re-enabling is a single toggle.
- Do not modify any repo-local `.git/config`.
