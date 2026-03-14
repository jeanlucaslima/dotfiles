local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 14.0

-- Window
config.window_padding = {
	left = 8,
	right = 8,
	top = 4,
	bottom = 4,
}
config.window_decorations = "RESIZE"

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500

-- Scrollback
config.scrollback_lines = 10000

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- Colors (Tokyo Night)
config.colors = {
	foreground = "#c0caf5",
	background = "#1a1b26",
	cursor_bg = "#c0caf5",
	cursor_fg = "#1a1b26",
	cursor_border = "#c0caf5",
	selection_fg = "#c0caf5",
	selection_bg = "#292e42",

	ansi = {
		"#414868", -- black
		"#f7768e", -- red
		"#9ece6a", -- green
		"#e0af68", -- yellow
		"#7aa2f7", -- blue
		"#bb9af7", -- magenta
		"#7dcfff", -- cyan
		"#a9b1d6", -- white
	},
	brights = {
		"#414868", -- bright black
		"#f7768e", -- bright red
		"#9ece6a", -- bright green
		"#e0af68", -- bright yellow
		"#7aa2f7", -- bright blue
		"#bb9af7", -- bright magenta
		"#7dcfff", -- bright cyan
		"#c0caf5", -- bright white
	},

	tab_bar = {
		background = "#1a1b26",
		active_tab = {
			bg_color = "#24283b",
			fg_color = "#c0caf5",
		},
		inactive_tab = {
			bg_color = "#1a1b26",
			fg_color = "#414868",
		},
		inactive_tab_hover = {
			bg_color = "#292e42",
			fg_color = "#c0caf5",
		},
		new_tab = {
			bg_color = "#1a1b26",
			fg_color = "#414868",
		},
		new_tab_hover = {
			bg_color = "#292e42",
			fg_color = "#c0caf5",
		},
	},
}

return config
