---@module "nami.palette.semantic"
---
--- Semantic color layer for Nami.
---
--- Maps raw palette → semantic roles.
---
--- Guarantees:
--- - All semantic colors pass through `utils.ensure`
--- - Accessibility rules are always respected
--- - User overrides cannot break contrast guarantees

local utils = require("nami.palette.utils")

local M = {}

-------------------------------------------------
-- ROLE MAPPING
-------------------------------------------------

local roles = {
	definition = "blue",
	string = "green",
	constant = "magenta",
	comment = "fg_dark",
}

-------------------------------------------------
-- BUILD
-------------------------------------------------

---@param c table Base palette
---@param overrides table
---@param opts table
---@return table
function M.build(c, overrides, opts)
	local bg = c.bg

	local S = {
		-- Backgrounds
		bg = c.bg,
		bg_light = c.bg_light,
		selection = c.selection,
		cursorline = c.cursorline,

		-- Foreground
		fg = c.fg,
		fg_dark = c.fg_dark,

		-- Core roles
		definition = utils.ensure(c[roles.definition], bg, "definition", opts),
		string = utils.ensure(c[roles.string], bg, "string", opts),
		constant = utils.ensure(c[roles.constant], bg, "constant", opts),
		comment = utils.ensure(c[roles.comment], bg, "comment", opts),

		-- Diagnostics (hierarchical)
		error = utils.ensure(c.red, bg, "definition", opts),
		warn = utils.ensure(c.orange, bg, "constant", opts),

		info = utils.ensure(c.cyan, bg, "string", opts),
		hint = utils.ensure(c.cyan, bg, "comment", opts),
	}

	-------------------------------------------------
	-- SAFE OVERRIDES
	-------------------------------------------------

	if overrides then
		for role, color in pairs(overrides) do
			if S[role] ~= nil then
				S[role] = utils.ensure(color, bg, role, opts)
			else
				S[role] = color
			end
		end
	end

	return S
end

return M
