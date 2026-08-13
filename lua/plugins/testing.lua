require("neotest").setup({
	diagnostic = {
		severity = vim.diagnostic.severity.ERROR,
	},
	adapters = {
		require("neotest-golang")({
			runner = "gotestsum",
			warn_test_name_dupes = false,
			testify_enabled = true,
			show_testpath_error = false,
			env = { TEST_POSTGRES_URL = "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable" },
		}),
		require("neotest-python")({
			-- Extra arguments for nvim-dap configuration
			-- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
			-- dap = { justMyCode = false },
			-- Command line arguments for runner
			-- Can also be a function to return dynamic values
			args = { "--log-level", "DEBUG" },
			-- Runner to use. Will use pytest if available by default.
			-- Can be a function to return dynamic value.
			runner = "pytest",
			-- Custom python path for the runner.
			-- Can be a string or a list of strings.
			-- Can also be a function to return dynamic value.
			-- If not provided, the path will be inferred by checking for
			-- virtual envs in the local directory and for Pipenev/Poetry configs
			python = ".venv/bin/python",
			-- Returns if a given file path is a test file.
			-- NB: This function is called a lot so don't perform any heavy tasks within it.
			-- is_test_file = function(file_path)
			--   ...
			-- end,
			-- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
			-- instances for files containing a parametrize mark (default: false)
			pytest_discover_instances = true,
		}),
	},
	status = { virtual_text = true, signs = false },
	output = { open_on_run = false, close_on_exit = true },
	quickfix = {
		enabled = true,
		open = function()
			vim.cmd("copen 10")
		end,
	},
	discovery = { enabled = true },
	diagnostic = { enabled = true },
})

-- Force all neotest-golang diagnostic underlines to ERROR (red) instead of HINT (blue)
local ok, diag = pcall(require, "neotest-golang.lib.diagnostics")
if ok then
	diag.is_hint_message = function()
		return false
	end
end

-- Keybinds
vim.keymap.set("n", "<leader>ctn", function()
	require("neotest").run.run()
end, { desc = "Test Nearest" })
vim.keymap.set("n", "<leader>ctf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test File" })
vim.keymap.set("n", "<leader>cts", function()
	require("neotest").summary.toggle()
end, { desc = "Test Summary" })
vim.keymap.set("n", "<leader>ctl", function()
	require("neotest").run.run_last()
end, { desc = "Test Last" })

-- Helper: prompt user for env vars and run tests in current file with those vars.
-- Inherits vim.env so PATH/HOME etc. are preserved.
local function run_test_file_with_env()
	vim.ui.input({ prompt = "ENV vars (KEY=VAL KEY2=VAL2 …): " }, function(input)
		if not input or input == "" then
			require("neotest").run.run(vim.fn.expand("%"))
			return
		end

		local env = vim.deepcopy(vim.env) -- inherit session env
		for token in input:gmatch("%S+") do
			local key, val = token:match("^([^=]+)=(.*)$")
			if key then
				env[key] = val
			else
				vim.notify(
					string.format("neotest-go: skipping malformed token %q (expected KEY=VAL)", token),
					vim.log.levels.WARN
				)
			end
		end

		require("neotest").run.run({
			vim.fn.expand("%"),
			extra_args = { env = env },
		})
	end)
end

vim.keymap.set("n", "<leader>cte", run_test_file_with_env, { desc = "Test File with [E]nv" })

-- Session-scoped env vars (only what user explicitly sets).
-- Persists for all test runs in this nvim session until cleared or changed.
local session_env_vars = {}

local function add_session_env()
	vim.ui.input({ prompt = "Set session ENV (KEY=VAL): " }, function(input)
		if not input or input == "" then
			return
		end
		local key, val = input:match("^([^=]+)=(.*)$")
		if key then
			session_env_vars[key] = val
			vim.notify(string.format("neotest session env: %s=%s", key, val), vim.log.levels.INFO)
		else
			vim.notify(string.format("skipping malformed input %q (expected KEY=VAL)", input), vim.log.levels.WARN)
		end
	end)
end

local function clear_session_env()
	session_env_vars = {}
	vim.notify("neotest session env cleared", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>ctE", add_session_env, { desc = "[E]nvironment var (session-scoped)" })
vim.keymap.set("n", "<leader>ctC", clear_session_env, { desc = "[C]lear session env vars" })

-- Wrap the neotest runner to inject session env vars on every test run.
-- This catches all neotest-golang runspec env resolution.
local neotest_run = require("neotest").run.run
require("neotest").run.run = function(args)
	if type(args) == "table" then
		local extra_args = args.extra_args or {}
		local merged = vim.tbl_extend("keep", extra_args, { env = {} })
		local existing_env = merged.env or {}
		-- Session env overrides anything already set
		merged.env = vim.tbl_extend("force", existing_env, session_env_vars)
		args.extra_args = merged
	end
	neotest_run(args)
end
