# Neovim Dotfiles

Modulare Neovim-Konfiguration in Lua mit lazy.nvim.
Optimiert für Python, Java, TypeScript, YAML/Helm und Docker.

Terminal: Ghostty + tmux mit cyberdream Theme (dark, transparent).


# Teil 1: Was wir gemacht haben

## Der Refactor (Februar 2026)

### Vorher

- Plugin-Manager: Packer (deprecated) + lazy.nvim parallel
- Rund 20 Plugins, viele davon ungenutzt
- LSP-Keybinds über Lspsaga statt native API
- Colorscheme als separater require-Aufruf
- Alle Plugin-Specs inline in einer riesigen lazy-setup.lua
- Alte lspconfig-API (deprecated seit v2)

### Nachher

- Nur noch lazy.nvim als Plugin-Manager
- 10 Plugin-Gruppen, jede in eigener Datei
- LSP über native vim.lsp.config und vim.lsp.enable (Neovim 0.11+)
- Colorscheme als lazy.nvim Plugin mit priority 1000
- Automatisches Laden aller Specs via import
- Jede Datei gibt ein eigenständiges Spec zurück

### Entfernte Plugins

**Packer** -- Deprecated, lazy.nvim ist der Standard.

**lspsaga.nvim** -- Bloat. Die native LSP-UI reicht völlig aus.

**vim-startify** -- Ersetzt durch Space-fr (Telescope oldfiles).

**vim-maximizer** -- tmux kann das besser mit prefix-z.

**nvim-autopairs** -- Minimum-Prinzip. Kann später optional hinzugefügt werden.

**indent-blankline** -- Minimum-Prinzip. Kann später optional hinzugefügt werden.

**molten-nvim und image.nvim** -- Jupyter gehört in den Browser.

**vim-sendtowindow** -- Ohne REPL-Workflow nicht nötig.

**vimtex** -- Kein LaTeX im aktüllen Stack.

**Nvim-R** -- Kein R im aktüllen Stack.

**vim-nightfly-guicolors** -- Ersetzt durch cyberdream.nvim.


## Ordnerstruktur

Alles liegt unter nvim/ im Dotfiles-Repo.

**init.lua** ist der Einstiegspunkt. Er lädt in dieser Reihenfolge: options, keymaps, lazy-setup.

**core/options.lua** enthält alle Vim-Optionen: Leader-Key, Tabs, Suche, Clipboard, Splits.

**core/keymaps.lua** enthält alle Keybinds, sowohl allgemeine als auch Plugin-Trigger.

**lazy-setup.lua** bootstrapt lazy.nvim und importiert automatisch alles aus dem plugins-Ordner.

**plugins/** enthält pro Plugin-Gruppe eine Datei:

- colorscheme.lua -- cyberdream (primary) + fluoromachine (secondary)
- telescope.lua -- Fuzzy Finder mit fzf-native Extension
- nvim-tree.lua -- File Explorer
- lualine.lua -- Statusline
- treesitter.lua -- Syntax Highlighting und Indentation
- cmp.lua -- Autocompletion mit LuaSnip und lspkind
- lsp.lua -- Mason, LSP-Server-Konfiguration und Keybinds
- gitsigns.lua -- Git-Integration mit Hunk-Navigation
- editor.lua -- surround, fugitive, Comment, which-key, tmux-navigator

**lazy-lock.json** ist das Lockfile mit den exakten Plugin-Versionen.


# Teil 2: Keybinds

Leader-Key ist Space.

## Allgemein

**kj** -- Escape aus Insert, Visual und Terminal Mode.

**Space nh** -- Search Highlights löschen.

**x** -- Einzelnes Zeichen löschen ohne es ins Register zu kopieren.

**Space +** und **Space -** -- Zahl unter dem Cursor erhöhen oder verringern.

## Fenster und Tabs

**Space sv** -- Fenster vertikal splitten.

**Space sh** -- Fenster horizontal splitten.

**Space se** -- Alle Splits gleich gross machen.

**Space sx** -- Aktuellen Split schliessen.

**Space to** -- Neuen Tab öffnen.

**Space tx** -- Aktuellen Tab schliessen.

**Space tn** und **Space tp** -- Nächster und vorheriger Tab.

**Ctrl-Pfeiltasten** -- Split-Grösse ändern.

**Space tt** -- Terminal öffnen.

## Telescope (Suche)

**Space ff** -- Dateien suchen.

**Space fs** -- Text suchen (Live Grep).

**Space fc** -- Wort unter dem Cursor suchen.

**Space fb** -- Offene Buffer auflisten.

**Space fh** -- Help Tags durchsuchen.

**Space fr** -- Zuletzt geöffnete Dateien.

In Telescope selbst: Ctrl-k und Ctrl-j zum Navigieren, Enter zum öffnen, Ctrl-q um Auswahl in die Quickfix-Liste zu senden.

## LSP

Diese Keybinds sind nur aktiv wenn ein LSP-Server läuft.

**gd** -- Go to Definition.

**gr** -- References anzeigen.

**K** -- Hover Documentation.

**Space ca** -- Code Action.

**Space rn** -- Rename.

**[d** und **]d** -- Zum vorherigen oder nächsten Diagnostic springen.

**Space d** -- Diagnostic-Float öffnen.

## Git (gitsigns)

**]c** und **[c** -- Zum nächsten oder vorherigen Hunk springen.

**Space hs** -- Hunk stagen.

**Space hr** -- Hunk zurücksetzen.

**Space hp** -- Hunk-Preview anzeigen.

## Sonstige Plugin-Keybinds

**Space e** -- NvimTree ein- und ausblenden.

**gcc** -- Aktülle Zeile kommentieren (Comment.nvim).

**gc** im Visual Mode -- Auswahl kommentieren.

**cs"'** -- Surround: Anführungszeichen von doppelt auf einfach ändern.

**ds"** -- Surround: Anführungszeichen entfernen.

**ysiw"** -- Surround: Wort mit Anführungszeichen umschliessen.


# Teil 3: LSP-Server

Alle Server werden automatisch via Mason installiert.

**pyright** für Python.

**jdtls** für Java.

**ts_ls** für TypeScript und JavaScript.

**yamlls** für YAML.

**helm_ls** für Helm Charts.

**dockerls** für Dockerfiles.

**lua_ls** für Lua, mit Neovim-Runtime konfiguriert damit vim-Globals erkannt werden.


# Teil 4: Wie geht es weiter

## Plugin hinzufügen

Erstelle eine neue Datei im plugins-Ordner. Die Datei muss ein lazy.nvim Spec zurückgeben. Beim nächsten Neovim-Start wird es automatisch geladen.

Für kleine Plugins die keine eigene Config brauchen: einfach in editor.lua hinzufügen.

Beispiel für eine eigene Plugin-Datei:

```lua
return {
  "author/plugin-name",
  event = "BufReadPre",
  opts = {},
}
```

## Colorscheme wechseln

Fluoromachine ist als Zweit-Theme installiert, lädt aber nicht automatisch. Um es zu aktivieren:

Zuerst das Plugin laden mit dem Befehl Lazy load fluoromachine.nvim, dann das Colorscheme setzen mit colorscheme fluoromachine.

## LSP-Server hinzufügen

Drei Schritte in plugins/lsp.lua:

1. Server-Name zur ensure_installed-Liste hinzufügen.
2. Server-Name zur vim.lsp.enable-Liste hinzufügen.
3. Neovim neu starten und mit Mason prüfen.


# Teil 5: Hausaufgaben

Dies ist eine Lernliste um deine Config wirklich zu verstehen, nicht nur zu benutzen. Arbeite die Themen in der Reihenfolge durch.

## 1. Lua Grundlagen

Zeitaufwand: ein bis zwei Abende.

Du musst kein Lua-Experte werden, aber du musst den Code in deiner Config lesen und verstehen können.

**Tables** sind das einzige Datenstruktur-Primitiv in Lua. Arrays und Dictionaries sind beides Tables. Ein Array ist eine Table mit numerischen Keys, ein Dictionary eine mit String-Keys. Beides kann gemischt werden.

**Functions als First-Class Values** bedeutet dass Funktionen wie jeder andere Wert behandelt werden. Du siehst das überall in der Config: config = function() ... end übergibt eine Funktion als Argument.

**require** ist wie Module geladen werden. Der Aufruf require("jlewe.plugins.lsp") lädt die Datei lua/jlewe/plugins/lsp.lua. Punkte werden zu Verzeichnistrennnern.

**pcall** steht für "protected call". Es ruft eine Funktion auf und fängt Fehler ab, anstatt Neovim abstürzen zu lassen. Die alte Config nutzte das viel, die neü weniger weil lazy.nvim eigene Fehlerbehandlung hat.

Ressource: öffne Neovim und lies help lua-guide. Das ist die offizielle Einführung.

## 2. Neovim-API verstehen

Zeitaufwand: ein Abend.

Lies diese Help-Pages direkt in Neovim:

**help vim.opt** erklärt wie Editor-Optionen gesetzt werden. Das nutzen wir in options.lua.

**help vim.keymap.set** erklärt wie Keybinds definiert werden. Das nutzen wir in keymaps.lua und in den Plugin-Configs.

**help vim.lsp** erklärt die native LSP-API die wir in lsp.lua nutzen. Besonders vim.lsp.config und vim.lsp.enable.

**help vim.diagnostic** erklärt das Diagnostic-System für Fehlermeldungen, Warnungen und Hints.

**help autocmd** erklärt Events. Plugins reagieren auf Events wie BufReadPre (bevor ein Buffer geladen wird) oder LspAttach (wenn ein LSP-Server sich an einen Buffer hängt).

## 3. lazy.nvim verstehen

Zeitaufwand: ein Abend.

Lies die lazy.nvim README auf GitHub, besonders den Abschnitt "Plugin Spec". Du musst verstehen was diese Felder bedeuten:

**event** bestimmt wann ein Plugin geladen wird. Zum Beispiel lädt BufReadPre das Plugin bevor eine Datei geöffnet wird, InsertEnter wenn du in den Insert Mode wechselst.

**ft** lädt das Plugin nur für bestimmte Dateitypen.

**cmd** lädt das Plugin wenn ein bestimmter Befehl ausgeführt wird.

**keys** lädt das Plugin wenn ein bestimmter Keybind gedrückt wird.

**dependencies** sind andere Plugins die vorher geladen werden müssen.

**opts** ist eine Table die automatisch an die setup-Funktion des Plugins übergeben wird.

**config** ist eine Funktion die nach dem Laden ausgeführt wird. Nutze config wenn du mehr Kontrolle brauchst als opts bietet.

öffne in Neovim den Befehl Lazy und schau dir an welche Plugins geladen sind und wann sie geladen wurden. Teste Lazy profile um die Ladezeiten zu sehen.

Experiment: Füge event = "VeryLazy" zu einem Plugin hinzu und beobachte den Unterschied im Profiler.

## 4. Treesitter verstehen

Zeitaufwand: 30 Minuten.

Treesitter ersetzt Vims altes regex-basiertes Syntax-Highlighting durch echtes Parsing. Es baut für jede Datei einen Syntax-Tree auf und versteht dadurch die Struktur des Codes.

öffne eine Datei und führe InspectTree aus. Du siehst den Syntax-Tree live. Wenn du den Cursor bewegst, wird der entsprechende Knoten im Tree markiert.

Mit TSInstallInfo siehst du welche Parser installiert sind.

In neueren Neovim-Versionen (0.11+) ist Treesitter-Highlighting automatisch aktiv wenn ein Parser installiert ist. Das Plugin nvim-treesitter ist nur noch für die Parser-Installation zuständig.

## 5. LSP-Workflow verinnerlichen

Zeitaufwand: ein Abend.

öffne eine Python-Datei und teste jeden einzelnen LSP-Keybind: gd für Definition, gr für References, K für Hover, Space ca für Code Actions, Space rn für Rename.

Wichtige Befehle:

**LspInfo** zeigt welcher Server an den aktüllen Buffer angehängt ist.

**LspLog** zeigt Server-Logs wenn etwas nicht funktioniert.

**Mason** öffnet die UI zum Verwalten von LSP-Servern.

Verstehe die Arbeitsteilung: Mason installiert die Server-Binaries. lspconfig liefert die Default-Konfigurationen. Neovim selbst startet die Server und kommuniziert mit ihnen.

## 6. Telescope Power-Features

Zeitaufwand: 30 Minuten.

Teste alle Keybinds: ff, fs, fc, fb, fh, fr.

Tipp: Führe Telescope mit Tab-Completion aus. Du siehst alle verfügbaren Picker, nicht nur die für die wir Keybinds haben.

Besonders nützlich: Telescope keymaps zeigt alle aktiven Keybinds durchsuchbar an. Wenn du jemals vergisst welcher Keybind was tut, ist das dein Rettungsanker.

## 7. Git-Workflow mit gitsigns und fugitive

Zeitaufwand: 30 Minuten.

ändere eine Datei und beobachte wie die Gutter-Signs erscheinen. Springe mit ]c und [c zwischen Hunks. Nutze Space hp für eine Preview, Space hs zum Stagen.

Fugitive ist ein vollständiges Git-Interface: Der Befehl Git öffnet ein interaktives Fenster. Git diff, Git blame und Git log funktionieren wie erwartet, aber direkt in Neovim.

## 8. Plugins für später

Füge diese erst hinzu wenn du die Basis sicher beherrschst.

**nvim-autopairs** schliesst Klammern und Anführungszeichen automatisch. Sinnvoll wenn es dich nervt das manüll zu tun.

**indent-blankline** zeigt visülle Indent-Guides. Sinnvoll bei tief verschachteltem Code.

**trouble.nvim** bietet eine bessere Diagnostic-Liste als der eingebaute Float. Sinnvoll wenn du an grösseren Projekten mit vielen Warnungen arbeitest.

**conform.nvim** führt Auto-Formatter aus (black, prettier, stylua). Sinnvoll wenn du automatische Formatierung beim Speichern willst.

**nvim-lint** integriert Linter die kein LSP haben. Sinnvoll für Tools wie eslint oder flake8.

**harpoon** ermöglicht schnelles Wechseln zwischen markierten Dateien. Sinnvoll wenn du ständig zwischen drei bis vier Files hin und her springst.

**oil.nvim** ist ein File-Manager der wie ein normaler Buffer funktioniert. Sinnvoll wenn dir NvimTree zu IDE-mässig ist.

**lazygit.nvim** öffnet LazyGit direkt in Neovim. Sinnvoll wenn du Git lieber in einem TUI bedienst.

## 9. Tägliche Praxis

**Woche 1:** Nutze nur die Basis-Keybinds. Füge kein Plugin hinzu. Jedes Mal wenn du nicht weisst wie etwas geht: Telescope keymaps ausführen oder Space drücken und warten bis which-key die Optionen anzeigt.

**Woche 2:** Wenn du merkst dass dir etwas fehlt, füge es selbst hinzu. Schreibe das Plugin-Spec von Hand, nicht copy-paste. Nur so lernst du wie die Config funktioniert.
