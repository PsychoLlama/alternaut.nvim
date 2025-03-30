local M = {}

--- Get matching providers for a given file path.
--- @param file_path string
--- @param providers alternaut.Provider[]
--- @return alternaut._.AvailableProviders
function M.get_matching_providers(file_path, providers)
  local path = require('alternaut._.path')
  local file = path.parse(file_path)
  local result = {
    alternates = {},
    sources = {},
  }

  for _, provider in ipairs(providers) do
    if
      vim.tbl_contains(provider.extensions.target, file.ext)
      and M.matches_name(file, provider)
      and M.matches_dir(file, provider)
    then
      -- The provider matches. The file path is probably an alternate, so set
      -- it in the sources list. It will help us return to the source file.
      table.insert(result.sources, provider)
    elseif vim.tbl_contains(provider.extensions.origin, file.ext) then
      -- The provider doesn't match, but the extension shows this might be
      -- a source file.
      table.insert(result.alternates, provider)
    end
  end

  return result
end

--- See if the file name matches any of the provider's patterns.
--- Example: `foo.test.ts`.
--- @param file alternaut._.Path
--- @param provider alternaut.Provider
--- @return boolean
function M.matches_name(file, provider)
  local template = require('alternaut._.template')

  for _, pattern in ipairs(provider.patterns) do
    if template.extract_name(file.basename, pattern) then
      return true
    end
  end

  return false
end

--- See if we're in a directory declared by the provider.
--- For example: `__tests__/` or `templates/`.
--- @param file alternaut._.Path
--- @param provider alternaut.Provider
--- @return boolean
function M.matches_dir(file, provider)
  for _, directory in ipairs(provider.directories) do
    -- Essentially a wildcard match. Nothing to be learned.
    if directory == '.' or directory == '..' then
      return true
    end

    -- We're in one of the target directories.
    if vim.endswith(file.dir, directory) then
      return true
    end
  end

  return false
end

return M

--- @class alternaut._.AvailableProviders
---
--- Providers leading to an alternate file.
--- @field alternates alternaut.Provider[]
---
--- Providers leading to a source file.
--- @field sources alternaut.Provider[]
