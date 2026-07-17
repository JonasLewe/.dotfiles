# Neovim-Konfiguration

Die Konfiguration setzt auf native Neovim-Funktionen und ergänzt nur klar
abgegrenzte Features mit Plugins. `nvim/init.lua` lädt Optionen, Keymaps und
anschließend lazy.nvim.

## Struktur

```text
nvim/
├── init.lua
├── lazy-lock.json
└── lua/jlewe/
    ├── core/
    │   ├── options.lua
    │   └── keymaps.lua
    ├── plugins/
    │   └── optional/
    ├── tooling.lua
    ├── install.lua
    └── lazy-setup.lua
```

- `core/` enthält ausschließlich Neovim-Verhalten ohne Plugin-Abhängigkeit.
- `plugins/` enthält die regelmäßig verwendeten Erweiterungen.
- `plugins/optional/` enthält Jira, Jupyter, DAP und Pomodoro.
- `tooling.lua` ist die gemeinsame Quelle für LSP-Server, Mason-Pakete,
  Formatter, Linter und Debug-Adapter.
- `install.lua` enthält den Headless-Bootstrap, den `install.sh` aufruft.

## Bedienung nachschlagen

Die Keymap-Beschreibungen in den Lua-Dateien sind die maßgebliche Referenz.
Dadurch müssen Tastenkürzel nicht in mehreren Dokumenten synchron gehalten
werden.

- `Space` drücken: verfügbare Leader-Gruppen mit which-key anzeigen.
- `?` drücken: buffer-lokale Mappings anzeigen.
- `:map`, `:nmap`, `:imap`: aktive Mappings direkt in Neovim anzeigen.
- `:verbose nmap <mapping>`: Definition eines konkreten Mappings finden.
- `:Lazy`: Plugins, Ladezustand und Ladezeiten prüfen.
- `:Mason`: externe Entwicklungswerkzeuge verwalten.
- `:checkhealth`: Installation und Provider prüfen.

## Funktionsbereiche

### Native Basis

Neovim übernimmt Optionen, Splits, Tabs, Terminal, netrw, Kommentare und
LSP-Completion selbst. Die native LSP-Completion ersetzt nvim-cmp und LuaSnip.
Der ausführliche native Workflow steht im `vanilla-vim-guide.md`.

### Suche und Navigation

Telescope bietet Datei-, Text-, Buffer- und Verlaufssuche. Trouble zeigt
Diagnostics und Dokumentsymbole. netrw bleibt der integrierte Dateiexplorer.

### LSP und Tooling

Mason installiert die in `tooling.lua` deklarierten Werkzeuge. nvim-lspconfig
liefert die Serverdefinitionen, Neovim aktiviert die Server nativ. Neue
Sprachunterstützung wird an einer Stelle ergänzt:

1. LSP-Server und Mason-Paket in `tooling.lua` eintragen.
2. Nur bei abweichenden Defaults eine `vim.lsp.config()`-Anpassung ergänzen.
3. `./install.sh --update` ausführen oder das Werkzeug mit `:Mason` installieren.

Conform formatiert beim Speichern und fällt bei Bedarf auf LSP-Formatierung
zurück. nvim-lint startet nach dem Speichern oder beim Verlassen des Insert
Mode. Treesitter-Parser stehen separat in `treesitter_languages.lua`, weil sie
sowohl interaktiv als auch vom Installer verwendet werden.

### Git und Debugging

Gitsigns stellt Hunk-Navigation, Staging, Reset und Blame im Buffer bereit.
LazyGit deckt Repository-weite Git-Workflows ab. nvim-dap, dap-ui und
Virtual Text bilden gemeinsam die Debug-Oberfläche; Debug-Adapter kommen aus
Mason.

### Optionale Integrationen

- JupyNvim wird ausschließlich für `.ipynb` oder über seine Commands geladen.
- Jira wird nur installiert und aktiviert, wenn `jira.local.lua` existiert.
  `jira.example.lua` dokumentiert die maschinenlokale Konfiguration.
- Der Jira-Read-only-Modus blockiert schreibende UI- und API-Einstiegspunkte.
- DAP und Pomodoro werden erst über ihre Commands oder Keymaps geladen.

## Plugin hinzufügen

Regelmäßig benötigte Plugins bekommen eine Datei unter `plugins/`. Features,
die nur in bestimmten Workflows vorkommen, gehören nach `plugins/optional/`.
Beide Verzeichnisse werden explizit von lazy.nvim importiert.

```lua
return {
  "author/plugin-name",
  event = "BufReadPre",
  opts = {},
}
```

Bevor ein Plugin hinzukommt, sollte ein wiederkehrendes Problem benannt sein,
das die native Funktion nicht ausreichend löst. Ein Plugin sollte außerdem
über `event`, `ft`, `cmd` oder `keys` so spät wie sinnvoll geladen werden.

## Lazy.nvim-Spezifikation

- `event`: Laden bei einem Neovim-Event.
- `ft`: Laden für bestimmte Dateitypen.
- `cmd`: Laden beim ersten Aufruf eines Commands.
- `keys`: Keymap registrieren und beim ersten Auslösen laden.
- `dependencies`: vorher benötigte Plugins.
- `opts`: an `setup()` übergebene Optionen.
- `config`: benutzerdefinierte Initialisierung nach dem Laden.

`lazy-lock.json` hält Plugin-Versionen reproduzierbar. Nach Änderungen helfen
`:Lazy restore`, `:Lazy clean` und ein frischer Headless-Start beim Prüfen.
