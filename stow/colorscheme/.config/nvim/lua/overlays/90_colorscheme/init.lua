return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = {
      flavour = "macchiato",
    },
    init = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  }
}
