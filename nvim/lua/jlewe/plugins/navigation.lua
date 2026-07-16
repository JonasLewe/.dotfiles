-- =============================================================================
-- CODE NAVIGATION PLUGINS
-- =============================================================================
-- Plugins for navigating code structure and diagnostics.

return {
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
  --   :Trouble symbols toggle      → symbol outline
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    -- keys spec: lazy.nvim registriert diese Keymaps sofort beim Start,
    -- und laedt das Plugin erst wenn man sie drueckt
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Toggle diagnostics panel" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<CR>", desc = "Toggle document symbols" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<CR>", desc = "Toggle document symbols" },
    },
    config = function()
      require("trouble").setup()
    end,
  },
}
