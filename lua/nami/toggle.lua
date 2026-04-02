---@module "nami.toggle"
---
--- Runtime toggle utilities for Nami.
---
--- Provides:
---   M.toggle_accessibility()  — toggle the OKLCH contrast correction on/off
---   M.status()                — print current configuration to the message area

local M = {}

-------------------------------------------------
-- TOGGLE ACCESSIBILITY
-------------------------------------------------

---Toggle the adaptive contrast system on or off.
---
---Re-runs the full setup pipeline with accessibility.enabled flipped,
---so all highlight groups are regenerated and re-applied immediately.
function M.toggle_accessibility()
	local setup = require("nami.setup")
	local state = setup.get_state()

	if not state.opts then
		vim.notify("[nami] not initialized — call require('nami').setup() first", vim.log.levels.ERROR)
		return
	end

	local opts = vim.deepcopy(state.opts)
	opts.accessibility = opts.accessibility or {}
	opts.accessibility.enabled = not opts.accessibility.enabled

	setup.setup(opts)

	vim.notify(
		"[nami] accessibility → " .. (opts.accessibility.enabled and "ON" or "OFF"),
		vim.log.levels.INFO
	)
end

-------------------------------------------------
-- STATUS
-------------------------------------------------

---Print the current Nami configuration to the message area.
function M.status()
	local state = require("nami.setup").get_state()

	if not state.opts then
		vim.notify("[nami] not initialized — call require('nami').setup() first", vim.log.levels.WARN)
		return
	end

	local opts = state.opts

	local lines = {
		"Nami status:",
		"  variant        → " .. tostring(opts.variant or "dark"),
		"  transparency   → " .. tostring(opts.transparent),
		"  accessibility  → " .. tostring(opts.accessibility and opts.accessibility.enabled or false),
		"  strict mode    → " .. tostring(opts.strict),
		"  debug mode     → " .. tostring(opts.debug),
	}

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

return M
