#!/bin/bash
set -euo pipefail

# Prompt user for which applications to install
echo "Which applications would you like to install?"
read -p "tmux? (y/n): " install_tmux
read -p "neovim? (y/n): " install_neovim

# Delete existing directories and symlinks
if [ -d "$XDG_CONFIG_HOME/tmux" ]; then
    sudo rm -rf "$XDG_CONFIG_HOME/tmux"
fi

if [ -d "$XDG_CONFIG_HOME/zsh" ]; then
    sudo rm -rf "$XDG_CONFIG_HOME/zsh"
fi

if [ -d "$XDG_CONFIG_HOME/nvim" ]; then
    sudo rm -rf "$XDG_CONFIG_HOME/nvim"
fi

if [ -L "$HOME/.zshenv" ]; then
    rm -f "$HOME/.zshenv"
fi

if [ -L "$XDG_CONFIG_HOME/zsh/.zshrc" ]; then
    rm -f "$XDG_CONFIG_HOME/zsh/.zshrc"
fi

# Install chosen applications
if [ "${install_tmux}" == "y" ]; then
    if [ -f /etc/lsb-release ]; then
        # Ubuntu, PopOS
        sudo apt install tmux -y
    else
        echo "Unsupported distribution. Please install tmux manually."
        exit 1
    fi
fi

if [ "${install_neovim}" == "y" ]; then
    if [ -f /etc/lsb-release ]; then
        # Ubuntu, PopOS
        sudo apt install neovim -y
    else
        echo "Unsupported distribution. Please install neovim manually."
        exit 1
    fi

    # Install neovim plugins
    mkdir -p "$XDG_CONFIG_HOME/nvim/undo"
    ln -s "$DOTFILES/nvim/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"

    curl -fLo "$DOTFILES/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Install (or update) all the plugins
    nvim --noplugin +PlugUpdate +qa
fi

# Configure tmux and zsh
mkdir -p "$XDG_CONFIG_HOME/tmux/plugins"
ln -s "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

mkdir -p "$XDG_CONFIG_HOME/zsh"
ln -s "$DOTFILES/zsh/.zshenv" "$HOME"
ln -s "$DOTFILES/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"
ln -s "$DOTFILES/zsh/aliases" "$XDG_CONFIG_HOME/zsh/aliases"
ln -s "$DOTFILES/zsh/external" "$XDG_CONFIG_HOME/zsh"

# Verify symlinks
if [ "$(readlink "$HOME/.zshenv")" != "$DOTFILES/zsh/.zshenv" ]; then
    echo "Incorrect symlink for .zshenv. Updating..."
    ln -sf "$DOTFILES/zsh/.zshenv" "$HOME"
fi

if [ "$(readlink "$XDG_CONFIG_HOME/zsh/.zshrc")" != "$DOTFILES/zsh/.zshrc" ]; then
    echo "Incorrect symlink for .zshrc. Updating..."
    ln -sf "$DOTFILES/zsh/.zshrc" "$
