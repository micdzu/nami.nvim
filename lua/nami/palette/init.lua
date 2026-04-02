---@module "nami.palette"
---
--- Palette pipeline for Nami — the ONLY public entry point for palette construction.
---
--- ---------------------------------------------------------
--- DESIGN OVERVIEW
--- ---------------------------------------------------------
---
--- Nami separates concerns into four stages:
---
---   raw color definition  → base.lua
---   structural variation  → variants.lua
---   semantic meaning      → semantic.lua
---   perceptual correction → utils.lua
---
--- IMPORTANT:
---   Accessibility is NOT a separate post-processing pass.
---   It is embedded inside the semantic layer via utils.ensure().
---
--- This ensures:
---   - contrast is role-aware (definition ≠ comment threshold)
---   - palette identity is preserved when colors are close enough
---   - correction happens only when necessary, only where needed
---
--- ---------------------------------------------------------
--- PIPELINE
--- ---------------------------------------------------------
---
---   base → overrides → variants → semantic (→ accessibility)
---
---   1. base
---      Raw canonical hex colors (non-semantic, not variant-specific)
---
---   2. overrides
---      User palette overrides injected early (opts.palette)
---
---   3. variants
---      Light/dark structural transformation + UI layer derivation
---      (bg_light, selection, cursorline)
---
---   4. semantic
---      Maps raw colors → semantic roles AND applies:
---        - OKLCH-based contrast correction
---        - preserve threshold (soft enforcement)
---        - chroma shaping
---
--- ---------------------------------------------------------
--- USER CONTROL
--- ---------------------------------------------------------
---
---   opts.palette       → raw color overrides (stage 1)
---   opts.variant       → "dark" | "light" | nil (auto from vim.o.background)
---   opts.semantic      → semantic role remapping (stage 4)
---   opts.accessibility → contrast tuning (embedded in stage 4)
---
--- Example — enable OKLCH contrast correction:
---
---   accessibility = {
---     enabled  = true,
---     contrast = 4.5,   -- WCAG AA target
---     preserve = 0.9,   -- accept colors within 90% of target
---   }
---

local M = {}

---Build and return the resolved semantic palette.
---
---@param opts table
---@return table S Semantic palette
function M.build(opts)
	opts = opts or {}

	local base     = require("nami.palette.base")
	local variants = require("nami.palette.variants")
	local semantic = require("nami.palette.semantic")

	-------------------------------------------------
	-- 1. BASE + USER PALETTE OVERRIDES
	-- User overrides are injected early so all downstream
	-- stages (variants, semantic, accessibility) see them.
	-------------------------------------------------

	local c = vim.tbl_deep_extend("force", base.get(), opts.palette or {})

	-------------------------------------------------
	-- 2. VARIANTS (STRUCTURAL TRANSFORMATIONS)
	-- Applies light/dark switching and derives:
	--   bg_light, selection, cursorline
	-------------------------------------------------

	c = variants.apply(c, opts.variant, opts)

	-------------------------------------------------
	-- 3. SEMANTIC (MEANING + ACCESSIBILITY)
	-- Maps raw colors → semantic roles AND applies
	-- OKLCH-based contrast correction with preserve threshold.
	-------------------------------------------------

	local S = semantic.build(c, opts.semantic or {}, opts)

	return S
end

return M
