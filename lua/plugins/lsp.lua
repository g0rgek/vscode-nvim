vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Disable semantic tokens — they fight with treesitter highlighting,
    -- causing a visible flash/delay when opening buffers
    if client then
      client.server_capabilities.semanticTokensProvider = nil
      client.server_capabilities.documentHighlightProvider = nil
    end
  end,
})

map("n", "<leader>ca", vim.lsp.buf.code_action, {
  desc = "[A]ction",
})

vim.lsp.enable({
  "gopls",
  -- "golangci-lint-ls",
  "json-language-server",
  "yaml-language-server",
  "buf_ls"
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        modernize = true,
      },
      hints = {
        assignVariableTypes = true,
        -- compositeLiteralFields = true,
        -- compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        -- rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.config('golangci-lint-ls', {
	cmd = { 'golangci-lint-langserver' },
	filetypes = { 'go', 'gomod' },
	root_markers = { '.git', 'go.mod' },
	init_options = {
		command = {
			'golangci-lint', 'run',
			'--output.json.path', 'stdout',
			'--output.text.path', '/dev/null',
			'--show-stats=false',
			'--issues-exit-code=1',
		},
	},
})


require("goplements").setup({})
require('goplements').toggle()

--- Toggle golangci-lint-ls diagnostics on/off, keeping gopls compiler diagnostics
---@param show_notify boolean|nil
local function toggle_lint_diagnostics(show_notify)
	local name = 'golangci-lint-ls'
	local clients = vim.lsp.get_clients({ name = name })
	if #clients > 0 then
		-- suppress "LSP log: ..." message on client stop
		pcall(vim.lsp.log.clear)
		for _, c in ipairs(clients) do
			c:stop()
		end
	else
		vim.lsp.enable(name)
	end
end

map("n", "<leader>ul", toggle_lint_diagnostics, { desc = "[L]int diagnostics" })

map("n", "<leader>uh", function()
  local ft = vim.bo.filetype
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
   if ft == 'go' then
      require('goplements').toggle()
   end
end, { desc = "Inlay [H]ints" })

