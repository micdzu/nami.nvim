---@module "nami.statusline"
---
--- Native Nami statusline.
---
--- Philosophy:
---   - Minimal, text-first UI
---   - Semantic coloring only where meaningful (mode accents)
---   - No visual noise or background blocks
---   - Context-aware: shows only relevant info per buffer
---
--- Usage:
---   vim.o.statusline = "%!v:lua.require('nami.statusline').build(require('nami').get_palette())()"
---
---   Or via the setup callback:
---     config = function()
---       local nami = require("nami")
---       local S = nami.setup({ ... })
---       vim.o.statusline = "%!v:lua.require('nami.statusline').build(" .. vim.inspect(S) .. ")()"
---     end

local M = {}

-------------------------------------------------
-- HIGHLIGHTS
-------------------------------------------------

local function set_hl(S)
	vim.api.nvim_set_hl(0, "NamiSLNormal", { fg = S.fg,         bg = S.bg })
	vim.api.nvim_set_hl(0, "NamiSLDim",    { fg = S.fg_dark,    bg = S.bg })

	vim.api.nvim_set_hl(0, "NamiSLDef",    { fg = S.definition, bg = S.bg })
	vim.api.nvim_set_hl(0, "NamiSLStr",    { fg = S.string,     bg = S.bg })
	vim.api.nvim_set_hl(0, "NamiSLConst",  { fg = S.constant,   bg = S.bg })

	vim.api.nvim_set_hl(0, "NamiSLError",  { fg = S.error,      bg = S.bg })
	vim.api.nvim_set_hl(0, "NamiSLWarn",   { fg = S.warn,       bg = S.bg })

	vim.api.nvim_set_hl(0, "NamiSLComment", { fg = S.comment,   bg = S.bg })
end

-------------------------------------------------
-- HELPERS
-------------------------------------------------

local function hl(group, text)
	return "%#" .. group .. "#" .. text .. "%*"
end

--- Map the current Vim mode to a semantic highlight group.
--- Semantic intent:
---   normal  → definition (structure: you are navigating the program)
---   insert  → string     (you are writing text/data)
---   visual  → constant   (you are selecting a value/range)
---   replace → error      (destructive edit)
---   command → warn       (executing a command)
local function mode_group()
	local m = vim.fn.mode()
	if m:match("i") then return "NamiSLStr"   end
	if m:match("v") then return "NamiSLConst" end
	if m:match("V") then return "NamiSLConst" end
	if m:match("R") then return "NamiSLError" end
	if m:match("c") then return "NamiSLWarn"  end
	return "NamiSLDef"
end

local function filename()
	local name = vim.fn.expand("%:t")
	return name ~= "" and name or "[No Name]"
end

local function modified()
	return vim.bo.modified and " +" or ""
end

local function readonly()
	return (vim.bo.readonly or not vim.bo.modifiable) and " 󰌾" or ""
end

-------------------------------------------------
-- GIT
-------------------------------------------------

local function git_branch()
	local g = vim.b.gitsigns_head
	if not g or g == "" then return "" end
	return hl("NamiSLComment", " " .. g)
end

local function git_diff()
	local g = vim.b.gitsigns_status_dict
	if not g then return "" end

	local parts = {}
	if g.added   and g.added   > 0 then table.insert(parts, hl("NamiSLStr",   "+" .. g.added))   end
	if g.changed  and g.changed  > 0 then table.insert(parts, hl("NamiSLConst", "~" .. g.changed))  end
	if g.removed  and g.removed  > 0 then table.insert(parts, hl("NamiSLError", "-" .. g.removed))  end

	return table.concat(parts, " ")
end

-------------------------------------------------
-- LSP
-------------------------------------------------

local function lsp()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then return "" end
	return hl("NamiSLComment", clients[1].name)
end

-------------------------------------------------
-- DIAGNOSTICS
-------------------------------------------------

local function diagnostics()
	local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

	if e == 0 and w == 0 then return "" end

	local parts = {}
	if e > 0 then table.insert(parts, hl("NamiSLError", "E" .. e)) end
	if w > 0 then table.insert(parts, hl("NamiSLWarn",  "W" .. w)) end

	return table.concat(parts, " ")
end

-------------------------------------------------
-- FILE INFO
-------------------------------------------------

local function fileinfo()
	local ft  = vim.bo.filetype ~= "" and vim.bo.filetype or "plain"
	local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
	local fmt = vim.bo.fileformat
	return hl("NamiSLDim", string.format("%s %s %s", enc, fmt, ft))
end

local function position()
	return hl("NamiSLNormal", string.format("%d:%d", vim.fn.line("."), vim.fn.col(".")))
end

-------------------------------------------------
-- BUILD
-------------------------------------------------

---Build and return the statusline render function.
---
---Initializes highlight groups from the palette on first call.
---Returns a function that Neovim calls on every statusline redraw.
---
---@param S table Semantic palette (from require("nami").get_palette())
---@return function statusline render function
function M.build(S)
	set_hl(S)

	return function()
		local left  = {}
		local right = {}

		-- Mode indicator + filename
		table.insert(left, hl(mode_group(), "●"))
		table.insert(left, hl("NamiSLNormal", filename() .. modified() .. readonly()))

		-- Git branch
		local branch = git_branch()
		if branch ~= "" then table.insert(left, "  " .. branch) end

		-- Git diff stats
		local diff = git_diff()
		if diff ~= "" then table.insert(left, " " .. diff) end

		-- Diagnostics
		local diag = diagnostics()
		if diag ~= "" then table.insert(left, "  " .. diag) end

		-- Active LSP client
		local lsp_name = lsp()
		if lsp_name ~= "" then table.insert(left, "  " .. lsp_name) end

		-- Right side
		table.insert(right, fileinfo())
		table.insert(right, hl("NamiSLDim", "│"))
		table.insert(right, position())

		return table.concat(left, " ") .. "%=" .. table.concat(right, " ")
	end
end

return M
