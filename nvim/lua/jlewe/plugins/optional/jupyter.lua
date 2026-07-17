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
