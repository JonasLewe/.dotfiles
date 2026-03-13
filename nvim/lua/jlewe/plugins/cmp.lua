-- =============================================================================
-- AUTOCOMPLETION — nvim-cmp + LuaSnip
-- =============================================================================
-- nvim-cmp provides intelligent autocompletion as you type.
-- It combines multiple sources:
--   • LSP (language server suggestions — functions, variables, types)
--   • LuaSnip (code snippets — for loops, function templates, etc.)
--   • Buffer (words from the current file)
--   • Path (filesystem path completion)
--
-- KEYBINDS IN INSERT MODE:
--   <C-Space>  — manually trigger completion menu
--   <C-e>      — dismiss/abort completion
--   <CR>       — confirm selected item (only if explicitly selected)
--   <Tab>      — select next item
--   <S-Tab>    — select previous item
--   <C-b/f>    — scroll docs up/down
--
-- WHY nvim-cmp OVER BUILT-IN COMPLETION (<C-x><C-n>):
--   Built-in completion only offers one source at a time and has no fuzzy matching.
--   nvim-cmp merges all sources into a single popup with fuzzy ranking.

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    vim.opt.completeopt = "menu,menuone,noselect"

    -- autopairs integration: add () after selecting a function from completion
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
}
