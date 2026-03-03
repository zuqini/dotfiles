#!/usr/bin/env bash
set -euo pipefail

DOTFILES_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

brew_install() {
  local cmd="$1"
  local pkg="${2:-$1}"
  if ! command -v "$cmd" &>/dev/null; then
    echo "Installing $pkg"
    brew install "$pkg"
  else
    echo "$pkg already installed"
  fi
}

brew_cask_install() {
  local pkg="$1"
  if ! brew list --cask "$pkg" &>/dev/null; then
    echo "Installing $pkg"
    brew install --cask "$pkg"
  else
    echo "$pkg already installed"
  fi
}

clone_if_missing() {
  local url="$1"
  local dest="$2"
  if [[ -d "$dest" ]]; then
    echo "Already exists: $dest"
  else
    git clone "$url" "$dest"
  fi
}

# Core dependencies first
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed"
fi

if ! command -v cargo &>/dev/null; then
  echo "Installing Rust"
  curl https://sh.rustup.rs -sSf | sh
  source "$HOME/.cargo/env"
else
  echo "Rust already installed"
fi

# stow must be installed before any stow commands
brew_install stow

# CLI tools
brew_install fd
brew_install rg ripgrep
brew_install ast-grep

# beads issue tracker
if ! command -v bd &>/dev/null; then
  echo "Installing beads"
  brew install steveyegge/beads/bd
else
  echo "beads already installed"
fi

# terminals
brew_install ghostty
brew_install zellij

# tiling window manager
brew_cask_install nikitabobko/tap/aerospace

# status bar
if ! command -v sketchybar &>/dev/null; then
  echo "Installing sketchybar"
  brew tap FelixKratz/formulae
  brew install sketchybar
else
  echo "sketchybar already installed"
fi

# neovim version manager and tree-sitter
if ! command -v tree-sitter &>/dev/null; then
  echo "Installing tree-sitter-cli"
  cargo install --locked tree-sitter-cli
else
  echo "tree-sitter-cli already installed"
fi

# bob completions
if ! command -v bob &>/dev/null; then
  echo "Installing bob-nvim"
  cargo install bob-nvim

  mkdir -p ~/.zfunc
  bob complete zsh > ~/.zfunc/_bob
else
  echo "bob-nvim already installed"
fi

# oh-my-zsh (idempotent)
if [[ ! -d ~/.oh-my-zsh ]]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh already installed"
fi

# font
brew_cask_install font-iosevka

# stow packages
stow zshrc
stow zellij

# oh-my-zsh theme (idempotent symlink)
mkdir -p ~/.oh-my-zsh/custom/themes
ln -sf "${DOTFILES_PATH}/misc/themes/oh-my-zsh/lambdim-zsh-theme/lambdim.zsh-theme" ~/.oh-my-zsh/custom/themes/lambdim.zsh-theme

# macos tiling windows manager and bar
stow aerospace sketchybar

# editors
stow nvim idea doom

# AI
stow claude gemini

# tmux
stow tmux
clone_if_missing https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

stow yazi

# terminal configs
stow wezterm ghostty kitty

# global git configs
stow gitconfig
stow gitignore

# zsh plugins (idempotent)
zsh_plugins="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins"
clone_if_missing https://github.com/jeffreytse/zsh-vi-mode "$zsh_plugins/zsh-vi-mode"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$zsh_plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-completions "$zsh_plugins/zsh-completions"

# wezterm terminfo
# https://wezfurlong.org/wezterm/faq.html?h=underline#how-do-i-enable-undercurl-curly-underlines
if [[ ! -f ~/.terminfo/w/wezterm ]]; then
  echo "Installing wezterm terminfo"
  tempfile=$(mktemp)
  trap "rm -f '$tempfile'" EXIT
  curl -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo
  tic -x -o ~/.terminfo "$tempfile"
else
  echo "wezterm terminfo already installed"
fi

# browser screenshot utility
if [[ ! -d "${DOTFILES_PATH}/utilities/browser-screenshot/node_modules" ]]; then
  echo "Installing browser-screenshot dependencies"
  (cd "${DOTFILES_PATH}/utilities/browser-screenshot" && npm install && npx playwright install chromium)
else
  echo "browser-screenshot already installed"
fi

echo "Done!"
