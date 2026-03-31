local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

local function resize_selected(direction, amount)
	return act.AdjustPaneSize({ direction, amount })
end

local function retarget_with_direction(direction)
	return act.ActivatePaneDirection(direction)
end

local function split_selected(direction)
	return direction == "Down"
			and act.SplitVertical({ domain = "CurrentPaneDomain" })
		or act.SplitHorizontal({ domain = "CurrentPaneDomain" })
end

local function close_selected()
	return act.CloseCurrentPane({ confirm = true })
end

function module.apply_to_config(config)
	config.key_tables = config.key_tables or {}
	config.key_tables.config_mode = {
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
		{ key = "c", mods = "CTRL", action = "PopKeyTable" },
		{ key = "n", action = act.ActivateTabRelative(1) },
		{ key = "p", action = act.ActivateTabRelative(-1) },
		{ key = "h", action = resize_selected("Left", 1) },
		{ key = "j", action = resize_selected("Down", 1) },
		{ key = "k", action = resize_selected("Up", 1) },
		{ key = "l", action = resize_selected("Right", 1) },
		{ key = "H", mods = "SHIFT", action = retarget_with_direction("Left") },
		{ key = "J", mods = "SHIFT", action = retarget_with_direction("Down") },
		{ key = "K", mods = "SHIFT", action = retarget_with_direction("Up") },
		{ key = "L", mods = "SHIFT", action = retarget_with_direction("Right") },
		{ key = "s", action = split_selected("Down") },
		{ key = "v", action = split_selected("Right") },
		{ key = "x", action = close_selected() },
	}
end

return module
