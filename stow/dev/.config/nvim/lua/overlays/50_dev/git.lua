return {
  {
    "sindrets/diffview.nvim",
    lazy = false,
    opts = function()
      local actions = require("diffview.actions")
      return {
        keymaps = {
          view = {
            { "n", "<Leader>ge", actions.focus_files, { desc = "Git: Focus File List" } },
          },
          file_panel = {
            { "n", "<Leader>gl", actions.focus_entry, { desc = "Git: Focus Right Pane" } },
          },
          file_history_panel = {
            { "n", "<Leader>gl", actions.focus_entry, { desc = "Git: Focus Right Pane" } },
          },
        },
      }
    end,
    keys = {
      { "<Leader>gv", "<cmd>DiffviewOpen<CR>",          desc = "Git: Review Local Changes" },
      { "<Leader>gS", "<cmd>DiffviewOpen --cached<CR>", desc = "Git: Review Staged Changes" },
      {
        "<Leader>gr",
        function()
          vim.ui.input({ prompt = "Review against base: ", default = "origin/main" }, function(base)
            if not base then return end
            base = vim.trim(base)
            if base == "" then return end
            vim.cmd.DiffviewOpen({ args = { base .. "...HEAD", "--imply-local" } })
          end)
        end,
        desc = "Git: Review Branch",
      },
      { "<Leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git: File History" },
      { "<Leader>gc", "<cmd>DiffviewClose<CR>",         desc = "Git: Close Diffview" },
    },
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
      { "<Leader>gs", "<cmd>Git<CR>", desc = "Git: Status" },
    },
  },
}
