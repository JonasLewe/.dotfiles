-- =============================================================================
-- HYPRLAND CONFIGURATION
-- =============================================================================
-- Hyprland is a tiling Wayland compositor (window manager).
-- Docs: https://wiki.hypr.land/configuring/core/
--
-- KEY CONCEPTS:
--   Monitor    -> a physical screen
--   Workspace  -> a virtual desktop (1-9), each monitor shows one workspace
--   Window     -> an application window, tiled or floating
--   Mod key    -> SUPER (Windows/Meta key), the prefix for all keybindings
--
-- WORKFLOW:
--   SUPER + Enter      -> open terminal (Ghostty)
--   SUPER + d          -> app launcher (Rofi)
--   SUPER + q          -> close window
--   SUPER + h/j/k/l    -> move focus (vim-style)
--   SUPER + 1-9        -> switch workspace

-- =============================================================================
-- MONITOR
-- =============================================================================
-- An empty output matches every monitor. "preferred" selects its preferred
-- resolution and "auto" lets Hyprland choose the position.

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- =============================================================================
-- AUTOSTART
-- =============================================================================
-- The start event runs once when the Hyprland session starts.

hl.on("hyprland.start", function()
    hl.exec_cmd("ghostty", { workspace = "1" })
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("hypridle")
end)

-- =============================================================================
-- ENVIRONMENT VARIABLES
-- =============================================================================

hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

-- =============================================================================
-- LOOK & FEEL
-- =============================================================================

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,
        col = {
            active_border = "rgb(888888)",
            inactive_border = "rgb(333333)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        blur = {
            enabled = false,
        },
        shadow = {
            enabled = false,
        },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        preserve_split = true,
    },

    input = {
        kb_layout = "eu",
        kb_options = "ctrl:nocaps",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            tap_to_click = false,
            clickfinger_behavior = true,
        },
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

-- =============================================================================
-- KEYBINDINGS
-- =============================================================================

local mod = "SUPER"

-- Launch and session controls.
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. " + W", hl.dsp.exec_cmd("~/.config/networkmanager-dmenu/networkmanager_dmenu_user"))
hl.bind(mod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

-- Move focus between windows (vim-style).
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move the focused window.
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Resize the focused window while a key is held.
hl.bind(mod .. " + CTRL + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })

-- Layout controls.
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + V", hl.dsp.window.float())
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + S", hl.dsp.layout("togglesplit"))

-- Switch workspaces or move the focused window to one.
for workspace = 1, 9 do
    local key = tostring(workspace)
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

-- Scroll through existing workspaces.
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move or resize windows with the mouse while holding SUPER.
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots.
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim - | wl-copy"))

-- Media keys.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q set 5%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q set 5%-"), { repeating = true })

-- Lock screen and power menu.
hl.bind(mod .. " + grave", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + Delete", hl.dsp.exec_cmd("~/.config/rofi/powermenu.sh"))
