-- Enable the new Lua loader for faster startup
if vim.loader then
  vim.loader.enable()
end

-- Set <,> as the leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Disable built-in plugins we don't need
local disabled_built_ins = {
  'netrw', 'netrwPlugin', 'netrwSettings', 'netrwFileHandlers',
  'gzip', 'zip', 'zipPlugin', 'tar', 'tarPlugin',
  'getscript', 'getscriptPlugin', 'vimball', 'vimballPlugin',
  '2html_plugin', 'logipat', 'rrhelper', 'spellfile_plugin', 'matchit',
}
for _, plugin in ipairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end


require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins");
require("lsp");
require("theme");

vim.diagnostic.config {
	signs = false,
}

