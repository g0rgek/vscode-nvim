local M = {}

function M.signs()
  -- gitsigns.nvim
  local gitsigns = require('gitsigns')

  gitsigns.setup({
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation: ]c and [c are special — they work in diff mode too
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions (visual mode)
      map('v', '<leader>hs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Git [s]tage hunk' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Git [r]eset hunk' })

      -- Actions (normal mode)
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[r]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = '[u]ndo stage hunk' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
      map('n', '<leader>hb', gitsigns.blame_line, { desc = '[b]lame line' })

    end,
  })
end

function M.diff()
  -- diffview.nvim
  local diffview = require('diffview')

  diffview.setup({
    diff_binaries = false,
    enhanced_diff_hl = true,
    use_per_buffer_settings = 'only',
    show_help_hints = true,
    hooks = {
      diff_buf_read = function(bufnr)
        vim.keymap.set('n', 'q', ':DiffviewClose<CR>', { buffer = bufnr, desc = 'Close diffview' })
        vim.keymap.set('n', '<leader>q', ':DiffviewClose<CR>', { buffer = bufnr, desc = 'Close diffview' })
      end,
    },
    keymaps = {
      disable_defaults = false,
      view = {
        ['<leader>q'] = ':DiffviewClose<CR>',
        ['q'] = ':DiffviewClose<CR>',
      },
      diff_builder = {
        [']c'] = function() diffview.nav_hunk('next') end,
        ['[c'] = function() diffview.nav_hunk('prev') end,
      },
    },
    defaults = {
      view = {
        default = {
          layout = 'diff3_mixed',
        },
      },
      file_history = {
        layout = 'diff3_mixed',
      },
    },
  })

  vim.opt.fillchars:append({ diff = "░" })

  -- Keybindings for opening diffs
  vim.keymap.set('n', '<leader>gd', function()
    vim.cmd('DiffviewOpen')
  end, { desc = '[d]iff against index' })

  vim.keymap.set('n', '<leader>gD', function()
    vim.cmd('DiffviewOpen HEAD^')
  end, { desc = '[D]iff against last commit' })

  vim.keymap.set('n', '<leader>gm', function()
    vim.cmd('DiffviewOpen --conflict')
  end, { desc = '[m]erge conflict' })
end

function M.neogit()
 require("neogit").setup({
   disable_commit_confirmation = true,
   integrations = {
      diffview = true,
   }
 })

 vim.keymap.set("n", "<leader>gn", ":Neogit<cr>", {desc = "[n]eogit"})
 vim.keymap.set("n", "<leader>gl", ":NeogitLogCurrent<cr>", {desc = "[l]og"})
end

function M.blame()
  require('gitblame').setup({
    enabled = false,              -- off by default, toggle with <leader>ga
    date_format = '%r',          -- relative dates ("3 days ago")
    highlight_group = 'NonText', -- subtle styling
  })

  vim.keymap.set('n', '<leader>ga', ':GitBlameToggle<CR>', { desc = 'Toggle git [a]nnotation (inlay hints)' })
end

return M


