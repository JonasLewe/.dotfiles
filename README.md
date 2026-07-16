# Dotfiles

Cross-platform personal dotfiles for **macOS** and **Arch Linux**. One repo, both platforms.

## What's included

### Shared
- **Neovim** — native LSP completion, Treesitter, Telescope, Trouble, LazyGit, Jira, DAP, JupyNvim, cyberdream
- **tmux** — Vanilla config, vim keybindings, no plugin manager
- **zsh** — Plain zsh with vi-mode, no frameworks
- **Ghostty** — GPU-accelerated terminal (platform-specific overrides via symlink)
- **Git** — Minimal gitconfig (email via `~/.gitconfig.local`)

### Linux (Arch / CachyOS)
- **Hyprland** — Tiling Wayland compositor (+ Waybar, Rofi, Dunst)

Philosophy: **vanilla first** — learn native features before adding plugins.

## Installation

Requires macOS (Homebrew) or an Arch-based distro (pacman).

```bash
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
./install.sh           # First install (interactive)
./install.sh --update  # Re-run: skip prompts, install only what's missing
```

The installer auto-detects the OS, installs packages, symlinks configs, and prompts for machine-specific settings. Idempotent — safe to re-run.

### Optional Jira integration

Jira support is machine-local and has no plugin cost on machines that do not use it. `jira.nvim` is enabled and installed only when `~/.config/nvim/jira.local.lua` exists. To enable it, copy `nvim/jira.example.lua` to that path, adjust the project settings, and authenticate once with `:Jira auth login`. The example defaults to read-only mode, which blocks Jira writes and Jira-triggered Git branch changes.

## Documentation

See `CLAUDE.md` for the full reference: architecture, keybindings, plugin list, platform matrix, and guides.
