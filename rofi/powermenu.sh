#!/usr/bin/env bash
# Power menu for Hyprland via Rofi
# Keybind: SUPER + Backspace (configured in hyprland.conf)

# Rofi flags for power menu: no search, no scrollbar, vim navigation (j/k)
rofi_cmd=(rofi -dmenu -i \
    -kb-row-down "j,Down,Control+j" \
    -kb-row-up "k,Up,Control+k" \
    -theme-str 'listview { scrollbar: false; } inputbar { enabled: false; }')

options="  Lock\n  Logout\n  Reboot\n  Shutdown"

chosen=$(echo -e "$options" | "${rofi_cmd[@]}" \
    -theme-str 'window { width: 200px; } listview { lines: 4; }')

confirm() {
    echo -e " Yes\n No" | "${rofi_cmd[@]}" \
        -theme-str 'window { width: 200px; } listview { lines: 2; }'
}

case "$chosen" in
    *Lock)     hyprlock ;;
    *Logout)   hyprctl dispatch exit ;;
    *Reboot)   [[ $(confirm) == *Yes ]] && systemctl reboot ;;
    *Shutdown) [[ $(confirm) == *Yes ]] && systemctl poweroff ;;
esac
