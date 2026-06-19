map("n", "<leader>cto", function()
	local current = vim.api.nvim_buf_get_name(0)
	if current == "" then
		vim.notify("Current buffer has no file name", vim.log.levels.WARN)
		return
	end
	local target
	if current:match("_test%.go$") then
		target = current:gsub("_test%.go$", ".go")
	elseif current:match("%.go$") then
		target = current:gsub("%.go$", "_test.go")
	else
		vim.notify("Not a Go file", vim.log.levels.WARN)
		return
	end

	vim.cmd.split(target)
end, {desc = "[O]pen test file"})

local function make_or_go(modifier, args)
	local makefiles = { "Makefile", "makefile", "GNUmakefile" }
	for _, mf in ipairs(makefiles) do
		local path = vim.fn.findfile(mf, ".;")
		if path ~= "" then
			for line in io.lines(path) do
				if line:match("^" .. modifier .. ":") then
					return "make " .. modifier
				end
			end
		end
	end
	return nil
end

local function run_in_split(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_name(buf, "GoOutput")
	vim.cmd("belowright 15sp")
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)

	local lines = {}
	local stderr_data = {}

	vim.fn.jobstart(vim.split(cmd, " "), {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					table.insert(lines, line)
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					table.insert(stderr_data, line)
				end
			end
		end,
		on_exit = function()
			local all = {}
			for _, l in ipairs(lines) do
				table.insert(all, l)
			end
			for _, l in ipairs(stderr_data) do
				table.insert(all, l)
			end
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, all)
			vim.api.nvim_buf_set_option(buf, "modifiable", false)
			vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bdelete<CR>", { noremap = true, silent = true })
		end,
	})
end

local function notify_and_run(cmd)
	vim.notify("Running: " .. cmd, vim.log.levels.INFO)
	vim.fn.jobstart(vim.split(cmd, " "), {
		on_exit = function(_, code)
			if code == 0 then
				vim.notify("Build succeeded", vim.log.levels.INFO)
			else
				vim.notify("Build failed with exit code " .. code, vim.log.levels.ERROR)
			end
		end,
	})
end

local function resolve_main()
	local main_go = vim.fn.findfile("main.go", ".;")
	if main_go == "" then
		main_go = vim.fn.findfile("main.go", vim.fn.getcwd() .. "/**")
	end
	return main_go
end

vim.api.nvim_create_user_command("GoBuild", function(opts)
	local cmd = make_or_go("build", opts.args)
	if not cmd then
		if opts.args and opts.args ~= "" then
			cmd = "go build " .. opts.args
		else
			local main_go = resolve_main()
			if main_go == "" then
				vim.notify("main.go not found and no Makefile build target. Provide args like :GoBuild -o output main.go", vim.log.levels.WARN)
				return
			end
			local main_rel = vim.fn.fnamemodify(main_go, ":.")
			cmd = "go build -o build/app " .. main_rel
		end
	end
	notify_and_run(cmd)
end, { nargs = "?", desc = "Build Go project (tries Makefile, falls back to go build)" })

vim.api.nvim_create_user_command("GoRun", function(opts)
	local cmd = make_or_go("run", opts.args)
	if not cmd then
		if opts.args and opts.args ~= "" then
			cmd = "go run " .. opts.args
		else
			local main_go = resolve_main()
			if main_go == "" then
				vim.notify("main.go not found and no Makefile run target. Provide args like :GoRun main.go", vim.log.levels.WARN)
				return
			end
			local main_rel = vim.fn.fnamemodify(main_go, ":.")
			cmd = "go run " .. main_rel
		end
	end
	run_in_split(cmd)
end, { nargs = "?", desc = "Run Go project (tries Makefile, falls back to go run)" })

map("n", "<leader>om", function()
	local go_mod = vim.fn.findfile("go.mod", ".;")
	if go_mod == "" then
		vim.notify("go.mod not found in project", vim.log.levels.WARN)
		return
	end
	vim.cmd.edit(vim.fn.fnamemodify(go_mod, ":p"))
end, {desc = "go.[m]od"})

map("n", "<leader>cb", "<cmd>GoBuild<CR>", {desc = "[B]uild"})
map("n", "<leader>cr", "<cmd>GoRun<CR>", {desc = "[R]un"})

