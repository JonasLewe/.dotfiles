# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for CachyOS (Arch Linux). It covers the full desktop stack: window manager, terminal, editor, shell, and multiplexer. The philosophy is **vanilla first** — use native features before adding plugins. Learn the fundamentals, then extend.

It includes:
- **Hyprland** — Tiling Wayland compositor with vim-style keybindings
- **Waybar** — Minimal status bar
- **Rofi** — Application launcher
- **Dunst** — Notification daemon
- **Ghostty** — GPU-accelerated terminal emulator
- **Neovim** — Minimal config with treesitter and vim-surround (no LSP, no autocompletion plugins)
- **tmux** — Vanilla config with vim keybindings (no plugin manager)
- **zsh** — Plain zsh with vi-mode (no frameworks)
- **Git** — Minimal gitconfig with global gitignore

## Installation & Setup

**Requires:** CachyOS or any Arch-based distro (pacman).

```bash
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The install script:
- Installs core tools via pacman: neovim, tmux, zsh, ghostty, ripgrep, fd, ctags
- Optionally installs Hyprland + rice tools: waybar, rofi, dunst, hyprpaper, hyprlock, etc.
- Symlinks all configurations:
  - `./nvim/` → `~/.config/nvim/`
  - `./tmux/tmux.conf` → `~/.tmux.conf`
  - `./zsh/zshrc` → `~/.zshrc`
  - `./zsh/zprofile` → `~/.zprofile`
  - `./git/gitconfig` → `~/.gitconfig`
  - `./ghostty/` → `~/.config/ghostty/`
  - `./hyprland/` → `~/.config/hypr/`
  - `./waybar/` → `~/.config/waybar/`
  - `./rofi/` → `~/.config/rofi/`
  - `./dunst/` → `~/.config/dunst/`
- Sets zsh as default shell
- Prompts before overwriting existing configurations

### Reset Configuration
```bash
# WARNING: Completely removes Neovim, plugins, and all config files
./reset.sh
```

## Configuration Architecture

### Directory Structure
```
~/.dotfiles/
├── nvim/                    # Neovim config
│   ├── init.lua
│   └── lua/jlewe/
│       ├── core/
│       │   ├── options.lua  # Editor options, netrw, path/grep setup
│       │   └── keymaps.lua  # Key mappings
│       ├── plugins/
│       │   ├── editor.lua   # vim-surround
│       │   └── treesitter.lua
│       └── lazy-setup.lua
├── tmux/tmux.conf           # tmux config
├── zsh/
│   ├── zshrc                # Interactive shell config
│   └── zprofile             # Login shell (PATH)
├── ghostty/config           # Terminal emulator
├── hyprland/hyprland.conf   # Window manager
├── waybar/
│   ├── config.jsonc         # Bar modules
│   └── style.css            # Bar styling
├── rofi/
│   ├── config.rasi          # App launcher
│   └── powermenu.sh         # Power menu (lock/logout/reboot/shutdown)
├── dunst/dunstrc            # Notifications
├── git/
│   ├── gitconfig
│   └── gitignore_global
├── install.sh               # Installer (Arch/pacman)
└── docs/
    ├── vanilla-vim-guide.md # Native Vim alternatives tutorial
    └── rice-guide.md        # Hyprland rice setup tutorial
```

### Key Design Patterns

**Vanilla First**: Native features over plugins:
- `:Ex`/`:Lex` instead of nvim-tree
- `:find` + `path+=**` instead of Telescope
- `<C-x><C-n>` instead of nvim-cmp
- `ctags` + `<C-]>` instead of LSP
- Visual Block Mode (`<C-v>`) instead of Comment.nvim
- `:grep` with ripgrep instead of Telescope live_grep

**Vim keybindings everywhere**: Hyprland (SUPER+hjkl), tmux (prefix+hjkl), Neovim (Ctrl+hjkl), zsh (bindkey -v).

## Neovim

### Installed Plugins (intentionally minimal)
- **lazy.nvim** — Plugin manager (auto-bootstraps)
- **vim-surround** — Add/change/delete surroundings (`ys`, `ds`, `cs`)
- **treesitter** — AST-based syntax highlighting

### Key Bindings (Leader: `<Space>`)
- `kj` — Exit insert/visual/terminal mode
- `<leader>e` — Toggle file explorer (netrw)
- `<leader>fb` — List buffers and switch
- `<leader>sv/sh` — Split vertically/horizontally
- `<C-h/j/k/l>` — Navigate splits
- `<leader>+/-` — Increment/decrement number
- `<leader>nh` — Clear search highlights
- `<leader>tt` — Terminal split

### Adding New Keymaps
Edit `nvim/lua/jlewe/core/keymaps.lua` using `vim.keymap.set()`.

### Changing Editor Options
Edit `nvim/lua/jlewe/core/options.lua` — use `vim.opt` or `vim.g`.

### Adding New Plugins
1. Add plugin spec to a file in `nvim/lua/jlewe/plugins/`
2. Run `:Lazy sync` to install

---

## tmux

Vanilla config. No plugin manager. Prefix: `Ctrl-A`.

### Key Bindings
- `Ctrl-A |` / `Ctrl-A -` — Split vertical/horizontal
- `Ctrl-A h/j/k/l` — Navigate panes
- `Ctrl-A H/J/K/L` — Resize panes
- `Ctrl-A c` — New window
- `Ctrl-A [` → `v` → `y` — Copy mode (vim-style)
- `Ctrl-A r` — Reload config

---

## zsh

Plain zsh, no framework. Vi-mode via `bindkey -v`.

- Prompt: directory (green) + git branch (yellow)
- Completion: case-insensitive, menu selection
- History: 10,000 lines, shared across panes
- Files: `zsh/zshrc`, `zsh/zprofile`, `~/.zshrc.local` (secrets)

---

## Hyprland (Window Manager)

Tiling Wayland compositor. Config: `hyprland/hyprland.conf`.

### Key Bindings (Mod: `SUPER`)
- `SUPER + Enter` — Ghostty terminal
- `SUPER + d` — Rofi app launcher
- `SUPER + q` — Close window
- `SUPER + h/j/k/l` — Move focus
- `SUPER + Shift + h/j/k/l` — Move window
- `SUPER + Ctrl + h/j/k/l` — Resize window
- `SUPER + f` — Fullscreen
- `SUPER + v` — Toggle floating
- `SUPER + 1-9` — Switch workspace
- `SUPER + Shift + 1-9` — Move window to workspace
- `Print` — Screenshot (region select)
- `` SUPER + ` `` — Lock screen (hyprlock)
- `SUPER + Delete` — Power menu (lock/logout/reboot/shutdown)

### Waybar
Config: `waybar/config.jsonc` (modules), `waybar/style.css` (styling).
Modules: workspaces, window title, CPU, memory, network, audio, clock.

### Rofi
Config: `rofi/config.rasi`. Modi: drun (apps), run (commands), window (switch).
Vim navigation: `Ctrl+j/k`.
Power menu: `rofi/powermenu.sh` — standalone theme (breeze-dark icons), vim navigation (j/k).

### Dunst
Config: `dunst/dunstrc`. Test: `notify-send "Title" "Body"`.

---

## Guides

- `docs/vanilla-vim-guide.md` — Native Vim alternatives to common plugins
- `docs/rice-guide.md` — Full Hyprland rice setup tutorial (CachyOS)
