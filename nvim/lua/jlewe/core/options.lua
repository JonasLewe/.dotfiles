vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.smarttab = true
opt.smartindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true
opt.scrolloff = 8

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
vim.cmd("colorscheme habamax")

-- backspace
opt.backspace = "indent,eol,start"

-- use system clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

-- persistent undo
opt.undofile = true

-- faster CursorHold events and swap file writes
opt.updatetime = 250

-- faster key sequence completion (also affects which-key popup delay)
opt.timeoutlen = 300

-- force alternate screen buffer restoration on exit
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    io.write("\27[?1049l")
  end,
})
