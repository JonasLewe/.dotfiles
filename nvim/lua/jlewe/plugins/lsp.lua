return {
  "williamboman/mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright",
        "ts_ls",
        "yamlls",
        "helm_ls",
        "dockerls",
        "lua_ls",
      },
      automatic_installation = true,
    })

    -- LSP keybinds via LspAttach autocmd (replaces on_attach callback)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
      end,
    })

    -- Diagnostic signs
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Capabilities from cmp for all servers
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- lua_ls needs special config for Neovim runtime
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

    -- Enable all servers
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
