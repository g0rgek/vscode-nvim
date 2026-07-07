-- Heirline statusline and winbar configuration
-- Design: Flat + Accent — mode-colored surround, two subtle surface1 islands, flat colored FG elsewhere
local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local devicons = require("nvim-web-devicons")
local triforce = require("heirline.components.triforce")

-- ---------------------------------------------------------------------------
-- Colors
-- ---------------------------------------------------------------------------
local function setup_colors()
	local c = require("vscode.colors").get_colors()
	local is_dark = vim.o.background == "dark"
	return {
		base = is_dark and "#373737" or "#F5F5F5",
		mantle = is_dark and "#373737" or "#F5F5F5",
		crust = c.vscLeftDark,
		surface0 = c.vscTabOutside,
		surface1 = is_dark and "#373737" or "#E4E4E4",
		surface2 = c.vscLeftMid,
		overlay0 = c.vscGray,
		overlay1 = c.vscSplitLight,
		text = c.vscFront,
		subtext0 = c.vscSuggestion,
		subtext1 = c.vscLineNumber,
		-- Match lualine vscode theme mode colors (darker, less bright)
		lavender = is_dark and "#DDB6F2" or "#FFA3A3",
		green = is_dark and "#4EC9B0" or "#008000",
		yellow = is_dark and "#ffaf00" or "#c08000",
		red = c.vscRed,
		peach = c.vscLightGreen,
		blue = is_dark and "#0a7aca" or "#AF00DB",
		mauve = c.vscViolet,
		teal = c.vscBlueGreen,
		sky = c.vscLightBlue,
		diag_error = c.vscRed,
		diag_warn = c.vscYellowOrange,
		diag_info = c.vscAccentBlue,
		diag_hint = c.vscGreen,
	}
end


heirline.load_colors(setup_colors)

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		utils.on_colorscheme(setup_colors)
	end,
	group = "Heirline",
})

-- Update statusline automatically
do
	local tick = vim.uv.new_timer()
	tick:start(0,5000,vim.schedule_wrap(function()
		vim.cmd("redrawstatus")
	end))
end

-- ---------------------------------------------------------------------------
-- Async ahead/behind fetcher (debounced + cached)
-- Debounce: don't fetch more than once per 5 seconds per buffer
-- Cache: store results with timestamp, TTL 30s
-- ---------------------------------------------------------------------------
local GIT_CACHE_TTL = 30 -- seconds
local _git_cache = {} -- { [bufnr] = { ahead, behind, ts } }

local function fetch_ahead_behind(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local cwd = vim.fn.expand("#" .. bufnr .. ":p:h")
	if cwd == "" or vim.fn.isdirectory(cwd) == 0 then
		return
	end

	-- Check cache
	local cached = _git_cache[bufnr]
	if cached and (vim.fn.localtime() - cached.ts) < GIT_CACHE_TTL then
		vim.b[bufnr].git_ahead = cached.ahead
		vim.b[bufnr].git_behind = cached.behind
		return
	end

	vim.system(
		{ "git", "rev-list", "--left-right", "--count", "HEAD...@{upstream}" },
		{ cwd = cwd, text = true },
		function(result)
			if result.code ~= 0 or not result.stdout then
				return
			end
			local ahead, behind = result.stdout:match("(%d+)%s+(%d+)")
			if ahead and behind then
				ahead, behind = tonumber(ahead), tonumber(behind)
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(bufnr) then
						vim.b[bufnr].git_ahead = ahead
						vim.b[bufnr].git_behind = behind
						_git_cache[bufnr] = { ahead = ahead, behind = behind, ts = vim.fn.localtime() }
						vim.cmd("redrawstatus")
					end
				end)
			end
		end
	)
end

-- Debounce helper: track pending buffers
local _fetch_timers = {}
local function schedule_fetch(buf)
	if _fetch_timers[buf] then
		_fetch_timers[buf]:stop()
		_fetch_timers[buf]:close()
	end
	_fetch_timers[buf] = vim.uv.new_timer()
	_fetch_timers[buf]:start(
		5000,
		0,
		vim.schedule_wrap(function()
			if _fetch_timers[buf] then
				_fetch_timers[buf]:stop()
				_fetch_timers[buf]:close()
				_fetch_timers[buf] = nil
			end
			fetch_ahead_behind(buf)
		end)
	)
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	group = "Heirline",
	callback = function(ev)
		schedule_fetch(ev.buf)
	end,
})
vim.api.nvim_create_autocmd("User", {
	group = "Heirline",
	pattern = "GitSignsUpdate",
	callback = function(ev)
		schedule_fetch(ev.buf)
	end,
})

-- ---------------------------------------------------------------------------
-- Primitives
-- ---------------------------------------------------------------------------
local Space = { provider = " " }
local Align = { provider = "%=" }
local Separator = { provider = " ", hl = { fg = "surface2" } }

-- ---------------------------------------------------------------------------
-- Mode
-- ---------------------------------------------------------------------------
local Mode = {
	init = function(self)
		self.mode = vim.fn.mode(1)
	end,
	static = {
		mode_names = {
			n = "NORMAL",
			no = "O-PENDING",
			nov = "O-PENDING",
			noV = "O-PENDING",
			["no\22"] = "O-PENDING",
			niI = "NORMAL",
			niR = "NORMAL",
			niV = "NORMAL",
			nt = "NORMAL",
			v = "VISUAL",
			vs = "VISUAL",
			V = "V-LINE",
			Vs = "V-LINE",
			["\22"] = "V-BLOCK",
			["\22s"] = "V-BLOCK",
			s = "SELECT",
			S = "S-LINE",
			["\19"] = "S-BLOCK",
			i = "INSERT",
			ic = "INSERT",
			ix = "INSERT",
			R = "REPLACE",
			Rc = "REPLACE",
			Rx = "REPLACE",
			Rv = "V-REPLACE",
			Rvc = "V-REPLACE",
			Rvx = "V-REPLACE",
			c = "COMMAND",
			cv = "EX",
			ce = "EX",
			r = "REPLACE",
			rm = "MORE",
			["r?"] = "CONFIRM",
			["!"] = "SHELL",
			t = "TERMINAL",
		},
	},
	provider = function(self)
		local m = self.mode:sub(1, 1)
		return " %2(" .. self.mode_names[self.mode] .. "%) "
	end,
	hl = function(self)
		local m = self.mode:sub(1, 1)
		local fg = (m == "i" or m == "v" or m == "V" or m == "\22") and "#262626" or "text"
		return { bg = self:mode_color(), fg = fg, bold = true }
	end,
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}

-- ---------------------------------------------------------------------------
-- File icon (nvim-web-devicons)
-- ---------------------------------------------------------------------------
local FileIcon = {
	restrict = { hl = true },
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = devicons.get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ") or ""
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

-- ---------------------------------------------------------------------------
-- File extension only
-- ---------------------------------------------------------------------------
local FileExtension = {
	restrict = { hl = true },
	provider = function(self)
		local ext = vim.fn.fnamemodify(self.filename, ":e")
		return ext ~= "" and ("." .. ext) or ""
	end,
	hl = { bold = true },
}

-- ---------------------------------------------------------------------------
-- Git branch  (  branch-name ↑2 ↓1)
-- Icon: nf-pl-branch ()  Ahead: ↑  Behind: ↓
-- Color: mauve for branch, sky for ahead, peach for behind
-- ---------------------------------------------------------------------------
local GitBranch = {
	condition = conditions.is_git_repo,
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.ahead = vim.b.git_ahead or 0
		self.behind = vim.b.git_behind or 0

		local branch = self.status_dict.head or ""
		local ahead_str = self.ahead > 0 and (" \u{2191}" .. self.ahead) or ""
		local behind_str = self.behind > 0 and (" \u{2193}" .. self.behind) or ""
		local suffix = ahead_str .. behind_str .. " "

		self.full_str = " \u{e0a0} " .. branch .. suffix

		local trunc_branch = branch
		if #trunc_branch > 50 then
			trunc_branch = trunc_branch:sub(1, 47) .. "\u{2026}"
		end
		self.trunc_str = " \u{e0a0} " .. trunc_branch .. suffix

		self.icon_str = " \u{e0a0}" .. suffix
	end,
	flexible = 1,
	-- Full: icon + full branch name + ahead/behind
	{
		provider = function(self)
			return self.full_str
		end,
	},
	-- Truncated: up to 20 chars + ahead/behind
	{
		provider = function(self)
			return self.trunc_str
		end,
	},
	-- Icon only + ahead/behind
	{
		provider = function(self)
			return self.icon_str
		end,
	},
	-- Nothing when no space
	{ provider = "" },
	hl = { fg = "text", italic = true },
	update = { "BufEnter", "FocusGained", "User", pattern = "GitSignsUpdate" },
}

-- ---------------------------------------------------------------------------
-- Git diff  (+3 ~2 -1)
-- Icons: nf-md-plus-circle (), nf-md-tilde (), nf-md-minus-circle ()
-- Colors: green / yellow / red
-- ---------------------------------------------------------------------------
local GitDiff = {
	condition = conditions.is_git_repo,
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
	end,
	update = { "BufEnter", "User", pattern = "GitSignsUpdate" },
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and ("+" .. count .. " ") or ""
		end,
		hl = { fg = "green" },
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and ("~" .. count .. " ") or ""
		end,
		hl = { fg = "yellow" },
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and ("-" .. count .. " ") or ""
		end,
		hl = { fg = "red" },
	},
}

-- ---------------------------------------------------------------------------
-- Macro recording
-- ---------------------------------------------------------------------------
local MacroRec = {
	condition = function()
		return vim.fn.reg_recording() ~= ""
	end,
	update = {
		"RecordingEnter",
		"RecordingLeave",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
	{
		provider = " \u{f044b} ",
		hl = { fg = "red", bold = true },
	},
	utils.surround({ "[", "]" }, "", {
		provider = function()
			return vim.fn.reg_recording()
		end,
		hl = { fg = "red", bold = true },
	}),
}

-- ---------------------------------------------------------------------------
-- Search count (visible when cmdheight=0 and search is active)
-- ---------------------------------------------------------------------------
local SearchCount = {
	condition = function()
		return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
	end,
	init = function(self)
		local ok, search = pcall(vim.fn.searchcount)
		if ok and search.total then
			self.search = search
		end
	end,
	provider = function(self)
		local s = self.search
		if not s then
			return ""
		end
		return string.format("[%d/%d]", s.current, math.min(s.total, s.maxcount))
	end,
	hl = { fg = "subtext0" },
}

-- ---------------------------------------------------------------------------
-- Spell indicator
-- ---------------------------------------------------------------------------
local Spell = {
	condition = function()
		return vim.wo.spell
	end,
	provider = " \u{2714}",
	hl = { fg = "peach", bold = true },
}

-- ---------------------------------------------------------------------------
-- Paste indicator
-- ---------------------------------------------------------------------------
local Paste = {
	condition = function()
		return vim.o.paste
	end,
	provider = " PASTE ",
	hl = { fg = "mantle", bg = "peach", bold = true },
}

-- ---------------------------------------------------------------------------
-- Diagnostics
-- ---------------------------------------------------------------------------
local Diagnostics = {
	condition = conditions.has_diagnostics,
	static = {
		error_icon = "\u{f0166} ",
		warn_icon = "\u{f002a} ",
		info_icon = "\u{f02fd} ",
		hint_icon = "\u{f0336} ",
	},
	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	end,
	update = "DiagnosticChanged",
	{
		provider = function(self)
			return self.errors > 0 and (" " .. self.error_icon .. self.errors) or ""
		end,
		hl = { fg = "diag_error" },
	},
	{
		provider = function(self)
			return self.warnings > 0 and (" " .. self.warn_icon .. self.warnings) or ""
		end,
		hl = { fg = "diag_warn" },
	},
	{
		provider = function(self)
			return self.info > 0 and (" " .. self.info_icon .. self.info) or ""
		end,
		hl = { fg = "diag_info" },
	},
	{
		provider = function(self)
			return self.hints > 0 and (" " .. self.hint_icon .. self.hints) or ""
		end,
		hl = { fg = "diag_hint" },
	},
}

-- ---------------------------------------------------------------------------
-- LSP progress cache (updated by autocmd, read by LSPActive init)
-- ---------------------------------------------------------------------------
local _lsp_progress = {}

vim.api.nvim_create_autocmd("LspProgress", {
	group = "Heirline",
	callback = function(ev)
		local client_id = ev.data.client_id
		local value = ev.data.params.value
		if value.kind == "end" then
			_lsp_progress[client_id] = nil
		else
			_lsp_progress[client_id] = {
				title = value.title or "",
				message = value.message or "",
				percentage = value.percentage,
			}
		end
		vim.schedule(function()
			vim.cmd("redrawstatus")
		end)
	end,
})

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
	group = "Heirline",
	callback = function()
		vim.schedule(function()
			vim.cmd("redrawstatus")
		end)
	end,
})

-- ---------------------------------------------------------------------------
-- LSP active
-- ---------------------------------------------------------------------------
local LSPActive = {
	condition = conditions.lsp_attached,
	init = function(self)
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if #clients == 0 then
			self.lsp_str = ""
			return
		end

		-- Build lookup of buffer-local client IDs
		local buf_clients = {}
		for _, client in ipairs(clients) do
			buf_clients[client.id] = client.name
		end

		-- Show progress for first active buffer-local client
		for client_id, p in pairs(_lsp_progress) do
			if buf_clients[client_id] then
				local msg = buf_clients[client_id]
				if p.title ~= "" then
					msg = msg .. " " .. p.title
				end
				if p.message ~= "" then
					msg = msg .. " " .. p.message
				end
				if p.percentage then
					msg = msg .. " " .. p.percentage .. "%"
				end
				if #msg > 40 then
					msg = msg:sub(1, 37) .. "\u{2026}"
				end
				-- Escape '%' for statusline rendering (prevents E539)
				msg = msg:gsub("%%", "%%%%")
				self.lsp_str = " \u{f04cb} " .. msg
				return
			end
		end

		-- Idle — show attached client names
		local names = {}
		for _, client in ipairs(clients) do
			names[#names + 1] = client.name
		end
		self.lsp_str = " \u{f04cb} " .. table.concat(names, "\u{2219}")
	end,
	update = {
		"LspAttach",
		"LspDetach",
		"BufEnter",
		"LspProgress",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
	flexible = 3,
	{
		provider = function(self)
			return self.lsp_str
		end,
	},
	{ provider = " \u{f04cb} " },
	{ provider = "" },
	hl = { fg = "lavender", italic = true },
}

-- ---------------------------------------------------------------------------
-- CodeCompanion status
-- ---------------------------------------------------------------------------
local CodeCompanionStatus = {
	condition = function()
		local s = vim.g.codecompanion_status
		return s and s.active
	end,
	provider = function()
		local s = vim.g.codecompanion_status
		if not s then return "" end
		local adapter = s.adapter and (s.adapter .. " ") or ""
		local msg = s.message or ""
		return " " .. adapter .. msg .. ""
	end,
	hl = { fg = "lavender", bold = true }
}

-- ---------------------------------------------------------------------------
-- Badges (flat: colored FG, no bg)
-- ---------------------------------------------------------------------------
local Badges = {
	{
		condition = function()
			return (vim.g.current_color_theme or "latte") == "nge"
		end,
		provider = "\u{f1bf4} ",
		hl = function()
			if _G.theme_colors then
				local badge = _G.theme_colors.get_badge_colors("theme")
				return { fg = badge.bg, bold = true }
			end
			return { fg = "mauve", bold = true }
		end,
	},
	{
		condition = function()
			return vim.g.experimental_enabled
		end,
		provider = "\u{f0668} ",
		hl = { fg = "peach", bold = true },
	},
}

-- ---------------------------------------------------------------------------
-- File info (hide defaults: utf-8, unix)
-- ---------------------------------------------------------------------------
local FileEncoding = {
	provider = function()
		local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
		if enc == "utf-8" then
			return ""
		end
		return enc:upper() .. " "
	end,
	hl = { fg = "subtext0", italic = true },
}

local FileFormat = {
	provider = function()
		local fmt = vim.bo.fileformat
		if fmt == "unix" then
			return ""
		end
		local symbols = { dos = "\u{f0d72}", mac = "\u{f0035}" }
		return (symbols[fmt] or fmt) .. " "
	end,
	hl = { fg = "subtext0" },
}

-- ---------------------------------------------------------------------------
-- Git blame using git-blame.nvim
-- ---------------------------------------------------------------------------
local GitBlame = {
	condition = function()
		local ok, gitblame = pcall(require, "gitblame")
		return ok and gitblame ~= nil
	end,
	provider = function()
		local ok, gitblame = pcall(require, "gitblame")
		if not ok then
			return ""
		end
		return gitblame.get_current_blame_text() or ""
	end,
	hl = { fg = "text" },
}


-- ---------------------------------------------------------------------------
-- Language version helper
-- ---------------------------------------------------------------------------
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

local FileType = {
	provider = function()
		local ft = vim.bo.filetype
		local ver = lang_version()
		if ft == "" then
			return "no ft"
		end
		return ver ~= "" and (ft .. " " .. ver) or ft
	end,
	hl = { fg = "text", bold = true },
}

-- ---------------------------------------------------------------------------
-- Location & progress (VSCode style: Ln X, Col Y)
-- ---------------------------------------------------------------------------
local Location = {
	provider = function()
		local line = vim.fn.line(".")
		local col = vim.fn.col(".")
		return string.format(" Ln %d, Col %d", line, col)
	end,
	hl = { fg = "text" },
}

-- ---------------------------------------------------------------------------
-- ScrollBar (mode-color dynamic fg, throttled to 100ms)
-- ---------------------------------------------------------------------------
local ScrollBar = {
	static = {
		sbar = { "\u{2581}", "\u{2582}", "\u{2583}", "\u{2584}", "\u{2585}", "\u{2586}", "\u{2587}", "\u{2588}" },
	},
	provider = function(self)
		local curr_line = vim.api.nvim_win_get_cursor(0)[1]
		local lines = vim.api.nvim_buf_line_count(0)
		local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
		return string.rep(self.sbar[i], 2)
	end,
	hl = function(self)
		return { fg = self:mode_color(), bg = "mantle" }
	end,
}

-- ---------------------------------------------------------------------------
-- Right info island (surface1 accent surround)
-- ---------------------------------------------------------------------------
local RightInfoIsland = {
	hl = { bg = "surface1", fg = "text" },
	Badges,
	FileEncoding,
	FileFormat,
	FileType,
}

-- ===========================================================================
-- StatusLine variants
-- ===========================================================================

-- Default statusline for normal buffers
local DefaultStatusline = {
	Mode,
	Space,
	GitBranch,
	Diagnostics,
	-- GitDiff,
	MacroRec,
	Align,
	SearchCount,
	Space,
	triforce.Component,
	-- Space,
	Spell,
	Paste,
	Space,
	-- GitBlame,
	Space,
	Location,
	Space,
	LSPActive,
	Space,
	CodeCompanionStatus,
	Space,
	RightInfoIsland,
}

-- Special statusline for help, quickfix, man, etc.
local SpecialStatusline = {
	condition = function()
		return conditions.buffer_matches({
			buftype = { "help", "quickfix", "nofile" },
			filetype = { "fugitive", "gitcommit" },
		})
	end,
	Mode,
	Space,
	{
		provider = function()
			local ft = vim.bo.filetype
			return ft ~= "" and ft:upper() or vim.bo.buftype:upper()
		end,
		hl = { fg = "subtext0", bold = true },
	},
	Space,
	{
		-- Show helpfile name or quickfix title
		provider = function()
			if vim.bo.buftype == "help" then
				return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
			end
			if vim.bo.buftype == "quickfix" then
				return vim.w.quickfix_title or ""
			end
			return ""
		end,
		hl = { fg = "text", bold = true },
	},
	Align,
	Location,
}

-- Terminal statusline
local TerminalStatusline = {
	condition = function()
		return conditions.buffer_matches({ buftype = { "terminal" } })
	end,
	Mode,
	Space,
	{
		provider = function()
			local tname = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
			return "\u{f018d} " .. tname
		end,
		hl = { fg = "subtext0", bold = true },
	},
	Align,
}

-- Inactive statusline (dimmed, minimal with git context)
local InactiveStatusline = {
	condition = conditions.is_not_active,
	{
		provider = function(self)
			local m = self.mode:sub(1, 1)
			local icon = self.mode_icons[m] or "\u{f0da0}"
			return " " .. icon .. " "
		end,
		hl = { fg = "overlay0" },
	},
	{
		init = function(self)
			self.filename = vim.api.nvim_buf_get_name(0)
		end,
		FileIcon,
		FileName,
		hl = { fg = "overlay0", force = true },
	},
	{
		-- Git branch context (dimmed, no ahead/behind to save space)
		condition = conditions.is_git_repo,
		init = function(self)
			self.status_dict = vim.b.gitsigns_status_dict
		end,
		provider = function(self)
			local branch = self.status_dict.head or ""
			if branch == "" then
				return ""
			end
			return " \u{e0a0} " .. branch
		end,
		hl = { fg = "overlay1", italic = true },
	},
	Align,
	{
		provider = "%l:%c",
		hl = { fg = "overlay0" },
	},
}

-- ===========================================================================
-- StatusLines (root: fallthrough = false, carries mode_color static)
-- ===========================================================================
local StatusLines = {
	hl = { bg = "mantle" },
	static = {
		mode_colors = {
			n = "blue",
			i = "green",
			v = "yellow",
			V = "yellow",
			["\22"] = "yellow",
			c = "lavender",
			R = "red",
			t = "green",
		},
		mode_color = function(self)
			local mode = vim.fn.mode():sub(1, 1)
			return self.mode_colors[mode] or "blue"
		end,
	},
	fallthrough = false,
	SpecialStatusline,
	TerminalStatusline,
	InactiveStatusline,
	DefaultStatusline,
}

-- ===========================================================================
-- WinBar
-- ===========================================================================
local WinBarFileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = devicons.get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ") or ""
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

local PATH_SEP = package.config:sub(1, 1)

local function drop_leading(path, n)
	local pos = 1
	for _ = 1, n do
		pos = path:find(PATH_SEP, pos, true)
		if not pos then
			return nil
		end
		pos = pos + 1
	end
	return "\u{2026}" .. PATH_SEP .. path:sub(pos)
end

local WinBarFilePath = {
	flexible = 2,
	init = function(self)
		self.relpath = vim.fn.fnamemodify(self.filename, ":.")
		if self.relpath == "" then
			self.relpath = "[No Name]"
		end
		self.basename = vim.fn.fnamemodify(self.filename, ":t")
		if self.basename == "" then
			self.basename = "[No Name]"
		end
	end,
	{
		provider = function(self)
			return self.relpath
		end,
	},
	{
		provider = function(self)
			return drop_leading(self.relpath, 1) or self.basename
		end,
	},
	{
		provider = function(self)
			return drop_leading(self.relpath, 2) or self.basename
		end,
	},
	{
		provider = function(self)
			return drop_leading(self.relpath, 3) or self.basename
		end,
	},
	{
		provider = function(self)
			return drop_leading(self.relpath, 4) or self.basename
		end,
	},
	{
		provider = function(self)
			return drop_leading(self.relpath, 5) or self.basename
		end,
	},
	{
		provider = function(self)
			return self.basename
		end,
	},
	hl = { bold = true },
}

local WinBarFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = " \u{25CF}",
		hl = { fg = "yellow" },
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = " \u{f033e}",
		hl = { fg = "red" },
	},
}

local WinBar = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	hl = function()
		if not conditions.is_active() then
			return { fg = "overlay0", force = true }
		end
	end,
	WinBarFileIcon,
	WinBarFilePath,
	WinBarFlags,
}

-- ===========================================================================
-- TabLine (Bufferline)
-- ===========================================================================

-- Buffer filename (tail only, with parent folder for duplicates)
local function get_unique_filename(bufnr)
	local bufs = vim.tbl_filter(function(b)
		return vim.api.nvim_get_option_value("buflisted", { buf = b })
	end, vim.api.nvim_list_bufs())

	-- Collect all filenames
	local filenames = {}
	for _, b in ipairs(bufs) do
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":t")
		if name == "" then name = "[No Name]" end
		if not filenames[name] then filenames[name] = {} end
		table.insert(filenames[name], b)
	end

	-- Find duplicates
	local duplicates = {}
	for name, buf_list in pairs(filenames) do
		if #buf_list > 1 then
			duplicates[name] = true
		end
	end

	-- Return parent folder + filename for duplicates, tail for unique
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local tail = vim.fn.fnamemodify(filename, ":t")
	if tail == "" then tail = "[No Name]" end

	if duplicates[tail] then
		local parent = vim.fn.fnamemodify(filename, ":h:t")
		return parent .. "/" .. tail
	end
	return tail
end

local TablineFileName = {
	provider = function(self)
		return get_unique_filename(self.bufnr)
	end,
	hl = function(self)
		return { bold = self.is_active, italic = false }
	end,
}

-- Modified / readonly / terminal flags per-buffer
local TablineFileFlags = {
	{
		condition = function(self)
			return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
		end,
		provider = " \u{25CF}",
		hl = { fg = "yellow" },
	},
	{
		condition = function(self)
			return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
				or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
		end,
		provider = function(self)
			if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
				return " \u{f018d}"
			else
				return " \u{f033e}"
			end
		end,
		hl = { fg = "red" },
	},
}

-- Assemble filename block: icon + name + flags
local TablineFileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(self.bufnr)
	end,
	hl = function(self)
		if self.is_active then
			return "TabLineSel"
		else
			return "TabLine"
		end
	end,
	on_click = {
		callback = function(_, minwid, _, button)
			if button == "m" then -- middle-click closes buffer
				vim.schedule(function()
					vim.api.nvim_buf_delete(minwid, { force = false })
				end)
			else
				vim.api.nvim_win_set_buf(0, minwid)
			end
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "heirline_tabline_buffer_callback",
	},
	{ provider = " " },
	-- FileIcon,
	TablineFileName,
	TablineFileFlags,
	{ provider = " " },
}

-- Close button (only for unmodified buffers)
local TablineCloseButton = {
	condition = function(self)
		return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
	end,
	{ provider = " " },
	{
		provider = "\u{f00d}",
		hl = { fg = "overlay0" },
		on_click = {
			callback = function(_, minwid)
				vim.schedule(function()
					vim.api.nvim_buf_delete(minwid, { force = false })
					vim.cmd.redrawtabline()
				end)
			end,
			minwid = function(self)
				return self.bufnr
			end,
			name = "heirline_tabline_close_buffer_callback",
		},
	},
}

-- Wrap each buffer block matching the statusline style
local TablineBufferBlock = { TablineFileNameBlock }

-- Build the bufferline using heirline's make_buflist
local BufferLine = utils.make_buflist(
	TablineBufferBlock,
	{ provider = "\u{f104} ", hl = { fg = "overlay0" } }, -- left truncation
	{ provider = " \u{f105}", hl = { fg = "overlay0" } } -- right truncation
)

-- Tab pages (shown only when ≥2 tabs)
local Tabpage = {
	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabnr .. " T"
	end,
	hl = function(self)
		if self.is_active then
			return { fg = "text", bg = "surface1", bold = true }
		else
			return { fg = "overlay0", bg = "mantle" }
		end
	end,
}

local TabPages = {
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	{ provider = "%=" },
	utils.make_tablist(Tabpage),
}

-- Sidebar offset
local TabLineOffset = {
	condition = function(self)
		local win = vim.api.nvim_tabpage_list_wins(0)[1]
		local bufnr = vim.api.nvim_win_get_buf(win)
		self.winid = win
		if vim.bo[bufnr].filetype == "neo-tree" then
			self.title = "Explorer"
			return true
		elseif vim.bo[bufnr].filetype == "dbui" then
			self.title = "Database"
			return true
		elseif vim.bo[bufnr].filetype == "time-machine-list" then
			self.title = "History"
			return true
		elseif vim.bo[bufnr].filetype == "grpcui" then
			self.title = "gRPC"
			return true
		elseif vim.bo[bufnr].filetype == "grug-far" then
			self.title = "Find & Replace"
			return true
		end
	end,
	provider = function(self)
		local title = self.title
		local width = vim.api.nvim_win_get_width(self.winid)
		local pad = math.ceil((width - #title) / 2)
		return string.rep(" ", pad) .. title .. string.rep(" ", pad)
	end,
	hl = function(self)
		if vim.api.nvim_get_current_win() == self.winid then
			return { fg = "text", bg = "#2d2d2d" }
		else
			return { fg = "overlay0", bg = "surface0" }
		end
	end,
}

-- Build bufnr → position index map once per tabline render (O(M) scan, not O(N×M))
local TabLine = {
	init = function(self)
		local bufs = vim.tbl_filter(function(b)
			return vim.api.nvim_get_option_value("buflisted", { buf = b })
		end, vim.api.nvim_list_bufs())
		self._buf_indices = {}
		for i, b in ipairs(bufs) do
			self._buf_indices[b] = i
		end
	end,
	TabLineOffset,
	BufferLine,
	TabPages,
}

-- Show tabline always (2) or auto (1); hide when only 1 listed buffer
vim.o.showtabline = 2
-- Set tabline background color
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#1f1f1f" })

-- ===========================================================================
-- Setup
-- ===========================================================================
heirline.setup({
	statusline = nil,
	winbar = nil,
	tabline = TabLine,
	opts = {
		disable_winbar_cb = function(args)
			return conditions.buffer_matches({
				buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
				filetype = {
					"^git.*",
					"fugitive",
					"neo%-tree",
					"Trouble",
					"lazy",
					"alpha",
					"dashboard",
				},
			}, args.buf)
		end,
	},
})

-- Override active tab background color (after setup so it isn't reset)
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#0074c2", fg = "#ffffff" })

