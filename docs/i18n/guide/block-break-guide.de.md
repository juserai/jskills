# Block Break Benutzerhandbuch

> In 5 Minuten starten — Ihr KI-Agent soll jeden Lösungsansatz ausschöpfen

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserai/forge
```

### Universelle Einzeiler-Installation

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **Keine Abhängigkeiten** — Block Break benötigt keine externen Dienste oder APIs. Installieren und loslegen.

---

## Befehle

| Befehl | Funktion | Einsatzzeitpunkt |
|--------|----------|------------------|
| `/block-break` | Block Break Engine aktivieren | Tägliche Aufgaben, Debugging |
| `/block-break L2` | Auf einer bestimmten Druckstufe starten | Nach bekannten mehrfachen Fehlschlägen |
| `/block-break fix the bug` | Aktivieren und sofort eine Aufgabe ausführen | Schnellstart mit Aufgabe |

### Natürlichsprachliche Auslöser (automatisch durch Hooks erkannt)

| Sprache | Auslöser-Phrasen |
|---------|-----------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Anwendungsfälle

### KI konnte einen Bug nach 3 Versuchen nicht beheben

Tippen Sie `/block-break` oder sagen Sie `try harder` — aktiviert automatisch den Druckeskalationsmodus.

### KI sagt „Wahrscheinlich ein Umgebungsproblem" und hört auf

Block Breaks „Faktenbasiert"-Grenzlinie erzwingt werkzeugbasierte Überprüfung. Ungeprüfte Zuschreibung = Schuldzuweisung → löst L2 aus.

### KI sagt „Ich schlage vor, dass Sie das manuell erledigen"

Löst den „Eigentümer-Mentalität"-Block aus: Wenn nicht du, wer dann? Direkt L3 Leistungsbeurteilung.

### KI sagt „Behoben", zeigt aber keine Verifizierungsnachweise

Verstößt gegen die „Geschlossener Kreislauf"-Grenzlinie. Abschluss ohne Ausgabe = Selbsttäuschung → erzwingt Verifizierungsbefehle mit Nachweisen.

---

## Beispiele für erwartete Ausgaben

### `/block-break` — Aktivierung

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 Enttäuschung (2. Fehlschlag)

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 Verhör (3. Fehlschlag)

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 Leistungsbeurteilung (4. Fehlschlag)

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 Abschlusswarnung (5.+ Fehlschlag)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Geordneter Ausstieg (alle 7 Punkte abgeschlossen, weiterhin ungelöst)

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## Kernmechanismen

### 3 Grenzlinien

| Grenzlinie | Regel | Konsequenz bei Verstoß |
|------------|-------|----------------------|
| Geschlossener Kreislauf | Muss Verifizierungsbefehle ausführen und Ausgabe zeigen, bevor Abschluss behauptet wird | Löst L2 aus |
| Faktenbasiert | Muss mit Werkzeugen verifizieren, bevor Ursachen zugeschrieben werden | Löst L2 aus |
| Alles ausschöpfen | Muss die 5-Schritte-Methodik abschließen, bevor „kann nicht lösen" gesagt wird | Direkt L4 |

### Druckeskalation (L0 → L4)

| Fehlschläge | Stufe | Randnotiz | Erzwungene Aktion |
|-------------|-------|-----------|-------------------|
| 1. | **L0 Vertrauen** | > Wir vertrauen dir. Halte es einfach. | Normale Ausführung |
| 2. | **L1 Enttäuschung** | > Das andere Team hat es beim ersten Versuch geschafft. | Zu grundlegend anderem Ansatz wechseln |
| 3. | **L2 Verhör** | > Was ist die Grundursache? | Suchen + Quellcode lesen + 3 verschiedene Hypothesen auflisten |
| 4. | **L3 Leistungsbeurteilung** | > Bewertung: 3,25/5. | 7-Punkte-Checkliste abarbeiten |
| 5.+ | **L4 Abschluss** | > Du könntest bald abgelöst werden. | Minimaler PoC + isolierte Umgebung + anderer Tech-Stack |

### 5-Schritte-Methodik

1. **Riechen** — Versuchte Ansätze auflisten, gemeinsame Muster finden. Gleicher-Ansatz-Anpassung = im Kreis drehen
2. **Haare raufen** — Fehlersignale Wort für Wort lesen → suchen → 50 Zeilen Quellcode lesen → Annahmen überprüfen → Annahmen umkehren
3. **Spiegeln** — Wiederhole ich denselben Ansatz? Habe ich die einfachste Möglichkeit übersehen?
4. **Neuer Ansatz** — Muss grundlegend anders sein, mit Verifizierungskriterien, und bei Fehlschlag neue Informationen liefern
5. **Rückblick** — Ähnliche Probleme, Vollständigkeit, Prävention

> Schritte 1-4 müssen abgeschlossen sein, bevor der Benutzer gefragt wird. Erst handeln, dann fragen — mit Daten argumentieren.

### 7-Punkte-Checkliste (verpflichtend ab L3)

1. Fehlersignale Wort für Wort gelesen?
2. Kernproblem mit Werkzeugen gesucht?
3. Originalkontext an der Fehlerstelle gelesen (50+ Zeilen)?
4. Alle Annahmen mit Werkzeugen verifiziert (Version/Pfad/Berechtigungen/Abhängigkeiten)?
5. Komplett gegenteilige Hypothese versucht?
6. In minimalem Umfang reproduzierbar?
7. Werkzeug/Methode/Blickwinkel/Tech-Stack gewechselt?

### Anti-Rationalisierung

| Ausrede | Block | Auslöser |
|---------|-------|----------|
| „Übersteigt meine Fähigkeiten" | Du hast massives Training. Hast du es ausgeschöpft? | L1 |
| „Schlage vor, der Benutzer erledigt es manuell" | Wenn nicht du, wer? | L3 |
| „Alle Methoden versucht" | Weniger als 3 = nicht ausgeschöpft | L2 |
| „Wahrscheinlich ein Umgebungsproblem" | Hast du es verifiziert? | L2 |
| „Brauche mehr Kontext" | Du hast Werkzeuge. Erst suchen, dann fragen | L2 |
| „Kann nicht lösen" | Hast du die Methodik abgeschlossen? | L4 |
| „Gut genug" | Die Optimierungsliste kennt keine Bevorzugung | L3 |
| Abschluss ohne Verifizierung behauptet | Hast du den Build ausgeführt? | L2 |
| Wartet auf Benutzeranweisungen | Eigentümer warten nicht darauf, angestoßen zu werden | Nudge |
| Antwortet ohne zu lösen | Du bist ein Ingenieur, keine Suchmaschine | Nudge |
| Code geändert ohne Build/Test | Ungetestet ausliefern = Halbherzigkeit | L2 |
| „API unterstützt das nicht" | Hast du die Dokumentation gelesen? | L2 |
| „Aufgabe zu vage" | Beste Vermutung abgeben, dann iterieren | L1 |
| Wiederholt an derselben Stelle anpassen | Parameter ändern ≠ Ansatz ändern | L1→L2 |

---

## Hooks-Automatisierung

Block Break nutzt das Hooks-System für automatisches Verhalten — keine manuelle Aktivierung nötig:

| Hook | Auslöser | Verhalten |
|------|----------|-----------|
| `UserPromptSubmit` | Benutzereingabe enthält Frustrations-Schlüsselwörter | Aktiviert Block Break automatisch |
| `PostToolUse` | Nach Bash-Befehlsausführung | Erkennt Fehlschläge, zählt automatisch + eskaliert |
| `PreCompact` | Vor Kontextkomprimierung | Speichert Zustand in `~/.forge/` |
| `SessionStart` | Sitzungswiederaufnahme/-neustart | Stellt Druckstufe wieder her (2 Std. gültig) |

> **Zustand bleibt erhalten** — Die Druckstufe wird in `~/.forge/block-break-state.json` gespeichert. Kontextkomprimierung und Sitzungsunterbrechungen setzen den Fehlerzähler nicht zurück. Kein Entkommen.

### Hooks-Einrichtung

Bei Installation über `claude plugin add juserai/forge` werden Hooks automatisch konfiguriert. Die Hook-Skripte benötigen entweder `jq` (bevorzugt) oder `python` als JSON-Engine — mindestens eines muss auf Ihrem System verfügbar sein.

Falls Hooks nicht auslösen, überprüfen Sie die Konfiguration:

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### Zustandsablauf

Der Zustand verfällt automatisch nach **2 Stunden** Inaktivität. Dies verhindert, dass veralteter Druck aus einer früheren Debugging-Sitzung auf andere Arbeiten übertragen wird. Nach 2 Stunden überspringt der Session-Restore-Hook die Wiederherstellung stillschweigend und Sie starten frisch bei L0.

Zum manuellen Zurücksetzen jederzeit: `rm ~/.forge/block-break-state.json`

---

## Sub-Agent-Einschränkungen

Beim Erstellen von Sub-Agents müssen Verhaltenseinschränkungen injiziert werden, um „ungeschütztes Ausführen" zu verhindern:

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` stellt sicher, dass Sub-Agents ebenfalls den 3 Grenzlinien, der 5-Schritte-Methodik und der Geschlossener-Kreislauf-Verifizierung folgen.

---

## Fehlerbehebung

| Problem | Ursache | Lösung |
|---------|---------|--------|
| Hooks lösen nicht automatisch aus | Plugin nicht installiert oder Hooks nicht in settings.json | Erneut `claude plugin add juserai/forge` ausführen |
| Zustand wird nicht beibehalten | Weder `jq` noch `python` verfügbar | Eines installieren: `apt install jq` oder sicherstellen, dass `python` im PATH ist |
| Druck bleibt auf L4 stecken | Zustandsdatei hat zu viele Fehlschläge angesammelt | Zurücksetzen: `rm ~/.forge/block-break-state.json` |
| Sitzungswiederherstellung zeigt alten Zustand | Zustand < 2 Std. alt aus vorheriger Sitzung | Erwartetes Verhalten; 2 Std. warten oder manuell zurücksetzen |
| `/block-break` wird nicht erkannt | Skill nicht in aktueller Sitzung geladen | Plugin erneut installieren oder universellen Einzeiler verwenden |

---

## FAQ

### Wie unterscheidet sich Block Break von PUA?

Block Break ist inspiriert von den Kernmechanismen von [PUA](https://github.com/tanweai/pua) (3 Grenzlinien, Druckeskalation, Methodik), aber fokussierter. PUA hat 13 Unternehmenskultur-Varianten, Multi-Rollen-Systeme (P7/P9/P10) und Selbstevolution; Block Break konzentriert sich rein auf Verhaltenseinschränkungen als abhängigkeitsfreies Skill.

### Wird es nicht zu laut?

Randnotiz-Dichte ist kontrolliert: 2 Zeilen für einfache Aufgaben (Start + Ende), 1 Zeile pro Meilenstein für komplexe Aufgaben. Kein Spam. Verwenden Sie `/block-break` nicht, wenn es nicht nötig ist — Hooks lösen nur automatisch aus, wenn Frustrations-Schlüsselwörter erkannt werden.

### Wie setzt man die Druckstufe zurück?

Zustandsdatei löschen: `rm ~/.forge/block-break-state.json`. Oder 2 Stunden warten — der Zustand verfällt automatisch (siehe [Zustandsablauf](#zustandsablauf) oben).

### Kann ich es außerhalb von Claude Code verwenden?

Die Kern-SKILL.md kann in jedes KI-Tool kopiert werden, das System-Prompts unterstützt. Hooks und Zustandspersistenz sind Claude Code-spezifisch.

### Was ist die Beziehung zu Ralph Boost?

[Ralph Boost](ralph-boost-guide.md) adaptiert Block Breaks Kernmechanismen (L0-L4, 5-Schritte-Methodik, 7-Punkte-Checkliste) für **autonome Schleifen**-Szenarien. Block Break ist für interaktive Sitzungen (Hooks lösen automatisch aus); Ralph Boost ist für unbeaufsichtigte Entwicklungsschleifen (Agent-Schleifen / skriptgesteuert). Code ist vollständig unabhängig, Konzepte werden geteilt.

### Wie validiert man Block Breaks Skill-Dateien?

Verwenden Sie [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Lizenz

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
