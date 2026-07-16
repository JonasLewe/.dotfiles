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

-- No configured plugin needs legacy remote-plugin hosts. Disabling them avoids
-- useless provider discovery and keeps :checkhealth focused on real features.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

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
opt.softtabstop = 4
opt.expandtab = true

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

-- signcolumn: always reserve a column on the left for signs.
-- "yes" prevents the text from jumping left/right when signs appear.
opt.signcolumn = "yes"

-- Colorscheme is set by the cyberdream plugin (plugins/colorscheme.lua).
-- It loads with priority 1000 so it's available before other plugins.

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
-- Hyphen is a word character only in formats where kebab-case is idiomatic.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "html", "helm", "sass", "scss", "yaml" },
  callback = function()
    vim.opt_local.iskeyword:append("-")
  end,
})

-- Use ecosystem defaults while retaining four spaces for Python and shell.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "helm", "json", "jsonc", "lua", "markdown", "yaml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- -----------------------------------------------------------------------------
-- FILE FINDING
-- -----------------------------------------------------------------------------
-- path+=** lets :find search recursively through subdirectories.
-- wildmenu shows a visual menu when pressing Tab to autocomplete commands.
-- wildignorecase makes :find case-insensitive on filenames.
opt.path:append("**")
opt.wildmenu = true
opt.wildignorecase = true
opt.wildignore:append("**/node_modules/**,**/.git/**,**/venv/**,**/__pycache__/**")

-- -----------------------------------------------------------------------------
-- NETRW (BUILT-IN FILE EXPLORER)
-- -----------------------------------------------------------------------------
-- netrw is Vim's built-in file browser. Open with :Ex, :Vex, :Lex
-- banner=0 hides the info banner at the top (cleaner look)
-- liststyle=1 shows files as a long listing (name + size + date)
-- winsize=25 sets the explorer width to 25% when used in a split (:Lex, :Vex)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 1
vim.g.netrw_winsize = 25

-- Lexplore keeps the window number where selected files should be opened in
-- g:netrw_chgwin. Netrw v184 generates an invalid `wincmd` when that target
-- window is closed and only the explorer remains. Resetting the stale target
-- makes the selected file open in the remaining window instead.
vim.api.nvim_create_autocmd("WinClosed", {
  group = vim.api.nvim_create_augroup("UserNetrwWindowGuard", { clear = true }),
  callback = function()
    local tabpage = vim.api.nvim_get_current_tabpage()
    vim.schedule(function()
      if not vim.api.nvim_tabpage_is_valid(tabpage) then
        return
      end

      local windows = vim.api.nvim_tabpage_list_wins(tabpage)
      if #windows ~= 1 then
        return
      end

      local buffer = vim.api.nvim_win_get_buf(windows[1])
      if vim.bo[buffer].filetype == "netrw" then
        vim.g.netrw_chgwin = -1
      end
    end)
  end,
})

-- -----------------------------------------------------------------------------
-- PERSISTENT UNDO
-- -----------------------------------------------------------------------------
-- Save undo history to disk so you can undo changes even after closing a file.
-- History is stored in ~/.local/state/nvim/undo/ automatically.
opt.undofile = true

-- -----------------------------------------------------------------------------
-- GREP PROGRAM
-- -----------------------------------------------------------------------------
-- Use ripgrep for :grep if available (much faster than default grep).
-- Results populate the quickfix list: :copen, :cn, :cp to navigate.
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- -----------------------------------------------------------------------------
-- PERFORMANCE
-- -----------------------------------------------------------------------------
-- updatetime: milliseconds of inactivity before CursorHold event fires.
-- Default is 4000ms (4 seconds) which feels slow. 250ms is snappy.
opt.updatetime = 250

-- timeoutlen: milliseconds to wait for a key sequence to complete.
-- Affects leader mappings and the kj escape sequence.
-- Lower = faster, but too low can make it hard to type key combos.
opt.timeoutlen = 650

-- -----------------------------------------------------------------------------
-- TERMINAL FIX
-- -----------------------------------------------------------------------------
-- Force Neovim to restore the terminal's alternate screen on exit.
-- Prevents the editor content from lingering in the terminal after :q
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    if #vim.api.nvim_list_uis() > 0 then
      io.write("\27[?1049l")
    end
  end,
})
