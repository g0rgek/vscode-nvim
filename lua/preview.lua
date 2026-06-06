local M = {}

function M.json()
 require('jqscratch').setup({
   ft = "json", "yaml", "yml",
 })

 -- Keymaps
 vim.keymap.set("n", "<leader>pj", function()
   require("jqscratch").toggle()
 end, { desc = "[J]son" })

end

function M.csv()
 require('csvview').setup({
   ft = "csv", "dbout",
 })

 -- Keymaps
 vim.keymap.set("n", "<leader>pc", '<cmd>CsvViewToggle display_mode=border header_lnum=1<CR>', { desc = "[C]sv" })
end

function M.md()
 require("render-markdown").setup({
   file_types = { 'markdown', 'md', 'codecompanion' },
   render_modes = { 'n', 'c', 't' },
   preset = 'obsidian',
   completions = {
     blink = { enabled = true },
     lsp = { enabled = true },
   },
 })

 vim.api.nvim_set_keymap("n", "<leader>pm", "<CMD>RenderMarkdown toggle<CR>", { desc = "[M]arkdown" })
end

function M.init()
	M.json()
	M.csv()
	M.md()
end

return M
