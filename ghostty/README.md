# Ghostty Terminal Configuration

GPU-accelerated terminal emulator with custom shaders and themes.

## What is Ghostty?

Ghostty is a fast, feature-rich, and GPU-accelerated terminal emulator built in Zig.
- Website: https://ghostty.org
- **Platform**: macOS (Linux support coming soon)

## Features

- ✅ **Auto-starts tmux** - Opens default session on launch
- ✅ **Custom GLSL shaders** - Visual effects (cursor trails, bloom, CRT, etc.)
- ✅ **Synthwave84 theme** - Retro cyberpunk aesthetics
- ✅ **JetBrainsMono Nerd Font** - Programming font with icons
- ✅ **Maximized window** - Full screen on startup
- ✅ **Custom keybindings** - Quick config reload

## Installation

### Prerequisites

1. **Install Ghostty** (macOS only)
   ```bash
   brew install ghostty
   ```

2. **Install JetBrainsMono Nerd Font**
   ```bash
   brew tap homebrew/cask-fonts
   brew install font-jetbrains-mono-nerd-font
   ```

### Setup

The install script handles configuration automatically:
```bash
./install.sh
```

This will:
1. Symlink `ghostty/` → `~/.config/ghostty/`
2. Clone shaders repo: `https://github.com/0xhckr/ghostty-shaders` → `~/.config/ghostty/shaders/`

**Manual shader installation** (if needed):
```bash
git clone https://github.com/0xhckr/ghostty-shaders ~/.config/ghostty/shaders
```

## Configuration Structure

```
ghostty/
├── config              # Main configuration
├── themes/             # Color schemes
│   ├── synthwave84     # Active theme (retro cyberpunk)
│   ├── cyberdream
│   ├── tokyonight
│   └── cyberpunk-neon
└── shaders/            # GLSL visual effects (40+ shaders)
    ├── cursor_smear.glsl    # Active: cursor trail effect
    ├── bloom.glsl
    ├── crt.glsl
    ├── matrix-hallway.glsl
    └── ...
```

## Customization

### Change Theme

Edit `config` line 5:
```conf
# Uncomment the theme you want:
# config-file = themes/cyberdream
# config-file = themes/tokyonight
config-file = themes/synthwave84
```

### Change Shaders

Edit `config` around line 12:
```conf
# Enable different shaders:
custom-shader = shaders/cursor_smear.glsl
# custom-shader = shaders/bloom.glsl
# custom-shader = shaders/crt.glsl
```

Try different combinations! All available shaders are in `shaders/`.

### Disable Auto-tmux

Edit `config` line 8:
```conf
# Comment out to disable auto-tmux:
# command = tmux new -A -s default
```

### Change Font

Edit `config` line 49:
```conf
font-family = "JetBrainsMono Nerd Font"
font-size = 14
```

## Keybindings

| Key | Action |
|-----|--------|
| `Cmd+R` | Reload configuration |
| `Cmd+Ctrl+F` | Toggle fullscreen |

## Platform Notes

### macOS
- Full support with all features
- Uses macOS-specific settings (hidden titlebar, option key)

### Linux
- Coming soon (Ghostty is expanding Linux support)
- Configuration should work out of the box when available

## Shader Gallery

Popular shaders included:
- **cursor_smear.glsl** - Smooth cursor trail (currently active)
- **bloom.glsl** - Glowing text effect
- **crt.glsl** - Retro CRT monitor simulation
- **matrix-hallway.glsl** - Matrix-style animations
- **starfield.glsl** - Moving stars background
- **retro-terminal.glsl** - Old-school terminal look

Experiment and find your favorite! 🎨

## Troubleshooting

**Ghostty not starting?**
- Ensure Ghostty is installed: `brew install ghostty`
- Check config syntax: `ghostty --config-check`

**Font looks wrong?**
- Install JetBrainsMono Nerd Font (see Prerequisites)
- Or change to a system font in config

**Shaders not working?**
- Requires GPU acceleration (should work on all modern Macs)
- Try disabling shaders temporarily to debug

**tmux not starting automatically?**
- Ensure tmux is installed: `brew install tmux`
- Check PATH includes tmux: `which tmux`

See `CLAUDE.md` for detailed documentation.
