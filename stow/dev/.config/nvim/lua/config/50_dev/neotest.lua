require("neotest").setup({
  adapters = {
    require("neotest-golang"),
  },
  status = { virtual_text = true },
  output = { open_on_run = true },
})


vim.keymap.set("n", "<leader>tc", function() require("neotest").output_panel.clear() end, { desc = "Clear test output panel" })
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run tests in current file" })
vim.keymap.set("n", "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end, { desc = "Run all tests in the current directory" })
vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, { desc = "Open test output" })
vim.keymap.set("n", "<leader>tO", function() require("neotest").output_panel.toggle() end, { desc = "Toggle test output panel" })
