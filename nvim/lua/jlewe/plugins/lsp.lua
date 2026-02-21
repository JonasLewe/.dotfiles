-- =============================================================================
-- LSP — LANGUAGE SERVER PROTOCOL
-- =============================================================================
-- LSP is the technology that powers IDE features like:
--   • Go to definition (gd)         • Find all references (gr)
--   • Hover documentation (K)       • Auto-completion
--   • Rename symbol (<leader>rn)    • Code actions (<leader>ca)
--   • Inline diagnostics (errors, warnings)
--
-- HOW IT WORKS:
--   1. mason.nvim     → installs language servers (e.g. pyright, lua_ls)
--   2. mason-lspconfig → bridges Mason with nvim-lspconfig
--   3. nvim-lspconfig → the official Neovim plugin that configures LSP clients
--
-- Language servers are separate programs that run alongside Neovim and
-- communicate via the LSP protocol. Mason downloads them automatically.
--
-- USEFUL COMMANDS:
--   :Mason         → open Mason UI (install/update language servers)
--   :LspInfo       → show which LSP servers are attached to current buffer
--   :LspLog        → debug log for LSP issues
--   :checkhealth   → overall health check including LSP

return {
  "williamboman/mason.nvim",

  -- Only load when opening a file (not on blank startup screen)
  event = { "BufReadPre", "BufNewFile" },

  -- Also allow opening Mason UI directly by command
  cmd = { "Mason", "MasonInstall", "MasonUpdate" },

  dependencies = {
    -- Bridges Mason's installers with nvim-lspconfig's server names
    "williamboman/mason-lspconfig.nvim",
    -- The official LSP client configuration plugin
    "neovim/nvim-lspconfig",
  },

  config = function()
    -- Initialize Mason (the installer UI / package manager)
    require("mason").setup()

    -- Configure which language servers to auto-install
    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright",   -- Python: type checking, completions, go-to-def
        "ts_ls",     -- TypeScript/JavaScript
        "yamlls",    -- YAML (Kubernetes manifests, CI configs, etc.)
        "helm_ls",   -- Helm charts (Kubernetes templating)
        "dockerls",  -- Dockerfile
        "lua_ls",    -- Lua (for editing this Neovim config!)
      },
      -- Automatically install a server when you open a file of that type
      automatic_installation = true,
    })

    -- -------------------------------------------------------------------------
    -- LSP KEYMAPS
    -- -------------------------------------------------------------------------
    -- These keymaps are only active when an LSP server is attached to a buffer.
    -- LspAttach fires once per buffer when a language server connects.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }

        -- Navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,  vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references,  vim.tbl_extend("force", opts, { desc = "Go to references" }))

        -- Documentation: hover shows the type signature and docs for symbol under cursor
        vim.keymap.set("n", "K",  vim.lsp.buf.hover,       vim.tbl_extend("force", opts, { desc = "Show hover docs" }))

        -- Refactoring
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,       vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,  vim.tbl_extend("force", opts, { desc = "Code action" }))

        -- Diagnostics: navigate between errors/warnings in the file
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,  vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next,  vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

        -- Show the full diagnostic message for the current line in a float window
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
      end,
    })

    -- -------------------------------------------------------------------------
    -- DIAGNOSTIC SIGNS
    -- -------------------------------------------------------------------------
    -- These icons appear in the signcolumn (left gutter) next to lines with issues.
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- -------------------------------------------------------------------------
    -- CAPABILITIES
    -- -------------------------------------------------------------------------
    -- Tell LSP servers what features this Neovim client supports.
    -- nvim-cmp (autocompletion) extends the default capabilities to add
    -- snippet support and better completion handling.
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Apply enhanced capabilities to ALL LSP servers globally
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- -------------------------------------------------------------------------
    -- SERVER-SPECIFIC CONFIG
    -- -------------------------------------------------------------------------

    -- lua_ls needs to know about the Neovim runtime globals (like `vim`)
    -- Without this, it would show "undefined global 'vim'" errors everywhere.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            -- Tell lua_ls that `vim` is a valid global (Neovim-specific)
            globals = { "vim" },
          },
          workspace = {
            -- Make lua_ls aware of all Neovim runtime files for better completions
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    })

    -- -------------------------------------------------------------------------
    -- ENABLE SERVERS
    -- -------------------------------------------------------------------------
    -- Activate all configured servers. They will attach automatically when
    -- you open a file of the matching type.
    vim.lsp.enable({
      "pyright",
      "ts_ls",
      "yamlls",
      "helm_ls",
      "dockerls",
      "lua_ls",
    })
  end,
}
