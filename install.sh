#!/usr/bin/env bash

# ==============================================================================
# DOTFILES INSTALLER — CachyOS / Arch Linux
# ==============================================================================
# Usage: git clone <repo> ~/.dotfiles && cd ~/.dotfiles && ./install.sh
#
# This script installs and symlinks all configurations.
# It prompts before overwriting existing files.

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing dotfiles from: $DOTFILES_DIR"
echo

# ==============================================================================
# CHECK: Must be Arch-based (CachyOS, EndeavourOS, vanilla Arch, etc.)
# ==============================================================================

if ! command -v pacman &>/dev/null; then
    echo "❌ pacman not found. This script requires an Arch-based distro (CachyOS, Arch, etc.)"
    exit 1
fi

echo "📦 Detected Arch-based system (pacman available)"
echo

# Helper: install a package if not already installed
install_pkg() {
    if ! pacman -Qi "$1" &>/dev/null; then
        echo "📥 Installing $1..."
        sudo pacman -S --noconfirm "$1"
    else
        echo "✅ $1 already installed"
    fi
}

# ==============================================================================
# CORE TOOLS
# ==============================================================================

echo "=== Core Tools ==="
install_pkg neovim
install_pkg tmux
install_pkg zsh
install_pkg ghostty
install_pkg git
install_pkg ripgrep        # fast grep, used by :grep in neovim
install_pkg fd             # fast find, useful for :find alternatives
install_pkg universal-ctags # code navigation with <C-]> in neovim

echo

# ==============================================================================
# HYPRLAND + RICE TOOLS (optional)
# ==============================================================================

read -p "🎨 Install Hyprland + rice tools (waybar, rofi, dunst, etc.)? (y/n) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "=== Hyprland & Rice Tools ==="
    install_pkg hyprland
    install_pkg waybar
    install_pkg rofi-wayland
    install_pkg dunst
    install_pkg hyprpaper       # static wallpaper
    install_pkg hyprlock        # lock screen
    install_pkg brightnessctl   # brightness control for waybar/keybinds
    install_pkg playerctl       # media control for waybar/keybinds
    install_pkg grim            # screenshot tool
    install_pkg slurp           # region selection for screenshots
    install_pkg wl-clipboard    # clipboard for Wayland (needed by neovim)
    install_pkg ttf-jetbrains-mono-nerd  # Nerd Font

    INSTALL_RICE=true
    echo
fi

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
# SYMLINKS — Core
# ==============================================================================

echo "=== Symlinking Configurations ==="

link_config "$DOTFILES_DIR/nvim"            ~/.config/nvim
link_config "$DOTFILES_DIR/tmux/tmux.conf"  ~/.tmux.conf
link_config "$DOTFILES_DIR/zsh/zshrc"       ~/.zshrc
link_config "$DOTFILES_DIR/zsh/zprofile"    ~/.zprofile
link_config "$DOTFILES_DIR/git/gitconfig"   ~/.gitconfig
link_config "$DOTFILES_DIR/ghostty"         ~/.config/ghostty

# Global gitignore (no prompt, doesn't overwrite)
if [[ ! -e ~/.gitignore_global ]]; then
    ln -s "$DOTFILES_DIR/git/gitignore_global" ~/.gitignore_global
    echo "✅ ~/.gitignore_global → git/gitignore_global"
else
    echo "✅ ~/.gitignore_global already exists"
fi

# Create .zshrc.local for machine-specific secrets
if [[ ! -e ~/.zshrc.local ]]; then
    cp "$DOTFILES_DIR/zsh/zshrc.local.example" ~/.zshrc.local
    echo "✅ Created ~/.zshrc.local (edit to add API keys, work aliases, etc.)"
else
    echo "✅ ~/.zshrc.local already exists"
fi

echo

# ==============================================================================
# SYMLINKS — Hyprland / Rice (if selected)
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
# DONE
# ==============================================================================

echo "✨ Installation complete!"
echo
echo "📝 Next steps:"
echo "  1. Log out and back in (to activate zsh as default shell)"
echo "  2. Start Neovim: 'nvim' (lazy.nvim will auto-install plugins)"
echo "  3. Start tmux: 'tmux'"
if [[ "$INSTALL_RICE" == true ]]; then
    echo "  4. Start Hyprland: select it from your display manager, or run 'Hyprland'"
    echo "  5. Read the rice guide: docs/rice-guide.md"
fi
echo "  📖 Read the vanilla vim guide: docs/vanilla-vim-guide.md"
echo
echo "🎯 Learn the fundamentals first, add plugins later!"
