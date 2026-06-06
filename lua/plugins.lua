vim.pack.add({
  {
    src = "/Users/23603840/.config/nvim/plugins/nvim-web-devicons",
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/nvim-treesitter',
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/nvim-treesitter-context',
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/which-key.nvim',
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/snacks.nvim'
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/tiny-inline-diagnostic.nvim'
  },
  {
    src = '/Users/23603840/.config/nvim/plugins/goplements.nvim'
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/lualine.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/git-blame.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/conform.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/barbar.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/gitsigns.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/nui.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/plenary.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/neo-tree.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/vim-dadbod",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/vim-dadbod-ui",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/fidget.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/codecompanion.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/nvim-notify",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/diffview.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/neogit",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/time-machine.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/blink.lib",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/blink.pairs",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/blink.cmp",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/nvim-navic",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/barbecue.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/guess-indent.nvim",
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/render-markdown.nvim"
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/jqscratch.nvim"
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/csvview.nvim"
  },
  {
    src = "/Users/23603840/.config/nvim/plugins/grpc-ui.nvim"
  },
  -- {
  --   src = "/Users/23603840/.config/nvim/plugins/smolpilot.nvim"
  -- },
})

require('treesitter').init()
require('ui').init()
require('neotree').init()
require('git').init()
require('underbar').init()
require('preview').init()

require("snacks").setup({
  toggle = {
    which_key = true,
  },

  picker = {
    layout = {
      preset = "vscode",
      preview = "main",
      layout = {
        border = "rounded",
      },
    },
  },

  indent = {
    enabled = true,

    animate = {
      enabled = false,
    },

    indent = {
      enabled = true,
      only_current = false,
      only_scope = false,
    },

    scope = {
      enabled = true,
      only_current = true,
    },

    chunk = {
      enabled = false,
    },

    filter = function(buf)
      return vim.g.snacks_indent ~= false
        and vim.b[buf].snacks_indent ~= false
        and vim.bo[buf].buftype == ""
        and vim.bo[buf].filetype ~= "markdown"
        and vim.bo[buf].filetype ~= "dbout"
    end,
  },
})

local picker = require("snacks.picker")

map("n", "<leader>fI", function()
  picker.lsp_implementations()
end, {
  desc = "[I]mplementations",
})

map("n", "<leader>fR", function()
  picker.lsp_references()
end, {
  desc = "[R]eferences",
})

map("n", "<leader>fd", function()
  picker.diagnostics_buffer()
end, {
  desc = "[D]iagnostics (buffer)",
})

map("n", "<leader>fD", function()
  picker.diagnostics()
end, {
  desc = "[D]iagnostics (all)",
})

map("n", "<leader>ff", function()
  picker.files()
end, {
  desc = "[F]iles",
})

map("n", "<leader>fg", function()
  picker.grep()
end, {
  desc = "[G]rep",
})

map("n", "<leader>fb", function()
  picker.buffers()
end, {
  desc = "[B]uffers",
})

map("n", "<leader>fs", function()
  picker.lsp_symbols()
end, {
  desc = "[S]ymbols (buffer)",
})

map("n", "<leader>fS", function()
  picker.lsp_workspace_symbols()
end, {
  desc = "[S]ymbols (all)",
})

map("n", "gd", function()
  picker.lsp_definitions()
end, {
  desc = "[G]oto [D]efinition",
})


-- ======================
-- conform (formatter)
-- ======================
require("conform").setup({
  formatters_by_ft = {
    go = { "gofmt", "goimports" },
  },

  formatters = {
    gofmt = {
      command = "gofmt",
      args = { "-r", "interface{} -> any" },
    },
    goimports = {
      command = "goimports",
      args = {
        "-local", "api.sc-ci.sber.ru,stash.sigma.sbrf.ru,stash.delta.sbrf.ru",
      },
    },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
})

vim.diagnostic.config({
  virtual_text = false,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})


-- ======================
-- barbar (bufferline)
-- ======================
vim.g.barbar_auto_setup = false

require("barbar").setup({
  sidebar_filetypes = {
  	["neo-tree"] = {event = "BufWipeout"},
  },
  animation = false,
  highlight_alternate = false,
  icons = {
    filetype = { enabled = true, custom_colors = false },
    preset = "default",
    separator_at_end = false,
    current = {
      separator = { left = "", right = "" },
    },
    inactive = {
      separator = { left = "", right = "" },
    },
  },
  highlight_inactive_file_icons = true,
})


-- ======================
-- time-machine (file history / undo tree)
-- ======================
require("time-machine").setup({
  split_opts = {
    split = "left",
    width = 50,
  },
})


-- ======================
-- Sidebar panel manager (replaces edgy)
-- ======================
-- Each panel has a uniquely-named buffer created once at startup.
-- Toggle a panel to hide/reveal its window. The buffer persists via
-- bufhidden=hide, so content is never lost when the window is closed.

local sidebar = {}
sidebar.width = 50
sidebar.last = "files"

-- Create named placeholder buffers (once) ─────────────────────────
sidebar.bufs = {}
for _, key in ipairs({ "files", "database", "history" }) do
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "sidebar://" .. key)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  sidebar.bufs[key] = buf
end

-- Helpers ─────────────────────────────────────────────────────────

---Find a window by filetype.
local function find_win(ft)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == ft then
      return w
    end
  end
end

---Move a window to the left sidebar position and set its width.
local function move_to_sidebar(win)
  vim.api.nvim_win_call(win, function()
    vim.cmd("wincmd H")
  end)
  vim.api.nvim_win_set_width(win, sidebar.width)
end

---Update barbar tabline offset from visible sidebar windows.
local function update_offset()
  local total = 0
  for _, p in pairs(sidebar.panels) do
    local w = find_win(p.ft)
    if w then total = total + vim.api.nvim_win_get_width(w) end
  end
  require("barbar.api").set_offset(total)
end

-- Panel definitions ───────────────────────────────────────────────
sidebar.panels = {
  files = {
    ft = "neo-tree",
    open = function()
      require("neo-tree.command").execute({ action = "focus", source = "filesystem" })
    end,
    close = function()
      pcall(vim.cmd, "Neotree close")
    end,
  },
  database = {
    ft = "dbui",
    open = function()
      vim.cmd("DBUI")
      local w = find_win("dbui")
      if w then move_to_sidebar(w) end
    end,
  },
  history = {
    ft = "time-machine-list",
    open = function()
      vim.cmd("TimeMachineToggle")
      local w = find_win("time-machine-list")
      if w then move_to_sidebar(w) end
    end,
  },
  grpc = {
    ft = "grpcui",
    open = function()
      require('grpc-ui').open()
      local w = find_win("grpcui")
      if w then move_to_sidebar(w) end
    end,
    close = function()
      require("grpc-ui").close()
    end
  },
}

---Close all sidebar panel windows.
function sidebar.close_all()
  for _, p in pairs(sidebar.panels) do
    if p.close then p.close() end
  end
  -- Catch any remaining windows (plugins without a close command)
  for _, p in pairs(sidebar.panels) do
    local w = find_win(p.ft)
    if w then pcall(vim.api.nvim_win_close, w, true) end
  end
  update_offset()
end

---Toggle a single panel: hide if visible, reveal if hidden.
function sidebar.toggle(key)
  local panel = sidebar.panels[key]
  if not panel then return end

  local w = find_win(panel.ft)
  if w then
    -- Hide
    if panel.close then panel.close()
    else pcall(vim.api.nvim_win_close, w, true) end
    update_offset()
  else
    -- Reveal — close others first so only one panel is visible
    sidebar.close_all()
    panel.open()
    sidebar.last = key
    vim.schedule(update_offset)
  end
end

---Toggle the entire sidebar: hide if any panel is visible, reveal last active.
function sidebar.toggle_all()
  local any = false
  for _, p in pairs(sidebar.panels) do
    if find_win(p.ft) then any = true break end
  end
  if any then
    sidebar.close_all()
  else
    sidebar.toggle(sidebar.last)
  end
end

map("n", "<leader>ee", function()
  sidebar.toggle("files")
end, { desc = "[E]xplorer" })

map("n", "<leader>ed", function()
  sidebar.toggle("database")
end, { desc = "[D]B-UI" })

map("n", "<leader>eu", function()
  sidebar.toggle("history")
end, { desc = "[U]ndo tree" })

map("n", "<leader>eg", function()
  sidebar.toggle("grpc")
end, { desc = "[g]RPC-UI"})

map("n", "<leader>eh", function()
  sidebar.toggle_all()
end, { desc = "[H]ide/reveal" })

require("dadbod-timer").setup()

require("fidget").setup({
  progress = {
    display = {
      group_style = 'FidgetLSPName',
    },
  },
  notification = {
    window = {
      normal_hl = 'FidgetText',
      winblend = 0,
      border = 'rounded',
    },
  },
})

vim.notify = require("notify")
require("notify").setup({
  background_colour = "#1e1e1e",
})


-- ============================
-- codecompanion (AI Assistant)
-- ============================
require("codecompanion").setup({
  display = {
    chat = {
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
      adapter = "gigacode",
    },
    inline = {
      adapter = "gigacode",
    },
    cmd = {
      adapter = "gigacode",
    }
  },
  adapters = {
    acp = {
      opts = {
        show_presets = false,
      },
      gigacode = function()
        return require("codecompanion.adapters.acp").extend("gemini_cli", {
          commands = {
            default = {
              "gigacode", "--acp",
            },
          },
          handlers = {
            auth = function(self)
              return true
            end,
          },
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

map("v", "<leader>as", "<cmd>CodeCompanionChat Add<CR>", { desc = "[S]end selection to Companion" })
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
end, { desc = "[S]end buffer to Companion" })
map("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "[C]ompanion toggle" })
map("n", "<leader>al", "<cmd>CodeCompanionAction list<CR>", { desc = "[L]ist Companions" })
map("n", "<C-q>", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Hide Chat" })


local progress = require("fidget.progress")
local handlers = {}
local group = vim.api.nvim_create_augroup("CodeCompanionFidget", {})

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionRequestStarted",
  group = group,
  callback = function(e)
    handlers[e.data.id] = progress.handle.create({
      title = "CodeCompanion",
      message = "Thinking...",
      lsp_client = {name = e.data.adapter.formatted_name},
    })
  end
})

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionRequestFinished",
  group = group,
  callback = function(e)
    local h = handlers[e.data.id]
    if h then
      h.message = e.data.status == "success" and "Done" or "Failed"
      h:finish()
      handlers[e.data.id] = nil
    end
  end
})

map("n", "<leader>tt", function()
  require("snacks").terminal.focus(nil, {
    win = { position = "right" },
    env = vim.v.count1 > 1 and { SNACKS_TERM = tostring(vim.v.count1) } or nil,
    count = vim.v.count1 > 1 and vim.v.count1 or nil,
    keys = {
      term_normal = {
        "<esc>",
        function(self)
          self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
          if self.esc_timer:is_active() then
            self.esc_timer:stop()
            vim.cmd("stopinsert")
          else
            self.esc_timer:start(200, 0, function() end)
            return "<esc>"
          end
        end,
        mode = "t",
        expr = true,
        desc = "Double escape to normal mode",
      },
    },
  })
end, { desc = "[T]erminal (shell) (count = new)" })

-- List and switch between all running terminals
map("n", "<leader>tl", function()
  local term_m = require("snacks").terminal
  local terms = term_m.list()
  if #terms == 0 then
    vim.notify("No terminals running", vim.log.levels.INFO)
    return
  end
  local items = {}
  for _, term in ipairs(terms) do
    local title = vim.b[term.buf].term_title or "terminal"
    table.insert(items, { term = term, label = title .. " [" .. term.buf .. "]" })
  end
  vim.ui.select(items, {
    prompt = "Terminals:",
    format_item = function(item) return item.label end,
  }, function(choice)
    if choice then
      choice.term:show():focus()
    end
  end)
end, { desc = "[L]ist terminals" })


require('blink.pairs').build():pwait()
require("blink.pairs").setup({
	highlights = {
		matchparen = { enabled = true },
		groups = { "BlinkPairsWhite", "BlinkPairsPurple", "BlinkPairsBlue" },
	},
})

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
				min_keyword_length = 3,
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

	snippets = { preset = "default" },

	fuzzy = {
		implementation = "rust",
		sorts = { "label", "kind", "score" },
	},

	signature = {
		enabled = false,
	},
})

require('barbecue').setup({
  exclude_filetypes = { 'txt', 'terminal', 'netrw', 'toggleterm', 'snacks_picker_list', 'neo-tree', 'sql', 'dbout', 'jq', 'yq'},
  theme = {
    normal = { bg = '#2D2D2D', bold = false },
  },
  create_autocmd = true,
})

-- vim.api.nvim_create_autocmd({
--   'WinScrolled',
--   'BufWinEnter',
--   'CursorHold',
--   'InsertLeave',
--
--   -- include this if you have set `show_modified` to `true`
--   -- 'BufModifiedSet',
-- }, {
--   group = vim.api.nvim_create_augroup('barbecue.updater', {}),
--   callback = function()
--     require('barbecue.ui').update()
--   end,
-- })

require('guess-indent').setup({})
