# Forge

> Härter arbeiten, dann Pause machen. 7 Skills für einen besseren Entwicklungsrhythmus mit Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-7-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

### Kurzdemo

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## Installation

```bash
# Claude Code (ein Befehl)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Hammer

| Skill | Was er macht | Ausprobieren |
|-------|-------------|--------------|
| **block-break** | Erzwingt erschöpfende Problemlösung, bevor aufgegeben wird | `/block-break` |
| **ralph-boost** | Autonome Entwicklungsschleifen mit Konvergenzgarantie | `/ralph-boost setup` |

### Crucible

| Skill | Was er macht | Ausprobieren |
|-------|-------------|--------------|
| **council-fuse** | Multi-Perspektiven-Beratung für bessere Antworten | `/council-fuse <question>` |
| **insight-fuse** | Systematische Multi-Quellen-Recherche mit professionellen Berichten | `/insight-fuse <topic>` |
| **tome-forge** | Persönliche Wissensbasis mit LLM-kompiliertem Wiki | `/tome-forge init` |

### Anvil

| Skill | Was er macht | Ausprobieren |
|-------|-------------|--------------|
| **skill-lint** | Validiert jedes Claude Code Skill-Plugin | `/skill-lint .` |

### Quench

| Skill | Was er macht | Ausprobieren |
|-------|-------------|--------------|
| **news-fetch** | Kurze Nachrichten zwischen den Entwicklungssitzungen | `/news-fetch AI today` |

---

## Block Break — Verhaltenssteuerungs-Engine

Ihre KI hat aufgegeben? `/block-break` zwingt sie, zuerst alle Ansätze auszuschöpfen.

Wenn Claude feststeckt, aktiviert Block Break ein Druckeskalationssystem, das vorzeitiges Aufgeben verhindert. Es zwingt den Agenten durch zunehmend rigorose Problemlösungsstufen, bevor eine Antwort wie "Das kann ich nicht" erlaubt wird.

| Mechanismus | Beschreibung |
|-------------|-------------|
| **3 Red Lines** | Geschlossene Verifikation / Faktenbasiert / Alle Optionen ausschöpfen |
| **Druckeskalation** | L0 Vertrauen → L1 Enttäuschung → L2 Befragung → L3 Leistungsbeurteilung → L4 Abschluss |
| **5-Schritte-Methode** | Wittern → Haare raufen → Spiegeln → Neuer Ansatz → Retrospektive |
| **7-Punkte-Checkliste** | Obligatorische Diagnose-Checkliste ab L3 |
| **Anti-Rationalisierung** | Erkennt und blockiert 14 gängige Ausredemuster |
| **Hooks** | Automatische Frustrationserkennung + Fehlerzählung + Zustandspersistenz |

```text
/block-break              # Block Break-Modus aktivieren
/block-break L2           # Auf einer bestimmten Druckstufe starten
/block-break fix the bug  # Aktivieren und sofort eine Aufgabe starten
```

Wird auch durch natürliche Sprache ausgelöst: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, usw. (automatisch durch Hooks erkannt).

> Inspiriert von [PUA](https://github.com/tanweai/pua), destilliert zu einem Skill ohne Abhängigkeiten.

## Ralph Boost — Autonome Entwicklungsschleifen-Engine

Autonome Entwicklungsschleifen, die tatsächlich konvergieren. Einrichtung in 30 Sekunden.

Repliziert die autonome Schleifenfähigkeit von ralph-claude-code als Skill, mit integrierter Block Break L0-L4 Druckeskalation zur Konvergenzgarantie. Löst das Problem des "Kreisens ohne Fortschritt" in autonomen Schleifen.

| Funktion | Beschreibung |
|----------|-------------|
| **Dual-Path-Schleife** | Agent-Schleife (primär, null externe Abhängigkeiten) + Bash-Script-Fallback (jq/python-Engines) |
| **Verbesserter Schutzschalter** | L0-L4 Druckeskalation integriert: von "nach 3 Runden aufgeben" zu "6-7 Runden progressiver Selbstrettung" |
| **Zustandsverfolgung** | Einheitliche state.json für Schutzschalter + Druck + Strategie + Sitzung |
| **Sanfte Übergabe** | L4 erstellt einen strukturierten Übergabebericht statt eines rohen Absturzes |
| **Unabhängig** | Verwendet das Verzeichnis `.ralph-boost/`, keine Abhängigkeit von ralph-claude-code |

```text
/ralph-boost setup        # Projekt initialisieren
/ralph-boost run          # Autonome Schleife starten
/ralph-boost status       # Aktuellen Zustand prüfen
/ralph-boost clean        # Aufräumen
```

> Inspiriert von [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), neu konzipiert als Skill ohne Abhängigkeiten mit Konvergenzgarantie.

## Skill Lint — Skill-Plugin-Validator

Validieren Sie Ihre Claude Code Plugins mit einem einzigen Befehl.

Prüft die strukturelle Integrität und semantische Qualität von Skill-Dateien in jedem Claude Code Plugin-Projekt. Bash-Skripte übernehmen strukturelle Prüfungen, die KI übernimmt semantische Prüfungen — komplementäre Abdeckung.

| Prüfungstyp | Beschreibung |
|-------------|-------------|
| **Strukturell** | Erforderliche Frontmatter-Felder / Dateiexistenz / Referenzlinks / Marketplace-Einträge |
| **Semantisch** | Beschreibungsqualität / Namenskonsistenz / Befehlsrouting / Evaluierungsabdeckung |

```text
/skill-lint              # Verwendung anzeigen
/skill-lint .            # Aktuelles Projekt validieren
/skill-lint /path/to/plugin  # Einen bestimmten Pfad validieren
```

## News Fetch — Ihre mentale Pause zwischen den Sprints

Ausgebrannt vom Debuggen? `/news-fetch` — Ihre 2-minütige mentale Pause.

Die anderen Skills treiben Sie zu härterem Arbeiten an. Dieser erinnert Sie daran, durchzuatmen. Holen Sie sich die neuesten Nachrichten zu jedem Thema, direkt aus Ihrem Terminal — kein Kontextwechsel, kein Abschweifen im Browser. Nur ein kurzer Überblick und zurück an die Arbeit, erfrischt.

| Funktion | Beschreibung |
|----------|-------------|
| **3-stufiger Fallback** | L1 WebSearch → L2 WebFetch (regionale Quellen) → L3 curl |
| **Deduplizierung und Zusammenführung** | Dasselbe Ereignis aus mehreren Quellen wird automatisch zusammengeführt, der höchste Score wird beibehalten |
| **Relevanzbewertung** | KI bewertet und sortiert nach Themenübereinstimmung |
| **Automatische Zusammenfassung** | Fehlende Abstracts werden automatisch aus dem Artikeltext generiert |

```text
/news-fetch AI                    # KI-Nachrichten der Woche
/news-fetch AI today              # KI-Nachrichten von heute
/news-fetch robotics month        # Robotik-Nachrichten des Monats
/news-fetch climate 2026-03-01~2026-03-31  # Benutzerdefinierter Zeitraum
```

## Council Fuse — Multi-Perspektiven-Beratungs-Engine

Bessere Antworten durch strukturierte Debatte. `/council-fuse` erzeugt 3 unabhängige Perspektiven, bewertet sie anonym und synthetisiert die beste Antwort.

Inspiriert von [Karpathys LLM Council](https://github.com/karpathy/llm-council) — destilliert in einen einzigen Befehl.

| Mechanismus | Beschreibung |
|-------------|-------------|
| **3 Perspektiven** | Generalist (ausgewogen) / Kritiker (adversarial) / Spezialist (technisch tiefgehend) |
| **Anonyme Bewertung** | 4-Dimensionen-Evaluation: Korrektheit, Vollständigkeit, Praxistauglichkeit, Klarheit |
| **Synthese** | Höchstbewertete Antwort als Gerüst, angereichert mit einzigartigen Erkenntnissen |
| **Minderheitsmeinung** | Gültige abweichende Ansichten werden bewahrt, nicht unterdrückt |

```text
/council-fuse Sollten wir Microservices verwenden?
/council-fuse Überprüfe dieses Error-Handling-Muster
/council-fuse Redis vs PostgreSQL für Job-Queues
```

## Insight Fuse — Multi-Quellen-Recherche-Engine

Vom Thema zum professionellen Recherchebericht. `/insight-fuse` führt eine 5-stufige progressive Pipeline aus: Scan → Ausrichtung → Recherche → Review → Deep Dive.

Eingebaute Multi-Perspektiven-Analyse (Generalist/Kritiker/Spezialist), erweiterbare Berichtsvorlagen und konfigurierbare Tiefe. Das Fuse-Geschwister zu council-fuse — während council-fuse über bekannte Informationen deliberiert, sammelt und synthetisiert insight-fuse aktiv neue Informationen.

| Mechanismus | Beschreibung |
|-------------|-------------|
| **5-Stufen-Pipeline** | Scan → Ausrichtung → Recherche → Review → Deep Dive |
| **Konfigurierbare Tiefe** | quick (nur Scan) / standard (Auto-Recherche) / deep (+ Multi-Perspektiven) / full (+ manuelle Checkpoints) |
| **3 Perspektiven** | Generalist (Breite) / Kritiker (Verifizierung) / Spezialist (Präzision) |
| **Berichtsvorlagen** | technology / market / competitive / custom — oder automatisch generiert |
| **Qualitätsstandards** | Multi-Quellen-Pflicht, Zitierungsintegrität, Quellenvielfalt-Prüfungen |

```text
/insight-fuse AI Agent Sicherheitsrisiken
/insight-fuse --depth quick --template technology WebAssembly
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist Quantencomputing-Kommerzialisierung
```

## Tome Forge — Persönliche Wissensbasis-Engine

Aufbau einer persönlichen Wissensbasis, die ein LLM kompiliert und pflegt. Basierend auf [Karpathys LLM Wiki-Muster](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — rohes Markdown wird in ein strukturiertes Wiki kompiliert, kein RAG oder Vektor-DB nötig.

| Feature | Beschreibung |
|---------|-------------|
| **Drei-Schichten-Architektur** | Rohquellen (unveränderlich) / Wiki (LLM-kompiliert) / Schema (CLAUDE.md) |
| **6 Operationen** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | Heiliger Bereich für menschliche Erkenntnisse — LLM überschreibt nie |
| **Zero Infra** | Reines Markdown + Git. Keine Datenbanken, Embeddings oder Server |

```text
/tome-forge init              # KB im aktuellen Verzeichnis initialisieren
/tome-forge capture "idea"    # Schnellerfassung einer Notiz
/tome-forge ingest raw/paper  # Rohmaterial ins Wiki kompilieren
/tome-forge query "question"  # Suchen und synthetisieren
/tome-forge lint              # Wiki-Struktur-Gesundheitscheck
/tome-forge compile           # Alle neuen Materialien batch-kompilieren
```

> Inspiriert von [Karpathys LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), gebaut als Zero-Dependency-Skill.

## Qualität

- Über 10 Evaluierungsszenarien pro Skill mit automatisierten Auslösetests
- Selbstvalidiert durch den eigenen skill-lint
- Null externe Abhängigkeiten — null Risiko
- MIT-lizenziert, vollständig Open Source

## Projektstruktur

```text
forge/
├── skills/                        # Claude Code Plattform
│   └── <skill>/
│       ├── SKILL.md               # Skill-Definition
│       ├── references/            # Detaillierter Inhalt (bei Bedarf geladen)
│       ├── scripts/               # Hilfsskripte
│       └── agents/                # Sub-Agent-Definitionen
├── platforms/                     # Anpassungen für andere Plattformen
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw-Anpassung
│           ├── references/        # Plattformspezifischer Inhalt
│           └── scripts/           # Plattformspezifische Skripte
├── .claude-plugin/                # Claude Code Marketplace-Metadaten
├── hooks/                         # Claude Code Plattform-Hooks
├── evals/                         # Plattformübergreifende Evaluierungsszenarien
├── docs/
│   ├── guide/                     # Benutzerhandbücher (Englisch)
│   ├── plans/                     # Designdokumente
│   └── i18n/                      # Übersetzungen (11 languages)
│       ├── README.*.md            # Übersetzte READMEs
│       └── guide/*-guide.*.md     # Übersetzte Handbücher
└── plugin.json                    # Sammlungs-Metadaten
```

## Mitwirken

1. `skills/<name>/SKILL.md` — Claude Code Skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw-Anpassung + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Evaluierungsszenarien
4. `.claude-plugin/marketplace.json` — Eintrag zum `plugins`-Array hinzufügen
5. Hooks bei Bedarf in `hooks/hooks.json`

Siehe [CLAUDE.md](../../CLAUDE.md) für vollständige Entwicklungsrichtlinien.

## Lizenz

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
