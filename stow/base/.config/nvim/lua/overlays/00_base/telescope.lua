return {
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
            return { "--hidden" }
          end,
        },
        find_files = {
          hidden = true,
          follow = true
        },
      },
    },
    keys = {
      { '<C-p>',       ':Telescope find_files<CR>',                             mode = 'n', desc = 'Find Files' },
      { '<F9>',        ':Telescope lsp_dynamic_workspace_symbols<CR>',          mode = 'n', desc = 'Workspace Symbols' },
      { '<Leader>sfh', '<cmd>Telescope find_files follow=true hidden=true<CR>', mode = 'n', desc = 'Find Files (hidden)' },
      { '<Leader>sk',  '<cmd>Telescope keymaps<CR>',                            mode = 'n', desc = 'Keymaps' },
    }
  },
}
