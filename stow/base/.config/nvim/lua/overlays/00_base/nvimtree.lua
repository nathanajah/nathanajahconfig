return {
  {
    'nvim-tree/nvim-tree.lua',
    config = true,
    keys = {
      { '<F7>', '<cmd>NvimTreeToggle<CR>', mode = 'n', desc = 'Toggle Nvim Tree' },
      { '<F6>', '<cmd>NvimTreeFindFile<CR>', mode = 'n', desc = 'Find File in Nvim Tree' },
    },
  },
}
