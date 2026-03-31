local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

local selected_panes = {}

local function window_key(window)
	return tostring(window:window_id())
end

local function get_tab_panes(pane)
	local tab = pane:tab()
	if not tab then
		return nil, {}
	end
	return tab, tab:panes_with_info()
end

local function sync_selected_pane(window, pane)
	if not pane then
		return nil
	end

	local key = window_key(window)
	local pane_id = selected_panes[key]
	local tab, panes = get_tab_panes(pane)

	if not tab then
		return nil
	end

	if pane_id then
		for _, info in ipairs(panes) do
			if info.pane:pane_id() == pane_id then
				return info.pane
			end
		end
	end

	local active = tab:active_pane()
	if active then
		selected_panes[key] = active:pane_id()
	end
	return active
end

local function activate_target(target)
	if target then
		target:activate()
	end
end

local function select_pane_by_index(index)
	return wezterm.action_callback(function(window, pane)
		local _, panes = get_tab_panes(pane)
		local target = panes[index + 1]
		if not target then
			return
		end

		selected_panes[window_key(window)] = target.pane:pane_id()
		activate_target(target.pane)
	end)
end

local function resize_selected(direction, amount)
	return wezterm.action_callback(function(window, pane)
		local target = sync_selected_pane(window, pane)
		if not target then
			return
		end

		window:perform_action(act.AdjustPaneSize({ direction, amount }), target)
	end)
end

local function retarget_with_direction(direction)
	return wezterm.action_callback(function(window, pane)
		local target = sync_selected_pane(window, pane)
		if not target then
			return
		end

		activate_target(target)
		window:perform_action(act.ActivatePaneDirection(direction), target)
		local active = window:active_pane()
		if active then
			selected_panes[window_key(window)] = active:pane_id()
		end
	end)
end

local function split_selected(direction)
	return wezterm.action_callback(function(window, pane)
		local target = sync_selected_pane(window, pane)
		if not target then
			return
		end

		local new_pane = target:split({
			direction = direction,
			size = { Percent = 50 },
		})
		if new_pane then
			selected_panes[window_key(window)] = new_pane:pane_id()
			activate_target(new_pane)
		end
	end)
end

local function close_selected()
	return wezterm.action_callback(function(window, pane)
		local target = sync_selected_pane(window, pane)
		if not target then
			return
		end

		window:perform_action(act.CloseCurrentPane({ confirm = true }), target)
	end)
end

function module.apply_to_config(config)
	config.key_tables = config.key_tables or {}
	config.key_tables.config_mode = {
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
		{ key = "c", mods = "CTRL", action = "PopKeyTable" },
		{ key = "1", action = select_pane_by_index(0) },
		{ key = "2", action = select_pane_by_index(1) },
		{ key = "3", action = select_pane_by_index(2) },
		{ key = "4", action = select_pane_by_index(3) },
		{ key = "5", action = select_pane_by_index(4) },
		{ key = "6", action = select_pane_by_index(5) },
		{ key = "7", action = select_pane_by_index(6) },
		{ key = "8", action = select_pane_by_index(7) },
		{ key = "9", action = select_pane_by_index(8) },
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

	wezterm.on("window-config-reloaded", function(window, _)
		selected_panes[window_key(window)] = nil
	end)
end

return module
