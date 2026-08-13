-- =============================================================================
-- Native Helix-style statusline
--   Mode  |  path  |  (N sel)  |                    25:17
-- =============================================================================

-- Register statusline highlights (uniform blue background)
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#ffffff", bg = "#0074c2", bold = true })
vim.api.nvim_set_hl(0, "StatusFilePath", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusSelCount", { fg = "#b4d5f5", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusGoVersion", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusLocation", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusSeparator", { fg = "#0074c2" })

-- Message area highlights: match statusline background so no flicker
-- vim.api.nvim_set_hl(0, "MsgArea",       { fg = "#ffffff", bg = "#0074c2" })
-- vim.api.nvim_set_hl(0, "MsgSeparator",  { fg = "#0074c2", bg = "#0074c2" })

-- Mode label map
local mode_labels = {
	n = " NOR ",
	i = " INS ",
	v = " VIS ",
	V = " V-LINE ",
	["\22"] = " V-BLOCK ",
	c = " CMD ",
	R = " REPLACE ",
	t = " TERM ",
	s = " SELECT ",
	["\19"] = " S-BLOCK ",
}

-- Cached Go version (fetched lazily via deferred pack entry, never at startup)
local go_version_cached = nil

local M = {}

function M.version()
	if go_version_cached ~= nil then
		return
	end
	local ok, out = pcall(vim.fn.system, "go version")
	if ok and out ~= "" then
		-- "go version go1.22.5 darwin/arm64" → " go1.22.5 "
		go_version_cached = " " .. vim.split(vim.trim(out), " ")[3] .. " "
	else
		go_version_cached = ""
	end
end

-- Export for plugins/ wrapper
_G.core_statusline = M

-- Build the statusline string
local function statusline()
	local mode = vim.fn.mode()
	local label = mode_labels[mode] or (" " .. mode:upper() .. " ")

	-- File path (relative to cwd)
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
	if path == "" then
		path = "[No Name]"
	end

	-- Selection count (only in visual mode)
	local sel = ""
	if mode:find("[vV\22]") then
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		if start_pos[2] and end_pos[2] then
			local count = math.abs(end_pos[2] - start_pos[2]) + 1
			if count >= 1 then
				sel = string.format(" (%d sel) ", count)
			end
		end
	end

	-- Go version (only for Go files, uses cached value — nil if not yet fetched)
	local go_version = ""
	if vim.fn.expand("%:e") == "go" and go_version_cached ~= nil then
		go_version = go_version_cached
	end

	-- Line : Column (Helix-style)
	local loc = string.format(" %d:%d ", vim.fn.line("."), vim.fn.col("."))

	return table.concat({
		"%#StatusLineMode#",
		label,
		" ",
		"%*%#StatusFilePath#",
		path,
		"%*%#StatusSelCount#",
		sel,
		"%*%#StatusSeparator#%=%#StatusGoVersion#",
		go_version,
		"%*%#StatusLocation#",
		loc,
		"%*",
	})
end

vim.o.statusline = "%{%v:lua.statusline()%}"
_G.statusline = statusline

-- Helper to re-apply after colorscheme resets
local function apply_highlights()
	pcall(vim.api.nvim_set_hl, 0, "StatusLine", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusLineMode", { fg = "#ffffff", bg = "#0074c2", bold = true })
	pcall(vim.api.nvim_set_hl, 0, "StatusFilePath", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusSelCount", { fg = "#b4d5f5", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusGoVersion", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusLocation", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusSeparator", { fg = "#0074c2" })
	-- pcall(vim.api.nvim_set_hl, 0, "MsgArea",         { fg = "#ffffff", bg = "#0074c2" })
	-- pcall(vim.api.nvim_set_hl, 0, "MsgSeparator",    { fg = "#0074c2", bg = "#0074c2" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_highlights,
})
