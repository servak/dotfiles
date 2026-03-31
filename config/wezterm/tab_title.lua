local wezterm = require("wezterm")

local module = {}

local function basename(path)
	return string.gsub(path or "", "(.*[/\\])(.*)", "%2")
end

local function display_path(path)
	if not path then
		return "-"
	end

	local home = os.getenv("HOME")
	if home and path:find("^" .. home) then
		path = path:gsub("^" .. home, "~")
	end

	path = path:gsub("/$", "")
	return path:match("([^/]+)$") or path
end

local function detect_ssh_title(process_name, pane_title)
	if process_name ~= "ssh" then
		return nil
	end

	if pane_title and pane_title ~= "" then
		local host = pane_title:match("([^@%s]+@[%w%._%-]+)")
		if host then
			return host
		end

		host = pane_title:match("([%w%._%-]+)%s*$")
		if host and host ~= "ssh" then
			return host
		end
	end

	return "ssh"
end

function module.apply_to_config(_)
	wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
		local pane = tab.active_pane
		local process_name = basename(pane.foreground_process_name)
		local pane_title = pane.title or ""
		local cwd_url = pane.current_working_dir
		local cwd = cwd_url and cwd_url.file_path or nil
		local title = tab.tab_title

		if title and title ~= "" then
			title = title
		else
			title = detect_ssh_title(process_name, pane_title) or display_path(cwd)
		end

		local zoom = ""
		for _, pane_info in ipairs(tab.panes) do
			if pane_info.is_zoomed then
				zoom = "Z "
				break
			end
		end

		local fg = tab.is_active and "#111111" or "#a0a0a0"
		local bg = tab.is_active and "#80ebdf" or "#181818"

		return {
			{ Background = { Color = bg } },
			{ Foreground = { Color = fg } },
			{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
			{ Text = " " .. zoom .. wezterm.truncate_right(title, max_width - 2) .. " " },
		}
	end)
end

return module
