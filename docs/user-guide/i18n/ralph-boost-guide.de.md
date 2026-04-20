# Ralph Boost Benutzerhandbuch

> In 5 Minuten starten — verhindern Sie, dass Ihre autonome KI-Entwicklungsschleife ins Stocken gerät

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserai/forge
```

### Universelle Einzeiler-Installation

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **Keine Abhängigkeiten** — Ralph Boost ist unabhängig von ralph-claude-code, block-break oder externen Diensten. Der primäre Pfad (Agent-Schleife) hat keine externen Abhängigkeiten; der Fallback-Pfad erfordert `jq` oder `python` und die `claude` CLI.

---

## Befehle

| Befehl | Funktion | Verwendung |
|--------|----------|------------|
| `/ralph-boost setup` | Autonome Schleife in Ihrem Projekt initialisieren | Ersteinrichtung |
| `/ralph-boost run` | Autonome Schleife in der aktuellen Sitzung starten | Nach der Initialisierung |
| `/ralph-boost status` | Aktuellen Schleifenstatus anzeigen | Fortschritt überwachen |
| `/ralph-boost clean` | Schleifendateien entfernen | Bereinigung |

---

## Schnellstart

### 1. Projekt initialisieren

```text
/ralph-boost setup
```

Claude führt Sie durch:
- Erkennung des Projektnamens
- Generierung einer Aufgabenliste (fix_plan.md)
- Erstellung des `.ralph-boost/`-Verzeichnisses und aller Konfigurationsdateien

### 2. Schleife starten

```text
/ralph-boost run
```

Claude steuert die autonome Schleife direkt in der aktuellen Sitzung (Agent-Schleifenmodus). Jede Iteration erzeugt einen Sub-Agent zur Aufgabenausführung, während die Hauptsitzung als Schleifencontroller den Zustand verwaltet.

**Fallback** (kopflose / unbeaufsichtigte Umgebungen):

```bash
# Vordergrund
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Hintergrund
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Status überwachen

```text
/ralph-boost status
```

Beispielausgabe:

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## Funktionsweise

### Autonome Schleife

Ralph Boost bietet zwei Ausführungspfade:

**Primärer Pfad (Agent-Schleife)**: Claude agiert als Schleifencontroller in der aktuellen Sitzung und erzeugt bei jeder Iteration einen Sub-Agent zur Aufgabenausführung. Die Hauptsitzung verwaltet den Zustand, den Circuit Breaker und die Druckeskalation. Keine externen Abhängigkeiten.

**Fallback (Bash-Skript)**: `boost-loop.sh` führt `claude -p`-Aufrufe in einer Schleife im Hintergrund aus. Unterstützt sowohl jq als auch python als JSON-Engine, automatisch erkannt zur Laufzeit. Standardmäßige Wartezeit zwischen Iterationen: 1 Stunde (konfigurierbar).

Beide Pfade teilen sich die gleiche Zustandsverwaltung (state.json), Druckeskalationslogik und das BOOST_STATUS-Protokoll.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Erweiterter Circuit Breaker (vs ralph-claude-code)

Circuit Breaker von ralph-claude-code: Gibt nach 3 aufeinanderfolgenden Schleifen ohne Fortschritt auf.

Circuit Breaker von ralph-boost: **Eskaliert den Druck progressiv** bei Blockaden, bis zu 6-7 Schleifen Selbstwiederherstellung vor dem Stopp.

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## Erwartete Ausgabebeispiele

### L0 — Normale Ausführung

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — Ansatzwechsel

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude wird gezwungen, den vorherigen Ansatz aufzugeben und etwas **grundlegend Anderes** zu versuchen. Parameteranpassungen zählen nicht.

### L2 — Suchen und Hypothesen aufstellen

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude muss: den Fehler Wort für Wort lesen → 50+ Zeilen Kontext durchsuchen → 3 verschiedene Hypothesen auflisten.

### L3 — Checkliste

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude muss die 7-Punkte-Checkliste abarbeiten (Fehlersignale lesen, Kernproblem suchen, Quellcode lesen, Annahmen verifizieren, Gegenhypothese aufstellen, minimale Reproduktion, Werkzeuge/Methoden wechseln). Jeder abgeschlossene Punkt wird in state.json geschrieben.

### L4 — Geordnete Übergabe

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude erstellt einen minimalen PoC und generiert dann einen Übergabebericht:

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

Nach Abschluss der Übergabe fährt die Schleife geordnet herunter. Das ist kein „Ich kann nicht" — sondern „Hier ist die Grenze."

---

## Konfiguration

`.ralph-boost/config.json`:

| Feld | Standard | Beschreibung |
|------|----------|--------------|
| `max_calls_per_hour` | 100 | Maximale Claude API-Aufrufe pro Stunde |
| `claude_timeout_minutes` | 15 | Timeout pro einzelnem Aufruf |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Für Claude verfügbare Werkzeuge |
| `claude_model` | "" | Modellüberschreibung (leer = Standard) |
| `session_expiry_hours` | 24 | Sitzungsablaufzeit |
| `no_progress_threshold` | 7 | Schwellenwert ohne Fortschritt vor dem Herunterfahren |
| `same_error_threshold` | 8 | Schwellenwert gleicher Fehler vor dem Herunterfahren |
| `sleep_seconds` | 3600 | Wartezeit zwischen Iterationen (Sekunden) |

### Häufige Konfigurationsanpassungen

**Schleife beschleunigen** (zum Testen):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Werkzeugberechtigungen einschränken**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Ein bestimmtes Modell verwenden**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Projektverzeichnisstruktur

```
.ralph-boost/
├── PROMPT.md           # Entwickleranweisungen (enthält block-break Protokoll)
├── fix_plan.md         # Aufgabenliste (automatisch von Claude aktualisiert)
├── config.json         # Konfiguration
├── state.json          # Vereinheitlichter Zustand (Circuit Breaker + Druck + Sitzung)
├── handoff-report.md   # L4 Übergabebericht (bei geordnetem Beenden generiert)
├── logs/
│   ├── boost.log       # Schleifenprotokoll
│   └── claude_output_*.log  # Ausgabe pro Iteration
└── .gitignore          # Ignoriert Zustand und Protokolle
```

Alle Dateien bleiben innerhalb von `.ralph-boost/` — Ihr Projektstammverzeichnis wird nicht berührt.

---

## Beziehung zu ralph-claude-code

Ralph Boost ist ein **unabhängiger Ersatz** für [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), kein Erweiterungsplugin.

| Aspekt | ralph-claude-code | ralph-boost |
|--------|-------------------|-------------|
| Form | Eigenständiges Bash-Werkzeug | Claude Code Skill (Agent-Schleife) |
| Installation | `npm install` | Claude Code Plugin |
| Codegröße | 2000+ Zeilen | ~400 Zeilen |
| Externe Abhängigkeiten | jq (erforderlich) | Primärer Pfad: keine; Fallback: jq oder python |
| Verzeichnis | `.ralph/` | `.ralph-boost/` |
| Circuit Breaker | Passiv (gibt nach 3 Schleifen auf) | Aktiv (L0-L4, 6-7 Schleifen Selbstwiederherstellung) |
| Koexistenz | Ja | Ja (keine Dateikonflikte) |

Beide können gleichzeitig im selben Projekt installiert werden — sie verwenden separate Verzeichnisse und stören sich nicht gegenseitig.

---

## Beziehung zu Block Break

Ralph Boost adaptiert die Kernmechanismen von Block Break (Druckeskalation, 5-Schritte-Methodik, Checkliste) für autonome Schleifenszenarien:

| Aspekt | block-break | ralph-boost |
|--------|-------------|-------------|
| Szenario | Interaktive Sitzungen | Autonome Schleifen |
| Aktivierung | Hooks lösen automatisch aus | In Agent-Schleife / Schleifenskript integriert |
| Erkennung | PostToolUse Hook | Agent-Schleife Fortschrittserkennung / Skript-Fortschrittserkennung |
| Steuerung | Hook-injizierte Prompts | Agent-Prompt-Injektion / --append-system-prompt |
| Zustand | `~/.forge/` | `.ralph-boost/state.json` |

Der Code ist vollständig unabhängig; die Konzepte sind geteilt.

> **Referenz**: Die Druckeskalation (L0-L4), 5-Schritte-Methodik und 7-Punkte-Checkliste von Block Break bilden die konzeptionelle Grundlage des Circuit Breakers von ralph-boost. Siehe das [Block Break Benutzerhandbuch](block-break-guide.md) für Details.

---

## FAQ

### Wie wähle ich zwischen dem primären Pfad und dem Fallback?

`/ralph-boost run` verwendet standardmäßig die Agent-Schleife (primärer Pfad) und läuft direkt in der aktuellen Claude Code Sitzung. Verwenden Sie das Fallback-Bash-Skript, wenn Sie kopflose oder unbeaufsichtigte Ausführung benötigen.

### Wo befindet sich das Schleifenskript?

Nach der Installation des forge Plugins befindet sich das Fallback-Skript unter `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`. Sie können es auch an einen beliebigen Ort kopieren und von dort ausführen. Das Skript erkennt automatisch jq oder python als JSON-Engine.

### Wie kann ich die Schleifenprotokolle anzeigen?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Wie setze ich die Druckstufe manuell zurück?

Bearbeiten Sie `.ralph-boost/state.json`: Setzen Sie `pressure.level` auf 0 und `circuit_breaker.consecutive_no_progress` auf 0. Oder löschen Sie einfach state.json und initialisieren Sie neu.

### Wie ändere ich die Aufgabenliste?

Bearbeiten Sie `.ralph-boost/fix_plan.md` direkt im Format `- [ ] Aufgabe`. Claude liest sie zu Beginn jeder Iteration.

### Wie kann ich nach dem Öffnen des Circuit Breakers wiederherstellen?

Bearbeiten Sie `state.json`, setzen Sie `circuit_breaker.state` auf `"CLOSED"`, setzen Sie die relevanten Zähler zurück und starten Sie das Skript erneut.

### Brauche ich ralph-claude-code?

Nein. Ralph Boost ist vollständig unabhängig und hängt nicht von Ralph-Dateien ab.

### Welche Plattformen werden unterstützt?

Derzeit wird Claude Code (Agent-Schleife als primärer Pfad) unterstützt. Das Fallback-Bash-Skript erfordert bash 4+, jq oder python und die claude CLI.

### Wie validiere ich die Skill-Dateien von ralph-boost?

Verwenden Sie [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Wann verwenden / Wann NICHT verwenden

### ✅ Verwenden wenn

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ Nicht verwenden wenn

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> Autonome Schleifen-Engine mit Konvergenzgarantie — braucht klare Ziele und stabile Umgebung.

Vollständige Grenzanalyse: [references/scope-boundaries.md](../../../skills/ralph-boost/references/scope-boundaries.md)

---

## Lizenz

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
