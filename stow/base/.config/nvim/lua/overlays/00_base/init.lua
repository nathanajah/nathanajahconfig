return {
  'nvim-lua/plenary.nvim',
  'tpope/vim-commentary',
  'tpope/vim-surround',
  'easymotion/vim-easymotion',
  'moll/vim-bbye',
  'ntpeters/vim-better-whitespace',
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang then
            return
          end

          -- Skip buffers whose parser is not installed.
          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })
    end,
  },
  { import = 'overlays.00_base.localvimrc' },
  { import = 'overlays.00_base.ctrlspace' },
  { import = 'overlays.00_base.telescope' },
  { import = 'overlays.00_base.nvimtree' },
}
