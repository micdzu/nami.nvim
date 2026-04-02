# 🌊 Nami.nvim

> A calm, semantic-first Neovim colorscheme with perceptual balance.

---

## 🌊 Origin

Nami started as a response to a tension I kept running into.

Some themes felt too uniform — structure faded into a blur. Others were
expressive, but visually dense — like a _fruit salad on slate_.

I wanted something in between:

- minimal, but not flat
- expressive, but not noisy

Nami is that middle ground.

> **Color should communicate meaning — not decoration.**

---

## ✨ Philosophy

Most themes color _syntax_. Nami colors _semantics_.

It highlights only what carries meaning. Everything else stays neutral.

---

## 🧠 Semantic Model

Nami uses **only four roles**:

| Role         | Meaning                                |
| ------------ | -------------------------------------- |
| `definition` | structure — functions, types, keywords |
| `string`     | text — string literals                 |
| `constant`   | values — numbers, booleans, constants  |
| `comment`    | non-code — comments                    |

Everything else is neutral.

> Fewer categories → stronger signal.

---

## 👁 Perceptual Design

Nami is not just semantic — it is **perceptually tuned**.

Each role is designed with intentional contrast, not just different colors.

---

### 🎚 Visual hierarchy

| Role         | Visual weight     |
| ------------ | ----------------- |
| `definition` | strongest         |
| `string`     | distinct but soft |
| `constant`   | noticeable accent |
| `comment`    | recedes           |

This creates a natural reading flow:

> **structure → values → text → noise**

---

### ⚖️ Balanced contrast

Nami avoids both extremes:

- ❌ high-contrast “neon” themes (fatiguing)
- ❌ flat low-contrast themes (hard to scan)

Instead, it uses:

> **balanced contrast tuned for long sessions**

---

### 🧠 Why this works

Your brain doesn’t read code linearly — it scans for structure.

Nami supports that by:

- emphasizing definitions (shape of the program)
- softening comments (reduce noise)
- keeping values distinct but not dominant

---

## 🎯 Design Principles

### Semantic over syntactic

Different languages, same meaning → same color.

```lua
-- Lua
local x = 42

# Python
x = 42
```

---

### Fewer colors, stronger signal

- no rainbow palettes
- no category explosion
- no visual noise

---

### Explicit over automatic

- no runtime magic
- no hidden mappings
- no dynamic behavior

Everything is:

- explicit
- predictable
- readable

---

### Consistency across languages

A function always looks like a function. A constant always looks like a
constant.

---

### UI is secondary

Plugins do not introduce new meaning.

They reuse the same semantic roles.

---

## 🎨 Color Roles

Dark variant:

```text
definition = #89B4FA
string     = #A6E3A1
constant   = #F5C2E7
comment    = #6C7086
```

These are tuned for:

- perceptual balance
- long-session readability
- stable contrast

---

## ✨ Features

- 🎨 **Semantic-first** — strict 4-role system
- 👁 **Perceptual design** — balanced contrast & visual hierarchy
- 🌊 **Minimal** — neutral base, low noise
- 🔍 **Modern** — TreeSitter + LSP semantic tokens
- 🌗 **Dark + light variants**
- ♿ **Accessibility option** — adaptive contrast (OKLCH-based)
- ⚡ **Lightweight** — deterministic, no runtime overhead
- 🔌 **Plugin support** (Telescope, cmp, gitsigns, lualine)

---

## 🧠 Adaptive Contrast System

Nami includes a perceptual contrast system based on OKLCH.

It applies **soft correction**:

- preserves original colors when possible
- adjusts only when contrast is too low
- keeps hue stable, adjusts luminance

```lua
accessibility = {
  enabled = false,
  contrast = 4.5,
  preserve = 0.9,
}
```

---

## 🚀 Installation

### lazy.nvim

```lua
{
  "micdzu/nami.nvim",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("nami")
  end,
}
```

---

## ⚙️ Configuration

```lua
vim.g.nami_config = {
  variant = "dark",

  transparent = false,
  terminal_colors = true,

  styles = {
    comments = { italic = true },
    keywords = { bold = true },
  },

  semantic = {},
  overrides = {},

  accessibility = {
    enabled = false,
    contrast = 4.5,
    preserve = 0.9,
  },

  strict = false,
}
```

---

## 🧘 Strict Mode

```lua
strict = true
```

Removes all non-semantic styling:

- no bold
- no italics
- no decoration

> Only meaning remains.

---

## ⚡ Example

```ts
class User {
  name: string;

  getName(): string {
    return "John";
  }
}
```

- `User`, `getName` → definition
- `"John"` → string
- everything else → neutral

---

## 💬 Final Thought

> A colorscheme should not compete with your code.

Nami stays out of the way — so your code can speak.

---

## 📄 License

MIT
