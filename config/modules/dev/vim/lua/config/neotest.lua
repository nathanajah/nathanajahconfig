require("neotest").setup({
  adapters = {
    require("neotest-golang"),
  },
  status = { virtual_text = true },
  output = { open_on_run = true },
})


vim.keymap.set("n", "<leader>tc", function() require("neotest").output_panel.clear() end)
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end)
vim.keymap.set("n", "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end)
vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end)
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end)
vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end)
vim.keymap.set("n", "<leader>tO", function() require("neotest").output_panel.toggle() end)
