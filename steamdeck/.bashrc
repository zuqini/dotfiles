#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Get a list of available Sdk extensions:
#   flatpak search org.freedesktop.Sdk.Extension.
# Great, let's install org.freedesktop.Sdk.Extension.node18
#   flatpak install flathub org.freedesktop.Sdk.Extension.node18
# run nvim with node18 enabled
alias fvim="env FLATPAK_ENABLE_SDK_EXT=node18 flatpak run io.neovim.nvim"
alias db=distrobox
alias dbe="distrobox enter ubuntu-22-04"

export PATH=$PATH:$HOME/.local/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
