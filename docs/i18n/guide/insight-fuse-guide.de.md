# Insight Fuse Benutzerhandbuch

> Systematische Multi-Source-Recherche-Engine — Vom Thema zum professionellen Recherchebericht

## Schnellstart

```bash
# Vollstaendige Recherche (5 Phasen, mit manuellen Checkpoints)
/insight-fuse AI Agent Sicherheitsrisiken

# Schnell-Scan (nur Stage 1)
/insight-fuse --depth quick Quantencomputing

# Mit bestimmter Vorlage
/insight-fuse --template technology WebAssembly

# Tiefenrecherche mit benutzerdefinierten Perspektiven
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist Kommerzialisierung autonomes Fahren

# Nur recherchieren, nicht archivieren (tome-forge KB-Speicherung ueberspringen)
/insight-fuse --depth quick --no-save temporaere Hintergrundrecherche
```

## Parameter

| Parameter | Beschreibung | Beispiel |
|-----------|-------------|----------|
| `topic` | Recherchethema (erforderlich) | `AI Agent Sicherheitsrisiken` |
| `--depth` | Recherchetiefe | `quick` / `standard` / `deep` / `full` |
| `--template` | Berichtsvorlage | `technology` / `market` / `competitive` |
| `--perspectives` | Perspektivenliste | `optimist,pessimist,pragmatist` |
| `--no-save` | KB-Archivierung ueberspringen (Opt-out bei installiertem tome-forge) | Standard `false`; setzen = recherchieren ohne Speichern |

## Tiefenmodi

### quick — Schnell-Scan
Fuehrt Stage 1 aus. 3+ Suchanfragen, 5+ Quellen, gibt einen Kurzbericht aus. Geeignet fuer einen schnellen Ueberblick ueber ein Thema.

### standard — Standardrecherche
Fuehrt Stage 1 + 3 aus. Erkennt automatisch Unterfragen, recherchiert parallel, umfassende Abdeckung. Keine manuelle Interaktion.

### deep — Tiefenrecherche
Fuehrt Stage 1 + 3 + 5 aus. Aufbauend auf der Standardrecherche werden alle Unterfragen aus 3 Perspektiven tiefgehend analysiert. Keine manuelle Interaktion.

### full (Standard) — Vollstaendige Pipeline
Fuehrt alle 5 Phasen aus. Stage 2 und Stage 4 sind manuelle Checkpoints, um sicherzustellen, dass die Richtung stimmt.

## Berichtsvorlagen

### Integrierte Vorlagen

- **technology** — Technologierecherche: Architektur, Vergleich, Oekosystem, Trends
- **market** — Marktrecherche: Groesse, Wettbewerb, Nutzer, Prognosen
- **competitive** — Wettbewerbsanalyse: Funktionsmatrix, SWOT, Preisgestaltung

### Benutzerdefinierte Vorlagen

1. Kopieren Sie `templates/custom-example.md` als `templates/your-name.md`
2. Aendern Sie die Kapitelstruktur
3. Behalten Sie die Platzhalter `{topic}` und `{date}` bei
4. Das letzte Kapitel muss "Referenzquellen" sein
5. Aktivieren Sie mit `--template your-name`

### Modus ohne Vorlage

Wenn `--template` nicht angegeben wird, generiert der Agent die Berichtsstruktur adaptiv basierend auf dem Rechercheinhalt.

## Multi-Perspektiven-Analyse

### Standardperspektiven

| Perspektive | Rolle | Modell |
|-------------|-------|--------|
| Generalist | Breite Abdeckung, Mainstream-Konsens | Sonnet |
| Critic | Hinterfragen, Gegenbelege finden | Opus |
| Specialist | Technische Tiefe, Primaerquellen | Sonnet |

### Alternative Perspektivensets

| Szenario | Perspektiven |
|----------|-------------|
| Trendprognose | `--perspectives optimist,pessimist,pragmatist` |
| Produktforschung | `--perspectives user,developer,business` |
| Politikforschung | `--perspectives domestic,international,regulatory` |

### Benutzerdefinierte Perspektiven

Erstellen Sie `agents/insight-{name}.md` und orientieren Sie sich an der Struktur bestehender Agent-Dateien.

## Qualitaetssicherung

Jeder Bericht wird automatisch geprueft:
- Mindestens 2 unabhaengige Quellen pro Kapitel
- Keine verwaisten Referenzen
- Einzelquellenanteil nicht ueber 40%
- Alle Vergleichsaussagen mit Daten belegt

## Wann verwenden / Wann NICHT verwenden

### ✅ Verwenden wenn

- Writing a professional research report from multiple sources
- You want configurable depth (scan → deep-dive)
- Multi-perspective crossing of new information

### ❌ Nicht verwenden wenn

- Quick factual lookup (overkill; use `claim-ground` / WebSearch)
- Single-source deep reading
- Tasks requiring primary research (interviews, field work)

> Desk-Research-Pipeline — verwandelt Multi-Source-Synthese in konfigurierbaren Prozess, keine Primärforschung.

Vollständige Grenzanalyse: [references/scope-boundaries.md](../../../skills/insight-fuse/references/scope-boundaries.md)

---

## KB-Archivierung und Opt-out

Nach der Berichtsausgabe versucht insight-fuse **automatisch**, den Bericht gemaess dem Archivierungsprotokoll zu speichern — sofern die lokale tome-forge-Wissensdatenbank installiert ist. Ohne tome-forge wird der Schritt stillschweigend uebersprungen.

Um bei einer einzelnen Recherche das Speichern explizit zu verhindern (Opt-out bei installiertem tome-forge), `--no-save` anhaengen:

```bash
/insight-fuse --depth quick --no-save temporaere Hintergrundrecherche
```

`--no-save` betrifft nur die KB-Archivierung; der Bericht selbst wird weiterhin auf der Konsole ausgegeben. `permissions.filesystem` von insight-fuse ist `none`, ausserhalb des Archivierungspfads erfolgen keine Dateischreiboperationen.

## Unterschied zu council-fuse

| | insight-fuse | council-fuse |
|---|---|---|
| **Zweck** | Aktive Recherche + Berichtserstellung | Multi-Perspektiven-Deliberation ueber bekannte Informationen |
| **Informationsquelle** | WebSearch/WebFetch Erfassung | Vom Nutzer bereitgestellte Fragen |
| **Ausgabe** | Vollstaendiger Recherchebericht | Synthetisierte Antwort |
| **Phasen** | 5 Phasen progressiv | 3 Phasen (Einberufung → Bewertung → Synthese) |

Beide koennen kombiniert werden: Zuerst mit insight-fuse recherchieren und Informationen sammeln, dann mit council-fuse Schluesselentscheidungen tiefgehend diskutieren.
