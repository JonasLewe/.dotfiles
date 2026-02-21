-- =============================================================================
-- TREESITTER — SYNTAX HIGHLIGHTING & CODE UNDERSTANDING
-- =============================================================================
-- Treesitter is a parser generator that builds a real syntax tree of your code.
-- Unlike the old regex-based Vim syntax highlighting, Treesitter actually
-- UNDERSTANDS the structure of the code.
--
-- Benefits over classic Vim syntax:
--   • More accurate and consistent highlighting
--   • Works correctly with nested languages (e.g. HTML inside JS)
--   • Powers other features: indentation, text objects, code folding
--   • Language-agnostic: add support for any language by installing a parser
--
-- HOW IT WORKS:
--   Each language has a "parser" — a compiled .so file that Treesitter uses
--   to analyze code. Parsers are downloaded and compiled automatically.
--   Stored in: ~/.local/share/nvim/lazy/nvim-treesitter/parser/
--
-- USEFUL COMMANDS:
--   :TSInstall <language>    → install a specific parser
--   :TSInstallInfo           → list all available parsers and their status
--   :TSUpdate                → update all installed parsers
--   :InspectTree             → visualize the syntax tree of the current file (cool!)

return {
  "nvim-treesitter/nvim-treesitter",

  -- Run :TSUpdate after install/update to keep parsers current
  build = ":TSUpdate",

  -- Only load when actually opening a file (not on the empty start screen)
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    require("nvim-treesitter").setup({

      -- Parsers to install automatically.
      -- Add more as you need them — full list: :TSInstallInfo
      ensure_installed = {
        "python",      -- Python
        "typescript",  -- TypeScript
        "javascript",  -- JavaScript
        "lua",         -- Lua (for this config!)
        "yaml",        -- YAML (Kubernetes, CI/CD)
        "json",        -- JSON
        "bash",        -- Shell scripts
        "markdown",    -- Markdown docs
        "vim",         -- Vimscript
        "vimdoc",      -- Neovim :help documentation
      },

      -- Install parsers asynchronously in the background (false = don't block)
      sync_install = false,

      -- Automatically install a parser when you open a file whose language
      -- isn't installed yet. Requires a C compiler (gcc) on the system.
      auto_install = true,

      -- SYNTAX HIGHLIGHTING
      -- Replaces the old regex-based Vim syntax highlighting.
      -- additional_vim_regex_highlighting = false avoids double-processing.
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      -- SMART INDENTATION
      -- Treesitter-aware auto-indent when pressing Enter or using =.
      -- More accurate than Vim's built-in indent rules.
      indent = {
        enable = true,
      },
    })
  end,
}
