local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font 'Roboto Mono Nerd Font Mono'

config.color_scheme = 'Catppuccin Mocha'
config.font_size = 14.0

config.scrollback_lines = 3500
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 144

config.enable_wayland = false

return config
