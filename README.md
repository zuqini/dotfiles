# .dotfiles

## Setup

##### zsh/bash
```
git clone --recurse-submodules --remote-submodules https://github.com/zuqini/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

##### Windows
```
git clone --recurse-submodules --remote-submodules https://github.com/zuqini/dotfiles.git C:\Users\{username}\dotfiles

# powershell
New-Item -ItemType SymbolicLink -path ~\AppData\Local\nvim\ -value C:\Users\{username}\dotfiles\nvim\.config\nvim
New-Item -ItemType SymbolicLink -path ~ -name .wezterm.lua -value C:\Users\{username}\dotfiles\wezterm\.wezterm.lua
New-Item -ItemType SymbolicLink -path ~ -name .gitconfig -value C:\Users\{username}\dotfiles\git\.gitconfig
New-Item -ItemType SymbolicLink -path ~\Documents\WindowsPowerShell -name profile.ps1 -value C:\Users\{username}\dotfiles\misc\win\profile.ps1
New-Item -ItemType SymbolicLink -path ~\Documents\PowerShell -name profile.ps1 -value C:\Users\{username}\dotfiles\misc\win\profile.ps1
```

### Miscellaneous

#### tmux-256color not displaying correctly

It's likely that `tmux-256color` is somehow missing in the `.terminfo`. See https://github.com/tmux/tmux/issues/1257#issuecomment-581378716
```
$ brew install ncurses
$ /usr/local/opt/ncurses/bin/infocmp tmux-256color > ~/tmux-256color.info
$ tic -xe tmux-256color tmux-256color.info
# This creates a complied entry in ~/.terminfo
$ infocmp tmux-256color | head
#       Reconstructed via infocmp from file: /Users/libin/.terminfo/74/tmux-256color
tmux-256color|tmux with 256 colors,
```

#### Increase key-repeat rate

##### MacOS

```
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms). note: 10 is too fast, you won't be able to log in due to double inputs.
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
```

##### Win11

Go into regedit.exe and edit:
```
[HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response]
"AutoRepeatDelay"="200"
"AutoRepeatRate"="6"
"DelayBeforeAcceptance"="0"
"Flags"="59"
"BounceTime"="0"
```
