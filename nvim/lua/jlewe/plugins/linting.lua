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
--   - shellcheck: Bash correctness and portability issues
--   Linter diagnostics appear alongside LSP diagnostics in the same gutter.
--
-- USAGE:
--   Linting runs automatically on save and leaving insert mode.
--   Diagnostics show in the sign column and in trouble.nvim (<leader>xx).
--
-- INSTALLING LINTERS:
--   Linters must be installed separately. Use Mason:
--     :MasonInstall ruff shellcheck
--   Or your system package manager:
--     pacman -S ruff shellcheck
--
-- ADDING A NEW LINTER:
--   Add the filetype + linter name to linters_by_ft below.
--   Full list: https://github.com/mfussenegger/nvim-lint#available-linters

return {
  "mfussenegger/nvim-lint",
  ft = { "python", "sh", "bash" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "ruff" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
    }

    -- Keep external processes off the initial file-open path.
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })

    -- The first InsertLeave or save runs it moments later during normal editing.
  end,
}
