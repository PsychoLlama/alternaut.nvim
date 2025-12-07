local M = {}

local casing = require('alternaut._.casing')

--- Render variables into a string. This is the template language used for
--- `patterns` in the config.
---
--- @param str string The template string
--- @param context table<string, string> Variable values (name, ext)
--- @param transform? string Optional casing transform to apply to {name}
--- @return string
function M.render(str, context, transform)
  return (
    str:gsub('{(.-)}', function(key)
      if context[key] == nil then
        error('alternaut: pattern contains unknown variable: {' .. key .. '}')
      end

      local value = context[key]

      -- Apply transform only to the {name} variable
      if key == 'name' and transform then
        local transform_fn = casing.transforms[transform]
        if transform_fn == nil then
          error('alternaut: unknown transform: ' .. transform)
        end
        value = transform_fn(value)
      end

      return value
    end)
  )
end

--- Takes the name of a file (no extension) and a pattern, returning the name
--- with the string literal parts removed. For example:
---
---   'test_foo.py' with pattern 'test_{name}.{ext}' returns 'foo'
---
--- When a transform is provided, the extracted name is converted back to the
--- origin casing.
---
--- @param filename string
--- @param pattern string
--- @param transform? string The origin transform to apply to the extracted name
--- @return nil|string
function M.extract_name(filename, pattern, transform)
  local match_pattern = pattern
    :gsub('%.', '%%.')
    :gsub('%-', '%%-')
    :gsub('%+', '%%+')
    :gsub('%?', '%%?')
    :gsub('%[', '%%[')
    :gsub('%]', '%%]')
    :gsub('%(', '%%(')
    :gsub('%)', '%%)')
    :gsub('{.-}', function(key)
      if key == '{name}' then
        return '(.-)'
      end

      return '.-'
    end)

  -- Return the first group match (the name).
  local extracted = filename:match(match_pattern)

  if extracted == nil then
    return nil
  end

  -- Apply the origin transform to convert back to source casing
  if transform then
    local transform_fn = casing.transforms[transform]
    if transform_fn then
      extracted = transform_fn(extracted)
    end
  end

  return extracted
end

return M
