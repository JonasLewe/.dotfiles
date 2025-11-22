#!/usr/bin/env bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Jonas' Dotfiles Installation Script  ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to create backup
backup_if_exists() {
    if [ -e "$1" ]; then
        echo -e "${YELLOW}Backing up existing $1${NC}"
        mv "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    fi
}

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ]; then
        echo -e "${YELLOW}Removing existing symlink: $target${NC}"
        rm "$target"
    elif [ -e "$target" ]; then
        backup_if_exists "$target"
    fi

    mkdir -p "$(dirname "$target")"
    ln -sf "$source" "$target"
    echo -e "${GREEN}✓ Linked: $target -> $source${NC}"
}

echo -e "${BLUE}Installing dotfiles...${NC}"
echo ""

# Install Neovim config
echo -e "${BLUE}[1/2] Installing Neovim configuration...${NC}"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Install tmux config
echo -e "${BLUE}[2/2] Installing tmux configuration...${NC}"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"
echo ""

dependencies=(
    "nvim:Neovim"
    "tmux:tmux"
    "git:Git"
    "zsh:Zsh (optional, recommended)"
)

missing_deps=()

for dep in "${dependencies[@]}"; do
    cmd="${dep%%:*}"
    name="${dep##*:}"

    if command -v "$cmd" &> /dev/null; then
        version=$($cmd --version 2>&1 | head -n1)
        echo -e "${GREEN}✓ $name found: $version${NC}"
    else
        echo -e "${RED}✗ $name not found${NC}"
        missing_deps+=("$name")
    fi
done

echo ""

if [ ${#missing_deps[@]} -eq 0 ]; then
    echo -e "${GREEN}All dependencies are installed!${NC}"
else
    echo -e "${YELLOW}Missing dependencies:${NC}"
    for dep in "${missing_deps[@]}"; do
        echo -e "  - $dep"
    done
    echo ""
    echo -e "${YELLOW}Install missing dependencies with:${NC}"
    echo -e "  sudo apt install nvim tmux git zsh"
fi

echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Restart tmux or run: tmux source-file ~/.tmux.conf"
echo -e "  2. Open nvim - plugins will install automatically"
echo -e "  3. (Optional) Install Node.js for TypeScript/Python LSP:"
echo -e "     sudo apt install nodejs npm"
echo -e "     Then in nvim: :MasonInstall pyright ts_ls"
echo ""
echo -e "${GREEN}Enjoy your new setup!${NC}"
