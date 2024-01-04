local wezterm = require 'wezterm'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-----------------------------config-----------------------------------

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe" }
end

config.scrollback_lines = 50000

config.window_background_opacity  = 0.95
config.color_scheme = 'GruvboxDarkHard'

config.font = wezterm.font('FiraCode Nerd Font')
config.font_size = 16

return config
