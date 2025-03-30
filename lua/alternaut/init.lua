local M = {}

--- Define test/source file patterns by filetype.
--- @param config? alternaut.UserConfig
function M.setup(config)
  require('alternaut._.config').set_config(config)
end

--- Toggle between the current file and its corresponding alternate or source.
--- @param mode string Set of providers to use (tests, styles, etc.).
--- @param provider? string Specific provider to use.
function M.toggle(mode, provider)
  M.toggle_with({
    file = vim.fn.expand('%:p'),
    mode = mode,
    provider = provider,
  })
end

--- Jump to the corresponding alternate or source file.
--- @param options alternaut.ResolveOptions
function M.toggle_with(options)
  local failed, target = M.resolve_with(options)
  if failed then
    return -- Error already logged.
  end

  if not target then
    require('alternaut._.log').error(
      "couldn't resolve ",
      { hi = 'String', msg = options.mode },
      ' file.'
    )

    return
  end

  vim.cmd.edit(target)
end

--- Find the corresponding alternate or source for the current file.
--- @param mode string Set of providers to use (tests, styles, etc.).
--- @param provider? string Specific provider to use.
--- @return boolean failed True if a validation error occurred.
--- @return string|nil path The resolved path, or nil if not found.
function M.resolve(mode, provider)
  return M.resolve_with({
    file = vim.fn.expand('%:p'),
    mode = mode,
    provider = provider,
  })
end

--- Find the corresponding alternate or source file.
--- @param options alternaut.ResolveOptions
--- @return boolean failed True if a validation error occurred.
--- @return string|nil path The resolved path, or nil if not found.
function M.resolve_with(options)
  local cfg = require('alternaut._.config')
  local provider = require('alternaut._.provider')
  local search_plan = require('alternaut._.search_plan')

  -- Get all providers specified by the options.
  local all_providers = cfg.get_providers(options.mode, options.provider)
  if not all_providers then
    return true, nil -- Error already logged.
  end

  -- Filter providers to what's plausible.
  local matching_providers =
    provider.get_matching_providers(options.file, all_providers)

  local search_paths = {}

  -- Start with source files! Alternates are more discriminating, so if the
  -- alternate matched and suggests searching a source file, it's more likely
  -- to be correct.
  for _, src_provider in ipairs(matching_providers.sources) do
    vim.list_extend(
      search_paths,
      search_plan.get_source_search_path(options.file, src_provider)
    )
  end

  for _, alt_provider in ipairs(matching_providers.alternates) do
    vim.list_extend(
      search_paths,
      search_plan.get_alternate_search_path(options.file, alt_provider)
    )
  end

  -- Search each path in sequence. Return the first match.
  for _, path in ipairs(search_paths) do
    if vim.fn.filereadable(path) == 1 then
      return false, path
    end
  end

  return false, nil
end

return M

--- @class alternaut.ResolveOptions
---
--- An absolute path to a reference point. Can be a source file or an
--- alternate file.
--- @field file string
---
--- The set of providers to consider when resolving the file (tests, headers,
--- styles, etc.).
--- @field mode string
---
--- The specific provider to use. If omitted, all providers are considered.
--- @field provider? string
