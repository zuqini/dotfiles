# Path to your Oh My Zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Non-interactive environment setup (needed by tools like Claude Code) =========
# uv
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# Custom PATHs
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
export PATH=/usr/local/opt/llvm/bin:$PATH
export PATH=$PATH:$HOME/.config/emacs/bin
export PATH=$PATH:$HOME/Development/flutter/bin
export PATH=$PATH:$HOME/.dotnet/tools
export PATH=$PATH:/Applications/love.app/Contents/MacOS/
export PATH=$PATH:$HOME/.local/share/nvim/mason/bin
export PATH=$PATH:$HOME/.local/bin

# Framework override for C# LSP
export FrameworkPathOverride=/Library/Frameworks/Mono.framework/Versions/Current

eval "$(brew shellenv)"

# Skip the rest for non-interactive shells (avoids omz noise in tools)
[[ ! -o interactive ]] && return
# ==============================================================================

ZSH_THEME="lambdim"

plugins=(
  git
  zsh-vi-mode
  zsh-autosuggestions
  nvm
)

zstyle ':omz:plugins:nvm' lazy yes

# completion
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
fpath+=~/.zfunc

source $ZSH/oh-my-zsh.sh

# User configuration -----------------------------------------------------------

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias vim="nvim"
alias vimnp="nvim -u ~/.config/nvim/noplugin.vim" # vim noplugin
alias skbr="sketchybar --reload"
# For Godot Engine
# In "Editor Sessings/Text Editor/External", set Exec Flags to --server ./godothost --remote-send "<C-N>:n {file}<CR>{line}G{col}|"
alias vimgd="vim --listen ./godothost"
alias k="kubectl"
alias ht="history -t '%y-%m-%d %T'"
alias z="zellij"

unsetopt autocd

source ~/dotfiles/.custom_commands.sh

# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
    source <(fzf --zsh)
    bindkey '^ ' autosuggest-accept
}

# source work specific stuff at the end
[[ -f "$HOME/work.sh" ]] && source ~/work.sh
