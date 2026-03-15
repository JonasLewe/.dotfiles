-- =============================================================================
-- NVIM-LINT — Code Linting
-- =============================================================================
-- Runs external linters and shows their diagnostics in Neovim.
-- Complements LSP diagnostics — catches things LSP servers miss.
--
-- WHY NOT JUST LSP?
--   LSP servers provide type errors and basic diagnostics, but dedicated
--   linters catch more:
--   - ruff: Python style, import sorting, security issues (replaces flake8+isort)
--   - eslint: JS/TS code quality, framework-specific rules
--   Linter diagnostics appear alongside LSP diagnostics in the same gutter.
--
-- USAGE:
--   Linting runs automatically on save, file open, and leaving insert mode.
--   Diagnostics show in the sign column and in trouble.nvim (<leader>xx).
--
-- INSTALLING LINTERS:
--   Linters must be installed separately. Use Mason:
--     :MasonInstall ruff eslint_d
--   Or your system package manager:
--     pacman -S ruff / npm install -g eslint_d
--
-- ADDING A NEW LINTER:
--   Add the filetype + linter name to linters_by_ft below.
--   Full list: https://github.com/mfussenegger/nvim-lint#available-linters

return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "ruff" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    -- Auto-lint on save, file open, and leaving insert mode
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
