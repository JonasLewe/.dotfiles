-- ========= Neovim Configuration =========
-- Leader muss vor lazy.nvim gesetzt werden!
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Lade Konfigurationen
require("config.options")
require("config.lazy")
require("config.keymaps")
