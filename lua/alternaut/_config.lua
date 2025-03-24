local M = {}
local log = require('alternaut._log')

--- @type alternaut.Config
local config = {
  modes = {},
  modes_by_ft = {},
}

--- Update the user-defined config. May be called multiple times.
--- This function is responsible for normalizing the config before saving it.
--- @param new_config? alternaut.UserConfig
function M.set_config(new_config)
  new_config = vim.deepcopy(new_config or {})

  -- Normalize top-level fields.
  new_config.modes = new_config.modes or {}
  new_config.modes_by_ft = new_config.modes_by_ft or {}

  local trim_file_extension = function(ext)
    if ext:sub(1, 1) == '.' then
      return ext:sub(2)
    end

    return ext
  end

  -- Normalize providers.
  for mode, providers in pairs(new_config.modes) do
    for provider_name, provider in pairs(providers) do
      local ident = mode .. '.' .. provider_name

      -- Default to searching sibling files.
      provider.directories = provider.directories or { '.' }

      if
        provider.extensions == nil
        or vim.tbl_isempty(provider.extensions)
      then
        log.error('Provider "' .. ident .. '" must define `extensions`.')
        return
      end

      -- Normalize extensions.
      if vim.islist(provider.extensions) then
        provider.extensions = {
          target = provider.extensions,
          origin = provider.extensions,
        }
      end

      -- Trim leading `.` from extensions.
      provider.extensions = {
        target = vim.tbl_map(trim_file_extension, provider.extensions.target),
        origin = vim.tbl_map(trim_file_extension, provider.extensions.origin),
      }
    end
  end

  config = new_config
end

--- Get the current user-defined config. Value is stable, meaning it won't
--- change if the user updates the config at a later time.
--- @return alternaut.Config
function M.get_config()
  return config
end

return M

--- User-defined config for the plugin.
--- @class alternaut.UserConfig
---
--- "Modes" are the different types of things you can swap between, such as
--- tests, CSS files, templates, etc. Each mode contains a set of providers.
--- @field modes? table<string, table<string, alternaut.UserConfig.Provider>>
---
--- "Modes by file type" declares what modes and providers are supported for
--- a given file type.
--- @field modes_by_ft? table<string, string[]>

--- A provider defines exactly how a source file relates to a target file.
--- Providers are defined within "modes". For example, saying a `.css` file is
--- co-located with an `.html` file is a provider. You could define another
--- provider for `.less` files, and another for `.scss`. All would live in
--- a `style` mode that knows how to resolve any type of style-related assets.
--- @class alternaut.UserConfig.Provider
---
--- A pattern defines how a source file's name relates to a target file's
--- name. For example, a test file might always end in `{name}_spec.py`.
--- Patterns have access to the following variables:
---
--- - `{name}`: The name of the source file, without the extension.
--- - `{ext}`: The extension of the source file.
---
--- There can be many patterns. Each permutation is searched in the order it
--- is defined.
--- @field patterns string[]
---
--- Possible file extensions. If this is a list of strings, it's assumed that
--- the source and target files share the same extensions.
--- @field extensions string[] | alternaut.UserConfig.Extensions
---
--- Directories searched while resolving target files. This defaults to the
--- current directory. If you override it, you may want to explicitly include
--- the current directory (`./`).
--- @field directories? string[]
---
--- Possible file extensions, both for the target file and the source file.
--- Alternaut needs the source file extensions in order to navigate back. Note
--- that the leading `.` is inferred and optional.
--- @class alternaut.UserConfig.Extensions
---
--- All possible file extensions for the target file. For example, `.ts` and
--- `.tsx` might both be valid extensions for a unit test. These are searched
--- in the order they are defined.
--- @field target string[]
---
--- All possible file extensions for the source file. Depending on the
--- language or tool, these might be different from the target file. This
--- allows Alternaut to navigate back to the source file.
--- @field origin string[]

--- Normalized user `extensions` config.
--- @alias alternaut.Extensions alternaut.UserConfig.Extensions

--- Normalized user config.
--- @class alternaut.Config
--- @field modes table<string, table<string, alternaut.Provider>>
--- @field modes_by_ft table<string, string[]>

--- Normalized user provider.
--- @class alternaut.Provider
--- @field patterns string[]
--- @field directories string[]
--- @field extensions alternaut.Extensions
