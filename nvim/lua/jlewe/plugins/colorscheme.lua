-- =============================================================================
-- COLORSCHEME — cyberdream
-- =============================================================================
-- A high-contrast, modern dark theme designed for terminals with transparency.
-- transparent = true makes the background invisible so the terminal wallpaper
-- shows through (works with Ghostty's transparency setting).
--
-- priority = 1000 ensures this loads before other plugins so colors are
-- available immediately (some plugins read highlight groups at startup).
--
-- To switch colorscheme temporarily: :colorscheme <Tab> to browse available.
-- To switch permanently: change the vim.cmd line below.

return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = true,
      italic_comments = true,
      borderless_telescope = true,
      terminal_colors = true,
    })
    vim.cmd("colorscheme cyberdream")
  end,
}
