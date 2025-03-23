local M = {}

--- Define test/source file patterns by filetype.
--- @param config alternaut.Config
function M.setup(config)
  require('alternaut._config').set_config(config)
end

return M
