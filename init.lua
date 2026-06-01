-- Make cursor solid block
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
-- Set <,> as the leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.fillchars:append({
  eob = " ",
})

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set height of command line under status line
vim.o.cmdheight = 0

-- Make line numbers default
vim.o.number = true

-- Make line numbers relative
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Prevent neovim from auto-equalizing window widths when windows
-- appear/disappear (edgy sidebar expand/collapse would shift the layout)
vim.o.equalalways = false

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true

-- Configure how they look
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  extends = '⟩',
  precedes = '⟨',
  space = '·',
  nbsp = '␣',
}

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.wo.cursorline = true
vim.wo.cursorlineopt = 'number'

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
vim.o.confirm = true

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Open init.lua
vim.keymap.set('n', '<leader>oc', ':e ~/.config/nvim/init.lua<CR>', { desc = '[C]onfig' })

-- Open .zshrc
vim.keymap.set('n', '<leader>oz', ':e ~/.zshrc<CR>', { desc = '[Z]hrc' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')


-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Use nvim-notify for dbui notification popups
vim.g.db_ui_use_nvim_notify = 1
-- Disable dadbod-ui's built-in progress spinner and query notifications
-- (we use a custom live timer near the query buffer instead)
vim.g.db_ui_disable_progress_bar = 1
vim.g.db_ui_disable_info_notifications = 1

require("plugins");
require("lsp");
require("autocmds")
require("theme");

-- Override vim.notify with nvim-notify (snacks also overrides it, we want
-- nvim-notify to win so dbui notifications look polished)
vim.notify = require("notify")
require("notify").setup({
  background_colour = "#1e1e1e",
})

vim.diagnostic.config {
	signs = false,
}
