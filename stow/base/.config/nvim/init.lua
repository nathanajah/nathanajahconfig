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



require ('config.options')

plugins = require('plugins')
require('lazy').setup(plugins)
require('config')
