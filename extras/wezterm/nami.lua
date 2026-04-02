-- Nami Theme for WezTerm
-- https://github.com/micdzu/nami.nvim

local M = {}

M.dark = {
  foreground = "#C9C2FF",
  background = "#1A1732",
  cursor_bg = "#C9C2FF",
  cursor_fg = "#1A1732",
  cursor_border = "#C9C2FF",
  selection_fg = "#C9C2FF",
  selection_bg = "#2F2A55",
  scrollbar_thumb = "#2F2A55",
  split = "#6B6796",
  ansi = {
    "#1A1732", -- black
    "#E87A98", -- red
    "#A7D494", -- green
    "#F0A07A", -- yellow
    "#8AA2F0", -- blue
    "#CF8EEC", -- magenta
    "#7AD2CE", -- cyan
    "#C9C2FF", -- white
  },
  brights = {
    "#6B6796", -- bright black
    "#E87A98", -- bright red
    "#A7D494", -- bright green
    "#F0A07A", -- bright yellow
    "#8AA2F0", -- bright blue
    "#CF8EEC", -- bright magenta
    "#7AD2CE", -- bright cyan
    "#D8D2FF", -- bright white
  },
  indexed = {
    [16] = "#F0A07A",
    [17] = "#C686B2",
  },
  tab_bar = {
    background = "#1A1732",
    active_tab = {
      bg_color = "#2F2A55",
      fg_color = "#C9C2FF",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "#211E3F",
      fg_color = "#6B6796",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab_hover = {
      bg_color = "#2F2A55",
      fg_color = "#C9C2FF",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    new_tab = {
      bg_color = "#211E3F",
      fg_color = "#6B6796",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    new_tab_hover = {
      bg_color = "#2F2A55",
      fg_color = "#C9C2FF",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
  },
}

M.light = {
  foreground = "#2A254A",
  background = "#F0E8FF",
  cursor_bg = "#2A254A",
  cursor_fg = "#F0E8FF",
  cursor_border = "#2A254A",
  selection_fg = "#2A254A",
  selection_bg = "#C8BFF0",
  scrollbar_thumb = "#C8BFF0",
  split = "#665E96",
  ansi = {
    "#2A254A", -- black
    "#A2556A", -- red
    "#647F58", -- green
    "#A87055", -- yellow
    "#59699C", -- blue
    "#865C99", -- magenta
    "#497E7B", -- cyan
    "#F0E8FF", -- white
  },
  brights = {
    "#665E96", -- bright black
    "#A2556A", -- bright red
    "#647F58", -- bright green
    "#A87055", -- bright yellow
    "#59699C", -- bright blue
    "#865C99", -- bright magenta
    "#497E7B", -- bright cyan
    "#F5F0FF", -- bright white (Nami palette friendly)
  },
  indexed = {
    [16] = "#A87055",
    [17] = "#865C99",
  },
  tab_bar = {
    background = "#F0E8FF",
    active_tab = {
      bg_color = "#C8BFF0",
      fg_color = "#2A254A",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "#E6DEF7",  -- Standardized to palette.lua value
      fg_color = "#665E96",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab_hover = {
      bg_color = "#C8BFF0",
      fg_color = "#2A254A",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    new_tab = {
      bg_color = "#E6DEF7",  -- Standardized to palette.lua value
      fg_color = "#665E96",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    new_tab_hover = {
      bg_color = "#C8BFF0",
      fg_color = "#2A254A",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
  },
}

return M
