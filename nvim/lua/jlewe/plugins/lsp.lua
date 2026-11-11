-- Mason installs servers; nvim-lspconfig supplies definitions; Neovim runs them.

local tooling = require("jlewe.tooling")

return {

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    opts = {
      registries = {
        "github:mkindberg/ghostty-ls",
        "github:mason-org/mason-registry",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = tooling.lsp_servers,
      -- setup_lsp below enables our servers after their definitions and custom
      -- settings are ready. Mason must not enable them earlier on BufReadPost.
      automatic_enable = false,
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

      -- Register before any plugin can attach a client (including obsidian-ls).
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
          local in_vault = require("jlewe.obsidian").contains(ev.buf)
          if in_vault and client.name == "obsidian-ls" then
            -- Marksman owns ordinary Markdown navigation, symbols and rename.
            -- Obsidian's commands still use its vault-aware resolver directly.
            for _, capability in ipairs({
              "definitionProvider",
              "referencesProvider",
              "documentSymbolProvider",
              "workspaceSymbolProvider",
              "renameProvider",
            }) do
              client.server_capabilities[capability] = false
            end
          end
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
            if client.name == "obsidian-ls" then
              -- Native completion on Neovim 0.12 needs triggers while typing links.
              local triggers = {}
              for char = 32, 126 do
                triggers[#triggers + 1] = string.char(char)
              end
              client.server_capabilities.completionProvider.triggerCharacters = triggers
            end
            -- Either server may attach last; keep the vault's completion options.
            vim.bo[ev.buf].completeopt = in_vault and "menuone,noselect,popup,fuzzy,nosort"
              or "menuone,noselect,popup"
            vim.lsp.completion.enable(true, client.id, ev.buf, {
              autotrigger = true,
              convert = in_vault and function()
                return { dup = 0 }
              end or nil,
            })
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
    end,
    config = function()
      local function setup_lsp()
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

        vim.lsp.config("yamlls", {
          settings = {
            yaml = {
              schemas = {
                -- GitLab accepts tags: [], but its upstream schema requires
                -- at least one tag. Prefer our patched schema over SchemaStore.
                [vim.uri_from_fname(vim.fn.stdpath("config") .. "/schemas/gitlab-ci.json")] = {
                  "**/.gitlab-ci.yml",
                  "**/.gitlab-ci.yaml",
                  "**/*.gitlab-ci.yml",
                  "**/*.gitlab-ci.yaml",
                },
              },
              customTags = {
                "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format",
              },
            },
          },
        })

        -- ghostty-ls lives in its own Mason registry and therefore has no
        -- nvim-lspconfig definition for mason-lspconfig to enable for us.
        vim.lsp.config("ghostty", {
          cmd = { "ghostty-ls" },
          filetypes = { "ghostty" },
        })

        vim.lsp.enable(tooling.lsp_servers)
        vim.lsp.enable("ghostty")
      end

      if vim.v.vim_did_enter == 1 then
        -- Finish the buffer's read/filetype events before enabling clients.
        vim.schedule(setup_lsp)
      else
        vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = setup_lsp })
      end
    end,
  },
}
