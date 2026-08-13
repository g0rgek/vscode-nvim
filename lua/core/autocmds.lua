-- =============================================================================
-- Core Autocommands
-- Includes: highlight-on-yank, auto-save, session management,
--           build hooks (PackChanged), LSP log rotation
-- =============================================================================

-- =============================================================================
-- HIGHLIGHT ON YANK
-- =============================================================================
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("nvimpack-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- =============================================================================
-- SESSION MANAGEMENT (replaces persistence.nvim)
-- Saves session to stdpath('data')/sessions/ on exit; loads on demand.
-- =============================================================================

local _session_dir = vim.fn.stdpath("data") .. "/sessions"
vim.fn.mkdir(_session_dir, "p")

-- Expose session dir for keymaps in tools.lua
vim.g._native_session_dir = _session_dir

local _session_save_enabled = true
local _session_group = vim.api.nvim_create_augroup("nvimpack-session", { clear = true })

vim.api.nvim_create_autocmd("VimLeavePre", {
	desc = "Auto-save session on exit",
	group = _session_group,
	callback = function()
		if not _session_save_enabled then
			return
		end
		-- Only save if Neovim was opened without file arguments
		if #vim.fn.argv() == 0 then
			local session_file = _session_dir .. "/last.vim"
			pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(session_file))
		end
	end,
})

-- Expose session control for keymap callbacks
function vim.g._session_disable()
	_session_save_enabled = false
	-- Clear the autocmd so the current session is not saved
	vim.api.nvim_create_augroup("nvimpack-session", { clear = true })
	vim.notify("Session auto-save disabled for this session", vim.log.levels.INFO)
end

-- =============================================================================
-- LSP LOG ROTATION
-- Truncate the LSP log file on VimEnter if it exceeds 10 MB to prevent
-- unbounded growth (the default log level is WARN, which still accumulates).
-- The log is recreated automatically when LSP clients start.
-- =============================================================================
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Truncate oversized LSP log file",
	group = vim.api.nvim_create_augroup("nvimpack-lsp-log-rotation", { clear = true }),
	callback = function()
		local log_path = vim.lsp.log.get_filename()
		if not log_path then
			return
		end
		local ok, stat = pcall(vim.uv.fs_stat, log_path)
		if ok and stat and stat.size > 10 * 1024 * 1024 then
			pcall(vim.uv.fs_unlink, log_path)
		end
	end,
})

-- =============================================================================
-- CLOSE QUICKFIX / LOCATION LIST WITH q
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf", "help", "man", "lspinfo", "notify" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
	end,
})

-- =============================================================================
-- ENABLE CSV RENDER
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "csv" },
	callback = function()
		vim.cmd("CsvViewToggle display_mode=highlight header_lnum=1")
	end,
})

-- =============================================================================
-- AUTOUPDATE BUFFER ON FOCUS
-- =============================================================================
-- Autoupdate buffer on focus
-- vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
--   pattern = [[*]],
--   command = "silent! checktime",
-- })
--
