return {
    {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      -- Shared buffer-local logic
      on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
        end

        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Visual format if supported
        if client.server_capabilities.documentRangeFormattingProvider then
          map("v", "<space>f", function() vim.lsp.buf.format({ async = false }) end, "LSP: Format Range")
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

      -- Per-server settings (same as before)
      servers = {
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
        local map = vim.keymap.set
        local o = { noremap = true, silent = true }
        map("n", "gD", vim.lsp.buf.declaration, o)
        map("n", "gd", vim.lsp.buf.definition, o)
        map("n", "K",  vim.lsp.buf.hover, o)
        map("n", "gi", vim.lsp.buf.implementation, o)
        map("n", "<C-k>", vim.lsp.buf.signature_help, o)
        map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, o)
        map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, o)
        map("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, o)
        map("n", "<space>D", vim.lsp.buf.type_definition, o)
        map("n", "<space>rn", vim.lsp.buf.rename, o)
        map("n", "<space>ca", vim.lsp.buf.code_action, o)
        map("n", "gr", vim.lsp.buf.references, o)
        map("n", "<space>e", vim.diagnostic.open_float, o)
        map("n", "[d", vim.diagnostic.goto_prev, o)
        map("n", "]d", vim.diagnostic.goto_next, o)
        map("n", "<space>q", vim.diagnostic.setloclist, o)
        map("n", "<space>f", function() vim.lsp.buf.format({ async = false }) end, o)
      end,

      -- Your format-on-save filetypes
      format_on_save = {
        pattern = { "*.go", "*.c", "*.cpp", "*.h", "*.hpp", "*.rs" },
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

      -- Start each server using the new API
      for name, server_opts in pairs(opts.servers or {}) do
        local base = vim.lsp.config[name]
        if not base then
          vim.notify(("LSP: no vim.lsp.config.%s; is it installed/available?"):format(name), vim.log.levels.WARN)
        else
          local cfg = vim.tbl_deep_extend("force", base, server_opts or {}, {
            on_attach = opts.on_attach,
          })

          if cfg.filetypes and #cfg.filetypes > 0 then
            vim.api.nvim_create_autocmd("FileType", {
              pattern = cfg.filetypes,
              callback = function(ev)
                local bufnr = ev.buf
                for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                  if client.name == cfg.name then return end
                end
                vim.lsp.start(cfg, { bufnr = bufnr })
              end,
            })
          else
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
              callback = function(ev)
                local bufnr = ev.buf
                for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                  if client.name == cfg.name then return end
                end
                vim.lsp.start(cfg, { bufnr = bufnr })
              end,
            })
          end
        end
      end
    end
  },
}
