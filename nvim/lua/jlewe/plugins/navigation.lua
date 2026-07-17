return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Toggle diagnostics panel" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<CR>", desc = "Toggle document symbols" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<CR>", desc = "Toggle document symbols" },
    },
    config = function()
      require("trouble").setup()
    end,
  },
}
