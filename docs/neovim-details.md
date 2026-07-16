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
- lsp.lua -- Mason, LSP-Server und native Neovim-Completion
- navigation.lua -- trouble.nvim (Diagnostics und Symbol-Liste)
- dap.lua -- nvim-dap + dap-ui + virtual-text + mason-nvim-dap (Debugging)
- jupyter.lua -- JupyNvim fuer native .ipynb-Notebooks
- jira.lua -- Lazy-loaded Jira-Board mit maschinenlokaler Konfiguration
- formatting.lua -- conform.nvim (Auto-Format on Save)
- gitsigns.lua -- gitsigns.nvim (Git-Gutter, Hunk-Staging, Blame)
- linting.lua -- nvim-lint (Async Linting)
- autopairs.lua -- nvim-autopairs (Klammern/Quotes automatisch schliessen)
- editor.lua -- vim-surround


# Teil 2: Keybinds

Leader-Key ist Space.

## Allgemein

**kj** -- Escape aus Insert, Visual und Terminal Mode (ausser LazyGit).

**Space Space** -- Search Highlights loeschen.

**x** -- Einzelnes Zeichen loeschen, ohne das Standard-Register zu ueberschreiben.

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

**Space ca** -- Code Action.

**Space rn** -- Symbol umbenennen.

**Space d** -- Diagnostic-Float oeffnen.

Die nativen Neovim-Aliase bleiben ebenfalls verfuegbar:

**grr** fuer References, **gri** fuer Implementierungen, **grn** fuer Rename,
**gra** fuer Code Actions, **gO** fuer Dokument-Symbole und **Ctrl-w d** fuer
das Diagnostic-Float.

**K** -- Hover Documentation.

**[d** und **]d** -- Zum vorherigen oder naechsten Diagnostic springen.

## Autocompletion (nativ)

Im Insert Mode:

**Tab** und **Shift-Tab** -- Naechsten oder vorherigen Vorschlag auswaehlen.

**Enter** -- Explizit ausgewaehlten Vorschlag bestaetigen.

**Ctrl-Space** -- LSP-Completion manuell ausloesen.

Die vertrauten Tasten liegen auf Neovims nativer Completion. Ctrl-n/Ctrl-p und
Ctrl-y funktionieren weiterhin als native Alternativen; nvim-cmp und LuaSnip
sind dafuer nicht mehr notwendig.

## Navigation

**Space cs** -- Dokument-Symbole mit Trouble ein-/ausblenden.

**Space xs** -- Zusaetzlicher Alias fuer dieselbe Symbol-Liste.

**Space xx** -- Diagnostics-Panel (trouble) ein-/ausblenden.

## Jira

**Space jj** -- Das Jira-Board aus `nvim/jira.local.lua` oeffnen.

Die maschinenlokale Datei wird nicht von Git getrackt. Als Vorlage dient
`nvim/jira.example.lua`. Der Jira-PAT liegt separat im Neovim-Datenverzeichnis
und wird einmalig mit `:Jira auth login` eingerichtet. Mit `read_only = true`
blockiert die lokale Konfiguration Status-, Assignee-, Worklog-, Kommentar-,
Create- und Edit-Aktionen sowie vom Jira-Plugin ausgeloeste Git-Branch-Wechsel.

## Debugging (DAP)

Neovim nutzt dasselbe Debug Adapter Protocol wie VSCode. Debug-Adapter werden
automatisch via Mason installiert. Die UI oeffnet sich automatisch beim Start
einer Debug-Session und schliesst sich beim Beenden.

**Space db** -- Breakpoint setzen oder entfernen.

**Space dB** -- Konditionalen Breakpoint setzen (mit Bedingung).

**Space dc** -- Debugging starten oder fortsetzen.

**Space di** -- Step Into (in Funktion hineinspringen).

**Space do** -- Step Over (naechste Zeile, Funktion ueberspringen).

**Space dO** -- Step Out (aus aktueller Funktion herausspringen).

**Space dr** -- REPL oeffnen (Ausdruecke auswerten waehrend der Debug-Session).

**Space dl** -- Letzte Debug-Konfiguration erneut ausfuehren.

**Space dt** -- Debug-Session beenden.

**Space du** -- Debug-UI manuell ein-/ausblenden.

Neue Sprache hinzufuegen: Adapter-Name zur ensure_installed-Liste in
plugins/dap.lua hinzufuegen. Verfuegbare Adapter:
python (debugpy), codelldb (C/C++/Rust), js (Node.js), delve (Go), bash.

## Formatting (conform.nvim)

Code wird automatisch beim Speichern formatiert. conform.nvim nutzt dedizierte
Formatter statt LSP, weil die fuer reproduzierbare Formatierung spezialisiert
sind. Falls kein Formatter konfiguriert ist, wird LSP als Fallback genutzt.

**Space cf** -- Code manuell formatieren (funktioniert auch auf Visual Selection).

**:ConformInfo** -- Zeigt welcher Formatter fuer die aktuelle Datei aktiv ist.

Konfigurierte Formatter:
- Python: black
- Lua: stylua
- Bash: shfmt
- JSON/YAML/Markdown: prettier

Formatter installieren: :MasonInstall black stylua prettier
Oder: pacman -S python-black stylua prettier

Neuen Formatter hinzufuegen: Filetype + Formatter-Name in formatters_by_ft
in plugins/formatting.lua eintragen.

## Linting (nvim-lint)

Linter laufen automatisch beim Speichern und Verlassen des Insert Mode. Der
erste Start bleibt frei von externen Linter-Prozessen. Diagnostics erscheinen
im Gutter und in Trouble (Space xx).

LSP-Server liefern Typ-Fehler, aber Linter finden mehr:
- ruff: Python Style, Import-Sortierung, Security-Probleme (ersetzt flake8+isort)
- shellcheck: Bash-Korrektheit und Portabilitaet

Linter installieren: :MasonInstall ruff shellcheck

Neuen Linter hinzufuegen: Filetype + Linter-Name in linters_by_ft
in plugins/linting.lua eintragen.

## Git Integration (gitsigns.nvim)

Zeigt Git-Aenderungen live im Gutter (gruener Balken = hinzugefuegt,
gelber Balken = geaendert, roter Marker = geloescht). Ergaenzt LazyGit
um Inline-Informationen direkt im Editor.

**]c** und **[c** -- Zum naechsten oder vorherigen Hunk (geaenderten Block) springen.

**Space hs** -- Hunk stagen (wie git add fuer einzelne Zeilen). Auch in Visual Mode.

**Space hr** -- Hunk zuruecksetzen (Aenderungen verwerfen).

**Space hS** -- Gesamte Datei stagen.

**Space hR** -- Gesamte Datei zuruecksetzen.

**Space hp** -- Hunk in Popup anzeigen (was hat sich geaendert?).

**Space hb** -- Git Blame fuer aktuelle Zeile (zeigt vollen Commit).

**Space hB** -- Inline Blame ein-/ausschalten (wer hat jede Zeile geschrieben).

## Sonstige Plugin-Keybinds

**Space e** -- netrw File Explorer ein-/ausblenden.

**cs"'** -- Surround: Anfuehrungszeichen von doppelt auf einfach aendern.

**ds"** -- Surround: Anfuehrungszeichen entfernen.

**ysiw"** -- Surround: Wort mit Anfuehrungszeichen umschliessen.

## Auto Pairs (nvim-autopairs)

Klammern, Anfuehrungszeichen und andere Paare werden automatisch geschlossen.
Cursor landet zwischen dem Paar.

**(**  wird zu **()**  mit Cursor dazwischen.

**"**  wird zu **""**  mit Cursor dazwischen.

**{**  wird zu **{}**  mit Cursor dazwischen.

**)** tippen wenn Cursor vor **)** steht -- springt drueber statt doppelt einzufuegen.

**Enter** zwischen **{}** -- formatiert mit Einrueckung.

Nutzt Treesitter fuer intelligentes Matching (keine Auto-Pairs in Strings oder Kommentaren).


# Teil 3: LSP-Server

Alle Server werden automatisch via Mason installiert.

Aktiv sind **pyright** fuer Python, **bashls** fuer Bash, **marksman** fuer
Markdown, **yamlls** fuer YAML, **helm_ls** fuer Helm und **lua_ls** fuer die
Neovim-Konfiguration. Treesitter-Parser sind auf Python, Bash, Markdown, YAML,
Helm sowie Lua und JSON begrenzt.

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

Fuege weitere Plugins erst hinzu, wenn ein wiederkehrendes Problem den Nutzen
messbar rechtfertigt. Der aktuelle Stack deckt Navigation, LSP, Completion,
Formatting, Linting, Git, Debugging und Notebooks bereits ab.

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
