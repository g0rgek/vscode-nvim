vim.pack.add({
  {
    src = "/home/gorgek/.config/nvim/plugins/nvim-web-devicons",
  },
  {
    src = '/home/gorgek/.config/nvim/plugins/nvim-treesitter',
  },
  {
    src = '/home/gorgek/.config/nvim/plugins/nvim-treesitter-context',
  },
  {
    src = '/home/gorgek/.config/nvim/plugins/which-key.nvim',
  },
  {
    src = '/home/gorgek/.config/nvim/plugins/snacks.nvim'
  },
  {
    src = '/home/gorgek/.config/nvim/plugins/tiny-inline-diagnostic.nvim'
  },
  {
    src = '/home/gorgek/.config/nvim/plugins/goplements.nvim'
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/lualine.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/git-blame.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/conform.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/barbar.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/gitsigns.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/edgy.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/nui.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/plenary.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/neo-tree.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/vim-dadbod",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/vim-dadbod-ui",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/fidget.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/claudecode.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/nvim-notify",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/diffview.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/neogit",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/time-machine.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/markview.nvim",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/blink.lib",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/blink.pairs",
  },
  {
    src = "/home/gorgek/.config/nvim/plugins/blink.cmp",
  },
})

require('nvim-treesitter').install {
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "templ",
    "bash",
    "diff",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "python",
    "sql"
}

require("goplements").setup({
  -- optional config (depends on plugin defaults)
})
require('goplements').toggle()

require("which-key").setup({
  preset = 'helix',
  delay = 0,

  win = {
    height = {
      max = math.huge,
    },
  },

  icons = {
    rules = false,
    breadcrumb = ' ',
    separator = '󱦰  ',
    group = '󰹍 ',
  },

  spec = {
    { '<leader>', group = 'Leader' },
    { '<leader>o', group = '[O]pen' },
    { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
    { '<leader>p', group = '[P]review' },
    { '<leader>b', group = '[B]uffer' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>f', group = '[F]ind' },
    { '<leader>u', group = '[U]i' },
    { '<leader>g', group = '[G]it' },
    { '<leader>t', group = '[T]erminal' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>a', group = '[A]I' },
    { '<leader>e', group = '[E]dgy' },
  },
})


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
    end,
  },
})

local picker = require("snacks.picker")

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
  desc = "[A]ction",
})

vim.keymap.set("n", "<leader>fI", function()
  picker.lsp_implementations()
end, {
  desc = "[I]mplementations",
})

vim.keymap.set("n", "<leader>fR", function()
  picker.lsp_references()
end, {
  desc = "[R]eferences",
})

vim.keymap.set("n", "<leader>fd", function()
  picker.diagnostics_buffer()
end, {
  desc = "[D]iagnostics (buffer)",
})

vim.keymap.set("n", "<leader>fD", function()
  picker.diagnostics()
end, {
  desc = "[D]iagnostics (all)",
})

vim.keymap.set({ "n", "x" }, "<leader>gb", function()
  require("snacks").gitbrowse()
end, {
  desc = "[B]rowse",
})

vim.keymap.set("n", "<leader>gg", ":Neogit<cr>", {desc = "[G]it"})
vim.keymap.set("n", "<leader>gl", ":Neogit log<cr>", {desc = "[L]og"})
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<cr>", {desc = "[D]iff"})

vim.keymap.set("n", "<leader>ff", function()
  picker.files()
end, {
  desc = "[F]iles",
})

vim.keymap.set("n", "<leader>fg", function()
  picker.grep()
end, {
  desc = "[G]rep",
})

vim.keymap.set("n", "<leader>fb", function()
  picker.buffers()
end, {
  desc = "[B]uffers",
})

vim.keymap.set("n", "<leader>fs", function()
  picker.lsp_symbols()
end, {
  desc = "[S]ymbols (buffer)",
})

vim.keymap.set("n", "<leader>fS", function()
  picker.lsp_workspace_symbols()
end, {
  desc = "[S]ymbols (all)",
})

vim.keymap.set("n", "gd", function()
  picker.lsp_definitions()
end, {
  desc = "[G]oto [D]efinition",
})


require("tiny-inline-diagnostic").setup({
  options = {
    show_all_diags_on_cursorline = true,

    multilines = {
      enabled = true,
    },

    show_source = {
      enabled = true,
      if_many = false,
    },

    add_messages = true,
  },

  signs = {
    diag = "●",
    arrow = "",
  },
})

require('nvim-web-devicons').setup({
  variant = 'dark',
  color_icons = true,
  default = true,
  override = {
    go = {
      icon = '󰟓',
      color = '#519ABA',
      name = 'Go',
    },
    md = {
      icon = '',
      color = '#519ABA',
      name = 'Md',
    },
  },
})


vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_message_template = '<author> (<date>) <summary>'
vim.g.gitblame_date_format = '%r'

local lualine = require("lualine")
local git_blame = require("gitblame")

-- ======================
-- language version helper
-- ======================
local function lang_version()
  if vim.b.lang_version_cache ~= nil then
    return vim.b.lang_version_cache
  end

  local ft = vim.bo.filetype
  local ver = ""

  if ft == "go" then
    local out = vim.fn.system("go version"):gsub("\n", "")
    ver = out:match("go version%s+go([%d%.]+)") or ""

  elseif ft == "rust" then
    local out = vim.fn.system("rustc --version"):gsub("\n", "")
    ver = out:match("rustc%s+([%w%.%-]+)") or ""

  elseif ft == "c" or ft == "cpp" then
    local out = vim.fn.system("gcc --version | head -n1"):gsub("\n", "")
    ver = out:match("gcc[^%d]*([%d%.]+)") or ""

  elseif ft == "python" then
    local out = vim.fn.system("python --version 2>&1"):gsub("\n", "")
    ver = out:match("Python%s+([%d%.]+)") or ""

    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
      local venv_name = vim.fn.fnamemodify(venv, ":t")
      ver = ver .. " (" .. venv_name .. ")"
    end

  elseif ft == "typst" then
    local out = vim.fn.system("typst -V"):gsub("\n", "")
    ver = out:match("(%d+%.%d+%.%d+)") or ""
  end

  vim.b.lang_version_cache = ver
  return ver
end


-- ======================
-- LSP clients
-- ======================
local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, c in ipairs(clients) do
    table.insert(names, c.name)
  end

  return table.concat(names, ",")
end

-- ======================
-- diagnostics
-- ======================
local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "info", "hint" },
  symbols = {
    error = " ",
    warn = " ",
    info = " ",
    hint = "󰌶 ",
  },
  colored = false,
  update_in_insert = false,
  color = { fg = "#cccccc" },
}

-- ======================
-- lualine setup
-- ======================
lualine.setup({
  options = {
    section_separators = "",
    component_separators = "",
    icons_enabled = true,
    globalstatus = true,

    disabled_filetypes = {
      statusline = { "NvimTree", "toggleterm", "terminal" },
      winbar = { "toggleterm", "terminal" },
    },
  },

  sections = {
    lualine_a = { { "mode" } },

    lualine_b = {
      {
        "branch",
        icon = "",
        color = { fg = "#cccccc" },
      },
      diagnostics,
    },

    lualine_c = {},

    lualine_x = {
      {
        git_blame.get_current_blame_text,
        cond = git_blame.is_blame_text_available,
        color = { fg = "#cccccc" },
      },
    },

    lualine_y = {
      {
        function()
          return string.format(
            "Ln %d, Col %d",
            vim.fn.line("."),
            vim.fn.col(".")
          )
        end,
        color = { fg = "#cccccc" },
      },

      { "encoding", color = { fg = "#cccccc" } },
      { lsp_clients, color = { fg = "#cccccc" } },
      { "filetype", color = { fg = "#cccccc" } },
      { lang_version, color = { fg = "#cccccc" } },
    },

    lualine_z = {},
  },
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

vim.keymap.set("n", "<leader>]", "<cmd>BufferNext<CR>",     { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>[", "<cmd>BufferPrevious<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>BufferClose<CR>",   { desc = "[C]lose" })


-- ======================
-- neo-tree (file tree)
-- ======================
require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = false,
  filesystem = {
    follow_current_file = {
      enabled = true,
    },
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = true,
    },
  },
  window = {
    position = "left",
  },
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
-- edgy (sidebar tabs)
-- ======================

local edgy = require("edgy")

edgy.setup({
  left = {
    -- Tab 1: File tree
    {
      title = "󰈙 Files",
      ft = "neo-tree",
      filter = function(buf)
        return vim.b[buf].neo_tree_source == "filesystem"
      end,
      size = { height = 0.40 },
    },
    -- Tab 2: Database client (dadbod)
    {
      title = "󰆼 Database",
      ft = "dbui",
      pinned = true,
      collapsed = true,
      open = "DBUI",
      size = { height = 0.30 },
    },
    -- Tab 3: Time machine (file history / undo tree)
    {
      title = "󰉋 History",
      ft = "time-machine-list",
      pinned = true,
      collapsed = true,
      open = "TimeMachineToggle",
      size = { height = 0.30 },
    },
  },

  options = {
    left = { size = 50 },
  },

  wo = {
    winbar = true,
    winfixwidth = true,
    winfixheight = true,
  },

  animate = {
    enabled = false,
  },

  icons = {
    closed = "󰅀",
    open   = "󰝰",
  },
})


local function focus_edgy_view(ft, fallback_cmd)
  -- If a window with this filetype is already open, focus it
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == ft then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  -- Find the edgy view: use open_pinned() if pinned, otherwise fallback
  local layout = require("edgy.config").layout
  for _, edgebar in pairs(layout) do
    for _, view in ipairs(edgebar.views) do
      if view.ft == ft then
        if view.pinned then
          view.collapsed = false
          view:open_pinned()
        elseif fallback_cmd then
          fallback_cmd()
        end
        return
      end
    end
  end
end

vim.keymap.set("n", "<leader>ee", function()
  focus_edgy_view("neo-tree", function()
    require("neo-tree.command").execute({ action = "focus", source = "filesystem" })
  end)
end, { desc = "[E]xplorer (file tree)" })

vim.keymap.set("n", "<leader>ed", function()
  focus_edgy_view("dbui")
end, { desc = "[D]atabase view" })

vim.keymap.set("n", "<leader>et", function()
  focus_edgy_view("time-machine-list")
end, { desc = "[T]ime machine (file history)" })

vim.keymap.set("n", "<leader>es", function()
  edgy.select("left")
end, { desc = "[S]elect sidebar tab" })

vim.keymap.set("n", "<leader>eh", function()
  -- Check if sidebar is currently open by looking for edgy-managed
  -- sidebar windows, not just any winfixwidth window (snacks.terminal
  -- and other float/term windows also use winfixwidth).
  local sidebar_fts = { "neo-tree", "dbui", "time-machine-list" }
  local sidebar_open = false
  local sidebar_width = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if vim.tbl_contains(sidebar_fts, ft) then
      sidebar_open = true
      sidebar_width = sidebar_width + vim.api.nvim_win_get_width(win)
    end
  end
  if sidebar_open then
    edgy.close("left")
    require("barbar.api").set_offset(0)
  else
    edgy.open("left")
    vim.defer_fn(function()
      require("neo-tree.command").execute({ action = "focus", source = "filesystem" })
      local layout = require("edgy.config").layout
      for _, edgebar in pairs(layout) do
        for _, view in ipairs(edgebar.views) do
          if view.ft == "time-machine-list" then
            view.collapsed = false
            if #view.wins > 0 then
              view.wins[1]:show(true)
            else
              view:open_pinned()
            end
          end
        end
      end
      -- Set barbar tabline offset to sidebar width
      local sidebar_width = 0
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if vim.tbl_contains({ "neo-tree", "dbui", "time-machine-list" }, ft) then
          sidebar_width = sidebar_width + vim.api.nvim_win_get_width(win)
        end
      end
      if sidebar_width > 0 then
        require("barbar.api").set_offset(sidebar_width)
      end
    end, 100)
  end
end, { desc = "[H]ide/reveal sidebar" })

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

-- ======================
-- claudecode (Claude Code AI integration)
-- ======================
require("claudecode").setup({
  terminal_cmd = vim.fn.expand("~/.local/bin/fcc-claude"),
  focus_after_send = true,
})

vim.keymap.set({ "n", "v" }, "<leader>as", "<cmd>ClaudeCodeSend<CR>", { desc = "[S]end to Claude" })

-- Claude Code and OS shell terminals (both on the right side, switchable)
vim.keymap.set("n", "<leader>tc", "<cmd>ClaudeCode<CR>", { desc = "[C]laude Toggle" })

vim.keymap.set("n", "<leader>tf", "<cmd>ClaudeCodeFocus<CR>", { desc = "[F]ocus Claude term" })

vim.keymap.set("n", "<leader>tt", function()
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
vim.keymap.set("n", "<leader>tl", function()
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

require("neogit").setup({
  disable_commit_confirmation = true,
  integrations = {
     diffview = true,
  }
})

require("markview").setup({
    preview = { 
	enable = false,
	icon_provider = "devicons",
	filetypes ={ "markdown", "typst", "yaml", "html"},
    },
    html = {enable = true},
    yaml = {enable = true},
})

vim.api.nvim_set_keymap("n", "<leader>pt", "<CMD>Markview toggle<CR>", { desc = "[T]oggle" })

require("blink.pairs").setup({})

require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
		-- ['<CR>'] = { 'accept', 'fallback' },
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
			auto_show = true,
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

	sources = {
		default = { "lsp", "path", "snippets", "buffer", "markview" },
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
