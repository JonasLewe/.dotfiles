-- =============================================================================
-- EDITOR ENHANCEMENT PLUGINS
-- =============================================================================

return {

  -- ---------------------------------------------------------------------------
  -- WHICH-KEY.NVIM
  -- ---------------------------------------------------------------------------
  -- Shows available keymaps while typing, e.g. <leader>f reveals ff/fr/fg/fb.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer local keymaps",
      },
    },
    opts = {
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug/diagnostics" },
        { "<leader>f", group = "find" },
        { "<leader>h", group = "git hunks" },
        { "<leader>l", group = "lazy" },
        { "<leader>n", group = "notebook" },
        { "<leader>p", group = "pomodoro" },
        { "<leader>s", group = "splits" },
        { "<leader>t", group = "tabs/terminal" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- VIM-SURROUND
  -- ---------------------------------------------------------------------------
  -- Add, change, or delete "surroundings" (quotes, brackets, tags, etc.)
  --
  -- EXAMPLES (cursor inside the word):
  --   ysiw"   → surround word with "double quotes"     (ys = you surround)
  --   ysiw'   → surround word with 'single quotes'
  --   ysiw(   → surround word with ( parens )
  --   yss"    → surround entire line with quotes
  --   ds"     → delete surrounding "quotes"            (ds = delete surround)
  --   cs"'    → change surrounding "quotes" to 'these' (cs = change surround)
  --   cst<p>  → change surrounding HTML tag to <p>
  --
  -- Works with any pair: ( ) [ ] { } < > " ' ` and HTML tags
  { "tpope/vim-surround" },
}
