---
name: nvim-plugin
description: Rules for my Neovim plugin development. Use when working on Neovim plugins, Lua files for Neovim, or vim plugin repositories.
---

- After a code change, update the README.md, any docs under `docs/`, and the vimdoc under `doc/` to match.
- After a code change, run the repo's test suite and make sure it passes before calling the change done. Use the command the repo defines (README, Makefile, `tests/`, CI workflow), e.g. `nvim -u NONE --headless -S run_tests.lua` or `nvim -u NONE -l tests/busted.lua`. If the repo has no tests, say so.
