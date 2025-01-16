# install brew
if ! which -s brew; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed"
fi

if ! which -s fd; then
  echo "Installing fd"
    brew install fd
else
  echo "fd already installed"
fi

if ! which -s rg; then
  echo "Installing rg"
    brew install ripgrep
else
  echo "rg already installed"
fi

if ! which -s ghostty; then
  echo "Installing Ghostty"
  brew install ghostty
else
  echo "Ghostty already installed"
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# font
brew install --cask font-iosevka

if ! which -s stow; then
  echo "Installing stow"
  brew install stow
else
  echo "stow already installed"
fi

# tiling window manager
if ! which -s aerospace; then
  echo "Installing aerospace"
  brew install --cask nikitabobko/tap/aerospace
else
  echo "aerospace already installed"
fi

if ! which -s sketchybar; then
  echo "Installing sketchybar"
  brew tap FelixKratz/formulae
  brew install sketchybar
else
  echo "sketchybar already installed"
fi

# https://stackoverflow.com/a/246129
DOTFILES_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

stow zshrc

mkdir -p ~/.oh-my-zsh/custom/themes
ln -s ${DOTFILES_PATH}/misc/themes/oh-my-zsh/lambdim-zsh-theme/lambdim.zsh-theme ~/.oh-my-zsh/custom/themes/lambdim.zsh-theme

# macos tiling windows manager and bar
stow aerospace sketchybar

# editors
stow nvim idea doom

mkdir -p ~/.zfunc
bob complete zsh > ~/.zfunc/_bob

# tmux
stow tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# terminal configs
stow wezterm ghostty kitty

# global git configs
stow gitconfig
stow gitignore

# zsh plugins
git clone https://github.com/jeffreytse/zsh-vi-mode \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions \
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

# wezterm terminfo
# https://wezfurlong.org/wezterm/faq.html?h=underline#how-do-i-enable-undercurl-curly-underlines
tempfile=$(mktemp) \
  && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo \
  && tic -x -o ~/.terminfo $tempfile \
  && rm $tempfile
