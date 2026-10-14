return {
  {
    "sindrets/diffview.nvim",
    lazy = false,
    keys = {
      { "<Leader>gv", "<cmd>DiffviewOpen<CR>",          desc = "Git: Review Local Changes" },
      {
        "<Leader>gr",
        function()
          vim.ui.input({ prompt = "Review against base: ", default = "origin/main" }, function(base)
            if not base then return end
            base = vim.trim(base)
            if base == "" then return end
            vim.cmd.DiffviewOpen({ args = { base .. "...HEAD" } })
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
