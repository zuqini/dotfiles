local wezterm = require 'wezterm'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-----------------------------config-----------------------------------
config.cursor_blink_rate = 0

config.scrollback_lines = 50000
config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity  = 0.75
config.macos_window_background_blur = 20
config.win32_system_backdrop = 'Acrylic'

config.color_scheme = 'GruvboxDarkHard'

config.font = wezterm.font("InputMonoCondensed", { stretch = "Condensed" })
config.font_size = 16

config.keys = {
  { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'C:/Program Files/nu/bin/nu.exe' }
  config.launch_menu = {}
  table.insert(config.launch_menu, {
    label = 'PowerShell',
    args = { 'pwsh.exe', '-NoLogo' },
  })

  table.insert(config.launch_menu, {
    label = 'CMD',
    args = { 'cmd.exe', '-NoLogo' },
  })
end

return config
