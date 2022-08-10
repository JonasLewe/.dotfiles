#!/bin/bash

########
# nvim #
########
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim/undo"
mkdir -p "$HOME/.config/zsh"

ln -sf "$HOME/.dotfiles/nvim/init.vim" "$HOME/.config/nvim/init.vim"
ln -sf "$HOME/.dotfiles/zsh/.zshenv" "$HOME"
ln -sf "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.config/zsh"

