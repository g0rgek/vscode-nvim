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

-- Helper: find and close the chat buffer, kill gigacode --acp process
local function close_chat_and_kill_acp()
  -- Close the CodeCompanion chat buffer if open
  local chat = require("codecompanion").last_chat()
  if chat and chat.bufnr and vim.api.nvim_buf_is_valid(chat.bufnr) then
    local win = vim.fn.bufwinid(chat.bufnr)
    if win ~= -1 then
      vim.api.nvim_win_close(win, true)
    end
    vim.api.nvim_buf_delete(chat.bufnr, { force = true })
  end

  -- Kill gigacode --acp process
  pcall(vim.fn.system, "pkill -f 'gigacode.*--acp'")
  vim.notify("Chat closed, ACP process stopped", vim.log.levels.INFO)
end

-- Override <C-q> to also kill the process
map("n", "<C-q>", close_chat_and_kill_acp, { desc = "Close Chat & stop ACP" })
map("n", "<leader>ad", close_chat_and_kill_acp, { desc = "[D]ismiss Chat & stop ACP" })

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



