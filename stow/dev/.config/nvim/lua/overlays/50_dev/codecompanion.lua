return {
  {
    'olimorris/codecompanion.nvim',
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
    keys = {
      { "<LocalLeader>ca", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<LocalLeader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
      { "<LocalLeader>cf", "<cmd>CodeCompanionChat Add<cr>",    mode = "v",          desc = "Add to CodeCompanion Chat" },
    },
    config = true,
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
      display = {
        diff = {
          provider = "mini_diff",
        },
      },
    },
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" }
  },
}
