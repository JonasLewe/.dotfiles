-- Pair insertion remains separate from native LSP snippet expansion.

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- use treesitter to check for pair (smarter matching)
  },
}
