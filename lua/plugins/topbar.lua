local M = {}

function M.barbar()
  require("barbar").setup({
    sidebar_filetypes = {
      ["neo-tree"] = {event = "BufWipeout"},
    },
    clickable = false,
    animation = false,
    highlight_alternate = false,
    icons = {
      enabled = true,
      filetype = { enabled = true, custom_colors = false },
      preset = "default",
      separator_at_end = false,
      current = {
        separator = { left = "", right = "" },
      },
      inactive = {
        separator = { left = "", right = "" },
      },
    },
    highlight_inactive_file_icons = true,
  })
end

function M.barbecue()
  require('barbecue').setup({
    exclude_filetypes = { 'txt', 'terminal', 'netrw', 'toggleterm', 'snacks_picker_list', 'neo-tree', 'sql', 'dbout', 'jq', 'yq'},
    theme = {
      normal = { bg = '#2D2D2D', bold = false },
    },
    create_autocmd = true,
  })

  -- setup() only registers autocmds; it does NOT render the current window.
  -- Since we lazy-load on UIEnter, the initial BufWinEnter already fired,
  -- so without this call the winbar stays blank until CursorMoved/InsertLeave.
  vim.schedule(function()
    pcall(require('barbecue.ui').update)
  end)
end

return M
