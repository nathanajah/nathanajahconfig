local configDirectory = vim.fn.stdpath('config') .. '/lua/config'

for name, kind in vim.fs.dir(configDirectory) do
  if kind == 'directory' and vim.fn.filereadable(configDirectory .. '/' .. name .. '/init.lua') == 1 then
    require('config.' .. name)
  end
end
