-- =============================================================================
-- NEOVIM ENTRY POINT
-- =============================================================================
-- This is the first file Neovim loads. Think of it as the "main()" of your
-- config. It simply delegates to other modules in order:
--
--   1. options  → editor settings (line numbers, tabs, etc.)
--   2. keymaps  → custom key bindings
--   3. lazy     → plugin manager (loads all plugins from lua/jlewe/plugins/)
--
-- Why split into modules instead of one big file?
-- Easier to find things, easier to debug, easier to share individual parts.

require("jlewe.core.options")
require("jlewe.core.keymaps")
require("jlewe.lazy-setup")
