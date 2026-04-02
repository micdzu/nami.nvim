---@module "nami.groups"
---
--- Highlight group aggregator for Nami.
---
--- FIXES:
--- - Unified API: all modules now receive (S, bg, bg_float, opts)
--- - Proper error handling with fallback groups
--- - User overrides applied correctly last

local M = {}

-------------------------------------------------
-- INTERNAL HELPERS
-------------------------------------------------

---Safely require a module and call its `get` function.
---@param name string Lua module path
---@param opts table|nil Used for debug flag
---@param ... any Arguments forwarded to mod.get()
---@return table groups (empty on failure)
local function load(name, opts, ...)
	local ok, mod = pcall(require, name)

	if not ok then
		if opts and opts.debug then
			vim.notify(string.format("[nami] failed to require '%s': %s", name, tostring(mod)), vim.log.levels.WARN)
		end
		return {}
	end

	if type(mod.get) ~= "function" then
		if opts and opts.debug then
			vim.notify(string.format("[nami] module '%s' has no get() function", name), vim.log.levels.WARN)
		end
		return {}
	end

	local ok2, result = pcall(mod.get, ...)
	if not ok2 then
		if opts and opts.debug then
			vim.notify(string.format("[nami] error in '%s'.get(): %s", name, tostring(result)), vim.log.levels.WARN)
		end
		return {}
	end

	if type(result) ~= "table" then
		return {}
	end

	return result
end

---Merge two highlight group tables (new wins on conflict).
---@param base table
---@param new table
---@return table
local function merge(base, new)
	return vim.tbl_deep_extend("force", base, new)
end

-------------------------------------------------
-- PUBLIC
-------------------------------------------------

---Build and return all highlight groups for the current configuration.
---
---@param S table Semantic palette
---@param opts table User options
---@return table<string, table> groups
function M.get(S, opts)
	local groups = {}

	-------------------------------------------------
	-- BACKGROUND RESOLUTION (FOR UI / PLUGINS)
	-- Resolve transparency settings once here
	-------------------------------------------------

	local bg = opts.transparent and "NONE" or S.bg

	local bg_float
	if opts.transparent and opts.float_transparent then
		bg_float = "NONE"
	else
		bg_float = S.bg_light
	end

	local styles = opts.styles or {}

	-------------------------------------------------
	-- CORE MODULES (UNIFIED API: get(S, bg, bg_float, opts))
	--
	-- All group modules now receive the resolved backgrounds
	-- to handle transparency correctly.
	-------------------------------------------------

	groups = merge(groups, load("nami.groups.editor", opts, S, bg, bg_float, opts))
	groups = merge(groups, load("nami.groups.treesitter", opts, S, bg, bg_float, opts))
	groups = merge(groups, load("nami.groups.lsp", opts, S, bg, bg_float, opts))

	-------------------------------------------------
	-- PLUGIN MODULES (EXTENDED CONTEXT)
	-------------------------------------------------

	groups = merge(groups, load("nami.groups.plugins", opts, S, bg, bg_float, styles))

	-------------------------------------------------
	-- USER OVERRIDES (HIGHEST PRIORITY)
	-- Applied last — always wins over everything above.
	-------------------------------------------------

	if opts.overrides and not vim.tbl_isempty(opts.overrides) then
		groups = merge(groups, opts.overrides)
	end

	return groups
end

return M
