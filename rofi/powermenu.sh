#!/usr/bin/env bash
# Power menu for Hyprland via Rofi
# Keybind: SUPER + Delete (configured in hyprland.conf)

# Self-contained theme: reset default theme to prevent bleed-through
menu_theme='@theme "/dev/null"
* { background-color: #1a1a1a; text-color: #cccccc; }
window { width: 200px; border: 2px; border-color: #888888; border-radius: 8px; padding: 0; }
mainbox { children: [listview]; padding: 8px; spacing: 0; }
listview { scrollbar: false; spacing: 4px; }
element { padding: 6px 12px; border-radius: 4px; }
element selected { background-color: #252525; text-color: #ffffff; }
element-icon { size: 18px; margin: 0 8px 0 0; }
element-text { expand: true; horizontal-align: 0.5; vertical-align: 0.5; }'

# Swallow letter/number keys so they don't filter the list (j/k are navigation)
noop_keys="Tab,space,a,b,c,d,e,f,g,h,i,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9"

rofi_cmd=(rofi -dmenu -i -no-custom -show-icons -icon-theme breeze-dark \
    -kb-row-down "j,Down,Control+j" \
    -kb-row-up "k,Up,Control+k" \
    -kb-row-tab "" \
    -kb-element-next "" \
    -kb-row-select "$noop_keys" \
    -theme-str "$menu_theme")

chosen=$(printf 'Lock\0icon\x1fsystem-lock-screen\nLogout\0icon\x1fsystem-log-out\nReboot\0icon\x1fview-refresh\nShutdown\0icon\x1fsystem-shutdown\n' \
    | "${rofi_cmd[@]}" -theme-str 'listview { lines: 4; }')

confirm() {
    printf 'Yes\nNo\n' | "${rofi_cmd[@]}" \
        -theme-str 'listview { lines: 2; }'
}

case "$chosen" in
    Lock)     hyprlock ;;
    Logout)   hyprctl dispatch exit ;;
    Reboot)   [[ $(confirm) == "Yes" ]] && systemctl reboot ;;
    Shutdown) [[ $(confirm) == "Yes" ]] && systemctl poweroff ;;
esac
