#!/bin/bash
###########
# install #
###########
if [ -f /etc/lsb-release ]; then
    # Ubuntu
    sudo apt install zsh tmux neovim ripgrep
else
    exit 0
fi

# make paths available
source "$HOME/.dotfiles/zsh/.zshenv"

#######
# zsh #
#######
sudo rm -rf "$XDG_CONFIG_HOME/zsh"
sudo mkdir -p "$XDG_CONFIG_HOME/zsh"
sudo ln -sf "$DOTFILES/zsh/.zshenv" "$HOME"
sudo ln -sf "$DOTFILES/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"
sudo ln -sf "$DOTFILES/zsh/aliases" "$XDG_CONFIG_HOME/zsh/aliases"
 
sudo rm -rf "$XDG_CONFIG_HOME/zsh/external"
sudo ln -sf "$DOTFILES/zsh/external" "$XDG_CONFIG_HOME/zsh"

########
# nvim #
########
sudo rm -rf "$XDG_CONFIG_HOME/nvim"
sudo mkdir -p "$XDG_CONFIG_HOME/nvim"
sudo mkdir -p "$XDG_CONFIG_HOME/nvim/undo"

sudo ln -sf "$DOTFILES/nvim/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"

# Install vim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# :PlugInstall
nvim --headless +PlugInstall +qall
nvim +UpdateRemotePlugins +qa

# Install oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Install Powerline10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

########
# tmux #
########
sudo rm -rf "$XDG_CONFIG_HOME/tmux"
sudo mkdir -p "$XDG_CONFIG_HOME/tmux"
sudo ln -sf "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

# Install tpm 
git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm

