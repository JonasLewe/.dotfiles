# 🚀 Dotfiles

Professional development environment dotfiles for **macOS** and **Linux** (Debian/Ubuntu).

**Components:** Neovim • tmux • zsh • Ghostty

---

## ✨ Features

### 🎯 **Minimal & Learning-Focused**
- **Start simple, add complexity when needed**
- Every feature is understandable and debuggable
- No hidden magic, no overwhelming plugins

### 🖥️ **Terminal Setup**
- **zsh** with oh-my-zsh + simple theme (only git + vi-mode plugins)
- **tmux** with vim keybindings (no theme, no plugins)
- **Ghostty** terminal (macOS) with cyberpunk aesthetics

### ⚡ **Performance Optimized**
- Shell startup: **~200ms** (lazy-loaded nvm)
- Neovim startup: **~150ms** (lazy.nvim plugin manager)
- Minimal plugin overhead

### 🔒 **Secure**
- API keys separated into `.zshrc.local` (gitignored)
- Safe installation scripts (prompts before overwriting)
- Cross-platform compatibility

### 🎨 **Modern Development Environment**
- **LSP** for Python, TypeScript, Java, Lua, YAML, Helm
- **Treesitter** syntax highlighting
- **Telescope** fuzzy finding
- **Git integration** with gitsigns + fugitive
- **Auto-completion** with nvim-cmp + LuaSnip
- **Markdown preview** live in browser

---

## 📦 Installation

### One-Command Setup

```bash
git clone git@github.com:JonasLewe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The install script will:
- ✅ Detect your OS (macOS or Linux)
- ✅ Install Neovim and tmux (if not present)
- ✅ Symlink all configurations
- ✅ Create `.zshrc.local` template for API keys
- ✅ Install Ghostty shaders (macOS only)

### Post-Installation

1. **Add your API keys** (optional):
   ```bash
   nvim ~/.zshrc.local
   # Add: export YOUR_API_KEY="..."
   ```

2. **Reload shell**:
   ```bash
   exec zsh
   ```

3. **Start Neovim** (plugins install automatically):
   ```bash
   nvim
   # Wait for lazy.nvim to install all plugins
   ```

4. **Start tmux**:
   ```bash
   tmux
   # Learn the keybindings (no plugins to install!)
   ```

---

## 🤖 For Claude Code: Automated Installation

**If Claude Code is setting this up on a new machine, follow these steps:**

### Step 1: Prerequisites Check
```bash
# Check if required tools are installed
which git zsh curl || echo "Missing prerequisites!"
```

### Step 2: Clone & Install
```bash
# Clone dotfiles
git clone git@github.com:JonasLewe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run installer (will prompt before overwriting)
chmod +x install.sh
./install.sh
```

### Step 3: Manual Steps (inform user)
After installation, **tell the user** to:

1. **Install oh-my-zsh** (required for zsh config):
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

2. **Install zsh-vi-mode plugin** (required):
   ```bash
   git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
   ```

3. **Add API keys** to `~/.zshrc.local` (if needed)

4. **Reload shell**: `exec zsh`

5. **Start Neovim** to install plugins: `nvim`

### Step 4: Verify Installation
```bash
# Check symlinks
ls -la ~/.zshrc ~/.tmux.conf ~/.gitconfig ~/.config/nvim

# Test tmux
tmux -V

# Test nvim
nvim --version
```

### What NOT to do:
- ❌ Don't commit `.zshrc.local` (contains secrets)
- ❌ Don't modify configs directly in `~/.config` (edit in `~/.dotfiles` instead)
- ❌ Don't install oh-my-zsh plugins that aren't in the config (minimal approach!)

### Troubleshooting:
- **Shell errors?** Check if oh-my-zsh is installed
- **Neovim errors?** Run `:checkhealth` in Neovim
- **tmux not working?** Check if symlink exists: `ls -la ~/.tmux.conf`

---

## 📁 Structure

```
dotfiles/
├── nvim/                   # Neovim configuration
│   ├── init.lua            # Entry point
│   ├── lua/jlewe/
│   │   ├── core/           # Options, keymaps
│   │   ├── plugins/        # Plugin configs (modular)
│   │   └── lazy-setup.lua  # Plugin manager bootstrap
│   └── README.md           # Neovim-specific docs
│
├── tmux/                   # tmux configuration
│   ├── tmux.conf           # Main config
│   └── README.md           # tmux docs
│
├── zsh/                    # Zsh configuration
│   ├── zshrc               # Main config (no secrets!)
│   ├── zshrc.local.example # Template for API keys
│   └── README.md           # Zsh docs
│
├── ghostty/                # Ghostty terminal (macOS)
│   ├── config              # Main config
│   ├── themes/             # Color schemes
│   ├── shaders/            # GLSL visual effects
│   └── README.md           # Ghostty docs
│
├── install.sh              # Cross-platform installer
├── CLAUDE.md               # Full documentation for Claude Code
└── README.md               # This file
```

---

## 🎯 Quick Reference

### Zsh (Shell)
- **Startup time**: ~200ms
- **Theme**: robbyrussell (simple, clear)
- **Plugins**: git, vi-mode (minimal, essential)
- **Lazy loading**: nvm (saves ~700ms)
- **Philosophy**: Learn the shell first, add features later

### tmux
- **Prefix**: `Ctrl-A` (not `Ctrl-B`)
- **Split vertical**: `Ctrl-A |`
- **Split horizontal**: `Ctrl-A -`
- **Navigate panes**: `Ctrl-A h/j/k/l` (vim-style)
- **Resize panes**: `Ctrl-A H/J/K/L` (vim-style)
- **Reload config**: `Ctrl-A r`
- **Philosophy**: No plugins - learn tmux basics first

### Neovim
- **Leader key**: `Space`
- **File explorer**: `Space e`
- **Find files**: `Space ff`
- **Live grep**: `Space fs`
- **LSP goto definition**: `gd`
- **LSP code action**: `Space ca`

### Ghostty (macOS)
- **Reload config**: `Cmd+R`
- **Toggle fullscreen**: `Cmd+Ctrl+F`
- **Active theme**: Synthwave84 (retro cyberpunk)
- **Shaders**: cursor_smear + glitchy (customizable)

---

## 🔧 Customization

Each component has its own README with detailed documentation:

- **Neovim**: See `CLAUDE.md` for full plugin list and keybindings
- **tmux**: See `tmux/README.md` for customization
- **Zsh**: See `zsh/README.md` for plugin management
- **Ghostty**: See `ghostty/README.md` for themes and shaders
- **Git**: See `git/README.md` for aliases and config
- **Full docs**: See `CLAUDE.md` (comprehensive guide for all tools)

---

## 🌍 Cross-Platform Notes

### macOS
- Uses Homebrew for package installation
- Ghostty terminal fully supported
- Shell optimized for `/bin/zsh`

### Linux (Debian/Ubuntu)
- Uses `apt` for package installation
- Ghostty skipped (macOS only), use Alacritty/Kitty instead
- AppImage for Neovim installation

---

## 🛠️ Prerequisites

### Required
- **Git** (for cloning and plugin management)
- **zsh** (shell)
- **curl** (for downloads)

### Installed Automatically
- **Neovim** (via AppImage/Homebrew)
- **tmux** (via apt/Homebrew)
- **Ghostty shaders** (macOS only, external repo)

### Recommended
- **oh-my-zsh**: https://ohmyz.sh/#install
- **zsh-vi-mode plugin**: https://github.com/jeffreytse/zsh-vi-mode
- **JetBrainsMono Nerd Font**: `brew install font-jetbrains-mono-nerd-font`

---

## 🔐 Security

- ✅ **API keys** are in `.zshrc.local` (gitignored)
- ✅ **Sensitive data** never committed to repository
- ✅ **Template files** (`.example`) provided for new machines
- ⚠️ Review `.zshrc.local` before adding real secrets

---

## 📚 Learning Resources

New to these tools? Start here:

1. **Neovim basics**: Run `:Tutor` in Neovim
2. **tmux basics**: https://tmuxcheatsheet.com/
3. **Zsh customization**: https://github.com/ohmyzsh/ohmyzsh/wiki
4. **LSP in Neovim**: `:help lsp`
5. **lazy.nvim plugins**: https://github.com/folke/lazy.nvim

---

## 🤝 Contributing

This is a personal dotfiles repo, but feel free to:
- Fork for your own setup
- Open issues for bugs
- Suggest improvements via PR

---

## 📝 License

MIT License - Use freely!

---

## 🎉 Credits

- **Neovim**: https://neovim.io
- **tmux**: https://github.com/tmux/tmux
- **oh-my-zsh**: https://ohmyz.sh
- **Ghostty**: https://ghostty.org
- **lazy.nvim**: https://github.com/folke/lazy.nvim
- **Ghostty Shaders**: https://github.com/0xhckr/ghostty-shaders

Built with ❤️ for minimal, learning-focused development.
