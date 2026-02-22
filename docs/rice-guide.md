# Rice Guide — Von der Installation zum fertigen Desktop

Dieses Dokument erklärt dir Schritt für Schritt, wie du von einer frischen CachyOS-Installation zu einem funktionierenden Hyprland-Rice kommst.

---

## Was ist Ricing?

"Rice" steht für **Race Inspired Cosmetic Enhancement** — ursprünglich aus der Auto-Szene. In der Linux-Welt bedeutet es: Jeden visuellen Aspekt deines Desktops selbst kontrollieren. Kein vorgegebenes Desktop-Environment (GNOME, KDE), sondern handverlesene Einzelkomponenten.

Die Komponenten eines Rice:

```
┌──────────────────────────────────────────────────────┐
│ Window Manager    → Hyprland (verwaltet Fenster)     │
│ Status Bar        → Waybar (oben am Bildschirm)      │
│ App Launcher      → Rofi (wie Spotlight/Alfred)       │
│ Notifications     → Dunst (Popup-Benachrichtigungen)  │
│ Terminal          → Ghostty (wo du arbeitest)         │
│ Shell             → zsh (Kommandozeile)               │
│ Editor            → Neovim (Texteditor)               │
│ Wallpaper         → hyprpaper (Hintergrundbild)       │
│ Lock Screen       → hyprlock (Sperrbildschirm)        │
└──────────────────────────────────────────────────────┘
```

Du hast Terminal + Shell + Editor bereits konfiguriert. Dieses Tutorial fügt die Desktop-Schicht hinzu.

---

## 1. CachyOS installieren

CachyOS ist Arch Linux mit einem grafischen Installer und Performance-Optimierungen.

### Download & Installation

1. ISO herunterladen: https://cachyos.org/download
2. USB-Stick erstellen: `sudo dd if=cachyos.iso of=/dev/sdX bs=4M status=progress`
   (oder mit Ventoy/Rufus)
3. Von USB booten → Installer folgen
4. **Desktop wählen:** Minimal oder Hyprland (wenn verfügbar)
   - Wenn du "Minimal" wählst, installiert `install.sh` Hyprland nachträglich

### Nach der Installation

```bash
# System aktualisieren
sudo pacman -Syu

# Git installieren (falls nicht vorhanden)
sudo pacman -S git
```

---

## 2. Dotfiles einrichten

```bash
# Repo klonen
git clone https://github.com/DEIN_USER/dotfiles ~/.dotfiles

# Installer starten
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

Das Script:
- Installiert Neovim, tmux, zsh, Ghostty, ripgrep, fd, ctags
- Fragt ob du Hyprland + Rice-Tools installieren willst → **y**
- Symlinkt alle Konfigurationen an die richtigen Stellen
- Setzt zsh als Standard-Shell

Nach der Installation: **Ausloggen und wieder einloggen.**

---

## 3. Hyprland starten

### Vom Display Manager

Wenn CachyOS einen Display Manager (SDDM) installiert hat:
- Am Login-Screen unten links "Hyprland" als Session wählen
- Einloggen

### Ohne Display Manager

```bash
# Direkt aus dem TTY starten:
Hyprland
```

Du siehst: Einen leeren Bildschirm mit Waybar oben. Das ist richtig — jetzt fängst du an.

---

## 4. Hyprland Keybindings

Die Keybindings sind **vim-inspiriert**. `SUPER` (Windows/Meta-Taste) ist dein Prefix — wie `Ctrl-A` in tmux.

### Basis (sofort auswendig lernen)

```
SUPER + Enter          Terminal öffnen (Ghostty)
SUPER + d              App-Launcher öffnen (Rofi)
SUPER + q              Fenster schließen
SUPER + Shift + e      Hyprland beenden (Vorsicht!)
```

### Fokus bewegen (wie in Neovim!)

```
SUPER + h              Fokus nach links
SUPER + j              Fokus nach unten
SUPER + k              Fokus nach oben
SUPER + l              Fokus nach rechts
```

### Fenster bewegen

```
SUPER + Shift + h      Fenster nach links schieben
SUPER + Shift + j      Fenster nach unten schieben
SUPER + Shift + k      Fenster nach oben schieben
SUPER + Shift + l      Fenster nach rechts schieben
```

### Fenster resizen

```
SUPER + Ctrl + h       Schmaler machen
SUPER + Ctrl + j       Höher machen
SUPER + Ctrl + k       Niedriger machen
SUPER + Ctrl + l       Breiter machen
```

### Layout

```
SUPER + f              Fullscreen (an/aus)
SUPER + v              Floating (Fenster schwebt / dockt an)
SUPER + s              Split-Richtung umschalten
```

### Workspaces

```
SUPER + 1-9            Zu Workspace 1-9 wechseln
SUPER + Shift + 1-9    Fenster zu Workspace 1-9 verschieben
SUPER + Mausrad        Durch Workspaces scrollen
```

### Maus

```
SUPER + Linksklick     Fenster verschieben (drag)
SUPER + Rechtsklick    Fenster resizen (drag)
```

### Extras

```
Print                  Screenshot (Region auswählen → Clipboard)
Shift + Print          Screenshot (ganzer Bildschirm → Clipboard)
SUPER + Shift + x      Bildschirm sperren (hyprlock)
```

### Parallele zu deinen anderen Tools

```
TOOL         PREFIX       NAVIGATION     SPLITS
─────────────────────────────────────────────────
Hyprland     SUPER        SUPER+hjkl     Automatisch (Tiling)
tmux         Ctrl-A       Ctrl-A+hjkl    Ctrl-A+|  Ctrl-A+-
Neovim       <Space>      Ctrl+hjkl      <leader>sv  <leader>sh
```

Überall hjkl. Überall vim.

---

## 5. Waybar anpassen

Waybar ist die Statusleiste oben am Bildschirm.

### Konfigurationsdateien

```
waybar/config.jsonc    → Module und Verhalten
waybar/style.css       → Aussehen (Farben, Abstände, Schrift)
```

### Module hinzufügen/entfernen

In `config.jsonc`, ändere die `modules-*` Arrays:

```jsonc
// Beispiel: Batterie hinzufügen (Laptop)
"modules-right": ["cpu", "memory", "battery", "network", "pulseaudio", "clock"],

// Batterie-Modul konfigurieren:
"battery": {
    "format": "{icon} {capacity}%",
    "format-icons": ["", "", "", "", ""],
    "format-charging": " {capacity}%"
},
```

### Änderungen anwenden

```bash
# Waybar neustarten (in einem Terminal):
killall waybar && waybar &
```

Oder in Hyprland config reloaden: Datei speichern → Hyprland lädt automatisch neu.

---

## 6. Rofi benutzen

Rofi ist dein App-Launcher (wie Spotlight auf macOS).

### Öffnen

```
SUPER + d              App-Launcher öffnen
```

### Bedienung

```
Tippen                 Suchen (fuzzy matching)
Enter                  App starten
Escape / Ctrl+c        Schließen
Ctrl+j / Ctrl+k        Navigation (vim-style!)
Pfeil hoch/runter      Navigation (alternativ)
```

### Modi wechseln

Rofi hat 3 Modi (konfiguriert in `rofi/config.rasi`):

```
drun     → Desktop-Applikationen (Standard)
run      → Beliebige Befehle ausführen
window   → Zwischen offenen Fenstern wechseln
```

Im Rofi-Fenster: Klicke auf den Modus-Namen oben oder nutze `Ctrl+Tab` zum Wechseln.

---

## 7. Dunst (Notifications)

Dunst zeigt Benachrichtigungen als Popup oben rechts.

### Testen

```bash
notify-send "Hallo" "Dein Rice funktioniert!"
notify-send -u critical "Warnung" "Das ist dringend!"
```

### Konfiguration

Datei: `dunst/dunstrc`

Wichtige Einstellungen:
- `origin` — Position (top-right, top-left, bottom-right, etc.)
- `timeout` — Wie lange die Notification sichtbar bleibt (Sekunden)
- `font` — Schriftart
- Farben pro Urgency-Level (low, normal, critical)

### Änderungen anwenden

```bash
killall dunst && dunst &
notify-send "Test" "Dunst neugestartet"
```

---

## 8. Wallpaper setzen

### hyprpaper (statisches Wallpaper)

Erstelle `~/.config/hypr/hyprpaper.conf`:

```
# Bild vorladen
preload = ~/Pictures/wallpaper.jpg

# Bild auf Monitor setzen ("" = alle Monitore)
wallpaper = , ~/Pictures/wallpaper.jpg
```

Danach:
```bash
killall hyprpaper && hyprpaper &
```

### Wallpaper finden

- https://wallhaven.cc — Riesige Sammlung, gute Suchfilter
- https://unsplash.com — Fotografien in hoher Auflösung
- r/wallpapers — Reddit Community

---

## 9. Farbschema durchziehen

Ein Rice sieht dann gut aus, wenn alles farblich zusammenpasst. Wähle EIN Schema und wende es überall an:

### Beliebte Schemas

| Schema | Vibe | Link |
|--------|------|------|
| Catppuccin Mocha | Warm, lila/blau | github.com/catppuccin |
| Tokyo Night | Kühl, dunkelblau | github.com/folke/tokyonight.nvim |
| Gruvbox Dark | Warm, orange/braun | github.com/morhetz/gruvbox |
| Nord | Kühl, arktisch | github.com/nordtheme |
| Dracula | Lila, kontrastreich | github.com/dracula |

### Wo Farben anpassen

```
Ghostty        → ghostty/config (theme = ...)
Neovim         → nvim/lua/jlewe/core/options.lua (vim.cmd("colorscheme ..."))
Hyprland       → hyprland/hyprland.conf (col.active_border, col.inactive_border)
Waybar         → waybar/style.css (background-color, color, etc.)
Rofi           → rofi/config.rasi (@bg, @fg, @accent, etc.)
Dunst          → dunst/dunstrc ([urgency_*] Sektionen)
```

### Workflow

1. Wähle ein Schema
2. Fange bei Ghostty an (Terminal = meiste Zeit)
3. Dann Neovim Colorscheme installieren (z.B. `catppuccin/nvim` als Plugin)
4. Dann Waybar + Rofi + Dunst CSS/Config anpassen
5. Zuletzt Hyprland Borders

---

## 10. Nächste Schritte

Wenn du die Grundlagen beherrschst, kannst du tiefer gehen:

### Lern-Reihenfolge

```
Phase 1 (jetzt):
  ✓ Hyprland Keybindings lernen
  ✓ Waybar + Rofi + Dunst verstehen
  ✓ Ein Wallpaper setzen

Phase 2 (wenn Phase 1 sitzt):
  → Farbschema durchziehen
  → Hyprland-Animationen tunen
  → Waybar-Module erweitern (Spotify, Wetter, etc.)
  → Ghostty-Shader ausprobieren

Phase 3 (Fortgeschritten):
  → swww statt hyprpaper (animierte Wallpaper-Übergänge)
  → Custom Skripte in ~/.local/bin/
  → eww oder ags als Waybar-Alternative (programmierbar)
  → hyprlock anpassen (eigener Lock Screen)
  → Window Rules (bestimmte Apps immer floating/workspace X)
```

### Window Rules Beispiel

In `hyprland/hyprland.conf`:
```
# Firefox immer auf Workspace 2
windowrulev2 = workspace 2, class:^(firefox)$

# Dateimanager immer floating
windowrulev2 = float, class:^(thunar)$

# Bild-Viewer floating und zentriert
windowrulev2 = float, class:^(imv)$
windowrulev2 = center, class:^(imv)$
```

### Inspiration

- **r/unixporn** — der Subreddit für Linux-Ricing (Pflicht!)
- **hyprland.org** — offizielle Docs und Wiki
- **Arch Wiki** — die beste Linux-Dokumentation überhaupt
- Andere Dotfile-Repos auf GitHub durchstöbern

---

## Cheat Sheet: Die ersten 30 Minuten

```bash
# 1. Dotfiles installieren
cd ~/.dotfiles && ./install.sh     # "y" bei Hyprland-Frage

# 2. Ausloggen, Hyprland als Session wählen, einloggen

# 3. Terminal öffnen
SUPER + Enter

# 4. Testen
notify-send "Test" "Dunst works!"  # Notification testen
SUPER + d                          # Rofi öffnen
SUPER + 2                          # Workspace 2
SUPER + 1                          # Zurück zu 1

# 5. Zweites Fenster öffnen
SUPER + Enter                      # Zweites Terminal
SUPER + h / SUPER + l              # Zwischen Fenstern wechseln

# 6. tmux innerhalb von Ghostty
tmux                               # tmux startet automatisch via Ghostty

# 7. Neovim innerhalb von tmux
nvim                               # lazy.nvim installiert Plugins beim ersten Start
```
