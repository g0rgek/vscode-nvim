-- Minimal eager load: only the colorscheme itself.
-- All highlight overrides and sidebar autocmds are deferred to UIEnter to
-- shave ~3ms off startup time.
require("vscode").setup({
	transparent = true,
	italic_comments = false,
	disable_nvimtree_bg = false,

	color_overrides = {
		vscTabCurrent = "#2D2D2D",
		vscTabOther = "#202020",
	},
})

vim.cmd.colorscheme("vscode")
vim.opt.background = "dark"

-- Set blink.cmp highlights immediately (not deferred) so they're ready
-- before UIEnter — blink loads on InsertEnter which can fire early.
vim.api.nvim_set_hl(0, "CmpMenu", { bg = "#252526", fg = "#7c7c7d" })
vim.api.nvim_set_hl(0, "CmpDocumentation", { bg = "#252526", fg = "#dbdbdb" })
vim.api.nvim_set_hl(0, "CmpDocumentationBorder", { bg = "#252526", fg = "#dbdbdb" })

-- Defer everything else to UIEnter — highlights don't affect first-paint correctness.
vim.api.nvim_create_autocmd("UIEnter", {
	group = vim.api.nvim_create_augroup("vscode-deferred", { clear = true }),
	once = true,
	callback = function()
		local hl = vim.api.nvim_set_hl
		local c = require("vscode.colors").get_colors()

		-- Vscode builtin and custom types have the same color
		hl(0, "@type.builtin", { fg = c.vscBlueGreen, bg = "NONE" })

		-- Whitespace color
		hl(0, "Whitespace", { fg = "#2D2D2D", bg = "NONE", nocombine = true })

		-- Tab color
		hl(0, "IblIndent", { fg = "#3E3E3E", bg = "NONE", nocombine = true })

		-- Make float windows transparent (which-key)
		hl(0, "NormalFloat", { bg = "NONE" })
		hl(0, "FloatBorder", { bg = "NONE" })

		-- Figdet.nvim colors
		hl(0, "FidgetLSPName", { fg = "#9CDCFE", bg = "NONE" })
		hl(0, "FidgetText", { fg = "#D4D4D4", bg = "NONE" })

		-- Goplements inlay hint color
		hl(0, "Goplements", { fg = c.vscSuggestion, bg = "NONE" })

		-- BlinkPairs rainbow parentheses colors.
		-- Work around a blink.pairs namespace bug: the plugin defines these in the
		-- blink_pairs (underscore) namespace, but applies extmarks in blink.pairs
		-- (dot). Defining them globally (ns=0) makes them visible to the extmarks.
		-- The ColorScheme autocmd re-applies them after any colorscheme change,
		-- which is necessary because themes like vscode.nvim call `hi clear` on load.
		local function set_blink_pairs_hl()
			hl(0, "BlinkPairsWhite", { fg = "#FFD700", default = true })
			hl(0, "BlinkPairsPurple", { fg = c.vscPink, default = true })
			hl(0, "BlinkPairsOrange", { fg = "#d65d0e", default = true })
			hl(0, "BlinkPairsBlue", { fg = "#569CD6", default = true })
			hl(0, "BlinkPairsUnmatched", { fg = "#ff007c", default = true })
			hl(0, "BlinkPairsMatchParen", { link = "MatchParen", default = true })
			hl(0, "BlinkIndentScope", { fg = "#707070", default = true })
		end

		set_blink_pairs_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("user_blink_pairs_hl", {}),
			callback = set_blink_pairs_hl,
		})

		local sidebar_bg = "#181818"

		local sidebar_fts = {
			"neo-tree",
			"dbui",
			"time-machine-list",
			"grpcui",
			"grug-far",
			"codecompanion",
			"dbout",
			"snacks_terminal",
		}

		local function set_sidebar_hl()
			hl(0, "SidebarNormal", { bg = sidebar_bg, default = true })
			hl(0, "NeoTreeNormal", { bg = sidebar_bg, default = true })
			hl(0, "NeoTreeNormalNC", { bg = sidebar_bg, default = true })
			hl(0, "NeoTreeIndentMarker", { fg = "#2D2D2D", bg = sidebar_bg, default = true })
			hl(0, "NeoTreeExpander", { bg = "NONE", default = true })
			hl(0, "TimeMachineNormal", { bg = sidebar_bg, default = true })
			hl(0, "CodeCompanionNormal", { bg = sidebar_bg, default = true })
			hl(0, "SnacksTermNormal", { bg = sidebar_bg, default = true })
		end

		set_sidebar_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("user_sidebar_hl", {}),
			callback = set_sidebar_hl,
		})

		vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "FileType" }, {
			pattern = "*",
			callback = function()
				if vim.tbl_contains(sidebar_fts, vim.bo.filetype) then
					vim.wo.winhighlight = "Normal:SidebarNormal,NormalNC:SidebarNormal"
				end
				if vim.bo.filetype == "codecompanion" then
					vim.wo.number = false
					vim.wo.relativenumber = false
				end
			end,
		})
		-- golang
		hl(0, "@keyword.range.go", { fg = c.vscPink })
		hl(0, "@keyword.package.go", { fg = c.vscBlue })
		hl(0, "@keyword.coroutine.go", { fg = c.vscPink })
		-- docker
		hl(0, "dockerfileKeyword", { fg = c.vscBlue })
		-- tengo
		hl(0, "@property.tengo", { link = "@function.method.tengo" })
	end,
})
