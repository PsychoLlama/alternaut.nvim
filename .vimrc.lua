local repo = vim.fn.expand('<sfile>:h')

-- Specific to my dotfiles. Replaces the compiled plugin with a local version.
require('core.pkg').on_load(function(plugins)
  return vim
    .iter(plugins)
    :map(function(plugin)
      if plugin.name ~= 'alternaut.nvim' then
        return plugin
      end

      return vim.tbl_extend('force', plugin, {
        type = 'path',
        source = repo,
      })
    end)
    :totable()
end)

-- Define a neovim command to reload the current file.
vim.api.nvim_create_user_command('Reload', function()
  local filepath = vim.fn.expand('%:p')
  local relative_path = filepath:gsub('^.*/lua/', '')
  local module_name = relative_path:gsub('/', '.'):gsub('.lua$', '')

  vim.print('Reloading ' .. module_name)
  package.loaded[module_name] = nil
end, {})
