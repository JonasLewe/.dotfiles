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
        # Install via tarball (not AppImage) — AppImage bundles Qt which causes
        # a harmless but annoying Wayland warning on every launch.
        # The tarball is a plain binary with no extra dependencies.
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        tar -xzf nvim-linux-x86_64.tar.gz -C ~/.local/
        rm nvim-linux-x86_64.tar.gz
        mkdir -p ~/bin
        ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/bin/nvim
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

echo

### ========== ZSHRC SYMLINK ==========

zshrc_file=~/.zshrc

if [[ -e "$zshrc_file" ]] || [[ -L "$zshrc_file" ]]; then
    read -p "⚠️  .zshrc already exists. Overwrite? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$zshrc_file"
    else
        echo "⏭️  Skipping .zshrc setup."
    fi
fi

if [[ ! -e "$zshrc_file" ]]; then
    ln -s "$DOTFILES_DIR/zsh/zshrc" "$zshrc_file"
    echo "✅ .zshrc symlinked to $zshrc_file"
fi

# Create .zshrc.local if it doesn't exist
if [[ ! -e ~/.zshrc.local ]]; then
    cp "$DOTFILES_DIR/zsh/zshrc.local.example" ~/.zshrc.local
    echo "✅ Created ~/.zshrc.local (add your API keys here)"
    echo "ℹ️  Edit ~/.zshrc.local to add your API keys and machine-specific settings"
else
    echo "✅ ~/.zshrc.local already exists"
fi

echo

### ========== ZSH PLUGINS ==========

# Install zsh-vi-mode plugin (required by zshrc)
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-vi-mode ]]; then
    echo "📥 Installing zsh-vi-mode plugin..."
    git clone https://github.com/jeffreytse/zsh-vi-mode ~/.oh-my-zsh/custom/plugins/zsh-vi-mode
    echo "✅ zsh-vi-mode plugin installed"
else
    echo "✅ zsh-vi-mode plugin already installed"
fi

echo

### ========== NVM (NODE VERSION MANAGER) ==========

# Install nvm (required for Node.js LSP servers: ts_ls, yamlls)
if [[ ! -d ~/.config/nvm ]]; then
    echo "📥 Installing nvm (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    # Source nvm and install LTS Node.js
    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "📥 Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    echo "✅ Node.js installed: $(node --version)"
else
    echo "✅ nvm already installed"
fi

echo

### ========== ZPROFILE SYMLINK ==========

zprofile_file=~/.zprofile

if [[ -e "$zprofile_file" ]] || [[ -L "$zprofile_file" ]]; then
    read -p "⚠️  .zprofile already exists. Overwrite? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$zprofile_file"
    else
        echo "⏭️  Skipping .zprofile setup."
    fi
fi

if [[ ! -e "$zprofile_file" ]]; then
    ln -s "$DOTFILES_DIR/zsh/zprofile" "$zprofile_file"
    echo "✅ .zprofile symlinked to $zprofile_file"
fi

echo


### ========== GIT CONFIG SYMLINK ==========

gitconfig_file=~/.gitconfig

if [[ -e "$gitconfig_file" ]] || [[ -L "$gitconfig_file" ]]; then
    read -p "⚠️  .gitconfig already exists. Overwrite? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$gitconfig_file"
    else
        echo "⏭️  Skipping .gitconfig setup."
    fi
fi

if [[ ! -e "$gitconfig_file" ]]; then
    ln -s "$DOTFILES_DIR/git/gitconfig" "$gitconfig_file"
    echo "✅ .gitconfig symlinked to $gitconfig_file"
fi

# Global gitignore
gitignore_global=~/.gitignore_global

if [[ ! -e "$gitignore_global" ]]; then
    ln -s "$DOTFILES_DIR/git/gitignore_global" "$gitignore_global"
    echo "✅ .gitignore_global symlinked to $gitignore_global"
else
    echo "✅ .gitignore_global already exists"
fi

echo

### ========== SSH CONFIG (MANUAL SETUP) ==========

if [[ ! -e ~/.ssh/config ]]; then
    echo "ℹ️  SSH config not found"
    echo "📝 To set up SSH config:"
    echo "   mkdir -p ~/.ssh"
    echo "   cp $DOTFILES_DIR/ssh/config.example ~/.ssh/config"
    echo "   nvim ~/.ssh/config  # Customize with your servers"
    echo "   chmod 600 ~/.ssh/config"
else
    echo "✅ SSH config already exists (~/.ssh/config)"
fi

echo

### ========== GHOSTTY CONFIG ==========

ghostty_dir=~/.config/ghostty

if [[ -e "$ghostty_dir" ]] || [[ -L "$ghostty_dir" ]]; then
    read -p "⚠️  Ghostty config already exists. Overwrite? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$ghostty_dir"
    else
        echo "⏭️  Skipping Ghostty configuration setup."
    fi
fi

if [[ ! -e "$ghostty_dir" ]]; then
    mkdir -p ~/.config
    ln -s "$DOTFILES_DIR/ghostty" "$ghostty_dir"
    echo "✅ Ghostty configuration symlinked to $ghostty_dir"
fi

# Install Ghostty shaders (external repo)
ghostty_shaders="$DOTFILES_DIR/ghostty/shaders"
if [[ ! -d "$ghostty_shaders" ]]; then
    echo "📥 Installing Ghostty shaders..."
    git clone https://github.com/0xhckr/ghostty-shaders "$ghostty_shaders"
    echo "✅ Ghostty shaders installed"
else
    echo "✅ Ghostty shaders already installed"
fi

echo

### ========== COMPLETION ==========

echo "✨ Installation complete!"
echo
echo "📝 Next steps:"
echo "  1. Edit ~/.zshrc.local and add your API keys (optional)"
echo "  2. Reload shell: 'exec zsh' or restart terminal"
echo "  3. Start Neovim: 'nvim' (lazy.nvim will auto-install plugins)"
echo "  4. Start tmux: 'tmux' and start learning the keybindings!"
echo
echo "🎯 Minimal setup complete - learn first, add features later!"
echo "Enjoy your dotfiles! 🎉"
