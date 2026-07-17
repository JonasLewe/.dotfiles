-- Live Git signs, hunk actions and blame for tracked buffers.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Git: " .. desc })
      end

      -- Hunk navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Previous hunk")

      -- Hunk actions
      map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
      map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected lines")
      map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
      map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected lines")
      map("n", "<leader>hS", gitsigns.stage_buffer, "Stage entire buffer")
      map("n", "<leader>hR", gitsigns.reset_buffer, "Reset entire buffer")
      map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, "Blame line (full commit)")
      map("n", "<leader>hB", gitsigns.toggle_current_line_blame, "Toggle inline blame")
    end,
  },
}
