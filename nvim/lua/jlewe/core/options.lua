-- =============================================================================
-- NEOVIM OPTIONS
-- =============================================================================
-- vim.opt is the modern Lua API for setting Neovim options.
-- Equivalent to :set in Vimscript (e.g. vim.opt.number = true == :set number)

-- Leader key: the "namespace" for custom keymaps.
-- Space is the most ergonomic choice — it's large and does nothing by default.
-- Must be set BEFORE lazy.nvim loads plugins (some plugins read it at load time).
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- -----------------------------------------------------------------------------
-- LINE NUMBERS
-- -----------------------------------------------------------------------------
-- number: show absolute line number on the current line
-- relativenumber: show relative line numbers on all other lines
-- Why relative? Lets you jump exactly N lines with e.g. "5j" or "12k"
-- without counting. Essential for efficient Vim movement.
opt.relativenumber = true
opt.number = true

-- -----------------------------------------------------------------------------
-- TABS & INDENTATION
-- -----------------------------------------------------------------------------
-- tabstop: how many spaces a <Tab> character counts as visually
-- shiftwidth: how many spaces >> and << indent/unindent
-- Keep both in sync to avoid confusing mixed-indent files.
opt.tabstop = 4
opt.shiftwidth = 4

-- smarttab: pressing <Tab> at line start inserts shiftwidth spaces
-- smartindent: auto-indent new lines based on previous line's syntax
opt.smarttab = true
opt.smartindent = true

-- -----------------------------------------------------------------------------
-- LINE WRAPPING
-- -----------------------------------------------------------------------------
-- Disable soft line wrapping. Long lines extend off-screen instead of
-- wrapping visually. Use "ze"/"zs" to scroll horizontally, or enable
-- wrap temporarily with :set wrap
opt.wrap = false

-- -----------------------------------------------------------------------------
-- SEARCH
-- -----------------------------------------------------------------------------
-- ignorecase: /foo matches Foo, FOO, foo
-- smartcase: if you type a capital, case becomes sensitive (/Foo won't match foo)
-- Together: lowercase = case-insensitive, any uppercase = case-sensitive.
opt.ignorecase = true
opt.smartcase = true

-- -----------------------------------------------------------------------------
-- CURSOR & SCROLLING
-- -----------------------------------------------------------------------------
-- cursorline: highlight the entire line the cursor is on (easier to spot cursor)
-- scrolloff: always keep N lines visible above/below cursor when scrolling
-- 8 is a good value — you see context above and below without jumping.
opt.cursorline = true
opt.scrolloff = 8

-- -----------------------------------------------------------------------------
-- APPEARANCE
-- -----------------------------------------------------------------------------
-- termguicolors: enable 24-bit RGB colors (requires a modern terminal)
-- Without this, only 256 colors are available and themes look wrong.
opt.termguicolors = true
opt.background = "dark"

-- signcolumn: always reserve a column on the left for signs (git changes,
-- LSP diagnostics). "yes" prevents the text from jumping left/right
-- when signs appear or disappear.
opt.signcolumn = "yes"

-- Built-in colorscheme. No plugin needed.
-- Other good built-ins: default, slate, desert, evening, industry
-- Run :colorscheme <Tab> to browse all installed schemes.
vim.cmd("colorscheme habamax")

-- -----------------------------------------------------------------------------
-- BACKSPACE BEHAVIOR
-- -----------------------------------------------------------------------------
-- Allow backspace to delete: auto-indent, line breaks, and text before insert started.
-- Without this, backspace can feel "stuck" in certain situations.
opt.backspace = "indent,eol,start"

-- -----------------------------------------------------------------------------
-- CLIPBOARD
-- -----------------------------------------------------------------------------
-- "unnamedplus" syncs Neovim's default register with the system clipboard.
-- This means yank/paste works with Ctrl+C/Ctrl+V in other applications.
-- Requires xclip/xsel on Linux or pbcopy on macOS to be installed.
opt.clipboard:append("unnamedplus")

-- -----------------------------------------------------------------------------
-- SPLITS
-- -----------------------------------------------------------------------------
-- Open vertical splits to the right, horizontal splits below.
-- Matches the natural reading direction (left→right, top→bottom).
opt.splitright = true
opt.splitbelow = true

-- -----------------------------------------------------------------------------
-- WORD CHARACTERS
-- -----------------------------------------------------------------------------
-- Treat hyphen as part of a word. Useful for CSS classes (e.g. "my-class"),
-- kebab-case variables, etc. — "dw" deletes the whole word including hyphens.
opt.iskeyword:append("-")

-- -----------------------------------------------------------------------------
-- PERSISTENT UNDO
-- -----------------------------------------------------------------------------
-- Save undo history to disk so you can undo changes even after closing a file.
-- History is stored in ~/.local/state/nvim/undo/ automatically.
opt.undofile = true

-- -----------------------------------------------------------------------------
-- PERFORMANCE
-- -----------------------------------------------------------------------------
-- updatetime: milliseconds of inactivity before CursorHold event fires.
-- Lower value = faster LSP diagnostics and git signs updates.
-- Default is 4000ms (4 seconds) which feels slow. 250ms is snappy.
opt.updatetime = 250

-- timeoutlen: milliseconds to wait for a key sequence to complete.
-- Affects which-key popup delay and multi-key mappings like "kj".
-- Lower = faster, but too low can make it hard to type key combos.
opt.timeoutlen = 300

-- -----------------------------------------------------------------------------
-- TERMINAL FIX
-- -----------------------------------------------------------------------------
-- Force Neovim to restore the terminal's alternate screen on exit.
-- Prevents the editor content from lingering in the terminal after :q
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    io.write("\27[?1049l")
  end,
})
