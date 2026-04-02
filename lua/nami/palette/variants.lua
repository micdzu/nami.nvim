---@module "nami.palette.variants"
---
--- Variant transformations for Nami.
---
--- FIXES:
--- - Light palette colors adjusted for better contrast (darker semantic colors)
--- - Proper handling of UI layers via derive_bg_adaptive fix

local M = {}
local utils = require("nami.palette.utils")

-------------------------------------------------
-- LIGHT VARIANT (FULL PALETTE OVERRIDE)
-------------------------------------------------

local light_palette = {
	-- Light variant with adjusted colors for better contrast
	-- Background: warm paper tone
	bg = "#E2DFEA",
	fg = "#28253D",
	fg_dark = "#5F5A85", -- Darkened from #7F7AA8 for better contrast

	-- Darker semantic source colors for light backgrounds
	red = "#C53B5E", -- Darkened for error visibility
	orange = "#B86A3D", -- Darkened for warning visibility
	green = "#5A8A4A", -- Darkened from #7FB36A
	cyan = "#3A8A85", -- Darkened from #5FB8B2
	blue = "#3D4FC0", -- Darkened from #5A72D4 for better definition contrast
	magenta = "#8A3ABF", -- Darkened from #B06AD9
}

-------------------------------------------------
-- APPLY VARIANT
-------------------------------------------------

---@param c table Base palette
---@param variant "light"|"dark"|nil
---@param opts table
---@return table
function M.apply(c, variant, opts)
	if variant == "light" then
		c = vim.tbl_deep_extend("force", c, light_palette)
	end

	-------------------------------------------------
	-- DERIVE UI LAYERS (ALWAYS)
	-- Now uses fixed derive_bg_adaptive that handles light/dark correctly
	-------------------------------------------------

	local layers = utils.derive_bg_adaptive(c.bg, opts)

	-- Merge: user-provided values take precedence
	c.bg_light = (opts.palette and opts.palette.bg_light) or layers.bg_light
	c.selection = (opts.palette and opts.palette.selection) or layers.selection
	c.cursorline = (opts.palette and opts.palette.cursorline) or layers.cursorline

	return c
end

return M
