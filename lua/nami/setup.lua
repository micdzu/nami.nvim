---@module "nami.setup"
---
--- Core rendering engine for Nami.
---
--- FIXES:
--- - Debug mode no longer mutates original groups table (uses deep copy)
--- - Added validation for user overrides
--- - Proper error handling in highlight application

local M = {}

-------------------------------------------------
-- STATE
-------------------------------------------------

local state = {
	opts = nil,
	palette = nil,
	loaded = false,
}

-------------------------------------------------
-- DEFAULT CONFIGURATION
-------------------------------------------------

local defaults = {
	variant = nil,
	transparent = false,
	float_transparent = false,

	styles = {
		comments = { italic = true },
		keywords = {},
		definitions = {},
		types = {},
		namespaces = {},
		parameters = {},
	},

	palette = {},
	semantic = {},
	overrides = {},

	terminal_colors = true,
	debug = false,

	accessibility = {
		enabled = false,
		contrast = 4.5,
		preserve = 0.9,
	},

	strict = false,
}

-------------------------------------------------
-- PUBLIC
-------------------------------------------------

function M.get_state()
	return state
end

-------------------------------------------------
-- INTERNAL: APPLY HIGHLIGHTS
-------------------------------------------------

---Apply a table of highlight group specs.
---Explicitly breaks all existing links on every group.
---
---@param groups table<string, table>
local function apply_highlights(groups)
	for name, spec in pairs(groups) do
		if spec.link then
			vim.api.nvim_set_hl(0, name, { link = spec.link })
		else
			-- Break any pre-existing link and set all attributes explicitly.
			local ok, err = pcall(vim.api.nvim_set_hl, 0, name, vim.tbl_extend("force", spec, { link = nil }))
			if not ok and state.opts and state.opts.debug then
				vim.notify(string.format("[nami] failed to set highlight %s: %s", name, err), vim.log.levels.WARN)
			end
		end
	end
end

-------------------------------------------------
-- VALIDATION
-------------------------------------------------

---Validate user overrides to prevent cryptic errors later.
---@param overrides table
---@return boolean valid
local function validate_overrides(overrides)
	if type(overrides) ~= "table" then
		return true -- nil is fine
	end

	for name, spec in pairs(overrides) do
		if type(spec) ~= "table" then
			vim.notify(
				string.format("[nami] invalid override for '%s': expected table, got %s", name, type(spec)),
				vim.log.levels.ERROR
			)
			return false
		end
		if spec.fg and type(spec.fg) == "string" and not spec.fg:match("^#%x%x%x%x%x%x$") and spec.fg ~= "NONE" then
			vim.notify(
				string.format("[nami] invalid fg color in override '%s': '%s'", name, spec.fg),
				vim.log.levels.WARN
			)
		end
		if spec.bg and type(spec.bg) == "string" and not spec.bg:match("^#%x%x%x%x%x%x$") and spec.bg ~= "NONE" then
			vim.notify(
				string.format("[nami] invalid bg color in override '%s': '%s'", name, spec.bg),
				vim.log.levels.WARN
			)
		end
	end
	return true
end

-------------------------------------------------
-- SETUP
-------------------------------------------------

---Build the palette, generate highlight groups, and apply them.
---
---@param opts table|nil
---@return table palette The resolved semantic palette
function M.setup(opts)
	opts = vim.tbl_deep_extend("force", defaults, opts or {})

	-------------------------------------------------
	-- STRICT MODE
	-------------------------------------------------

	if opts.strict then
		opts.styles = {
			comments = {},
			keywords = {},
			definitions = {},
			types = {},
			namespaces = {},
			parameters = {},
		}
	end

	-------------------------------------------------
	-- VALIDATION
	-------------------------------------------------

	if not validate_overrides(opts.overrides) then
		vim.notify("[nami] invalid overrides provided, using empty overrides", vim.log.levels.WARN)
		opts.overrides = {}
	end

	-------------------------------------------------
	-- BUILD PIPELINE
	-------------------------------------------------

	local palette = require("nami.palette").build(opts)

	-- FIX: Check if palette built successfully
	if not palette or not palette.bg then
		vim.notify("[nami] failed to build palette", vim.log.levels.ERROR)
		return {}
	end

	local groups = require("nami.groups").get(palette, opts)

	vim.g.colors_name = "nami"

	-------------------------------------------------
	-- DEBUG VISUALIZATION
	-- FIX: Use deep copy to avoid mutating original groups
	-------------------------------------------------

	if opts.debug then
		-- Clone groups to avoid polluting the original table
		groups = vim.deepcopy(groups)
		for _, g in pairs(groups) do
			if g.fg == palette.definition then
				g.bg = "#000033"
			elseif g.fg == palette.string then
				g.bg = "#003300"
			elseif g.fg == palette.constant then
				g.bg = "#330033"
			end
		end
	end

	-------------------------------------------------
	-- APPLY HIGHLIGHTS
	-------------------------------------------------

	apply_highlights(groups)

	-------------------------------------------------
	-- TERMINAL COLORS
	-------------------------------------------------

	if opts.terminal_colors then
		local S = palette
		vim.g.terminal_color_0 = S.bg
		vim.g.terminal_color_1 = S.error
		vim.g.terminal_color_2 = S.string
		vim.g.terminal_color_3 = S.warn
		vim.g.terminal_color_4 = S.definition
		vim.g.terminal_color_5 = S.constant
		vim.g.terminal_color_6 = S.info
		vim.g.terminal_color_7 = S.fg
		vim.g.terminal_color_8 = S.fg_dark
		vim.g.terminal_color_9 = S.error
		vim.g.terminal_color_10 = S.string
		vim.g.terminal_color_11 = S.warn
		vim.g.terminal_color_12 = S.definition
		vim.g.terminal_color_13 = S.constant
		vim.g.terminal_color_14 = S.info
		vim.g.terminal_color_15 = S.fg
	end

	-------------------------------------------------
	-- STATE
	-------------------------------------------------

	state.opts = opts
	state.palette = palette
	state.loaded = true

	return palette
end

return M
