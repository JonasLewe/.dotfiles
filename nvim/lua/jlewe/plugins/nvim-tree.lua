-- =============================================================================
-- NVIM-TREE — FILE EXPLORER
-- =============================================================================
-- A file explorer sidebar, similar to VS Code's file tree.
-- Toggle it with <leader>e.
--
-- KEYMAPS INSIDE THE TREE:
--   <CR> or o   → open file / expand folder
--   a           → create new file or directory (end with / for directory)
--   d           → delete file
--   r           → rename file
--   x           → cut
--   c           → copy
--   p           → paste
--   R           → refresh tree
--   H           → toggle hidden (dotfiles) visibility
--   I           → toggle gitignored files visibility
--   ?           → show all keymaps

return {
  "nvim-tree/nvim-tree.lua",

  -- Only load when the keymap or command triggers it
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = { { "<leader>e" } },

  -- Provides file type icons (requires a Nerd Font in your terminal)
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    -- Disable netrw — Neovim's built-in (and inferior) file browser.
    -- nvim-tree replaces it completely.
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      renderer = {
        icons = {
          show = {
            -- Show git status icons next to files (M = modified, ? = untracked, etc.)
            git = true,
          },
        },
      },

      filters = {
        -- Show dotfiles (files starting with .) like .gitignore, .env
        dotfiles = false,
        -- Show files listed in .gitignore (e.g. node_modules, build output)
        -- Set to true if you want to hide them (cleaner view)
        git_ignored = false,
      },

      actions = {
        open_file = {
          -- Disable window picker so files always open in the last used window.
          -- The picker (which prompts you to choose a window) can be confusing.
          window_picker = {
            enable = false,
          },
        },
      },
    })
  end,
}
