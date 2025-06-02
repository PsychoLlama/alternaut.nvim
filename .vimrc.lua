local repo = vim.fn.expand('<sfile>:h')

-- Specific to my dotfiles. Replaces the compiled plugin with a local version.
require('core.pkg').override('alternaut.nvim', function(plugin)
  return vim.tbl_extend('force', plugin, {
    type = 'path',
    source = repo,
  })
end)

-- Define a neovim command to reload the current file.
vim.api.nvim_create_user_command('Reload', function()
  local filepath = vim.fn.expand('%:p')
  local relative_path = filepath:gsub('^.*/lua/', '')
  local module_name = relative_path:gsub('/', '.'):gsub('.lua$', '')

  vim.print('Reloading ' .. module_name)
  package.loaded[module_name] = nil
end, {})
