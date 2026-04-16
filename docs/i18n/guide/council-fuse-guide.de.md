# Council Fuse Benutzerhandbuch

> In 5 Minuten starten — Multi-Perspektiven-Deliberation für bessere Antworten

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserai/forge
```

### Universelle Einzeiler-Installation

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **Keine Abhängigkeiten** — Council Fuse benötigt keine externen Dienste oder APIs. Installieren und loslegen.

---

## Befehle

| Befehl | Funktion | Wann verwenden |
|--------|----------|----------------|
| `/council-fuse <Frage>` | Vollständige Rats-Deliberation durchführen | Wichtige Entscheidungen, komplexe Fragen |

---

## Funktionsweise

Council Fuse destilliert Karpathys LLM Council-Muster in einen einzigen Befehl:

### Phase 1: Einberufen

Drei Agenten werden **parallel** gestartet, jeder mit einer anderen Perspektive:

| Agent | Rolle | Modell | Stärke |
|-------|-------|--------|--------|
| Generalist | Ausgewogen, praktisch | Sonnet | Gängige Best Practices |
| Kritiker | Gegnerisch, findet Schwachstellen | Opus | Grenzfälle, Risiken, blinde Flecken |
| Spezialist | Tiefes technisches Detail | Sonnet | Implementierungspräzision |

Jeder Agent antwortet **unabhängig** — sie können die Antworten der anderen nicht sehen.

### Phase 2: Bewerten

Der Vorsitzende (Hauptagent) anonymisiert alle Antworten als Antwort A/B/C und bewertet dann jede auf 4 Dimensionen (0-10):

- **Korrektheit** — sachliche Genauigkeit, logische Schlüssigkeit
- **Vollständigkeit** — Abdeckung aller Aspekte
- **Praktikabilität** — Umsetzbarkeit, Praxistauglichkeit
- **Klarheit** — Struktur, Lesbarkeit

### Phase 3: Synthese

Die am höchsten bewertete Antwort wird zum Grundgerüst. Einzigartige Erkenntnisse aus den anderen Antworten werden integriert. Die berechtigten Einwände des Kritikers bleiben als Vorbehalte erhalten.

---

## Anwendungsfälle

### Architekturentscheidungen

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

Der Generalist liefert ausgewogene Abwägungen, der Kritiker hinterfragt den Microservices-Hype und der Spezialist beschreibt Migrationsmuster. Die Synthese ergibt eine bedingte Empfehlung.

### Technologieauswahl

```
/council-fuse Redis vs PostgreSQL for our job queue
```

Drei verschiedene Blickwinkel stellen sicher, dass Sie weder betriebliche Bedenken (Kritiker), Implementierungsdetails (Spezialist) noch den pragmatischen Standard (Generalist) übersehen.

### Code-Review

```
/council-fuse Is this error handling pattern correct? <paste code>
```

Erhalten Sie gängige Validierung, gegnerische Grenzfall-Analyse und tiefgehende technische Verifizierung in einem Durchgang.

---

## Ausgabestruktur

Jede Rats-Deliberation erzeugt:

1. **Bewertungsmatrix** — transparente Bewertung aller drei Perspektiven
2. **Konsensanalyse** — Übereinstimmungen und Meinungsverschiedenheiten
3. **Synthetisierte Antwort** — die fusionierte beste Antwort
4. **Minderheitsmeinung** — beachtenswerte abweichende Standpunkte

---

## Anpassung

### Perspektiven ändern

Bearbeiten Sie `agents/*.md`, um benutzerdefinierte Ratsmitglieder festzulegen. Alternative Dreiergruppen:

- Optimist / Pessimist / Pragmatiker
- Architekt / Umsetzer / Tester
- Nutzeranwalt / Entwickler / Sicherheitsexperte

### Modelle ändern

Bearbeiten Sie das Feld `model:` in jeder Agenten-Datei:

- `model: haiku` — kostengünstige Rats-Sitzungen
- `model: opus` — Schwergewicht für kritische Entscheidungen

---

## Plattformen

| Plattform | Funktionsweise der Ratsmitglieder |
|-----------|-----------------------------------|
| Claude Code | 3 unabhängige Agent-Spawns parallel |
| OpenClaw | Einzelner Agent, 3 sequenzielle unabhängige Denkrunden |

---

## FAQ

**F: Kostet es 3x so viele Tokens?**
A: Ja, ungefähr. Drei unabhängige Antworten plus Synthese. Verwenden Sie es für Entscheidungen, die die Investition rechtfertigen.

**F: Kann ich weitere Ratsmitglieder hinzufügen?**
A: Das Framework unterstützt das — fügen Sie eine weitere `agents/*.md`-Datei hinzu und aktualisieren Sie den SKILL.md-Workflow. Allerdings ist 3 der optimale Kompromiss zwischen Kosten und Vielfalt.

**F: Was passiert, wenn ein Agent fehlschlägt?**
A: Der Vorsitzende bewertet dieses Mitglied mit 0 und synthetisiert aus den verbleibenden Antworten. Graceful Degradation, kein Absturz.
