local uv = vim.uv or vim.loop

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plenarypath = vim.fn.stdpath("data") .. "/plenary.nvim"
if not vim.loop.fs_stat(plenarypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/nvim-lua/plenary.nvim.git",
    "--branch=master", -- master
    plenarypath,
  })
end
vim.opt.rtp:prepend(plenarypath)

local overlays = {}

local ovHandle = uv.fs_scandir(vim.fn.stdpath('config') .. '/lua/overlays')
if ovHandle then
  while true do
    local name, type = uv.fs_scandir_next(ovHandle)

    if not name then
      break
    end
    table.insert(overlays, name)
  end
end
table.sort(overlays)

local overlayPlugins = {}

for _, overlay in ipairs(overlays) do
  table.insert(overlayPlugins, { import = 'overlays.' .. overlay } )
end


require ('config.options')
plugins = require('plugins')
for _, overlay in ipairs(overlayPlugins) do
  table.insert(plugins, overlay)
end
require('lazy').setup(plugins)
require('config')
