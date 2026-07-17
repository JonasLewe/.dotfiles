-- nvim-treesitter supplies parsers and queries; Neovim 0.12 starts highlighting.

return {
  "nvim-treesitter/nvim-treesitter",
  -- The Neovim 0.12 rewrite explicitly does not support lazy-loading.
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    local parsers = require("jlewe.treesitter_languages")

    treesitter.setup()

    -- Install only missing configured parsers, asynchronously after startup.
    local installed = treesitter.get_installed("parsers")
    local missing = vim.tbl_filter(function(lang)
      return not vim.list_contains(installed, lang)
    end, parsers)
    if #missing > 0 and vim.env.DOTFILES_INSTALL ~= "1" then
      vim.schedule(function()
        treesitter.install(missing, { summary = true })
      end)
    end

    -- Helm templates look like YAML by extension. Only promote files inside a
    -- chart's templates/ directory when a Chart.yaml exists above them.
    vim.filetype.add({
      pattern = {
        [".*/templates/.*"] = {
          function(path)
            local chart = vim.fs.find("Chart.yaml", {
              path = vim.fs.dirname(path),
              upward = true,
              type = "file",
            })[1]
            return chart and "helm" or nil
          end,
          { priority = 100 },
        },
      },
    })

    -- Highlighting is native in Neovim 0.12; nvim-treesitter supplies the
    -- parsers and queries. Unsupported/mid-install buffers fall back cleanly.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      pattern = {
        "bash",
        "helm",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "python",
        "sh",
        "vim",
        "vimdoc",
        "yaml",
      },
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
