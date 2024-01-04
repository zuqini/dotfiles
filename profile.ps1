# In "Editor Sessings/Text Editor/External", set Exec Flags to --server 127.0.0.1:9696 --remote-send "<C-N>:n {file}<CR>{line}G{col}|"
Function vimgd {nvim --listen 127.0.0.1:9696}
Set-Alias vim nvim
Set-Alias vid $HOME\neovide.exe
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

$env:PATH = [string]::join(
	';',
	$env:PATH,
	$HOME + '\AppData\Local\nvim-data\mason\packages\lua-language-server\extension\server\bin',
	$HOME + '\AppData\Local\nvim-data\mason\packages\omnisharp'
)
