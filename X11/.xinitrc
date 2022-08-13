urxvtd -o -q -f

xrdb -merge ~/.config/X11/.Xresources

setxkbmap -layout de

setxkbmap -option caps:escape

udiskie &

exec i3
