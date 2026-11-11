-- Keep typing Markdown headings from triggering hashtag completion.
-- Link completion and manual completion via Ctrl-Space remain available.
return {
  on_init = function(client)
    local completion = client.server_capabilities.completionProvider
    if completion then
      completion.triggerCharacters = vim.tbl_filter(function(char)
        return char ~= "#"
      end, completion.triggerCharacters or {})
    end
  end,
}
