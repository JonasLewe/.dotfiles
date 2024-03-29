# Enable Tmux by default
# if [ "$TMUX" = "" ]; then tmux; fi
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

source "$XDG_CONFIG_HOME/zsh/aliases"
setopt AUTO_PARAM_SLASH
unsetopt CASE_GLOB

XDG_CURRENT_DESKTOP=KDE

autoload -Uz compinit; compinit

# Autocomplete hidden files
_comp_options+=(globdots)
source $DOTFILES/zsh/external/completion.zsh

fpath=($ZDOTDIR/external $fpath)

autoload -Uz prompt_purification_setup; prompt_purification_setup
autoload -Uz cursor_mode && cursor_mode

# Push the current directory visited on to the stack.
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack.
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using pushd or popd.
setopt PUSHD_SILENT

bindkey -v
export KEYTIMEOUT=1

# remap screen clear to ctrl+g
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

source $DOTFILES/zsh/external/bd.zsh
source $DOTFILES/zsh/scripts.sh

#if [ $(command -v "fzf") ]; then
#	source /usr/share/fzf/completion.zsh
#	source /usr/share/fzf/key-bindings.zsh
#fi


#if [ "$(tty)" = "/dev/tty1" ]; then
#	pgrep i3 || exec startx "$XDG_CONFIG_HOME/X11/.xinitrc"
#fi


export PATH=$PATH:/home/jonas/.local/bin

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jonas/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jonas/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jonas/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jonas/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

