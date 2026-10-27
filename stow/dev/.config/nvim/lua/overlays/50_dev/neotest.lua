return {
  {
    'nvim-neotest/neotest',
    opts = function()
      return {
        adapters = {
          require("neotest-golang")({}),
        },
        status = { virtual_text = true },
        output = { open_on_run = false },
      }
    end,
    keys = {
      { "<leader>tc", function() require("neotest").output_panel.clear() end,                             desc = "Clear test output panel" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run tests in current file" },
      { "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run all tests in the current directory" },
      { "<leader>tn", function() require("neotest").run.run() end,                                        desc = "Run nearest test" },
      { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Rerun last test" },
      { "<leader>tx", function() require("neotest").run.stop() end,                                       desc = "Stop nearest test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Open test output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle test output panel" },
    }
  },
}
