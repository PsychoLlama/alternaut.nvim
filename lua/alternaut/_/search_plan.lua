local M = {}

--- Given a source file and a provider, create a search path for all possible
--- locations of the alternate file (e.g. a `.h` file or test). This does not
--- handle returning from an alternate back to the source file.
--- @param source_path string
--- @param provider alternaut.Provider
--- @return string[]
function M.get_alternate_search_path(source_path, provider)
  local template = require('alternaut._.template')
  local path = require('alternaut._.path')

  local src = path.parse(source_path)
  local result = {}

  local target_directories = vim.tbl_map(function(directory)
    local target_dir = path.join(src.dir, directory)
    return path.normalize(target_dir)
  end, provider.directories)

  -- Order matters! Check all variations before moving onto the next pattern.
  for _, pattern in ipairs(provider.patterns) do
    for _, directory in ipairs(target_directories) do
      for _, ext in ipairs(provider.extensions.target) do
        -- Use target transform when going from source to alternate
        local target_transform = pattern.transform
          and pattern.transform.target
        local possible_path = path.join(
          directory,
          template.render(pattern.template, {
            name = src.name,
            ext = ext,
          }, target_transform)
        )

        table.insert(result, possible_path)
      end
    end
  end

  return result
end

--- Given an alternate file and a provider, create a search path for all
--- possible locations of the source file. This is the opposite of the
--- `get_alternate_search_path` function.
--- @param alternate_path string
--- @param provider alternaut.Provider
--- @return string[]
function M.get_source_search_path(alternate_path, provider)
  local template = require('alternaut._.template')
  local path = require('alternaut._.path')

  local alt = path.parse(alternate_path)
  local result = {}

  for _, pattern in ipairs(provider.patterns) do
    -- Use origin transform when going from alternate back to source
    local origin_transform = pattern.transform and pattern.transform.origin
    local src_name =
      template.extract_name(alt.basename, pattern.template, origin_transform)

    for _, directory in ipairs(provider.directories) do
      local upward_path = directory

      -- Invert the directory search. Instead of going down, we go up.
      if directory ~= '.' then
        local up_one = vim.tbl_map(function()
          return '..'
        end, path.split(directory))

        upward_path = path.join(unpack(up_one))
      end

      for _, ext in ipairs(provider.extensions.origin) do
        if path.is_relative(directory) and src_name then
          local possible_path =
            path.join(alt.dir, upward_path, src_name .. '.' .. ext)

          table.insert(result, path.normalize(possible_path))
        end
      end
    end
  end

  return result
end

return M
