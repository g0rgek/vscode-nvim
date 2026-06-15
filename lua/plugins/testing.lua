require("neotest").setup({
  diagnostic = {
    severity = vim.diagnostic.severity.ERROR,
  },
  adapters = {
    require("neotest-golang")({
      runner = "gotestsum",
      extra_args = { "-race", "-count=1" },
      warn_test_name_dupes = false,
    }),
  },
  status = { virtual_text = true, signs = false },
  output = { open_on_run = true, close_on_exit = true },
  quickfix = {
    open = function()
      vim.cmd('copen 10')
    end,
  },
  discovery = { enabled = true },
  diagnostic = { enabled = true },
})

-- Force all neotest-golang diagnostic underlines to ERROR (red) instead of HINT (blue)
local ok, diag = pcall(require, "neotest-golang.lib.diagnostics")
if ok then
  diag.is_hint_message = function() return false end
end

-- Keybinds
vim.keymap.set("n", "<leader>ctn", function() require("neotest").run.run() end,
  { desc = "Test Nearest" })
vim.keymap.set("n", "<leader>ctf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test File" })
vim.keymap.set("n", "<leader>cts", function() require("neotest").summary.toggle() end,
  { desc = "Test Summary" })
vim.keymap.set("n", "<leader>ctl", function() require("neotest").run.run_last() end,
  { desc = "Test Last" })
