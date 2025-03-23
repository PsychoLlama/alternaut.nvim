local M = {}
local log = require('alternaut._log')

--- User-defined config for the plugin.
---
--- @class alternaut.Config
--- @field conventions table<string, alternaut.Convention>
---
--- @class alternaut.Convention
--- @field directory_naming_conventions string[]
--- @field file_naming_conventions string[]
--- @field file_extensions string[]
local config = {}

--- Update the user-defined config. May be called multiple times.
--- This function is responsible for normalizing the config before saving it.
function M.set_config(new_config)
  if new_config == nil then
    log.error('Config must be a table.')
    return
  end

  -- We're about to mutate stuff.
  new_config = vim.deepcopy(new_config)
  new_config.conventions = new_config.conventions or {}

  config = new_config
end

--- Get the current user-defined config. Value is stable, meaning it won't
--- change if the user updates the config at a later time.
function M.get_config()
  return config
end

return M
