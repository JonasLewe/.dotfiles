-- Dedicated formatters run on save; LSP remains the fallback.

local tooling = require("jlewe.tooling")

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ timeout_ms = 5000 })
      end,
      mode = { "n", "v" },
      desc = "Format code",
    },
  },
  opts = {
    formatters_by_ft = tooling.formatters_by_ft,
    default_format_opts = { lsp_format = "fallback" },

    format_on_save = {
      timeout_ms = 5000,
    },
  },
}
