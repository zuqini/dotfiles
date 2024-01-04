mkdir ~/.config
ln -s ~/dotfiles/nvim ~/.config
ln -s ~/dotfiles/kitty ~/.config
ln -s ~/dotfiles/.tmux.conf ~
ln -s ~/dotfiles/.ideavimrc ~

git clone https://github.com/jeffreytse/zsh-vi-mode \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
