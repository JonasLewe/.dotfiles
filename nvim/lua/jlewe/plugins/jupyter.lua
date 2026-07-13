-- =============================================================================
-- JUPYNVIM - NATIVE JUPYTER NOTEBOOKS
-- =============================================================================
-- Opens .ipynb files as editable notebook buffers with code/markdown cells,
-- Jupyter kernel execution, inline plots, LSP diagnostics, and completion.
--
-- QUICK START:
--   nvim nvim/examples/jupynvim-demo/demo.ipynb
--   <S-CR>      run current cell and move to the next one
--   <C-CR>      run current cell and stay in it
--   <leader>n   show all notebook actions in which-key

return {
  "sheng-tse/jupynvim",
  lazy = false,
  build = function(plugin)
    local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
    install.run(plugin)
  end,
  opts = {
    -- Ghostty 1.3+ supports scroll-stable Kitty Unicode placeholders.
    image_renderer = "placeholder",
    auto_venv = true,
    log_level = "info",
    -- Keep the global Ctrl-j/Ctrl-k split navigation available in notebooks.
    keymaps = {
      enter_output_dn = "<leader>no",
      enter_output_up = "<leader>nO",
    },
  },
}
