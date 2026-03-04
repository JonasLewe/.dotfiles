# Neovim Dotfiles

Modulare Neovim-Konfiguration in Lua mit lazy.nvim.
Philosophie: vanilla first — native Features vor Plugins. Dann gezielt erweitern.

Terminal: Ghostty + tmux mit cyberdream Theme (dark, transparent).


# Teil 1: Architektur

## Ordnerstruktur

Alles liegt unter nvim/ im Dotfiles-Repo.

**init.lua** ist der Einstiegspunkt. Er laedt in dieser Reihenfolge: options, keymaps, lazy-setup.

**core/options.lua** enthaelt alle Vim-Optionen: Leader-Key, Tabs, Suche, Clipboard, Splits.

**core/keymaps.lua** enthaelt alle Keybinds, sowohl allgemeine als auch Plugin-Trigger.

**lazy-setup.lua** bootstrapt lazy.nvim und importiert automatisch alles aus dem plugins-Ordner.

**plugins/** enthaelt pro Plugin-Gruppe eine Datei:

- colorscheme.lua -- cyberdream (transparent, dark)
- telescope.lua -- Fuzzy Finder mit fzf-native Extension
- treesitter.lua -- Syntax Highlighting via AST-Parsing
- cmp.lua -- Autocompletion mit LuaSnip und lspkind
- lsp.lua -- Mason, LSP-Server-Konfiguration und Keybinds
- navigation.lua -- aerial.nvim (Symbol-Sidebar) + trouble.nvim (Diagnostics)
- editor.lua -- vim-surround

**lazy-lock.json** ist das Lockfile mit den exakten Plugin-Versionen.


# Teil 2: Keybinds

Leader-Key ist Space.

## Allgemein

**kj** -- Escape aus Insert, Visual und Terminal Mode.

**Space nh** -- Search Highlights loeschen.

**x** -- Einzelnes Zeichen loeschen ohne es ins Register zu kopieren.

**Space +** und **Space -** -- Zahl unter dem Cursor erhoehen oder verringern.

## Fenster und Splits

**Space sv** -- Fenster vertikal splitten.

**Space sh** -- Fenster horizontal splitten.

**Ctrl-h/j/k/l** -- Zwischen Splits navigieren.

**Space tt** -- Terminal oeffnen.

## Telescope (Suche)

**Space ff** -- Dateien suchen.

**Space fg** -- Text suchen (Live Grep).

**Space fb** -- Offene Buffer auflisten.

**Space fr** -- Zuletzt geoeffnete Dateien.

In Telescope: Ctrl-k und Ctrl-j zum Navigieren, Enter zum oeffnen.

## LSP

Diese Keybinds sind nur aktiv wenn ein LSP-Server laeuft.

**gd** -- Go to Definition.

**gr** -- References anzeigen.

**K** -- Hover Documentation.

**Space ca** -- Code Action.

**Space rn** -- Rename.

**[d** und **]d** -- Zum vorherigen oder naechsten Diagnostic springen.

**Space d** -- Diagnostic-Float oeffnen.

## Autocompletion (nvim-cmp)

Im Insert Mode:

**Tab** -- Naechsten Vorschlag auswaehlen.

**Shift-Tab** -- Vorherigen Vorschlag auswaehlen.

**Enter** -- Vorschlag bestaetigen (nur wenn explizit ausgewaehlt).

**Ctrl-Space** -- Completion manuell ausloesen.

**Ctrl-e** -- Completion abbrechen.

## Navigation

**Space cs** -- Symbol-Sidebar (aerial) ein-/ausblenden.

**Space xx** -- Diagnostics-Panel (trouble) ein-/ausblenden.

## Sonstige Plugin-Keybinds

**Space e** -- netrw File Explorer ein-/ausblenden.

**cs"'** -- Surround: Anfuehrungszeichen von doppelt auf einfach aendern.

**ds"** -- Surround: Anfuehrungszeichen entfernen.

**ysiw"** -- Surround: Wort mit Anfuehrungszeichen umschliessen.


# Teil 3: LSP-Server

Alle Server werden automatisch via Mason installiert.

**pyright** fuer Python.

**lua_ls** fuer Lua, mit Neovim-Runtime konfiguriert damit vim-Globals erkannt werden.

Neue Server hinzufuegen: drei Schritte in plugins/lsp.lua:

1. Server-Name zur ensure_installed-Liste hinzufuegen.
2. Server-Name zur vim.lsp.enable-Liste hinzufuegen.
3. Falls noetig, vim.lsp.config() fuer Server-spezifische Settings.
4. Neovim neu starten und mit :Mason pruefen.


# Teil 4: Wie geht es weiter

## Plugin hinzufuegen

Erstelle eine neue Datei im plugins-Ordner. Die Datei muss ein lazy.nvim Spec zurueckgeben. Beim naechsten Neovim-Start wird es automatisch geladen.

Fuer kleine Plugins die keine eigene Config brauchen: einfach in editor.lua hinzufuegen.

Beispiel:

```lua
return {
  "author/plugin-name",
  event = "BufReadPre",
  opts = {},
}
```

## LSP-Server hinzufuegen

Drei Schritte in plugins/lsp.lua:

1. Server-Name zur ensure_installed-Liste hinzufuegen.
2. Server-Name zur vim.lsp.enable-Liste hinzufuegen.
3. Neovim neu starten und mit Mason pruefen.

## Plugins fuer spaeter

Fuege diese erst hinzu wenn du die Basis sicher beherrschst.

**nvim-autopairs** schliesst Klammern und Anfuehrungszeichen automatisch.

**indent-blankline** zeigt visuelle Indent-Guides.

**conform.nvim** fuehrt Auto-Formatter aus (black, prettier, stylua).

**nvim-lint** integriert Linter die kein LSP haben.

**harpoon** ermoeglicht schnelles Wechseln zwischen markierten Dateien.

**oil.nvim** ist ein File-Manager der wie ein normaler Buffer funktioniert.

**gitsigns.nvim** zeigt Git-Aenderungen im Gutter und erlaubt Hunk-Staging.


# Teil 5: Lazy.nvim verstehen

Lies die lazy.nvim README auf GitHub, besonders den Abschnitt "Plugin Spec".

**event** bestimmt wann ein Plugin geladen wird (z.B. InsertEnter, BufReadPre).

**ft** laedt das Plugin nur fuer bestimmte Dateitypen.

**cmd** laedt das Plugin wenn ein bestimmter Befehl ausgefuehrt wird.

**keys** laedt das Plugin wenn ein bestimmter Keybind gedrueckt wird.

**dependencies** sind andere Plugins die vorher geladen werden muessen.

**opts** ist eine Table die automatisch an die setup-Funktion uebergeben wird.

**config** ist eine Funktion die nach dem Laden ausgefuehrt wird.

Nutze :Lazy in Neovim um installierte Plugins und ihre Ladezeiten zu sehen.
