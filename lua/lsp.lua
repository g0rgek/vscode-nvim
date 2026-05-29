vim.lsp.enable({
  "gopls",
  "golangci-lint-ls",
})

-- vim.diagnostic.config({ signs = true })

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.config('golangci_lint_ls', {
	cmd = {'golangci-lint-langserver'},
	root_markers = { '.git', 'go.mod' },
	init_options = {
		command = {
			'golangci-lint', 'run', '--output.json.path', 'stdout', '--show-stats=false', '--issues-exit-code=1'
		},
	},
})

vim.keymap.set("n", "<leader>uh", function()
  local ft = vim.bo.filetype
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
   if ft == 'go' then
      require('goplements').toggle()
   end
end, { desc = "Toggle inlay hints" })

