local M = {}

function M.base_ui()
	require("blink.indent").setup({
		blocked = {
			buftypes = { include_defaults = true },
			filetypes = { include_defaults = true, "dbout" },
		},
		static = {
			enabled = true,
			char = "│",
		},
		scope = {
			enabled = true,
			char = "│",
			highlights = { "BlinkIndentScope" },
			underline = {
				enabled = false,
			},
		},
	})

	-- require('blink.pairs').build({ force = true }):pwait()
	require("blink.pairs").setup({
		highlights = {
			matchparen = { enabled = true },
			groups = { "BlinkPairsWhite", "BlinkPairsPurple", "BlinkPairsBlue" },
		},
	})
end

function M.picker()
	require("snacks").setup({
		picker = {
			layout = {
				preset = "vscode",
				preview = "main",
				layout = {
					border = "rounded",
				},
			},
		},
	})

	-- Keybinds
	local picker = require("snacks.picker")
	vim.keymap.set("n", "<leader>fi", function()
		picker.lsp_implementations()
	end, {
		desc = "[I]mplementations",
	})

	vim.keymap.set("n", "<leader>fr", function()
		picker.lsp_references()
	end, {
		desc = "[R]eferences",
	})

	vim.keymap.set("n", "<leader>fd", function()
		picker.diagnostics_buffer()
	end, {
		desc = "[D]iagnostics (buffer)",
	})

	vim.keymap.set("n", "<leader>fD", function()
		picker.diagnostics()
	end, {
		desc = "[D]iagnostics (all)",
	})

	vim.keymap.set("n", "<leader>ff", function()
		picker.files()
	end, {
		desc = "[F]iles",
	})

	vim.keymap.set("n", "<leader>fg", function()
		picker.grep()
	end, {
		desc = "[G]rep",
	})

	vim.keymap.set("n", "<leader>fb", function()
		picker.buffers()
	end, {
		desc = "[B]uffers",
	})

	vim.keymap.set("n", "<leader>fs", function()
		picker.lsp_symbols()
	end, {
		desc = "[S]ymbols (buffer)",
	})

	vim.keymap.set("n", "<leader>fS", function()
		picker.lsp_workspace_symbols()
	end, {
		desc = "[S]ymbols (all)",
	})

	vim.keymap.set("n", "gd", function()
		picker.lsp_definitions()
	end, {
		desc = "[G]oto [D]efinition",
	})

	vim.keymap.set("n", "<leader>tt", function()
		require("snacks").terminal.focus(nil, {
			win = {
				position = "right",
				wo = { winbar = "" },
				on_win = function(self)
					-- Force dark background immediately (SidebarNormal is `#181818`)
					vim.wo[self.win].winhighlight = "Normal:SidebarNormal,NormalNC:SidebarNormal"
				end,
			},
			env = vim.v.count1 > 1 and { SNACKS_TERM = tostring(vim.v.count1) } or nil,
			count = vim.v.count1 > 1 and vim.v.count1 or nil,
			keys = {
				q = "hide",
				term_normal = {
					"<esc>",
					function(self)
						self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
						if self.esc_timer:is_active() then
							self.esc_timer:stop()
							vim.cmd("stopinsert")
						else
							self.esc_timer:start(200, 0, function() end)
							return "<esc>"
						end
					end,
					mode = "t",
					expr = true,
					desc = "Double escape to normal mode",
				},
			},
		})
	end, { desc = "[T]erminal" })

	vim.keymap.set({ "n", "t" }, "<C-q>", function()
		local cur_buf = vim.api.nvim_get_current_buf()
		for _, term in ipairs(require("snacks").terminal.list()) do
			if term.buf == cur_buf then
				-- Exit terminal mode first if in terminal mode
				if vim.api.nvim_get_mode().mode:match("^t") then
					vim.cmd("stopinsert")
				end
				term:hide()
				return
			end
		end
	end, { desc = "Close Snacks Terminal" })

	-- List and switch between all running terminals
	vim.keymap.set("n", "<leader>tl", function()
		local term_m = require("snacks").terminal
		local terms = term_m.list()
		if #terms == 0 then
			vim.notify("No terminals running", vim.log.levels.INFO)
			return
		end
		local items = {}
		for _, term in ipairs(terms) do
			local title = vim.b[term.buf].term_title or "terminal"
			table.insert(items, { term = term, label = title .. " [" .. term.buf .. "]" })
		end
		vim.ui.select(items, {
			prompt = "Terminals:",
			format_item = function(item)
				return item.label
			end,
		}, function(choice)
			if choice then
				choice.term:show():focus()
			end
		end)
	end, { desc = "[L]ist terminals" })
end

function M.format()
	require("conform").setup({
		notify_on_error = true,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			go = { "gofmt", "goimports" },
			["*"] = { "codespell" },
			["_"] = { "trim_whitespace" },
		},

		formatters = {
			ruff_format = {
				command = "ruff",
				args = { "format", "-" },
			},
			gofmt = {
				command = "gofmt",
				args = { "-r", "interface{} -> any" },
			},
			goimports = {
				command = "goimports",
				args = {
					"-local",
					"api.sc-ci.sber.ru,stash.sigma.sbrf.ru,stash.delta.sbrf.ru",
				},
			},
		},

		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	})

	-- Keymaps
	vim.keymap.set("", "<leader>bf", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, { desc = "[F]ormat buffer" })
end

function M.guess_indent()
	-- guess-indent
	require("guess-indent").setup({
		auto_cmd = true,
		override_editorconfig = false,
		filetype_exclude = {
			"netrw",
			"tutor",
			"help",
			"qf",
			"diff",
			"fzf",
		},
		buftype_exclude = {
			"help",
			"nofile",
			"terminal",
			"prompt",
		},
		on_tab_options = {
			["expandtab"] = false,
		},
		on_space_options = {
			["expandtab"] = true,
			["tabstop"] = "detected",
			["softtabstop"] = "detected",
			["shiftwidth"] = "detected",
		},
	})
end

return M
