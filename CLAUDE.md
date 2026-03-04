# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **cross-platform** personal dotfiles repository for **macOS and Arch Linux**. One repo, both platforms. The philosophy is **vanilla first** — use native features before adding plugins. Learn the fundamentals, then extend.

### Shared (both platforms)
- **Ghostty** — GPU-accelerated terminal emulator (with commented Mac overrides)
- **Neovim** — Config with LSP, treesitter, telescope.nvim, nvim-cmp, aerial.nvim, trouble.nvim, cyberdream, vim-surround
- **tmux** — Vanilla config with vim keybindings (no plugin manager)
- **zsh** — Plain zsh with vi-mode (no frameworks)
- **Git** — Minimal gitconfig (email via `~/.gitconfig.local`)

### Linux-only (Arch / CachyOS)
- **Hyprland** — Tiling Wayland compositor with vim-style keybindings
- **Waybar** — Minimal status bar
- **Rofi** — Application launcher
- **Dunst** — Notification daemon

### macOS-only
- **AeroSpace** — i3-like tiling window manager (no SIP required, instant workspaces)

## Installation & Setup

**Requires:** macOS (Homebrew) or Arch-based distro (pacman).

```bash
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The install script auto-detects the OS and:
- **macOS**: Installs via Homebrew, symlinks shared configs + AeroSpace WM
- **Linux**: Installs via pacman, optionally installs Hyprland + rice tools
- Prompts for git email → writes to `~/.gitconfig.local`
- Creates `~/.zshrc.local` for machine-specific config (nvm, IBM CLI, etc.)
- Sets zsh as default shell

### Symlink Matrix

| Config | Target | Platform |
|--------|--------|----------|
| `nvim/` | `~/.config/nvim/` | All |
| `tmux/tmux.conf` | `~/.tmux.conf` | All |
| `zsh/zshrc` | `~/.zshrc` | All |
| `zsh/zprofile` | `~/.zprofile` | All |
| `git/gitconfig` | `~/.gitconfig` | All |
| `ghostty/` | `~/.config/ghostty/` | All |
| `aerospace/` | `~/.config/aerospace/` | macOS |
| `hyprland/` | `~/.config/hypr/` | Linux |
| `waybar/` | `~/.config/waybar/` | Linux |
| `rofi/` | `~/.config/rofi/` | Linux |
| `dunst/` | `~/.config/dunst/` | Linux |

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
│       │   ├── cmp.lua          # nvim-cmp + LuaSnip (autocompletion)
│       │   ├── colorscheme.lua  # cyberdream (transparent dark theme)
│       │   ├── editor.lua      # vim-surround
│       │   ├── lsp.lua         # mason + lspconfig (LSP setup)
│       │   ├── navigation.lua  # aerial.nvim + trouble.nvim
│       │   ├── telescope.lua   # telescope.nvim + fzf-native
│       │   └── treesitter.lua
│       └── lazy-setup.lua
├── tmux/tmux.conf           # tmux config
├── zsh/
│   ├── zshrc                # Interactive shell config
│   └── zprofile             # Login shell (PATH, Hyprland auto-start)
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
│   ├── gitconfig            # Shared (email in ~/.gitconfig.local)
│   ├── gitconfig.local.example  # Template for per-machine email
│   └── gitignore_global
├── aerospace/aerospace.toml  # macOS tiling WM (i3-like)
├── install.sh               # Unified installer (macOS + Linux)
└── docs/
    ├── vanilla-vim-guide.md # Native Vim alternatives tutorial
    ├── neovim-details.md    # Neovim config deep-dive (architecture, keybinds, LSP)
    └── rice-guide.md        # Hyprland rice setup tutorial
```

### Key Design Patterns

**Vanilla First**: Native features over plugins:
- `:Ex`/`:Lex` instead of nvim-tree
- `:find` + `path+=**` as vanilla alternative to Telescope (telescope.nvim now installed for fuzzy finding)
- Visual Block Mode (`<C-v>`) instead of Comment.nvim
- `:grep` with ripgrep as vanilla alternative to Telescope live_grep

**Per-machine config**: Git email and machine-specific secrets live outside the repo:
- `~/.gitconfig.local` — git email (created by install.sh)
- `~/.zshrc.local` — API keys, work aliases

**Vim keybindings everywhere**: Hyprland (SUPER+hjkl), tmux (prefix+hjkl), Neovim (Ctrl+hjkl), zsh (bindkey -v).

## Neovim

### Installed Plugins
- **lazy.nvim** — Plugin manager (auto-bootstraps)
- **cyberdream.nvim** — Dark colorscheme with transparency support
- **vim-surround** — Add/change/delete surroundings (`ys`, `ds`, `cs`)
- **treesitter** — AST-based syntax highlighting
- **nvim-cmp** — Autocompletion engine (LSP + snippets + buffer + path)
- **LuaSnip** — Snippet engine (for LSP snippet expansion)
- **mason.nvim** — Installs LSP servers automatically
- **mason-lspconfig.nvim** — Bridge between mason and lspconfig
- **nvim-lspconfig** — Configures LSP clients (pyright, lua_ls)
- **telescope.nvim** — Fuzzy finder (files, grep, buffers, recent files)
- **telescope-fzf-native.nvim** — Compiled C fzf algorithm for faster fuzzy matching
- **aerial.nvim** — Symbol sidebar (functions, classes, variables)
- **trouble.nvim** — Diagnostics panel (errors, warnings)

### Key Bindings (Leader: `<Space>`)
- `kj` — Exit insert/visual/terminal mode
- `<leader>e` — Toggle file explorer (netrw)
- `<leader>ff` — Find files (telescope)
- `<leader>fr` — Recent files (telescope)
- `<leader>fg` — Live grep (telescope)
- `<leader>fb` — Buffers (telescope)
- `<leader>sv/sh` — Split vertically/horizontally
- `<C-h/j/k/l>` — Navigate splits
- `<leader>+/-` — Increment/decrement number
- `<leader>nh` — Clear search highlights
- `<leader>tt` — Terminal split
- `<leader>cs` — Toggle symbol sidebar (aerial)
- `<leader>xx` — Toggle diagnostics panel (trouble)

### LSP Key Bindings (active in files with LSP)
- `gd` — Go to definition
- `gr` — Show references
- `K` — Hover documentation
- `<leader>ca` — Code action (quick fixes)
- `<leader>rn` — Rename symbol
- `<leader>d` — Line diagnostics
- `[d` / `]d` — Previous/next diagnostic

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
- Hyprland auto-starts on TTY1 login on Linux (guarded by `uname` check)

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

## macOS Window Management — AeroSpace

Config: `aerospace/aerospace.toml`. i3-like tiling WM. No SIP required.
Layout: tiles. Gaps: 2px. Instant workspace switching (bypasses Mission Control).

### Key Bindings
- `Alt + h/j/k/l` — Focus window
- `Alt + Shift + h/j/k/l` — Move/swap window
- `Alt + Shift + m` — Fullscreen
- `Alt + Shift + e` — Balance sizes
- `Alt + Shift + t` — Toggle float/tiling
- `Ctrl + 1-8` — Switch workspace (instant)
- `Ctrl + Shift + 1-8` — Move window to workspace
- `Alt + Shift + s/g` — Move window to left/right monitor
- `Alt + Tab` — Workspace back-and-forth
- `Alt + Shift + ;` — Enter service mode (r=reset, f=float, Esc=exit)

### Floating Apps (not tiled)
System Settings, Calculator, QuickTime, Finder, Cisco Secure Client, Webex.

---

## Git Email

Git email is **not** in the shared gitconfig. Each machine sets it via `~/.gitconfig.local`:
```bash
git config --file ~/.gitconfig.local user.email you@example.com
```
The install script prompts for this during setup.

---

## Guides

- `docs/vanilla-vim-guide.md` — Native Vim alternatives to common plugins
- `docs/neovim-details.md` — Neovim config deep-dive (architecture, keybinds, LSP, plugins)
- `docs/rice-guide.md` — Full Hyprland rice setup tutorial (CachyOS)
