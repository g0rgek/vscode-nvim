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

