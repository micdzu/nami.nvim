# Philosophy

Nami is a semantic-first colorscheme built around a simple question:

> What should color _do_ in code?

---

## Core Idea

Most themes assign colors to many syntax categories.

Nami does not.

It reduces everything to **four semantic roles**:

- definition → structure
- string → data
- constant → fixed values
- comment → context

Everything else stays neutral.

Color is not removed. It is made **intentional**.

---

## Cognitive Model

Nami is not designed to make syntax more visible.

It is designed to make structure easier to recognize.

Color is not information. It is a guide.

After some time:

- definitions become anchors
- strings become data blocks
- constants become signals
- comments fade into context

You stop parsing tokens. You start perceiving structure.

---

## What Makes Nami Different

- Very small semantic palette
- Strong meaning per color
- Minimal visual noise
- Warm, consistent identity

Most tokens share the same foreground.

Color appears only where it carries meaning.

---

## Strict Mode

Nami can operate in a fully minimal form:

```lua
strict = true
```

Strict mode removes all stylistic emphasis:

- no bold
- no italic
- no decorative highlighting

Only semantic color remains.

> This is Nami in its purest form.

---

## Semantic Overrides

Meaning is not fixed.

You can redefine semantic roles:

```lua
semantic = {
  definition = "#89B4FA",
  string     = "#A6E3A1",
  constant   = "#F5C2E7",
  comment    = "#6C7086",
}
```

This propagates across:

- TreeSitter
- LSP
- plugins
- UI elements

You are not recoloring syntax. You are redefining meaning.

---

## Comparison

### Nord

Calm and consistent, but often too uniform. Structure can disappear into the
same palette.

**Nami:** stronger semantic separation.

---

### Tokyo Night

Expressive and vibrant, but visually dense.

**Nami:** fewer colors, less noise, more focus.

---

### Rosé Pine

Warm and soft, with a gentle palette.

**Nami:** more restrained, more structural.

---

Nami is designed to fade into the background— so structure can come forward.

🌊
