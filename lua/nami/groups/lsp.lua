---@module "nami.groups.lsp"
---
--- LSP semantic token highlight mappings.
---
--- CHANGES:
--- - Updated signature to accept bg, bg_float for consistency
--- - Added validation for S.palette fields

local M = {}

---@param S table Semantic palette
---@param bg string Resolved background (unused but consistent)
---@param bg_float string Resolved float background (unused but consistent)
---@param opts table User options
function M.get(S, bg, bg_float, opts)
	if not S.fg or not S.definition or not S.constant or not S.comment or not S.selection then
		vim.notify("[nami] lsp: incomplete semantic palette", vim.log.levels.ERROR)
		return {}
	end

	return {
		-------------------------------------------------
		-- SEMANTIC TOKEN TYPES
		-------------------------------------------------

		["@lsp.type.variable"] = { fg = S.fg },
		["@lsp.type.parameter"] = { fg = S.fg },
		["@lsp.type.property"] = { fg = S.fg },
		["@lsp.type.field"] = { fg = S.fg },
		["@lsp.type.enumMember"] = { fg = S.constant },

		["@lsp.type.function"] = { fg = S.definition },
		["@lsp.type.method"] = { fg = S.definition },
		["@lsp.type.macro"] = { fg = S.definition },

		["@lsp.type.class"] = { fg = S.definition },
		["@lsp.type.struct"] = { fg = S.definition },
		["@lsp.type.interface"] = { fg = S.definition },
		["@lsp.type.type"] = { fg = S.definition },
		["@lsp.type.typeParameter"] = { fg = S.definition },
		["@lsp.type.enum"] = { fg = S.definition },

		["@lsp.type.namespace"] = { fg = S.definition },
		["@lsp.type.module"] = { fg = S.definition },
		["@lsp.type.decorator"] = { fg = S.definition },

		["@lsp.type.string"] = { fg = S.string },
		["@lsp.type.number"] = { fg = S.constant },
		["@lsp.type.boolean"] = { fg = S.constant },

		["@lsp.type.keyword"] = { fg = S.definition },
		["@lsp.type.comment"] = { fg = S.comment },
		["@lsp.type.operator"] = { fg = S.fg },
		["@lsp.type.punctuation"] = { fg = S.fg },

		-------------------------------------------------
		-- SEMANTIC TOKEN MODIFIERS
		-------------------------------------------------

		["@lsp.mod.deprecated"] = { strikethrough = true },
		["@lsp.mod.readonly"] = { fg = S.constant },
		["@lsp.mod.constant"] = { fg = S.constant },
		["@lsp.mod.defaultLibrary"] = { fg = S.definition },
		["@lsp.mod.static"] = { fg = S.definition },
		["@lsp.mod.async"] = { fg = S.definition },
		["@lsp.mod.documentation"] = { fg = S.comment },
		["@lsp.mod.abstract"] = { fg = S.definition, italic = true },
		["@lsp.mod.modification"] = { fg = S.fg },

		-------------------------------------------------
		-- LSP UI GROUPS
		-------------------------------------------------

		LspReferenceText = { bg = S.selection },
		LspReferenceRead = { bg = S.selection },
		LspReferenceWrite = { bg = S.selection },

		LspReferenceTarget = { fg = S.definition, bg = S.selection, bold = true },

		LspCodeLens = { fg = S.comment },
		LspCodeLensSeparator = { fg = S.fg_dark },

		LspInlayHint = { fg = S.comment, bg = S.bg_light },

		LspSignatureActiveParameter = { fg = S.constant, bold = true },
	}
end

return M
