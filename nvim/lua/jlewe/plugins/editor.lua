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
}
