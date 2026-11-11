-- Machine-local vault settings; shared by the plugin, LSP and formatter.
local M = {}
local filename = vim.fn.stdpath("config") .. "/obsidian.local"

if vim.fn.filereadable(filename) == 1 then
  local ok, config = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(filename), "\n"))
  end)
  if ok and type(config) == "table" and type(config.path) == "string" then
    local path = vim.fs.normalize(vim.fn.expand(config.path))
    if vim.fn.isdirectory(path) == 1 then
      config.path = vim.uv.fs_realpath(path) or path
      M.config = config
    end
  end
  if not M.config then
    vim.schedule(function()
      vim.notify("Obsidian: check the JSON and vault path in " .. filename, vim.log.levels.WARN)
    end)
  end
end

function M.contains(bufnr)
  if not M.config then
    return false
  end
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local path = vim.uv.fs_realpath(filename) or vim.fs.normalize(filename)
  return path:sub(1, #M.config.path + 1) == M.config.path .. "/" and path:lower():sub(-3) == ".md"
end

return M
