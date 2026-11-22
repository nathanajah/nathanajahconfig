local plugins = {}
local pluginDirectory = vim.fn.stdpath('config') .. '/lua/plugins'

for name, kind in vim.fs.dir(pluginDirectory) do
  if kind == 'directory' and vim.fn.filereadable(pluginDirectory .. '/' .. name .. '/init.lua') == 1 then
    local packagePlugins = require('plugins.' .. name)
    if type(packagePlugins) == 'table' then
      vim.list_extend(plugins, packagePlugins)
    end
  end
end

return plugins
