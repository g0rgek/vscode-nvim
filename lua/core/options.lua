-- =============================================================================
-- Core Options
-- =============================================================================

-- Aggressively disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0

-- Disable unused built-in plugins for startup speed
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1

-- Nerd Font availability flag (used by plugins)
vim.g.have_nerd_font = true

-- =============================================================================
-- Display
-- =============================================================================
vim.o.number = true
vim.o.relativenumber = false
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.cursorline = true
vim.wo.cursorlineopt = 'number'
vim.o.signcolumn = 'yes'
vim.o.termguicolors = true
vim.o.laststatus = 3
vim.opt.fillchars = { eob = " " }

-- Transparency for floating panes
-- vim.opt.pumblend = 20
-- vim.opt.winblend = 20

vim.opt.smoothscroll = true
vim.o.cmdheight = 0
vim.o.autoread = true
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'

-- =============================================================================
-- Editing
-- =============================================================================
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split'
vim.o.confirm = true
vim.o.scrolloff = 10
vim.o.list = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', space = '·', nbsp = '␣'}
vim.o.wrap = true
vim.o.sidescrolloff = 8
vim.o.gdefault = true  -- global replace by default

-- =============================================================================
-- Performance
-- =============================================================================
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.opt.ttimeoutlen = 10
vim.opt.lazyredraw = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.shortmess:append 'c'
vim.opt.shortmess:append 'W'
vim.opt.synmaxcol = 500
vim.opt.regexpengine = 0  -- auto-select best regex engine

-- =============================================================================
-- Files & History
-- =============================================================================
vim.o.undofile = true
vim.opt.undolevels = 10000
vim.opt.history = 1000
vim.opt.hidden = true

-- =============================================================================
-- Splits
-- =============================================================================
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.equalalways = false

-- =============================================================================
-- Folding
-- =============================================================================
vim.o.foldmethod = 'expr'
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.foldnestmax = 3

-- =============================================================================
-- Completion
-- =============================================================================
vim.opt.pumheight = 15
vim.opt.pumwidth = 30
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }


-- =============================================================================
-- User Plugins
-- =============================================================================
vim.g.db_ui_use_nvim_notify = 1
vim.g.db_ui_disable_progress_bar = 1
vim.g.db_ui_disable_info_notifications = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_save_location = "~/.local/share/db_ui"
vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_message_template = '<author> (<date>)'
vim.g.gitblame_date_format = '%r'
vim.g.barbar_auto_setup = false

-- =============================================================================
-- Filetype detection patches
-- =============================================================================
vim.filetype.add {
  pattern = {
    ['.*/.*%.component%.html'] = 'htmlangular',
  },
}

-- =============================================================================
-- Rounded borders for all floating windows
-- =============================================================================
-- local orig_open_win = vim.api.nvim_open_win
-- vim.api.nvim_open_win = function(buffer, enter, config)
--   if config and config.relative then
--     config.border = config.border or 'rounded'
--     if not config.style then config.style = 'minimal' end
--   end
--   return orig_open_win(buffer, enter, config)
-- end
