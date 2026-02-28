-- =============================================================================
-- CODE NAVIGATION PLUGINS
-- =============================================================================
-- Plugins for navigating code structure and diagnostics.

return {

  -- ---------------------------------------------------------------------------
  -- AERIAL.NVIM — Symbol Sidebar
  -- ---------------------------------------------------------------------------
  -- Shows a sidebar with all symbols (functions, classes, variables) in the
  -- current file. Uses Treesitter and LSP to understand code structure.
  --
  -- USAGE:
  --   <leader>cs  → toggle sidebar (opens on the right)
  --   Navigate with j/k inside the sidebar, Enter to jump to symbol.
  --   The sidebar auto-highlights the symbol closest to your cursor.
  --
  -- COMMANDS:
  --   :AerialToggle  → toggle sidebar
  --   :AerialInfo    → debug: show what backends are active
  {
    "stevearc/aerial.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("aerial").setup({
        -- Use Treesitter first (works without LSP), fall back to LSP
        backends = { "treesitter", "lsp" },

        -- Sidebar layout
        layout = {
          default_direction = "right",
          min_width = 30,
        },

        -- Keep sidebar open when jumping to a symbol (close with <leader>cs or <leader>sx)
        close_on_select = false,

        -- Show which symbol you're currently in on the statusline
        show_guides = true,
      })

      vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle<CR>", { desc = "Toggle symbol sidebar" })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- TROUBLE.NVIM — Diagnostics Panel
  -- ---------------------------------------------------------------------------
  -- Pretty list of diagnostics (errors, warnings), references, quickfix, etc.
  -- Shows all problems in one organized panel at the bottom of the screen.
  --
  -- USAGE:
  --   <leader>xx  → toggle diagnostics panel
  --   Navigate with j/k, Enter to jump to the problem.
  --
  -- COMMANDS:
  --   :Trouble diagnostics toggle  → toggle panel
  --   :Trouble symbols toggle      → symbol outline (alternative to aerial)
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    -- keys spec: lazy.nvim registriert diese Keymaps sofort beim Start,
    -- und laedt das Plugin erst wenn man sie drueckt
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Toggle diagnostics panel" },
    },
    config = function()
      require("trouble").setup()
    end,
  },
}
