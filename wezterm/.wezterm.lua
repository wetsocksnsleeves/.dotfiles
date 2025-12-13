-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Universal configurations
config.font = wezterm.font({ family = "JetBrainsMono Nerd Font" })
config.color_scheme = "Vengence" -- Custom version of the Batman color scheme
config.audible_bell = "Disabled"
config.warn_about_missing_glyphs = false

-- Windows Configurations
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.font_size = 12.0
    config.hide_tab_bar_if_only_one_tab = true
    config.window_decorations = "RESIZE"
    config.initial_rows = 43
    config.initial_cols = 187
    config.window_background_opacity = 0.8
    config.win32_system_backdrop = "Acrylic"
    config.default_prog = { "C:\\Windows\\System32\\wsl.exe", "--cd", "~" }

    wezterm.on("gui-startup", function(command_line)
        local tab, pane, window = wezterm.mux.spawn_window(command_line or {})
        window:gui_window():set_position(15, 15)
    end)
end

-- Mac Configurations
if wezterm.target_triple == "x86_64-apple-darwin" then
    config.font_size = 15.0
    config.hide_tab_bar_if_only_one_tab = true
    config.window_decorations = "RESIZE"
    config.window_background_opacity = 0.2
    config.macos_window_background_blur = 50

    config.window_padding = {
        left = "3cell",
        right = "3cell",
        top = "1cell",
        bottom = "1cell",
    }

    -- Fullscreen
    config.initial_rows = 200
    config.initial_cols = 200
end

-- Linux Configurations
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
    config.font_size = 12.0
    config.hide_tab_bar_if_only_one_tab = true
    config.window_decorations = "NONE"
    config.window_background_opacity = 0.6
    config.kde_window_background_blur = true

    config.window_padding = {
        left = "3cell",
        right = "3cell",
        top = "1cell",
        bottom = "1cell",
    }

    -- Fullscreen
    config.initial_rows = 200
    config.initial_cols = 200
end

config.color_schemes = {
    ["Vengence"] = {
        foreground = "#e4e4e4",
        background = "#000000",
        cursor_bg = "#fff67d",
        cursor_border = "#fff67d",
        selection_bg = "#4D4F4C",
        ansi = { "#000000", "#5f8787", "#d0dfee", "#5f81a5", "#888888", "#999999", "#aaaaaa", "#c1c1c1" },
        brights = { "#404040", "#5f8787", "#d0dfee", "#5f81a5", "#888888", "#999999", "#aaaaaa", "#c1c1c1" }
    },
}

-- and finally, return the configuration to wezterm
return config
