-- colors/nami.lua
--
-- Native colorscheme entrypoint for Nami.
-- This is the ONLY required entrypoint for users.

-- Prevent double-loading
local state = require("nami.setup").get_state()
if vim.g.colors_name == "nami" and state.loaded then
	return
end

-- Standard colorscheme reset
vim.cmd("hi clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

-- Mark colorscheme as active (required by Neovim)
vim.g.colors_name = "nami"

-- Load user config from global
local config = vim.g.nami_config or {}

-- Apply theme
require("nami.setup").setup(config)
