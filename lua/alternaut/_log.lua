local M = {}

local level = vim.log.levels
local PLUGIN_PREFIX = 'alternaut: '

--- Log information
function M.info(msg)
  vim.notify(PLUGIN_PREFIX .. msg, level.INFO)
end

--- Log a warning
function M.warn(msg)
  vim.notify(PLUGIN_PREFIX .. msg, level.WARN)
end

--- Log an error
function M.error(msg)
  vim.notify(PLUGIN_PREFIX .. msg, level.ERROR)
end

return M
