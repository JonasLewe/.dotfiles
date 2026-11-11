-- Keep typing Markdown headings from triggering hashtag completion.
-- Link completion and manual completion via Ctrl-Space remain available.
return {
  root_dir = function(bufnr, on_dir)
    -- The vault uses obsidian-ls for links, completion and rename operations.
    if not require("jlewe.obsidian").contains(bufnr) then
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
