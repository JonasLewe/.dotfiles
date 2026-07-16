-- =============================================================================
-- JIRA.NVIM — on-demand Jira board for machine-local projects and queries
-- =============================================================================

local local_config

local function local_config_path()
  return vim.fn.stdpath("config") .. "/jira.local.lua"
end

local function load_local_config()
  if local_config then
    return local_config
  end

  local_config = {}
  local path = local_config_path()
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

local function enable_read_only()
  local message = "Jira read-only mode: write action blocked"

  local function notify_blocked(action)
    vim.notify(message .. " (" .. action .. ")", vim.log.levels.WARN)
  end

  local function block_ui_action(action)
    return function()
      notify_blocked(action)
    end
  end

  local function block_api_action(action)
    return function(...)
      local args = { ... }
      local callback

      for index = select("#", ...), 1, -1 do
        if type(args[index]) == "function" then
          callback = args[index]
          break
        end
      end

      local error_message = message .. " (" .. action .. ")"
      if callback then
        vim.schedule(function()
          callback(nil, error_message)
        end)
      else
        notify_blocked(action)
      end
    end
  end

  -- Keep risky entry points from opening write-oriented views or changing local Git state.
  local board = require("jira.board")
  board.change_status = block_ui_action("change status")
  board.change_assignee = block_ui_action("change assignee")
  board.edit_issue = block_ui_action("edit issue")
  board.create_issue = block_ui_action("create issue")
  board.log_time = block_ui_action("log work")
  board.checkout_branch = block_ui_action("checkout/create Git branch")

  require("jira.edit").open = block_ui_action("edit issue")
  require("jira.create").open = block_ui_action("create issue")

  -- The API guard is the final safety net for commands, :write and comment actions.
  local api = require("jira.jira-api.api")
  api.transition_issue = block_api_action("change status")
  api.add_worklog = block_api_action("log work")
  api.assign_issue = block_api_action("change assignee")
  api.add_comment = block_api_action("add comment")
  api.edit_comment = block_api_action("edit comment")
  api.update_issue = block_api_action("edit issue")
  api.create_issue = block_api_action("create issue")

  vim.notify("Jira read-only mode enabled", vim.log.levels.INFO)
end

return {
  "letieu/jira.nvim",
  version = "v0.8.4",
  -- Keep Jira completely disabled on machines without local Jira settings.
  -- `cond` also prevents lazy.nvim from installing the plugin there.
  cond = function()
    return vim.uv.fs_stat(local_config_path()) ~= nil
  end,
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
  config = function(_, opts)
    require("jira").setup(opts)

    if load_local_config().read_only == true then
      enable_read_only()
    end
  end,
}
