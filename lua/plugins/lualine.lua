-- ======================
-- language version helper
-- ======================
local function lang_version()
	if vim.b.lang_version_cache ~= nil then
		return vim.b.lang_version_cache
	end

	local ft = vim.bo.filetype
	local ver = ""

	if ft == "go" then
		local out = vim.fn.system("go version"):gsub("\n", "")
		ver = out:match("go version%s+go([%d%.]+)") or ""
	elseif ft == "rust" then
		local out = vim.fn.system("rustc --version"):gsub("\n", "")
		ver = out:match("rustc%s+([%w%.%-]+)") or ""
	elseif ft == "c" or ft == "cpp" then
		local out = vim.fn.system("gcc --version | head -n1"):gsub("\n", "")
		ver = out:match("gcc[^%d]*([%d%.]+)") or ""
	elseif ft == "python" then
		local out = vim.fn.system("python --version 2>&1"):gsub("\n", "")
		ver = out:match("Python%s+([%d%.]+)") or ""

		local venv = os.getenv("VIRTUAL_ENV")
		if venv then
			local venv_name = vim.fn.fnamemodify(venv, ":t")
			ver = ver .. " (" .. venv_name .. ")"
		end
	elseif ft == "typst" then
		local out = vim.fn.system("typst -V"):gsub("\n", "")
		ver = out:match("(%d+%.%d+%.%d+)") or ""
	end

	vim.b.lang_version_cache = ver
	return ver
end

-- ======================
-- LSP clients
-- ======================
local function lsp_clients()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return ""
	end

	local names = {}
	for _, c in ipairs(clients) do
		table.insert(names, c.name)
	end

	return table.concat(names, ",")
end

-- ======================
-- diagnostics
-- ======================
local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "info", "hint" },
	symbols = {
		error = " ",
		warn = " ",
		info = " ",
		hint = "󰌶 ",
	},
	colored = false,
	update_in_insert = false,
	color = { fg = "#cccccc" },
}

local git_blame = require("gitblame")
local lualine = require("lualine")

lualine.setup({
	options = {
		section_separators = "",
		component_separators = "",
		icons_enabled = true,
		globalstatus = true,

		disabled_filetypes = {
			statusline = { "NvimTree", "toggleterm", "terminal" },
			winbar = { "toggleterm", "terminal" },
		},
	},

	sections = {
		lualine_a = { { "mode" } },

		lualine_b = {
			{
				"branch",
				icon = "",
				color = { fg = "#cccccc" },
			},
			diagnostics,
		},

		lualine_c = {},

		lualine_x = {
			{
				git_blame.get_current_blame_text,
				cond = git_blame.is_blame_text_available,
				color = { fg = "#cccccc" },
			},
		},

		lualine_y = {
			{
				function()
					return string.format("Ln %d, Col %d", vim.fn.line("."), vim.fn.col("."))
				end,
				color = { fg = "#cccccc" },
			},

			{ "encoding", color = { fg = "#cccccc" } },
			{ lsp_clients, color = { fg = "#cccccc" } },
			{ "filetype", color = { fg = "#cccccc" } },
			{ lang_version, color = { fg = "#cccccc" } },
		},

		lualine_z = {},
	},
})
