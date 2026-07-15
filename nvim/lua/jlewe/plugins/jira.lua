-- =============================================================================
-- JIRA.NVIM — on-demand Jira board for machine-local projects and queries
-- =============================================================================

local local_config

local function load_local_config()
  if local_config then
    return local_config
  end

  local_config = {}
  local path = vim.fn.stdpath("config") .. "/jira.local.lua"
  if not vim.uv.fs_stat(path) then
    return local_config
  end

  local ok, result = pcall(dofile, path)
  if not ok then
    vim.schedule(function()
      vim.notify("Could not load jira.local.lua: " .. result, vim.log.levels.ERROR)
    end)
    return local_config
  end

  if type(result) ~= "table" then
    vim.schedule(function()
      vim.notify("jira.local.lua must return a table", vim.log.levels.ERROR)
    end)
    return local_config
  end

  local_config = result
  return local_config
end

local function default_queries(config)
  local label = tostring(config.label or "team-label"):gsub("\\", "\\\\"):gsub('"', '\\"')
  local board = ('project = "%%s" AND labels = "%s" ORDER BY Rank ASC'):format(label)
  local mine = (
    'project = "%%s" AND labels = "%s" AND assignee = currentUser() '
    .. "AND statusCategory != Done ORDER BY Rank ASC"
  ):format(label)

  return {
    ["Team Board"] = board,
    ["My Team Tickets"] = mine,
  }, board
end

return {
  "letieu/jira.nvim",
  version = "v0.8.4",
  cmd = "Jira",
  keys = {
    {
      "<leader>jj",
      function()
        local config = load_local_config()
        if not config.project_key or config.project_key == "" then
          vim.notify("Set project_key in " .. vim.fn.stdpath("config") .. "/jira.local.lua", vim.log.levels.WARN)
          return
        end
        require("jira").open(config.project_key)
      end,
      desc = "Open default Jira board",
    },
  },
  opts = function()
    local config = load_local_config()
    local queries, active_query = default_queries(config)

    if type(config.queries) == "table" then
      queries = config.queries
    end
    if type(config.active_query) == "string" and config.active_query ~= "" then
      active_query = config.active_query
    end

    return {
      jira = {
        api_version = config.api_version or "2",
        limit = config.limit or 100,
        logging = config.logging == true,
      },
      active_sprint_query = active_query,
      queries = queries,
      projects = config.projects or {},
    }
  end,
}
