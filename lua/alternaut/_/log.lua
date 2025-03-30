local log = {}

--- Log a message with highlighting.
--- This is a little gross. There's probably a better way to do it.
--- @vararg string|alternaut._.LogHighlight
function log.with_highlight(...)
  local parts = vim.tbl_map(function(part)
    if type(part) == 'string' then
      return { hi = 'None', msg = part }
    end

    return part
  end, { ... })

  for _, part in ipairs(parts) do
    vim.cmd.echohl(part.hi)
    vim.cmd.echon(vim.json.encode(part.msg))
  end

  vim.cmd.echohl('None')
end

--- Informational message
--- @vararg string|alternaut._.LogHighlight
function log.info(...)
  log.with_highlight({ hi = 'Comment', msg = 'alternaut: ' }, ...)
end

--- Warning message
--- @vararg string|alternaut._.LogHighlight
function log.warn(...)
  log.with_highlight({ hi = 'Type', msg = 'alternaut: ' }, ...)
end

--- Error message
--- @vararg string|alternaut._.LogHighlight
function log.error(...)
  log.with_highlight({ hi = 'Error', msg = 'alternaut: ' }, ...)
end

return log

--- @class alternaut._.LogHighlight
---
--- Syntax highlight name.
--- @field hi string
---
--- Message to display.
--- @field msg string
