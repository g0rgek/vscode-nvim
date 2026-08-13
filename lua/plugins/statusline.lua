-- Thin wrapper: core/statusline exports M.version() via _G.core_statusline
local M = {}

function M.version()
	return _G.core_statusline.version()
end

return M
