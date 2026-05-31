vim.pack.add({
  {
    src = '/home/gorgek/.config/nvim/plugins/vscode.nvim'
  },
  -- { src = "https://github.com/catppuccin/nvim", name = "catppuccin" }
})

require("vscode").setup({
  transparent = true, -- set to true if you want transparent background
  italic_comments = false,
  disable_nvimtree_bg = false,

  color_overrides = {
    vscTabCurrent = "#2D2D2D",
    vscTabOther = "#202020",
  },
})

vim.cmd.colorscheme("vscode")

local c = require('vscode.colors').get_colors()

-- Basic Neovim UI settings
vim.opt.termguicolors = true -- enable true colors
vim.opt.background = 'dark' -- ensure dark mode background

-- Vscode builtin and custom types have the same color
vim.api.nvim_set_hl(0, '@type.builtin', { fg = c.vscBlueGreen, bg = 'NONE' })

-- Whitespace color
vim.api.nvim_set_hl(0, 'Whitespace', { fg = '#3E3E3E', bg = 'NONE', nocombine = true })

-- Tab color
vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3E3E3E', bg = 'NONE', nocombine = true })

-- Make float windows transparent (which-key)
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })

-- TreesitterContext background colors
vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#2D2D2D' })
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = '#5A5A5A', bg = '#2D2D2D' })

-- Figdet.nvim colors
vim.api.nvim_set_hl(0, 'FidgetLSPName', { fg = '#9CDCFE', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FidgetText', { fg = '#D4D4D4', bg = 'NONE' })

-- Goplements inlay hint color
vim.api.nvim_set_hl(0, 'Goplements', { fg = c.vscSuggestion, bg = 'NONE' })

-- Tiny diagnostics colors
vim.api.nvim_set_hl(0, 'DiagnosticError', { bg = '#3A2725', fg = '#FF6464' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { bg = '#3E2F23', fg = '#FA973B' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { bg = '#233332', fg = '#30AF65' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { bg = '#24313A', fg = '#569CD6' })

-- BlinkPairs rainbow parentheses colors.
-- Work around a blink.pairs namespace bug: the plugin defines these in the
-- blink_pairs (underscore) namespace, but applies extmarks in blink.pairs
-- (dot). Defining them globally (ns=0) makes them visible to the extmarks.
-- The ColorScheme autocmd re-applies them after any colorscheme change,
-- which is necessary because themes like vscode.nvim call `hi clear` on load.
local function set_blink_pairs_hl()
  vim.api.nvim_set_hl(0, 'BlinkPairsWhite', { fg = '#FFD700', default = true })
  vim.api.nvim_set_hl(0, 'BlinkPairsPurple', { fg = c.vscPink, default = true })
  vim.api.nvim_set_hl(0, 'BlinkPairsOrange', { fg = '#d65d0e', default = true })
  vim.api.nvim_set_hl(0, 'BlinkPairsBlue', { fg = '#569CD6', default = true })
  vim.api.nvim_set_hl(0, 'BlinkPairsUnmatched', { fg = '#ff007c', default = true })
  vim.api.nvim_set_hl(0, 'BlinkPairsMatchParen', { link = 'MatchParen', default = true })
end
set_blink_pairs_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('user_blink_pairs_hl', {}),
  callback = set_blink_pairs_hl,
})
