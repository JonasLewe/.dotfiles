#!/bin/bash
###########
# install #
###########
if [ -f /etc/lsb-release ]; then
    # Ubuntu
    sudo apt install zsh tmux -y
elif [ -f /etc/arch-release ]; then
    # Arch
    sudo pacman -S zsh tmux zsh-syntax-highlighting fzf ripgrep cmake
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

# install neovim plugin manager
[ ! -f "$DOTFILES/nvim/autoload/plug.vim" ] && curl -fLo "$DOTFILES/nvim/autoload/plug.vim" --create -dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p "$XDG_CONFIG_HOME/nvim/autoload"
ln -sf $DOTFILES/nvim/autoload/plug.vim" "$XDG_CONFIG_HOME/nvim/autoload/plug.vim"

# Install (or update) all the plugins
nvim --noplugin +PlugUpdate +qa

########
# tmux #
########
sudo mkdir -p "$XDG_CONFIG_HOME/tmux"
sudo ln -sf "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

#########
# Fonts #
#########
mkdir -p "$XDG_DATA_HOME"
cp -rf "$DOTFILES/fonts" "$XDG_DATA_HOME"


#########
# Stuff #
#########
mkdir -p "$XDG_CONFIG_HOME/dunst"
ln -sf "$DOTFILES/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"
