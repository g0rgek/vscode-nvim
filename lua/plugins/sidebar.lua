local sidebar = {}
sidebar.width = 82
sidebar.last = "files"

require("time-machine").setup({
  split_opts = {
    split = "left",
    width = 50,
  },
})

require("dbui").setup({
  use_nerd_fonts = true
})

require("grpc-ui").setup({
  short_buffer_names = true
})

local function sort_migrations_by_number(a, b)
  -- directories always come first
  if a.type ~= b.type then
    return a.type < b.type
  end

  local a_name = a.name or a.path or ""
  local b_name = b.name or b.path or ""
  local na = a_name:match("^(%d+)")
  local nb = b_name:match("^(%d+)")

  if na and nb then
    -- both have leading numbers → numeric comparison
    return tonumber(na) < tonumber(nb)
  elseif na then
    -- a has a number, b doesn't → a first
    return true
  elseif nb then
    -- b has a number, a doesn't → b first
    return false
  else
    -- neither has a leading number → case-insensitive alphabetical
    return a_name:lower() < b_name:lower()
  end
end

require('neo-tree').setup({
  auto_clean_after_session_restore = true,
  close_if_last_window = false,
  enable_diagnostics = true,
  enable_git_status = true,
  enable_modified_markers = true,
  enable_refresh_on_write = true,
  popup_border_style = 'rounded',
  sort_case_insensitive = false,
  sort_function = sort_migrations_by_number,
  use_popups_for_input = true,

  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = '│',
      last_indent_marker = '└',
      highlight = 'NeoTreeIndentMarker',
      with_expanders = nil,
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
  },

  filesystem = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    hijack_netrw_behavior = 'open_default',
    use_libuv_file_watcher = true,
    scan_mode = 'shallow',
    filtered_items = {
      visible = false,
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_hidden = true,
      hide_by_name = {
        '.DS_Store', 'thumbs.db', 'node_modules', '.git', '.svn',
        '__pycache__', '.pytest_cache', '.mypy_cache', '.ruff_cache',
        '*.pyc', '*.pyo', '*.pyd', '.Python', 'env', 'venv',
        '.env', '.venv', 'ENV', 'env.bak', 'venv.bak',
      },
      hide_by_pattern = {
        '*/src/*/tsconfig.json',
        '*.tmp',
        '*.temp',
      },
      always_show = {
        '.gitignored',
        '.gitattributes',
        '.github',
        '.ci',
        '.opencode',
        '.agents',
      },
      never_show = {
        '.DS_Store',
        'thumbs.db',
      },
      never_show_by_pattern = {
        '.null-ls_*',
        '*.tmp',
        '.#*',
      },
    },
    bind_to_cwd = true,
    cwd_target = {
      sidebar = 'tab',
      current = 'window',
    },
  },

  buffers = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    group_empty_dirs = true,
    show_unloaded = true,
  },

  window = {
    position = 'left',
    width = sidebar.width,
    auto_expand_width = false,
    popup = {},
  },
})

-- Create named placeholder buffers (once) ─────────────────────────
sidebar.bufs = {}
for _, key in ipairs({"files", "database", "history", "grpc"}) do
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
local function move_to_sidebar(win, w)
  w = w or sidebar.width
  vim.api.nvim_win_call(win, function()
    vim.cmd("wincmd H")
  end)
  vim.api.nvim_win_set_width(win, w)
end

-- Panel definitions ───────────────────────────────────────────────
sidebar.panels = {
  files = {
    ft = "neo-tree",
    width = 40,
    open = function()
      require("neo-tree.command").execute({ action = "focus", source = "filesystem" })
      local w = find_win("neo-tree")
      if w then
        pcall(vim.api.nvim_win_call, w, function()
          vim.cmd("wincmd H")
        end)
        vim.api.nvim_win_set_width(w, sidebar.panels.files.width)
      end
    end,
    close = function()
      pcall(vim.cmd, "Neotree close")
    end,
  },
  database = {
    ft = "dbui",
    width = 82,
    open = function()
      vim.cmd("DBUI")
      local w = find_win("dbui")
      if w then move_to_sidebar(w, sidebar.panels.database.width) end
    end,
  },
  history = {
    ft = "history",
    width = 40,
    open = function()
      vim.cmd("TimeMachineToggle")
      local w = find_win("history")
      if w then move_to_sidebar(w, sidebar.panels.history.width) end
    end,
  },
  grpc = {
    ft = "grpcui",
    width = 82,
    open = function()
      require('grpc-ui').open()
      local w = find_win("grpcui")
      if w then move_to_sidebar(w, sidebar.panels.grpc.width) end
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
  -- update_offset()
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
    -- update_offset()
  else
    -- Reveal — close others first so only one panel is visible
    sidebar.close_all()
    panel.open()
    sidebar.last = key
    -- vim.schedule(update_offset)
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

map("n", "<leader>ef", function()
  sidebar.toggle("files")
end, { desc = "[F]iles" })

map("n", "<leader>ed", function()
  sidebar.toggle("database")
end, { desc = "[D]atabase" })

map("n", "<leader>et", function()
  sidebar.toggle("history")
end, { desc = "[T]ime machine" })

map("n", "<leader>eg", function()
  sidebar.toggle("grpc")
end, { desc = "[G]RPC"})

map("n", "<leader>eh", function()
  sidebar.toggle_all()
end, { desc = "[H]ide/reveal" })
