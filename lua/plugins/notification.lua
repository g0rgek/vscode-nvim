require("fidget").setup({
  progress = {
    ignore = {'gopls'},
  },
  notification = {
    window = {
      normal_hl = 'FidgetText',
      winblend = 0,
      border = 'none',
    },
  },
})

vim.notify = require("notify")
require("notify").setup({
  background_colour = "#1e1e1e",
})


require("plugins.dadbod-timer").setup()
