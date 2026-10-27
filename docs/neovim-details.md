# Neovim-Konfiguration

Die Konfiguration setzt auf native Neovim-Funktionen und ergänzt nur klar
abgegrenzte Features mit Plugins. `nvim/init.lua` lädt Optionen, Keymaps und
anschließend lazy.nvim.

## Struktur

```text
nvim/
├── init.lua
├── lazy-lock.json
├── plugin/
│   └── k9s.lua
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
- `nvim/plugin/` enthält lokale Erweiterungen, die Neovim automatisch lädt.
  Eine Datei entfernen und Neovim neu starten deaktiviert die Erweiterung;
  ein `require()` in `init.lua` ist nicht nötig.
- `plugins/` enthält die regelmäßig verwendeten Erweiterungen.
- `plugins/optional/` enthält DAP und Pomodoro.
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

Live Grep sucht ab dem aktuellen Arbeitsverzeichnis auch in versteckten
Dateien und Verzeichnissen, etwa `.gitlab-ci.yml` und `.gitlab/`.
`.git` bleibt ausgeschlossen; Ignore-Regeln und Regex-Suche gelten weiterhin.
Das Arbeitsverzeichnis lässt sich mit `:pwd` prüfen.

### LSP und Tooling

Mason installiert die in `tooling.lua` deklarierten Werkzeuge. nvim-lspconfig
liefert die Serverdefinitionen, Neovim aktiviert die Server nativ. Neue
Sprachunterstützung wird an einer Stelle ergänzt:

1. LSP-Server und Mason-Paket in `tooling.lua` eintragen.
2. Nur bei abweichenden Defaults eine `vim.lsp.config()`-Anpassung ergänzen.
3. `./install.sh --update` ausführen oder das Werkzeug mit `:Mason` installieren.

Ghostty ist eine Ausnahme: Die Anwendung liefert Filetype, Syntax und
Kommentaroptionen über einen eigenen Neovim-Runtime-Pfad. Dieser Pfad bleibt
beim Start bewusst erhalten. `ghostty-ls` stammt aus einer zusätzlichen
Mason-Registry und wird deshalb separat in `plugins/lsp.lua` konfiguriert.

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

- DAP und Pomodoro werden erst über ihre Commands oder Keymaps geladen.

### Kubernetes mit k9s

`install.sh` installiert k9s über Homebrew bzw. pacman. Auf einem bestehenden
System genügt `brew install k9s` (macOS) oder `sudo pacman -S k9s` (Arch);
`./install.sh --update` nimmt es beim nächsten vollständigen Update mit.
Bei `--config-only` muss k9s bereits auf dem Server installiert sein.

Die Integration liegt vollständig in `nvim/plugin/k9s.lua`: Command,
Keymap, which-key-Gruppe und Fenstersteuerung. Zum Deaktivieren diese Datei
entfernen oder in `k9s.lua.disabled` umbenennen und Neovim neu starten.
Das über den Installer bereitgestellte CLI bleibt unabhängig davon nutzbar.

`:K9s` öffnet k9s in einem zentrierten Floating Window mit abgerundetem Rahmen
und aktiviert direkt die Terminal-Eingabe. Das Fenster nutzt etwa 90 % des
Editors und passt sich beim Ändern der Terminalgröße an.
Zusätzliche Argumente werden weitergereicht, beispielsweise
`:K9s --context mein-cluster -n default`. Die Keymap ist in der
which-key-Gruppe `kubernetes` zu finden.

k9s verwendet die lokale Kubeconfig (`~/.kube/config` oder `KUBECONFIG`).
Cluster-Zugänge bleiben maschinenspezifisch. In k9s wechselt `:ctx` den
Kontext, `:ns` den Namespace; `?` zeigt die Hilfe und `:q` beendet k9s und
schließt bei erfolgreichem Exit das Floating Window. Bei einem Fehler bleibt
die Ausgabe sichtbar. Mit `Ctrl+\`, danach `Ctrl+n`, gelangst du in Neovims
Normalmodus; dort schließen `q` oder `Esc` das Fenster samt Terminal-Prozess.
`kj` wird in k9s nicht abgefangen, damit die Navigation mit `j` und `k`
funktioniert. Dafür setzt die Erweiterung `b:terminal_passthrough`, die
allgemeine Ausnahme für Terminal-Buffer mit eigener Tastensteuerung.

Referenz: [k9s-Befehle und Tastenkürzel](https://k9scli.io/topics/commands/).

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
