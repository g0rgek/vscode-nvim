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
  -- {
  --   src = "/Users/23603840/.config/nvim/plugins/claudecode.nvim",
  -- },
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

require("goplements").setup({})
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
        and vim.bo[buf].filetype ~= "dbout"
    end,
  },
})

local picker = require("snacks.picker")

map("n", "<leader>ca", vim.lsp.buf.code_action, {
  desc = "[A]ction",
})

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

map({ "n", "x" }, "<leader>gb", function()
  require('core.native').gitbrowse()
end, {
  desc = "[B]rowse",
})

map("n", "<leader>gg", ":Neogit<cr>", {desc = "[G]it"})
map("n", "<leader>gl", ":Neogit log<cr>", {desc = "[L]og"})
map("n", "<leader>gd", ":DiffviewOpen<cr>", {desc = "[D]iff"})

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
vim.g.gitblame_message_template = '<author> (<date>)'
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
end, { desc = "[G]RPC-UI"})

map("n", "<leader>eh", function()
  sidebar.toggle_all()
end, { desc = "[H]ide/reveal" })


-- ======================
-- edgy (sidebar tabs)
-- ======================

-- local edgy = require("edgy")
-- edgy.setup({
--   left = {
--     -- Tab 1: File tree
--     {
--       title = "󰈙 Files",
--       ft = "neo-tree",
--       filter = function(buf)
--         return vim.b[buf].neo_tree_source == "filesystem"
--       end,
--       size = { height = 0.40 },
--     },
--     -- Tab 2: Database client (dadbod)
--     -- open() finds/creates the edgy placeholder, clears the BufWinLeave
--     -- autocmd (so enew! doesn't close the window), runs :DBUI which
--     -- reuses the window via the drawer patch (&ft == 'edgy' check),
--     -- then nils pinned_win. The pending FileType → vim.schedule callback
--     -- handles the rest — integrating the dbui window with its winbar.
--     {
--       title = "󰆼 Database",
--       ft = "dbui",
--       pinned = true,
--       collapsed = true,
--       open = function()
--         local edgy_config = require("edgy.config")
--         local dbui_view = nil
--         for _, edgebar in pairs(edgy_config.layout) do
--           for _, view in ipairs(edgebar.views) do
--             if view.ft == "dbui" then dbui_view = view break end
--           end
--         end
--         if not dbui_view then vim.cmd("DBUI") return end
--
--         -- Find or create the placeholder
--         local pw = nil
--         if dbui_view.pinned_win and vim.api.nvim_win_is_valid(dbui_view.pinned_win.win) then
--           pw = dbui_view.pinned_win.win
--         end
--         if not pw then
--           for _, w in ipairs(vim.api.nvim_list_wins()) do
--             local b = vim.api.nvim_win_get_buf(w)
--             if vim.bo[b].filetype == "edgy"
--               and vim.api.nvim_buf_get_name(b):match("Database") then
--               pw = w break
--             end
--           end
--         end
--         if not pw then
--           local any = false
--           for _, w in ipairs(vim.api.nvim_list_wins()) do
--             local f = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
--             if f == "neo-tree" or f == "time-machine-list" or f == "edgy" then
--               any = true break
--             end
--           end
--           if not any then require("edgy").open("left") end
--           dbui_view:show_pinned()
--           require("edgy.layout").layout({ full = true })
--           if dbui_view.pinned_win and vim.api.nvim_win_is_valid(dbui_view.pinned_win.win) then
--             pw = dbui_view.pinned_win.win
--           end
--         end
--
--         if pw then
--           vim.api.nvim_set_current_win(pw)
--           -- Clear BufWinLeave so enew! doesn't close the window
--           pcall(vim.api.nvim_clear_autocmds, {
--             buffer = vim.api.nvim_win_get_buf(pw), event = "BufWinLeave",
--           })
--         end
--         vim.cmd("DBUI")
--
--         -- Release pinned_win. The FileType → vim.schedule(Layout.update)
--         -- will pick up the window (now ft=dbui) and set its winbar.
--         dbui_view.pinned_win = nil
--       end,
--       size = { height = 0.30 },
--     },
--     -- Tab 3: Time machine (file history / undo tree)
--     {
--       title = "󰉋 History",
--       ft = "time-machine-list",
--       pinned = true,
--       collapsed = true,
--       open = "TimeMachineToggle",
--       size = { height = 0.30 },
--     },
--   },
--
--   options = {
--     left = { size = 50 },
--   },
--
--   wo = {
--     winbar = true,
--     winfixwidth = true,
--     winfixheight = true,
--   },
--
--   animate = {
--     enabled = false,
--   },
--
--   icons = {
--     closed = "󰅀",
--     open   = "󰝰",
--   },
-- })

-- edgy.setup({
--   left = {
--     -- Tab 1: File tree
--     {
--       title = "󰈙 Files",
--       ft = "neo-tree",
--       filter = function(buf)
--         return vim.b[buf].neo_tree_source == "filesystem"
--       end,
--       size = { height = 0.40 },
--     },
--     -- Tab 2: Database client (dadbod)
--     {
--       title = "󰆼 Database",
--       ft = "dbui",
--       pinned = true,
--       collapsed = true,
--       open = "DBUI",
--       size = { height = 0.30 },
--     },
--     -- Tab 3: Time machine (file history / undo tree)
--     {
--       title = "󰉋 History",
--       ft = "time-machine-list",
--       pinned = true,
--       collapsed = true,
--       open = "TimeMachineToggle",
--       size = { height = 0.30 },
--     },
--   },

--   options = {
--     left = { size = 50 },
--   },

--   wo = {
--     winbar = true,
--     winfixwidth = true,
--     winfixheight = true,
--   },

--   animate = {
--     enabled = false,
--   },

--   icons = {
--     closed = "󰅀",
--     open   = "󰝰",
--   },
-- })

-- ======================
-- dadbod live query timer
-- ======================
-- Shows a floating elapsed-time counter near the query buffer while executing.
-- Hooks into dadbod's DBExecutePre/DBExecutePost autocommands.
require("dadbod-timer").setup()


-- local function focus_edgy_view(ft, fallback_cmd)
--   -- If a window with this filetype is already open, focus it
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     if vim.bo[buf].filetype == ft then
--       vim.api.nvim_set_current_win(win)
--       return
--     end
--   end
--   -- Find the edgy view: use open_pinned() if pinned, otherwise fallback
--   local layout = require("edgy.config").layout
--   for _, edgebar in pairs(layout) do
--     for _, view in ipairs(edgebar.views) do
--       if view.ft == ft then
--         if view.pinned then
--           view.collapsed = false
--           view:open_pinned()
--         elseif fallback_cmd then
--           fallback_cmd()
--         end
--         return
--       end
--     end
--   end
-- end
--
-- map("n", "<leader>ee", function()
--   focus_edgy_view("neo-tree", function()
--     require("neo-tree.command").execute({ action = "focus", source = "filesystem" })
--   end)
-- end, { desc = "[E]xplorer (file tree)" })
--
-- map("n", "<leader>ed", function()
--   focus_edgy_view("dbui")
-- end, { desc = "[D]atabase view" })
--
-- map("n", "<leader>et", function()
--   focus_edgy_view("time-machine-list")
-- end, { desc = "[T]ime machine (file history)" })
--
-- map("n", "<leader>es", function()
--   edgy.select("left")
-- end, { desc = "[S]elect sidebar tab" })
--
-- map("n", "<leader>eh", function()
--   -- Check if sidebar is currently open by looking for edgy-managed
--   -- sidebar windows, not just any winfixwidth window (snacks.terminal
--   -- and other float/term windows also use winfixwidth).
--   local sidebar_fts = { "neo-tree", "dbui", "time-machine-list" }
--   local sidebar_open = false
--   local sidebar_width = 0
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     local ft = vim.bo[buf].filetype
--     if vim.tbl_contains(sidebar_fts, ft) then
--       sidebar_open = true
--       sidebar_width = sidebar_width + vim.api.nvim_win_get_width(win)
--     end
--   end
--   if sidebar_open then
--     edgy.close("left")
--     require("barbar.api").set_offset(0)
--   else
--     edgy.open("left")
--     vim.defer_fn(function()
--       require("neo-tree.command").execute({ action = "focus", source = "filesystem" })
--       local layout = require("edgy.config").layout
--       for _, edgebar in pairs(layout) do
--         for _, view in ipairs(edgebar.views) do
--           if view.ft == "time-machine-list" then
--             view.collapsed = false
--             if #view.wins > 0 then
--               view.wins[1]:show(true)
--             else
--               view:open_pinned()
--             end
--           end
--         end
--       end
--       -- Set barbar tabline offset to sidebar width
--       local sidebar_width = 0
--       for _, win in ipairs(vim.api.nvim_list_wins()) do
--         local buf = vim.api.nvim_win_get_buf(win)
--         local ft = vim.bo[buf].filetype
--         if vim.tbl_contains({ "neo-tree", "dbui", "time-machine-list" }, ft) then
--           sidebar_width = sidebar_width + vim.api.nvim_win_get_width(win)
--         end
--       end
--       if sidebar_width > 0 then
--         require("barbar.api").set_offset(sidebar_width)
--       end
--     end, 100)
--   end
-- end, { desc = "[H]ide/reveal sidebar" })
--
--
-- map("n", "<leader>ef", function()
--   local w = require("edgy.editor").get_win()
--   if w then
--     w:toggle()
--   else
--     -- Cursor is in the main area; fold the last-active edgy window
--     local layout = require("edgy.config").layout
--     for _, edgebar in pairs(layout) do
--       for _, win in ipairs(edgebar.wins) do
--         if win.visible then
--           win:toggle()
--           return
--         end
--       end
--     end
--   end
-- end, { desc = "[F]old current tab" })


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
-- ======================
-- claudecode (Claude Code AI integration)
-- ======================
-- require("claudecode").setup({
--   refresh_buffers_key = "<leader>br",
--   integration_mode = "simple",  -- Use simple mode for qwencode/gigacode
--   terminal_cmd = vim.fn.expand(""),
--   focus_after_send = true,
-- })
--
-- map({ "n", "v" }, "<leader>as", "<cmd>ClaudeCodeSend<CR>", { desc = "[S]end to Claude" })

-- Claude Code and OS shell terminals (both on the right side, switchable)
-- map("n", "<leader>tc", "<cmd>ClaudeCode<CR>", { desc = "[C]laude Toggle" })
-- map("n", "<leader>tf", "<cmd>ClaudeCodeFocus<CR>", { desc = "[F]ocus Claude term" })

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

require("neogit").setup({
  disable_commit_confirmation = true,
  integrations = {
     diffview = true,
  }
})

require("render-markdown").setup({
  file_types = { 'markdown', 'md', 'codecompanion' },
  render_modes = { 'n', 'c', 't' },
  preset = 'obsidian',
  completions = {
    blink = { enabled = true },
    lsp = { enabled = true },
  },
})

vim.api.nvim_set_keymap("n", "<leader>pm", "<CMD>RenderMarkdown toggle<CR>", { desc = "[M]arkdown" })

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

require('jqscratch').setup({
  ft = "json", "yaml", "yml",
})

map("n", "<leader>pj", function()
  require("jqscratch").toggle()
end, { desc = "[J]son" })

require('csvview').setup({
  ft = "csv", "dbout",
})

map("n", "<leader>pc", '<cmd>CsvViewToggle display_mode=border header_lnum=1<CR>', { desc = "[C]sv" })


