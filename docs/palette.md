# Palette

Nami’s palette is built around a single principle:

> Color is used for meaning—not decoration.

---

## Semantic Roles

Nami uses four roles:

| Role       | Meaning      |
| ---------- | ------------ |
| definition | structure    |
| string     | data         |
| constant   | fixed values |
| comment    | context      |

All other text remains neutral.

---

## Base Palette

These are the canonical colors used to derive the theme.

### Dark Variant

| Role       | Color   |
| ---------- | ------- |
| Background | #1A1732 |
| Foreground | #C9C2FF |
| Comment    | #746FA3 |
| String     | #9FD88A |
| Constant   | #D596F0 |
| Definition | #839DF4 |

---

### Light Variant

| Role       | Color   |
| ---------- | ------- |
| Background | #E2DFEA |
| Foreground | #28253D |
| Comment    | #7F7AA8 |
| String     | #7FB36A |
| Constant   | #B06AD9 |
| Definition | #5A72D4 |

---

## Perceptual System

Nami uses a perceptual color model (OKLCH) to ensure readability.

When accessibility is enabled:

- contrast is adjusted toward a target
- hue is preserved
- chroma is gently shaped

Colors are only changed when necessary.

---

## Adaptive Contrast

Nami applies **soft contrast correction**:

- colors are preserved if they are _close enough_
- only low-contrast colors are adjusted
- palette identity remains stable

```lua
accessibility = {
  enabled = false,
  contrast = 4.5,
  preserve = 0.9,
}
```

### Preserve Threshold

| Value | Behavior                |
| ----- | ----------------------- |
| 1.0   | strict WCAG enforcement |
| 0.9   | balanced (recommended)  |
| 0.7   | aesthetic-first         |
| 0.0   | always adjust           |

---

## Why OKLCH?

Traditional RGB adjustments distort color identity.

OKLCH allows:

- predictable lightness changes
- stable hue
- perceptual consistency

This is essential for a semantic color system.

---

## UI Layers

Background layers are derived from the base background:

- `bg_light` → subtle surfaces
- `selection` → active regions
- `cursorline` → focus

These are generated automatically to maintain consistency.

---

## Customization

### Override base palette

```lua
palette = {
  blue = "#82aaff",
}
```

### Override semantic roles (recommended)

```lua
semantic = {
  definition = "#89B4FA",
}
```

---

Nami is not about having many colors.

It is about using fewer colors—better.
