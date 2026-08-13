-- =============================================================================
-- Core Keymaps
-- Base keymaps from init.lua and lua/enhancement/config/keymaps.lua
-- =============================================================================

map = vim.keymap.set

-- =============================================================================
-- CONFIG
-- =============================================================================

-- Open init.lua
map("n", "<leader>oc", ":e ~/.config/nvim/init.lua<CR>", { desc = "[C]onfig" })

-- Open .zshrc
map("n", "<leader>oz", ":e ~/.zshrc<CR>", { desc = "[Z]hrc" })

-- =============================================================================
-- BASIC
-- =============================================================================

-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- =============================================================================
-- NAVIGATION & WINDOW MANAGEMENT
-- =============================================================================

-- Window resizing
map("n", ">", [[<cmd>vertical resize +5<cr>]], { desc = "Increase vertical size" })
map("n", "<", [[<cmd>vertical resize -5<cr>]], { desc = "Decrease vertical size" })
map("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Increase horizontal size" })
map("n", "-", [[<cmd>horizontal resize -2<cr>]], { desc = "Decrease horizontal size" })
map("n", "=", [[<cmd>wincmd =<cr>]], { desc = "Equalize window sizes" })

-- Previous/next buffer
map("n", "<leader>]", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>[", "<cmd>bprev<cr>", { desc = "Prev Buffer" })

-- Close buffer (uses native bufdelete for safe window-layout-preserving close)
map("n", "<C-x>", function()
	require("core.native").bufdelete()
end, { desc = "Close buffer" })

-- =============================================================================
-- TEXT EDITING ENHANCEMENTS
-- =============================================================================

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move text up and down
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Better paste in visual mode
map("v", "p", '"_dP', { desc = "Paste without overwriting clipboard" })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Center screen when navigating
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- =============================================================================
-- QUICK ACTIONS
-- =============================================================================

-- Toggle line wrapping
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Line [W]rap" })

-- Disable arrows in normal mode
map("n", "<left>", function()
	vim.notify("Use h to move!!")
end)

map("n", "<right>", function()
	vim.notify("Use l to move!!")
end)
map("n", "<up>", function()
	vim.notify("Use k to move!!")
end)
map("n", "<down>", function()
	vim.notify("Use j to move!!")
end)
