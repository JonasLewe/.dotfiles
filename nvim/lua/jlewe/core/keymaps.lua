local keymap = vim.keymap

keymap.set("i", "kj", "<Esc>", { desc = "Exit insert mode" })
keymap.set("v", "kj", "<Esc>", { desc = "Exit visual mode" })

-- Terminal tools can opt out via b:terminal_passthrough; LazyGit also needs kj itself.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("UserTerminalKeymaps", { clear = true }),
  callback = function(args)
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      local bufname = vim.api.nvim_buf_get_name(args.buf)
      if not bufname:match("lazygit") and not vim.b[args.buf].terminal_passthrough then
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

keymap.set("n", "<leader>tt", function()
  local file = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()

  if vim.bo.buftype == "terminal" then
    -- Terminal names are term://{cwd}//{pid}:{command}, not file paths.
    local terminal_dir = file:match("^term://(.-)//%d+:")
    if terminal_dir then
      cwd = vim.fn.fnamemodify(terminal_dir, ":p")
    end
  elseif vim.bo.buftype == "" and file ~= "" then
    cwd = vim.fs.dirname(file)
  end

  if vim.fn.isdirectory(cwd) == 0 then
    cwd = vim.fn.getcwd()
  end

  vim.cmd.new()
  vim.fn.jobstart({ vim.o.shell }, { cwd = cwd, term = true })
  vim.cmd.startinsert()
end, { desc = "Open terminal split in current file directory" })
local function toggle_explorer(use_cwd)
  -- An explicit Lexplore path updates an open sidebar instead of closing it.
  local explorer = vim.t.netrw_lexbufnr
  if explorer and vim.fn.bufwinid(explorer) ~= -1 then
    vim.cmd.Lexplore()
    return
  end

  local cwd = vim.fn.getcwd()
  local dir = cwd
  local file = vim.api.nvim_buf_get_name(0)
  if not use_cwd and vim.bo.buftype == "" and file ~= "" and not file:match("^%a[%w+.-]*://") then
    dir = vim.fs.dirname(file)
  end
  if vim.fn.isdirectory(dir) == 0 then
    dir = cwd
  end
  vim.cmd("Lexplore " .. vim.fn.fnameescape(dir))
end

keymap.set("n", "<leader>e", function()
  toggle_explorer(false)
end, { desc = "Toggle file explorer in current file directory (netrw)" })
keymap.set("n", "<leader>E", function()
  toggle_explorer(true)
end, { desc = "Toggle file explorer in working directory (netrw)" })

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
