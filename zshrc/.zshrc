# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="lambdim"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
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

# ---------------------------------------------------------------------------------------------
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines
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

# uv
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# Custom PATHs ====================================================================
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
export PATH=/usr/local/opt/llvm/bin:$PATH
export PATH=$PATH:$HOME/.config/emacs/bin
export PATH=$PATH:$HOME/Development/flutter/bin
export PATH=$PATH:$HOME/.dotnet/tools
export PATH=$PATH:/Applications/love.app/Contents/MacOS/
# NVIM Language Servers on the path for Helix/MCPs
export PATH=$PATH:$HOME/.local/share/nvim/mason/bin
# Framework override for C# LSP
export FrameworkPathOverride=/Library/Frameworks/Mono.framework/Versions/Current
# export FrameworkPathOverride=~/.config/coc/extensions/coc-omnisharp-data/server/omnisharp
# =================================================================================
eval "$(brew shellenv)"

# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
    # [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    source <(fzf --zsh)
    bindkey '^ ' autosuggest-accept
}

# source work specific stuff at the end
[[ -f "$HOME/work.sh" ]] && source ~/work.sh

# Created by `pipx` on 2026-02-06 20:05:54
export PATH="$PATH:/Users/zachli/.local/bin"
