local M = {}

--- Define test/source file patterns by filetype.
--- @param config? alternaut.UserConfig
function M.setup(config)
  require('alternaut._config').set_config(config)
end

return M
