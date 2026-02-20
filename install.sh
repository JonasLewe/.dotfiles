#!/usr/bin/env bash

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing dotfiles from: $DOTFILES_DIR"
echo

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "📦 Detected OS: $OS"
echo

### ========== NEOVIM INSTALLATION ==========

if which nvim >/dev/null; then
    echo "✅ Neovim version $(nvim --version | head -1 | awk '{print $2}') is already installed."
else
    echo "📥 Installing Neovim..."
    if [[ "$OS" == "linux" ]]; then
        # FUSE is required for AppImages
        if ! dpkg -s fuse >/dev/null 2>&1; then
            sudo apt install -y fuse
        fi
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
        echo "✅ Neovim installed successfully"
    elif [[ "$OS" == "macos" ]]; then
        if which brew >/dev/null; then
            brew install neovim
            echo "✅ Neovim installed via Homebrew"
        else
            echo "⚠️  Homebrew not found. Please install Neovim manually."
        fi
    fi
fi

echo

### ========== TMUX INSTALLATION ==========

if which tmux >/dev/null; then
    echo "✅ tmux version $(tmux -V) is already installed."
else
    echo "📥 Installing tmux..."
    if [[ "$OS" == "linux" ]]; then
        sudo apt install -y tmux
        echo "✅ tmux installed successfully"
    elif [[ "$OS" == "macos" ]]; then
        if which brew >/dev/null; then
            brew install tmux
            echo "✅ tmux installed via Homebrew"
        else
            echo "⚠️  Homebrew not found. Please install tmux manually."
        fi
    fi
fi

echo

### ========== NEOVIM CONFIG SYMLINK ==========

config_dir=~/.config/nvim

if [[ -e "$config_dir" ]] || [[ -L "$config_dir" ]]; then
    read -p "⚠️  Neovim configuration already exists. Overwrite? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$config_dir"
    else
        echo "⏭️  Skipping Neovim configuration setup."
    fi
fi

if [[ ! -e "$config_dir" ]]; then
    mkdir -p ~/.config
    ln -s "$DOTFILES_DIR/nvim" "$config_dir"
    echo "✅ Neovim configuration symlinked to $config_dir"
fi

echo

### ========== TMUX CONFIG SYMLINK ==========

tmux_conf=~/.tmux.conf

if [[ -e "$tmux_conf" ]] || [[ -L "$tmux_conf" ]]; then
    read -p "⚠️  tmux configuration already exists. Overwrite? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$tmux_conf"
    else
        echo "⏭️  Skipping tmux configuration setup."
    fi
fi

if [[ ! -e "$tmux_conf" ]]; then
    ln -s "$DOTFILES_DIR/tmux/tmux.conf" "$tmux_conf"
    echo "✅ tmux configuration symlinked to $tmux_conf"
fi

echo

### ========== TPM (TMUX PLUGIN MANAGER) INSTALLATION ==========

tpm_dir=~/.tmux/plugins/tpm

if [[ -d "$tpm_dir" ]]; then
    echo "✅ TPM (Tmux Plugin Manager) is already installed."
else
    echo "📥 Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    echo "✅ TPM installed successfully"
    echo "ℹ️  After starting tmux, press Ctrl-A + I to install plugins"
fi

echo

### ========== COMPLETION ==========

echo "✨ Installation complete!"
echo
echo "Next steps:"
echo "  1. Start Neovim: 'nvim' (lazy.nvim will auto-install plugins)"
echo "  2. Start tmux: 'tmux'"
echo "  3. Install tmux plugins: Press Ctrl-A + I inside tmux"
echo
echo "Enjoy your dotfiles! 🎉"
