-- Copy this file to jira.local.lua and adjust it per machine:
--   cp ~/.config/nvim/jira.example.lua ~/.config/nvim/jira.local.lua
--
-- jira.local.lua is ignored by Git. Authentication is stored separately by
-- jira.nvim after running :Jira auth login.

return {
  api_version = "2", -- Jira Data Center: 2; Jira Cloud: 3
  project_key = "DEMO",
  label = "team-label",
  limit = 100,
  logging = false,

  active_query = 'project = "%s" AND labels = "team-label" ORDER BY Rank ASC',

  queries = {
    ["Team Board"] = 'project = "%s" AND labels = "team-label" ORDER BY Rank ASC',
    ["My Team Tickets"] = [[
      project = "%s"
      AND labels = "team-label"
      AND assignee = currentUser()
      AND statusCategory != Done
      ORDER BY Rank ASC
    ]],
  },

  -- Optional project-specific fields:
  projects = {
    -- DEMO = { story_point_field = "customfield_10016" },
  },
}
