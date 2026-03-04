# Hax0r Guide — Vom Dotfiles-Setup zum Power User

Du hast ein solides Fundament: Hyprland, Neovim mit LSP, tmux, plain zsh, alles auf Arch. Dieser Guide zeigt dir, was als naechstes kommt — in sinnvoller Reihenfolge.

---

## Phase 1: Deine Tools meistern

Bevor du neue Tools lernst, werde schnell mit dem was du hast. Das ist der groesste Produktivitaets-Boost.

### Vim-Motions

Das Ziel: Du denkst nicht mehr in Tasten, sondern in Aktionen. "Loesche alles in den Klammern" wird zu `di(` — ohne nachzudenken.

**Text Objects — die wichtigste Vim-Technik:**
```
ci"        Change inner quotes (loescht Inhalt zwischen ", bleibt im Insert Mode)
ca"        Change around quotes (loescht auch die Anfuehrungszeichen selbst)
di(        Delete inner parens
da{        Delete around braces
yi[        Yank inner brackets
vi<tag>    Select inner HTML tag
```

Kombinierbar mit jedem Operator (`d`, `c`, `y`, `v`) und jedem Object (`w`, `"`, `'`, `` ` ``, `(`, `{`, `[`, `<`, `t` fuer Tags, `p` fuer Paragraph, `s` fuer Sentence).

**Der Dot-Befehl (`.`):**
```
ciw new_name <Esc>    Wort ersetzen
n                      Naechster Suchtreffer
.                      Gleiche Aenderung wiederholen
```

`.` wiederholt die letzte *Aenderung*, nicht die letzte *Bewegung*. Das macht ihn so maechtig — du baust dir quasi ein Einmal-Makro.

**Makros:**
```
qa          Makro aufnehmen in Register a
(Aktionen)  Alles was du tippst wird aufgezeichnet
q           Aufnahme stoppen
@a          Makro abspielen
@@          Letztes Makro nochmal
5@a         Makro 5 mal abspielen
```

Typischer Use-Case: Eine Zeile umformatieren, dann `@a` auf 50 weitere Zeilen anwenden. Funktioniert auch mit visueller Selektion: Zeilen markieren, dann `:'<,'>norm @a`.

**Stichworte zum Vertiefen:**
- `:help text-objects` — vollstaendige Liste aller Text Objects
- `:help repeat` — alles ueber `.`, Makros, `@:`
- Vim-Surround (`ys`, `cs`, `ds`) hast du schon — nutze es aktiv
- `g;` und `g,` — durch die Changelist springen (wo hast du zuletzt editiert?)
- `<C-a>` / `<C-x>` im Visual Mode — Zahlen in mehreren Zeilen inkrementieren

### tmux Workflows

Einzelne tmux-Session reicht fuer den Anfang. Wenn du an mehreren Projekten arbeitest, werden benannte Sessions maechtig.

**Sessions verwalten:**
```bash
tmux new -s dotfiles          Neue Session "dotfiles"
tmux new -s webapp            Neue Session "webapp"
tmux ls                       Alle Sessions auflisten
tmux attach -t dotfiles       Zu Session wechseln
```

In tmux:
```
Ctrl-A s       Session-Picker (interaktiv wechseln)
Ctrl-A $       Session umbenennen
Ctrl-A d       Session detachen (laeuft im Hintergrund weiter)
Ctrl-A (       Vorherige Session
Ctrl-A )       Naechste Session
```

**Workflow-Pattern:** Eine Session pro Projekt, mit festem Pane-Layout:
```
Pane 0: Neovim (Code)
Pane 1: Terminal (git, tests, builds)
Pane 2: Logs / Server
```

**Stichworte zum Vertiefen:**
- `tmux send-keys` — Befehle programmatisch an Panes schicken
- Eigene Scripts fuer Projekt-Setups: Session erstellen + Panes + Commands in einem Befehl
- `tmux capture-pane` — Pane-Inhalt in eine Datei schreiben (Debugging)
- `tmux pipe-pane` — Pane-Output live in eine Datei streamen

### Shell-Scripting

Dein `~/.local/bin/` ist dein persoenlicher Werkzeugkasten. Alles was du mehr als zweimal tippst, gehoert in ein Script.

**Bash-Grundlagen die du koennen musst:**
```bash
# Variablen und String-Operationen
name="hello"
echo "${name^^}"          # HELLO (uppercase)
echo "${name:0:3}"        # hel (substring)
echo "${file%.txt}.md"    # Extension ersetzen

# Conditionals
[[ -f "$file" ]]          # Datei existiert?
[[ -d "$dir" ]]           # Verzeichnis existiert?
[[ -z "$var" ]]           # Variable leer?
[[ "$a" == "$b" ]]        # Strings gleich?

# Loops
for f in *.txt; do echo "$f"; done
while read -r line; do echo "$line"; done < file.txt

# Pipes und Process Substitution
command1 | command2                    # Pipe
diff <(command1) <(command2)           # Process Substitution
command > output.txt 2>&1             # Stdout + Stderr umleiten
```

**Nuetzliche Script-Ideen:**
- `proj` — tmux-Session mit vordefiniertem Layout fuer ein Projekt starten
- `backup` — wichtige Configs/Daten mit rsync sichern
- `cleanup` — Cache-Verzeichnisse aufraeumen, alte Logs loeschen
- `sysinfo` — CPU, RAM, Disk, Updates auf einen Blick

**Stichworte zum Vertiefen:**
- `set -euo pipefail` — stricte Fehlerbehandlung in Scripts
- `trap` — Cleanup bei Script-Abbruch (temp files loeschen etc.)
- `xargs` — Argumente aus stdin an Befehle uebergeben
- `shellcheck` — Linter fuer Shell-Scripts (installieren: `pacman -S shellcheck`)
- POSIX sh vs Bash vs Zsh — Unterschiede kennen (Portabilitaet)

---

## Phase 2: Linux verstehen

Du benutzt Linux — jetzt lern wie es funktioniert.

### Systemd

Systemd verwaltet alles: Services, Timers, Logs, Boot, Netzwerk.

**Services verstehen:**
```bash
systemctl status sshd                 # Status eines Service
systemctl start/stop/restart sshd     # Service steuern
systemctl enable/disable sshd         # Autostart an/aus
systemctl list-units --type=service   # Alle aktiven Services
systemctl list-unit-files             # Alle installierten Services
systemctl --failed                    # Fehlgeschlagene Services
```

**Eigene Services schreiben:**
```ini
# ~/.config/systemd/user/mein-service.service
[Unit]
Description=Mein Service

[Service]
ExecStart=/home/jonas/.local/bin/mein-script
Restart=on-failure

[Install]
WantedBy=default.target
```

```bash
systemctl --user daemon-reload
systemctl --user enable --now mein-service
```

**Timers statt Cronjobs:**
```ini
# ~/.config/systemd/user/backup.timer
[Unit]
Description=Taegliches Backup

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

**Logs mit journalctl:**
```bash
journalctl -u sshd                   # Logs fuer einen Service
journalctl -f                        # Live-Log (wie tail -f)
journalctl --since "1 hour ago"      # Zeitfilter
journalctl -p err                    # Nur Fehler
journalctl --user -u mein-service    # User-Service Logs
```

**Stichworte zum Vertiefen:**
- `systemd-analyze blame` — was braucht beim Boot am laengsten?
- Socket Activation — Service startet erst wenn jemand den Port anfragt
- `systemd-tmpfiles` — temporaere Dateien verwalten
- `systemd-nspawn` — leichtgewichtige Container (wie chroot, aber besser)
- `loginctl` — User-Sessions verwalten (dein Hyprland laeuft als User-Session)

### Netzwerk

**Grundlegende Befehle:**
```bash
ip addr                     # Netzwerk-Interfaces und IPs
ip route                    # Routing-Tabelle
ss -tulnp                   # Offene Ports (welcher Prozess hoert wo?)
curl -v https://example.com # HTTP-Request mit Details
dig example.com             # DNS-Abfrage
host example.com            # Einfachere DNS-Abfrage
ping -c 3 example.com       # Erreichbarkeit pruefen
traceroute example.com      # Route zum Ziel anzeigen
```

**DNS verstehen:**
```
Browser tippt "github.com" ein
  → /etc/resolv.conf → welcher DNS-Server?
  → DNS-Server → A-Record → 140.82.121.3
  → TCP-Verbindung zu 140.82.121.3:443
  → TLS-Handshake → HTTP-Request
```

**Firewall (nftables/iptables):**
```bash
sudo nft list ruleset        # Aktuelle Firewall-Regeln
sudo ss -tulnp               # Welche Ports sind offen?
```

**Stichworte zum Vertiefen:**
- TCP/IP Stack — SYN, SYN-ACK, ACK (der Dreiwege-Handshake)
- Subnetting — CIDR-Notation verstehen (`192.168.1.0/24`)
- NAT, Port Forwarding — wie kommt Traffic von aussen rein?
- Wireshark / `tcpdump` — Pakete live mitlesen
- `/etc/hosts` — lokale DNS-Overrides
- mDNS / Avahi — Geraete im lokalen Netz finden (`.local` Domains)

### Prozesse und Permissions

**Prozesse untersuchen:**
```bash
ps aux                       # Alle Prozesse
ps aux | grep nvim           # Bestimmten Prozess finden
pstree -p                    # Prozessbaum mit PIDs
top / htop / btop            # Interaktiver Prozess-Monitor
kill -TERM <pid>             # Sauber beenden
kill -KILL <pid>             # Sofort beenden (letzter Ausweg)
```

**Debugging mit strace:**
```bash
strace -p <pid>              # Systemcalls eines laufenden Prozesses
strace -f command            # Command starten und tracen (-f = Forks folgen)
strace -e open command       # Nur bestimmte Syscalls zeigen
```

Wenn ein Programm sich seltsam verhaelt: `strace` zeigt dir *genau* was es tut — welche Dateien es oeffnet, welche Netzwerkverbindungen es macht, wo es haengt.

**Offene Dateien:**
```bash
lsof -p <pid>                # Alle offenen Dateien eines Prozesses
lsof -i :8080                # Wer hoert auf Port 8080?
lsof +D /tmp                 # Wer hat Dateien in /tmp offen?
```

**Permissions:**
```bash
ls -la                       # Permissions anzeigen
chmod 755 script.sh          # rwxr-xr-x
chmod u+x script.sh          # Execute fuer Owner
chown user:group file        # Besitzer aendern

# Spezielle Permissions
chmod u+s binary             # SUID — laeuft als Owner (gefaehrlich!)
chmod g+s directory          # SGID — neue Dateien erben Gruppe
chmod +t /tmp                # Sticky Bit — nur Owner darf loeschen
```

**Stichworte zum Vertiefen:**
- `/proc/<pid>/` — Pseudo-Filesystem mit Prozess-Infos (maps, fd, status, environ)
- `namespaces` — Prozess-Isolation (Grundlage von Containern)
- `cgroups` — Ressourcen-Limits (CPU, RAM pro Prozessgruppe)
- `capabilities` — feinkoerniger als root/nicht-root (z.B. `CAP_NET_BIND_SERVICE`)
- `ulimit` — Ressourcen-Limits pro Shell-Session
- SELinux / AppArmor — Mandatory Access Control

---

## Phase 3: Dev-Skills aufleveln

### Git richtig

Ueber `add`, `commit`, `push` hinaus.

**Interactive Rebase:**
```bash
git rebase -i HEAD~5         # Letzte 5 Commits bearbeiten
# Im Editor:
# pick   = behalten
# reword = Commit-Message aendern
# squash = mit vorherigem Commit verschmelzen
# drop   = Commit loeschen
# edit   = anhalten, Aenderungen machen, git rebase --continue
```

**Bisect — Bug per Binaersuche finden:**
```bash
git bisect start
git bisect bad                # Aktueller Commit ist kaputt
git bisect good abc123        # Dieser alte Commit war ok
# Git checkt automatisch die Mitte aus
# Du testest, sagst "good" oder "bad"
# Nach ~7 Schritten bei 100 Commits: der schuldige Commit
git bisect reset              # Zurueck zum Ausgangspunkt
```

**Reflog — dein Sicherheitsnetz:**
```bash
git reflog                    # Jede HEAD-Bewegung der letzten 90 Tage
git checkout HEAD@{3}         # Zustand von vor 3 Schritten wiederherstellen
```

Reflog rettet dich nach `git reset --hard`, verlorenen Branches, verpatztem Rebase.

**Worktrees — mehrere Branches gleichzeitig ausgecheckt:**
```bash
git worktree add ../feature-branch feature
# Jetzt existiert ein zweites Verzeichnis mit dem feature Branch
# Kein stash/switch noetig — einfach zwischen Verzeichnissen wechseln
git worktree remove ../feature-branch
```

**Stichworte zum Vertiefen:**
- `git stash` — aendern zwischenparken (`git stash push -m "wip auth"`)
- `git cherry-pick` — einzelne Commits auf anderen Branch uebertragen
- `git blame` — wer hat welche Zeile wann geschrieben?
- `git log --graph --oneline --all` — visueller Branch-Graph
- `git diff --word-diff` — Aenderungen wortweise statt zeilenweise
- `.gitattributes` — Merge-Strategien pro Datei, LF/CRLF Kontrolle
- Git Hooks — pre-commit, pre-push Scripts (z.B. Linting vor Commit)

### Docker / Podman

Container = isolierte Umgebung mit allem was eine App braucht. Podman ist der rootless Docker-Ersatz (kein Daemon, kein Root noetig).

```bash
sudo pacman -S podman         # Installation

podman run -it alpine sh      # Alpine Linux Container starten
podman ps                     # Laufende Container
podman images                 # Lokale Images
podman build -t myapp .       # Image aus Dockerfile bauen
podman rm/rmi                 # Container/Image loeschen
```

**Dockerfile-Grundstruktur:**
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "main.py"]
```

**Stichworte zum Vertiefen:**
- Multi-stage Builds — kleinere Images durch Build/Runtime-Trennung
- Volumes — persistente Daten (`podman run -v ./data:/app/data`)
- Compose — mehrere Container orchestrieren (`podman-compose`)
- Distrobox — Desktop-Apps in Containern ausfuehren (verschiedene Distros auf Arch)
- OCI Images — das Format hinter Docker/Podman

### Eine Sprache richtig lernen

Du hast Neovim mit LSP. Waehle eine Sprache und geh tief rein.

**Python** (wenn du Data/Automation/Backend willst):
- Virtuelle Environments: `python -m venv .venv && source .venv/bin/activate`
- Pyright LSP hast du schon via Mason
- Type Hints + `mypy` — statische Typpruefung
- `pytest` — Testing
- `ruff` — extrem schneller Linter/Formatter

**Go** (wenn du CLI-Tools/Infra/Performance willst):
- Ein Binary, keine Dependencies, cross-compilation
- `gopls` LSP via Mason
- Goroutines — parallele Programmierung eingebaut
- Stdlib reicht fuer HTTP-Server, JSON, Crypto

**Stichworte zum Vertiefen:**
- Design Patterns — die wichtigsten 5-6 reichen (Singleton, Observer, Factory, Strategy, Decorator, Iterator)
- Data Structures — Arrays, Linked Lists, Hash Maps, Trees, Graphs *implementieren*, nicht nur nutzen
- Algorithmen — Sorting, Searching, BFS/DFS, Dynamic Programming Grundlagen
- Big O Notation — Laufzeitkomplexitaet abschaetzen koennen

---

## Phase 4: Security

### CTFs (Capture The Flag)

CTFs sind Hacking-Challenges in sicherer Umgebung. Der beste Weg, Security hands-on zu lernen.

**Einstieg — OverTheWire Bandit:**
```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
# Passwort: bandit0
```

30 Level, jedes bringt dir ein Linux-Konzept bei: Permissions, Pipes, SSH, Encoding, Netzwerk. Wenn du das durchhast, verstehst du Linux deutlich besser.

**Danach:**
- **OverTheWire Natas** — Web Security (SQL Injection, XSS, Path Traversal)
- **OverTheWire Leviathan** — Privilege Escalation, Binary Exploitation Grundlagen
- **PicoCTF** — Beginner-freundlich, breite Themen
- **HackTheBox** — realistische Maschinen (kostenlos im Free Tier)
- **TryHackMe** — gefuehrt mit Erklaerungen (gut zum Lernen, weniger zum Knobeln)

### Netzwerk-Security

**Tools die du kennen solltest:**
```bash
sudo pacman -S nmap wireshark-qt tcpdump

nmap -sV 192.168.1.0/24       # Netzwerk scannen (Services + Versionen)
nmap -sn 192.168.1.0/24       # Ping Sweep (wer ist online?)
sudo tcpdump -i any port 80   # HTTP-Traffic mitlesen
wireshark                     # Grafischer Paket-Analyzer
```

**Stichworte zum Vertiefen:**
- ARP, DHCP, DNS — wie Geraete sich im Netz finden
- TLS/SSL — Zertifikate, Certificate Chains, HSTS
- VPN — WireGuard einrichten und verstehen
- SSH Tunneling — `ssh -L` (local), `ssh -R` (remote), `ssh -D` (SOCKS Proxy)
- Port Knocking — Ports verstecken bis eine Klopfsequenz kommt

### Crypto Basics

Du hast FIDO2/YubiKey schon im Setup. Versteh jetzt *warum* es funktioniert.

**Asymmetrische Kryptografie:**
```
Private Key (geheim)  ←→  Public Key (oeffentlich)
- Private Key signiert → Public Key verifiziert
- Public Key verschluesselt → Private Key entschluesselt
- SSH, GPG, TLS, FIDO2 — alles basiert darauf
```

**GPG im Alltag:**
```bash
gpg --full-gen-key            # Schluesselpaar generieren
gpg --list-keys               # Oeffentliche Schluessel
gpg -e -r user@mail.com file  # Datei verschluesseln
gpg -d file.gpg               # Datei entschluesseln
gpg --sign file               # Datei signieren
git config --global commit.gpgsign true  # Git-Commits signieren
```

**Stichworte zum Vertiefen:**
- Hashing — SHA-256, Argon2, bcrypt (Passwoerter niemals im Klartext!)
- Symmetric vs Asymmetric — AES vs RSA/Ed25519 (wann was?)
- TOTP — wie 2FA-Codes funktionieren (HMAC + Zeitstempel)
- FIDO2/WebAuthn — Challenge-Response, warum Phishing-resistent
- `age` — moderne, einfache Dateiverschluesselung (Alternative zu GPG)
- Pass (`pass`) — Passwort-Manager auf GPG-Basis, git-kompatibel

### Web Security (OWASP Top 10)

Wenn du Web-Apps baust, musst du wissen wie man sie angreift — um sie zu schuetzen.

**Die wichtigsten Angriffsvektoren:**
```
SQL Injection     →  ' OR 1=1 --
XSS               →  <script>alert(1)</script>
CSRF              →  Fremde Seite loest Aktion auf deiner Seite aus
Path Traversal    →  ../../etc/passwd
IDOR              →  /api/user/123 → /api/user/124 (fremde Daten)
SSRF              →  Server dazu bringen, interne URLs abzurufen
```

**Stichworte zum Vertiefen:**
- Burp Suite Community — HTTP-Proxy zum Manipulieren von Requests
- OWASP Juice Shop — absichtlich unsichere Web-App zum Ueben
- `curl` + `jq` — APIs manuell testen und debuggen
- Content Security Policy (CSP) — XSS-Schutz im Browser
- CORS — Cross-Origin Requests verstehen

---

## Ehrliche Einordnung: Brauche ich das alles noch?

Berechtigte Frage. Dieses Dotfiles-Setup ist ein gutes Beispiel: CLAUDE.md, install.sh, die Plugin-Configs, dieser Guide — das meiste davon hat Claude Code geschrieben oder mitgeschrieben. Und die Tools werden besser, nicht schlechter. Also warum nicht einfach warten und in zwei Jahren alles von der AI machen lassen?

### Was AI schon heute ersetzt

Seien wir ehrlich ueber das, was sich schon veraendert hat:

**Boilerplate und Config schreiben** — erledigt. Kein Mensch muss sich Webpack-Configs, Dockerfiles, CI-Pipelines oder systemd-Units aus dem Kopf schreiben. Du beschreibst was du willst, Claude schreibt es, du pruefst ob es stimmt. Das ist schneller und oft besser als es selbst zu tippen.

**Syntax und API-Details** — irrelevant geworden. Frueher musstest du wissen ob es `os.path.join()` oder `pathlib.Path()` ist, wie `awk` Felder trennt, welche Flags `tar` braucht. Heute fragst du einfach. Die Tage in denen "ich kenne die Flags von rsync auswendig" ein Skill war, sind vorbei.

**Debugging** — massiv beschleunigt. Fehlermeldung reinkopieren, Kontext geben, Loesung bekommen. Fuer 80% der Bugs funktioniert das schneller als selbst zu debuggen.

**Neue Sprachen/Frameworks lernen** — der Einstieg ist trivial geworden. Du kannst produktiv in einer Sprache arbeiten die du noch nie benutzt hast, weil die AI die Syntax, Patterns und Idiome kennt.

### Was AI (noch) nicht kann

**Entscheiden was gebaut werden soll.** AI kann dir 5 Architekturen vorschlagen. Aber welche fuer *dein* Problem die richtige ist — mit deinem Team, deiner Infrastruktur, deinem Budget — das ist eine menschliche Entscheidung. Und du kannst diese Entscheidung nur treffen, wenn du die Optionen verstehst.

**Wissen wann die AI falsch liegt.** Das ist der kritische Punkt. Claude schreibt dir ein Shell-Script das funktioniert — bis es auf einem Dateinamen mit Leerzeichen crasht. Oder eine SQL-Query die korrekt aussieht — aber bei 10 Millionen Rows die Datenbank toetet. Oder einen Kubernetes-Deployment-Yaml der den Service exposed — ohne Auth. Wenn du die Grundlagen nicht verstehst, merkst du es nicht. Und "es funktioniert auf meinem Rechner" ist kein Qualitaetsbeweis.

**Systeme debuggen, nicht Code.** Wenn dein Hyprland nicht startet, dein Netzwerk haengt, dein Container keine DNS-Aufloesung hat, oder dein Laptop nach Suspend nicht aufwacht — dann ist das kein Code-Problem das du in einen Prompt packen kannst. Das ist ein System-Problem. Du brauchst `journalctl`, `strace`, `ip`, `dmesg`, und du brauchst ein mentales Modell davon, wie die Teile zusammenspielen.

**Unter Druck arbeiten.** Produktion ist down, der Server antwortet nicht, du hast SSH-Zugang aber kein Internet auf der Maschine. Kein Claude, kein Google, kein StackOverflow. Nur du, ein Terminal, und was du im Kopf hast. Das passiert selten — aber wenn, dann zaehlt es.

### Das Dotfiles-Paradox

Ja, Claude hat den Grossteil dieses Setups geschrieben. Aber schau was dabei passiert ist:

1. Du hast *entschieden* was du willst: Hyprland statt KDE, plain zsh statt oh-my-zsh, vanilla-first Philosophie
2. Du hast *verstanden* was die Configs tun — sonst haettest du nicht nachgefragt warum netrw statt nvim-tree
3. Du hast *gemerkt* wann die Doku veraltet war — weil du die tatsaechliche Config kennst
4. Du hast *getestet* ob alles funktioniert — auf deinem spezifischen System

Claude war das Werkzeug. Du warst der Entscheider, Tester und Qualitaetskontrolle. Das funktioniert — aber nur weil du genug verstehst um diese Rolle auszufuellen.

### Was sich aendert wenn AI besser wird

Die Schwelle fuer "genug verstehen" sinkt. Heute brauchst du solides Linux-Wissen um Claude's Output zu pruefen. In zwei Jahren brauchst du vielleicht weniger Detail-Wissen, weil die AI weniger Fehler macht und besser erklaert was sie tut.

Aber "weniger" ist nicht "null". Die Grundlagen bleiben relevant, weil:

**Die Abstraktionsebene steigt, aber der Stack bleibt.** Frueher hast du Assembler geschrieben. Dann C. Dann Python. Jetzt Prompts. Aber wenn Python langsam ist, musst du wissen dass es daran liegt dass es interpretiert wird. Wenn dein Container nicht funktioniert, musst du wissen was Namespaces sind. Die AI hebt dich auf eine hoehere Ebene — aber die darunter verschwinden nicht.

**Du wirst zum Architekten, nicht zum Zuschauer.** Die Skills verschieben sich:
```
Weniger wichtig:          Wichtiger:
- Syntax auswendig        - Systemverstaendnis
- Boilerplate tippen      - Architektur-Entscheidungen
- API-Docs lesen          - Code Review (auch AI-Code!)
- Config-Dateien          - Wissen was moeglich ist
  von Null schreiben      - Erkennen wenn etwas falsch ist
```

**Security wird wichtiger, nicht weniger.** Wenn jeder mit AI Code schreiben kann, schreiben auch mehr Leute unsicheren Code. Wenn du verstehst wie SQL Injection, XSS oder Privilege Escalation funktioniert, bist du wertvoller als jemand der nur "mach mir eine Web-App" prompten kann.

### Also: Lohnt sich das alles?

Kommt drauf an was dein Ziel ist.

**Wenn du Software professionell bauen willst** — ja, unbedingt. Nicht weil du alles auswendig koennen musst, sondern weil du verstehen musst was du baust. AI ist ein Verstaerker: sie macht gute Entwickler besser und schlechte Entwickler gefaehrlicher.

**Wenn du Ops/Infra/Security machen willst** — ja, und zwar die Linux- und Netzwerk-Sektionen besonders. Das sind die Bereiche wo AI am schwaechsten ist, weil jedes System anders ist und Kontext alles bestimmt.

**Wenn du einfach effektiv arbeiten willst** — lerne das Minimum das du brauchst um AI-Output zu bewerten, und nutze die AI fuer den Rest. Vim-Motions lohnen sich trotzdem, weil du damit *ueberall* schneller bist — in Claude Code, in SSH-Sessions, in git commit Messages.

**Wenn es dir Spass macht** — das ist Grund genug. Nicht alles muss ROI-optimiert sein. Zu verstehen wie dein Rechner funktioniert hat einen Eigenwert. Wie ein Auto selbst reparieren koennen — du musst nicht, aber wenn du es kannst, hat das Ding eine andere Bedeutung.

### Die pragmatische Antwort

Lerne die Grundlagen aus Phase 1 und 2 dieses Guides. Nicht weil AI sie nicht kann, sondern weil sie dich in die Lage versetzen, AI *gut* zu nutzen. Ueberspring das Auswendiglernen von Flags und Syntax — dafuer hast du Claude. Aber verstehe *was* Prozesse, Permissions, Netzwerk und Dateisysteme sind. Das ist die Schicht die bleibt, egal wie gut die Tools werden.

Und ja — in zwei Jahren wird vieles davon einfacher sein. Aber die Leute die dann am meisten davon profitieren, sind die, die heute die Grundlagen verstehen.

---

## Reihenfolge

```
Monat 1-2:   Vim-Motions + Shell-Scripting (beschleunigt alles andere)
Monat 3:     OverTheWire Bandit + Linux-Internals (systemd, Prozesse)
Monat 4-5:   Git fortgeschritten + Docker/Podman
Monat 6:     Eine Sprache vertiefen (Projekt bauen!)
Monat 7+:    Security vertiefen (CTFs, Web Security, Netzwerk)
```

Die Reihenfolge ist wichtig: Jede Phase baut auf der vorherigen auf. Vim-Motions und Shell-Scripting machen dich in allem anderen schneller.

---

## Ressourcen

**Buecher:**
- "The Linux Command Line" von William Shotts (kostenlos online)
- "How Linux Works" von Brian Ward
- "The Art of Command Line" (GitHub Repo)

**Websites:**
- Arch Wiki — https://wiki.archlinux.org (die beste Linux-Doku)
- OverTheWire — https://overthewire.org/wargames
- Explain Shell — https://explainshell.com (Befehle erklaert)
- Linux From Scratch — https://linuxfromscratch.org (baue dein eigenes Linux)

**YouTube-Kanaele:**
- ThePrimeagen — Vim, Produktivitaet, Memes
- NetworkChuck — Netzwerk, Linux, Security (beginner-freundlich)
- John Hammond — CTFs, Malware-Analyse
- LiveOverflow — Binary Exploitation, tiefe technische Dives
