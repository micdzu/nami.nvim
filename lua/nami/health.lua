---@module "nami.health"
---
--- :checkhealth nami
---
--- FIXES:
--- - TreeSitter check no longer creates parser instances (side-effect free)
--- - Added contrast ratio checking for current variant
--- - Better error messages

local M = {}

function M.check()
	vim.health.start("nami.nvim")

	-------------------------------------------------
	-- VERSION
	-------------------------------------------------

	if vim.fn.has("nvim-0.10") == 1 then
		vim.health.ok("Neovim version is 0.10+")
	else
		vim.health.error(
			"Neovim 0.10+ required. "
				.. "Nami uses vim.lsp.get_clients(), semantic token highlights, "
				.. "and the full vim.diagnostic API."
		)
	end

	-------------------------------------------------
	-- COLORSCHEME
	-------------------------------------------------

	local state = require("nami.setup").get_state()

	if vim.g.colors_name == "nami" and state.loaded then
		vim.health.ok("Colorscheme active and initialized")
	elseif vim.g.colors_name == "nami" and not state.loaded then
		vim.health.warn("Colorscheme set but not fully initialized")
	elseif state.loaded then
		vim.health.warn("Nami initialized but not set as active colorscheme")
	else
		vim.health.warn("Colorscheme not active — run :colorscheme nami")
	end

	-------------------------------------------------
	-- TERM COLORS
	-------------------------------------------------

	if vim.o.termguicolors then
		vim.health.ok("termguicolors enabled")
	else
		vim.health.error(
			"termguicolors is not set — add `vim.o.termguicolors = true` to your config. "
				.. "Nami requires 24-bit color support."
		)
	end

	-------------------------------------------------
	-- TREESITTER
	-- FIX: Check parser existence without creating side effects
	-------------------------------------------------

	local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "unknown"
	local has_parser = false

	if ft ~= "unknown" then
		-- Query available parsers without instantiating
		local ok, parsers = pcall(require, "nvim-treesitter.parsers")
		if ok then
			has_parser = parsers.has_parser(ft)
		else
			-- Fallback: check if parser file exists
			local parser_path = vim.fn.stdpath("data") .. "/site/parser/" .. ft .. ".so"
			has_parser = vim.fn.filereadable(parser_path) == 1
		end
	end

	if has_parser then
		vim.health.ok("Treesitter parser available for current filetype (" .. ft .. ")")
	elseif ft == "unknown" then
		vim.health.info("No filetype set — cannot check Treesitter parser")
	else
		vim.health.warn(
			"No Treesitter parser for filetype '" .. ft .. "'. " .. "Run :TSInstall " .. ft .. " to add a parser."
		)
	end

	-------------------------------------------------
	-- STATE
	-------------------------------------------------

	if state.loaded then
		vim.health.ok("nami.setup() has been called")
		vim.health.info("── Configuration ─────────────────────")
		vim.health.info("Variant:        " .. tostring(state.opts.variant or "dark (default)"))
		vim.health.info("Transparent:    " .. tostring(state.opts.transparent))
		vim.health.info("Float transparent:" .. tostring(state.opts.float_transparent))
		vim.health.info("Accessibility:  " .. tostring(state.opts.accessibility.enabled))
		vim.health.info("Term colors:    " .. tostring(state.opts.terminal_colors))
		vim.health.info("Strict mode:    " .. tostring(state.opts.strict))
		vim.health.info("Debug mode:     " .. tostring(state.opts.debug))
	else
		vim.health.warn("nami.setup() not called — colorscheme may not be fully initialized")
	end

	-------------------------------------------------
	-- SEMANTIC PALETTE & CONTRAST
	-------------------------------------------------

	if state.palette then
		vim.health.ok("Semantic palette loaded")
		local S = state.palette
		local utils = require("nami.palette.utils")

		vim.health.info(
			"── Palette ────────────────────────────"
		)
		vim.health.info("bg:         " .. (S.bg or "?"))
		vim.health.info("fg:         " .. (S.fg or "?"))
		vim.health.info("definition: " .. (S.definition or "?"))
		vim.health.info("string:     " .. (S.string or "?"))
		vim.health.info("constant:   " .. (S.constant or "?"))
		vim.health.info("comment:    " .. (S.comment or "?"))

		-- Contrast checks
		vim.health.info("── Contrast Ratios (WCAG AA = 4.5) ───")
		local function check_contrast(name, fg, bg, threshold)
			if not fg or not bg then
				return
			end
			local ratio = utils.contrast(fg, bg)
			local status = ratio >= threshold and "✓" or "✗"
			vim.health.info(string.format("%s: %.2f:1 %s (target: %.1f)", name, ratio, status, threshold))
		end

		check_contrast("definition", S.definition, S.bg, 3.2)
		check_contrast("string", S.string, S.bg, 2.7)
		check_contrast("constant", S.constant, S.bg, 3.0)
		check_contrast("comment", S.comment, S.bg, 2.3)

		-- Warn about light mode if applicable
		local bg_lum = utils.contrast(S.bg, "#000000") -- Approximate luminance
		if bg_lum < 2 then -- Light background (high contrast with black = light)
			vim.health.info("Variant detected: light")
			if state.opts.accessibility.enabled == false then
				vim.health.warn("Light variant may have contrast issues with accessibility disabled")
			end
		end
	else
		vim.health.warn("Palette not initialized")
	end

	-------------------------------------------------
	-- TERMINAL COLORS
	-------------------------------------------------

	if state.opts and state.opts.terminal_colors then
		if vim.g.terminal_color_0 ~= nil then
			vim.health.ok("Terminal colors applied (terminal_color_0 = " .. vim.g.terminal_color_0 .. ")")
		else
			vim.health.error(
				"terminal_colors = true but vim.g.terminal_color_0 is not set. "
					.. "This is a nami bug — please open an issue."
			)
		end
	else
		vim.health.info("Terminal colors disabled (terminal_colors = false)")
	end
end

return M
