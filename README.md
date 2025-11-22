# Jonas' Dotfiles

Modern development environment configuration for Neovim and tmux.

## Features

### Neovim
- **30+ plugins** managed with lazy.nvim
- **LSP support** with Mason for easy language server installation
- **Autocompletion** with nvim-cmp
- **Fuzzy finding** with Telescope
- **File explorer** with Neo-tree
- **Git integration** with gitsigns and fugitive
- **Modern UI** with Tokyo Night theme
- **Treesitter** for advanced syntax highlighting

### tmux
- **Ctrl+a** prefix (more ergonomic than Ctrl+b)
- **Vim-like** pane navigation and resizing
- **Mouse support** enabled
- **Plugin manager** (TPM) with session persistence
- **Custom status line** with useful information

## Quick Installation

```bash
# Clone this repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles

# Run the installation script
cd ~/.dotfiles
./install.sh
```

The install script will:
- Create symlinks for all configurations
- Backup existing configs (if any)
- Check for required dependencies

## Manual Installation

If you prefer to set up manually:

```bash
# Neovim
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# tmux
ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
```

## Dependencies

### Required
- **Neovim** >= 0.11.0
- **tmux** >= 3.0
- **Git**

### Optional (but recommended)
- **Node.js & npm** - For TypeScript/JavaScript LSP (pyright, ts_ls)
- **Python 3** - For Python LSP
- **ripgrep** - For fast searching in Telescope
- **fd** - For fast file finding in Telescope
- **Nerd Font** - For icons (recommended: JetBrainsMono Nerd Font)

Install on Debian/Ubuntu:
```bash
sudo apt install neovim tmux git ripgrep fd-find nodejs npm
```

## Post-Installation

### Neovim
1. Open Neovim: `nvim`
2. Plugins will install automatically on first launch
3. Install language servers: `:Mason` then press `I` on desired servers
4. For Python/TypeScript LSP (requires Node.js):
   ```vim
   :MasonInstall pyright ts_ls
   ```

### tmux
1. Install TPM (tmux plugin manager):
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```
2. Start tmux: `tmux`
3. Install plugins: Press `Ctrl+a` then `I` (capital i)

## Key Bindings

### Neovim

#### General
- `Space` - Leader key
- `:Lazy` - Open plugin manager
- `:Mason` - Open LSP installer

#### File Navigation
- `Space e` - Toggle file explorer (Neo-tree)
- `Space ff` - Find files (Telescope)
- `Space fg` - Find in files (Live grep)
- `Space fb` - Find buffers
- `Space fh` - Find help tags

#### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `gD` - Go to declaration
- `K` - Hover documentation
- `Space rn` - Rename symbol
- `Space ca` - Code action
- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `Space d` - Show diagnostic

#### Editing
- `gcc` - Comment/uncomment line
- `gc` - Comment/uncomment motion (e.g., `gcap` for paragraph)
- `ys{motion}{char}` - Surround with char (e.g., `ysiw"` wraps word in quotes)
- `ds{char}` - Delete surrounding char (e.g., `ds"` removes quotes)
- `cs{old}{new}` - Change surrounding char (e.g., `cs"'` changes " to ')

#### Git
- `Space gb` - Git blame
- `Space gd` - Git diff
- `]h` - Next hunk
- `[h` - Previous hunk

### tmux

#### Session/Window Management
- `Ctrl+a c` - Create new window
- `Ctrl+a ,` - Rename window
- `Ctrl+a n` - Next window
- `Ctrl+a p` - Previous window
- `Ctrl+a 0-9` - Switch to window by number

#### Pane Management
- `Ctrl+a |` - Split vertically
- `Ctrl+a -` - Split horizontally
- `Ctrl+a h/j/k/l` - Navigate panes (vim-style)
- `Ctrl+a H/J/K/L` - Resize panes (vim-style)
- `Ctrl+a o` - Cycle through panes
- `Ctrl+a x` - Kill pane

#### Other
- `Ctrl+a r` - Reload tmux config
- `Ctrl+a [` - Enter copy mode (use vim keys to navigate)
- `Ctrl+a d` - Detach from session

## Directory Structure

```
.dotfiles/
├── nvim/                       # Neovim configuration
│   ├── init.lua               # Entry point
│   └── lua/
│       ├── config/            # Core configuration
│       │   ├── options.lua    # Vim options
│       │   ├── keymaps.lua    # Key mappings
│       │   └── lazy.lua       # Plugin manager setup
│       └── plugins/           # Plugin configurations
│           ├── colorscheme.lua
│           ├── treesitter.lua
│           ├── lsp.lua
│           ├── telescope.lua
│           ├── neo-tree.lua
│           ├── git.lua
│           └── editing.lua
├── tmux/
│   └── tmux.conf              # tmux configuration
├── install.sh                 # Installation script
└── README.md                  # This file
```

## Customization

### Neovim
- Edit `~/.dotfiles/nvim/lua/config/options.lua` for vim options
- Edit `~/.dotfiles/nvim/lua/config/keymaps.lua` for custom keybindings
- Add new plugins in `~/.dotfiles/nvim/lua/plugins/`

### tmux
- Edit `~/.dotfiles/tmux/tmux.conf`
- Reload with `Ctrl+a r` or `tmux source-file ~/.tmux.conf`

## Updating

```bash
cd ~/.dotfiles
git pull
./install.sh
```

## Troubleshooting

### Neovim plugins not installing
- Run `:Lazy sync` in Neovim
- Check `:checkhealth` for issues

### tmux prefix not working
- Make sure config is loaded: `tmux source-file ~/.tmux.conf`
- Or restart tmux completely: `tmux kill-server && tmux`

### LSP not working
- Check if language server is installed: `:Mason`
- Check LSP status: `:LspInfo`
- For Python/TypeScript, ensure Node.js is installed

## Credits

Built with love using:
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [Neovim](https://neovim.io/)
- [tmux](https://github.com/tmux/tmux)

## License

Feel free to use and modify as you wish!
