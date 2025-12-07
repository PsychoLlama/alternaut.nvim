local M = {}

--- @type alternaut.Config
local config = {
  modes = {},
}

--- Declared config. Normalization is deferred until the first time it's used.
--- @type alternaut.UserConfig|nil
local tentative_config = nil

--- Update the user-defined config. May be called multiple times.
--- Since validation and normalization may be expensive, the cost is deferred
--- until the first time it's used.
--- @param new_config? alternaut.UserConfig
function M.set_config(new_config)
  tentative_config = new_config
end

--- Get the current user-defined config. Value is stable, meaning it won't
--- change if the user updates the config at a later time.
--- @return alternaut.Config
function M.get_config()
  M.apply_tentative_config()

  return config
end

--- Normalize and save the user-defined config if it exists and is valid.
function M.apply_tentative_config()
  if tentative_config == nil then
    return
  end

  local new_config = M.validate_and_normalize(tentative_config)

  if new_config then
    config = new_config
    tentative_config = nil
  end
end

--- Normalize the user-defined config. Returns `nil` if the config is invalid.
--- @param new_config? alternaut.UserConfig
--- @return alternaut.Config|nil
function M.validate_and_normalize(new_config)
  local path = require('alternaut._.path')
  new_config = vim.deepcopy(new_config or {})

  -- Normalize top-level fields.
  new_config.modes = new_config.modes or {}

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

      -- Simplify directory paths as much as possible.
      provider.directories = vim.tbl_map(path.normalize, provider.directories)

      if
        provider.extensions == nil
        or vim.tbl_isempty(provider.extensions)
      then
        require('alternaut._.log').error(
          'Provider "' .. ident .. '" must define `extensions`.'
        )
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

      -- Normalize patterns to always be tables with `template` field.
      provider.patterns = vim.tbl_map(function(pattern)
        if type(pattern) == 'string' then
          return { template = pattern }
        end
        return pattern
      end, provider.patterns or {})
    end
  end

  return new_config --[[@as alternaut.Config]]
end

--- Return the provider(s) associated with a mode. Optionally specify the
--- exact provider name.
---
--- User facing. May log errors.
---
--- @param mode string
--- @param provider_name? string
--- @return nil|alternaut.Provider[]
function M.get_providers(mode, provider_name)
  local cfg = M.get_config()

  if not cfg.modes[mode] then
    require('alternaut._.log').error(
      'Mode ',
      { hi = 'String', msg = mode },
      ' does not exist.'
    )

    return nil
  end

  if provider_name then
    if not cfg.modes[mode][provider_name] then
      require('alternaut._.log').error(
        'Provider ',
        { hi = 'String', msg = mode },
        { hi = 'Comment', msg = '.' },
        { hi = 'String', msg = provider_name },
        ' does not exist.'
      )

      return nil
    end

    return { cfg.modes[mode][provider_name] }
  end

  return vim.tbl_values(cfg.modes[mode])
end

return M

--- User-defined config for the plugin.
--- @class alternaut.UserConfig
---
--- "Modes" are the different types of things you can swap between, such as
--- tests, CSS files, templates, etc. Each mode contains a set of providers.
--- @field modes? table<string, alternaut.Mode>
---
--- Collection of providers.
--- @alias alternaut.Mode table<string, alternaut.UserConfig.Provider>

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
--- is defined. Patterns can be strings (simple) or tables (with transforms).
--- @field patterns (string | alternaut.UserConfig.Pattern)[]
---
--- A pattern with optional casing transforms.
--- @class alternaut.UserConfig.Pattern
--- @field template string The pattern template (e.g., "{name}.{ext}")
--- @field transform? alternaut.UserConfig.Transform Casing transforms for name
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

--- Casing transforms for the {name} variable.
--- @class alternaut.UserConfig.Transform
--- @field origin string Casing of the source file name (e.g., "pascal")
--- @field target string Casing of the target file name (e.g., "kebab")

--- Normalized user `extensions` config.
--- @alias alternaut.Extensions alternaut.UserConfig.Extensions

--- Normalized user config.
--- @class alternaut.Config
--- @field modes table<string, table<string, alternaut.Provider>>

--- Normalized user provider.
--- @class alternaut.Provider
--- @field patterns alternaut.Pattern[]
--- @field directories string[]
--- @field extensions alternaut.Extensions

--- Normalized pattern.
--- @class alternaut.Pattern
--- @field template string The pattern template
--- @field transform? alternaut.Transform Casing transforms (nil if no transform)

--- Normalized transform.
--- @alias alternaut.Transform alternaut.UserConfig.Transform
