-- =============================================================================
-- EDITOR ENHANCEMENT PLUGINS
-- =============================================================================

return {

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

  -- ---------------------------------------------------------------------------
  -- COMMENT.NVIM
  -- ---------------------------------------------------------------------------
  -- Smart commenting that knows about the current file's language.
  -- Works correctly in mixed-language files (e.g. HTML with embedded JS/CSS).
  --
  -- KEYMAPS:
  --   gcc         → toggle comment on current line
  --   gc + motion → toggle comment on motion (e.g. gcap = comment a paragraph)
  --   gc (visual) → toggle comment on selected lines
  --
  -- EXAMPLES:
  --   gcc    in a .py file → adds/removes # comment
  --   gcc    in a .lua file → adds/removes -- comment
  --   gcap   → comment entire paragraph
  --   gc3j   → comment current line + 3 lines below
  { "numToStr/Comment.nvim", opts = {} },

  -- ---------------------------------------------------------------------------
  -- WHICH-KEY
  -- ---------------------------------------------------------------------------
  -- Shows a popup with available keybindings when you pause mid-sequence.
  --
  -- HOW TO USE:
  --   Press <leader> (Space) and wait ~300ms → see all <leader> keymaps
  --   Press <leader>f and wait → see all file-related keymaps
  --   Press g and wait → see all g-prefixed motions
  --
  -- This is invaluable for learning keymaps — you don't need to memorize
  -- everything at once. Just press the prefix and see what's available.
  {
    "folke/which-key.nvim",
    -- VeryLazy = load after everything else, on first user input
    -- It doesn't need to be ready at startup, only when you actually press a key
    event = "VeryLazy",
    opts = {},
  },
}
