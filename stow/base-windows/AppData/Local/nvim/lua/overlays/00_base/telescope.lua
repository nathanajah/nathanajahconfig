return {
  {
    'nvim-telescope/telescope.nvim',
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules/",
          "%.git/"
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
      { '<C-p>',      ':Telescope find_files<CR>',                             mode = 'n', desc = 'Find Files' },
      { '<F9>',       ':Telescope lsp_dynamic_workspace_symbols<CR>',          mode = 'n', desc = 'Workspace Symbols' },
      { '<Leader>ff', '<cmd>Telescope find_files<CR>',                         mode = 'n', desc = 'Find Files' },
      { '<Leader>fF', '<cmd>Telescope find_files follow=true hidden=true<CR>', mode = 'n', desc = 'Find Files (hidden)' },
      { '<Leader>fg', '<cmd>Telescope live_grep<CR>',                          mode = 'n', desc = 'Live grep' },
      { '<Leader>fh', '<cmd>Telescope help_tags<CR>',                          mode = 'n', desc = 'Help Tags' },
      { '<Leader>fb', '<cmd>Telescope buffers<CR>',                            mode = 'n', desc = 'Buffers' },
      { '<Leader>fk', '<cmd>Telescope keymaps<CR>',                            mode = 'n', desc = 'Keymaps' },
      { '<Leader>fs', '<cmd>Telescope lsp_document_symbols<CR>',               mode = 'n', desc = 'Document Symbols' },
      { '<Leader>fS', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>',      mode = 'n', desc = 'Workspace Symbols' },
    }
  },
}
