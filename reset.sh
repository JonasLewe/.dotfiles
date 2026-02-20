#!/usr/bin/env bash

# Remove Neovim data directories (includes lazy.nvim, plugins, state)
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Remove Neovim binary
sudo rm -rf /usr/local/bin/nvim

# Remove config directory
rm -rf ~/.config/nvim

# Remove old vim info
rm -rf ~/.viminfo



