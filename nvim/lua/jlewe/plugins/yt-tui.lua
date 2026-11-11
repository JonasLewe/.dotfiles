local plugin_dir = vim.fn.expand("~/Developer/yt-tui.nvim")
if vim.fn.isdirectory(plugin_dir) == 0 then
  return {}
end

return {
  {
    dir = plugin_dir,
    name = "yt-tui.nvim",
    main = "yt-tui",
    cmd = { "YtTui", "YtTuiClose" },
    keys = {
      { "<leader>yt", "<cmd>YtTui<cr>", desc = "Open YouTrack" },
    },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>y", group = "youtrack" })
    end,
  },
}
