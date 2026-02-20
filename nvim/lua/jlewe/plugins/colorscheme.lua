return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
        borderless_telescope = true,
        terminal_colors = true,
      })
      vim.cmd("colorscheme cyberdream")
    end,
  },
  {
    "maxmx03/fluoromachine.nvim",
    lazy = true,
    config = function()
      require("fluoromachine").setup({
        glow = true,
        theme = "retrowave",
        transparent = true,
      })
    end,
  },
}
