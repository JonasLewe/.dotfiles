-- =============================================================================
-- GITSIGNS — GIT INTEGRATION IN THE EDITOR
-- =============================================================================
-- Shows git change indicators in the signcolumn (the gutter on the left).
-- A "hunk" is a contiguous block of changed lines.
--
-- SIGNS IN THE GUTTER:
--   │  (green)  → added lines
--   │  (red)    → removed lines
--   ~  (orange) → modified lines
--
-- KEYMAPS (active when a git repo is detected):
--   ]c          → jump to next hunk (change)
--   [c          → jump to previous hunk
--   <leader>hs  → stage the hunk under cursor (add it to git index)
--   <leader>hr  → reset the hunk (discard changes in this hunk)
--   <leader>hp  → preview the hunk diff in a floating window

return {
  "lewis6991/gitsigns.nvim",

  -- Load when opening any file (git signs need to appear immediately)
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    require("gitsigns").setup({
      -- on_attach runs once per buffer when gitsigns connects to it
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local opts = { buffer = bufnr }

        -- Jump to next hunk, but respect native diff navigation if in diff mode
        vim.keymap.set("n", "]c", function()
          if vim.wo.diff then return "]c" end          -- use built-in diff nav
          vim.schedule(function() gs.next_hunk() end) -- otherwise use gitsigns
          return "<Ignore>"
        end, { buffer = bufnr, expr = true, desc = "Next git hunk" })

        -- Jump to previous hunk
        vim.keymap.set("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { buffer = bufnr, expr = true, desc = "Previous git hunk" })

        -- Stage/reset/preview hunks
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk,   vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
        vim.keymap.set("n", "<leader>hr", gs.reset_hunk,   vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
      end,
    })
  end,
}
