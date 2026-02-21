-- =============================================================================
-- KEYMAPS
-- =============================================================================
-- vim.keymap.set(mode, lhs, rhs, opts)
--   mode: "n" = normal, "i" = insert, "v" = visual, "t" = terminal
--   lhs:  the key(s) you press
--   rhs:  what happens (a command string or a Lua function)
--   opts: table of options, most useful ones:
--     { silent = true }  → don't echo the command to the command line
--     { desc = "..." }   → description shown in which-key popup
--
-- The leader key (<leader>) is set to Space in options.lua.
-- So <leader>ff means: press Space, then f, then f.

local keymap = vim.keymap

-- =============================================================================
-- GENERAL
-- =============================================================================

-- EXIT INSERT/VISUAL/TERMINAL MODE
-- "kj" pressed quickly is much more ergonomic than reaching for Escape.
-- The key sequence must be typed fast (within timeoutlen = 300ms).
-- You can still use Escape — this is just an additional shortcut.
keymap.set("i", "kj", "<ESC>",        { desc = "Exit insert mode" })
keymap.set("v", "kj", "<ESC>",        { desc = "Exit visual mode" })
keymap.set("t", "kj", "<C-\\><C-n>",  { desc = "Exit terminal mode" }) -- terminal needs special sequence

-- CLEAR SEARCH HIGHLIGHTS
-- After searching with /, all matches stay highlighted until you clear them.
-- <leader>nh removes the highlight without changing anything else.
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- DELETE WITHOUT YANKING
-- Normally "x" cuts the character into the default register (you could paste it).
-- '"_x' sends it to the black hole register (_ ) — a true delete, no yank.
keymap.set("n", "x", '"_x', { desc = "Delete char (no yank)" })

-- INCREMENT / DECREMENT NUMBERS
-- Place cursor on a number and press <leader>+ or <leader>- to change it.
-- Default Vim bindings are <C-a>/<C-x> but those conflict with the tmux prefix.
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- =============================================================================
-- WINDOW / SPLIT MANAGEMENT
-- =============================================================================
-- In Neovim, a "window" is a viewport (split pane). A "buffer" is the file.
-- You can have many windows showing the same or different buffers.

-- CREATE SPLITS
-- sv = split vertical (side by side), sh = split horizontal (top/bottom)
keymap.set("n", "<leader>sv", "<C-w>v",       { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s",       { desc = "Split window horizontally" })

-- Equalize all split sizes (useful after resizing or adding splits)
keymap.set("n", "<leader>se", "<C-w>=",       { desc = "Equalize split sizes" })

-- Close the current split (not the buffer — just this window pane)
keymap.set("n", "<leader>sx", ":close<CR>",   { desc = "Close current split" })

-- NAVIGATE BETWEEN SPLITS
-- Ctrl+hjkl moves between splits without needing the <C-w> prefix.
-- Much faster than the default <C-w> h/j/k/l.
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- RESIZE SPLITS
-- Hold Ctrl and press arrow keys to resize the current split incrementally.
keymap.set("n", "<C-Left>",  ":vertical resize +3<CR>", { silent = true, desc = "Resize split ←" })
keymap.set("n", "<C-Right>", ":vertical resize -3<CR>", { silent = true, desc = "Resize split →" })
keymap.set("n", "<C-Up>",    ":resize -3<CR>",          { silent = true, desc = "Resize split ↑" })
keymap.set("n", "<C-Down>",  ":resize +3<CR>",          { silent = true, desc = "Resize split ↓" })

-- =============================================================================
-- TABS
-- =============================================================================
-- Neovim tabs are like separate workspaces, each with their own layout of splits.
-- Different from VS Code tabs — those are more like Neovim buffers.

keymap.set("n", "<leader>to", ":tabnew<CR>",   { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>",     { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>",     { desc = "Go to previous tab" })

-- =============================================================================
-- TERMINAL
-- =============================================================================
-- Open a small terminal split at the bottom of the screen.
-- Switch back to normal mode with: kj  or  Ctrl+\ Ctrl+n
keymap.set("n", "<leader>tt", ":new | term<CR>", { desc = "Open terminal split" })

-- =============================================================================
-- PLUGIN KEYBINDS
-- =============================================================================

-- NVIM-TREE: keymap is defined in nvim-tree.lua (inside the lazy `keys` spec)
-- so that lazy.nvim loads the plugin before executing the command.

-- TELESCOPE (fuzzy finder — find anything, fast)
-- ff = find files by name
-- fs = search text inside files (like grep)
-- fc = search for the word currently under the cursor
-- fb = switch between open buffers
-- fh = search Neovim's built-in help documentation
-- fr = recently opened files
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",   { desc = "Search in files" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Search word under cursor" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Find open buffers" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Search Neovim help" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    { desc = "Recent files" })
