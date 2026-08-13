-- Enable the new Lua loader for faster startup
if vim.loader then
	vim.loader.enable()
end

-- Set <,> as the leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable built-in plugins we don't need
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	"matchit",
	-- Runtime plugins that cost ~0.15ms each on startup — disable if unused
	"editorconfig", -- EditorConfig support (re-enable if you use .editorconfig)
	"man", -- :Man command (re-enable if you use it)
	"nvim_net_plugin", -- network RFC/protocol helper (re-enable if needed)
}
for _, plugin in ipairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

-- Core settings
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.statusline")

-- Plugin declarations (vim.pack.add with load = no-op) + loading engine setup.
-- require('plugins') does everything: installs plugins, registers the declarative
-- loading rules, and sets up autocmds / keymaps / deferred loaders.
require("plugins")

vim.diagnostic.config({
	signs = false,
})
