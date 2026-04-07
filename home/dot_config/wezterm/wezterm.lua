local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 14.0
config.line_height = 1.2

-- Catppuccin Mocha colorscheme
config.colors = {
  foreground = "#cdd6f4",
  background = "#1e1e2e",
  cursor_bg = "#f5e0dc",
  cursor_border = "#f5e0dc",
  cursor_fg = "#1e1e2e",
  selection_bg = "#585b70",
  selection_fg = "#cdd6f4",

  ansi = {
    "#45475a", -- black (Surface1)
    "#f38ba8", -- red
    "#a6e3a1", -- green
    "#f9e2af", -- yellow
    "#89b4fa", -- blue
    "#cba6f7", -- magenta (Mauve)
    "#89dceb", -- cyan (Sky)
    "#bac2de", -- white (Subtext1)
  },
  brights = {
    "#585b70", -- bright black (Surface2)
    "#f38ba8", -- bright red
    "#a6e3a1", -- bright green
    "#f9e2af", -- bright yellow
    "#89b4fa", -- bright blue
    "#cba6f7", -- bright magenta
    "#89dceb", -- bright cyan
    "#a6adc8", -- bright white (Subtext0)
  },
}

-- Window
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.window_decorations = "RESIZE"
config.window_background_opacity = 1.0
config.macos_window_background_blur = 0

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.colors.tab_bar = {
  background = "#181825",
  active_tab = { bg_color = "#cba6f7", fg_color = "#1e1e2e" },
  inactive_tab = { bg_color = "#1e1e2e", fg_color = "#585b70" },
  inactive_tab_hover = { bg_color = "#181825", fg_color = "#cba6f7" },
  new_tab = { bg_color = "#1e1e2e", fg_color = "#585b70" },
  new_tab_hover = { bg_color = "#1e1e2e", fg_color = "#cba6f7" },
}

-- Scrollback
config.scrollback_lines = 10000

-- Bell
config.audible_bell = "Disabled"

-- macOS
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

return config
