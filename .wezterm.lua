-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = 'Kanagawa Dragon (Gogh)'

config.font = wezterm.font { family = "JetBrainsMono Nerd Font"}
config.font_size = 12.0
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.initial_rows = 43
config.initial_cols = 187
config.window_background_opacity = 0.8
config.win32_system_backdrop = "Acrylic"

-- Special
config.default_prog = { 'C:\\Windows\\System32\\wsl.exe', '--cd', '~'}
wezterm.on("gui-startup", function(command_line)
  local tab, pane, window = wezterm.mux.spawn_window(command_line or {})
  window:gui_window():set_position(15, 15) -- Example: position at (100, 100)
end)

-- and finally, return the configuration to wezterm
return config
