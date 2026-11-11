-- Keep typing Markdown headings from triggering hashtag completion.
-- Link completion and manual completion via Ctrl-Space remain available.
return {
  root_dir = function(bufnr, on_dir)
    local vault = require("jlewe.obsidian")
    -- Keep nested note folders in the configured vault workspace.
    -- Marksman also needs .marksman.toml in that root to index all notes.
    if vault.contains(bufnr) then
      on_dir(vault.config.path)
    else
      on_dir(vim.fs.root(bufnr, { ".marksman.toml", ".git" }))
    end
  end,
  on_init = function(client)
    local completion = client.server_capabilities.completionProvider
    if completion then
      completion.triggerCharacters = vim.tbl_filter(function(char)
        return char ~= "#"
      end, completion.triggerCharacters or {})
    end
  end,
}
