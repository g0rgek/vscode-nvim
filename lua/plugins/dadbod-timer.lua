---Live query execution timer for dadbod-ui.
---Shows a floating window with an elapsed timer near the query buffer
---while a database query is running, similar to JetBrains DataGrip.
---
---Hooks:
---  User *DBExecutePre  → show the timer
---  User *DBExecutePost → hide the timer, show final elapsed

local M = {}

local ns_id = vim.api.nvim_create_namespace("dadbod_timer")

---@type { win: integer?, buf: integer?, timer: integer?, start_time: number, bufnr: integer? }
local state = {
	win = nil,
	buf = nil,
	timer = nil,
	start_time = 0,
	bufnr = nil,
}

---Find a good position for the timer floating window relative to the query buffer.
---Prefer the upper-right corner of the current window.
local function get_timer_config()
	local win = vim.api.nvim_get_current_win()
	local width = vim.api.nvim_win_get_width(win)
	return {
		relative = "win",
		width = 22,
		height = 1,
		row = 0,
		col = width - 22,
		focusable = false,
		style = "minimal",
		border = "rounded",
		win = win,
		zindex = 100,
	}
end

---Format elapsed time with spinner icon.
local SPINNER = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local function format_timer(elapsed_sec, frame)
	local icon = SPINNER[(frame % #SPINNER) + 1]
	return string.format(" " .. icon .. "  %.1fs  ", elapsed_sec)
end

---Timer tick callback.
local function tick()
	if not state.start_time or state.start_time == 0 then
		return
	end

	local elapsed = vim.fn.reltimefloat(vim.fn.reltime()) - state.start_time

	-- Update floating window if still valid
	if state.win and state.buf and vim.api.nvim_win_is_valid(state.win) then
		local frame = math.floor(elapsed * 10)
		local text = format_timer(elapsed, frame)
		local lines = vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)
		if lines[1] ~= text then
			vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, { text })
		end
	end

	-- Also update virtual text in the query buffer as a fallback
	if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
		local frame = math.floor(elapsed * 10)
		local text = SPINNER[(frame % #SPINNER) + 1] .. " executing " .. string.format("%.1fs", elapsed)
		vim.api.nvim_buf_clear_namespace(state.bufnr, ns_id, 0, -1)
		vim.api.nvim_buf_set_extmark(state.bufnr, ns_id, 0, 0, {
			virt_text = { { text, "NonText" } },
			virt_text_pos = "right_align",
		})
	end
end

---Show the live timer.
local function show_timer()
	-- Record start time
	state.start_time = vim.fn.reltimefloat(vim.fn.reltime())
	state.bufnr = vim.api.nvim_get_current_buf()

	-- Create floating window near the query buffer
	local config = get_timer_config()
	state.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(state.buf, "buftype", "nofile")
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, { format_timer(0, 0) })

	-- Set highlight on the timer buffer
	vim.api.nvim_set_hl(0, "DbeeTimerFloat", { link = "FloatTitle" })
	vim.api.nvim_buf_set_option(state.buf, "filetype", "dbee")

	pcall(function()
		state.win = vim.api.nvim_open_win(state.buf, false, config)
		vim.api.nvim_win_set_option(state.win, "winhl", "Normal:DbeeTimerFloat")
	end)

	-- Start 100ms tick timer
	state.timer = vim.fn.timer_start(100, function()
		vim.schedule(tick)
	end, { ["repeat"] = -1 })
end

---Hide the timer and show final time.
local function hide_timer()
	-- Stop tick timer
	if state.timer then
		pcall(vim.fn.timer_stop, state.timer)
		state.timer = nil
	end

	-- Close floating window
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		pcall(vim.api.nvim_win_close, state.win, true)
	end
	state.win = nil
	state.buf = nil

	-- Clear virtual text
	if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
		vim.api.nvim_buf_clear_namespace(state.bufnr, ns_id, 0, -1)
	end

	-- Calculate final time and show notification
	if state.start_time and state.start_time > 0 then
		local elapsed = vim.fn.reltimefloat(vim.fn.reltime()) - state.start_time
		vim.schedule(function()
			vim.notify(string.format("󰆼  Query finished in %.3fs", elapsed), vim.log.levels.INFO, {
				title = "DB Query",
				timeout = 3000,
			})
		end)
	end

	state.start_time = 0
	state.bufnr = nil
end

---Initialize: set up autocmds.
function M.setup()
	vim.api.nvim_create_augroup("dadbod_timer_live", { clear = true })

	vim.api.nvim_create_autocmd("User", {
		group = "dadbod_timer_live",
		pattern = "*DBExecutePre",
		callback = function()
			vim.schedule(show_timer)
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		group = "dadbod_timer_live",
		pattern = "*DBExecutePost",
		callback = function()
			vim.schedule(hide_timer)
		end,
	})
end

return M
