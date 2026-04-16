# News Fetch Benutzerhandbuch

> In 3 Minuten starten — lassen Sie die KI Ihre Nachrichtenübersicht abrufen

Ausgebrannt vom Debugging? Nehmen Sie sich 2 Minuten, erfahren Sie, was in der Welt passiert, und kommen Sie erfrischt zurück.

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserai/forge
```

### Universelle Einzeiler-Installation

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **Keine Abhängigkeiten** — News Fetch benötigt keine externen Dienste oder API-Schlüssel. Installieren und loslegen.

---

## Befehle

| Befehl | Funktion | Einsatzzweck |
|--------|----------|-------------|
| `/news-fetch AI` | KI-Nachrichten dieser Woche abrufen | Schnelles Branchenupdate |
| `/news-fetch AI today` | Heutige KI-Nachrichten abrufen | Tägliche Übersicht |
| `/news-fetch robotics month` | Robotik-Nachrichten dieses Monats abrufen | Monatlicher Rückblick |
| `/news-fetch climate 2026-03-01~2026-03-31` | Nachrichten für einen bestimmten Zeitraum abrufen | Gezielte Recherche |

---

## Anwendungsfälle

### Tägliche Tech-Übersicht

```
/news-fetch AI today
```

Erhalten Sie die neuesten KI-Nachrichten des Tages, nach Relevanz sortiert. Scannen Sie Schlagzeilen und Zusammenfassungen in Sekunden.

### Branchenrecherche

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Rufen Sie Nachrichten für einen bestimmten Zeitraum ab, um Marktanalysen und Wettbewerbsforschung zu unterstützen.

### Sprachübergreifende Nachrichten

Chinesische Themen erhalten automatisch ergänzende englische Suchen für breitere Abdeckung und umgekehrt. Sie erhalten das Beste aus beiden Welten ohne zusätzlichen Aufwand.

---

## Beispiel für erwartete Ausgabe

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## 3-stufiger Netzwerk-Fallback

News Fetch verfügt über eine eingebaute Fallback-Strategie, um sicherzustellen, dass der Nachrichtenabruf unter verschiedenen Netzwerkbedingungen funktioniert:

| Stufe | Werkzeug | Datenquelle | Auslöser |
|-------|----------|-------------|----------|
| **L1** | WebSearch | Google/Bing | Standard (bevorzugt) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 schlägt fehl |
| **L3** | Bash curl | Gleiche Quellen wie L2 | L2 schlägt ebenfalls fehl |

Wenn alle Stufen fehlschlagen, wird ein strukturierter Fehlerbericht erstellt, der den Fehlergrund für jede Quelle auflistet.

---

## Ausgabefunktionen

| Funktion | Beschreibung |
|----------|-------------|
| **Deduplizierung** | Wenn mehrere Quellen über dasselbe Ereignis berichten, wird der Eintrag mit der höchsten Bewertung beibehalten; andere werden unter „Verwandte Berichterstattung" zusammengefasst |
| **Zusammenfassungsergänzung** | Fehlt in den Suchergebnissen eine Zusammenfassung, wird der Artikeltext abgerufen und eine Zusammenfassung generiert |
| **Relevanzbewertung** | KI bewertet jedes Ergebnis nach Themenrelevanz — höher bedeutet relevanter |
| **Anklickbare Links** | Markdown-Linkformat — anklickbar in IDEs und Terminals |

---

## Relevanzbewertung

Jeder Artikel wird auf einer Skala von 0-300 bewertet, basierend darauf, wie gut Titel und Zusammenfassung zum angeforderten Thema passen:

| Bewertungsbereich | Bedeutung |
|-------------------|-----------|
| 200-300 | Hochrelevant — Thema ist das Hauptthema |
| 100-199 | Mäßig relevant — Thema wird wesentlich erwähnt |
| 0-99 | Tangential relevant — Thema wird am Rande erwähnt |

Artikel werden absteigend nach Bewertung sortiert. Die Bewertung ist heuristisch und basiert auf Schlüsselwortdichte, Titelübereinstimmung und kontextueller Relevanz.

## Fehlerbehebung Netzwerk-Fallback

| Symptom | Wahrscheinliche Ursache | Lösung |
|---------|------------------------|--------|
| L1 liefert 0 Ergebnisse | WebSearch-Werkzeug nicht verfügbar oder Abfrage zu spezifisch | Themenschlüsselwort erweitern |
| L2 alle Quellen schlagen fehl | Inländische Nachrichtenseiten blockieren automatisierten Zugriff | Warten und erneut versuchen, oder prüfen ob `curl` manuell funktioniert |
| L3 curl Zeitüberschreitungen | Netzwerkverbindungsproblem | `curl -I https://news.baidu.com` prüfen |
| Alle Stufen schlagen fehl | Kein Internetzugang oder alle Quellen ausgefallen | Netzwerk überprüfen; der Fehlerbericht listet den Fehler jeder Quelle auf |

---

## FAQ

### Brauche ich einen API-Schlüssel?

Nein. News Fetch basiert ausschließlich auf WebSearch und öffentlichem Web-Scraping. Keine Konfiguration erforderlich.

### Kann es englischsprachige Nachrichten abrufen?

Auf jeden Fall. Chinesische Themen beinhalten automatisch ergänzende englische Suchen, und englische Themen funktionieren nativ. Die Abdeckung umfasst beide Sprachen.

### Was wenn mein Netzwerk eingeschränkt ist?

Die 3-stufige Fallback-Strategie behandelt dies automatisch. Selbst wenn WebSearch nicht verfügbar ist, greift News Fetch auf inländische Nachrichtenquellen zurück.

### Wie viele Artikel werden zurückgegeben?

Bis zu 20 (nach Deduplizierung). Die tatsächliche Anzahl hängt davon ab, was die Datenquellen liefern.

---

## Lizenz

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
