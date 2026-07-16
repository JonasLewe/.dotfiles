-- =============================================================================
-- AUTO PAIRS — automatically close brackets, quotes, etc.
-- =============================================================================
-- When you type an opening character, the closing one is inserted automatically
-- and the cursor lands between them.
--
-- BEHAVIOR:
--   (  → ()  with cursor between
--   "  → ""  with cursor between
--   {  → {}  with cursor between
--   )  → jumps over existing ) instead of doubling
--   <CR> between {} → formats with proper indentation
--
-- Kept intentionally small: native LSP completion handles snippets, while this
-- plugin only handles typed pairs after InsertEnter.

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- use treesitter to check for pair (smarter matching)
  },
}
