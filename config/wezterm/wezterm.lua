-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action
-- create leader key
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- disable confirm close window
config.window_close_confirmation = "NeverPrompt"

-- disable bell chime
config.audible_bell = "Disabled"
-- keymap for pane splits
config.keys = {
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "\\",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(wezterm.action.SwitchToWorkspace({ name = "wezterm-config" }), pane)
			window:perform_action(
				wezterm.action.SpawnCommandInNewTab({
					cwd = "/Users/drewrichard/.config/wezterm",
					args = { "/opt/homebrew/bin/nvim", "wezterm.lua" },
				}),
				pane
			)
		end),
	},
}

config.font_size = 18
config.font = wezterm.font({
	family = "Monaspace Neon",
	--ligature features below
	harfbuzz_features = {
		"calt=1",
		"ss01=1",
		"ss02=1",
		"ss03=1",
		"ss05=1",
		"ss06=1",
		"ss07=1",
		"ss08=1",
		"ss09=1",
		"liga=1",
		"clig=1",
	},
})
config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 15
config.adjust_window_size_when_changing_font_size = false
config.initial_rows = 40
config.initial_cols = 140

config.max_fps = 120

-- config.color_scheme = 'Cobalt Neon'
-- config.color_scheme = 'Catppuccin Mocha (Gogh)'
-- config.color_scheme = 'tokyonight'
config.color_scheme = "Tokyo Night (Gogh)"
-- config.color_scheme = 'Tokyo Night Storm (Gogh)'

-- coolnight colorscheme:
-- config.colors = {
--   foreground = "#CBE0F0",
--   -- background = "#011423",
--   background = "#000000",
--   cursor_bg = "#97E5F5",
--   cursor_border = "#47FF9C",
--   cursor_fg = "#011423",
--   selection_bg = "#B9F3FB",
--   selection_fg = "#001423",
--   ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
--   brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
-- }

-- and finally, return the configuration to wezterm
return config
