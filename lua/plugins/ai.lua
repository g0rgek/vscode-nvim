require("codecompanion").setup({
	display = {
		chat = {
			-- Fold code-context blocks (the files/selections shared via
			-- #{buffer}/#{selection}). These are usually the largest part of a
			-- chat buffer, so folding them keeps long chats fast to open/render.
			fold_context = true,
			window = {
				position = "right",
			},
		},
	},
	opts = {
		log_level = "DEBUG",
		show_defaults = false,
		language = "English",
	},
	interactions = {
		chat = {
			adapter = "fcc",
		},
		inline = {
			adapter = "fcc",
		},
		cmd = {
			adapter = "fcc",
		},
	},
	adapters = {
		acp = {
			opts = {
				show_presets = false,
			},
			fcc = function()
				return require("codecompanion.adapters.acp").extend("claude_code", {
				})
			end,
		},
		http = {
			opts = {
				show_presets = false,
			},
		},
	},
})

-- Give the `#` editor-context and `@` tool tags a visible background so they
-- read as distinct, clickable commands rather than plain text.
vim.api.nvim_set_hl(0, "CodeCompanionChatEditorContext", { fg = "#9CDCFE", bg = "#223E55" })
vim.api.nvim_set_hl(0, "CodeCompanionChatTool", { fg = "#C586C0", bg = "#3A3D41" })
vim.api.nvim_set_hl(0, "CodeCompanionChatToolGroup", { fg = "#C586C0", bg = "#3A3D41" })

-- Send the visual selection to the existing chat and focus it (the plain
-- `CodeCompanionChat` command spawns a fresh window and doesn't focus).
map("v", "<leader>as", function()
	local cc = require("codecompanion")
	local chat = cc.last_chat()
	if not chat then
		chat = cc.chat()
	end
	if not chat then
		return vim.notify("Could not create chat buffer", vim.log.levels.WARN)
	end
	-- Refresh the chat's buffer context with the current visual selection so
	-- the `#{selection}` tag resolves to it (an existing chat's stored context
	-- is stale and would otherwise warn "No visual selection found").
	chat.buffer_context = require("codecompanion.utils.context").get(vim.api.nvim_get_current_buf())
	chat:add_buf_message({
		role = require("codecompanion.config").constants.USER_ROLE,
		content = "#{selection}",
	})
	chat.ui:open()
	if chat.ui and chat.ui.winnr and vim.api.nvim_win_is_valid(chat.ui.winnr) then
		vim.api.nvim_set_current_win(chat.ui.winnr)
	end
end, { desc = "[S]end selection to Companion" })
map("v", "<leader>aS", function()
	local start_line, end_line = vim.fn.line("v"), vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	local line_ref = string.format("#L%d-%d", start_line, end_line)

	local chat = require("codecompanion").last_chat()
	if not chat then
		chat = require("codecompanion").chat()
		if not chat then
			return vim.notify("Could not create chat buffer", vim.log.levels.WARN)
		end
	end
	chat:add_buf_message({
		role = require("codecompanion.config").constants.USER_ROLE,
		content = string.format("#{buffer}%s", line_ref),
	})
	chat.ui:open()
	if chat.ui and chat.ui.winnr and vim.api.nvim_win_is_valid(chat.ui.winnr) then
		vim.api.nvim_set_current_win(chat.ui.winnr)
	end
end, { desc = "[S]end buffer to Companion" })
map("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "[C]ompanion toggle" })
map("n", "<leader>al", "<cmd>CodeCompanionAction list<CR>", { desc = "[L]ist Companions" })

-- Helper: find and close the chat buffer, kill gigacode --acp process
local function close_chat_and_kill_acp()
	-- Close the CodeCompanion chat buffer if open
	local chat = require("codecompanion").last_chat()
	if chat and chat.bufnr and vim.api.nvim_buf_is_valid(chat.bufnr) then
		local win = vim.fn.bufwinid(chat.bufnr)
		if win ~= -1 then
			vim.api.nvim_win_close(win, true)
		end
		vim.api.nvim_buf_delete(chat.bufnr, { force = true })
	end

	-- Kill gigacode --acp process
	pcall(vim.fn.system, "pkill -f 'gigacode.*--acp'")
	vim.notify("Chat closed, ACP process stopped", vim.log.levels.INFO)
end

-- Override <C-q> to also kill the process
map("n", "<C-q>", close_chat_and_kill_acp, { desc = "Close Chat & stop ACP" })
map("n", "<leader>ad", close_chat_and_kill_acp, { desc = "[D]ismiss Chat & stop ACP" })

vim.g.codecompanion_status = { active = false }
local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd("User", {
	pattern = "CodeCompanionRequestStarted",
	group = group,
	callback = function(e)
		vim.g.codecompanion_status = {
			active = true,
			adapter = e.data.adapter.formatted_name,
			message = "Thinking...",
		}
		vim.cmd("redrawstatus")
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "CodeCompanionRequestFinished",
	group = group,
	callback = function(e)
		vim.g.codecompanion_status = {
			active = true,
			message = e.data.status == "success" and "Done" or "Failed",
		}
		vim.cmd("redrawstatus")
		-- Clear after a short delay so the user can see the result
		vim.defer_fn(function()
			vim.g.codecompanion_status.active = false
			vim.cmd("redrawstatus")
		end, 2000)
	end,
})
