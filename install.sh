#!/bin/bash
###########
# install #
###########
if [ -f /etc/lsb-release ]; then
    # Ubuntu
    sudo apt install zsh tmux -y
elif [ -f /etc/arch-release ]; then
    # Arch
    sudo pacman -S zsh tmux zsh-syntax-highlighting fzf ripgrep
fi

######
# i3 #
######
sudo rm -rf "$HOME/.config/i3"
sudo ln -s "$HOME/dotfiles/i3" "$HOME/.config"

#######
# zsh #
#######
sudo mkdir -p "$XDG_CONFIG_HOME/zsh"
sudo ln -sf "$DOTFILES/zsh/.zshenv" "$HOME"
sudo ln -sf "$DOTFILES/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"
sudo ln -sf "$DOTFILES/zsh/aliases" "$XDG_CONFIG_HOME/zsh/aliases"

sudo rm -rf "$XDG_CONFIG_HOME/zsh/external"
sudo ln -sf "$DOTFILES/zsh/external" "$XDG_CONFIG_HOME/zsh"

########
# nvim #
########
sudo mkdir -p "$XDG_CONFIG_HOME/nvim"
sudo mkdir -p "$XDG_CONFIG_HOME/nvim/undo"

sudo ln -sf "$DOTFILES/nvim/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"

# Install vim plug
sudo sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# :PlugInstall
sudo nvim --headless +PlugInstall +qall
sudo nvim +UpdateRemotePlugins +qa

########
# tmux #
########
sudo mkdir -p "$XDG_CONFIG_HOME/tmux"
sudo ln -sf "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
