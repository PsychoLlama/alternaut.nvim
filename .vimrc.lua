local repo = vim.fn.expand('<sfile>:h')

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
