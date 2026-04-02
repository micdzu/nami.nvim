# Nami Terminal Extras

Terminal emulator themes and tool configurations matching the Nami colorscheme.

These files allow you to use Nami's semantic color palette (lavender, green, magenta, blue) outside of Neovim—for a consistent terminal environment.

## Available Themes

### Terminal Emulators

| Terminal | Dark | Light | Setup |
|----------|------|-------|-------|
| [Alacritty](https://alacritty.org/) | [nami_dark.toml](alacritty/nami_dark.toml) | [nami_light.toml](alacritty/nami_light.toml) | Copy to `~/.config/alacritty/` |
| [Foot](https://codeberg.org/dnkl/foot) | [nami_dark.ini](foot/nami_dark.ini) | [nami_light.ini](foot/nami_light.ini) | Copy to `~/.config/foot/` |
| [Kitty](https://sw.kovidgoyal.net/kitty/) | [nami_dark.conf](kitty/nami_dark.conf) | [nami_light.conf](kitty/nami_light.conf) | Copy to `~/.config/kitty/` |
| [WezTerm](https://wezfurlong.org/wezterm/) | [nami.lua](wezterm/nami.lua) | [nami.lua](wezterm/nami.lua) | Require in config |

### CLI Tools

| Tool | File | Setup |
|------|------|-------|
| [Tmux](https://github.com/tmux/tmux) | [nami_dark.conf](tmux/nami_dark.conf) / [nami_light.conf](tmux/nami_light.conf) | Source in `.tmux.conf` |
| [FZF](https://github.com/junegunn/fzf) | [nami_dark.opts](fzf/nami_dark.opts) / [nami_light.opts](fzf/nami_light.opts) | Source in shell rc |
| [bat](https://github.com/sharkdp/bat) | [nami.tmTheme](bat/nami.tmTheme) | Copy to `~/.config/bat/themes/`, run `bat cache --build` |
| [delta](https://github.com/dandavison/delta) | [nami.gitconfig](delta/nami.gitconfig) | Include in `~/.gitconfig` or use with bat theme |
| [lazygit](https://github.com/jesseduffield/lazygit) | [nami.yml](lazygit/nami.yml) | Copy to `~/.config/lazygit/config.yml` |
| [zellij](https://zellij.dev/) | [nami.kdl](zellij/nami.kdl) | Copy to `~/.config/zellij/themes/` or include in config |
| [starship](https://starship.rs/) | [nami.toml](starship/nami.toml) | Copy to `~/.config/starship.toml` |
| [yazi](https://yazi-rs.github.io/) | [nami.toml](yazi/nami.toml) | Copy to `~/.config/yazi/theme.toml` |

## Quick Setup

### Alacritty

```bash
mkdir -p ~/.config/alacritty
cp extras/alacritty/nami_dark.toml ~/.config/alacritty/nami.toml
```

Then import in `~/.config/alacritty/alacritty.toml`:

```toml
import = ["~/.config/alacritty/nami.toml"]
```

### Foot (Wayland native terminal)

```bash
mkdir -p ~/.config/foot
cp extras/foot/nami_dark.ini ~/.config/foot/nami.ini
```

Then include in `~/.config/foot/foot.ini`:

```ini
include=~/.config/foot/nami.ini
```

Or paste the colors directly into your `[colors]` section.

### Kitty

```bash
mkdir -p ~/.config/kitty
cp extras/kitty/nami_dark.conf ~/.config/kitty/nami.conf
```

Then include in `~/.config/kitty/kitty.conf`:

```
include nami.conf
```

### WezTerm

Require the theme in your `~/.config/wezterm/wezterm.lua`:

```lua
-- If nami.lua is in your wezterm config dir:
local nami = require("nami")

-- OR if using the full path:
local nami = dofile("/path/to/extras/wezterm/nami.lua")

return {
  colors = nami.dark, -- or nami.light
  -- ... rest of config
}
```

### Tmux

Source the theme in your `~/.tmux.conf`:

```bash
source-file ~/.config/tmux/nami_dark.conf
```

Or copy the content directly into your config.

### FZF

Load the theme in your shell config:

```bash
# ~/.bashrc or ~/.zshrc
export FZF_DEFAULT_OPTS="$(cat ~/.config/fzf/nami_dark.opts)"
```

Or set the colors manually:

```bash
export FZF_DEFAULT_OPTS='
  --color=fg:#C9C2FF,bg:#1A1732,hl:#8AA2F0
  --color=fg+:#C9C2FF,bg+:#2F2A55,hl+:#8AA2F0
  --color=info:#6B6796,prompt:#CF8EEC,pointer:#CF8EEC
  --color=marker:#A7D494,spinner:#7AD2CE,header:#6B6796
'
```

### bat (syntax highlighting)

```bash
mkdir -p ~/.config/bat/themes
cp extras/bat/nami.tmTheme ~/.config/bat/themes/
bat cache --build
export BAT_THEME="nami"
```

### delta (Git diff viewer)

**Option 1: Use with bat theme (recommended)**

```bash
git config --global core.pager "delta --bat-theme=nami"
```

**Option 2: Use standalone config**

```bash
cat extras/delta/nami.gitconfig >> ~/.gitconfig
```

### lazygit (Terminal Git UI)

```bash
mkdir -p ~/.config/lazygit
cp extras/lazygit/nami.yml ~/.config/lazygit/config.yml
```

Or merge with your existing config.

### zellij (Terminal workspace)

```bash
mkdir -p ~/.config/zellij/themes
cp extras/zellij/nami.kdl ~/.config/zellij/themes/
```

Then in `~/.config/zellij/config.kdl`:

```kdl
theme "nami"
```

### starship (Cross-shell prompt)

```bash
cp extras/starship/nami.toml ~/.config/starship.toml
```

Or source from your existing starship config.

### yazi (Terminal file manager)

```bash
mkdir -p ~/.config/yazi
cp extras/yazi/nami.toml ~/.config/yazi/theme.toml
```

## Color Reference

### Dark Variant

| Color | Hex | ANSI | Usage |
|-------|-----|------|-------|
| Background | `#1A1732` | 0 | Terminal background |
| Foreground | `#C9C2FF` | 15 | Default text |
| Selection | `#2F2A55` | — | Selected text bg |
| Black | `#1A1732` | 0 | Background |
| Red | `#E87A98` | 1 | Errors, deletions |
| Green | `#A7D494` | 2 | Success, additions |
| Yellow | `#F0A07A` | 3 | Warnings |
| Blue | `#8AA2F0` | 4 | Links, functions |
| Magenta | `#CF8EEC` | 5 | Constants |
| Cyan | `#7AD2CE` | 6 | Info, strings |
| White | `#C9C2FF` | 7 | Foreground |
| Bright Black | `#6B6796` | 8 | Comments, muted |
| Bright Red | `#E87A98` | 9 | Bright errors |
| Bright Green | `#A7D494` | 10 | Bright strings |
| Bright Yellow | `#F0A07A` | 11 | Bright warnings |
| Bright Blue | `#8AA2F0` | 12 | Bright definitions |
| Bright Magenta | `#CF8EEC` | 13 | Bright constants |
| Bright Cyan | `#7AD2CE` | 14 | Bright info |
| Bright White | `#D8D2FF` | 15 | Bright text |

### Light Variant

| Color | Hex | ANSI | Usage |
|-------|-----|------|-------|
| Background | `#F0E8FF` | 15 | Terminal background |
| Foreground | `#2A254A` | 0 | Default text |
| Selection | `#C8BFF0` | — | Selected text bg |
| Black | `#2A254A` | 0 | Foreground |
| Red | `#A2556A` | 1 | Errors |
| Green | `#647F58` | 2 | Success |
| Yellow | `#A87055` | 3 | Warnings |
| Blue | `#59699C` | 4 | Links |
| Magenta | `#865C99` | 5 | Constants |
| Cyan | `#497E7B` | 6 | Info |
| White | `#F0E8FF` | 7 | Background |
| Bright Black | `#665E96` | 8 | Comments |
| Bright Red | `#A2556A` | 9 | Bright errors |
| Bright Green | `#647F58` | 10 | Bright strings |
| Bright Yellow | `#A87055` | 11 | Bright warnings |
| Bright Blue | `#59699C` | 12 | Bright definitions |
| Bright Magenta | `#865C99` | 13 | Bright constants |
| Bright Cyan | `#497E7B` | 14 | Bright info |
| Bright White | `#F5F0FF` | 15 | Bright text |

### Semantic Mapping (Nami's 4-Color Philosophy)

| Semantic | Color | Hex | Applied To |
|----------|-------|-----|------------|
| Comments | Lavender (muted) | `#6B6796` / `#665E96` | Inactive items, hidden files, borders |
| Strings | Green | `#A7D494` / `#647F58` | Success, additions, media files |
| Constants | Magenta | `#CF8EEC` / `#865C99` | Fixed values, git branches, enums |
| Definitions | Blue | `#8AA2F0` / `#59699C` | Functions, directories, types, active items |

## Missing your terminal?

Don't see your terminal emulator or tool? Use the Lua API to extract colors from the main plugin:

```lua
local palette = require("nami").get_palette("dark")
print(string.format("Background: %s", palette.bg))
print(string.format("Foreground: %s", palette.fg))
print(string.format("Blue: %s", palette.func))  -- definitions
```

Or reference the hex values directly from the table above.

## Contributing

Have a terminal config to add? PRs welcome at [github.com/micdzu/nami.nvim](https://github.com/micdzu/nami.nvim).
