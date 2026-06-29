local hl = vim.api.nvim_set_hl

require("vscode").setup({
  transparent = true,
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
vim.opt.background = 'dark' -- ensure dark mode background

-- Vscode builtin and custom types have the same color
hl(0, '@type.builtin', { fg = c.vscBlueGreen, bg = 'NONE' })

-- Whitespace color
hl(0, 'Whitespace', { fg = '#3E3E3E', bg = 'NONE', nocombine = true })

-- Tab color
hl(0, 'IblIndent', { fg = '#3E3E3E', bg = 'NONE', nocombine = true })

-- Make float windows transparent (which-key)
hl(0, 'NormalFloat', { bg = 'NONE' })
hl(0, 'FloatBorder', { bg = 'NONE' })

-- Figdet.nvim colors
hl(0, 'FidgetLSPName', { fg = '#9CDCFE', bg = 'NONE' })
hl(0, 'FidgetText', { fg = '#D4D4D4', bg = 'NONE' })

-- Goplements inlay hint color
hl(0, 'Goplements', { fg = c.vscSuggestion, bg = 'NONE' })

-- Tiny diagnostics colors
hl(0, 'DiagnosticError', { bg = '#3A2725', fg = '#FF6464' })
hl(0, 'DiagnosticWarn', { bg = '#3E2F23', fg = '#FA973B' })
hl(0, 'DiagnosticInfo', { bg = '#233332', fg = '#30AF65' })
hl(0, 'DiagnosticHint', { bg = '#24313A', fg = '#569CD6' })

-- BlinkPairs rainbow parentheses colors.
-- Work around a blink.pairs namespace bug: the plugin defines these in the
-- blink_pairs (underscore) namespace, but applies extmarks in blink.pairs
-- (dot). Defining them globally (ns=0) makes them visible to the extmarks.
-- The ColorScheme autocmd re-applies them after any colorscheme change,
-- which is necessary because themes like vscode.nvim call `hi clear` on load.
local function set_blink_pairs_hl()
  hl(0, 'BlinkPairsWhite', { fg = '#FFD700', default = true })
  hl(0, 'BlinkPairsPurple', { fg = c.vscPink, default = true })
  hl(0, 'BlinkPairsOrange', { fg = '#d65d0e', default = true })
  hl(0, 'BlinkPairsBlue', { fg = '#569CD6', default = true })
  hl(0, 'BlinkPairsUnmatched', { fg = '#ff007c', default = true })
  hl(0, 'BlinkPairsMatchParen', { link = 'MatchParen', default = true })
  hl(0, 'BlinkIndentScope', { fg = '#707070', default = true })
end

set_blink_pairs_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('user_blink_pairs_hl', {}),
  callback = set_blink_pairs_hl,
})

local sidebar_bg = "#181818"

local sidebar_fts = {
  'neo-tree', 'dbui', 'time-machine-list', 'grpcui',
  'grug-far', 'codecompanion', 'dbout', 'snacks_terminal'
}

local function set_sidebar_hl()
  hl(0, 'SidebarNormal', { bg = sidebar_bg, default = true })
  hl(0, 'NeoTreeNormal', { bg = sidebar_bg, default = true })
  hl(0, 'NeoTreeNormalNC', { bg = sidebar_bg, default = true })
  hl(0, 'NeoTreeIndentMarker', { bg = sidebar_bg, default = true })
  hl(0, 'TimeMachineNormal', { bg = sidebar_bg, default = true })
  hl(0, 'CodeCompanionNormal', { bg = sidebar_bg, default = true })
  hl(0, 'SnacksTermNormal', { bg = sidebar_bg, default = true })
end

set_sidebar_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('user_sidebar_hl', {}),
  callback = set_sidebar_hl,
})

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'FileType' }, {
  pattern = "*",
  callback = function()
    if vim.tbl_contains(sidebar_fts, vim.bo.filetype) then
      vim.wo.winhighlight = 'Normal:SidebarNormal,NormalNC:SidebarNormal'
    else
      vim.wo.winhighlight = ''
    end
  end,
})

vim.api.nvim_set_hl(0, "@keyword.range.go", { fg = c.vscPink })
vim.api.nvim_set_hl(0, "@keyword.package.go", { fg = c.vscBlue })
