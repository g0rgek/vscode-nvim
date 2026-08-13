-- Disable file watcher to prevent rece condittion that resets timer.
-- THe watcher reloads stats from disk on file change, and a truncate-during-save
-- race can cause load() to return defaults with last_session_start = 0,
-- making the session timer disappear.
-- The autosave timer (30s) and BufWritePre save handle presistence fine.
vim.g.triforce_watch_setup = 1

require("triforce").setup({})

require("heirline.components.triforce").setup({
	session_time = { enabled = true, icon = "󰥔", show_duration = true, format = "short" },
	level = {
		enabled = true,
		prefix = "Lv.",
		show = { level = true, bar = true, percent = false, xp = false },
		bar = { length = 6, chars = { filled = "█", empty = "░" } },
	},
	achievements = { enabled = false, icon = "", show_count = true },
})
vim.keymap.set("n", "<leader>otp", ":Triforce profile<CR>", { desc = "[P]rofile" })
vim.keymap.set("n", "<leader>d", ":Triforce profile daily<CR>", { desc = "[D]aily assignments" })
