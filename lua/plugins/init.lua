vim.pack.add({

  -- Theme
  {
    src = '/Users/23603840/.config/nvim/plugins/vscode.nvim', name = 'vscode'
  },

  -- Core utilities
  {
    src = "/Users/23603840/.config/nvim/plugins/plenary.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/nvim-web-devicons",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/nui.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/nvim-navic",
  },

  -- Notifications
  {
    src = "/Users/23603840/.config/nvim/plugins/fidget.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/nvim-notify",
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/tiny-inline-diagnostic.nvim'
  },

  -- Editor helpers
  {
    src = '/Users/23603840/.config/nvim/plugins/which-key.nvim',
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/guess-indent.nvim",
  },

  -- Completion
  {
    src = "/Users/23603840/.config/nvim/plugins/blink.lib",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/blink.pairs",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/blink.cmp",
  },

  -- Formatting
  {
    src = "/Users/23603840/.config/nvim/plugins/conform.nvim",
  },

  -- Treesitter
  {
    src = '/Users/23603840/.config/nvim/plugins/nvim-treesitter',
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/nvim-treesitter-context',
  },

  -- Git
  {
    src = "/Users/23603840/.config/nvim/plugins/git-blame.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/gitsigns.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/diffview.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/neogit",
  },

  -- Utilities
  {
    src = '/Users/23603840/.config/nvim/plugins/snacks.nvim'
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/blink.indent'
  },

  -- Navigation
  {
    src = "/Users/23603840/.config/nvim/plugins/neo-tree.nvim",
  },

  -- Productivity
  {
    src = "/Users/23603840/.config/nvim/plugins/time-machine.nvim",
  },

  -- Database
  {
    src = "/Users/23603840/.config/nvim/plugins/vim-dadbod",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/vim-dadbod-ui",
  },

  -- gRPC
  {
    src = "/Users/23603840/.config/nvim/plugins/grpc-ui.nvim"
  },

  -- LSP
  {
    src = '/Users/23603840/.config/nvim/plugins/goplements.nvim'
  },

  -- Preview
  {
    src = "/Users/23603840/.config/nvim/plugins/render-markdown.nvim"
  },
 {
    src = "/Users/23603840/.config/nvim/plugins/jqscratch.nvim"
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/csvview.nvim"
  },

  -- Statusbar
  -- {
  --   src = "/Users/23603840/.config/nvim/plugins/lualine.nvim",
  -- },
  {
    src = "/Users/23603840/.config/nvim/plugins/heirline.nvim",
  },

  -- Topbar
  {
    src = "/Users/23603840/.config/nvim/plugins/barbar.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/barbecue.nvim",
  },

  -- AI
  {
    src = "/Users/23603840/.config/nvim/plugins/codecompanion.nvim",
  }
}, { confirm = false, load = function() end })

-- =============================================================================
-- Declarative loading registry
-- Each entry describes when and how to load a plugin module.
-- Fields:
--   mod     — module name under plugins/ (e.g. 'catppuccin' → plugins/catppuccin.lua)
--   event   — autocmd event (string or array) to trigger loading (once=true by default)
--   keys    — keymaps that trigger loading on first press; engine replays the key after
--   defer   — milliseconds to delay via vim.defer_fn
--   packadd — plugin directory names to :packadd before requiring the module
-- =============================================================================

local pack = require('core.pack')

pack.setup({

  -- -------------------------------------------------------------------------
  -- Immediate (first frame — keep minimal; only catppuccin)
  -- -------------------------------------------------------------------------
  { mod = 'vscode', packadd = { 'vscode' } },

  -- -------------------------------------------------------------------------
  -- VimEnter (non-blocking — loads after init but before UI renders)
  -- Native snacks replacements: bigfile guard + gitbrowse/lazygit/terminal keymaps
  -- -------------------------------------------------------------------------
  { mod = 'ui', fn = 'native',    event = 'VimEnter' },
  { mod = 'ui', fn = 'bigfile',   event = 'VimEnter' },
  { mod = 'ui', fn = 'quickfile', event = 'VimEnter' },

  -- -------------------------------------------------------------------------
  -- UIEnter (non-blocking — loads after first frame renders)
  -- -------------------------------------------------------------------------
  -- { mod = 'lualine',    event = 'UIEnter',                          packadd = { 'git-blame.nvim', 'lualine.nvim', 'nvim-web-devicons' } },
  { mod = 'heirline',   event = 'UIEnter', packadd = { 'heirline.nvim', 'nvim-web-devicons' } },
  { mod = 'ui',         fn = 'which_key',  event = 'UIEnter',                         packadd = { 'which-key.nvim' } },
  { mod = 'ui',         fn = 'tiny_diagnostics',  event = 'UIEnter',                  packadd = { 'tiny-inline-diagnostic.nvim' } },
  -- { mod = 'navigation',                    event = 'UIEnter',                         packadd = { 'neo-tree.nvim', 'nui.nvim' } },
  { mod = 'editing',    fn = 'base_ui',    event = 'UIEnter',                         packadd = { 'blink.lib', 'blink.indent', 'blink.pairs' } },
  { mod = 'topbar',     fn = 'barbecue',   event = { 'UIEnter'                     }, packadd = { 'nvim-navic', 'barbecue.nvim' } },

  -- -------------------------------------------------------------------------
  -- BufReadPre / BufNewFile (core file-level features)
  -- -------------------------------------------------------------------------
  { mod = 'treesitter', fn = 'base',     event = { 'BufReadPre', 'BufNewFile' }, packadd = { 'nvim-treesitter' } },
  { mod = 'lsp',                         event = { 'BufReadPre', 'BufNewFile' }, packadd = { 'goplements.nvim' } },
  { mod = 'git',        fn = 'signs',    event = { 'BufReadPre', 'BufNewFile' }, packadd = { 'gitsigns.nvim', 'plenary.nvim' } },
  { mod = 'treesitter', fn = 'context',  event = { 'BufReadPre', 'BufNewFile' }, packadd = { 'nvim-treesitter-context' } },
  -- { mod = 'topbar',     fn = 'barbar',   event = { 'BufAdd'                   }, packadd = { 'nvim-web-devicons', 'barbar.nvim' } },

  -- -------------------------------------------------------------------------
  -- InsertEnter / CmdlineEnter (completion)
  -- -------------------------------------------------------------------------
  { mod = 'completion', event = { 'InsertEnter', 'CmdlineEnter' }, packadd = { 'blink.cmp' } },

  -- -------------------------------------------------------------------------
  -- BufWritePre (formatting on save — conform has its own internal guard)
  -- -------------------------------------------------------------------------
  { mod = 'editing', fn = 'format', event = 'BufWritePre', packadd = { 'conform.nvim' } },

  -- -------------------------------------------------------------------------
  -- Keymap-triggered (first keypress loads the module, then replays the key)
  -- -------------------------------------------------------------------------

  -- Picker
  { mod = 'editing', fn = 'picker', keys = {
      { '<leader>ff',   desc = '[F]iles' },
      { '<leader>fs',   desc = '[s]ymbols buffer' },
      { '<leader>fS',   desc = '[S]ymbols global' },
      { '<leader>fR',   desc = '[R]eferences' },
      { '<leader>fI',   desc = '[I]mplenentations' },
      { '<leader>fd',   desc = '[d]iagnostics buffer' },
      { '<leader>fD',   desc = '[D]iagnostics global' },
      { '<leader>fg',   desc = '[g]rep' },
      {         'gd',   desc = '[G]oto [D]efinition' },
      { '<leader>tl',   desc = '[L]ist' },
    }, packadd = { 'snacks.nvim' } },
  -- Sidebar
  { mod = 'sidebar', keys = {
      { '<leader>ef',   desc = '[F]iles' },
      { '<leader>ed',   desc = '[D]atabase' },
      { '<leader>eg',   desc = '[G]RPC' },
      { '<leader>et',   desc = '[T]ime machine' },
      { '<leader>eh',   desc = '[H]ide' },
    }, packadd = {'neo-tree.nvim', 'nui.nvim', 'vim-dadbod', 'vim-dadbod-ui', 'time-machine.nvim', 'grpc-ui.nvim' } },
  -- Git Diff
  { mod = 'git', fn = 'diff', keys = {
      { '<leader>gd',   desc = '[Diff] against index' },
      { '<leader>gD',   desc = '[D]iff Last Commit' },
      { '<leader>gm',   desc = '[M]erge Conflict' },
    }, packadd = { 'diffview.nvim', 'plenary.nvim' } },
  -- Tools
  { mod = 'tools', fn = 'productivity', keys = {
      { '<leader>us',   desc = 'Session Restore' },
      { '<leader>ud',   desc = "Don't Save Session" },
      { '<leader>fr',   desc = 'File Rename' },
      { '<leader>fd',   desc = 'File Duplicate' },
      { '<leader>fn',   desc = 'File New' },
      { '<leader>fx',   desc = 'File Move' },
      { '<leader>fc',   desc = 'File Copy Path' },
    } },
  -- AI
  { mod = 'ai', keys = {
      { '<leader>ac',   desc = '[C]ode Companion Toggle' },
      { '<leader>as',   desc = '[S]end to companion' },
      { '<leader>al',   desc = '[L]ist companions' },
    }, packadd = { 'codecompanion.nvim', 'blink.cmp', 'blink.lib' } },
  { mod = 'preview', fn = 'json', keys = {
      { '<leader>pj',   desc = '[J]son' },
    }, packadd = { 'jqscratch.nvim' } },
  { mod = 'preview', fn = 'csv', keys = {
      { '<leader>pc',   desc = '[C]sv' },
    }, packadd = { 'csvview.nvim' } },

  -- -------------------------------------------------------------------------
  -- Deferred (idle — load after defer ms)
  -- -------------------------------------------------------------------------
  { mod = 'editing', fn = 'guess_indent',  defer = 1,  packadd = { 'guess-indent.nvim' } },
  { mod = 'notification',                  defer = 1,  packadd = { 'fidget.nvim', 'nvim-notify' } },
  { mod = 'preview', fn = 'md',            defer = 1,  packadd = { 'render-markdown.nvim' } },
})


