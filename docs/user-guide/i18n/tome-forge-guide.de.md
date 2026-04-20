# Tome Forge Benutzerhandbuch

> In 5 Minuten loslegen — persoenliche Wissensdatenbank mit LLM-kompiliertem Wiki

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserai/forge
```

### Universelle Einzeiler-Installation

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **Keine Abhaengigkeiten** — Tome Forge benoetigt keine externen Dienste, keine Vektordatenbank, keine RAG-Infrastruktur. Installieren und loslegen.

---

## Befehle

| Befehl | Funktion | Wann verwenden |
|--------|----------|----------------|
| `/tome-forge init` | Wissensdatenbank initialisieren | Beim Starten einer neuen KB in einem beliebigen Verzeichnis |
| `/tome-forge capture [text]` | Schnellerfassung von Notiz, Link oder Zwischenablage | Gedanken notieren, URLs speichern, Inhalte clippen |
| `/tome-forge capture clip` | Aus der Systemzwischenablage erfassen | Schnelles Speichern kopierter Inhalte |
| `/tome-forge ingest <path>` | Rohmaterial in Wiki kompilieren | Nach dem Hinzufuegen von Artikeln, Papieren oder Notizen zu `raw/` |
| `/tome-forge ingest <path> --dry-run` | Routing-Vorschau ohne Schreiben | Vor dem Uebernehmen von Aenderungen ueberpruefen |
| `/tome-forge query <question>` | Im Wiki suchen und zusammenfassen | Antworten in der gesamten Wissensdatenbank finden |
| `/tome-forge lint` | Wiki-Struktur pruefen | Vor Commits, regelmaessige Wartung |
| `/tome-forge compile` | Alle neuen Rohmaterialien stapelweise kompilieren | Aufholen nach dem Hinzufuegen mehrerer Rohdateien |

---

## Funktionsweise

Basierend auf Karpathys LLM-Wiki-Muster:

```
raw materials + LLM compilation = structured Markdown wiki
```

### Die Zwei-Schichten-Architektur

| Schicht | Eigentuemer | Zweck |
|---------|-------------|-------|
| `raw/` | Sie | Unveraenderliche Quellmaterialien — Artikel, Papiere, Notizen, Links |
| `wiki/` | LLM | Kompilierte, strukturierte, quervernetzte Markdown-Seiten |

Das LLM liest Ihre Rohmaterialien und kompiliert sie zu gut strukturierten Wiki-Seiten. Sie bearbeiten `wiki/` niemals direkt — Sie fuegen Rohmaterialien hinzu und lassen das LLM das Wiki pflegen.

### Der Geschuetzte Abschnitt

Jede Wiki-Seite hat einen Abschnitt `## Mein Verstaendnis-Delta`. Dieser gehoert **Ihnen** — das LLM wird ihn niemals aendern. Schreiben Sie hier Ihre persoenlichen Erkenntnisse, Widersprueche oder Intuitionen. Er ueberlebt alle Neukompilierungen.

---

## KB-Erkennung — Wohin gehen meine Daten?

Sie koennen `/tome-forge` aus **jedem Verzeichnis** ausfuehren. Es findet automatisch die richtige KB:

| Situation | Was passiert |
|-----------|-------------|
| Aktuelles Verzeichnis (oder uebergeordnetes) enthaelt `.tome-forge.json` | Verwendet diese KB |
| Kein `.tome-forge.json` nach oben gefunden | Verwendet Standard `~/.tome-forge/` (wird bei Bedarf automatisch erstellt) |

Das bedeutet, Sie koennen Notizen aus jedem Projekt erfassen, ohne zuerst `cd` ausfuehren zu muessen — alles fliesst in Ihre einzelne Standard-KB.

Moechten Sie separate KBs pro Projekt? Verwenden Sie `init .` innerhalb des Projektverzeichnisses.

## Arbeitsablauf

### 1. Initialisieren

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

Nach der Initialisierung sieht das KB-Verzeichnis so aus:

```
~/.tome-forge/               # (or wherever you initialized)
├── .tome-forge.json         # KB marker (auto-generated)
├── CLAUDE.md                # KB schema and rules
├── index.md                 # Wiki page index
├── .gitignore
├── logs/                    # Operation logs (monthly rotation)
│   └── 2026-04.md           # One file per month, never grows too large
├── raw/                     # Your source materials (immutable)
└── wiki/                    # LLM-compiled wiki (auto-maintained)
```

### 2. Erfassen

Aus **jedem Verzeichnis** einfach ausfuehren:

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

Schnellerfassungen gehen nach `raw/captures/{date}/`. Fuer laengere Materialien legen Sie Dateien direkt in `raw/papers/`, `raw/articles/` usw. ab.

### 3. Aufnehmen

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

Das LLM liest die Rohdatei, leitet sie an die richtige(n) Wiki-Seite(n) weiter und fuegt neue Informationen zusammen, waehrend Ihre persoenlichen Notizen erhalten bleiben.

### 4. Abfragen

```
/tome-forge query "what is the relationship between attention and transformers?"
```

Synthetisiert eine Antwort aus Ihrem Wiki mit Verweis auf bestimmte Seiten. Teilt Ihnen mit, wenn Informationen fehlen und welches Rohmaterial hinzugefuegt werden sollte.

### 5. Warten

```
/tome-forge lint
/tome-forge compile
```

Lint prueft die strukturelle Integritaet. Compile nimmt stapelweise alles Neue seit der letzten Kompilierung auf.

---

## Verzeichnisstruktur

```
my-knowledge-base/
├── .tome-forge.json       # KB marker (auto-generated)
├── CLAUDE.md              # Schema and rules (auto-generated)
├── index.md               # Wiki page index
├── .last_compile          # Timestamp for batch compile
├── logs/                  # Operation logs (monthly rotation)
│   └── 2026-04.md
├── raw/                   # Your source materials (immutable)
│   ├── captures/          # Quick captures by date
│   ├── papers/            # Academic papers
│   ├── articles/          # Blog posts, articles
│   ├── books/             # Book notes
│   └── conversations/     # Chat logs, interviews
└── wiki/                  # LLM-compiled wiki (auto-maintained)
    ├── ai/                # Domain directories
    ├── systems/
    └── ...
```

---

## Wiki-Seitenformat

Jede Wiki-Seite folgt einer strengen Vorlage:

```yaml
---
domain: ai
maturity: growing        # draft | growing | stable | deprecated
last_compiled: 2026-04-15
source_refs:
  - raw/papers/attention.md
confidence: medium       # low | medium | high
compiled_by: claude-opus-4-6
---
```

Erforderliche Abschnitte:
- **Kernkonzept** — LLM-gepflegtes Wissen
- **Mein Verstaendnis-Delta** — Ihre persoenlichen Erkenntnisse (wird vom LLM nicht angeruehrt)
- **Offene Fragen** — Unbeantwortete Fragen
- **Verbindungen** — Links zu verwandten Wiki-Seiten

---

## Empfohlener Rhythmus

| Haeufigkeit | Aktion | Zeit |
|-------------|--------|------|
| **Taeglich** | `capture` fuer Gedanken, Links, Zwischenablage | 2 Min. |
| **Woechentlich** | `compile` zur Stapelverarbeitung der Wochenmaterialien | 15-30 Min. |
| **Monatlich** | `lint` + Mein Verstaendnis-Delta Abschnitte ueberpruefen | 30 Min. |

**Vermeiden Sie Echtzeit-Aufnahme.** Haeufige Einzeldatei-Aufnahmen fragmentieren die Kohaerenz des Wikis. Woechentliche Stapelkompilierung erzeugt bessere Querverweise und konsistentere Seiten.

---

## Skalierungs-Fahrplan

| Phase | Wiki-Groesse | Strategie |
|-------|-------------|-----------|
| 1. Kaltstart (Woche 1-4) | < 30 Seiten | Vollstaendiger Kontextlauf, index.md-Routing |
| 2. Normalbetrieb (Monat 2-3) | 30-100 Seiten | Themen-Sharding (wiki/ai/, wiki/systems/) |
| 3. Skalierung (Monat 4-6) | 100-200 Seiten | Shard-bezogene Abfragen, ripgrep-Ergaenzung |
| 4. Fortgeschritten (6+ Monate) | 200+ Seiten | Embedding-basiertes Routing (nicht Retrieval), inkrementelle Kompilierung |

---

## Bekannte Risiken

| Risiko | Auswirkung | Abhilfe |
|--------|-----------|---------|
| **Formulierungsdrift** | Mehrfaches Kompilieren glaettet persoenliche Stimme | `compiled_by` verfolgt das Modell; raw/ ist die Wahrheitsquelle; jederzeit aus raw neu kompilieren |
| **Skalierungsobergrenze** | Kontextfenster begrenzt Wiki-Groesse | Nach Domain aufteilen; Index-Routing verwenden; Embedding-Schicht bei > 200 Seiten |
| **Anbieterabhaengigkeit** | An einen LLM-Anbieter gebunden | Rohquellen sind reines Markdown; Modell wechseln und neu kompilieren |
| **Delta-Korruption** | LLM ueberschreibt persoenliche Erkenntnisse | Post-Aufnahme-Diff-Verifizierung stellt Original-Delta automatisch wieder her |

---

## Plattformen

| Plattform | Funktionsweise |
|-----------|---------------|
| Claude Code | Voller Dateisystemzugriff, paralleles Lesen, Git-Integration |
| OpenClaw | Gleiche Operationen, angepasst an OpenClaw-Tool-Konventionen |

---

## Wann verwenden / Wann NICHT verwenden

### ✅ Verwenden wenn

- Building a personal knowledge base from scattered notes
- You want LLM-compiled wiki that preserves human insights
- Zero-infra solution (just Markdown + Git)

### ❌ Nicht verwenden wenn

- Team collaboration or real-time sync
- Ad-hoc notes (too structured — plain Markdown is fine)
- Transactional data (use a real database)

> LLM-kompilierte persönliche Bibliothek — bewahrt menschliche Einsichten, für Einzelpersonen konzipiert, keine Echtzeit-Synchronisation.

Vollständige Grenzanalyse: [references/scope-boundaries.md](../../../skills/tome-forge/references/scope-boundaries.md)

---

## FAQ

**F: Wie gross kann das Wiki werden?**
A: Unter 50 Seiten liest das LLM alles. Bei 50-200 Seiten nutzt es den Index zur Navigation. Ueber 200 hinaus sollten Sie Domain-Sharding in Betracht ziehen.

**F: Kann ich Wiki-Seiten direkt bearbeiten?**
A: Nur den Abschnitt `## Mein Verstaendnis-Delta`. Alles andere wird bei der naechsten Aufnahme/Kompilierung ueberschrieben.

**F: Wird eine Vektordatenbank benoetigt?**
A: Nein. Das Wiki ist reines Markdown. Das LLM liest Dateien direkt — keine Embeddings, kein RAG, keine Infrastruktur.

**F: Wie sichere ich meine KB?**
A: Es sind alles Dateien in einem Git-Repository. `git push` und fertig.

**F: Was wenn das LLM einen Fehler im Wiki macht?**
A: Fuegen Sie eine Korrektur zu `raw/` hinzu und nehmen Sie erneut auf. Der Zusammenfuehrungsalgorithmus bevorzugt autoritativere Quellen. Oder notieren Sie Unstimmigkeiten in Ihrem Mein Verstaendnis-Delta.
