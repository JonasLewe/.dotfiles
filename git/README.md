# Git Configuration

Global git configuration with sensible defaults.

## Files

| File | Purpose | Git Tracked |
|------|---------|-------------|
| `gitconfig` | Main git config (with your name/email) | ✅ Yes |
| `gitconfig.example` | Template for new users | ✅ Yes |
| `gitconfig.local` | Machine-specific overrides | ❌ No (gitignored) |

## Installation

The install script symlinks `gitconfig` → `~/.gitconfig`

## Customization

### Option 1: Edit the main config
```bash
nvim ~/.dotfiles/git/gitconfig
```

### Option 2: Use local overrides
Create `~/.gitconfig.local` for machine-specific settings:
```ini
[user]
    email = different-email@example.com

[credential]
    helper = store  # Different credential helper
```

Then include it in your main config:
```ini
[include]
    path = ~/.gitconfig.local
```

## Features

- ✅ Sensible defaults (main branch, push autosetup)
- ✅ Useful aliases (st, co, br, ci, visual log)
- ✅ Cross-platform credential helpers
- ✅ Neovim as default editor
- ✅ Auto-coloring

## Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `git st` | `status` | Short status |
| `git co` | `checkout` | Checkout branch |
| `git br` | `branch` | List branches |
| `git ci` | `commit` | Commit changes |
| `git unstage` | `reset HEAD --` | Unstage files |
| `git last` | `log -1 HEAD` | Show last commit |
| `git visual` | `log --oneline --graph` | Visual commit tree |
