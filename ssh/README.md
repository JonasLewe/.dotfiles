# SSH Configuration

SSH client configuration template.

## Files

| File | Purpose | Git Tracked |
|------|---------|-------------|
| `config.example` | Template for SSH config | ✅ Yes |
| `config` | Your actual SSH config | ❌ No (gitignored) |

## Setup

**Manual setup required** (not automated by install script):

```bash
# Copy template to ~/.ssh/config
mkdir -p ~/.ssh
cp ~/.dotfiles/ssh/config.example ~/.ssh/config

# Customize with your servers
nvim ~/.ssh/config

# Set correct permissions
chmod 600 ~/.ssh/config
```

## Features

The template includes:
- ✅ Global connection settings (keep-alive, connection reuse)
- ✅ 1Password SSH agent integration (macOS)
- ✅ GitHub configuration
- ✅ Examples for personal/work servers

## Why not automated?

SSH config is **highly personal and sensitive**:
- Contains server hostnames and IPs
- References specific SSH keys
- May include internal company infrastructure
- Security risk if accidentally committed

Keep your actual `~/.ssh/config` local and private!

## 1Password SSH Agent (macOS)

If you use 1Password for SSH keys, uncomment this line:
```ssh
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

## Connection Reuse

The config enables connection reuse (ControlMaster) which speeds up repeated connections:
```bash
# First connection: Normal
ssh myserver

# Subsequent connections: Instant (reuses existing connection)
ssh myserver
```

Sockets are stored in `~/.ssh/sockets/` (create this directory if needed):
```bash
mkdir -p ~/.ssh/sockets
```
