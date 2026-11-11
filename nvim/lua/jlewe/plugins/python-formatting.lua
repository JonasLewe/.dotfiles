-- Match the Google-style CI formatter in Poetry projects that include YAPF.
local function project(bufnr)
  local root = vim.fs.root(bufnr, "pyproject.toml")
  if root and vim.fn.filereadable(root .. "/poetry.lock") == 1 then
    for _, line in ipairs(vim.fn.readfile(root .. "/poetry.lock")) do
      if line:match('^name%s*=%s*"yapf"%s*$') then
        return root
      end
    end
  end
end

local function args(_, ctx)
  local result = { "run", "yapf", "--style", "google" }
  if ctx.range then
    vim.list_extend(result, { "--lines", ("%d-%d"):format(ctx.range.start[1], ctx.range["end"][1]) })
  end
  return result
end

return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local default_python = opts.formatters_by_ft.python
    opts.formatters_by_ft.python = function(bufnr)
      -- Skip virtualenv files even when Neovim resolves a .venv symlink.
      local filename = vim.api.nvim_buf_get_name(bufnr)
      if filename:find("/.venv/", 1, true) or vim.fs.root(bufnr, "pyvenv.cfg") then
        return { lsp_format = "never" }
      end
      if project(bufnr) then
        return { "poetry_yapf", lsp_format = "never" }
      end
      return default_python
    end

    opts.formatters = opts.formatters or {}
    opts.formatters.poetry_yapf = {
      inherit = false,
      command = "poetry",
      args = args,
      range_args = args,
      stdin = true,
      cwd = function(_, ctx)
        return project(ctx.buf)
      end,
      require_cwd = true,
    }
  end,
}
