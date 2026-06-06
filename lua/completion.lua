local smolpilot = require("smolpilot")
local ghost_text = require("smolpilot.ghost_text")
local binary_interop = require("smolpilot.binary_interop")

local progress = require("fidget.progress")
local handlers = {}
local group = vim.api.nvim_create_augroup("smolpilot_fidget", {})

-- Отслеживаем начало запроса
vim.api.nvim_create_autocmd("User", {
    pattern = "SmolPilotRequestStarted",
    group = group,
    callback = function(e)
        local id = e.data and e.data.id or "smolpilot"
        handlers[id] = progress.handle.create({
            title = "SmolPilot",
            message = "Generating completion...",
        })
    end,
})

-- Отслеживаем завершение запроса
vim.api.nvim_create_autocmd("User", {
    pattern = "SmolPilotRequestFinished",
    group = group,
    callback = function(e)
        local id = e.data and e.data.id or "smolpilot"
        local h = handlers[id]
        if h then
            h.message = e.data and e.data.status == "success" and "Done" or "Failed"
            h:finish()
            handlers[id] = nil
        end
    end,
})

-- Перехват send_suggest - испускаем событие
local original_send_suggest = binary_interop.send_suggest
local request_id = 0
binary_interop.send_suggest = function(buffer, row, col)
    request_id = request_id + 1
    ghost_text.delete_extmark()

    vim.api.nvim_exec_autocmds("User", {
        pattern = "SmolPilotRequestStarted",
        data = { id = request_id },
    })

    original_send_suggest(buffer, row, col)
end

-- Перехват callback - испускаем событие при ответе
local original_set_callback = binary_interop.set_callback
binary_interop.set_callback = function(callback)
    original_set_callback(function(text)
        vim.api.nvim_exec_autocmds("User", {
            pattern = "SmolPilotRequestFinished",
            data = { status = text and #text > 0 and "success" or "empty" },
        })
        callback(text)
    end)
end

smolpilot.setup({
    endpoint = "https://deepseek-v4-flash.apps.bacyqfli.k8s.delta.sbrf.ru/v1/chat/completions",
    api_type = "openai",
    model = "deepseek-v4-flash",
    api_key = "somekey",
})
