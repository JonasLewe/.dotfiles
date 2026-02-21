-- =============================================================================
-- LAZY.NVIM — PLUGIN MANAGER
-- =============================================================================
-- lazy.nvim is the standard plugin manager for Neovim. It:
--   • Downloads and updates plugins from GitHub automatically
--   • Only loads plugins when they are actually needed (lazy loading)
--     → faster startup time
--   • Provides a UI at :Lazy to manage everything
--
-- HOW IT WORKS:
--   1. On first launch, this script clones lazy.nvim itself into:
--      ~/.local/share/nvim/lazy/lazy.nvim
--   2. lazy.nvim then reads all files in lua/jlewe/plugins/ and installs
--      any plugins defined there
--   3. Plugins are stored in: ~/.local/share/nvim/lazy/
--
-- USEFUL COMMANDS (run inside Neovim):
--   :Lazy          → open the plugin manager UI
--   :Lazy sync     → install missing + update + clean unused plugins
--   :Lazy update   → update all plugins
--   :Lazy clean    → remove plugins no longer in config

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap: if lazy.nvim is not installed yet, clone it
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end

-- Add lazy.nvim to Neovim's runtime path so it can be required
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
  -- Load all plugin specs from lua/jlewe/plugins/ automatically.
  -- Each .lua file there should return a plugin spec table.
  { import = "jlewe.plugins" },
  {
    -- Don't auto-check for plugin updates on startup (do it manually with :Lazy)
    checker = { enabled = false },
    -- Don't show a notification when config files change
    change_detection = { notify = false },
  }
)
