#!/usr/bin/env bash
# ==============================================================================
# SCRIPTS INSTALLER — macOS & Arch Linux
# ==============================================================================
# Installs custom CLI tools from the scripts/ directory.
#
# Usage (standalone):  ./scripts/install.sh
# Usage (from main):   called by install.sh during dotfiles setup

set -e

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname)"
BIN_DIR="$HOME/.local/bin"

echo "=== Installing CLI Scripts ==="
echo

# ─── Ensure ~/.local/bin exists and is on PATH ───
mkdir -p "$BIN_DIR"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "⚠️  $BIN_DIR is not in your PATH."
    echo "   Add this to your ~/.zshrc.local:"
    echo "     export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
fi

# ─── Helper: symlink a script to ~/.local/bin ───
link_script() {
    local src="$1"
    local name="$(basename "$src")"
    local dst="$BIN_DIR/$name"

    if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst" 2>/dev/null)" == "$src" ]]; then
            echo "✅ $name already linked"
            return
        fi
        read -p "⚠️  $dst already exists. Overwrite? (y/n) " -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -f "$dst"
        else
            echo "⏭️  Skipping $name"
            return
        fi
    fi

    ln -s "$src" "$dst"
    echo "✅ $name → $src"
}

# ─── Install dependencies ───
install_deps() {
    local deps=("$@")
    local missing=()

    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -eq 0 ]]; then
        echo "✅ All dependencies installed (${deps[*]})"
        return
    fi

    echo "📥 Installing missing dependencies: ${missing[*]}"

    if [[ "$OS" == "Darwin" ]]; then
        if ! command -v brew &>/dev/null; then
            echo "❌ Homebrew not found. Install it first: https://brew.sh"
            return 1
        fi
        brew install "${missing[@]}"
    elif [[ "$OS" == "Linux" ]]; then
        if ! command -v pacman &>/dev/null; then
            echo "❌ pacman not found. This script requires an Arch-based distro."
            return 1
        fi
        sudo pacman -S --noconfirm "${missing[@]}"
    fi
}

# ==============================================================================
# glab-issue-helper — Interactive GitLab issue creator
# ==============================================================================

echo "── glab-issue-helper ──"
install_deps glab fzf jq
link_script "$SCRIPTS_DIR/glab-issue-helper"
echo

# ==============================================================================
# Add more scripts here as needed:
# ==============================================================================
# echo "── another-tool ──"
# install_deps dep1 dep2
# link_script "$SCRIPTS_DIR/another-tool"
# echo

echo "✅ Scripts installation complete!"
echo
