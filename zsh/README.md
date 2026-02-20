# Zsh Configuration

Professional zsh configuration with oh-my-zsh, Powerlevel10k, and performance optimizations.

## Features

- ✅ **oh-my-zsh** with Powerlevel10k theme
- ✅ **Performance optimized** (~200ms startup with lazy loading)
- ✅ **Vim mode** (zsh-vi-mode plugin)
- ✅ **Autosuggestions** (fish-like suggestions)
- ✅ **Syntax highlighting**
- ✅ **Lazy loading** for nvm and IBM Cloud CLI
- ✅ **Secure** - API keys in separate `.zshrc.local` file

## Installation

The install script handles everything automatically:
```bash
./install.sh
```

This will:
1. Symlink `zsh/zshrc` → `~/.zshrc`
2. Create `~/.zshrc.local` from template
3. Preserve existing configuration (with prompt)

## Configuration Files

| File | Purpose | Git Tracked |
|------|---------|-------------|
| `zshrc` | Main config (general settings) | ✅ Yes |
| `zshrc.local.example` | Template for local config | ✅ Yes |
| `~/.zshrc.local` | API keys & machine-specific | ❌ No (gitignored) |

## Adding API Keys

Edit `~/.zshrc.local`:
```bash
# Add your API keys here
export BAM_API_KEY="your-key-here"
export ICR_KEY="your-key-here"
```

This file is **gitignored** and will NOT be committed!

## Performance

Startup time: **~180-230ms** (with all optimizations)

### Optimizations Applied

1. **Lazy loading nvm** - Saves ~700ms
2. **Lazy loading IBM Cloud CLI** - Saves ~50ms
3. **Completion caching** - Rebuilds only once per day
4. **Minimal plugins** - Only essential plugins loaded

## Customization

### Change Theme

Edit `zshrc` line 12:
```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Run `p10k configure` to customize Powerlevel10k appearance.

### Add Plugins

Edit `zshrc` plugins array:
```bash
plugins=(
    git
    zsh-vi-mode
    zsh-autosuggestions
    zsh-syntax-highlighting
    # Add more here
)
```

**Warning:** Too many plugins slow down shell startup!

### Add Aliases

Add to `~/.zshrc.local` for machine-specific aliases, or edit `zshrc` for global aliases.

## Prerequisites

Required plugins (install these first):
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-vi-mode
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode

# Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

## Troubleshooting

**Slow startup?**
- Run `zprof` to profile startup time
- Check if nvm is lazy-loaded (should not appear in top times)

**Plugins not working?**
- Ensure oh-my-zsh is installed: https://ohmyz.sh/#install
- Install missing plugins (see Prerequisites above)

**API keys not loading?**
- Check `~/.zshrc.local` exists and has proper exports
- Reload shell: `exec zsh`

See `CLAUDE.md` for detailed documentation.
