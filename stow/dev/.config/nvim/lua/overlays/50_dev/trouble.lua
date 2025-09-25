return {
  {
    'folke/trouble.nvim',
    opts = {
      auto_preview = false,
      win = {
        size = {
          width = 0.2,
          height = 0.2,
        }
      }
    },
    keys = {
      { "<leader>xs", "<cmd>Trouble symbols toggle<CR>",                desc = "Trouble: Toggle Symbols" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",            desc = "Trouble: Toggle Diagnostics" },
      { "<leader>xl", "<cmd>Trouble lsp toggle win.position=right<CR>", desc = "Trouble: Toggle LSP" },
      { "<leader>xd", "<cmd>Trouble lsp_definitions toggle<CR>",        desc = "Trouble: Toggle LSP Definitions" },
      { "<leader>xD", "<cmd>Trouble lsp_declarations toggle<CR>",       desc = "Trouble: Toggle LSP Declarations" },
      { "<leader>xi", "<cmd>Trouble lsp_implementations toggle<CR>",    desc = "Trouble: Toggle LSP Implementations" },
      { "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>",         desc = "Trouble: Toggle LSP References" },
      { "<leader>xI", "<cmd>Trouble lsp_incoming_calls toggle<CR>",     desc = "Trouble: Toggle LSP Incoming Calls" },
      { "<leader>xO", "<cmd>Trouble lsp_outgoing_calls toggle<CR>",     desc = "Trouble: Toggle LSP Outgoing Calls" },
      { "<leader>xo", "<cmd>Trouble open<CR>",                          desc = "Trouble: Open" },
      { "<leader>xc", function() require("trouble").close() end,        desc = "Trouble: Close" },
    }
  },
}
