local keymap = vim.keymap

keymap.set("i", "kj", "<Esc>", { desc = "Exit insert mode" })
keymap.set("v", "kj", "<Esc>", { desc = "Exit visual mode" })

-- LazyGit needs kj itself, so terminal escape is buffer-local and delayed.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("UserTerminalKeymaps", { clear = true }),
  callback = function(args)
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      local bufname = vim.api.nvim_buf_get_name(args.buf)
      if not bufname:match("lazygit") then
        vim.keymap.set("t", "kj", "<C-\\><C-n>", { buffer = args.buf, desc = "Exit terminal mode" })
      end
    end, 100)
  end,
})

keymap.set("n", "<leader><space>", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "x", '"_x', { desc = "Delete char (no yank)" })
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

keymap.set("n", "<C-Left>", ":vertical resize +3<CR>", { silent = true, desc = "Resize split ←" })
keymap.set("n", "<C-Right>", ":vertical resize -3<CR>", { silent = true, desc = "Resize split →" })
keymap.set("n", "<C-Up>", ":resize -3<CR>", { silent = true, desc = "Resize split ↑" })
keymap.set("n", "<C-Down>", ":resize +3<CR>", { silent = true, desc = "Resize split ↓" })

keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" })

keymap.set("n", "<leader>tt", ":new | term<CR>", { desc = "Open terminal split" })
keymap.set("n", "<leader>e", ":Lex<CR>", { desc = "Toggle file explorer (netrw)" })
keymap.set("n", "<leader>E", ":Lex %:p:h<CR>", { desc = "Open file explorer in current file dir (netrw)" })

-- netrw reserves Ctrl-l for refresh; keep split navigation consistent there.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "<C-h>", "<C-w>h", { buffer = true })
    vim.keymap.set("n", "<C-j>", "<C-w>j", { buffer = true })
    vim.keymap.set("n", "<C-k>", "<C-w>k", { buffer = true })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true })
  end,
})
