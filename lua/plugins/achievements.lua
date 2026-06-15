require("triforce").setup({})

require("heirline.components.triforce").setup({
  level = {
    enabled = true,
    prefix = 'Lv.',
    show = { level = true, bar = true, percent = false, xp = false },
    bar = { length = 6, chars = { filled = '█', empty = '░' } },
  },
  achievements = { enabled = false, icon = "", show_count = true },
  session_time = { enabled = true, icon = "󰥔", show_duration = true, format = "short" }
})
vim.keymap.set("n", "<leader>otp", ":Triforce profile<CR>", { desc = "[P]rofile" })

