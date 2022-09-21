# Enable Tmux by default
if [ "$TMUX" = "" ]; then tmux; fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set oh-my-zsh stuff

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

source "$XDG_CONFIG_HOME/zsh/aliases"
setopt AUTO_PARAM_SLASH
unsetopt CASE_GLOB

# autoload -Uz compinit; compinit

# Autocomplete hidden files
_comp_options+=(globdots)
source ~/.dotfiles/zsh/external/completion.zsh

# fpath=($ZDOTDIR/external $fpath)

# autoload -Uz prompt_purification_setup; prompt_purification_setup
# autoload -Uz cursor_mode && cursor_mode

# Push the current directory visited on to the stack.
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack.
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using pushd or popd.
setopt PUSHD_SILENT

DISABLE_AUTO_TITLE=true

bindkey -v
export KEYTIMEOUT=1

# Remap screen clearing to ctrl+g
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

source ~/.dotfiles/zsh/external/bd.zsh

tmux source $HOME/.config/tmux/tmux.conf
