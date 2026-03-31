local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

function module.apply_to_config(config)
	config.key_tables = config.key_tables or {}
	config.key_tables.copy_mode = {
		{ key = "Escape", mods = "NONE", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
		{ key = "q", mods = "NONE", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
		{ key = "c", mods = "CTRL", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
		{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
		{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
		{ key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
		{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "r", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Block" }) },
		{ key = "z", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "SemanticZone" }) },
		{ key = "[", mods = "NONE", action = act.CopyMode({ MoveBackwardZoneOfType = "Input" }) },
		{ key = "]", mods = "NONE", action = act.CopyMode({ MoveForwardZoneOfType = "Input" }) },
		{ key = "/", mods = "NONE", action = act.Search("CurrentSelectionOrEmptyString") },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				act.CopyTo("ClipboardAndPrimarySelection"),
				act.CopyMode("Close"),
			}),
		},
		{
			key = "v",
			mods = "SUPER",
			action = act.Multiple({
				"ScrollToBottom",
				{ CopyMode = "Close" },
				act.PasteFrom("Clipboard"),
			}),
		},
	}
end

return module
