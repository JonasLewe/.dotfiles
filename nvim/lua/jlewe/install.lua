local M = {}

local function fail(message)
  vim.api.nvim_err_writeln(tostring(message))
  vim.cmd("cquit 1")
end

function M.treesitter()
  local ok, err = pcall(function()
    local treesitter = require("nvim-treesitter")
    local configured = require("jlewe.treesitter_languages")
    local installed = treesitter.get_installed("parsers")
    local missing = vim.tbl_filter(function(language)
      return not vim.list_contains(installed, language)
    end, configured)

    if #missing > 0 then
      local success = treesitter.install(missing, { summary = true }):wait(300000)
      assert(success, "one or more Treesitter parsers failed to install")
    end
  end)

  if not ok then
    fail(err)
    return
  end
  vim.cmd("qa!")
end

function M.mason()
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    fail(registry)
    return
  end

  vim.defer_fn(function()
    fail("Mason installation timed out after 120 seconds")
  end, 120000)

  registry.refresh(function()
    local missing = {}
    for _, name in ipairs(require("jlewe.tooling").mason_packages) do
      local found, package = pcall(registry.get_package, name)
      if found and not package:is_installed() then
        table.insert(missing, package)
      end
    end

    if #missing == 0 then
      vim.schedule(function()
        vim.cmd("qa!")
      end)
      return
    end

    local completed = 0
    for _, package in ipairs(missing) do
      package:install():once(
        "closed",
        vim.schedule_wrap(function()
          completed = completed + 1
          if completed == #missing then
            vim.cmd("qa!")
          end
        end)
      )
    end
  end)
end

return M
