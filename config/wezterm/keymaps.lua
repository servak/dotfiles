local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

local function notify(window, message)
	require("statusbar").flash(window, message, 2)
end

local function copy_last_command_block()
	return wezterm.action_callback(function(window, pane)
		window:perform_action(act.ActivateCopyMode, pane)
		window:perform_action(act.CopyMode({ MoveBackwardZoneOfType = "Input" }), pane)
		window:perform_action(act.CopyMode({ SetSelectionMode = "Cell" }), pane)
		window:perform_action(act.CopyMode({ MoveForwardZoneOfType = "Prompt" }), pane)
		window:perform_action(act.CopyMode("MoveUp"), pane)
		window:perform_action(act.CopyMode("MoveToEndOfLineContent"), pane)
		window:perform_action(
			act.Multiple({
				{ CopyTo = "ClipboardAndPrimarySelection" },
				{ Multiple = { "ScrollToBottom", { CopyMode = "Close" } } },
			}),
			pane
		)
		notify(window, "Copied last command with output")
	end)
end

local function rename_tab()
	return act.PromptInputLine({
		description = "Rename tab",
		action = wezterm.action_callback(function(window, _, line)
			if line == nil then
				return
			end

			window:active_tab():set_title(line)
			if line == "" then
				notify(window, "Reset tab title")
				return
			end

			notify(window, "Renamed tab")
		end),
	})
end

function module.apply_to_config(config)
	config.leader = { key = "t", mods = "CTRL", timeout_milliseconds = 1000 }
	config.disable_default_key_bindings = false

	config.keys = {
		{ key = "t", mods = "LEADER|CTRL", action = act.SendKey({ key = "t", mods = "CTRL" }) },
		{
			key = "e",
			mods = "LEADER",
			action = act.SpawnCommandInNewTab({
				args = {
					"/bin/zsh",
					"-lc",
					"${EDITOR:-vim} ~/.config/wezterm/wezterm.lua",
				},
			}),
		},
		{ key = "c", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },
		{ key = "r", mods = "LEADER", action = rename_tab() },
		{
			key = "?",
			mods = "LEADER|SHIFT",
			action = act.ShowLauncherArgs({
				flags = "KEY_ASSIGNMENTS|FUZZY",
				title = "WezTerm Keys",
			}),
		},
		{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
		{ key = "n", mods = "LEADER|CTRL", action = act.ActivateTabRelative(1) },
		{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
		{ key = "p", mods = "LEADER|CTRL", action = act.ActivateTabRelative(-1) },
		{ key = "Space", mods = "LEADER", action = act.QuickSelect },
		{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
		{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
		{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
		{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
		{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
		{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
		{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
		{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
		{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },
		{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
		{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
		{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
		{ key = "[", mods = "ALT", action = act.ScrollToPrompt(-1) },
		{ key = "]", mods = "ALT", action = act.ScrollToPrompt(1) },
		{ key = "y", mods = "LEADER", action = copy_last_command_block() },
		{
			key = "X",
			mods = "CTRL",
			action = act.Multiple({
				act.ActivateCopyMode,
				act.CopyMode("ClearPattern"),
				act.CopyMode("ClearSelectionMode"),
				act.CopyMode("MoveToViewportMiddle"),
			}),
		},
		{
			key = "m",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "config_mode",
				one_shot = false,
				timeout_milliseconds = 2000,
			}),
		},
	}
end

return module
