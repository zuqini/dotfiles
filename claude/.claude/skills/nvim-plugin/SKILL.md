---
name: nvim-plugin
description: Guidelines for Neovim plugin development. Use when working on Neovim plugins, Lua files for Neovim, or vim plugin repositories.
---

# Neovim Plugin Development

## Instructions

When working on Neovim plugins:

1. **Documentation**: Always update both the README.md (and any docs under `docs/`) and the vimdocs after making code changes
2. **Commits**: Follow proper open-source commit message standards
3. **Testing**: Run tests with `nvim -u NONE --headless -S run_tests.lua` (only if there were code changes)
