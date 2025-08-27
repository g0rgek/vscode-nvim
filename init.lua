-- Set <,> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Set height of command line under status line
vim.o.cmdheight = 0

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
-- vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Install and configure plugins ]]
require("lazy").setup({
	-- Show keybinds
	{
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			preset = "helix",
			delay = 0,
			win = {
				height = {
					max = math.huge,
				},
			},
			icons = {
				rules = false,
				breadcrumb = " ", -- symbol used in the command line area that shows your active key combo
				separator = "󱦰  ", -- symbol used between a key and it's label
				group = "󰹍 ", -- symbol prepended to a group
			},
			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>f", group = "[F]ind" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>u", group = "[U]i" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},
	-- VSCode theme plugin
	{
		"Mofiqul/vscode.nvim",
		priority = 1000,
		config = function()
			require("vscode").setup({
				transparent = true, -- set to true if you want transparent background
				italic_comments = false, -- make comments italic
				disable_nvimtree_bg = true, -- use same bg for nvim-tree
			})
			require("vscode").load("dark") -- load 'dark' variant for VSCode Dark Modern
		end,
	},
	-- Adds git related signs to the gutter
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	-- Indent line for code blocks
	{
		"folke/snacks.nvim",
		opts = {
			toggle = {
				which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
			},
			lazygit = {},
			picker = {
				layout = {
					preset = "vscode",
				},
			},
			indent = {
				enabled = true,
				animate = { enabled = false },
				indent = {
					enabled = true,
					only_current = false,
					only_scope = false,
				},
				scope = {
					enabled = true,
					only_current = true,
				},
				chunk = { enabled = false },
				filter = function(buf)
					return vim.g.snacks_indent ~= false
						and vim.b[buf].snacks_indent ~= false
						and vim.bo[buf].buftype == ""
						and vim.bo[buf].filetype ~= "markdown"
				end,
			},
		},
		keys = {
			-- Find files (like Ctrl+P in VSCode)
			{
				mode = "n",
				"<leader>ff",
				function()
					require("snacks.picker").files()
				end,
				desc = "Find Files",
			},
			-- Search text in project (like Ctrl+Shift+F)
			{
				mode = "n",
				"<leader>fg",
				function()
					require("snacks.picker").grep()
				end,
				desc = "Live Grep",
			},
			-- Search buffers (like VSCode "Open Editors")
			{
				mode = "n",
				"<leader>fb",
				function()
					require("snacks.picker").buffers()
				end,
				desc = "Find Buffers",
			},
			-- Search document symbols (like Ctrl+Shift+O)
			{
				mode = "n",
				"<leader>fs",
				function()
					require("snacks.picker").lsp_document_symbols()
				end,
				desc = "Document Symbols",
			},
			-- Search workspace symbols (like VSCode Cmd+T)
			{
				mode = "n",
				"<leader>fw",
				function()
					require("snacks.picker").lsp_workspace_symbols()
				end,
				desc = "Workspace Symbols",
			},
			{
				mode = "n",
				"<leader>gg",
				function()
					require("snacks.lazygit").open()
				end,
				desc = "[G]it Lazy[G]it",
			},
		},
	},
	-- Colored icons
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				color_icons = true,
				default = true,
				override = {
					go = {
						icon = "󰟓",
						color = "#519ABA",
						name = "Go",
					},
					md = {
						icon = "", -- Nerd Font glyph U+E609
						color = "#519ABA", -- pick your preferred color
						name = "Md",
					},
					py = {
						icon = "",
						color = "#519ABA",
						name = "Py",
					},
					-- rs = {
					--   icon = '',
					--   color = '#6D8086',
					--   name = 'Rs',
					-- },
				},
			})
		end,
	},
	-- Tree-sitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"go",
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},
	-- Buffer line with colored icons
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- Set the filetypes which barbar will offset itself for
			sidebar_filetypes = {
				["neo-tree"] = { event = "BufWipeout" },
			},
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- highlight_visible = true,
			-- insert_at_start = true,
			-- …etc.
		},
		version = "^1.9.1", -- optional: only update when a new 1.x version is released
	},
	-- Vscode beadcrumb
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = function()
			require("barbecue").setup({
				create_autocmd = false, -- prevent barbecue from updating itself automatically
				exclude_filetypes = { -- don't process these
					statusline = { "NvimTree", "toggleterm", "terminal" }, -- disable for statusline
					winbar = { "toggleterm", "terminal" }, -- disable for winbar (if you use it)
				},
			})

			vim.api.nvim_create_autocmd({
				"WinScrolled", -- or WinResized on NVIM-v0.9 and higher
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",

				-- include this if you have set `show_modified` to `true`
				"BufModifiedSet",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
		opts = {
			-- configurations go here
		},
	},
	-- Git-blame plugin
	{
		"f-person/git-blame.nvim",
		-- load the plugin at startup
		event = "VeryLazy",
		-- Because of the keys part, you will be lazy loading this plugin.
		-- The plugin will only load once one of the keys is used.
		-- If you want to load the plugin at startup, add something like event = "VeryLazy",
		-- or lazy = false. One of both options will work.
		opts = {
			-- your configuration comes here
			-- for example
			enabled = true, -- if you want to enable the plugin
			message_template = "<author> (<date>)", -- template for the blame message, check the Message template section for more options
			date_format = "%r", -- template for the date, check Date format section for more options
			virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
		},
	},
	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "echasnovski/mini.icons" }, -- mini.icons provides icons
		config = function()
			vim.g.gitblame_display_virtual_text = 0
			local lualine = require("lualine")
			local git_blame = require("gitblame")

			-- Helper to get LSP clients
			local function lsp_clients()
				local clients = vim.lsp.get_active_clients({ bufnr = 0 })
				if #clients == 0 then
					return ""
				end
				local names = {}
				for _, c in ipairs(clients) do
					table.insert(names, c.name)
				end
				return " " .. table.concat(names, ",")
			end

			-- Diagnostics component with VSCode-like icons
			local diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn", "info", "hint" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
				colored = true,
				update_in_insert = false,
			}

			lualine.setup({
				options = {
					theme = "auto", -- picks colors from current colorscheme (VSCode.nvim)
					section_separators = "",
					component_separators = "",
					icons_enabled = true,
					globalstatus = true, -- VSCode-like single statusline
					disabled_filetypes = { -- don't process these
						statusline = { "NvimTree", "toggleterm", "terminal" }, -- disable for statusline
						winbar = { "toggleterm", "terminal" }, -- disable for winbar (if you use it)
					},
				},
				sections = {
					lualine_a = { { "mode" } },
					lualine_b = {
						{
							color = { fg = "#CCC" }, -- white
							"branch",
							icon = "",
						},
						{ "diff" },
						diagnostics,
					},
					lualine_c = {},
					lualine_x = {
						{
							git_blame.get_current_blame_text,
							cond = git_blame.is_blame_text_available,
							color = { fg = "#CCC" }, -- white
						},
					},
					lualine_y = {
						{
							function()
								local line = vim.fn.line(".")
								local col = vim.fn.col(".")
								return string.format("Ln %d, Col %d", line, col)
							end,
							color = { fg = "#CCC" }, -- white
						},
						{ lsp_clients },
						{
							"encoding",
							color = { fg = "#CCC" }, -- white
						},
						{
							"filetype",
							color = { fg = "#CCC" }, -- white
						},
					},
					lualine_z = {},
				},
				-- inactive_sections = {
				--   lualine_a = {},
				--   lualine_b = {},
				--   lualine_c = {},
				--   lualine_x = {},
				--   lualine_y = {},
				--   lualine_z = {},
				-- },
			})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		keys = {
			{ "<leader>tt", "<cmd>ToggleTerm dir=git_dir<CR>", desc = "Toggle terminal", mode = "n" },
			{ "<leader>tt", [[<C-\><C-n><cmd>ToggleTerm<CR>]], desc = "ReToggle terminal", mode = "t" },
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = true, -- neo-tree will lazily load itself
		keys = {
			-- open term
			{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
			-- change focus to term
			{
				"<leader>o",
				function()
					if vim.bo.filetype == "neo-tree" then
						vim.cmd.wincmd("p")
					else
						vim.cmd.Neotree("focus")
					end
				end,
				desc = "Toggle Explorer Focus",
			},
		},
	},
})

-- Basic Neovim UI settings
vim.opt.termguicolors = true -- enable true colors
vim.opt.background = "dark" -- ensure dark mode background
-- Make float window transparent too
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
