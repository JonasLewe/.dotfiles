#!/bin/zsh
###########
# install #
###########

# make paths available
source "$HOME/.dotfiles/zsh/.zshenv"

if [ -f /etc/lsb-release ]; then
    # Ubuntu
    sudo apt install tmux neovim ripgrep -y
else
    exit 0
fi

#######
# zsh #
#######
sudo rm -rf "$XDG_CONFIG_HOME/zsh"
sudo mkdir -p "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/zsh/.zshenv" "$HOME"
ln -sf "$DOTFILES/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/zsh/aliases" "$XDG_CONFIG_HOME/zsh/aliases"
 
sudo rm -rf "$XDG_CONFIG_HOME/zsh/external"
ln -sf "$DOTFILES/zsh/external" "$XDG_CONFIG_HOME/zsh"

# Install oh-my-zsh
sudo rm -rf "$HOME/.oh-my-zsh"
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

sudo rm -rf $HOME/.zshrc

# Install Powerline10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

########
# nvim #
########
sudo rm -rf "$XDG_CONFIG_HOME/nvim"
sudo mkdir -p "$XDG_CONFIG_HOME/nvim"
sudo mkdir -p "$XDG_CONFIG_HOME/nvim/undo"

ln -sf "$DOTFILES/nvim/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"

# Install vim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# :PlugInstall
nvim --headless +PlugInstall +qall
nvim +UpdateRemotePlugins +qa

########
# tmux #
########
sudo rm -rf "$XDG_CONFIG_HOME/tmux"
sudo mkdir -p "$XDG_CONFIG_HOME/tmux"
sudo mkdir -p "$XDG_CONFIG_HOME/tmux/plugins/tpm"
ln -sf "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

# Install tpm 
sudo git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm

