-- =============================================================================
-- CONFORM.NVIM — Code Formatting
-- =============================================================================
-- Auto-formats code on save using external formatters (black, prettier, etc.).
-- Uses the same formatters you'd use on the command line, but runs them
-- automatically inside Neovim.
--
-- WHY NOT JUST LSP?
--   LSP servers CAN format, but dedicated formatters are better:
--   - black is the Python standard, not pyright
--   - prettier is the JS/TS/JSON standard, not ts_ls
--   - stylua is the Lua standard, not lua_ls
--   conform.nvim falls back to LSP if no formatter is configured.
--
-- USAGE:
--   Formatting happens automatically on save (format-on-save).
--   <leader>cf  → Format manually (also works on visual selection)
--   :ConformInfo → Show which formatters are active for the current file
--
-- INSTALLING FORMATTERS:
--   Formatters must be installed separately. Use Mason:
--     :MasonInstall black stylua prettier
--   Or your system package manager:
--     pacman -S python-black stylua prettier
--
-- ADDING A NEW FORMATTER:
--   Add the filetype + formatter name to formatters_by_ft below.
--   Full list: https://github.com/stevearc/conform.nvim#formatters

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ lsp_format = "fallback", timeout_ms = 1000 })
      end,
      mode = { "n", "v" },
      desc = "Format code",
    },
  },
  opts = {
    formatters_by_ft = {
      python = { "black" },
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
    },

    -- Format on save: runs the configured formatter, falls back to LSP
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
}
