# Dotfiles

Cross-platform personal dotfiles for **macOS** and **Arch Linux**. One repo, both platforms.

## What's included

### Shared
- **Neovim** — LSP, Treesitter, Telescope, nvim-cmp, aerial.nvim, trouble.nvim, lazygit, cyberdream
- **tmux** — Vanilla config, vim keybindings, no plugin manager
- **zsh** — Plain zsh with vi-mode, no frameworks
- **Ghostty** — GPU-accelerated terminal (platform-specific overrides via symlink)
- **Git** — Minimal gitconfig (email via `~/.gitconfig.local`)

### Linux (Arch / CachyOS)
- **Hyprland** — Tiling Wayland compositor (+ Waybar, Rofi, Dunst)

### macOS
- **AeroSpace** — i3-like tiling window manager (no SIP required)

Philosophy: **vanilla first** — learn native features before adding plugins.

## Installation

Requires macOS (Homebrew) or an Arch-based distro (pacman).

```bash
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer auto-detects the OS, installs packages, symlinks configs, and prompts for machine-specific settings (git email, Nerd Font, Hyprland rice on Linux).

## Documentation

See `CLAUDE.md` for the full reference: architecture, keybindings, plugin list, platform matrix, and guides.
