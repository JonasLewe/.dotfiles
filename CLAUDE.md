# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for development environment setup. It includes:
- **Neovim** - Modern text editor with LSP, treesitter, and autocompletion
- **tmux** - Terminal multiplexer with vim keybindings and session persistence

The configuration is optimized for development work with Python, LaTeX, and general text editing, with a focus on performance and ergonomics.

## Installation & Setup

### Initial Setup
```bash
# Install Neovim, tmux, and configure dotfiles
./install.sh
```

The install script:
- **Detects OS** (Linux/Debian or macOS) and installs accordingly
- **Neovim**: Installs via AppImage (Linux) or Homebrew (macOS)
- **tmux**: Installs via apt (Linux) or Homebrew (macOS)
- **Symlinks configurations**:
  - `./nvim/` → `~/.config/nvim/`
  - `./tmux/tmux.conf` → `~/.tmux.conf`
- **TPM**: Installs Tmux Plugin Manager for theme and plugins
- lazy.nvim auto-bootstraps on first Neovim launch
- Prompts before overwriting existing configurations

### Font Installation
```bash
# Install DroidSansMono Nerd Font (optional but recommended for icons)
./install_nerd_font.sh
```

### Reset Configuration
```bash
# WARNING: Completely removes Neovim, plugins, and all config files
./reset.sh
```
This removes:
- `~/.local/share/nvim` (plugin data)
- `~/.local/state/nvim` (state files)
- `~/.cache/nvim` (cache)
- `~/.config/nvim` (configuration)
- `/usr/local/bin/nvim` (binary)

## Configuration Architecture

### Module Structure
The Neovim configuration follows a modular architecture located in `nvim/lua/jlewe/`:

```
nvim/
├── init.lua                          # Entry point, loads core settings and lazy.nvim
├── lua/jlewe/
│   ├── core/                         # Core Neovim settings
│   │   ├── options.lua              # Editor options
│   │   ├── keymaps.lua              # Key mappings
│   │   └── colorscheme.lua          # Color scheme setup
│   ├── plugins/                      # Plugin configurations
│   │   ├── lsp/                     # LSP-related configs
│   │   │   ├── mason.lua            # LSP server management
│   │   │   ├── lspconfig.lua        # LSP server configurations
│   │   │   └── lspsaga.lua          # Enhanced LSP UI
│   │   ├── nvim-cmp.lua             # Autocompletion
│   │   ├── telescope.lua             # Fuzzy finder
│   │   ├── nvim-tree.lua            # File explorer
│   │   ├── lualine.lua              # Status line
│   │   └── treesitter.lua           # Syntax highlighting & parsing
│   └── lazy-setup.lua                # lazy.nvim plugin manager setup
└── plugin/
    └── packer_compiled.lua           # Legacy file (no longer used)
```

### Key Design Patterns

**Module Loading**: Core settings load first, then lazy.nvim bootstraps and loads all plugins, finally colorscheme is applied (nvim/init.lua:1-9).

**Plugin Management**: lazy.nvim auto-bootstraps on first launch and provides lazy loading for better startup performance. Plugin specs are defined in `lazy-setup.lua` with event-based and filetype-based lazy loading.

**Safe Configuration**: All plugin configurations use `pcall()` to prevent errors if plugins aren't installed yet.

**Lazy Loading**: Plugins load based on events (e.g., `BufReadPre`, `InsertEnter`) or filetypes (e.g., `python`, `tex`) to optimize startup time.

## Plugin Management with lazy.nvim

### Working with Plugins

When modifying `nvim/lua/jlewe/lazy-setup.lua`:
1. Add/remove plugin specs in the `require("lazy").setup({})` table
2. Save and restart Neovim
3. Run `:Lazy` to open the lazy.nvim UI
4. Use `:Lazy sync` to install/update/clean plugins

### Lazy.nvim Commands
- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Install missing plugins, update and clean
- `:Lazy update` - Update plugins
- `:Lazy clean` - Remove unused plugins
- `:Lazy check` - Check for updates

### Installed LSP Servers

The following LSP servers are auto-installed via Mason (nvim/lua/jlewe/plugins/lsp/mason.lua:18-24):
- `jsonls` - JSON
- `marksman` - Markdown
- `ltex` - LaTeX
- `lua_ls` - Lua
- `pyright` - Python

To add new LSP servers, update the `ensure_installed` table in `nvim/lua/jlewe/plugins/lsp/mason.lua`.

## Modern Features (Added in 2026 Update)

### Treesitter
Provides advanced syntax highlighting, indentation, and code understanding:
- Auto-installs language parsers
- Incremental selection with `<C-space>`
- Better syntax highlighting than regex-based vim syntax
- Configuration: `nvim/lua/jlewe/plugins/treesitter.lua`

### Additional Modern Plugins
- **gitsigns** - Git integration with line blame, hunk preview, and diff
- **which-key** - Displays keybinding hints in a popup (press `<leader>` and wait)
- **nvim-autopairs** - Auto-closes brackets, quotes, etc.
- **indent-blankline** - Visual indent guides
- **molten.nvim** - Full Jupyter notebook integration with inline image/plot rendering
- **image.nvim** - Terminal image rendering for plots and graphics

## Key Bindings Reference

Leader key: `<Space>`

### Important Custom Keymaps (nvim/lua/jlewe/core/keymaps.lua)
- `kj` - Exit insert/visual/terminal mode (alternative to ESC)
- `<leader>e` - Toggle file explorer (NvimTree)
- `<leader>ff` - Find files (Telescope)
- `<leader>fs` - Live grep search (Telescope)
- `<leader>pt` - Open IPython terminal
- `<leader>tt` - Open default terminal
- `<leader>sv/sh` - Split window vertically/horizontally

## Language Support

### Python Development
- LSP: Pyright
- Interactive REPL: vim-sendtowindow plugin
- Jupyter integration: **molten.nvim** - Interactive Jupyter notebooks with inline output rendering
  - Image rendering via image.nvim (matplotlib plots, charts, images)
  - Async execution with persistent output
  - Multiple kernel support
  - Works with `.ipynb` files and Python scripts
- Terminal: IPython3 accessible via `<leader>pt`
- Auto-pairs for brackets and quotes

#### Molten.nvim Setup Requirements

**Python Packages** (install these first):
```bash
pip install pynvim jupyter_client cairosvg pillow pnglatex
```

**Terminal Emulator**:
- **Current setup**: iTerm2 + tmux - Image rendering is **disabled by default** (text output only)
- **For images**: Install Kitty terminal and enable `image.nvim` in config
- See MOLTEN_SETUP.md for full instructions

**Note**: Molten works great even without image rendering! You get full code execution, REPL, tables, and text output.

#### Using Molten (Jupyter in Neovim)

Keybindings (all start with `<leader>m`):
- `<leader>mi` - Initialize Molten kernel for current file
- `<leader>ml` - Evaluate current line
- `<leader>mr` - Re-evaluate current cell (visual mode: evaluate selection)
- `<leader>mc` - Re-evaluate cell
- `<leader>mj` - Run cell and move to next (like Jupyter Shift+Enter)
- `<leader>mo` - Show output window
- `<leader>mh` - Hide output window
- `<leader>md` - Delete cell
- `<leader>mx` - Interrupt execution

**Workflow**:
1. Open a `.py` file or `.ipynb` file
2. Run `<leader>mi` to initialize Jupyter kernel
3. Write code and run cells with `<leader>ml` or `<leader>mr`
4. Outputs appear below code cells with plots/images rendered inline

### LaTeX
- Editing: vimtex plugin
- LSP: ltex (grammar/spell checking)

## Modifying Configuration Files

### Adding New Keymaps
Edit `nvim/lua/jlewe/core/keymaps.lua` and use the `vim.keymap.set()` function following existing patterns.

### Adding New LSP Servers
1. Add server name to `ensure_installed` in `nvim/lua/jlewe/plugins/lsp/mason.lua`
2. Add server configuration in `nvim/lua/jlewe/plugins/lsp/lspconfig.lua`

### Changing Editor Options
Edit `nvim/lua/jlewe/core/options.lua` - use `vim.opt` or `vim.g` for settings.

### Adding New Plugins
1. Add plugin spec to `nvim/lua/jlewe/lazy-setup.lua`
2. Optionally create a dedicated config file in `nvim/lua/jlewe/plugins/`
3. Reference the config in the plugin spec using the `config` function
4. Run `:Lazy sync` to install

Example plugin spec:
```lua
{
  "plugin/name",
  event = "BufReadPre",  -- Lazy load on event
  dependencies = { "other/plugin" },
  config = function()
    require("jlewe.plugins.plugin-name")
  end,
}
```

---

## tmux Configuration

### Overview

The tmux configuration provides a productive terminal multiplexer setup with:
- **Vim-style keybindings** for navigation and pane management
- **Custom prefix key**: `Ctrl-A` (instead of default `Ctrl-B`)
- **Dracula theme** with status bar customization
- **Session persistence** via tmux-resurrect and tmux-continuum
- **Mouse support** for easy pane resizing and scrolling
- **TPM** (Tmux Plugin Manager) for plugin management

### Configuration File

Location: `tmux/tmux.conf` → symlinked to `~/.tmux.conf`

### Key Bindings

**Prefix Key**: `Ctrl-A` (instead of default `Ctrl-B`)

#### Pane Management
- `Ctrl-A |` - Split pane vertically (opens in current directory)
- `Ctrl-A -` - Split pane horizontally (opens in current directory)
- `Ctrl-A h/j/k/l` - Navigate panes (vim-style)
- `Ctrl-A H/J/K/L` - Resize panes (vim-style, repeatable)

#### Window Management
- `Ctrl-A c` - Create new window (opens in home directory)

#### Copy Mode (vim-style)
- `Ctrl-A [` - Enter copy mode
- `v` - Begin selection (in copy mode)
- `y` - Copy selection and exit (in copy mode)
- `Escape` - Exit copy mode

#### Configuration & Sessions
- `Ctrl-A r` - Reload tmux configuration
- `Ctrl-A R` - Restore saved session (tmux-resurrect)

### Installed Plugins (via TPM)

Plugins are managed by TPM and defined in `tmux/tmux.conf`:

1. **tmux-sensible** - Sensible default settings
2. **tmux-resurrect** - Save/restore tmux sessions
3. **tmux-continuum** - Automatic session save/restore (auto-save enabled)
4. **dracula/tmux** - Dracula color theme with customizable status bar

### Plugin Management with TPM

After installation, install plugins:
```bash
# Inside tmux, press:
Ctrl-A + I  # Install plugins (capital I)

# Other TPM commands:
Ctrl-A + U  # Update plugins
Ctrl-A + alt + u  # Uninstall plugins not in config
```

### Status Bar Configuration

The Dracula theme status bar shows:
- Network bandwidth
- Network status
- Battery status
- Time (24-hour format: `YYYY-MM-DD HH:MM`)
- Current session name (left icon)

### Session Persistence

Sessions are automatically saved and restored:
- **Auto-save**: Every 15 minutes (tmux-continuum)
- **Auto-restore**: Sessions restore on tmux start
- **Pane contents**: Captured and restored

### Modifying tmux Configuration

1. Edit `tmux/tmux.conf`
2. Reload config: `Ctrl-A r` (inside tmux)
3. Or restart tmux: `tmux kill-server && tmux`

### Platform-Specific Notes

**macOS**:
- Uses `reattach-to-user-namespace` for clipboard integration
- Default shell: `/bin/zsh`

**Linux/Debian**:
- May need to adjust shell path in config if using different shell
- `reattach-to-user-namespace` line can be removed (macOS-specific)

### Troubleshooting

**Colors look wrong:**
- Ensure terminal supports 256 colors and true color
- For iTerm2/Alacritty/Kitty: Should work out of the box
- Test with: `echo $TERM` (should show `screen-256color` inside tmux)

**Plugins not loading:**
1. Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
2. Press `Ctrl-A + I` inside tmux to install plugins
3. Restart tmux

**Mouse not working:**
- Mouse support is enabled by default in config
- Some terminal emulators may need additional configuration
