local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.use_ime = true
config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
config.font_size = 14.0

-- Colors (warp_purple theme)
config.colors = {
  foreground = "#ff2f2f",
  background = "#38005c",
  cursor_fg = "#38005c",
  cursor_bg = "#ff2f2f",
  selection_fg = "#f1f1f1",
  selection_bg = "#6b3fa0",
  ansi = {
    "#616161", -- black
    "#ff8272", -- red
    "#b4fa72", -- green
    "#fefdc2", -- yellow
    "#a5d5fe", -- blue
    "#ff8ffd", -- magenta
    "#d0d1fe", -- cyan
    "#f1f1f1", -- white
  },
  brights = {
    "#8e8e8e", -- black
    "#ffc4bd", -- red
    "#d6fcb9", -- green
    "#fefdd5", -- yellow
    "#c1e3fe", -- blue
    "#ffb1fe", -- magenta
    "#e5e6fe", -- cyan
    "#feffff", -- white
  },
}

-- Tab bar
config.use_fancy_tab_bar = true
config.tab_max_width = 25
config.window_frame = {
  active_titlebar_bg = "#38005c",
  inactive_titlebar_bg = "#38005c",
}
config.colors.tab_bar = {
  background = "#38005c",
  active_tab = {
    bg_color = "#38005c",
    fg_color = "#ff8ffd",
    intensity = "Bold",
  },
  inactive_tab = {
    bg_color = "#38005c",
    fg_color = "#8e8e8e",
  },
  inactive_tab_hover = {
    bg_color = "#6b3fa0",
    fg_color = "#f1f1f1",
  },
  new_tab = {
    bg_color = "#38005c",
    fg_color = "#8e8e8e",
  },
  new_tab_hover = {
    bg_color = "#6b3fa0",
    fg_color = "#f1f1f1",
  },
}

-- Window
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.scrollback_lines = 10000
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.macos_window_background_blur = 20
config.window_close_confirmation = "NeverPrompt"

-- NOTE: WezTerm does not support global hotkeys (e.g. Alt-Space to focus).
-- Use Raycast or another macOS tool to bind Alt-Space to activate WezTerm.

-- Tab title: show directory name (e.g. repo name) with padding
wezterm.on("format-tab-title", function(tab)
  local title
  if tab.tab_title and #tab.tab_title > 0 then
    title = tab.tab_title
  else
    local cwd = tab.active_pane.current_working_dir
    if cwd then
      local path = cwd.file_path or tostring(cwd)
      title = path:match("([^/]+)/?$") or path
    else
      title = tab.active_pane.title
    end
  end
  return "  " .. title .. "  "
end)

-- Keybindings
local act = wezterm.action
config.keys = {
  { key = "Backspace", mods = "CMD", action = act.SendString("\x15") },       -- Cmd-Delete: kill to line start
  { key = "z",         mods = "CMD", action = act.SendString("\x1f") },        -- Cmd-Z: undo
  { key = "d",         mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d",         mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w",         mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "]",         mods = "CMD", action = act.ActivatePaneDirection("Next") },
  { key = "[",         mods = "CMD", action = act.ActivatePaneDirection("Prev") },
  { key = "k",         mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
  { key = " ",         mods = "CMD|SHIFT", action = act.QuickSelect },
  { key = "e",         mods = "CMD", action = act.PromptInputLine({
    description = "Tab name:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }) },
  { key = "<",         mods = "SHIFT|CMD", action = act.MoveTabRelative(-1) },
  { key = ">",         mods = "SHIFT|CMD", action = act.MoveTabRelative(1) },
}

return config
