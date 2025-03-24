local M = {}

--- Render variables into a string. This is the template language used for
--- `patterns` in the config.
--- @param str string
--- @param context table<string, string>
--- @return string
function M.render(str, context)
  return (
    str:gsub('{(.-)}', function(key)
      if context[key] == nil then
        error('alternaut: pattern contains unknown variable: {' .. key .. '}')
      end

      return context[key]
    end)
  )
end

--- Takes the name of a file (no extension) and a pattern, returning the name
--- with the string literal parts removed. For example:
---
---   'test_foo.py' with pattern 'test_{name}.{ext}' returns 'foo'
---
--- @param filename string
--- @param pattern string
--- @return string
function M.extract_name(filename, pattern)
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
  return (filename:match(match_pattern))
end

return M
