-- =============================================================================
-- TELESCOPE — FUZZY FINDER
-- =============================================================================
-- Telescope is one of the most powerful Neovim plugins. It lets you search
-- through almost anything interactively with fuzzy matching:
--   • Files in a project          (<leader>ff)
--   • Text content inside files   (<leader>fs — needs ripgrep installed)
--   • Open buffers                (<leader>fb)
--   • Neovim help pages           (<leader>fh)
--   • Recent files                (<leader>fr)
--   • Git commits, branches, etc. (:Telescope git_commits)
--
-- FUZZY MATCHING: you don't need to type the exact name.
--   Searching "mlua" might match "my-lua-file.lua".
--
-- KEYMAPS INSIDE TELESCOPE PICKER:
--   <Esc> or q  → close
--   <CR>        → open selected file
--   <C-j/k>     → move up/down in results (configured below)
--   <C-v>       → open in vertical split
--   <C-x>       → open in horizontal split
--   <C-t>       → open in new tab
--   <Tab>        → select multiple items
--
-- DEPENDENCIES:
--   ripgrep (rg)  → required for live_grep (<leader>fs)
--   fd            → optional, faster file finding
--   Install: sudo apt install ripgrep fd-find

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",

  -- Only load when triggered by a keybind or command (not at startup)
  cmd = "Telescope",
  keys = {
    { "<leader>ff" }, { "<leader>fs" }, { "<leader>fc" },
    { "<leader>fb" }, { "<leader>fh" }, { "<leader>fr" },
  },

  dependencies = {
    -- Required utility library used by many Neovim plugins
    "nvim-lua/plenary.nvim",
    -- Native FZF sorter compiled in C — significantly faster fuzzy matching
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },

  config = function()
    -- Compatibility shim for Neovim 0.10+
    -- Telescope uses an older nvim-treesitter API that was removed.
    -- This adds back the missing function using the new built-in API.
    local ts_parsers = require("nvim-treesitter.parsers")
    if not ts_parsers.ft_to_lang then
      ts_parsers.ft_to_lang = function(ft)
        return vim.treesitter.language.get_lang(ft) or ft
      end
    end

    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        -- Open picker in normal mode (so you can use vim motions immediately)
        -- Switch to insert mode with "i" to start typing a search
        initial_mode = "normal",

        mappings = {
          i = {
            -- In insert mode, use Ctrl+j/k instead of arrow keys to navigate results
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            -- Send selected items to the quickfix list (for multi-file operations)
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- Load the FZF extension for faster fuzzy matching
    telescope.load_extension("fzf")
  end,
}
