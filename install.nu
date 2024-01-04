mkdir ~/.config

# vim
ln -s ~/dotfiles/nvim ~/.config
ln -s ~/dotfiles/.ideavimrc ~

# tmux
ln -s ~/dotfiles/.tmux.conf ~

# terminal configs
ln -s ~/dotfiles/kitty ~/.config
ln -s ~/dotfiles/.wezterm.lua ~

# zsh plugins
git clone https://github.com/jeffreytse/zsh-vi-mode \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
