require("minuet").setup({
	provider = "openai_fim_compatible",
	context_window = 768,
	request_timeout = 5,
	n_completions = 2,
	provider_options = {
		openai_fim_compatible = {
			--          name = 'deepseek',
			--          api_key = function() return "TOKEN" end,
			-- end_point = 'https://deepseek-v4-flash.apps.bacyqfli.k8s.delta.sbrf.ru/v1/completions',
			model = "qwen3.6-27b-fp8",
			end_point = "http://10.3.96.28:10000/v1/completions",
			api_key = function()
				return "TOKEN"
			end,
			name = "Qwen",
			template = {
				prompt = function(ctx_before, ctx_after, opts)
					return ctx_before
				end,
				suffix = false, -- don't send suffix
			},
			optional = {
				max_tokens = 100,
				top_p = 0.9,
				enable_thinking = false,
			},
		},
	},
	enable_predicates = {
		function()
			if vim.g.minuet_enabled == nil then
				vim.g.minuet_enabled = false
			end
			return vim.g.minuet_enabled
		end,
	},
	virtualtext = {
		auto_trigger_ft = { "go" },
		show_on_completion_menu = true,
		keymap = {
			-- accept whole completion
			accept = "<M-a>",
			-- accept one line
			accept_line = "<D-l>",
			-- accept n lines (prompts for number)
			-- e.g. "A-z 2 CR" will accept 2 lines
			accept_n_lines = "<D-z>",
			-- Cycle to prev completion item, or manually invoke completion
			prev = "<D-[>",
			-- Cycle to next completion item, or manually invoke completion
			next = "<D-]>",
			dismiss = "<D-e>",
		},
	},
})

vim.api.nvim_set_hl(0, "MinuetVirtualText", {
	fg = "#606978",
	bg = "NONE",
	italic = true,
})

vim.b.minuet_virtual_text_auto_trigger = true

map("n", "<leader>as", function()
	vim.g.minuet_enabled = not vim.g.minuet_enabled
	vim.notify("AI Suggestions " .. (vim.g.minuet_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "[S]uggestions Toggle" })
