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

return M
