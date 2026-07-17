return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer local keymaps",
      },
    },
    opts = {
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug/diagnostics" },
        { "<leader>f", group = "find" },
        { "<leader>h", group = "git hunks" },
        { "<leader>l", group = "lazy" },
        { "<leader>n", group = "notebook" },
        { "<leader>p", group = "pomodoro" },
        { "<leader>s", group = "splits" },
        { "<leader>t", group = "tabs/terminal" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },
  { "tpope/vim-surround" },
}
