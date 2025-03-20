-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Universal configurations
config.font = wezterm.font { family = "JetBrainsMono Nerd Font" }

-- Windows Configurations
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.color_scheme = 'Kanagawa Dragon (Gogh)'
    config.font_size = 12.0
    config.hide_tab_bar_if_only_one_tab = true
    config.window_decorations = "RESIZE"
    config.initial_rows = 43
    config.initial_cols = 187
    config.window_background_opacity = 0.8
    config.win32_system_backdrop = "Acrylic"
    config.default_prog = { 'C:\\Windows\\System32\\wsl.exe', '--cd', '~' }

    wezterm.on("gui-startup", function(command_line)
        local tab, pane, window = wezterm.mux.spawn_window(command_line or {})
        window:gui_window():set_position(15, 15)
    end)
end

-- Mac Configurations
if wezterm.target_triple == 'x86_64-apple-darwin' then
    config.color_scheme = 'Batman'
    config.font_size = 15.0
    config.hide_tab_bar_if_only_one_tab = true
    config.window_decorations = "RESIZE"
    config.window_background_opacity = 0.2
    config.macos_window_background_blur = 50

    config.window_padding = {
        left = '3cell',
        right = '3cell',
        top = '1cell',
        bottom = '1cell',
    }

    -- Fullscreen
    config.initial_rows = 200
    config.initial_cols = 200
end

-- and finally, return the configuration to wezterm
return config
