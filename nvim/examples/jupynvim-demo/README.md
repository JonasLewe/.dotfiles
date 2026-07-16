# jupynvim test environment

The Python environment is local to this directory and ignored by Git.

```sh
cd ~/.dotfiles/nvim/examples/jupynvim-demo
uv sync
nvim demo.ipynb
```

`jupynvim` should start the project-local kernel automatically. Inside the
notebook, press `Space n` to see all notebook actions in Which-Key.

Useful keys:

| Key | Action |
| --- | --- |
| `Shift+Enter` | Run cell and move to the next cell |
| `Ctrl+Enter` | Run cell and stay in the current cell |
| `Space n R` | Run all cells |
| `Space n a` / `Space n b` | Add a cell above / below |
| `Space n m` / `Space n y` | Convert cell to Markdown / code |
| `Space n K` | Select a Jupyter kernel |
| `Space n x` | Restart the kernel |
| `Space n o` / `Space n O` | Open output below / above in a split |
| `[c` / `]c` | Previous / next cell |

Suggested test:

1. Run every cell with `Shift+Enter`.
2. Confirm that the DataFrame is readable and the plot appears inline.
3. In the final code cell, type `result.` and trigger completion with
   `Ctrl+Space`. Kernel-provided attributes should be included.
4. Put the cursor on `result.mean` and press `K` to test kernel hover.
5. Add, move, convert, and delete a cell, then use undo.
6. Save with `:w`, close Neovim, and reopen the notebook. Outputs should still
   be present.

The HTML cell is intentional. It shows how a rich browser-oriented MIME output
falls back in the terminal and helps compare this workflow with VS Code.
