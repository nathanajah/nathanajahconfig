return {
  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    keys = {
      vim.keymap.set('i', '<C-f>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot Suggestion"
      }),
    },
    lazy = false,
  },
}
