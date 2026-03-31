local wezterm = require("wezterm")

local module = {}

function module.apply_to_config(config)
	config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
	config.term = "xterm-256color"
	config.font = wezterm.font("SauceCodePro Nerd Font Mono")
	config.font_size = 14
	config.window_background_opacity = 1.0
	config.initial_cols = 140
	config.initial_rows = 36
	config.enable_scroll_bar = false
	config.use_fancy_tab_bar = false
	config.hide_tab_bar_if_only_one_tab = false
	config.tab_bar_at_bottom = true
	config.inactive_pane_hsb = {
		saturation = 0.75,
		brightness = 0.60,
	}
	config.adjust_window_size_when_changing_font_size = false
	config.send_composed_key_when_left_alt_is_pressed = true
	config.send_composed_key_when_right_alt_is_pressed = false
	config.window_decorations = "RESIZE"
	config.window_close_confirmation = "NeverPrompt"

	config.window_frame = {
		font = wezterm.font("SauceCodePro Nerd Font Mono"),
		font_size = 13,
	}

	config.colors = {
		background = "#2b2b2b",
		foreground = "#d0d0d0",
		split = "#6a6a6a",
		cursor_bg = "#80ebdf",
		cursor_fg = "#000000",
		cursor_border = "#80ebdf",
		selection_bg = "#f0e68c",
		selection_fg = "#111111",
		tab_bar = {
			background = "#181818",
			active_tab = {
				bg_color = "#2b2b2b",
				fg_color = "#d0d0d0",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#181818",
				fg_color = "#7a7a7a",
			},
			inactive_tab_hover = {
				bg_color = "#222222",
				fg_color = "#a0a0a0",
			},
			new_tab = {
				bg_color = "#181818",
				fg_color = "#7a7a7a",
			},
			new_tab_hover = {
				bg_color = "#222222",
				fg_color = "#d0d0d0",
			},
		},
	}
end

return module
