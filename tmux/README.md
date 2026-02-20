# tmux Configuration

Personal tmux configuration with vim keybindings, Dracula theme, and session persistence.

## Quick Reference

### Prefix Key
`Ctrl-A` (instead of default `Ctrl-B`)

### Essential Commands

```bash
# Pane Management
Ctrl-A |        # Split vertically
Ctrl-A -        # Split horizontally
Ctrl-A h/j/k/l  # Navigate panes (vim-style)
Ctrl-A H/J/K/L  # Resize panes

# Window Management
Ctrl-A c        # New window
Ctrl-A n/p      # Next/previous window

# Copy Mode
Ctrl-A [        # Enter copy mode
v               # Begin selection
y               # Copy and exit

# Configuration
Ctrl-A r        # Reload config
Ctrl-A R        # Restore session
```

### Plugin Installation

After first tmux start:
```bash
Ctrl-A + I  # Install TPM plugins (capital I)
```

## Features

- ✅ Vim-style navigation and keybindings
- ✅ Dracula theme with custom status bar
- ✅ Session persistence (auto-save every 15 minutes)
- ✅ Mouse support for easy pane management
- ✅ True color (24-bit) support
- ✅ Custom prefix key (Ctrl-A)

## Plugins

- **tmux-sensible** - Sensible defaults
- **tmux-resurrect** - Save/restore sessions
- **tmux-continuum** - Auto-save sessions
- **dracula/tmux** - Dracula theme

See `CLAUDE.md` for detailed documentation.
