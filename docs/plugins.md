# Plugins

Nami integrates plugins using the same semantic system as code.

The goal is not full coverage. It is consistency.

---

## Philosophy

Plugins should feel native.

They should not introduce new colors or visual noise.

Instead, they reuse Nami’s semantic roles.

---

## How Plugins Are Styled

Plugin elements are mapped to semantic roles:

- structure → definition
- data → string
- matches / highlights → constant
- metadata / secondary info → comment

UI elements use background layers:

- selections → `selection`
- panels → `bg_light`

This keeps plugins visually consistent with code.

---

## Supported Plugins

### Fuzzy Finders

- telescope.nvim
- fzf-lua

### Completion

- nvim-cmp
- blink.cmp

### Git

- gitsigns.nvim

### File Explorer

- neo-tree.nvim

### UI

- which-key.nvim
- noice.nvim
- nvim-notify

### Statusline

- lualine.nvim

---

## Lualine Example

```lua
require("lualine").setup({
  options = {
    theme = require("nami").lualine_theme(),
  },
})
```

---

## Missing a Plugin?

Nami is intentionally minimal.

If something looks off:

- open an issue
- or override highlights

```lua
overrides = {
  MyPluginBorder = { fg = "#839DF4" },
}
```

---

## Design Principle

Plugins should not look “themed”.

They should look like part of the editor.
