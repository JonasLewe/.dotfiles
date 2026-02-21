-- =============================================================================
-- NVIM-CMP — AUTOCOMPLETION
-- =============================================================================
-- nvim-cmp provides the completion popup that appears as you type.
-- It aggregates suggestions from multiple "sources":
--   • nvim_lsp   → suggestions from the language server (most important)
--   • luasnip    → code snippets (type "fn<Tab>" to expand a function template)
--   • buffer     → words already present in the current file
--   • path       → file system paths (useful when typing import paths)
--
-- KEYMAPS IN THE COMPLETION POPUP:
--   <Tab>       → select next item / confirm snippet
--   <S-Tab>     → select previous item
--   <CR>        → confirm selected item (only if explicitly selected)
--   <C-e>       → close the popup without confirming
--   <C-Space>   → manually trigger completion (if it didn't open automatically)
--   <C-b>/<C-f> → scroll up/down in the documentation preview

return {
  "hrsh7th/nvim-cmp",

  -- Only load when entering insert mode (no overhead on startup)
  event = "InsertEnter",

  dependencies = {
    -- Completion sources (each adds a category of suggestions)
    "hrsh7th/cmp-buffer",       -- words from current buffer
    "hrsh7th/cmp-path",         -- file system paths
    "hrsh7th/cmp-nvim-lsp",     -- LSP suggestions (requires a running LSP server)

    -- Snippet engine — required for LSP snippet completions
    -- Many LSP servers return snippets (e.g. function signatures with placeholders)
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip", -- bridges LuaSnip with nvim-cmp

    -- Pre-built snippet collection (hundreds of snippets for common languages)
    "rafamadriz/friendly-snippets",
  },

  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load the friendly-snippets collection into LuaSnip
    require("luasnip.loaders.from_vscode").lazy_load()

    -- completeopt controls how the completion menu behaves:
    --   menu      → show the popup menu
    --   menuone   → show popup even when there's only one match
    --   noselect  → don't auto-select the first item (you must choose explicitly)
    vim.opt.completeopt = "menu,menuone,noselect"

    cmp.setup({
      -- Tell nvim-cmp to use LuaSnip for expanding snippet completions
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- Key mappings for the completion popup
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),              -- force open completion
        ["<C-e>"]     = cmp.mapping.abort(),                 -- close popup
        ["<CR>"]      = cmp.mapping.confirm({ select = false }), -- confirm (only if selected)
        ["<Tab>"]     = cmp.mapping.select_next_item(),      -- next suggestion
        ["<S-Tab>"]   = cmp.mapping.select_prev_item(),      -- previous suggestion
        ["<C-b>"]     = cmp.mapping.scroll_docs(-4),         -- scroll docs up
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),          -- scroll docs down
      }),

      -- Sources in priority order — nvim_lsp suggestions appear first
      sources = cmp.config.sources({
        { name = "nvim_lsp" },  -- language server (highest priority)
        { name = "luasnip" },   -- snippets
        { name = "buffer" },    -- words in current file
        { name = "path" },      -- file paths
      }),
    })
  end,
}
