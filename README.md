# Dotfiles

Personal dotfiles for CachyOS (Arch Linux). Full desktop stack: Hyprland, Neovim, tmux, zsh, Ghostty.

## What's included

- **Hyprland** — Tiling Wayland compositor (+ Waybar, Rofi, Dunst)
- **Neovim** — LSP, Treesitter, Telescope, aerial.nvim, trouble.nvim
- **tmux** — Vanilla config, vim keybindings, no plugin manager
- **zsh** — Plain zsh with vi-mode, no frameworks
- **Ghostty** — GPU-accelerated terminal

Philosophy: **vanilla first** — learn native features before adding plugins.

## Installation

Requires an Arch-based distro (pacman).

```bash
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer handles packages, symlinks, and optionally the Hyprland rice stack.

## Documentation

See `CLAUDE.md` for the full reference: architecture, keybindings, plugin list, and guides.
