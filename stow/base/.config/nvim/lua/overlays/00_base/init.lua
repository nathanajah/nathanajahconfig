return {
  'nvim-lua/plenary.nvim',
  'tpope/vim-commentary',
  'tpope/vim-surround',
  'easymotion/vim-easymotion',
  'moll/vim-bbye',
  'ntpeters/vim-better-whitespace',
  { "nvim-treesitter/nvim-treesitter",     build = ":TSUpdate" },
  { import = 'overlays.00_base.localvimrc' },
  { import = 'overlays.00_base.ctrlspace' },
  { import = 'overlays.00_base.telescope' },
  { import = 'overlays.00_base.nvimtree' },
}
