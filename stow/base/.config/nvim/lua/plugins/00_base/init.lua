return {
  'nvim-lua/plenary.nvim',
  'tpope/vim-commentary',
  'tpope/vim-surround',
  {
    'embear/vim-localvimrc',
    init = function()
      vim.g.localvimrc_sandbox = 0
    end,
  },
  {
    'vim-ctrlspace/vim-ctrlspace',
    keys = {
      { '<C-J>', ':CtrlSpace<CR>', mode = 'n', desc = 'Open CtrlSpace' },
    },
    init = function()
      vim.g.CtrlSpaceSaveWorkspaceOnSwitch = 1
      vim.g.CtrlSpaceSaveWorkspaceOnExit = 1
    end,
  },
  'easymotion/vim-easymotion',
  'moll/vim-bbye',
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = { theme = 'auto' },
    },
  },
  'ntpeters/vim-better-whitespace',
  {
    'nvim-telescope/telescope.nvim',
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules/",
          ".git/"
        }
      },
      pickers = {
        live_grep = {
          additional_args = function(opts)
            return {"--hidden"}
          end,
        },
        find_files = {
          hidden = true,
          follow = true
        },
      },
    },
    keys = {
      { '<C-p>', ':Telescope find_files<CR>', mode = 'n', desc = 'Find Files' },
      { '<F9>', ':Telescope lsp_dynamic_workspace_symbols<CR>', mode = 'n', desc = 'Workspace Symbols' },
      { '<Leader>sfh', '<cmd>Telescope find_files follow=true hidden=true<CR>', mode = 'n', desc = 'Find Files (hidden)' },
      { '<Leader>sk', '<cmd>Telescope keymaps<CR>', mode = 'n', desc = 'Keymaps' },
    }
  },
  {
    'nvim-tree/nvim-tree.lua',
    config = true,
    keys = {
      { '<F7>', '<cmd>NvimTreeToggle<CR>', mode = 'n', desc = 'Toggle Nvim Tree' },
      { '<F6>', '<cmd>NvimTreeFindFile<CR>', mode = 'n', desc = 'Find File in Nvim Tree' },
    },
  },
  {"nvim-treesitter/nvim-treesitter", build= ":TSUpdate"}
}
