return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    event = { "VeryLazy" }, -- load on first keypress below
    keys = {
      { "<Leader>dc", function() require("dap").continue() end,          desc = "DAP Continue/Start" },
      { "<Leader>do", function() require("dap").step_over() end,         desc = "DAP Step Over" },
      { "<Leader>di", function() require("dap").step_into() end,         desc = "DAP Step Into" },
      { "<Leader>dO", function() require("dap").step_out() end,          desc = "DAP Step Out" },
      { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<Leader>dB", function() require("dap").set_breakpoint() end,    desc = "DAP Set Breakpoint" },
      {
        "<Leader>lp",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "DAP Set Logpoint"
      },
      { "<Leader>dr", function() require("dap").repl.open() end, desc = "DAP Open REPL" },
      { "<Leader>dl", function() require("dap").run_last() end,  desc = "DAP Run Last" },
      -- Widgets (these come from nvim-dap itself)
      {
        "<Leader>df",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "DAP UI: Show Frames"
      },
      {
        "<Leader>ds",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "DAP UI: Show Scopes"
      },
      { "<Leader>dh", function() require("dap.ui.widgets").hover() end,   mode = { "n", "v" }, desc = "DAP UI: Hover" },
      { "<Leader>dp", function() require("dap.ui.widgets").preview() end, mode = { "n", "v" }, desc = "DAP UI: Preview" },
    },
    config = function()
      -- You can put adapter configs here if you add more languages later.
      -- For Go we’ll lean on nvim-dap-go to register delve.
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- required by dap-ui
    },
    keys = {
      { "<Leader>dz", function() require("dapui").toggle() end, desc = "DAP UI: Toggle" },
      { "<Leader>du", function() require("dapui").open() end,   desc = "DAP UI: Open" },
      { "<Leader>dq", function() require("dapui").close() end,  desc = "DAP UI: Close" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup() -- same as: require("dapui").setup()

      -- (Optional) auto-open/close UI on session start/end
      dap.listeners.after.event_initialized["dapui_autoopen"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_autoclose"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_autoclose"]     = function() dapui.close() end
    end,
  },

  -- Go conveniences (require name: "dap-go")
  {
    "leoluz/nvim-dap-go",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<Leader>dt", function() require("dap-go").debug_test() end, desc = "DAP Go: Debug Test" },
    },
    config = function()
      require("dap-go").setup() -- same as your require('dap-go').setup()
    end,
  },
}
