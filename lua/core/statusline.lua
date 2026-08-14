-- =============================================================================
-- Native Helix-style statusline
--   Mode  |  path  |  (N sel)  |                    25:17
-- =============================================================================

-- Register statusline highlights (uniform blue background)
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#ffffff", bg = "#0074c2", bold = true })
vim.api.nvim_set_hl(0, "StatusFilePath", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusSelCount", { fg = "#b4d5f5", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusGoVersion", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusLocation", { fg = "#ffffff", bg = "#0074c2" })
vim.api.nvim_set_hl(0, "StatusSearchCount", { fg = "#b4d5f5", bg = "#0074c2" })
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

-- Search match count ([cur/total]) shown to the left of Line:Column while
-- hlsearch is active. recompute=1 derives the current match from the cursor
-- position on every evaluation, so it stays correct however the cursor got
-- there (n/N, a remap, a jump plugin, or a manual move while hlsearch is on).
-- recompute=0 would rely on Neovim's internal search cache, which can return a
-- frozen "1" as the cursor moves outside of a plain n/N search. Hidden after
-- :nohlsearch (vim.v.hlsearch becomes 0) or when there are no matches.
local function search_count()
	if vim.v.hlsearch == 0 then
		return ""
	end
	local ok, sc = pcall(vim.fn.searchcount, { recompute = 1, maxcount = 99, timeout = 500 })
	if not ok or type(sc) ~= "table" or not sc.total or sc.total == 0 then
		return ""
	end
	return string.format(" [%d/%d]", sc.current, sc.total)
end

-- Build the statusline string
local function statusline()
	local mode = vim.fn.mode()
	local label = mode_labels[mode] or (" " .. mode:upper() .. " ")

	-- File path (relative to cwd)
	local ft = vim.bo.filetype
	local path
	if ft == "codecompanion" or ft == "codecompanion_input" then
		-- The chat buffer's name is an LLM-generated title derived from the
		-- first message; show a stable label instead of leaking it into the
		-- statusline as if it were the filename.
		path = "CodeCompanion"
	else
		path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
		if path == "" then
			path = "[No Name]"
		end
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

	-- Search match count, shown before Line:Column when hlsearch is on
	local search = search_count()

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
		"%*%#StatusSearchCount#",
		search,
		"%*%#StatusLocation#",
		loc,
		"%*",
	})
end

vim.o.statusline = "%{%v:lua.statusline()%}"
_G.statusline = statusline

-- Neovim caches the result of the %{...} expression and only rebuilds it on
-- mode/window changes, so the statusline would go stale as the cursor moves
-- (cycling matches with n/N leaves the [cur/total] count frozen, and
-- :nohlsearch leaves it lingering). Rebuild it whenever the cursor moves or a
-- command line is left (covers n/N, :nohlsearch, :set [no]hlsearch, / and ?).
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "CmdlineLeave" }, {
	group = vim.api.nvim_create_augroup("core_statusline_redraw", { clear = true }),
	callback = function()
		vim.cmd("redrawstatus")
	end,
})

-- Helper to re-apply after colorscheme resets
local function apply_highlights()
	pcall(vim.api.nvim_set_hl, 0, "StatusLine", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusLineNC", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusLineMode", { fg = "#ffffff", bg = "#0074c2", bold = true })
	pcall(vim.api.nvim_set_hl, 0, "StatusFilePath", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusSelCount", { fg = "#b4d5f5", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusGoVersion", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusLocation", { fg = "#ffffff", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusSearchCount", { fg = "#b4d5f5", bg = "#0074c2" })
	pcall(vim.api.nvim_set_hl, 0, "StatusSeparator", { fg = "#0074c2" })
	-- pcall(vim.api.nvim_set_hl, 0, "MsgArea",         { fg = "#ffffff", bg = "#0074c2" })
	-- pcall(vim.api.nvim_set_hl, 0, "MsgSeparator",    { fg = "#0074c2", bg = "#0074c2" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_highlights,
})
