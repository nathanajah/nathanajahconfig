require('nvim-tree').setup()
vim.api.nvim_set_keymap('n', '<F7>', ':NvimTreeToggle<CR>', {})
vim.api.nvim_set_keymap('n', '<F6>', ':NvimTreeFindFile<CR>', {})
