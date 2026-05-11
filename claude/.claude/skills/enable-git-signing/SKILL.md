---
name: enable-git-signing
description: "Turn git commit signing back on globally. Use after /disable-git-signing once Memento/ac-sign is available again."
---

Re-enable global git commit signing.

## Steps

1. Run: `git config --global commit.gpgsign true`
2. Confirm: `git config --global --get commit.gpgsign`
3. Report the new value to the user in one short line.

## Rules

- Assume the signing program (`gpg.format=x509`, `gpg.x509.program=/usr/local/bin/ac-sign`) is already configured — do not set these.
- Do not modify any repo-local `.git/config`.
