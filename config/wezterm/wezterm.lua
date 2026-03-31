local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true

require("appearance").apply_to_config(config)
require("keymaps").apply_to_config(config)
require("copy_mode").apply_to_config(config)
require("config_mode").apply_to_config(config)
require("statusbar").apply_to_config(config)
require("tab_title").apply_to_config(config)

return config
