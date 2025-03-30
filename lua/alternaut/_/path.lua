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

--- Return the basename of a path.
--- @param path string
--- @return string
function M.basename(path)
  return vim.fs.basename(path)
end

--- Parse a path into its parts.
--- @param path string
--- @return alternaut._.Path
function M.parse(path)
  local dir = vim.fs.dirname(path)
  local ext = vim.fn.fnamemodify(path, ':e')
  local name = vim.fn.fnamemodify(path, ':t:r')
  local basename = vim.fn.fnamemodify(path, ':t')

  return {
    dir = dir,
    basename = basename,
    name = name,
    ext = ext,
  }
end

--- Normalize a path.
--- @param path string
--- @return string
function M.normalize(path)
  return vim.fs.normalize(path)
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

--- Structured full file path.
--- @class alternaut._.Path
--- @field dir string
--- @field basename string
--- @field name string
--- @field ext nil|string
