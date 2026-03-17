local wezterm = require("wezterm")
local config = wezterm.config_builder()
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

config.use_ime = true
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Noto Sans Mono CJK JP",
})
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

-- Tab bar (disabled: zellij manages tabs/panes)
config.enable_tab_bar = false

-- Window
config.window_decorations = "TITLE | RESIZE"
config.scrollback_lines = 10000
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.macos_window_background_blur = 20
config.window_close_confirmation = "NeverPrompt"

-- NOTE: WezTerm does not support global hotkeys (e.g. Alt-Space to focus).
-- Use Raycast or another macOS tool to bind Alt-Space to activate WezTerm.

-- Keybindings (tab/pane operations delegated to zellij)
local act = wezterm.action
config.keys = {
  { key = "Backspace", mods = "CMD", action = act.SendString("\x15") },       -- Cmd-Delete: kill to line start
  { key = "z",         mods = "CMD", action = act.SendString("\x1f") },        -- Cmd-Z: undo
  { key = "k",         mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
  { key = " ",         mods = "CMD|SHIFT", action = act.QuickSelect },
  { key = "q",         mods = "CMD", action = wezterm.action_callback(function(window, pane)
    local ws = resurrect.workspace_state.get_workspace_state()
    resurrect.state_manager.save_state(ws)
    resurrect.state_manager.write_current_state(ws.workspace, "workspace")
    window:perform_action(act.QuitApplication, pane)
  end) },
  -- Disable default tab/pane shortcuts (zellij handles these)
  { key = "t",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "t",         mods = "CMD|SHIFT", action = act.DisableDefaultAssignment },
  { key = "w",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "d",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "d",         mods = "CMD|SHIFT", action = act.DisableDefaultAssignment },
  { key = "]",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "[",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "1",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "2",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "3",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "4",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "5",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "6",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "7",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "8",         mods = "CMD",       action = act.DisableDefaultAssignment },
  { key = "9",         mods = "CMD",       action = act.DisableDefaultAssignment },
}

-- Session resurrect: periodic save + restore on startup
resurrect.state_manager.periodic_save({ interval_seconds = 600, save_workspaces = true })
wezterm.on("resurrect.state_manager.periodic_save.finished", function()
  resurrect.state_manager.write_current_state(wezterm.mux.get_active_workspace(), "workspace")
end)
wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

return config
