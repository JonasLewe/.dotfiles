#!/usr/bin/env bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Dotfiles Uninstallation Script       ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to remove symlink
remove_symlink() {
    local target="$1"

    if [ -L "$target" ]; then
        echo -e "${YELLOW}Removing symlink: $target${NC}"
        rm "$target"
        echo -e "${GREEN}✓ Removed: $target${NC}"
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}Warning: $target exists but is not a symlink${NC}"
        echo -e "${YELLOW}Skipping... (use --force to remove anyway)${NC}"
    else
        echo -e "${BLUE}$target does not exist${NC}"
    fi
}

echo -e "${BLUE}Removing dotfile symlinks...${NC}"
echo ""

# Remove Neovim config
echo -e "${BLUE}[1/2] Removing Neovim configuration...${NC}"
remove_symlink "$HOME/.config/nvim"

# Remove tmux config
echo -e "${BLUE}[2/2] Removing tmux configuration...${NC}"
remove_symlink "$HOME/.tmux.conf"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Uninstallation complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check for backups
echo -e "${BLUE}Checking for backups...${NC}"
backups=$(find "$HOME/.config" "$HOME" -maxdepth 1 -name "*.backup.*" 2>/dev/null || true)

if [ -n "$backups" ]; then
    echo -e "${GREEN}Found backups:${NC}"
    echo "$backups"
    echo ""
    echo -e "${YELLOW}To restore a backup:${NC}"
    echo "  mv <backup-file> <original-location>"
    echo "  Example: mv ~/.tmux.conf.backup.20251122 ~/.tmux.conf"
else
    echo -e "${BLUE}No backups found${NC}"
fi

echo ""
echo -e "${YELLOW}Note: This script only removes symlinks.${NC}"
echo -e "${YELLOW}The dotfiles repository at ~/.dotfiles is still intact.${NC}"
echo -e "${YELLOW}To completely remove: rm -rf ~/.dotfiles${NC}"
echo ""
