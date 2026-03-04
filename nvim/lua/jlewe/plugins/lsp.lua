-- =============================================================================
-- LSP — LANGUAGE SERVER PROTOCOL
-- =============================================================================
-- LSP connects Neovim to language servers that understand your code.
-- A language server runs in the background and provides:
--   • Go to definition (gd)
--   • Find references (gr)
--   • Hover documentation (K)
--   • Diagnostics (errors/warnings in real-time)
--   • Code actions (quick fixes, refactorings)
--   • Rename symbols across the project
--
-- HOW IT WORKS (Neovim 0.11+):
--   1. mason.nvim         — Downloads and manages language servers (like pacman for LSP)
--   2. mason-lspconfig    — Bridge: tells mason which servers to install
--   3. nvim-lspconfig     — Provides default configs for servers (cmd, filetypes, root_dir)
--   4. vim.lsp.enable()   — Native Neovim API to activate servers (replaces old lspconfig.setup())
--
-- USEFUL COMMANDS:
--   :Mason               → UI to manage installed servers
--   :LspInfo              → show active LSP clients for current buffer
--   :LspLog               → view LSP debug logs
--
-- ADDING A NEW LANGUAGE:
--   1. Add the server name to ensure_installed (mason-lspconfig) below
--   2. Add vim.lsp.enable("server_name") at the bottom
--   3. Run :Lazy sync, then :Mason to verify installation
--   Full list of servers: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {

  -- ---------------------------------------------------------------------------
  -- MASON — LSP Server Installer
  -- ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  -- ---------------------------------------------------------------------------
  -- MASON-LSPCONFIG — Bridge between mason and lspconfig
  -- ---------------------------------------------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- Servers to install automatically.
        -- Add more as you need them — find names with :Mason
        ensure_installed = {
          "pyright",       -- Python
          "lua_ls",        -- Lua (Neovim config)
        },
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- NVIM-LSPCONFIG — Default Server Configurations + Keymaps + Enable
  -- ---------------------------------------------------------------------------
  -- Provides default configs (cmd, filetypes, root_dir) for each server.
  -- Also sets up LSP keymaps and enables servers via Neovim 0.11+ native API.
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- LSP KEYMAPS — only active in buffers with an attached LSP server
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = function(desc)
            return { buffer = ev.buf, desc = "LSP: " .. desc }
          end

          local keymap = vim.keymap

          -- NAVIGATION
          keymap.set("n", "gd", vim.lsp.buf.definition,      opts("Go to definition"))
          keymap.set("n", "gr", vim.lsp.buf.references,       opts("Show references"))
          keymap.set("n", "K",  vim.lsp.buf.hover,            opts("Hover documentation"))

          -- ACTIONS
          keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename,      opts("Rename symbol"))

          -- DIAGNOSTICS
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts("Line diagnostics"))
          keymap.set("n", "[d", vim.diagnostic.goto_prev,         opts("Previous diagnostic"))
          keymap.set("n", "]d", vim.diagnostic.goto_next,         opts("Next diagnostic"))
        end,
      })

      -- CMP CAPABILITIES — tell LSP servers about nvim-cmp's extended features
      -- Without this, servers won't send snippet completions or extra detail.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- LUA_LS CONFIG — special settings for Neovim Lua development
      -- Without this, lua_ls would flag `vim` as an undefined global.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })

      -- ENABLE SERVERS — Neovim 0.11+ native API
      -- vim.lsp.enable() tells Neovim to start this server for matching filetypes.
      -- The server config (cmd, filetypes, root_dir) comes from nvim-lspconfig.
      -- Add new servers here after adding them to ensure_installed above.
      vim.lsp.enable({ "pyright", "lua_ls" })
    end,
  },
}
