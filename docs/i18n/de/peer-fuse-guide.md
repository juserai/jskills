# Peer Fuse v0.1.0 Anleitung

> Generischer Peer-Reviewer für Recherche-Artefakte — **8-Stufen-Pipeline (Stage 7 KB-Archivierung verpflichtend + beobachtbar, opt-out via `--no-save`) + 10-Format-Eingabeadapter (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, 3-Tier-Dispatch) + 6 Recherche-Typ-Presets (auto-klassifiziert) + 8-dimensionale gewichtete Rubrik + 18-Flag-Taxonomie + 3-Perspektiven-Panel + § Document Reading Freeze (Review-Isolation als harte Beschränkung)**.

Peer-Fuse nimmt jedes Markdown- / PDF- / Office-Dokument und erzeugt einen Peer-Review-Markdown-Bericht mit einer A+/A−/.../D-Note, einer abgestuften Liste von Qualitätsflags, einer Multi-Perspektiven-Panel-Synthese und Patch-artigen Diff-Vorschlägen. Es koexistiert mit dem [insight-fuse Stage 6.5 Reviewer](insight-fuse-guide.md) — Stage 6.5 ist der IF-interne Same-Source-Review; peer-fuse ist der **skill-übergreifende externe Reviewer**, der Formate und Skills abdeckt, die Stage 6.5 nicht beherrscht.

## Schnellstart

```bash
# Auto-Klassifizierung des Typs, Standardtiefe, Archivierung in KB
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# PDF-Forschungsarbeit (Typ automatisch aus arXiv/IEEE/Nature-Header erkannt)
/peer-fuse papers/transformer-2017.pdf

# PPTX-Deck mit explizitem Typ
/peer-fuse decks/q4-roadmap.pptx --type product

# Quick-Tiefe (überspringt Stage 4 Panel + Stage 5.5 Holistic) + KB-Archiv überspringen
/peer-fuse handbook.docx --depth quick --no-save

# Hilfe anzeigen
/peer-fuse help
# oder ohne Argumente
/peer-fuse
```

## Defaults & Flags

| Flag | Default | Werte |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — überspringt Stage 7 KB-Archivierung, nur Konsolenausgabe |

`--type=auto` lässt peer-fuse das Dokument nach dem Lesen über Heuristiken klassifizieren (frontmatter type field → section pattern → citation density → format/title hints → fallback overview). Siehe [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) für die Prioritätskette.

## Unterstützte Formate

| Tier | Tool-Anforderung | Formate |
|:-:|---|---|
| 1 | keine (nativ) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` für `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Fehlendes Tool → Fail-Soft mit konkretem Installationshinweis (`brew install pandoc`, `apt install libreoffice`, etc.) und Abbruch vor Stage 1. Siehe [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md).

## Was Sie zurückerhalten

Zwei parallele Ergebnisse:

1. **Inline gerenderter Review** in Ihrer Konversation, strukturiert als:
   - § Document Reading — deskriptive Erzählung (was das Dokument aussagt), 3-5 Absätze, 300-600 Wörter
   - § Holistic Assessment — bewertende Erzählung (Methodik / Stärken / Bedenken / Empfehlung), 4 Absätze, 400-700 Wörter
   - § Score Matrix — 8-dim gewichtete Bewertungen → Notenstufe
   - § Flag List — Flag-Codes aus 18-Taxonomie mit Positionen
   - § Multi-Perspective Panel — Verdikte von Methodologist / Adversarial / Practitioner
   - § Diff Suggestions — Patch-artige Umformulierungen für jeden Mangel
   - § Reconciliation — target self-grade vs review_grade Δ

2. **KB-Archivierung** unter `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` (mit `--no-save` überspringen). Die Archivierungs-Logzeile `Archived to KB: <path>` erscheint immer in der für den Nutzer sichtbaren Antwort.

## Harte Beschränkung: § Document Reading ist review-isoliert

Die wichtigste architektonische Entscheidung in peer-fuse:

**§ Document Reading darf nicht durch Review-Verdikte verunreinigt werden.** Es ist die treue, deskriptive Lesart des Dokuments durch den Reviewer — frontmatter, Struktur, Behauptungen, Belege, Scope. Es läuft in Stage 3.5, **vor** Stage 4 Panel und Stage 5 Scoring, und die Eingabegrenze ist strikt:

- ✅ Akzeptiert: Originaldokument, Stage 1-3 sachliche Scan-Ergebnisse
- ❌ Abgelehnt: Panel-Verdikte, Bewertungen, Flag-Treffer

Der Abschnitt wird nach Stage 3.5 **eingefroren**: ein SHA-256-Hash wird vor Stage 4 erfasst, und Stage 7 verifiziert den Hash vor der Archivierung. Jede Modifikation → Fail-Closed. Lint verbietet zudem evaluatives Vokabular (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) und Notenstufen-Literale aus diesem Abschnitt.

Dies ist die vom Nutzer geforderte harte Beschränkung und wird auf drei Ebenen erzwungen: architektonische Isolation + Write-Once-Freeze + Forbidden-Word-Lint.

## Interaktion mit anderen Forge-Skills

| Skill | Beziehung |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | Koexistiert — Stage 6.5 ist IF-interner Same-Source-Review (gleiche Rubrik, gleiche Heuristiken, nur IF-Markdown). peer-fuse ist **skill-übergreifender externer Review** mit breiterer 8-dim-Rubrik, 18 Flags, 10 Formaten, 3-Agent-Panel. Beide sollten für wichtige IF-Berichte ausgeführt werden. |
| **council-fuse** | Geschwister-Crucible — peer-fuse verwendet das parallele Sub-Agent-Dispatch-Muster von council-fuse wieder (Stage 4 Panel spiegelt council-fuse Stage 1). |
| **tome-forge** | Archivierungs-Backend — peer-fuse Stage 7 ruft das report-archival-protocol von tome-forge auf; implementiert die KB-Schreiblogik nicht erneut. |
| **skill-lint** | Geschwister-nach-Muster (andere Kategorie, anvil) — beide beurteilen Artefakte und geben Diagnostik aus, aber skill-lint produziert ephemere Konsolen-Diagnostik, während peer-fuse ein persistentes Markdown-Peer-Review-Artefakt produziert. |

## Wann peer-fuse vs. IF Stage 6.5 verwenden

| Szenario | Verwenden |
|---|:-:|
| Sie haben gerade `/insight-fuse <topic>` ausgeführt und möchten eine zweite Meinung zum IF-Bericht | IF Stage 6.5 lief bereits inline; wenn Sie einen zweistufigen externen Review mit Cross-Format-Bereitschaft wünschen, führen Sie `/peer-fuse <if-output-path>` aus |
| Sie haben eine Drittanbieter-PDF-Forschungsarbeit zu bewerten | peer-fuse |
| Sie haben ein PPTX-Business-Deck, das Sie benoten lassen möchten | peer-fuse |
| Sie haben eine council-fuse Synthese-Ausgabe, die Sie benoten lassen möchten | peer-fuse |
| Sie möchten mehrere Artefakte anhand derselben Rubrik vergleichen | peer-fuse (konsistente Bewertung über Artefakte hinweg) |

## Konkretes Beispiel

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 detection
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 produces § Document Reading (frozen)
# Stage 4 panel runs 3 sub-agents in parallel
# Stage 5 scoring → 8.6 / A-
# Stage 5.5 holistic assessment
# Stage 6 diff suggestions: 5 blocks
# Stage 7 archive

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

Die Konsole rendert den vollständigen Review inline; das KB-Archiv ist die persistente kanonische Version.

## Verifikation

```bash
# Statische Prüfung
bash skills/skill-lint/scripts/skill-lint.sh .

# Trigger-Test
bash evals/peer-fuse/run-trigger-test.sh

# Hash-Lockstep
bash scripts/recalc-all-hashes.sh
```

## Siehe auch

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — Runtime-Skill-Definition
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — architektonische Entscheidungen + 4-Kategorien-Rationale
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (nach Merge)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — Geschwister-Crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — Geschwister-Crucible (Quelle des Panel-Musters)
