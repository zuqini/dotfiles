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
New-Item -ItemType SymbolicLink -path ~\AppData\Local\nvim\ -value C:\Users\{username}\dotfiles\nvim\
New-Item -ItemType SymbolicLink -path ~ -name .wezterm.lua -value C:\Users\{username}\dotfiles\.wezterm.lua
New-Item -ItemType SymbolicLink -path ~\Documents\WindowsPowerShell -name profile.ps1 -value C:\Users\{username}\dotfiles\profile.ps1
New-Item -ItemType SymbolicLink -path ~\Documents\PowerShell -name profile.ps1 -value C:\Users\{username}\dotfiles\profile.ps1
New-Item -ItemType SymbolicLink -path ~\AppData\Roaming\nushell\ -name config.nue -value C:\Users\{username}\dotfiles\config.nu
New-Item -ItemType SymbolicLink -path ~\AppData\Roaming\nushell\ -name config.nue -value C:\Users\{username}\dotfiles\env.nu

# cmd/nushell
mklink /D C:\Users\{username}\AppData\Local\nvim\ C:\Users\{username}\dotfiles\nvim\
mklink C:\Users\{username}\.wezterm.lua C:\Users\{username}\dotfiles\.wezterm.lua
mklink C:\Users\{username}\Documents\WindowsPowerShell\profile.ps1 C:\Users\{username}\dotfiles\profile.ps1
mklink C:\Users\{username}\Documents\PowerShell\profile.ps1 C:\Users\{username}\dotfiles\profile.ps1
mklink C:\Users\{username}\AppData\Roaming\nushell\config.nu C:\Users\{username}\dotfiles\nushell\config.nu
mklink C:\Users\{username}\AppData\Roaming\nushell\env.nu C:\Users\{username}\dotfiles\nushell\env.nu
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
