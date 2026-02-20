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
- ✅ Install TPM (Tmux Plugin Manager)
- ✅ Create `.zshrc.local` template for API keys

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

3. **Start tmux and install plugins**:
   ```bash
   tmux
   # Press: Ctrl-A + I (capital I)
   ```

4. **Start Neovim** (plugins install automatically):
   ```bash
   nvim
   ```

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
- **Auto-starts tmux**: Opens default session
- **Reload config**: `Cmd+R`
- **Toggle fullscreen**: `Cmd+Ctrl+F`
- **Active theme**: Synthwave84 (retro cyberpunk)

---

## 🔧 Customization

Each component has its own README with detailed documentation:

- **Neovim**: See `nvim/README.md` or `NEOVIM_DETAILS.md`
- **tmux**: See `tmux/README.md`
- **Zsh**: See `zsh/README.md`
- **Ghostty**: See `ghostty/README.md`
- **Full docs**: See `CLAUDE.md` (for Claude Code AI assistant)

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
- **TPM** (Tmux Plugin Manager)

### Recommended
- **oh-my-zsh**: https://ohmyz.sh/#install
- **Powerlevel10k theme**: https://github.com/romkatv/powerlevel10k
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
- **Dracula theme**: https://draculatheme.com

Built with ❤️ for developer productivity.
