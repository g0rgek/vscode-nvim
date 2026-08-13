local M = {}

function M.base()
	require("nvim-treesitter").setup({
		indent = {
			enable = false,
		},
		incremental_selection = {
			enable = false,
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	})

	-- Register htmlangular filetype → angular parser
	vim.treesitter.language.register("angular", "htmlangular")
	vim.treesitter.language.register("tengo", "tengo")
	vim.filetype.add({ extension = { tengo = "tengo", mshk = "tengo" } })

	-- Highlight every filetype with an installed parser
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("nvimpack-treesitter", { clear = true }),
		callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	})

	-- Catch up: initial buffer's FileType fires before UIEnter
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
			pcall(vim.treesitter.start, buf)
		end
	end

	-- Auto-install missing parsers (deferred 500ms to not block startup)
	vim.defer_fn(function()
		local ensure_installed = {
			"regex",
			"go",
			"gomod",
			"gosum",
			"gotmpl",
			"templ",
			"diff",
			"html",
			"markdown",
			"markdown_inline",
			"query",
			"python",
			"sql",
			"yaml",
			"json",
			"lua",
			"comment",
		}

		-- local installed = require('nvim-treesitter.config').get_installed()
		-- local missing = {}
		--
		-- for _, lang in ipairs(ensure_installed) do
		--   if not vim.list_contains(installed, lang) then
		--     table.insert(missing, lang)
		--   end
		-- end
		--
		-- if #missing > 0 then
		--   require('nvim-treesitter.install').install(missing, { summary = true })
		-- end
	end, 500)
end

function M.context()
	require("treesitter-context").setup({
		enable = true,
		multiwindow = false,
		max_lines = 2,
		min_window_height = 25,
		line_numbers = false,
		multiline_threshold = 15,
		trim_scope = "outer",
		mode = "topline",
		throttle = true,
		separator = nil,
		zindex = 20,
		on_attach = function(buf)
			local filetype = vim.bo[buf].filetype
			local disabled_filetypes = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			}
			return not vim.tbl_contains(disabled_filetypes, filetype)
		end,
	})

	-- Treesitter context highlight overrides (dynamic Catppuccin colors)
	local function set_treesitter_context_colors()
		vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#2D2D2D" })
		vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#5A5A5A", bg = "#2D2D2D" })
		-- vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { fg = palette.lavender, bg = palette.surface0 })
		-- vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { bg = palette.surface0, sp = palette.blue, underline = true })
		-- vim.api.nvim_set_hl(0, 'TreesitterContextLineNumberBottom', {
		--   bg = palette.surface0, fg = palette.overlay1, sp = palette.blue, underline = true, italic = true,
		-- })
	end

	set_treesitter_context_colors()

	-- Re-apply colors when theme changes
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = set_treesitter_context_colors,
	})

	vim.keymap.set("n", "[C", function()
		require("treesitter-context").go_to_context(vim.v.count1)
	end, { desc = "Jump to context (upwards)" })
end

return M
