-- ========= Vim Options =========
local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true
o.termguicolors = true
o.signcolumn = "yes"
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8

-- Splits
o.splitright = true
o.splitbelow = true

-- Tabs & Indentation
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true

-- System
o.mouse = "a"
o.clipboard = "unnamedplus"
o.updatetime = 250
o.timeoutlen = 300
o.undofile = true
o.backup = false
o.swapfile = false

-- Completion
o.completeopt = "menuone,noselect"
o.pumheight = 10
