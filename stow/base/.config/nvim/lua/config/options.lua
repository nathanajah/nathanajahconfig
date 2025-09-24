vim.opt.number = true

-- Undo
vim.opt.undodir = vim.env.HOME .. '/.config/nvim/undodir/'
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.undofile = true

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- Hidden
vim.opt.hidden = true

vim.g['python3_host_prog']= vim.env.HOME .. '/.config/venv/py3/nvim/bin/python'
vim.g['python_host_prog']= vim.env.HOME .. '/.config/venv/py2/nvim/bin/python'
