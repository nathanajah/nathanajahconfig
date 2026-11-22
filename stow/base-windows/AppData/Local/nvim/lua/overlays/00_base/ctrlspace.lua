return {
  {
    'vim-ctrlspace/vim-ctrlspace',
    keys = {
      { '<C-J>', ':CtrlSpace<CR>', mode = 'n', desc = 'Open CtrlSpace' },
    },
    init = function()
      vim.g.CtrlSpaceSaveWorkspaceOnSwitch = 1
      vim.g.CtrlSpaceSaveWorkspaceOnExit = 1
    end,
  }
}
