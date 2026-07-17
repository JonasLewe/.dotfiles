-- Load the transparent theme before plugins consume highlight groups.

return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = true,
      italic_comments = true,
      borderless_pickers = true,
      terminal_colors = true,
      extensions = {
        default = false,
        dapui = true,
        gitsigns = true,
        lazy = true,
        notify = true,
        telescope = true,
        treesitter = true,
        trouble = true,
        whichkey = true,
      },
    })
    vim.cmd("colorscheme cyberdream")
  end,
}
