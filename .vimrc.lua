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
