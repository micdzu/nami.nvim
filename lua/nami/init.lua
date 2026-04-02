---@module "nami"
---
--- Public API entrypoint for Nami.
---
--- Exposed functions:
---   M.setup(opts)          → build palette, apply highlights, register commands
---   M.lualine_theme(opts)  → return a lualine-compatible theme table
---   M.get_palette()        → return the current resolved semantic palette

local M = {}

-------------------------------------------------
-- COMMANDS
-------------------------------------------------

local function create_commands()
	local toggle = require("nami.toggle")
	local setup = require("nami.setup")

	vim.api.nvim_create_user_command("NamiVariant", function(opts)
		local state = setup.get_state()
		local new = opts.args ~= "" and opts.args or (state.opts.variant == "light" and "dark" or "light")

		local cfg = vim.deepcopy(state.opts or {})
		cfg.variant = new

		setup.setup(cfg)
		vim.notify("Nami variant → " .. new)
	end, {
		nargs = "?",
		complete = function()
			return { "dark", "light" }
		end,
	})

	vim.api.nvim_create_user_command("NamiAccessibility", function()
		toggle.toggle_accessibility()
	end, {})

	vim.api.nvim_create_user_command("NamiStatus", function()
		toggle.status()
	end, {})
end

-------------------------------------------------
-- SETUP
-------------------------------------------------

---Initialize Nami and apply all highlights.
---
---@param opts table|nil User configuration (see README for full schema)
---@return table palette The resolved semantic palette
function M.setup(opts)
	local palette = require("nami.setup").setup(opts)

	create_commands()

	return palette
end

-------------------------------------------------
-- LUALINE THEME
-------------------------------------------------

---Return a lualine-compatible theme table built from the current (or given) config.
---
---Must be called after M.setup(), or pass opts explicitly.
---
---Usage:
---  require("lualine").setup({
---    options = { theme = require("nami").lualine_theme() },
---  })
---
---@param opts table|nil Override opts (defaults to current state)
---@return table lualine theme
function M.lualine_theme(opts)
	local state = require("nami.setup").get_state()

	if not state.loaded then
		vim.notify(
			"[nami] lualine_theme() called before setup() — call require('nami').setup() first",
			vim.log.levels.WARN
		)
		return {}
	end

	local merged_opts = opts and vim.tbl_deep_extend("force", state.opts, opts) or state.opts
	return require("nami.groups.plugins").lualine_theme(state.palette, merged_opts)
end

-------------------------------------------------
-- GET PALETTE
-------------------------------------------------

---Return the currently resolved semantic palette.
---
---Returns nil if setup() has not been called yet.
---
---@return table|nil palette
function M.get_palette()
	local state = require("nami.setup").get_state()
	return state.palette
end

return M
