# .dotfiles

## Setup

Unix
```
git clone --recurse-submodules --remote-submodules https://github.com/zuqini/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Windows
```
git clone --recurse-submodules --remote-submodules https://github.com/zuqini/dotfiles.git C:\Users\{username}\dotfiles
New-Item -ItemType SymbolicLink -path ~\AppData\Local\nvim\ -value C:\Users\{username}\dotfiles\nvim\
New-Item -ItemType SymbolicLink -path ~ -name .wezterm.lua -value C:\Users\{username}\dotfiles\.wezterm.lua
```

## Increase key-repeat rate

#### MacOS

```
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms). note: 10 is too fast, you won't be able to log in due to double inputs.
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
```

#### Win11

Go into regedit.exe and edit:
```
[HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response]
"AutoRepeatDelay"="200"
"AutoRepeatRate"="6"
"DelayBeforeAcceptance"="0"
"Flags"="59"
"BounceTime"="0"
```
