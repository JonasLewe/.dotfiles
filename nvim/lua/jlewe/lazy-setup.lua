local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "jlewe.plugins" },
  { import = "jlewe.plugins.optional" },
}, {
  checker = { enabled = false },
  change_detection = { notify = false },
  -- Keep application-provided runtime files. Ghostty exposes its filetype,
  -- syntax, compiler, and comment settings through an XDG runtime directory.
  performance = { rtp = { reset = false } },
  rocks = { enabled = false },
})
