-- require('blink.cmp').build():pwait()
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},

	appearance = {
		nerd_font_variant = "mono",
		kind_icons = {
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "󰑭",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "󰙅",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "",
		},
	},

	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
				default_brackets = { "(", ")" },
				kind_resolution = { enabled = true },
				semantic_token_resolution = { enabled = true },
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
			window = {
				border = "none",
				winhighlight = "Normal:CmpDocumentation,CursorLine:CmpDocumentationCursorLine,Search:None",
				scrollbar = true,
			},
		},
		menu = {
			border = "none",
			winhighlight = "Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:PmenuSel,Search:None",
			max_height = 15,
			scrolloff = 2,
			scrollbar = true,
			draw = {
				treesitter = { "lsp" },
				columns = {
					{ "kind_icon", "label", gap = 1 },
					{ "label_description", gap = 1 },
					{ "source_name" },
				},
				components = {
					kind_icon = {
						ellipsis = false,
						text = function(ctx)
							return ctx.kind_icon .. " "
						end,
						highlight = function(ctx)
							return "CmpItemKind" .. ctx.kind
						end,
					},
					label = {
						width = { fill = true, max = 60 },
						text = function(ctx)
							return ctx.label .. ctx.label_detail
						end,
						highlight = function(ctx)
							local highlights = {
								nvim_lsp = "CmpItemAbbrMatch",
								buffer = "CmpItemAbbrMatchFuzzy",
								path = "CmpItemAbbrMatchFuzzy",
							}
							return highlights[ctx.source_name] or "CmpItemAbbr"
						end,
					},
					label_description = {
						width = { max = 30 },
						text = function(ctx)
							return ctx.label_description
						end,
						highlight = "CmpItemMenu",
					},
				},
			},
		},
	},
  cmdline = {
    enabled = false,
  },
	sources = {
		default = { "lsp", "snippets", "path", "buffer" },
                providers = {
			lsp = {
				min_keyword_length = 0,
				score_offset = 4,
			},
			snippets = {
				min_keyword_length = 2,
				score_offset = 3,
			},
			path = {
				min_keyword_length = 3,
				score_offset = 2,
			},
			buffer = {
				min_keyword_length = 4,
				score_offset = 1,
			},
		},
		per_filetype = {
			lua = { "lsp", "path", "snippets", "buffer" },
		},
	},

	snippets = { preset = "luasnip" },

	fuzzy = {
		implementation = "rust",
		sorts = { "score", "label", "kind" },
	},

	signature = {
		enabled = false,
	},
})

require("luasnip.loaders.from_vscode").lazy_load()
