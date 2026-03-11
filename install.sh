#!/usr/bin/env bash

# ==============================================================================
# DOTFILES INSTALLER — macOS & Arch Linux
# ==============================================================================
# Usage: git clone <repo> ~/.dotfiles && cd ~/.dotfiles && ./install.sh
#
# This script installs and symlinks all configurations.
# It prompts before overwriting existing files.

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname)"

echo "🚀 Installing dotfiles from: $DOTFILES_DIR"
echo "🖥️  Detected OS: $OS"
echo

# ==============================================================================
# SYMLINK HELPER
# ==============================================================================

# Creates a symlink, prompting if target already exists.
# Usage: link_config <source> <target>
link_config() {
    local src="$1"
    local dst="$2"

    if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
        read -p "⚠️  $dst already exists. Overwrite? (y/n) " -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$dst"
        else
            echo "⏭️  Skipping $dst"
            return
        fi
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "✅ $dst → $src"
}

# ==============================================================================
# PACKAGE INSTALLATION
# ==============================================================================

if [[ "$OS" == "Darwin" ]]; then
    echo "=== macOS Package Installation (Homebrew) ==="

    if ! command -v brew &>/dev/null; then
        echo "❌ Homebrew not found. Install it first: https://brew.sh"
        exit 1
    fi

    brew install neovim tmux zsh git ripgrep fd node fzf glab jq

    echo

elif [[ "$OS" == "Linux" ]]; then
    if ! command -v pacman &>/dev/null; then
        echo "❌ pacman not found. This script requires an Arch-based distro (CachyOS, Arch, etc.)"
        exit 1
    fi

    echo "=== Linux Package Installation (pacman) ==="

    # Helper: install a package if not already installed
    install_pkg() {
        if ! pacman -Qi "$1" &>/dev/null; then
            echo "📥 Installing $1..."
            sudo pacman -S --noconfirm "$1"
        else
            echo "✅ $1 already installed"
        fi
    }

    install_pkg neovim
    install_pkg tmux
    install_pkg zsh
    install_pkg ghostty
    install_pkg git
    install_pkg ripgrep
    install_pkg fd
    install_pkg ctags
    install_pkg libfido2
    install_pkg nodejs
    install_pkg npm

    echo

    # Optional: Hyprland + Rice
    read -p "🎨 Install Hyprland + rice tools (waybar, rofi, dunst, etc.)? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "=== Hyprland & Rice Tools ==="
        install_pkg hyprland
        install_pkg waybar
        install_pkg rofi-wayland
        install_pkg dunst
        install_pkg hyprpaper
        install_pkg hyprlock
        install_pkg hypridle
        install_pkg brightnessctl
        install_pkg playerctl
        install_pkg grim
        install_pkg slurp
        install_pkg wl-clipboard
        install_pkg wl-clip-persist
        install_pkg ttf-jetbrains-mono-nerd
        install_pkg breeze-icons

        INSTALL_RICE=true
        echo
    fi
fi

# ==============================================================================
# SYMLINKS — Shared (all platforms)
# ==============================================================================

echo "=== Symlinking Configurations ==="

link_config "$DOTFILES_DIR/nvim"            ~/.config/nvim
link_config "$DOTFILES_DIR/tmux/tmux.conf"  ~/.tmux.conf
link_config "$DOTFILES_DIR/zsh/zshrc"       ~/.zshrc
link_config "$DOTFILES_DIR/zsh/zprofile"    ~/.zprofile
link_config "$DOTFILES_DIR/git/gitconfig"   ~/.gitconfig
link_config "$DOTFILES_DIR/ghostty"         ~/.config/ghostty

# Ghostty platform config — symlink platform.conf to the right file
if [[ "$OS" == "Darwin" ]]; then
    ln -sf "$DOTFILES_DIR/ghostty/mac.conf" "$DOTFILES_DIR/ghostty/platform.conf"
    echo "✅ ghostty/platform.conf → mac.conf"
else
    ln -sf "$DOTFILES_DIR/ghostty/linux.conf" "$DOTFILES_DIR/ghostty/platform.conf"
    echo "✅ ghostty/platform.conf → linux.conf"
fi

# Man page (system config reference: man dotfiles)
mkdir -p ~/.local/share/man/man7
link_config "$DOTFILES_DIR/man/dotfiles.7" ~/.local/share/man/man7/dotfiles.7

# Global gitignore (no prompt, doesn't overwrite)
if [[ ! -e ~/.gitignore_global ]]; then
    ln -s "$DOTFILES_DIR/git/gitignore_global" ~/.gitignore_global
    echo "✅ ~/.gitignore_global → git/gitignore_global"
else
    echo "✅ ~/.gitignore_global already exists"
fi

echo

# ==============================================================================
# SYMLINKS — macOS-only (WM stack)
# ==============================================================================

if [[ "$OS" == "Darwin" ]]; then
    echo "=== Symlinking macOS WM Configurations ==="

    link_config "$DOTFILES_DIR/aerospace"  ~/.config/aerospace

    echo
fi

# ==============================================================================
# SYMLINKS — Linux-only (Hyprland / Rice)
# ==============================================================================

if [[ "$INSTALL_RICE" == true ]]; then
    echo "=== Symlinking Rice Configurations ==="

    link_config "$DOTFILES_DIR/hyprland"  ~/.config/hypr
    link_config "$DOTFILES_DIR/waybar"    ~/.config/waybar
    link_config "$DOTFILES_DIR/rofi"      ~/.config/rofi
    link_config "$DOTFILES_DIR/dunst"     ~/.config/dunst

    echo
fi

# ==============================================================================
# LAZY.NVIM (Neovim Plugin Manager)
# ==============================================================================

lazypath="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ ! -d "$lazypath" ]]; then
    echo "📥 Installing lazy.nvim..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$lazypath"
    echo "✅ lazy.nvim installed"
else
    echo "✅ lazy.nvim already installed"
fi

echo

# ==============================================================================
# GHOSTTY SHADERS
# ==============================================================================

ghostty_shaders="$DOTFILES_DIR/ghostty/shaders"
if [[ ! -d "$ghostty_shaders" ]]; then
    echo "📥 Installing Ghostty shaders..."
    git clone https://github.com/0xhckr/ghostty-shaders "$ghostty_shaders"
    echo "✅ Ghostty shaders installed"
else
    echo "✅ Ghostty shaders already installed"
fi

echo

# ==============================================================================
# SSH CONFIG (manual setup)
# ==============================================================================

if [[ ! -e ~/.ssh/config ]]; then
    echo "ℹ️  SSH config not found"
    echo "   To set up: cp $DOTFILES_DIR/ssh/config.example ~/.ssh/config"
    echo "   Then edit and chmod 600 ~/.ssh/config"
else
    echo "✅ SSH config already exists"
fi

echo

# ==============================================================================
# LOCAL CONFIG FILES
# ==============================================================================

# .zshrc.local — machine-specific shell config (nvm, IBM CLI, etc.)
if [[ ! -e ~/.zshrc.local ]]; then
    if [[ -f "$DOTFILES_DIR/zsh/zshrc.local.example" ]]; then
        cp "$DOTFILES_DIR/zsh/zshrc.local.example" ~/.zshrc.local
    else
        touch ~/.zshrc.local
    fi
    echo "✅ Created ~/.zshrc.local (edit to add API keys, work aliases, nvm, etc.)"
else
    echo "✅ ~/.zshrc.local already exists"
fi

# .gitconfig.local — machine-specific git config (email)
if [[ ! -e ~/.gitconfig.local ]]; then
    echo
    read -p "📧 Enter your Git email address: " git_email
    if [[ -n "$git_email" ]]; then
        cat > ~/.gitconfig.local <<EOF
[user]
	email = $git_email
EOF
        echo "✅ Created ~/.gitconfig.local with email: $git_email"
    else
        touch ~/.gitconfig.local
        echo "✅ Created empty ~/.gitconfig.local (set your email later: git config --file ~/.gitconfig.local user.email you@example.com)"
    fi
else
    echo "✅ ~/.gitconfig.local already exists"
fi

echo

# ==============================================================================
# SET DEFAULT SHELL
# ==============================================================================

if [[ "$SHELL" != *"zsh"* ]]; then
    echo "📥 Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    echo "✅ Default shell changed to zsh (takes effect on next login)"
else
    echo "✅ zsh is already the default shell"
fi

echo

# ==============================================================================
# NERD FONT
# ==============================================================================

if [[ -f "$DOTFILES_DIR/install_nerd_font.sh" ]]; then
    read -p "🔤 Install JetBrainsMono Nerd Font? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$DOTFILES_DIR/install_nerd_font.sh"
    fi
fi

# ==============================================================================
# CUSTOM CLI SCRIPTS
# ==============================================================================

if [[ -f "$DOTFILES_DIR/scripts/install.sh" ]]; then
    read -p "🔧 Install custom CLI scripts (glab-issue-helper, etc.)? (y/n) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$DOTFILES_DIR/scripts/install.sh"
    fi
fi

# ==============================================================================
# DONE
# ==============================================================================

echo "✨ Installation complete!"
echo
echo "📝 Next steps:"
echo "  1. Log out and back in (to activate zsh as default shell)"
echo "  2. Start Neovim: 'nvim' (lazy.nvim will auto-install plugins)"
echo "  3. Start tmux: 'tmux'"
if [[ "$OS" == "Darwin" ]]; then
    echo "  4. Uncomment macOS overrides in ~/.config/ghostty/config"
    echo "  5. Install AeroSpace: brew install --cask nikitabobko/tap/aerospace"
fi
if [[ "$INSTALL_RICE" == true ]]; then
    echo "  4. Start Hyprland: log in on TTY1 (auto-starts via zprofile)"
    echo "  5. Read the rice guide: docs/rice-guide.md"
fi
echo "  📖 Read the vanilla vim guide: docs/vanilla-vim-guide.md"
echo
echo "🎯 Learn the fundamentals first, add plugins later!"
