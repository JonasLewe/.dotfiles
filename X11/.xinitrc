urxvtd -o -q -f

xrdb -merge ~/.config/X11/.Xresources

setxkbmap -layout de

udiskie &

exec i3
