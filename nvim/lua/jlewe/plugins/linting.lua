-- Run dedicated linters after edits without blocking the initial file open.

local tooling = require("jlewe.tooling")

return {
  "mfussenegger/nvim-lint",
  ft = { "python", "sh", "bash" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = tooling.linters_by_ft

    -- Keep external processes off the initial file-open path.
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
