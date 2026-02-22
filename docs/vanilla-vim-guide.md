# Vanilla Vim Guide

Dieses Dokument zeigt dir die nativen Neovim/Vim-Alternativen zu den Plugins, die du entfernt hast. Alles hier funktioniert ohne ein einziges Plugin — in jedem Vim/Neovim, auf jedem Server.

---

## 1. Dateien finden (ersetzt Telescope)

### Dateien nach Name finden: `:find`

```vim
" In deiner options.lua ist path+=** bereits konfiguriert.
" Das erlaubt rekursive Suche:

:find main.py          " Datei direkt öffnen
:find *.lua<Tab>       " Tab-Completion zeigt alle .lua Dateien
:find *test*<Tab>      " Alle Dateien mit 'test' im Namen
:sfind main.py         " Öffnet in horizontalem Split
:vert sfind main.py    " Öffnet in vertikalem Split
```

### Text in Dateien suchen: `:grep`

```vim
" grepprg ist auf ripgrep konfiguriert (wenn installiert).
" Ergebnisse landen in der Quickfix-Liste.

:grep "def main" **/*.py     " Suche nach Pattern in Python-Dateien
:grep TODO                   " Suche in allen Dateien
:copen                       " Quickfix-Liste öffnen (Ergebnisliste)
:cn                          " Nächstes Ergebnis
:cp                          " Vorheriges Ergebnis
:ccl                         " Quickfix schließen
```

### Text in der aktuellen Datei suchen: `/`

```vim
/pattern        " Vorwärts suchen
?pattern        " Rückwärts suchen
n               " Nächster Treffer
N               " Vorheriger Treffer
*               " Wort unter dem Cursor vorwärts suchen
#               " Wort unter dem Cursor rückwärts suchen
```

### Buffer wechseln: `:ls` + `:b`

```vim
:ls              " Alle offenen Buffer auflisten
:b name<Tab>     " Buffer nach (Teil-)Name wechseln
:b 3             " Buffer nach Nummer wechseln
:bn              " Nächster Buffer
:bp              " Vorheriger Buffer
:bd              " Buffer schließen (Datei bleibt gespeichert)
```

Tipp: `<leader>fb` ist als Keymap konfiguriert — zeigt Buffer-Liste und lässt dich wechseln.

---

## 2. Dateiexplorer (ersetzt nvim-tree)

### netrw — Vim's eingebauter Dateimanager

```vim
:Ex              " Explorer im aktuellen Fenster öffnen
:Vex             " Explorer in vertikalem Split
:Lex             " Explorer als Sidebar links (25% Breite)
:Sex             " Explorer in horizontalem Split
```

In deiner `options.lua` ist netrw bereits konfiguriert:
- Kein Banner (cleaner Look)
- Long-Listing (Name + Größe + Datum) — `liststyle=1`
- Tree-Modus (`liststyle=3`) ist deaktiviert weil er einen `E471`-Bug beim Navigieren hat
- 25% Breite bei Splits

`<leader>e` öffnet `:Lex` — dein Dateiexplorer-Toggle.

**Hinweis:** `<C-h/j/k/l>` zum Wechseln zwischen Splits funktioniert auch innerhalb von netrw, weil ein Autocmd in `keymaps.lua` die netrw-internen Mappings überschreibt (netrw belegt `<C-l>` sonst für Refresh).

### Navigation in netrw

```
Enter     Datei öffnen / Ordner betreten
-         Eine Ebene hoch (Elternverzeichnis)
%         Neue Datei erstellen (fragt nach Name)
d         Neues Verzeichnis erstellen
D         Datei/Verzeichnis löschen
R         Umbenennen
i         Ansicht wechseln (Liste → Baum → Spalten)
s         Sortierung ändern (Name → Zeit → Größe)
/         Suchen (normale Vim-Suche)
```

---

## 3. Autocompletion (ersetzt nvim-cmp)

### Vim's eingebaute Completion-Modi

Alle starten mit `<C-x>` im Insert Mode, gefolgt von einem zweiten Buchstaben:

```vim
<C-x><C-n>     Keywords aus dem aktuellen Buffer
<C-x><C-f>     Dateipfade (absolut oder relativ)
<C-x><C-l>     Ganze Zeilen (aus allen offenen Buffern)
<C-x><C-]>     Tags (aus ctags-Datei, siehe Kapitel 4)
<C-x><C-o>     Omni Completion (sprach-spezifisch, z.B. HTML)
<C-x><C-k>     Wörterbuch (wenn spell aktiviert)
```

### Schnelle Completion ohne `<C-x>`

```vim
<C-n>          Nächster Vorschlag (Keywords aus allen Buffern)
<C-p>          Vorheriger Vorschlag
```

### Navigation im Completion-Menü

```vim
<C-n>          Nächster Eintrag
<C-p>          Vorheriger Eintrag
<C-y>          Auswahl bestätigen
<C-e>          Completion abbrechen
```

### Workflow-Tipp

Tippe die ersten 2-3 Buchstaben, dann `<C-n>`. Vim schlägt aus allen offenen Buffern vor. Das ist für 90% der Fälle ausreichend.

---

## 4. Code-Navigation (ersetzt LSP)

### ctags — Vim's natives "Go to Definition"

```bash
# Installieren (einmalig)
sudo apt install universal-ctags   # Linux
brew install universal-ctags       # macOS

# Tags generieren (im Projektverzeichnis ausführen)
ctags -R .
```

Das erstellt eine `tags`-Datei. Vim liest sie automatisch.

### Navigation mit Tags

```vim
<C-]>          Springe zur Definition des Worts unter dem Cursor
<C-t>          Springe zurück (Stack-basiert, mehrfach möglich)
:tag name      Springe zu einem Tag nach Name
:tselect name  Zeige alle Matches wenn es mehrere gibt
:tnext         Nächster Tag-Match
:tprev         Vorheriger Tag-Match
g]             Zeige alle Tags für Wort unter Cursor (mit Auswahl)
```

### Tags automatisch aktualisieren

Füge dies zu deiner Shell hinzu (oder führe es manuell aus):
```bash
# Nach jedem git pull oder größeren Änderungen:
ctags -R .
```

### Include-File-Suche (ohne ctags)

```vim
[I             Zeige alle Zeilen die das Wort unter dem Cursor enthalten
[<C-I>         Springe zur ersten Fundstelle
gd             Go to local Declaration (selbe Datei)
gD             Go to global Declaration (selbe Datei)
```

---

## 5. Kommentieren (ersetzt Comment.nvim)

### Visual Block Mode — die wichtigste Technik

**Kommentare hinzufügen:**
```
1. <C-v>        Visual Block Mode starten
2. j/k          Zeilen selektieren (so viele wie nötig)
3. I            Insert am Zeilenanfang (großes I!)
4. # <Space>    Kommentarzeichen tippen
5. <Esc>        Auf alle Zeilen anwenden
```

**Kommentare entfernen:**
```
1. <C-v>        Visual Block Mode starten
2. j/k          Zeilen selektieren
3. l            Selektion erweitern (um "# " abzudecken)
4. d oder x     Löschen
```

### Alternative: Norm-Befehl

```vim
" Zeilen 5-15 kommentieren:
:5,15norm I#

" Zeilen 5-15 entkommentieren:
:5,15norm ^xx

" Visuelle Selektion kommentieren:
:'<,'>norm I#

" Für verschiedene Sprachen:
:'<,'>norm I//
:'<,'>norm I--
```

### Alternative: Suchen & Ersetzen

```vim
" Aktuelle Zeile + 5 darunter kommentieren:
:.,.+5s/^/# /

" Entkommentieren:
:.,.+5s/^# //

" Ganze Datei kommentieren (Vorsicht!):
:%s/^/# /
```

### Warum das besser ist als ein Plugin

Visual Block Mode (`<C-v>`) ist eine der mächtigsten Vim-Funktionen. Du kannst damit nicht nur kommentieren, sondern:
- Text in mehreren Zeilen gleichzeitig einfügen
- Spalten löschen
- Tabellen ausrichten
- Variablennamen in mehreren Zeilen ändern

Jedes Mal wenn du kommentierst, trainierst du `<C-v>`.

---

## 6. Git im Terminal (ersetzt gitsigns)

### Grundlegende Git-Befehle in Neovim

```vim
:!git status             " Git status anzeigen
:!git diff               " Unstaged changes anzeigen
:!git diff --staged      " Staged changes anzeigen
:!git log --oneline -10  " Letzte 10 Commits
:!git add %              " Aktuelle Datei stagen (% = aktueller Dateiname)
```

### Interaktives Staging: `git add -p`

```bash
# Im Terminal (nicht in Vim):
git add -p

# Zeigt jeden geänderten Hunk einzeln:
# y = stage this hunk
# n = skip this hunk
# s = split into smaller hunks
# q = quit
```

Das ist mächtiger als jedes Plugin — du siehst genau was du committest.

### Neovim's eingebautes Diff

```vim
" Zwei Dateien vergleichen:
nvim -d file1 file2

" Oder innerhalb von Neovim:
:vert diffsplit other_file.py

" Diff-Befehle:
]c              Nächste Änderung
[c              Vorherige Änderung
do              Diff obtain (Änderung vom anderen Buffer übernehmen)
dp              Diff put (Änderung zum anderen Buffer schicken)
:diffoff        Diff-Modus beenden
```

### Workflow-Empfehlung

Halte ein tmux-Pane für Git offen:
```
<prefix> |     " Vertikalen Split in tmux
git status     " Im neuen Pane
git diff       " Änderungen anschauen
git add -p     " Interaktiv stagen
git commit     " Commit schreiben (öffnet Neovim!)
```

---

## 7. Keymaps nachschlagen (ersetzt which-key)

### Alle Mappings anzeigen

```vim
:map              " Alle Mappings (alle Modi)
:nmap             " Nur Normal Mode
:imap             " Nur Insert Mode
:vmap             " Nur Visual Mode

" Nach Prefix filtern:
:nmap <leader>    " Alle Leader-Mappings im Normal Mode
:nmap <C-         " Alle Ctrl-Mappings

" Einzelnes Mapping nachschlagen:
:verbose nmap <leader>e    " Zeigt WO das Mapping definiert wurde
```

### Hilfe nutzen

```vim
:help              " Allgemeine Hilfe
:help key-notation " Erklärung der Tastenschreibweise (<C-x>, <leader>, etc.)
:help insert       " Hilfe zu Insert Mode
:help visual       " Hilfe zu Visual Mode
:help quickfix     " Hilfe zur Quickfix-Liste
:help netrw        " Hilfe zum Dateiexplorer
:help ins-completion " Alle eingebauten Completion-Modi
```

### Deine konfigurierten Keymaps (Referenz)

**Allgemein:**
- `kj` — Insert/Visual/Terminal Mode verlassen
- `<leader>nh` — Suchhighlights löschen
- `x` — Zeichen löschen (ohne Yank)
- `<leader>+` / `<leader>-` — Zahl erhöhen/verringern

**Fenster/Splits:**
- `<leader>sv` / `<leader>sh` — Vertical/Horizontal Split
- `<leader>se` — Splits gleichmäßig verteilen
- `<leader>sx` — Split schließen
- `<C-h/j/k/l>` — Zwischen Splits navigieren
- `<C-Pfeiltasten>` — Splits resizen

**Tabs:**
- `<leader>to` — Neuer Tab
- `<leader>tx` — Tab schließen
- `<leader>tn` / `<leader>tp` — Nächster/Vorheriger Tab

**Dateien:**
- `<leader>e` — Dateiexplorer (netrw) toggle
- `<leader>fb` — Buffer-Liste

**Terminal:**
- `<leader>tt` — Terminal-Split öffnen

---

## Cheat Sheet: Was du als Erstes üben solltest

### Woche 1-2: Bewegung
```
h j k l          Grundbewegung
w b e            Wortweise bewegen
0 ^ $            Zeilenanfang / erstes Zeichen / Zeilenende
gg G             Dateianfang / Dateiende
{ }              Absatz vor/zurück
<C-d> <C-u>      Halbe Seite runter/hoch
f{char} F{char}  Zum Zeichen springen (vorwärts/rückwärts)
t{char} T{char}  Bis vor das Zeichen springen
; ,              Wiederhole f/t vorwärts/rückwärts
```

### Woche 3-4: Editing
```
ciw caw          Change inner/around word
ci" ca"          Change inner/around quotes
ci( ca(          Change inner/around parens
diw daw          Delete inner/around word
yiw yaw          Yank inner/around word
>>  <<           Einrücken / Ausrücken
J                Zeilen zusammenfügen
.                Letzte Aktion wiederholen (DER mächtigste Befehl)
```

### Woche 5-6: Visual Mode
```
v                Visual (zeichenweise)
V                Visual Line (zeilenweise)
<C-v>            Visual Block (spaltenweise) ← übe das!
gv               Letzte Selektion wiederherstellen
o                Springe zum anderen Ende der Selektion
```

### Ab Woche 7: Fortgeschritten
```
:find            Dateien suchen
:grep            Text suchen
<C-x><C-n>      Completion
<C-]> <C-t>      Tags (nach ctags -R .)
:Ex :Vex :Lex   Dateiexplorer
q{reg}           Makro aufnehmen
@{reg}           Makro abspielen
```
