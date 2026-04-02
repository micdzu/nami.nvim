---@module "nami.palette.base"
---
--- Base color definitions for Nami.
---
--- This module defines the raw, canonical palette.
--- These colors are NOT semantic — they are inputs to the system.
---
--- All transformations (variants, accessibility, semantic mapping)
--- happen after this stage.
---
--- All colors must be 6-digit hex strings (#RRGGBB).
---
--- To override individual base colors without touching semantic roles:
---   vim.g.nami_config = { palette = { blue = "#82aaff" } }

local M = {}

---Return base palette (dark default).
---@return table
function M.get()
	return {
		-------------------------------------------------
		-- BACKGROUND
		-------------------------------------------------
		bg = "#1A1732",

		-------------------------------------------------
		-- FOREGROUND
		-------------------------------------------------
		fg      = "#C9C2FF",
		fg_dark = "#746FA3",

		-------------------------------------------------
		-- ACCENTS (RAW — non-semantic)
		-- These are the source colors that the semantic layer
		-- maps to roles (definition, string, constant, comment).
		-- Change these here to shift the whole palette identity.
		-------------------------------------------------
		red     = "#E87A98",
		orange  = "#F0A07A",
		green   = "#9FD88A",
		cyan    = "#7AD2CE",
		blue    = "#839DF4",
		magenta = "#D596F0",
	}
end

return M
