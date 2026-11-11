# Neovim-Konfiguration

Die Konfiguration setzt auf native Neovim-Funktionen und ergänzt nur klar
abgegrenzte Features mit Plugins. `nvim/init.lua` lädt Optionen, Keymaps und
anschließend lazy.nvim.

## Struktur

```text
nvim/
├── init.lua
├── lazy-lock.json
├── after/lsp/marksman.lua
├── schemas/
│   └── gitlab-ci.json
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
- `plugins/optional/` enthält die erst bei Bedarf geladene DAP-Integration.
- Die optionale Obsidian-Integration wird durch `obsidian.local` aktiviert.
- `after/lsp/` ergänzt einzelne LSP-Server; `schemas/` enthält lokale Schemas.
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
liefert die Serverdefinitionen, Neovim aktiviert die Server nativ. Die Aktivierung
erfolgt zentral in `plugins/lsp.lua`, nachdem Definitionen und eigene Einstellungen
bereitstehen; Masons automatische Aktivierung bleibt ausgeschaltet.

Neue Sprachunterstützung wird an einer Stelle ergänzt:

1. LSP-Server und Mason-Paket in `tooling.lua` eintragen.
2. Nur bei abweichenden Defaults eine `vim.lsp.config()`-Anpassung ergänzen.
3. `./install.sh --update` ausführen oder das Werkzeug mit `:Mason` installieren.

Ghostty ist eine Ausnahme: Die Anwendung liefert Filetype, Syntax und
Kommentaroptionen über einen eigenen Neovim-Runtime-Pfad. Dieser Pfad bleibt
beim Start bewusst erhalten. `ghostty-ls` stammt aus einer zusätzlichen
Mason-Registry und wird deshalb separat in `plugins/lsp.lua` konfiguriert.

Für GitLab-CI-Dateien verwendet YAML-LSP das lokale Schema unter `schemas/`.
Herkunft, Anpassung und Update-Anleitung stehen in der
[Schema-Dokumentation](../nvim/schemas/README.md). Der Marksman-Override unter
`after/lsp/marksman.lua` verhindert Completion beim Tippen von `#`;
Link-Completion und manuelle Completion bleiben verfügbar.

Conform formatiert beim Speichern und fällt bei Bedarf auf LSP-Formatierung
zurück. Python nutzt standardmäßig Black. Enthält die `poetry.lock` neben der
nächsten `pyproject.toml` YAPF, wird stattdessen `poetry run yapf --style google`
ohne LSP-Fallback verwendet; Poetry muss verfügbar sein. Dateien in `.venv/`
oder einer über `pyvenv.cfg` erkannten Umgebung werden nicht formatiert.

nvim-lint startet nach dem Speichern oder beim Verlassen des Insert Mode.
Treesitter-Parser stehen separat in `treesitter_languages.lua`, weil sie sowohl
interaktiv als auch vom Installer verwendet werden.

### Git und Debugging

Gitsigns stellt Hunk-Navigation, Staging, Reset und Blame im Buffer bereit.
LazyGit deckt Repository-weite Git-Workflows ab. nvim-dap, dap-ui und
Virtual Text bilden gemeinsam die Debug-Oberfläche; Debug-Adapter kommen aus
Mason.

### Optionale Integrationen

DAP wird erst über seine Debug-Keymaps geladen; der Python-Adapter `debugpy`
bleibt Teil des Toolings.

YouTrack wird über den lokalen Checkout `~/Developer/yt-tui.nvim` eingebunden.
Nur wenn das Verzeichnis vorhanden ist, werden Plugin, Commands und Keymaps
registriert. `:YtTui` lädt und öffnet die Integration bei Bedarf. Der Installer
legt den Checkout nicht an.

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

### Obsidian-Vault

Neovim und die Obsidian-App bearbeiten denselben Vault. Es gibt keine Kopie
und keinen zusätzlichen Synchronisationsdienst. Die maschinenspezifische
Konfiguration liegt in `nvim/obsidian.local` (JSON, von Git ignoriert).
Auf einem neuen Rechner `nvim/obsidian.local.example` dorthin kopieren und
`path` auf den bestehenden Vault setzen. Ohne gültigen Vault bleibt das
Plugin deaktiviert.

`obsidian-nvim/obsidian.nvim` lädt beim Öffnen einer Markdown-Datei im Vault
oder über `:Obsidian` und die Gruppe `Space o`. Die Version folgt stabilen
Releases; `lazy-lock.json` hält den installierten Stand fest. Telescope und
Neovims native Completion werden wiederverwendet. Innerhalb des Vaults
übernimmt `obsidian-ls`, außerhalb bleibt Marksman zuständig.

Nach einem Neustart beispielsweise `nvim "$HOME/Documents/Obsidian Vault"`
öffnen oder von überall `Space o f` für die Notizsuche verwenden.

| Befehl | Funktion |
| --- | --- |
| `:Obsidian quick_switch` | Notiz nach Dateiname suchen |
| `:Obsidian search` | Volltextsuche im Vault |
| `:Obsidian new Mein Thema` | Notiz mit diesem Dateinamen in der Vault-Wurzel anlegen |
| `:Obsidian today` | Daily Note öffnen oder anlegen |
| `:Obsidian backlinks` | Rückverweise auf die aktuelle Notiz anzeigen |
| `:Obsidian open` | Aktuelle Notiz in der Obsidian-App öffnen |
| `:Obsidian paste_img` | Clipboard-Bild ablegen und in der Notiz verlinken |

Die letzten drei Aktionen sind über buffer-lokale Tasten nur in Vault-Notizen
verfügbar. `Enter` im Normalmodus folgt Links oder bedient Checkboxen;
`]o` und `[o` springen zwischen Links. Beim Tippen von `[[` und einem Teil
des Namens erscheinen Linkvorschläge. `Ctrl-Space` stößt Completion manuell
an, `Tab` wählt einen Vorschlag und `Enter` übernimmt die Auswahl.

Neue Notizen behalten Titel, Leerzeichen und Großschreibung als Dateinamen.
Daily Notes liegen wie in der App unter `Daily Notes` mit `DD.MM.YYYY` als
Dateiname; Bildanhänge landen in der Vault-Wurzel. Diese beiden Ablagen lassen
sich in der lokalen JSON-Datei anpassen. Es werden keine Vorlagen vorgegeben.
Vorhandene Properties werden gelesen, aber nicht automatisch ergänzt oder
umgeschrieben. Automatische Formatierung beim Speichern ist ausschließlich
für Vault-Notizen aus; explizites Formatieren mit `Space c f` bleibt möglich.

`pngpaste` für Clipboard-Bilder auf macOS ist Teil von `install.sh`; unter
Wayland ist `wl-clipboard` bereits vorgesehen. Die Markdown-Parser
`markdown` und `markdown_inline` stehen in der gemeinsamen Treesitter-Liste.
`:checkhealth obsidian` prüft die Integration. Hinweise auf optionale Audio-
und Bildbearbeitungsprogramme erfordern für diesen Notiz-Workflow keine
zusätzliche Installation.

Referenz: [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim).

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
