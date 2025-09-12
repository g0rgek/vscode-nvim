-- Make cursor solid block
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
-- Set <,> as the leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

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
vim.opt.list = true

-- Configure how they look
vim.opt.listchars = {
  tab = '» ',
  trail = '·', -- Show a dot for trailing spaces
  extends = '⟩', -- Show when text extends past screen
  precedes = '⟨', -- Show when text precedes the screen
  space = '·', -- Show a dot for spaces (indents)
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

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
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
  'NMAC427/guess-indent.nvim',
  -- Print auto-paired brackets
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
  -- Autocomplete closing HTML tags
  {
    'rayliwell/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  -- Display colored git lines on gutter
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },
  -- Display help when key is pressed
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
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
        breadcrumb = ' ',
        separator = '󱦰  ',
        group = '󰹍 ',
      },
      spec = {
        { '<leader>', group = 'Leader' },
        { '<leader>o', group = '[O]pen' },
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>pt', group = '[T]ypst' },
        { '<leader>pm', group = '[M]arkdown' },
        { '<leader>ps', group = '[S]trudel' },
        { '<leader>pc', group = '[C]SV' },
        { '<leader>p', group = '[P]review' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>f', group = '[F]ind' },
        { '<leader>u', group = '[U]i' },
        { '<leader>g', group = '[G]it' },
        { '<leader>t', group = '[T]erminal' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  -- QoL plugins (indent lines, picker, lazygit, toggle)
  {
    'folke/snacks.nvim',
    lazy = false,
    opts = {
      gitbrowse = {},
      toggle = {
        which_key = true,
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
      { '<leader>ca', vim.lsp.buf.code_action, desc = '[A]ction' },
      {
        '<leader>fI',
        function()
          require('snacks.picker').lsp_implementations()
        end,
        desc = '[I]mplementations',
      },
      {
        '<leader>fR',
        function()
          require('snacks.picker').lsp_references()
        end,
        desc = '[R]eferences',
      },
      {
        '<leader>fd',
        function()
          require('snacks.picker').diagnostics_buffer()
        end,
        desc = '[D]iagnostics (buffer)',
      },
      {
        '<leader>fD',
        function()
          require('snacks.picker').diagnostics()
        end,
        desc = '[D]iagnostics (all)',
      },
      {
        '<leader>gb',
        function()
          require('snacks').gitbrowse()
        end,
        mode = { 'n', 'x' },
        desc = '[B]rowse',
      },
      {
        mode = 'n',
        '<leader>ff',
        function()
          require('snacks.picker').files()
        end,
        desc = '[F]iles',
      },
      {
        mode = 'n',
        '<leader>fg',
        function()
          require('snacks.picker').grep()
        end,
        desc = '[G]rep',
      },
      {
        mode = 'n',
        '<leader>fb',
        function()
          require('snacks.picker').buffers()
        end,
        desc = '[B]uffers',
      },
      {
        mode = 'n',
        '<leader>fs',
        function()
          require('snacks.picker').lsp_symbols()
        end,
        desc = '[S]ymbols (buffer)',
      },
      {
        mode = 'n',
        '<leader>fS',
        function()
          require('snacks.picker').lsp_workspace_symbols()
        end,
        desc = '[S]ymbols (all)',
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
        desc = 'Lazy[G]it',
      },
    },
  },
  -- Git Diff view
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[D]iff' },
      { '<leader>gc', '<cmd>DiffviewClose<CR>', desc = '[D]iff close' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = '[H]istory (file)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<CR>', desc = '[H]istory (project)' },
      { '<leader>gl', '<cmd>.DiffviewFileHistory --follow<CR>', desc = 'History [L]ine' },
      { '<leader>gl', '<cmd>.DiffviewFileHistory --follow<CR>', desc = 'History [L]ine[s]', mode = 'v' },
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
    keys = {
      { '<leader>e', ':Neotree reveal<CR>', desc = '[E]xplorer', silent = true },
    },
    config = function()
      require('neo-tree').setup {
        filesystem = {
          window = {
            mappings = {
              ['<leader>e'] = 'close_window',
            },
          },
        },
        source_selector = {
          separator = { left = '', right = '' },
          separator_active = nil,
          show_separator_on_edge = false,
        },
      }
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    -- config = function()
    --   require('toggleterm').setup {
    --     shade_terminals = false,
    --     highlights = {
    --       Normal = {
    --         guibg = '#202020',
    --       },
    --     },
    --   }
    -- end,
    keys = {
      { '<leader>t', '<cmd>ToggleTerm dir=git_dir<CR>', desc = '[T]erminal', mode = 'n' },
      { '<leader>t', [[<C-\><C-n><cmd>ToggleTerm<CR>]], desc = 'Close terminal', mode = 't' },
    },
  },
  {
    'romgrk/barbar.nvim',
    lazy = false,
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>]', '<cmd>BufferNext<CR>', desc = 'Next Buffer' },
      { '<leader>[', '<cmd>BufferPrevious<CR>', desc = 'Prev Buffer' },
      { '<leader>bc', '<cmd>BufferClose<CR>', desc = '[C]lose' },
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config = function()
      require('barbar').setup {
        sidebar_filetypes = {
          ['neo-tree'] = { event = 'BufWipeout' },
        },
        animation = false,
        highlight_alternate = false,
        icons = {
          -- TODO: bg of icons stays same color
          -- despite changing hl group color
          -- fo now they're turned off
          filetype = { enabled = true, custom_colors = false },
          preset = 'default',
          separator_at_end = false,
          current = {
            separator = { left = '', right = '' },
          },
          inactive = {
            separator = { left = '', right = '' },
          },
        },

        highlight_inactive_file_icons = true,
      }
    end,
    version = '^1.9.1',
  },
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('barbecue').setup {
        exclude_filetypes = { 'terminal', 'netrw', 'toggleterm', 'snacks_picker_list', 'neo-tree' },
        theme = {
          normal = { bg = '#2D2D2D', bold = false },
        },
        create_autocmd = false, -- prevent barbecue from updating itself automatically
      }

      vim.api.nvim_create_autocmd({
        'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
        'BufWinEnter',
        'CursorHold',
        'InsertLeave',

        -- include this if you have set `show_modified` to `true`
        -- 'BufModifiedSet',
      }, {
        group = vim.api.nvim_create_augroup('barbecue.updater', {}),
        callback = function()
          require('barbecue.ui').update()
        end,
      })
    end,
  },
  -- Status updates for LSP.
  {
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        display = {
          group_style = 'FidgetLSPName',
        },
      },
      notification = {
        window = {
          normal_hl = 'FidgetText',
          winblend = 0,
          border = 'rounded',
        },
      },
    },
  },
  -- Main LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'j-hui/fidget.nvim',
      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
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
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            vim.g.inlay_hints_visible = true
            local snacks = require 'snacks'
            local ft = vim.bo.filetype
            snacks
              .toggle({
                name = 'Inlay [H]ints',
                get = vim.lsp.inlay_hint.is_enabled,
                set = function(state)
                  vim.lsp.inlay_hint.enable(state)
                  if ft == 'go' then
                    require('goplements').toggle()
                  end
                end,
              })
              :map '<leader>uh'
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        signs = false,
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

      local orig_capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require('blink.cmp').get_lsp_capabilities(orig_capabilities)

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      -- local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      local servers = {
        lua_ls = {},
        gopls = {},
      }
      -- ---@type MasonLspconfigSettings
      -- ---@diagnostic disable-next-line: missing-fields
      -- require('mason-lspconfig').setup {
      --   automatic_enable = vim.tbl_keys(servers or {}),
      -- }

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
      -- Ensure the servers and tools above are installed
      -- To check the current status run :Mason
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      vim.lsp.config('lua_ls', {
        settings = {
          telemetry = { enable = false },
          Lua = {
            diagnostics = {
              globals = { 'vim' },
              disable = { 'missing-fields' },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })
      -- Installed LSPs are configured and enabled automatically with mason-lspconfig
      -- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
      -- for server_name, config in pairs(servers) do
      --   vim.lsp.config(server_name, config)
      -- end
      -- NOTE: Some servers may require an old setup until they are updated. For the full list refer here: https://github.com/neovim/nvim-lspconfig/issues/3705
      -- These servers will have to be manually set up with require("lspconfig").server_name.setup{}
    end,
  },
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      lsp_inlay_hints = {
        enable = false,
      },
      -- lsp_keymaps = false,
      -- other options
    },
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
      vim.diagnostic.config {
        signs = false,
      }

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
            codelenses = {
              generate = true,
              gc_details = true,
              test = true,
              tidy = true,
              vendor = true,
              regenerate_cgo = true,
              upgrade_dependency = true,
            },
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
    end,
  },
  -- Golang: show implementations as inlay hints
  {
    'maxandron/goplements.nvim',
    ft = 'go',
    opts = {},
  },
  -- Auto-formating
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>bf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        desc = '[F]ormat',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        -- You can use 'stop_after_first'
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        lua = { 'stylua' },
        python = { 'ruff_format' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        templ = { 'templ', 'injected' },
        markdown = { 'prettierd' },
      },
    },
  },
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = { 'rafamadriz/friendly-snippets' },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for <C-y> to accept
      -- 'super-tab' for tab to accept (vscode)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      keymap = { preset = 'super-tab' },

      appearance = {
        nerd_font_variant = 'mono',
      },

      -- Customize completion window
      -- Make it tansparent with round border
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
          },
        },
        menu = {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        },
      },

      --Print function signature when passing args
      signature = {
        enabled = true,
        window = {
          border = 'rounded',
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      snippets = { preset = 'default' },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  -- Treesitter to parse lang. syntax
  {
    'nvim-treesitter/nvim-treesitter',
    version = 'main',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'go',
        'gomod',
        'gosum',
        'gotmpl',
        'templ',
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'python',
      },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  -- Show inside which function the cursor at
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = function()
      local tsc = require 'treesitter-context'
      local snacks = require 'snacks'
      snacks
        .toggle({
          name = 'Treesitter [C]ontext',
          get = tsc.enabled,
          set = function(state)
            if state then
              tsc.enable()
            else
              tsc.disable()
            end
          end,
        })
        :map '<leader>uc'
      return { mode = 'cursor', max_lines = 3 }
    end,
  },
  -- Pretty inline diagnostic messages
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    config = function()
      require('tiny-inline-diagnostic').setup {
        options = {
          show_all_diags_on_cursorline = true,
          multilines = {
            enabled = true,
          },
          show_source = {
            enabled = true,
            if_many = false,
          },
          add_messages = true,
        },
        signs = {
          diag = '●',
          arrow = '',
        },
      }
      vim.diagnostic.config { virtual_text = false }
    end,
  },
  -- [[Preview PLUGINS]]
  -- Typst preview
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '1.*',
    opts = {},
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
  -- Strudel preview
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
  -- Markdown preview
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
  -- CSV preview
  {
    'hat0uma/csvview.nvim',
    ft = { 'csv' },
    keys = {
      {
        '<leader>pcr',
        '<cmd>CsvViewEnable display_mode=border header_lnum=1<CR>',
        desc = 'csv [R]un',
      },
      {
        '<leader>pcs',
        '<cmd>CsvViewDisable<CR>',
        desc = 'csv [S]top',
      },
    },
    opts = {
      parser = { comments = { '#', '//' } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  },
  {
    'f-person/git-blame.nvim',
    event = 'VeryLazy',
    opts = {
      enabled = true, -- if you want to enable the plugin
      message_template = '<author> (<date>)', -- template for the blame message, check the Message template section for more options
      date_format = '%r', -- template for the date, check Date format section for more options
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.g.gitblame_display_virtual_text = 0
      local lualine = require 'lualine'
      local git_blame = require 'gitblame'

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
        color = { fg = '#CCC' },
      }

      lualine.setup {
        options = {
          theme = 'auto',
          section_separators = '',
          component_separators = '',
          icons_enabled = false,
          globalstatus = true,
          disabled_filetypes = {
            statusline = { 'NvimTree', 'toggleterm', 'terminal' },
            winbar = { 'toggleterm', 'terminal' },
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
              color = { fg = '#CCC' },
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
  -- Main theme
  {
    'Mofiqul/vscode.nvim',
    priority = 999,
    config = function()
      require('vscode').setup {
        transparent = true, -- set to true if you want transparent background
        italic_comments = false, -- make comments italic
        disable_nvimtree_bg = false, -- use same bg for nvim-tree
        color_overrides = {
          vscTabCurrent = '#2D2D2D',
          vscTabOther = '#202020',
        },
      }
      require('vscode').load 'dark' -- load 'dark' variant for VSCode Dark Modern
    end,
  },
  -- Colored icons
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        variant = 'dark',
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
        },
      }
    end,
  },
}
require('goplements').toggle()
-- [UI colors]
-- To match vscode Dark+ theme
local c = require('vscode.colors').get_colors()

-- Basic Neovim UI settings
vim.opt.termguicolors = true -- enable true colors
vim.opt.background = 'dark' -- ensure dark mode background

-- Vscode builtin and custom types have the same color
vim.api.nvim_set_hl(0, '@type.builtin', { fg = c.vscBlueGreen, bg = 'NONE' })

-- Whitespace color
vim.api.nvim_set_hl(0, 'Whitespace', { fg = '#3E3E3E', bg = 'NONE', nocombine = true })

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
-- To apply same colors to default diagnostics
-- Use DiagnosticVirtualTextError, DiagnosticVirtualTextWarn,...
vim.api.nvim_set_hl(0, 'DiagnosticError', { bg = '#3A2725', fg = '#FF6464' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { bg = '#3E2F23', fg = '#FA973B' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { bg = '#233332', fg = '#30AF65' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { bg = '#24313A', fg = '#569CD6' })
