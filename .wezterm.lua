local wezterm = require 'wezterm'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe" }
end


config.color_scheme = 'GruvboxDarkHard'
config.window_background_opacity  = 0.95
  config.font = wezterm.font('FiraCode Nerd Font')

return config
