# install brew
which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed"
fi

# wezterm
which -s wezterm
if [[ $? != 0 ]] ; then
  echo "Installing wezterm"
  brew install wezterm
else
  echo "wezterm already installed"
fi

# nu
# which -s nu
# if [[ $? != 0 ]] ; then
#   echo "Installing nushell"
#   brew install nushell
# else
#   echo "nushell already installed"
# fi

mkdir ~/.config

# vim
ln -s ~/dotfiles/nvim ~/.config
ln -s ~/dotfiles/.ideavimrc ~

# tmux
ln -s ~/dotfiles/.tmux.conf ~

# terminal configs
ln -s ~/dotfiles/kitty ~/.config
ln -s ~/dotfiles/.wezterm.lua ~

# nushell configs
# ln -s ~/dotfiles/nushell/config.nu ~/Library/Application\ Support/nushell
# ln -s ~/dotfiles/nushell/env.nu ~/Library/Application\ Support/nushell

# global git configs
ln -s ~/dotfiles/git ~/.config/

# zsh plugins
git clone https://github.com/jeffreytse/zsh-vi-mode \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
