-- Mason installs servers; nvim-lspconfig supplies definitions; Neovim runs them.

local tooling = require("jlewe.tooling")

return {

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    opts = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = tooling.lsp_servers,
      -- Never auto-enable every package left in Mason's install directory.
      automatic_enable = tooling.lsp_servers,
    },
  },

  {
    "neovim/nvim-lspconfig",
    -- Do not load LSP for an empty editor. For a file, defer activation until
    -- VimEnter so server discovery stays off the first-render path.
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- Mason is command-lazy, but its tools must still be visible to LSP,
      -- formatters, linters, and debug adapters.
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      end
    end,
    config = function()
      local function setup_lsp()
        -- LSP KEYMAPS — only active in buffers with an attached LSP server
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = function(ev)
            local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
            local opts = function(desc)
              return { buffer = ev.buf, desc = "LSP: " .. desc }
            end

            -- Preserve the established mappings. Neovim's newer native aliases
            -- (grr, gri, grn, gra, gO, and <C-w>d) remain available too.
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Show references"))
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts("Line diagnostics"))
            vim.keymap.set("n", "[d", function()
              vim.diagnostic.jump({ count = -1 })
            end, opts("Previous diagnostic"))
            vim.keymap.set("n", "]d", function()
              vim.diagnostic.jump({ count = 1 })
            end, opts("Next diagnostic"))

            -- Neovim 0.12 handles LSP completion and snippets natively. Manual
            -- completion is <C-Space>; compatibility mappings retain the old
            -- Tab/Shift-Tab/Enter workflow without bringing nvim-cmp back.
            if client:supports_method("textDocument/completion") then
              vim.opt_local.completeopt = { "menuone", "noselect", "popup" }
              vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
              vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, opts("Trigger completion"))
              vim.keymap.set("i", "<Tab>", function()
                return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
              end, { buffer = ev.buf, expr = true, desc = "Completion: next item" })
              vim.keymap.set("i", "<S-Tab>", function()
                return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
              end, { buffer = ev.buf, expr = true, desc = "Completion: previous item" })
              vim.keymap.set("i", "<CR>", function()
                local selected = vim.fn.complete_info({ "selected" }).selected
                return vim.fn.pumvisible() == 1 and selected >= 0 and "<C-y>" or "<CR>"
              end, { buffer = ev.buf, expr = true, desc = "Completion: confirm selected item" })
            end
          end,
        })

        -- LUA_LS CONFIG — special settings for Neovim Lua development
        -- Without this, lua_ls would flag `vim` as an undefined global.
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
              workspace = {
                -- Avoid making lua_ls index every plugin in runtimepath.
                library = { vim.env.VIMRUNTIME, vim.fn.stdpath("config") },
              },
            },
          },
        })

        vim.lsp.enable(tooling.lsp_servers)
      end

      if vim.v.vim_did_enter == 1 then
        setup_lsp()
      else
        vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = setup_lsp })
      end
    end,
  },
}
