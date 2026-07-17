-- Native .ipynb editing, kernel execution, inline plots and completion.

return {
  "sheng-tse/jupynvim",
  -- Loading the full notebook stack on every Neovim launch costs about 4 ms.
  -- Keep regular startup unchanged and load it only when it is actually used.
  event = {
    { event = "BufReadCmd", pattern = "*.ipynb" },
    { event = "BufNewFile", pattern = "*.ipynb" },
  },
  cmd = { "JupynvimOpen", "JupynvimOpenRemote" },
  build = function(plugin)
    local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
    install.run(plugin)
  end,
  config = function(_, opts)
    local jupynvim = require("jupynvim")
    jupynvim.setup(opts)

    local function resize_images(factor)
      local rows = math.floor((jupynvim.config.image_rows or 16) * factor + 0.5)
      local cols = math.floor((jupynvim.config.image_cols or 48) * factor + 0.5)
      rows = math.max(6, math.min(32, rows))
      cols = math.max(18, math.min(96, cols))

      jupynvim.config.image_rows = rows
      jupynvim.config.image_cols = cols

      local image = require("jupynvim.image")
      image.set_size({ rows = rows, cols = cols })
      image.clear_all()
      for buf, notebook in pairs(require("jupynvim.notebook").all()) do
        notebook.image_ids = {}
        jupynvim.refresh(buf)
      end
      vim.notify(("Notebook image size: %d x %d"):format(rows, cols))
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("jlewe_jupynvim_image_size", { clear = true }),
      callback = function(event)
        if not vim.b[event.buf].jupynvim_filetype then return end
        local map_opts = { buffer = event.buf, silent = true }
        vim.keymap.set({ "n", "i" }, "<C-S-+>", function() resize_images(1.25) end,
          vim.tbl_extend("force", map_opts, { desc = "Enlarge notebook images" }))
        vim.keymap.set({ "n", "i" }, "<C-S-->", function() resize_images(0.8) end,
          vim.tbl_extend("force", map_opts, { desc = "Shrink notebook images" }))
      end,
    })
  end,
  opts = {
    -- Ghostty 1.3+ supports scroll-stable Kitty Unicode placeholders.
    image_renderer = "placeholder",
    auto_venv = true,
    log_level = "info",
    -- Preserve the global netrw mappings, especially <leader>E for %:p:h.
    explorer_keys = {},
    -- Keep the global Ctrl-j/Ctrl-k split navigation available in notebooks.
    keymaps = {
      enter_output_dn = "<leader>no",
      enter_output_up = "<leader>nO",
    },
  },
}
