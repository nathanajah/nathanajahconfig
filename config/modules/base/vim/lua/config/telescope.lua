require("telescope").setup {
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
}
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', {})
vim.api.nvim_set_keymap('n', '<F9>', ':Telescope lsp_dynamic_workspace_symbols<CR>', {})
vim.cmd('command Rg :Telescope live_grep')
vim.api.nvim_set_keymap('n', '<Leader>sfh', '<cmd>Telescope find_files follow=true hidden=true<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>sk', '<cmd>Telescope keymaps<CR>', {})
