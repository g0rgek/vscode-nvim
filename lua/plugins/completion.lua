require('blink.cmp').build():pwait()
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
		documentation = {
			auto_show = false,
			auto_show_delay_ms = 500,
			window = {
				border = "rounded",
				winhighlight = "Normal:CmpDocumentation,FloatBorder:CmpDocumentationBorder,CursorLine:CmpDocumentationCursorLine,Search:None",
				scrollbar = true,
				max_width = 80,
				max_height = 20,
			},
		},
		menu = {
			border = "rounded",
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
		default = { "snippets", "lsp", "path", "buffer" },
                providers = {
			snippets = {
				min_keyword_length = 2,
				score_offset = 4,
			},
			lsp = {
				min_keyword_length = 1,
				score_offset = 3,
			},
			path = {
				min_keyword_length = 3,
				score_offset = 2,
			},
			buffer = {
				min_keyword_length = 3,
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
		sorts = { "label", "kind", "score" },
	},

	signature = {
		enabled = false,
	},
})

require("luasnip.loaders.from_vscode").lazy_load()
