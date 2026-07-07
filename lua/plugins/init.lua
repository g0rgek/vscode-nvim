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
  {
    src = "/Users/23603840/.config/nvim/plugins/volt",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/nvim-nio",
  },

  -- Notifications
  {
    src = "/Users/23603840/.config/nvim/plugins/nvim-notify",
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/tiny-inline-diagnostic.nvim'
  },

  -- Achievements
  {
    src = "/Users/23603840/.config/nvim/plugins/triforce.nvim",
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

  -- Snippets
  {
    src =  "/Users/23603840/.config/nvim/plugins/LuaSnip",
  },
  {
    src =  "/Users/23603840/.config/nvim/plugins/friendly-snippets",
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
  {
    src = "/Users/23603840/.config/nvim/plugins/grug-far.nvim",
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
    src = "/Users/23603840/.config/nvim/plugins/vim-dadbod-completion",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/dbui.nvim",
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
  {
    src = "/Users/23603840/.config/nvim/plugins/heirline.nvim",
  },

  -- Topbar
  {
    src = "/Users/23603840/.config/nvim/plugins/barbecue.nvim",
  },

  -- AI
  {
    src = "/Users/23603840/.config/nvim/plugins/codecompanion.nvim",
  },

  -- Testing
  {
    src = "/Users/23603840/.config/nvim/plugins/neotest",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/neotest-golang",
  },

  -- Leetcode
  {
    src = "/Users/23603840/.config/nvim/plugins/leetcode.nvim",
  },

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
  { mod = 'heirline',   event = 'UIEnter', packadd = { 'heirline.nvim', 'nvim-web-devicons', 'volt', 'triforce.nvim' } },
  { mod = 'ui',         fn = 'which_key',  event = 'UIEnter',                         packadd = { 'which-key.nvim' } },
  { mod = 'ui',         fn = 'tiny_diagnostics',  event = 'UIEnter',                  packadd = { 'tiny-inline-diagnostic.nvim' } },
  { mod = 'editing',    fn = 'base_ui',    event = 'UIEnter',                         packadd = { 'blink.lib', 'blink.indent', 'blink.pairs', 'LuaSnip', 'friendly-snippets' } },
  -- { mod = 'topbar',     fn = 'barbecue',   event = 'UIEnter',                         packadd = { 'nvim-navic', 'barbecue.nvim' } },
  -- -------------------------------------------------------------------------
  -- BufReadPre / BufNewFile (core file-level features)
  -- Order matters: lightweight frames first so context renders before
  -- gitsigns/LSP (which can block the autocmd queue for several ms).
  -- -------------------------------------------------------------------------
  { mod = 'treesitter', fn = 'base',     event = { 'BufReadPre', 'BufNewFile' }, packadd = { 'nvim-treesitter' } },
  { mod = 'treesitter', fn = 'context',  event = { 'BufReadPre', 'BufNewFile' }, packadd = { 'nvim-treesitter-context' } },
  { mod = 'git',        fn = 'signs',    event = { 'BufReadPre', 'BufNewFile' }, packadd = { 'gitsigns.nvim', 'plenary.nvim' } },
  { mod = 'lsp',                         event = { 'BufReadPre', 'BufNewFile' }, packadd = { 'goplements.nvim' } },

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
      { '<leader>ol',   desc = '[L]eetcode' },
      { '<leader>fs',   desc = '[s]ymbols (buffer)' },
      { '<leader>fS',   desc = '[S]ymbols (all)' },
      { '<leader>fr',   desc = '[R]eferences' },
      { '<leader>fi',   desc = '[I]mplenentations' },
      { '<leader>fd',   desc = '[d]iagnostics buffer' },
      { '<leader>fD',   desc = '[D]iagnostics (all)' },
      { '<leader>fg',   desc = '[g]rep' },
      {         'gd',   desc = '[G]oto [D]efinition' },
      { '<leader>tl',   desc = '[L]ist' },
      { '<leader>tt',   desc = '[T]erminal' },
    }, packadd = { 'snacks.nvim' } },
  -- Testing
  { mod = 'testing', keys = {
      { '<leader>ctn',   desc = '[N]earest' },
      { '<leader>ctf',   desc = '[F]ile' },
      { '<leader>cts',   desc = '[S]ummary' },
      { '<leader>ctl',   desc = '[L]ast' },
      { '<leader>cte',   desc = 'File with [E]nv' },
    }, packadd = { 'nvim-nio', 'plenary.nvim', 'neotest', 'neotest-golang' } },
  -- Leetcode
  { mod = 'leetcode', keys = {
      { '<leader>ol', desc = '[L]eetcode' }
  }, packadd = { 'plenary.nvim', 'nui.nvim', 'snacks.nvim', 'leetcode.nvim' } },
  -- Sidebar
  { mod = 'sidebar', keys = {
      { '<leader>ef',   desc = '[F]iles' },
      { '<leader>ed',   desc = '[D]atabase' },
      { '<leader>eg',   desc = '[G]RPC' },
      { '<leader>eu',   desc = '[U]ndo' },
      { '<leader>et',   desc = '[T]oggle' },
      { '<leader>er',   desc = '[R]eplace' },
    }, packadd = {'nui.nvim','blink.lib', 'blink.cmp', 'neo-tree.nvim', 'vim-dadbod', 'dbui.nvim', 'vim-dadbod-completion', 'time-machine.nvim', 'grpc-ui.nvim', 'grug-far.nvim' } },
  -- Git Diff
  { mod = 'git', fn = 'diff', keys = {
      { '<leader>gd',   desc = '[Diff] against index' },
      { '<leader>gD',   desc = '[D]iff Last Commit' },
      { '<leader>gm',   desc = '[M]erge Conflict' },
    }, packadd = { 'diffview.nvim', 'plenary.nvim' } },
  -- Tools
  { mod = 'tools', fn = 'productivity', keys = {
      { '<leader>ss',   desc = 'Session Save' },
      { '<leader>sr',   desc = 'Session Restore' },
      { '<leader>Fr',   desc = 'File Rename' },
      { '<leader>Fd',   desc = 'File Duplicate' },
      { '<leader>Fn',   desc = 'File New' },
      { '<leader>Fm',   desc = 'File Move' },
      { '<leader>Fc',   desc = 'File Copy Path' },
      { '<leader>Fc',   desc = 'File Copy Path' },
    } },
  -- AI
  { mod = 'ai', keys = {
      { '<leader>ac',   desc = '[C]ode Companion Toggle' },
      { '<leader>as',   desc = '[S]end to companion', mode = 'v' },
      { '<leader>al',   desc = '[L]ist companions' },
    }, packadd = { 'codecompanion.nvim', 'blink.cmp', 'blink.lib' } },
  -- Preview
  { mod = 'preview', fn = 'json', keys = {
      { '<leader>pj',   desc = '[J]son' },
    }, packadd = { 'jqscratch.nvim' } },
  { mod = 'preview', fn = 'csv', keys = {
      { '<leader>pc',   desc = '[C]sv' },
    }, packadd = { 'csvview.nvim' } },

  -- -------------------------------------------------------------------------
  -- Deferred (idle — load after defer ms)
  -- -------------------------------------------------------------------------
  { mod = 'editing', fn = 'guess_indent',  defer = 1,    packadd = { 'guess-indent.nvim' } },
  { mod = 'notification',                  defer = 1,    packadd = { 'nvim-notify' } },
  -- { mod = 'achievements',                  defer = 500,  packadd = { 'volt', 'triforce.nvim' } },
  { mod = 'preview', fn = 'md',            defer = 50,   packadd = { 'render-markdown.nvim' } },
})
