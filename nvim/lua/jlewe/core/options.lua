vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- No configured plugin needs legacy remote-plugin hosts.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smarttab = true
opt.smartindent = true

opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.scrolloff = 8

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "html", "helm", "sass", "scss", "yaml" },
  callback = function()
    vim.opt_local.iskeyword:append("-")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "helm", "json", "jsonc", "lua", "markdown", "yaml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

opt.path:append("**")
opt.wildmenu = true
opt.wildignorecase = true
opt.wildignore:append("**/node_modules/**,**/.git/**,**/venv/**,**/__pycache__/**")

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 1
vim.g.netrw_winsize = 25

-- Work around netrw v184 keeping a closed Lexplore target in g:netrw_chgwin.
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

opt.undofile = true

if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

opt.updatetime = 250
opt.timeoutlen = 650

-- Restore the terminal's alternate screen when a UI exits.
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    if #vim.api.nvim_list_uis() > 0 then
      io.write("\27[?1049l")
    end
  end,
})
