return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
    },

    opts = {
      -- Shared buffer-local logic
      on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
        end

        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Visual format if supported
        if client.server_capabilities.documentRangeFormattingProvider then
          map("v", "<leader>cf", function() vim.lsp.buf.format({ async = false }) end, "LSP: Format Selection")
        end

        -- Document highlight if supported
        if client.server_capabilities.documentHighlightProvider then
          vim.cmd([[
            hi default LspReferenceRead  cterm=bold ctermbg=red guibg=LightYellow
            hi default LspReferenceText  cterm=bold ctermbg=red guibg=LightYellow
            hi default LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
          ]])
          local grp = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = grp,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = grp,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,

      -- Per-server settings
      servers = {
        lua_ls = {},
        clangd = {},
        bashls = {},
        dockerls = {},
        gopls = {
          settings = { gopls = { symbolScope = "workspace" } },
        },
        rust_analyzer = {},
        golangci_lint_ls = {},
      },

      -- Global (non-buffer) keymaps
      keys = function()
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
        end
        map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to Declaration")
        map("n", "gd", vim.lsp.buf.definition, "LSP: Go to Definition")
        map("n", "K", vim.lsp.buf.hover, "LSP: Hover Documentation")
        map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to Implementation")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "LSP: Signature Help")
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "LSP: Add Workspace Folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "LSP: Remove Workspace Folder")
        map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP: List Workspace Folders")
        map("n", "<leader>D", vim.lsp.buf.type_definition, "LSP: Go to Type Definition")
        map("n", "<leader>cr", vim.lsp.buf.rename, "LSP: Rename Symbol")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
        map("n", "gr", vim.lsp.buf.references, "LSP: Find References")
        map("n", "<leader>e", vim.diagnostic.open_float, "Diagnostics: Show Details")
        map("n", "[d", vim.diagnostic.goto_prev, "Diagnostics: Previous")
        map("n", "]d", vim.diagnostic.goto_next, "Diagnostics: Next")
        map("n", "<leader>cf", function() vim.lsp.buf.format({ async = false }) end, "LSP: Format File")
      end,

      -- Your format-on-save filetypes
      format_on_save = {
        pattern = { "*.go", "*.c", "*.cpp", "*.h", "*.hpp", "*.rs", "*.lua" },
      },
    },

    config = function(_, opts)
      -- Global keymaps
      if type(opts.keys) == "function" then opts.keys() end

      -- Format on save
      if opts.format_on_save then
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = opts.format_on_save.pattern,
          callback = function() vim.lsp.buf.format({ async = false }) end,
        })
      end

      -- Configure servers and let Neovim manage startup and attachment.
      for name, server_opts in pairs(opts.servers or {}) do
        if not vim.lsp.config[name] then
          vim.notify(("LSP: no vim.lsp.config.%s; is it installed/available?"):format(name), vim.log.levels.WARN)
        else
          vim.lsp.config(name, vim.tbl_deep_extend("force", server_opts or {}, {
            on_attach = opts.on_attach,
          }))
          vim.lsp.enable(name)
        end
      end
    end
  },
}
