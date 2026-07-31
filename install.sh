#!/usr/bin/env bash

# Usage: ./install.sh [--update] [--config-only]
# Supports macOS/Homebrew, Arch Linux/pacman, and pre-provisioned servers.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
OS="$(uname)"
UPDATE_MODE=false
CONFIG_ONLY=false
INSTALL_RICE=false

MAC_PACKAGES=(
  neovim tmux zsh ghostty git ripgrep fd node fzf glab jq ctags w3m
  lazygit helm tree-sitter-cli
)

ARCH_PACKAGES=(
  neovim tmux zsh ghostty git ripgrep fd ctags libfido2 nodejs npm w3m
  lazygit helm base-devel tree-sitter-cli wl-clipboard
)

RICE_PACKAGES=(
  hyprland waybar rofi-wayland dunst hyprpaper hyprlock hypridle
  brightnessctl playerctl grim slurp wl-clip-persist breeze-icons
  networkmanager networkmanager-dmenu
)

REQUIRED_COMMANDS=(git nvim tmux zsh tree-sitter cc make)

parse_args() {
  local arg
  for arg in "$@"; do
    case "$arg" in
    --update)
      UPDATE_MODE=true
      ;;
    --config-only)
      CONFIG_ONLY=true
      UPDATE_MODE=true
      ;;
    *)
      echo "❌ Unknown flag: $arg"
      echo "Usage: ./install.sh [--update] [--config-only]"
      exit 1
      ;;
    esac
  done
}

link_config() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    echo "⚠️  Source not found, skipping: $src"
    return
  fi

  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    echo "✅ $dst (already linked)"
    return
  fi

  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    if [[ -d "$dst" ]] && [[ ! -L "$dst" ]]; then
      if [[ "$UPDATE_MODE" == true ]]; then
        echo "⚠️  $dst is a directory — backing up to ${dst}.bak"
        mv "$dst" "${dst}.bak"
      else
        read -r -p "$dst is a directory with files. Back up and replace? (y/n) "
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          mv "$dst" "${dst}.bak"
        else
          echo "Skipping $dst"
          return
        fi
      fi
    elif [[ "$UPDATE_MODE" == true ]]; then
      rm -rf "$dst"
    else
      read -r -p "$dst already exists. Overwrite? (y/n) "
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$dst"
      else
        echo "Skipping $dst"
        return
      fi
    fi
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "$dst -> $src"
}

install_pacman_packages() {
  local package
  for package in "$@"; do
    if pacman -Qi "$package" &>/dev/null; then
      echo "✅ $package already installed"
    else
      echo "📥 Installing $package..."
      sudo pacman -S --noconfirm "$package"
    fi
  done
}

verify_server_commands() {
  local command_name
  echo "=== Checking pre-installed server tools ==="
  for command_name in "${REQUIRED_COMMANDS[@]}"; do
    if command -v "$command_name" &>/dev/null; then
      echo "✅ $command_name found"
    else
      echo "⚠️  $command_name not found — install it manually for full functionality"
    fi
  done
}

install_packages() {
  if [[ "$CONFIG_ONLY" == true ]]; then
    verify_server_commands
    return
  fi

  case "$OS" in
  Darwin)
    command -v brew &>/dev/null || {
      echo "❌ Homebrew not found. Install it first: https://brew.sh"
      exit 1
    }
    echo "=== macOS packages ==="
    brew install "${MAC_PACKAGES[@]}"
    ;;
  Linux)
    command -v pacman &>/dev/null || {
      echo "❌ Linux installation requires an Arch-based system with pacman"
      exit 1
    }
    echo "=== Arch Linux packages ==="
    install_pacman_packages "${ARCH_PACKAGES[@]}"

    if [[ "$UPDATE_MODE" == true ]]; then
      if pacman -Qi hyprland &>/dev/null; then
        INSTALL_RICE=true
      fi
    else
      read -r -p "🎨 Install Hyprland + rice tools? (y/n) "
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_RICE=true
      fi
    fi

    if [[ "$INSTALL_RICE" == true ]]; then
      echo "=== Hyprland and rice packages ==="
      install_pacman_packages "${RICE_PACKAGES[@]}"
    fi
    ;;
  *)
    echo "❌ Unsupported operating system: $OS"
    exit 1
    ;;
  esac
}

install_font() {
  if [[ "$CONFIG_ONLY" == true ]]; then
    return
  fi

  if [[ "$OS" == "Linux" ]]; then
    install_pacman_packages ttf-jetbrains-mono-nerd
  elif brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    echo "✅ JetBrainsMono Nerd Font already installed"
  else
    brew install --cask font-jetbrains-mono-nerd-font
  fi
}

link_configs() {
  echo "=== Linking configurations ==="
  link_config "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
  link_config "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
  link_config "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
  link_config "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
  link_config "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
  link_config "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"

  if [[ "$CONFIG_ONLY" == true ]]; then
    return
  fi

  if [[ ! -f "$DOTFILES_DIR/ghostty/config" ]]; then
    cp "$DOTFILES_DIR/ghostty/config.example" "$DOTFILES_DIR/ghostty/config"
  fi
  link_config "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

  if [[ "$OS" == "Darwin" ]]; then
    ln -sf "$DOTFILES_DIR/ghostty/mac.conf" "$DOTFILES_DIR/ghostty/platform.conf"
  else
    ln -sf "$DOTFILES_DIR/ghostty/linux.conf" "$DOTFILES_DIR/ghostty/platform.conf"
  fi

  if [[ "$INSTALL_RICE" == true ]]; then
    link_config "$DOTFILES_DIR/hyprland" "$HOME/.config/hypr"
    link_config "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"
    link_config "$DOTFILES_DIR/rofi" "$HOME/.config/rofi"
    link_config "$DOTFILES_DIR/networkmanager-dmenu" "$HOME/.config/networkmanager-dmenu"
    link_config "$DOTFILES_DIR/dunst" "$HOME/.config/dunst"
  fi
}

install_neovim() {
  if ! command -v nvim &>/dev/null; then
    echo "ℹ️  nvim not found — skipping plugin and tool installation"
    return
  fi

  echo "=== Installing Neovim plugins ==="
  if DOTFILES_INSTALL=1 nvim --headless "+Lazy! restore" "+Lazy! clean" +qa 2>/tmp/nvim-lazy-sync.log; then
    echo "✅ Neovim plugins installed"
  else
    echo "⚠️  Lazy restore/clean had issues. Log: /tmp/nvim-lazy-sync.log"
  fi

  echo "=== Installing Treesitter parsers ==="
  if DOTFILES_INSTALL=1 nvim --headless "+lua require('jlewe.install').treesitter()" 2>/tmp/nvim-treesitter.log; then
    echo "✅ Treesitter parsers installed"
  else
    echo "⚠️  Some Treesitter parsers failed. Log: /tmp/nvim-treesitter.log"
  fi

  echo "=== Installing Mason tools ==="
  if DOTFILES_INSTALL=1 nvim --headless "+lua require('jlewe.install').mason()" 2>/tmp/nvim-mason.log; then
    echo "✅ Mason tools installed"
  else
    echo "⚠️  Some Mason tools failed. Log: /tmp/nvim-mason.log"
  fi
}

install_optional_assets() {
  [[ "$CONFIG_ONLY" == true ]] && return

  local shaders="$DOTFILES_DIR/ghostty/shaders"
  if [[ -d "$shaders" ]]; then
    echo "✅ Ghostty shaders already installed"
  else
    git clone https://github.com/0xhckr/ghostty-shaders "$shaders" ||
      echo "⚠️  Could not clone Ghostty shaders (cosmetic only)"
  fi

  if [[ "$OS" == "Linux" ]] && [[ -f "$DOTFILES_DIR/man/dotfiles.7" ]]; then
    link_config "$DOTFILES_DIR/man/dotfiles.7" "$HOME/.local/share/man/man7/dotfiles.7"
  fi
}

report_ssh_config() {
  if [[ -e "$HOME/.ssh/config" ]]; then
    echo "✅ SSH config already exists"
  else
    echo "SSH config is machine-local. Copy ssh/config.example manually if needed."
  fi
}

setup_local_configs() {
  if [[ ! -e "$HOME/.zshrc.local" ]]; then
    if [[ -f "$DOTFILES_DIR/zsh/zshrc.local.example" ]]; then
      cp "$DOTFILES_DIR/zsh/zshrc.local.example" "$HOME/.zshrc.local"
    else
      touch "$HOME/.zshrc.local"
    fi
    echo "✅ Created ~/.zshrc.local"
  fi

  if [[ -e "$HOME/.gitconfig.local" ]]; then
    return
  fi

  if [[ "$UPDATE_MODE" == true ]]; then
    touch "$HOME/.gitconfig.local"
    echo "✅ Created empty ~/.gitconfig.local"
    return
  fi

  read -r -p "📧 Enter your Git email address: " git_email
  if [[ -n "$git_email" ]]; then
    cat >"$HOME/.gitconfig.local" <<EOF
[user]
	email = $git_email
EOF
  else
    touch "$HOME/.gitconfig.local"
  fi
  echo "✅ Created ~/.gitconfig.local"
}

set_default_shell() {
  if ! command -v zsh &>/dev/null; then
    echo "ℹ️  zsh not found — skipping default shell change"
    return
  fi

  if [[ "$SHELL" == *"zsh"* ]]; then
    echo "✅ zsh is already the default shell"
    return
  fi

  if ! command -v chsh &>/dev/null; then
    echo "⚠️  chsh unavailable — change the default shell manually"
    return
  fi

  echo "Setting zsh as default shell..."
  if ! chsh -s "$(command -v zsh)"; then
    echo "⚠️  chsh failed — change the default shell manually"
  fi
}

print_summary() {
  echo
  echo "Installation complete!"
  if [[ "$CONFIG_ONLY" == true ]]; then
    echo "Start a new shell, then open Neovim and tmux."
  elif [[ "$UPDATE_MODE" == true ]]; then
    echo "All configured components are up to date."
  else
    echo "Log out and back in, then start Neovim or tmux."
    if [[ "$INSTALL_RICE" == true ]]; then
      echo "Hyprland starts automatically on TTY1."
    fi
  fi
  echo "Documentation: README.md and docs/"
}

main() {
  parse_args "$@"

  echo "🚀 Installing dotfiles from: $DOTFILES_DIR"
  echo "🖥️  Detected OS: $OS"
  if [[ "$CONFIG_ONLY" == true ]]; then
    echo "📦 Config-only mode"
  elif [[ "$UPDATE_MODE" == true ]]; then
    echo "🔄 Update mode"
  fi

  install_packages
  install_font
  link_configs
  install_neovim
  install_optional_assets
  report_ssh_config
  setup_local_configs
  set_default_shell
  print_summary
}

main "$@"
