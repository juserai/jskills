# Skill Lint Benutzerhandbuch

> In 3 Minuten loslegen — Qualität Ihres Claude Code Skills validieren

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserai/forge
```

### Universelle Einzeiler-Installation

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **Keine Abhängigkeiten** — Skill Lint benötigt keine externen Dienste oder APIs. Installieren und loslegen.

---

## Befehle

| Befehl | Funktion | Verwendung |
|--------|----------|------------|
| `/skill-lint` | Nutzungsinfo anzeigen | Verfügbare Prüfungen anzeigen |
| `/skill-lint .` | Aktuelles Projekt prüfen | Selbstprüfung während der Entwicklung |
| `/skill-lint /path/to/plugin` | Einen bestimmten Pfad prüfen | Ein anderes Plugin überprüfen |

---

## Anwendungsfälle

### Selbstprüfung nach Erstellung eines neuen Skills

Nach dem Erstellen von `skills/<name>/SKILL.md`, `commands/<name>.md` und zugehörigen Dateien führen Sie `/skill-lint .` aus, um zu bestätigen, dass die Struktur vollständig ist, das Frontmatter korrekt ist und der Marketplace-Eintrag hinzugefügt wurde.

### Plugin einer anderen Person überprüfen

Bei der Überprüfung eines PRs oder der Prüfung eines anderen Plugins verwenden Sie `/skill-lint /path/to/plugin` für eine schnelle Prüfung auf Dateivollständigkeit und Konsistenz.

### CI-Integration

`scripts/skill-lint.sh` kann direkt in einer CI-Pipeline ausgeführt werden und gibt JSON für automatisiertes Parsing aus:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Prüfpunkte

### Strukturelle Prüfungen (ausgeführt durch Bash-Skript)

| Regel | Was geprüft wird | Schweregrad |
|-------|------------------|-------------|
| S01 | `plugin.json` existiert sowohl im Root als auch in `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` existiert | error |
| S03 | Jedes `skills/<name>/` enthält eine `SKILL.md` | error |
| S04 | SKILL.md Frontmatter enthält `name` und `description` | error |
| S05 | Jeder Skill hat eine zugehörige `commands/<name>.md` | warning |
| S06 | Jeder Skill ist im marketplace.json `plugins`-Array aufgeführt | warning |
| S07 | In SKILL.md referenzierte Dateien existieren tatsächlich | error |
| S08 | `evals/<name>/scenarios.md` existiert | warning |

### Semantische Prüfungen (ausgeführt durch KI)

| Regel | Was geprüft wird | Schweregrad |
|-------|------------------|-------------|
| M01 | Beschreibung gibt Zweck und Auslösebedingungen klar an | warning |
| M02 | Name stimmt mit Verzeichnisname überein; Beschreibung ist dateiübergreifend konsistent | warning |
| M03 | Befehlsrouting-Logik referenziert den Skill-Namen korrekt | warning |
| M04 | Referenzinhalte sind logisch konsistent mit SKILL.md | warning |
| M05 | Evaluierungsszenarien decken die Kernfunktionalitätspfade ab (mindestens 5) | warning |

---

## Beispiele für erwartete Ausgaben

### Alle Prüfungen bestanden

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### Probleme gefunden

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Arbeitsablauf

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## FAQ

### Kann ich nur strukturelle Prüfungen ohne semantische Prüfungen ausführen?

Ja — führen Sie das Bash-Skript direkt aus:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Dies gibt reines JSON ohne KI-semantische Analyse aus.

### Funktioniert es bei Nicht-forge-Projekten?

Ja. Jedes Verzeichnis, das der Standard-Plugin-Struktur von Claude Code folgt (`skills/`, `commands/`, `.claude-plugin/`), kann validiert werden.

### Was ist der Unterschied zwischen Fehlern und Warnungen?

- **error**: Strukturelle Probleme, die das Laden oder Veröffentlichen des Skills verhindern
- **warning**: Qualitätsprobleme, die die Funktionalität nicht beeinträchtigen, aber Wartbarkeit und Auffindbarkeit betreffen

### Weitere forge-Tools

Skill Lint ist Teil der forge-Sammlung und funktioniert gut zusammen mit diesen Skills:

- [Block Break](block-break-guide.md) — Verhaltensbasierte Einschränkungs-Engine, die KI zwingt, jeden Ansatz auszuschöpfen
- [Ralph Boost](ralph-boost-guide.md) — Autonome Entwicklungsschleifen-Engine mit eingebauten Block Break Konvergenzgarantien

Nach der Entwicklung eines neuen Skills führen Sie `/skill-lint .` aus, um die strukturelle Vollständigkeit zu überprüfen und zu bestätigen, dass Frontmatter, marketplace.json und Referenzlinks alle korrekt sind.

---

## Wann verwenden / Wann NICHT verwenden

### ✅ Verwenden wenn

- Validating a Claude Code plugin's structure before release
- Checking integrity hash / convention compliance / i18n coverage
- As a CI/CD gate for plugin repositories

### ❌ Nicht verwenden wenn

- Non-plugin projects (rules don't apply; you'll get irrelevant errors)
- Production code quality review (not a linter / type checker / security scanner)
- License legal review (only checks the `license` field exists)

> Struktur-CI für Claude Code Plugins — gewährleistet Konventionskonformität und Hash-Konsistenz, nicht Laufzeit-Korrektheit.

Vollständige Grenzanalyse: [references/scope-boundaries.md](../../../skills/skill-lint/references/scope-boundaries.md)

---

## Lizenz

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
