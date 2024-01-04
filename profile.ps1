Set-Alias vim nvim
Set-Alias vid $HOME\neovide.exe
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

$env:PATH = [string]::join(
	';',
	$env:PATH,
	$HOME + '\AppData\Local\nvim-data\mason\packages\lua-language-server\extension\server\bin',
	$HOME + '\AppData\Local\nvim-data\mason\packages\omnisharp'
)
