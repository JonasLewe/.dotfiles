#!/bin/bash
###########
# install #
###########

# make paths available
source "$HOME/.dotfiles/zsh/.zshenv"

if [ -f /etc/lsb-release ]; then
    # Ubuntu, PopOS
    sudo apt install zsh tmux neovim ripgrep curl fzf zsh-syntax-highlighting -y
elif [ -f /etc/arch-release ]; then
    # Arch
    sudo pacman -S zsh tmux zsh-syntax-highlighting fzf ripgrep cmake
fi

######
# i3 #
######
# sudo rm -rf "$HOME/.config/i3"
# sudo ln -s "$HOME/dotfiles/i3" "$HOME/.config"

#######
# zsh #
#######
sudo rm -rf "$XDG_CONFIG_HOME/zsh"
mkdir -p "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/zsh/.zshenv" "$HOME"
ln -sf "$DOTFILES/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/zsh/aliases" "$XDG_CONFIG_HOME/zsh/aliases"
 
sudo rm -rf "$XDG_CONFIG_HOME/zsh/external"
ln -sf "$DOTFILES/zsh/external" "$XDG_CONFIG_HOME/zsh"

# Make ZSH default shell
chsh -s $(which zsh)


########
# nvim #
########
sudo rm -rf "$XDG_CONFIG_HOME/nvim"
mkdir -p "$XDG_CONFIG_HOME/nvim"
mkdir -p "$XDG_CONFIG_HOME/nvim/undo"

sudo ln -sf "$DOTFILES/nvim/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"

# install neovim plugin manager
[ ! -f "$DOTFILES/nvim/autoload/plug.vim" ] && curl -fLo "$DOTFILES/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p "$XDG_CONFIG_HOME/nvim/autoload"
ln -sf "$DOTFILES/nvim/autoload/plug.vim" "$XDG_CONFIG_HOME/nvim/autoload/plug.vim"

# Install (or update) all the plugins
nvim --noplugin +PlugUpdate +qa

########
# tmux #
########
sudo rm -rf "$XDG_CONFIG_HOME/tmux"
mkdir -p "$XDG_CONFIG_HOME/tmux/plugins"
ln -sf "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

# Install tpm 
cd "$XDG_CONFIG_HOME/tmux/plugins"
git clone https://github.com/tmux-plugins/tpm \

#########
# Fonts #
#########
#mkdir -p "$HOME/.local"
#mkdir -p "$HOME/.local/share"
#cp -rf "$DOTFILES/fonts" "$HOME/.local/share"
mkdir -p "$HOME/.local/share/fonts"
cd "$HOME/.local/share/fonts" && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

#########
# Stuff #
#########
# mkdir -p "$XDG_CONFIG_HOME/dunst"
# ln -sf "$DOTFILES/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"
