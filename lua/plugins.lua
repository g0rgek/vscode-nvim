vim.pack.add({
  {
    src = '~/.config/nvim/plugins/nvim-treesitter',
  },
  {
    src = '~/.config/nvim/plugins/which-key.nvim',
  },
  {
    src = '~/.config/nvim/plugins/snacks.nvim'
  },
  {
    src = '~/.config/nvim/plugins/tiny-inline-diagnostic.nvim'
  },
  {
    src = '~/.config/nvim/plugins/goplements.nvim'
  },
  {
    src = "~/.config/nvim/plugins/lualine.nvim",
  },
  {
    src = "~/.config/nvim/plugins/nvim-web-devicons",
  },
  {
    src = "~/.config/nvim/plugins/git-blame.nvim",
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
    { '<leader>pt', group = '[T]ypst' },
    { '<leader>pm', group = '[M]arkdown' },
    { '<leader>ps', group = '[S]trudel' },
    { '<leader>pc', group = '[C]SV' },
    { '<leader>p', group = '[P]review' },
    { '<leader>b', group = '[B]uffer' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>f', group = '[F]ind' },
    { '<leader>u', group = '[U]i' },
    { '<leader>g', group = '[G]it' },
    { '<leader>t', group = '[T]erminal' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
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


vim.g.gitblame_display_virtual_text = 0

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
    icons_enabled = false,
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




vim.diagnostic.config({
  virtual_text = false,
})



