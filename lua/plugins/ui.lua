local M = {}

function M.dev_icons()
 require('nvim-web-devicons').setup({
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
 })
end

function M.tiny_diagnostics()
 require("tiny-inline-diagnostic").setup({
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
     diag = "●",
     arrow = "",
   },
 })
end


function M.which_key()
 require("which-key").setup({
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
     { '<leader>p', group = '[P]review' },
     { '<leader>b', group = '[B]uffer' },
     { '<leader>w', group = '[W]orkspace' },
     { '<leader>r', group = '[R]ename' },
     { '<leader>f', group = '[F]ind' },
     { '<leader>u', group = '[U]i' },
     { '<leader>g', group = '[G]it' },
     { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
     { '<leader>t', group = '[T]erminal' },
     { '<leader>a', group = '[A]I' },
     { '<leader>e', group = '[E]dgy' },
   },
 })
end

function M.native()
  -- Native replacements for snacks.nvim features
  -- bigfile and quickfile are loaded via separate VimEnter registry entries.
  local native = require('core.native')

  -- Git operations
  vim.keymap.set('n', '<leader>gb', native.gitbrowse,            { desc = '[b]rowse' })

  -- Buffer operations
  vim.keymap.set('n', '<leader>bd', native.bufdelete,            { desc = '[D]elete' })
  vim.keymap.set('n', '<leader>bD', native.bufdelete_force,      { desc = '[D]elete Force' })
  vim.keymap.set('n', '<leader>bO', native.bufdelete_other,      { desc = 'Delete [O]thers' })
  vim.keymap.set('n', '<leader>ba', native.bufdelete_all,        { desc = 'Delete [A]ll' })

  -- Terminal operations
  vim.keymap.set('n', '<leader>tf', native.terminal_float,       { desc = '[F]loat' })
  vim.keymap.set('n', '<leader>tp', function() native.terminal_repl('python3') end, { desc = '[P]ython REPL' })
  vim.keymap.set('n', '<leader>tn', function() native.terminal_repl('node') end,    { desc = '[N]ode REPL' })
  vim.keymap.set('n', '<leader>ts', native.scratch,              { desc = '[S]cratch Buffer' })
  vim.keymap.set({ 'n', 'v' }, '<leader>tS', native.scratch_select, { desc = '[S]elect Scratch Buffer' })
end

function M.bigfile()
  -- Disable expensive features for files larger than 1.5 MB
  local BIGFILE_SIZE = 1.5 * 1024 * 1024
  vim.api.nvim_create_autocmd('BufReadPre', {
    group = vim.api.nvim_create_augroup('nvimpack-bigfile', { clear = true }),
    callback = function(ev)
      local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
      if not ok or not stat or stat.size <= BIGFILE_SIZE then return end
      vim.b[ev.buf].bigfile = true
      -- Disable treesitter highlighting
      vim.bo[ev.buf].syntax = 'off'
      vim.treesitter.stop(ev.buf)
      -- Disable folding
      vim.wo.foldmethod = 'manual'
      vim.wo.foldexpr   = ''
      -- Disable swapfile for huge files
      vim.bo[ev.buf].swapfile = false
      vim.notify(
        ('Big file (%.1f MB) — treesitter/folding disabled'):format(stat.size / 1024 / 1024),
        vim.log.levels.WARN
      )
    end,
  })
end

function M.quickfile()
  -- Defer plugin loading until after the first buffer is fully read in,
  -- ensuring the initial file renders instantly with syntax alone.
  -- (This is a no-op for startup; just signals the feature is "enabled".)
  -- The real effect is the absence of any blocking BufReadPost work here.
end

return M

