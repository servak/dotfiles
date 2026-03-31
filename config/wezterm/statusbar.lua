local wezterm = require("wezterm")

local module = {}
local transient_messages = {}

local STATUS_STYLES = {
	leader = { label = "LEADER", color = "#d7ba7d" },
	copy_mode = { label = "VIEW", color = "#ffd166" },
	config_mode = { label = "CONFIG", color = "#ef476f" },
	zoom = { label = "ZOOM", color = "#80ebdf" },
	workspace = { color = "#6a9955" },
	notice = { color = "#80ebdf" },
}

function module.flash(window, message, ttl_seconds)
	transient_messages[window:window_id()] = {
		message = message,
		expires_at = os.time() + (ttl_seconds or 2),
	}
end

function module.apply_to_config(config)
	config.status_update_interval = 1000

	wezterm.on("update-status", function(window, pane)
		local workspace = window:active_workspace()
		local key_table = window:active_key_table()
		local active_tab = pane and pane:tab() or nil
		local left_cells = {}
		local right_cells = {}
		local flags = {}
		local has_left = false
		local has_right = false
		local notice = transient_messages[window:window_id()]

		if notice and notice.expires_at <= os.time() then
			transient_messages[window:window_id()] = nil
			notice = nil
		end

		if workspace ~= "default" then
			has_left = true
			table.insert(left_cells, { Foreground = { Color = STATUS_STYLES.workspace.color } })
			table.insert(left_cells, { Text = "❐ " .. workspace .. " " })
		end

		if window:leader_is_active() then
			table.insert(flags, STATUS_STYLES.leader)
		end

		if key_table == "copy_mode" then
			table.insert(flags, STATUS_STYLES.copy_mode)
		elseif key_table == "config_mode" then
			table.insert(flags, STATUS_STYLES.config_mode)
		end

		if active_tab then
			for _, info in ipairs(active_tab:panes_with_info()) do
				if info.is_zoomed then
					table.insert(flags, STATUS_STYLES.zoom)
					break
				end
			end
		end

		if #flags == 0 and not has_left and not notice then
			window:set_left_status("")
			window:set_right_status("")
			return
		end

		for _, flag in ipairs(flags) do
			table.insert(right_cells, { Foreground = { Color = flag.color } })
			table.insert(right_cells, { Text = flag.label .. " " })
			has_right = true
		end

		if notice then
			table.insert(right_cells, { Foreground = { Color = STATUS_STYLES.notice.color } })
			table.insert(right_cells, { Text = notice.message .. " " })
			has_right = true
		end

		if has_left then
			window:set_left_status(wezterm.format({
				{ Background = { Color = "#232323" } },
				{ Text = " " },
				table.unpack(left_cells),
			}))
		else
			window:set_left_status("")
		end

		if has_right then
			window:set_right_status(wezterm.format({
				{ Background = { Color = "#232323" } },
				{ Text = " " },
				table.unpack(right_cells),
			}))
		else
			window:set_right_status("")
		end
	end)
end

return module
