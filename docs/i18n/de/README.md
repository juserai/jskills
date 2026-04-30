# Forge

> Härter arbeiten, dann Pause machen. 8 Skills für einen besseren Entwicklungsrhythmus mit Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-8-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../../README.md) | [中文](../zh-CN/README.md) | [日本語](../ja/README.md) | [한국어](../ko/README.md) | [Español](../es/README.md) | [Português](../pt-BR/README.md) | [Français](../fr/README.md) | [Deutsch](README.md) | [Русский](../ru/README.md) | [हिन्दी](../hi/README.md) | [Türkçe](../tr/README.md) | [Tiếng Việt](../vi/README.md)

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

> Jeder Skill unterstützt `/<skill> help` (auch `--help`) zur Anzeige seiner Usage-Karte. Skills mit Pflichtargumenten zeigen die Hilfe zusätzlich bei leerem Aufruf.

### Hammer

| Skill | Was er macht | Ausprobieren |
|-------|-------------|--------------|
| **block-break** | Erzwingt erschöpfende Problemlösung, bevor aufgegeben wird | `/block-break` |
| **ralph-boost** | Autonome Entwicklungsschleifen mit Konvergenzgarantie | `/ralph-boost setup` |
| **claim-ground** | Verankert jede "aktueller Moment"-Aussage an Laufzeitbelegen | Auto-Auslösung |

### Crucible

| Skill | Was er macht | Ausprobieren |
|-------|-------------|--------------|
| **council-fuse** | Multi-Perspektiven-Beratung für bessere Antworten | `/council-fuse <question>` |
| **insight-fuse** | 7-Stufen-Recherche-Engine mit skeleton.yaml-Datenvertrag & 6-dim Qualitätsrubrik | `/insight-fuse <topic>` |
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

## Claim Ground — Epistemische Beschränkungs-Engine

Stoppen Sie die Halluzinationen veralteter Fakten. `claim-ground` verankert jede "aktueller Moment"-Aussage an Laufzeitbelegen.

Auto-ausgelöst (kein Slash-Befehl). Wenn Claude gerade faktische Fragen zum aktuellen Zustand beantwortet — laufendes Modell, installierte Tools, Env-Vars, Konfigurationswerte — oder wenn der Nutzer eine vorherige Aussage anfechtet, erzwingt Claim Ground das Zitieren des System-Prompts / Tool-Ausgabe / Dateiinhalts *vor* dem Schlussfolgern. Bei Widerspruch verifiziert Claude erneut, anstatt umzuformulieren.

| Mechanismus | Beschreibung |
|-------------|--------------|
| **3 Rote Linien** | Keine unbelegten Aussagen / Beispiele nicht als vollständig / Kein Umformulieren bei Widerspruch |
| **Runtime > Training** | System-Prompt, Env und Tool-Ausgabe schlagen immer Trainingsgedächtnis |
| **Zitieren-dann-schließen** | Rohes Beweisfragment inline zitiert vor jeder Schlussfolgerung |
| **Verifikations-Playbook** | Fragetyp → Beweisquelle (Modell / CLI / Pakete / Env / Dateien / Git / Datum) |

Auslösebeispiele (auto-erkannt durch Beschreibung):

- "Welches Modell läuft?" / "What model is running?"
- "Welche Version von X ist installiert?"
- "Wirklich? / Sicher? / Ich dachte es sei aktualisiert"

Funktioniert orthogonal zu block-break: Bei beidseitiger Aktivierung verhindert block-break "Ich gebe auf", claim-ground verhindert "Ich habe nur meine falsche Antwort umformuliert".

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

## Insight Fuse — Systematische Multi-Quellen-Recherche-Engine (v3)

Vom Thema zum professionellen Recherchebericht. `/insight-fuse` führt eine 7-stufige Pipeline mit `skeleton.yaml` als Datenvertrag aus: Brainstorm → Scan → Align → Research → Review → Deep Dive → QA.

Eingebaute Multi-Perspektiven-Analyse, 6 Recherche-Typ-Presets (overview / technology / market / academic / product / competitive), 5 Ausgabeformate (report / checklist / ADR / decision-tree / PoC) und eine 6-dimensionale Qualitätsrubrik mit 14 blockierenden Prüfungen. Das Fuse-Geschwister zu council-fuse — während council-fuse über bekannte Informationen deliberiert, sammelt und synthetisiert insight-fuse aktiv neue Informationen.

| Mechanismus | Beschreibung |
|-------------|--------------|
| **7-Stufen-Pipeline** | Brainstorm (Skelett) → Scan → Align → Research → Review → Deep Dive → QA |
| **Recherche-Typen** | overview / technology / market / academic / product / competitive — Preset-Bundle (Template + Perspektiven + spezifische Checks) |
| **Konfigurierbare Tiefe** | quick / standard / deep / full — quick überspringt Stage 2-5; full durchläuft alle 7 Stages mit interaktiven Gates |
| **Skeleton.yaml** | 7-Feld-Datenvertrag (dimensions / taxonomies / out_of_scope / existing_consensus / known_dissensus / hypotheses / business_neutral) wird von jeder Stage konsumiert |
| **Qualitätsrubrik** | 6-dim Bewertung (Falsifizierbarkeit / Beweisdichte / Reproduzierbarkeit / Quellenvielfalt / Handlungsfähigkeit / Transparenz) + 14 blockierende Checks + A/B/C/D-Note |
| **Multi-Section** | report / checklist / ADR / decision-tree / PoC — `--sections` wählt Abschnitte aus; standardmäßig wird jeder als eigene `.md`-Datei gerendert, `--merge` bündelt sie in eine Datei |

```text
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling" --type technology --sections report,adr,poc
/insight-fuse "Kubernetes autoscaling" --type technology --sections report,adr,poc --merge
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI Native landscape" --type overview --depth full --audience "new entrants"
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
│       ├── agents/                # Sub-Agent-Definitionen
│       └── hooks/                 # Per-Skill Claude Code Hooks (nur für Hook-Owner-Skills)
├── platforms/                     # Anpassungen für andere Plattformen
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw-Anpassung
│           ├── references/        # Plattformspezifischer Inhalt
│           └── scripts/           # Plattformspezifische Skripte
├── .claude-plugin/                # Claude Code Marketplace-Metadaten
├── evals/                         # Plattformübergreifende Evaluierungsszenarien
├── docs/
│   ├── user-guide/                # Benutzerhandbücher (Englisch)
│   ├── dev-guide/                 # Entwicklerdokumentation
│   ├── design/<category>/         # Designdokumente nach 4 Kategorien
│   └── i18n/<lang>/               # Übersetzungen (README + Skill-Handbuch)
├── openspec/                      # Evolutions-Meta-Repository
│   ├── specs/<capability>/        # Horizontale Capability-Verträge
│   └── changes/<id>/              # Aktive RFCs (archive/ für abgeschlossene)
└── plugin.json                    # Sammlungs-Metadaten
```

## Mitwirken

1. `skills/<name>/SKILL.md` — Claude Code Skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw-Anpassung + references/scripts (siehe [platform-parity](../../../openspec/specs/platform-parity/spec.md) für den Broadcast-Vertrag)
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Evaluierungsszenarien
4. `.claude-plugin/marketplace.json` — Eintrag zum `plugins`-Array hinzufügen
5. Hooks bei Bedarf: Erstelle `skills/<name>/hooks/hooks.json` + Skripte; `source` in marketplace.json muss auf `./skills/<name>` zeigen

Siehe [CLAUDE.md](../../../CLAUDE.md) für vollständige Entwicklungsrichtlinien.

## Lizenz

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
