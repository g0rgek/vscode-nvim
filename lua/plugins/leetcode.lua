require('leetcode').setup({
  hooks = {
    ["enter"] = { function()
      vim.o.showtabline = 0
      require("barbecue.ui").toggle(false)
    end },
    ["leave"] = { function()
      vim.o.showtabline = 2
      require("barbecue.ui").toggle(true)
    end },
    ["question_enter"] = { function(question)
      vim.keymap.set("n", "td", function()
        question.description:toggle()
      end, { buffer = question.bufnr, desc = "Toggle description" })
    end },
  },
  problem_bank = {
    directory = "/Users/23603840/proj/lcp/",
    index     = "/Users/23603840/proj/lcp/index.html",
  },
})

vim.keymap.set('n', '<leader>ol', ':Leet<CR>', { desc = '[L]eetcode' })
vim.keymap.set('n', '<leader>ls', ':Leet submit<CR>', { desc = '[S]ubmit' })
vim.keymap.set('n', '<leader>lt', ':Leet tabs<CR>', { desc = '[T]abs' })
vim.keymap.set('n', '<leader>ld', ':Leet desc toggle<CR>', { desc = '[D]escription' })
vim.keymap.set('n', '<leader>lh', ':Leet hints<CR>', { desc = '[H]ints' })
vim.keymap.set('n', '<leader>lm', ':Leet mark<CR>', { desc = '[M]ark as done' })
vim.keymap.set('n', '<leader>ll', ':Leet list<CR>', { desc = '[L]ist problems' })
