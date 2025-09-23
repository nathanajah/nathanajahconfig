require("trouble").setup {
  auto_preview = false,
  win = {
    size = {
      width= 0.2,
      height= 0.2,
    }
  }
}
vim.keymap.set("n", "<F8>", "<cmd>Trouble symbols toggle<CR>")
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>")
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble lsp toggle win.position=right<CR>")
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble lsp_definitions toggle<CR>")
vim.keymap.set("n", "<leader>xD", "<cmd>Trouble lsp_declarations toggle<CR>")
vim.keymap.set("n", "<leader>xi", "<cmd>Trouble lsp_implementations toggle<CR>")
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>")
vim.keymap.set("n", "<leader>xI", "<cmd>Trouble lsp_incoming_calls toggle<CR>")
vim.keymap.set("n", "<leader>xO", "<cmd>Trouble lsp_outgoing_calls toggle<CR>")
vim.keymap.set("n", "<leader>xc", function() require("trouble").close() end)
