local wezterm = require 'wezterm'
local act = wezterm.action

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

config.window_background_opacity = 0.95
config.color_scheme = 'terafox'

-- config.font = wezterm.font("InputMonoCondensed", { stretch = "Condensed" })
config.font = wezterm.font("Iosevka Custom")
config.font_size = 16
config.line_height = 1
config.use_fancy_tab_bar = false

config.keys = {
  { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.window_background_opacity  = 0.8
  config.win32_system_backdrop = 'Acrylic'
  -- config.win32_system_backdrop = 'Mica'
  -- config.win32_system_backdrop = 'Tabbed'
  -- config.default_prog = { 'C:/Program Files/nu/bin/nu.exe' }
  config.default_prog = { 'pwsh.exe' }
  config.launch_menu = {}
  table.insert(config.launch_menu, {
    label = 'PowerShell',
    args = { 'pwsh.exe', '-NoLogo' },
  })

  table.insert(config.launch_menu, {
    label = 'CMD',
    args = { 'cmd.exe', '-NoLogo' },
  })
elseif wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
  config.window_background_opacity  = 0.75
  config.macos_window_background_blur = 30
  config.window_decorations = 'RESIZE'
end

return config
