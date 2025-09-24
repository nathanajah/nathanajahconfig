local sysname = vim.loop.os_uname().sysname

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
  'tpope/vim-fugitive',
  'ludovicchabant/vim-lawrencium',
  'airblade/vim-gitgutter',
  {
    'folke/trouble.nvim',
    opts = {
      auto_preview = false,
      win = {
        size = {
          width= 0.2,
          height= 0.2,
        }
      }
    },
    keys = {
      { "<F8>", "<cmd>Trouble symbols toggle<CR>", desc = "Trouble: Toggle Symbols" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: Toggle Diagnostics" },
      { "<leader>xl", "<cmd>Trouble lsp toggle win.position=right<CR>", desc = "Trouble: Toggle LSP" },
      { "<leader>xd", "<cmd>Trouble lsp_definitions toggle<CR>", desc = "Trouble: Toggle LSP Definitions" },
      { "<leader>xD", "<cmd>Trouble lsp_declarations toggle<CR>", desc = "Trouble: Toggle LSP Declarations" },
      { "<leader>xi", "<cmd>Trouble lsp_implementations toggle<CR>", desc = "Trouble: Toggle LSP Implementations" },
      { "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>", desc = "Trouble: Toggle LSP References" },
      { "<leader>xI", "<cmd>Trouble lsp_incoming_calls toggle<CR>", desc = "Trouble: Toggle LSP Incoming Calls" },
      { "<leader>xO", "<cmd>Trouble lsp_outgoing_calls toggle<CR>", desc = "Trouble: Toggle LSP Outgoing Calls" },
      { "<leader>xc", function() require("trouble").close() end, desc = "Trouble: Close" },
    }
  },
  'hashivim/vim-terraform',
  'nvim-tree/nvim-web-devicons',
  'sindrets/diffview.nvim',
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',
      -- use a release tag to download pre-built binaries
    version = '*',
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-e: Hide menu
      -- C-k: Toggle signature help
      --
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = 'default' },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    event = { "VeryLazy" }, -- load on first keypress below
    keys = {
      { "<F5>",  function() require("dap").continue() end,                     desc = "DAP Continue/Start" },
      { "<F10>", function() require("dap").step_over() end,                    desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end,                    desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end,                     desc = "DAP Step Out" },
      { "<Leader>b",  function() require("dap").toggle_breakpoint() end,       desc = "DAP Toggle Breakpoint" },
      { "<Leader>B",  function() require("dap").set_breakpoint() end,          desc = "DAP Set Breakpoint" },
      { "<Leader>lp", function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "DAP Set Logpoint"
      },
      { "<Leader>dr", function() require("dap").repl.open() end,               desc = "DAP Open REPL" },
      { "<Leader>dl", function() require("dap").run_last() end,                desc = "DAP Run Last" },
      -- Widgets (these come from nvim-dap itself)
      { "<Leader>df", function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "DAP UI: Show Frames"
      },
      { "<Leader>ds", function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "DAP UI: Show Scopes"
      },
      { "<Leader>dh", function() require("dap.ui.widgets").hover() end,        mode = { "n", "v" }, desc = "DAP UI: Hover" },
      { "<Leader>dp", function() require("dap.ui.widgets").preview() end,      mode = { "n", "v" }, desc = "DAP UI: Preview" },
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
      { "<Leader>du", function() require("dapui").toggle() end, desc = "DAP UI: Toggle" },
      { "<Leader>do", function() require("dapui").open() end,   desc = "DAP UI: Open" },
      { "<Leader>dc", function() require("dapui").close() end,  desc = "DAP UI: Close" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup() -- same as: require("dapui").setup()

      -- (Optional) auto-open/close UI on session start/end
      dap.listeners.after.event_initialized["dapui_autoopen"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_autoclose"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_autoclose"]      = function() dapui.close() end
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
  'folke/neodev.nvim',
  'nvim-neotest/nvim-nio',
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
  {
    'nvim-neotest/neotest',
    opts = {
      adapters = {
        ['neotest-golang'] = {},
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
    keys = {
      { "<leader>tc", function() require("neotest").output_panel.clear() end, desc = "Clear test output panel" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run tests in current file" },
      { "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all tests in the current directory" },
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Open test output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle test output panel" },
    }
  },
  'fredrikaverpil/neotest-golang',
  {
    'olimorris/codecompanion.nvim',
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
    keys = {
      { "<C-x>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to CodeCompanion Chat" },
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
  {
    'echasnovski/mini.diff',
    config = true,
  },
}
