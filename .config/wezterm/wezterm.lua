local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.font_size = 18.0

config.scrollback_lines = 3500
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 144

return config