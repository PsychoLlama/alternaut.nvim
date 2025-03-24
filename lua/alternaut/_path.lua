--- Tools for working with file paths.

--- OS-specific path separator.
local PATHSEP = package.config:sub(1, 1)

local M = {}

--- Check if a path is an absolute (root-relative) path.
--- @return boolean
function M.is_absolute(path)
  return path:sub(1, 1) == PATHSEP
end

--- Check if a path is relative.
--- @return boolean
function M.is_relative(path)
  return not M.is_absolute(path)
end

--- @class alternaut._path.Path
--- @field parent nil|string
--- @field name string
--- @field ext nil|string
---
--- Parse a path into its parts.
--- @param path string
--- @return alternaut._path.Path
function M.parse(path)
  local parent = vim.fs.dirname(path)
  local ext = vim.fn.fnamemodify(path, ':e')
  local name = vim.fn.fnamemodify(path, ':t:r')

  return {
    parent = parent,
    name = name,
    ext = ext,
  }
end

--- Join multiple path segments.
--- @param ... string
--- @return string
function M.join(...)
  return vim.fs.joinpath(...)
end

--- Split a path into its segments.
--- @param path string
--- @return string[]
function M.split(path)
  local parts = vim.split(path, PATHSEP, {
    plain = true,
    trimempty = true,
  })

  if M.is_absolute(path) then
    table.insert(parts, 1, PATHSEP)
  end

  return parts
end

return M
