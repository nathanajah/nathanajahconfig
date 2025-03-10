local scan = require('plenary.scandir')
local path = require('plenary.path')

result = {}

for _, file in ipairs(scan.scan_dir(vim.fn.stdpath('config') .. '/lua/plugins', {depth = 1, add_dirs = true})) do
    local path = path:new(file .. '/init.lua')
    if (path:exists()) then
        module, _ = file
            :gsub('^' .. vim.fn.stdpath('config'), '', 1)
            :gsub('/lua/', '', 1)
            :gsub("/", ".")
        tmp = require(module)
        if (type(tmp) == 'table') then
          for _, plugin in ipairs(tmp) do
            table.insert(result, plugin)
          end
        end
    end
end
return result
