-- Plugins are local git repos under <config>/plugins/. Resolve their absolute
-- path at runtime (relative to stdpath('config')) so this file is portable across
-- machines. It was previously hardcoded to /home/gorgek/.config/nvim/plugins/...,
-- which broke on other hosts (macOS) and made vim.pack.add try to `git clone` from
-- non-existent paths on startup.
local function plug(name)
	return vim.fs.joinpath(vim.fn.stdpath("config"), "plugins", name)
end

vim.pack.add({

	-- Theme
	{
		src = plug("vscode.nvim"),
		name = "vscode",
	},

	-- Core utilities
	{
		src = plug("plenary.nvim"),
	},
	{
		src = plug("nvim-web-devicons"),
	},
	{
		src = plug("nui.nvim"),
	},
	{
		src = plug("nvim-navic"),
	},
	{
		src = plug("nvim-nio"),
	},

	-- Notifications
	{
		src = plug("nvim-notify"),
	},
	{
		src = plug("error-lens.nvim"),
	},

	-- Editor helpers
	{
		src = plug("which-key.nvim"),
	},
	{
		src = plug("guess-indent.nvim"),
	},
	{
	src = plug("tiny-inline-diagnostic.nvim"),
	},

	-- Completion
	{
		src = plug("blink.lib"),
	},
	{
		src = plug("blink.pairs"),
	},
	{
		src = plug("blink.cmp"),
	},

	-- Snippets
	{
		src = plug("LuaSnip"),
	},
	{
		src = plug("friendly-snippets"),
	},

	-- Formatting
	{
		src = plug("conform.nvim"),
	},

	-- Treesitter
	{
		src = plug("nvim-treesitter"),
	},
	{
		src = plug("nvim-treesitter-context"),
	},

	-- Git
	{
		src = plug("git-blame.nvim"),
	},
	{
		src = plug("gitsigns.nvim"),
	},
	{
		src = plug("diffview.nvim"),
	},
	{
		src = plug("neogit"),
	},

	-- Utilities
	{
		src = plug("snacks.nvim"),
	},
	{
		src = plug("blink.indent"),
	},

	-- Navigation
	{
		src = plug("neo-tree.nvim"),
	},
	{
		src = plug("grug-far.nvim"),
	},

	-- Productivity
	{
		src = plug("time-machine.nvim"),
	},

	-- Database
	{
		src = plug("vim-dadbod"),
	},
	{
		src = plug("vim-dadbod-completion"),
	},
	{
		src = plug("dbui.nvim"),
	},

	-- gRPC
	{
		src = plug("grpc-ui.nvim"),
	},

	-- LSP
	{
		src = plug("goplements.nvim"),
	},

	-- Preview
	{
		src = plug("render-markdown.nvim"),
	},
	{
		src = plug("jqscratch.nvim"),
	},
	{
		src = plug("csvview.nvim"),
	},

	-- Statusbar
	{
		src = plug("heirline.nvim"),
	},

	-- AI
	{
		src = plug("codecompanion.nvim"),
	},
	{
		src = plug("minuet-ai.nvim"),
	},

	-- Testing
	{
		src = plug("neotest"),
	},
	{
		src = plug("neotest-golang"),
	},
	{
		src = plug("neotest-python"),
	},

	-- Leetcode
	{
		src = plug("leetcode.nvim"),
	},
}, { confirm = false, load = function() end })

-- =============================================================================
-- Declarative loading registry
-- Each entry describes when and how to load a plugin module.
-- Fields:
--   mod     — module name under plugins/ (e.g. 'catppuccin' → plugins/catppuccin.lua)
--   event   — autocmd event (string or array) to trigger loading (once=true by default)
--   keys    — keymaps that trigger loading on first press; engine replays the key after
--   defer   — milliseconds to delay via vim.defer_fn
--   packadd — plugin directory names to :packadd before requiring the module
-- =============================================================================

local pack = require("core.pack")

pack.setup({

	-- -------------------------------------------------------------------------
	-- Immediate (first frame — theme + treesitter so the first buffer is
	-- highlighted instantly instead of flashing gray while the async parse runs)
	-- -------------------------------------------------------------------------
	{ mod = "vscode", packadd = { "vscode" } },
	{ mod = "treesitter", fn = "base", packadd = { "nvim-treesitter" } },

	-- -------------------------------------------------------------------------
	-- VimEnter (non-blocking — loads after init but before UI renders)
	-- Native snacks replacements: bigfile guard + gitbrowse/lazygit/terminal keymaps
	-- -------------------------------------------------------------------------
	{ mod = "ui", fn = "native", event = "VimEnter" },
	{ mod = "ui", fn = "bigfile", event = "VimEnter" },
	{ mod = "ui", fn = "quickfile", event = "VimEnter" },

	-- -------------------------------------------------------------------------
	-- UIEnter (non-blocking — loads after first frame renders)
	-- -------------------------------------------------------------------------
	{ mod = "ui", fn = "tiny_inline_diag", event = "UIEnter", packadd = { "tiny-inline-diagnostic.nvim" } },
	{ mod = "heirline", event = "UIEnter", packadd = { "heirline.nvim", "nvim-web-devicons" } },
	{
		mod = "ui",
		fn = "which_key",
		event = "UIEnter",
		packadd = { "which-key.nvim" },
	},
	-- {
	-- 	mod = "ui",
	-- 	fn = "error_lens",
	-- 	event = "UIEnter",
	-- 	packadd = { "error-lens.nvim" },
	-- },
	{
		mod = "editing",
		fn = "base_ui",
		event = "UIEnter",
		packadd = { "blink.lib", "blink.indent", "blink.pairs", "LuaSnip", "friendly-snippets" },
	},
	-- { mod = 'topbar',     fn = 'barbecue',   event = 'UIEnter',                         packadd = { 'nvim-navic', 'barbecue.nvim' } },
	-- -------------------------------------------------------------------------
	-- BufReadPre / BufNewFile (core file-level features)
	-- Order matters: lightweight frames first so context renders before
	-- gitsigns/LSP (which can block the autocmd queue for several ms).
	-- -------------------------------------------------------------------------
	{
		mod = "treesitter",
		fn = "context",
		event = { "BufReadPre", "BufNewFile" },
		packadd = { "nvim-treesitter-context" },
	},
	{
		mod = "git",
		fn = "signs",
		event = { "BufReadPre", "BufNewFile" },
		packadd = { "gitsigns.nvim", "plenary.nvim" },
	},
	{ mod = "lsp", event = { "BufReadPre", "BufNewFile" }, packadd = { "goplements.nvim" } },

	-- -------------------------------------------------------------------------
	-- InsertEnter / CmdlineEnter (completion)
	-- -------------------------------------------------------------------------
	{ mod = "completion", event = { "InsertEnter", "CmdlineEnter" }, packadd = { "blink.cmp" } },
	{ mod = "minuet", event = { "InsertEnter", "CmdlineEnter" }, packadd = { "minuet-ai.nvim" } },

	-- -------------------------------------------------------------------------
	-- BufReadPre/BufNewFile (formatting on save — conform has its own internal
	-- guard). Loaded on first file open (not BufWritePre) so conform's
	-- format_on_save autocmd is registered before the first `:w`; loading on
	-- BufWritePre made the first save a no-op.
	-- -------------------------------------------------------------------------
	{ mod = "editing", fn = "format", event = { "BufReadPre", "BufNewFile" }, packadd = { "conform.nvim" } },

	-- -------------------------------------------------------------------------
	-- Keymap-triggered (first keypress loads the module, then replays the key)
	-- -------------------------------------------------------------------------

	-- Picker
	{
		mod = "editing",
		fn = "picker",
		keys = {
			{ "<leader>ff", desc = "[F]iles" },
			{ "<leader>ol", desc = "[L]eetcode" },
			{ "<leader>fs", desc = "[s]ymbols (buffer)" },
			{ "<leader>fS", desc = "[S]ymbols (all)" },
			{ "<leader>fr", desc = "[R]eferences" },
			{ "<leader>fi", desc = "[I]mplenentations" },
			{ "<leader>fd", desc = "[d]iagnostics buffer" },
			{ "<leader>fD", desc = "[D]iagnostics (all)" },
			{ "<leader>fg", desc = "[g]rep" },
			{ "gd", desc = "[G]oto [D]efinition" },
			{ "<leader>tl", desc = "[L]ist" },
			{ "<leader>tt", desc = "[T]erminal" },
		},
		packadd = { "snacks.nvim" },
	},
	-- Testing
	{
		mod = "testing",
		keys = {
			{ "<leader>ctn", desc = "[N]earest" },
			{ "<leader>ctf", desc = "[F]ile" },
			{ "<leader>cts", desc = "[S]ummary" },
			{ "<leader>ctl", desc = "[L]ast" },
			{ "<leader>cte", desc = "File with [E]nv" },
		},
		packadd = { "nvim-nio", "plenary.nvim", "neotest", "neotest-golang", "neotest-python" },
	},
	-- Leetcode
	{
		mod = "leetcode",
		keys = {
			{ "<leader>ol", desc = "[L]eetcode" },
		},
		packadd = { "plenary.nvim", "nui.nvim", "snacks.nvim", "leetcode.nvim" },
	},
	-- Sidebar
	{
		mod = "sidebar",
		keys = {
			{ "<leader>ef", desc = "[F]iles" },
			{ "<leader>ed", desc = "[D]atabase" },
			{ "<leader>eg", desc = "[G]RPC" },
			{ "<leader>eu", desc = "[U]ndo" },
			{ "<leader>et", desc = "[T]oggle" },
			{ "<leader>er", desc = "[R]eplace" },
		},
		packadd = {
			"nui.nvim",
			"plenary.nvim",
			"blink.lib",
			"blink.cmp",
			"neo-tree.nvim",
			"vim-dadbod",
			"dbui.nvim",
			"vim-dadbod-completion",
			"time-machine.nvim",
			"grpc-ui.nvim",
			"grug-far.nvim",
		},
	},
	-- Git Blame
	{
		mod = "git",
		fn = "blame",
		keys = {
			{ "<leader>ga", desc = "Blame [a]nnotations" },
		},
		packadd = { "git-blame.nvim" },
	},
	-- Git Diff
	{
		mod = "git",
		fn = "diff",
		keys = {
			{ "<leader>gd", desc = "[Diff] against index" },
			{ "<leader>gD", desc = "[D]iff Last Commit" },
			{ "<leader>gm", desc = "[M]erge Conflict" },
		},
		packadd = { "diffview.nvim", "plenary.nvim" },
	},
	-- Tools
	{
		mod = "tools",
		fn = "productivity",
		keys = {
			{ "<leader>ss", desc = "Session Save" },
			{ "<leader>sr", desc = "Session Restore" },
			{ "<leader>Fr", desc = "File Rename" },
			{ "<leader>Fd", desc = "File Duplicate" },
			{ "<leader>Fn", desc = "File New" },
			{ "<leader>Fm", desc = "File Move" },
			{ "<leader>Fc", desc = "File Copy Path" },
			{ "<leader>Fc", desc = "File Copy Path" },
		},
	},
	-- AI
	{
		mod = "ai",
		keys = {
			{ "<leader>ac", desc = "[C]ode Companion Toggle" },
			{ "<leader>as", desc = "[S]uggestions Toggle", mode = "n" },
			{ "<leader>as", desc = "[S]end to companion", mode = "v" },
			{ "<leader>al", desc = "[L]ist companions" },
		},
		packadd = { "codecompanion.nvim", "blink.cmp", "blink.lib" },
	},
	-- Preview
	{
		mod = "preview",
		fn = "json",
		keys = {
			{ "<leader>pj", desc = "[J]son" },
		},
		packadd = { "jqscratch.nvim" },
	},
	{
		mod = "preview",
		fn = "csv",
		keys = {
			{ "<leader>pc", desc = "[C]sv" },
		},
		packadd = { "csvview.nvim" },
	},

	-- -------------------------------------------------------------------------
	-- Deferred (idle — load after defer ms)
	-- -------------------------------------------------------------------------
	{ mod = "statusline", fn = "version", defer = 1 },
	{ mod = "editing", fn = "guess_indent", defer = 1, packadd = { "guess-indent.nvim" } },
	{ mod = "preview", fn = "md", defer = 50, packadd = { "render-markdown.nvim" } },
	{ mod = "notification", defer = 1, packadd = { "nvim-notify" } },
})

-- =============================================================================
-- Directory-argument hijack
-- netrw is disabled globally (loaded_netrw = 1 in init.lua), and neo-tree is
-- otherwise lazy-loaded only via <leader>ef. When nvim is launched with a
-- directory argument, no BufRead/BufNewFile fires for it, so nothing would load
-- neo-tree and the directory would open as a plain (empty) buffer or hang.
-- Load the sidebar eagerly here so neo-tree's BufEnter hijack
-- (hijack_netrw_behavior = "open_default") replaces the directory buffer in
-- place. Must happen during init.lua — before the directory's BufEnter — not on
-- VimEnter, or the hijack arrives too late.
-- =============================================================================
local launch_has_dir = false
for i = 0, vim.fn.argc() - 1 do
	if vim.fn.isdirectory(vim.fn.argv(i)) == 1 then
		launch_has_dir = true
		break
	end
end
if launch_has_dir then
	pack.load("sidebar")
end
