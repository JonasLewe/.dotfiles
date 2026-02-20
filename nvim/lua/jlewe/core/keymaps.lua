local keymap = vim.keymap

---------------------
-- General Keymaps
---------------------

-- use kj to exit insert/visual/terminal mode
keymap.set("i", "kj", "<ESC>")
keymap.set("v", "kj", "<ESC>")
keymap.set("t", "kj", "<C-\\><C-n>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v")       -- split vertikal
keymap.set("n", "<leader>sh", "<C-w>s")       -- split horizontal
keymap.set("n", "<leader>se", "<C-w>=")       -- splits gleich gross
keymap.set("n", "<leader>sx", ":close<CR>")   -- split schliessen

-- tabs
keymap.set("n", "<leader>to", ":tabnew<CR>")
keymap.set("n", "<leader>tx", ":tabclose<CR>")
keymap.set("n", "<leader>tn", ":tabn<CR>")
keymap.set("n", "<leader>tp", ":tabp<CR>")

-- resize splits
keymap.set("n", "<C-Left>", ":vertical resize +3<CR>", { silent = true })
keymap.set("n", "<C-Right>", ":vertical resize -3<CR>", { silent = true })
keymap.set("n", "<C-Up>", ":resize -3<CR>", { silent = true })
keymap.set("n", "<C-Down>", ":resize +3<CR>", { silent = true })

-- terminal
keymap.set("n", "<leader>tt", ":new | term<CR>")

----------------------
-- Plugin Keybinds
----------------------

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")
