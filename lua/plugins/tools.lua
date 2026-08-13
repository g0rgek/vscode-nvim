local M = {}

function M.productivity()
	-- Native file operations (replaces nvim-genghis)
	vim.keymap.set("n", "<leader>Fr", function()
		local old = vim.fn.expand("%:p")
		local old_rel = vim.fn.expand("%:t")
		vim.ui.input({ prompt = "Rename to: ", default = old_rel }, function(new_name)
			if not new_name or new_name == "" or new_name == old_rel then
				return
			end
			local new_path = vim.fn.expand("%:p:h") .. "/" .. new_name
			if vim.fn.rename(old, new_path) == 0 then
				vim.cmd("edit " .. vim.fn.fnameescape(new_path))
				vim.notify("Renamed to " .. new_name, vim.log.levels.INFO)
			else
				vim.notify("Rename failed: " .. new_path, vim.log.levels.ERROR)
			end
		end)
	end, { desc = "[R]ename" })

	vim.keymap.set("n", "<leader>Fd", function()
		local src = vim.fn.expand("%:p")
		local base = vim.fn.expand("%:t:r")
		local ext = vim.fn.expand("%:e")
		local default = base .. "-copy" .. (ext ~= "" and "." .. ext or "")
		vim.ui.input({ prompt = "Duplicate as: ", default = default }, function(new_name)
			if not new_name or new_name == "" then
				return
			end
			local dest = vim.fn.expand("%:p:h") .. "/" .. new_name
			local ok, err = vim.uv.fs_copyfile(src, dest)
			if ok then
				vim.cmd("edit " .. vim.fn.fnameescape(dest))
				vim.notify("Duplicated to " .. new_name, vim.log.levels.INFO)
			else
				vim.notify("Duplicate failed: " .. tostring(err), vim.log.levels.ERROR)
			end
		end)
	end, { desc = "[D]uplicate" })

	vim.keymap.set("n", "<leader>Fn", function()
		local dir = vim.fn.expand("%:p:h")
		vim.ui.input({ prompt = "New file: ", default = dir .. "/" }, function(path)
			if not path or path == "" then
				return
			end
			vim.cmd("edit " .. vim.fn.fnameescape(path))
		end)
	end, { desc = "[N]ew" })

	vim.keymap.set("n", "<leader>Fm", function()
		local old = vim.fn.expand("%:p")
		vim.ui.input({ prompt = "Move/rename to: ", default = old }, function(new_path)
			if not new_path or new_path == "" or new_path == old then
				return
			end
			-- Create parent directories if needed
			local dir = vim.fn.fnamemodify(new_path, ":h")
			vim.fn.mkdir(dir, "p")
			if vim.fn.rename(old, new_path) == 0 then
				vim.cmd("edit " .. vim.fn.fnameescape(new_path))
				vim.notify("Moved to " .. new_path, vim.log.levels.INFO)
			else
				vim.notify("Move failed: " .. new_path, vim.log.levels.ERROR)
			end
		end)
	end, { desc = "[M]ove & rename" })

	vim.keymap.set("n", "<leader>Fc", function()
		local path = vim.fn.expand("%:p")
		vim.fn.setreg("+", path)
		vim.notify("Copied: " .. path, vim.log.levels.INFO)
	end, { desc = "[C]opy path" })

	-- Native session management (replaces persistence.nvim)
	local session_dir = vim.g._native_session_dir or (vim.fn.stdpath("data") .. "/sessions")

	vim.keymap.set("n", "<leader>ss", function()
		local f = session_dir .. "/last.vim"
		vim.fn.mkdir(session_dir, "p")
		vim.cmd("mksession! " .. vim.fn.fnameescape(f))
		vim.notify("Session saved", vim.log.levels.INFO)
	end, { desc = "[S]ave" })

	vim.keymap.set("n", "<leader>sr", function()
		local f = session_dir .. "/last.vim"
		if vim.fn.filereadable(f) == 1 then
			vim.cmd("source " .. vim.fn.fnameescape(f))
			vim.notify("Session restored", vim.log.levels.INFO)
		else
			vim.notify("No saved session found", vim.log.levels.WARN)
		end
	end, { desc = "[R]estore" })

	vim.keymap.set("n", "<leader>ud", function()
		if vim.g._session_disable then
			vim.g._session_disable()
		end
	end, { desc = "[U]tility session [D]on't save" })
end

return M
