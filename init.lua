-- Set <,> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
local vim = vim
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Set height of command line under status line
vim.o.cmdheight = 0

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
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

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
-- vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Install and configure plugins ]]
require('lazy').setup {
  -- VSCode theme plugin
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    config = function()
      require('vscode').setup {
        transparent = true, -- set to true if you want transparent background
        italic_comments = false, -- make comments italic
        disable_nvimtree_bg = true, -- use same bg for nvim-tree
      }
      require('vscode').load 'dark' -- load 'dark' variant for VSCode Dark Modern
    end,
  },
  -- Show keybinds
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      preset = 'helix',
      delay = 0,
      win = {
        height = {
          max = math.huge,
        },
      },
      icons = {
        rules = false,
        breadcrumb = ' ', -- symbol used in the command line area that shows your active key combo
        separator = '󱦰  ', -- symbol used between a key and it's label
        group = '󰹍 ', -- symbol prepended to a group
      },
      -- Document existing key chains
      spec = {
        { '<leader>', group = 'Leader' },
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>pt', group = '[T]ypst' },
        { '<leader>pm', group = '[M]arkdown' },
        { '<leader>ps', group = '[S]trudel' },
        { '<leader>p', group = '[P]review' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>f', group = '[F]ind' },
        { '<leader>u', group = '[U]i' },
        { '<leader>g', group = '[G]it' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
  -- Adds git related signs to the gutter
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },
  -- Indent line for code blocks
  {
    'folke/snacks.nvim',
    lazy = false,
    opts = {
      gitbrowse = {},
      toggle = {
        which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
      },
      lazygit = {
        win = {
          style = 'lazygit',
          border = 'rounded',
        },
      },
      picker = {
        layout = {
          preset = 'vscode',
          preview = 'main',
          layout = {
            border = 'rounded',
          },
        },
      },
      indent = {
        enabled = true,
        animate = { enabled = false },
        indent = {
          enabled = true,
          only_current = false,
          only_scope = false,
        },
        scope = {
          enabled = true,
          only_current = true,
        },
        chunk = { enabled = false },
        filter = function(buf)
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == '' and vim.bo[buf].filetype ~= 'markdown'
        end,
      },
    },
    keys = {
      { '<leader>ca', vim.lsp.buf.code_action, desc = 'LSP [C]ode [A]ction' },
      {
        '<leader>fI',
        function()
          require('snacks.picker').lsp_implementations()
        end,
        desc = '[F]ind [I]mplementations',
      },
      {
        '<leader>fR',
        function()
          require('snacks.picker').lsp_references()
        end,
        desc = '[F]ind [R]eferences',
      },
      {
        '<leader>fd',
        function()
          require('snacks.picker').diagnostics_buffer()
        end,
        desc = '[F]ind buffer [D]iagnostics',
      },
      {
        '<leader>fD',
        function()
          require('snacks.picker').diagnostics()
        end,
        desc = '[F]ind all [D]iagnostics',
      },
      {
        '<leader>gb',
        function()
          require('snacks').gitbrowse()
        end,
        mode = { 'n', 'x' },
        desc = '[G]it [B]rowse',
      },
      -- Find files (like Ctrl+P in VSCode)
      {
        mode = 'n',
        '<leader>ff',
        function()
          require('snacks.picker').files()
        end,
        desc = '[F]ind [F]iles',
      },
      -- Search text in project (like Ctrl+Shift+F)
      {
        mode = 'n',
        '<leader>fg',
        function()
          require('snacks.picker').grep()
        end,
        desc = '[L]ive [G]rep',
      },
      -- Search buffers (like VSCode "Open Editors")
      {
        mode = 'n',
        '<leader>fb',
        function()
          require('snacks.picker').buffers()
        end,
        desc = '[F]ind [B]uffers',
      },
      -- Search document symbols (like Ctrl+Shift+O)
      {
        mode = 'n',
        '<leader>fs',
        function()
          require('snacks.picker').lsp_symbols()
        end,
        desc = '[F]ind buffer [S]ymbols',
      },
      -- Search workspace symbols (like VSCode Cmd+T)
      {
        mode = 'n',
        '<leader>fS',
        function()
          require('snacks.picker').lsp_workspace_symbols()
        end,
        desc = '[F]ind all [S]ymbols',
      },
      {
        'gd',
        function()
          require('snacks.picker').lsp_definitions()
        end,
        desc = '[G]oto [D]efinition',
      },
      {
        mode = 'n',
        '<leader>gg',
        function()
          require('snacks.lazygit').open()
        end,
        desc = '[G]it Lazy[G]it',
      },
    },
  },
  -- Colored icons
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        color_icons = true,
        default = true,
        override = {
          go = {
            icon = '󰟓',
            color = '#519ABA',
            name = 'Go',
          },
          md = {
            icon = '',
            color = '#519ABA',
            name = 'Md',
          },
          py = {
            icon = '',
            color = '#519ABA',
            name = 'Py',
          },
        },
      }
    end,
  },
  -- Tree-sitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'go', 'gomod', 'gosum', 'gotmpl', 'templ', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  {
    'rayliwell/tree-sitter-rstml',
    dependencies = { 'nvim-treesitter' },
    build = ':TSUpdate',
    config = function()
      require('tree-sitter-rstml').setup()
    end,
  },
  {
    'rayliwell/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  -- Buffer line with colored icons
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = false,
      -- Set the filetypes which barbar will offset itself for
      sidebar_filetypes = {
        ['neo-tree'] = { event = 'BufWipeout' },
      },
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- highlight_visible = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.9.1', -- optional: only update when a new 1.x version is released
  },
  -- Vscode beadcrumb
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    config = function()
      require('barbecue').setup {
        create_autocmd = false, -- prevent barbecue from updating itself automatically
        exclude_filetypes = { -- don't process these
          statusline = { 'NvimTree', 'toggleterm', 'terminal' }, -- disable for statusline
          winbar = { 'toggleterm', 'terminal', 'snacks_picker_list' }, -- disable for winbar (if you use it)
        },
      }

      vim.api.nvim_create_autocmd({
        'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
        'BufWinEnter',
        'CursorHold',
        'InsertLeave',

        -- include this if you have set `show_modified` to `true`
        'BufModifiedSet',
      }, {
        group = vim.api.nvim_create_augroup('barbecue.updater', {}),
        callback = function()
          require('barbecue.ui').update()
        end,
      })
    end,
    opts = {
      -- configurations go here
    },
  },
  -- Git-blame plugin
  {
    'f-person/git-blame.nvim',
    -- load the plugin at startup
    event = 'VeryLazy',
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin will only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
      -- your configuration comes here
      -- for example
      enabled = true, -- if you want to enable the plugin
      message_template = '<author> (<date>)', -- template for the blame message, check the Message template section for more options
      date_format = '%r', -- template for the date, check Date format section for more options
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    },
  },
  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.g.gitblame_display_virtual_text = 0
      local lualine = require 'lualine'
      local git_blame = require 'gitblame'
      -- simplified lang_version: buffer-local cache

      local function lang_version()
        -- use buffer variable as cache
        if vim.b.lang_version_cache ~= nil then
          return vim.b.lang_version_cache
        end

        local ft = vim.bo.filetype
        local ver = ''

        if ft == 'go' then
          local out = vim.fn.system('go version'):gsub('\n', '')
          ver = out:match 'go version%s+go([%d%.]+)' or ''
        elseif ft == 'rust' then
          local out = vim.fn.system('rustc --version'):gsub('\n', '')
          ver = out:match 'rustc%s+([%w%.%-]+)' or ''
        elseif ft == 'c' or ft == 'cpp' then
          local out = vim.fn.system('gcc --version | head -n1'):gsub('\n', '')
          ver = out:match 'gcc[^%d]*([%d%.]+)' or ''
        elseif ft == 'python' then
          local out = vim.fn.system('python --version 2>&1'):gsub('\n', '')
          ver = out:match 'Python%s+([%d%.]+)' or ''
          local venv = os.getenv 'VIRTUAL_ENV'
          if venv then
            local venv_name = vim.fn.fnamemodify(venv, ':t')
            ver = ver .. ' (' .. venv_name .. ')'
          end
        elseif ft == 'typst' then
          local out = vim.fn.system('typst -V'):gsub('\n', '')
          ver = out:match '(%d+%.%d+%.%d+)' or ''
        end

        -- store in buffer cache
        vim.b.lang_version_cache = ver
        return ver
      end

      -- Helper to get LSP clients
      local function lsp_clients()
        local clients = vim.lsp.get_active_clients { bufnr = 0 }
        if #clients == 0 then
          return ''
        end
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return table.concat(names, ',')
      end

      -- Diagnostics component with VSCode-like icons
      local diagnostics = {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn', 'info', 'hint' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌶 ' },
        colored = false,
        update_in_insert = false,
        color = { fg = '#CCC' }, -- white
      }

      lualine.setup {
        options = {
          theme = 'vscode', -- picks colors from current colorscheme (VSCode.nvim)
          section_separators = '',
          component_separators = '',
          icons_enabled = false,
          globalstatus = true, -- VSCode-like single statusline
          disabled_filetypes = { -- don't process these
            statusline = { 'NvimTree', 'toggleterm', 'terminal' }, -- disable for statusline
            winbar = { 'toggleterm', 'terminal' }, -- disable for winbar (if you use it)
          },
        },
        sections = {
          lualine_a = { { 'mode' } },
          lualine_b = {
            {
              color = { fg = '#CCC' }, -- white
              'branch',
              icon = '',
            },
            diagnostics,
          },
          lualine_c = {},
          lualine_x = {
            {
              git_blame.get_current_blame_text,
              cond = git_blame.is_blame_text_available,
              color = { fg = '#CCC' }, -- white
            },
          },
          lualine_y = {
            {
              function()
                local line = vim.fn.line '.'
                local col = vim.fn.col '.'
                return string.format('Ln %d, Col %d', line, col)
              end,
              color = { fg = '#CCC' }, -- white
            },
            {
              'encoding',
              color = { fg = '#CCC' }, -- white
            },
            {
              lsp_clients,
              color = { fg = '#CCC' }, -- white
            },
            {
              'filetype',
              color = { fg = '#CCC' }, -- white
            },
            {
              lang_version,
              color = { fg = '#CCC' },
            },
          },
          lualine_z = {},
        },
        -- inactive_sections = {
        -- },
      }
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    keys = {
      { '<leader>tt', '<cmd>ToggleTerm dir=git_dir<CR>', desc = 'Toggle terminal', mode = 'n' },
      { '<leader>tt', [[<C-\><C-n><cmd>ToggleTerm<CR>]], desc = 'ReToggle terminal', mode = 't' },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    lazy = true, -- neo-tree will lazily load itself
    keys = {
      -- open term
      { '<leader>e', '<cmd>Neotree toggle<CR>', desc = 'Explorer' },
      -- change focus to term
      {
        '<leader>o',
        function()
          if vim.bo.filetype == 'neo-tree' then
            vim.cmd.wincmd 'p'
          else
            vim.cmd.Neotree 'focus'
          end
        end,
        desc = 'Explorer Focus',
      },
    },
  },
  {
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        display = {
          group_style = 'Lsp_Name',
        },
      },
      notification = {
        window = {
          normal_hl = 'Lsp_Text',
          winblend = 0, -- 0 keeps transparency consistent
          border = 'rounded',
        },
      },
    },
  },
  -- Main LSP Configuration
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>uh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              require('goplements').toggle()
            end, '[T]oggle Inlay [H]ints')
            vim.lsp.inlay_hint.enable(false)
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local orig_capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require('blink.cmp').get_lsp_capabilities(orig_capabilities)
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- bashls = {},
        marksman = {},
        pyrefly = {},
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        -- lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        -- settings = {
        --   Lua = {
        --     completion = {
        --       callSnippet = 'Replace',
        --     },
        --     -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        --     -- diagnostics = { disable = { 'missing-fields' } },
        --   },
        -- },
        -- },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'ruff',
        'pyrefly',
        -- 'goimports',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  -- Auto-complete window
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'super-tab' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
          },
        },
        menu = {
          border = 'rounded',
          draw = { gap = 2 },
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        },
      },

      -- (Default) Only show the documentation popup when manually triggered
      -- completion = {
      --   menu = { border = 'rounded', winblend = 0 },
      --   documentation = { window = { border = 'single' } },
      -- },
      signature = { enabled = true },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  -- Auto-formating
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- go = { 'goimports' },
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'ruff_format' },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { 'rustfmt', lsp_format = 'fallback' },
        -- Conform will run the first available formatter
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        templ = {
          'templ',
          'injected',
        },
        markdown = { 'prettierd' },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    },
  },
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {},
    config = function(lp, opts)
      require('go').setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })

      vim.lsp.config('gopls', {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod' },
        root_markers = { '.git', 'go.mod' },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              useany = true,
            },
            completeUnimported = true,
            diagnosticsDelay = '250ms',
            diagnosticsTrigger = 'Save',
            gofumpt = false,
            -- staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })
      vim.lsp.enable 'gopls'
      -- local gopls_cfg = require('go.lsp').config()

      -- -- gopls_cfg.filetypes = { 'go', 'gomod'}, -- override settings
      -- vim.lsp.config.gopls = gopls_cfg
      -- vim.lsp.enable 'gopls'
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    'maxandron/goplements.nvim',
    ft = 'go',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iff' },
      { '<leader>gc', '<cmd>DiffviewClose<CR>', desc = '[G]it [D]iff close' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it file [H]istory' },
      { '<leader>gp', '<cmd>DiffviewFileHistory<CR>', desc = '[G]it project [H]istory' },
    },
  },
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '1.*',
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
    keys = {
      {
        '<leader>ptr',
        '<cmd>TypstPreview<CR>',
        desc = 'typst [R]un',
      },
      {
        '<leader>pts',
        '<cmd>TypstPreviewStop<CR>',
        desc = 'typst [S]top',
      },
    },
  },
  {
    'gruvw/strudel.nvim',
    ft = { 'str' },
    build = 'npm install',
    config = function()
      require('strudel').setup()
    end,
    keys = {
      {
        '<leader>psr',
        '<cmd>StrudelLaunch<CR>',
        desc = 'strudel [R]un',
      },
      {
        '<leader>pss',
        '<cmd>StrudelQuit<CR>',
        desc = 'strudel [S]top',
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
    keys = {
      {
        '<leader>pmr',
        '<cmd>MarkdownPreview<CR>',
        desc = 'markdown [R]un',
      },
      {
        '<leader>pms',
        '<cmd>MarkdownPreviewStop<CR>',
        desc = 'markdown [S]top',
      },
    },
  },
}

require('goplements').disable()
vim.api.nvim_set_hl(0, 'Lsp_Name', { fg = '#9CDCFE', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'Lsp_Text', { fg = '#D4D4D4', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'Goplements', { fg = require('vscode.colors').get_colors().vscSuggestion, bg = 'NONE' })
-- Basic Neovim UI settings
vim.opt.termguicolors = true -- enable true colors
vim.opt.background = 'dark' -- ensure dark mode background
-- Make float window transparent too
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
-- vim.diagnostic.config { signs = false }
-- vim.opt.signcolumn = 'no'

vim.keymap.set('n', '<leader>]', ':bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '<leader>[', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Prev buffer' })
-- For vscode theme to builtin and custom types have the same color
local c = require('vscode.colors').get_colors()
vim.api.nvim_set_hl(0, '@type.builtin', { fg = c.vscBlueGreen, bg = 'NONE' })
