# Claim Ground Benutzerhandbuch

> Epistemische Disziplin in 3 Minuten — jede Aussage über den "aktuellen Moment" an Laufzeitbelege verankern

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserai/forge
```

### Universelle Ein-Zeilen-Installation

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **Null Abhängigkeiten** — Claim Ground ist reine Verhaltensbeschränkung. Keine Skripte, keine Hooks, keine externen Dienste.

---

## Funktionsweise

Claim Ground ist eine **automatisch ausgelöste** Skill. Kein Slash-Befehl — die Skill aktiviert sich nach der Art der Frage. Absichtliches Design: Faktendrift kann überall im Gespräch auftreten, und ein manueller Befehl wäre leicht zu vergessen, wenn er am nötigsten ist.

| Auslöserbedingung | Beispiel |
|-------------------|----------|
| Faktische Frage zum aktuellen Zustand | "Welches Modell läuft?" / "Welche Version ist installiert?" / "Was ist in meinem PATH?" |
| Nutzer stellt vorherige Aussage in Frage | "Wirklich?" / "Sicher?" / "Ich dachte es sei schon aktualisiert" |
| Selbstüberprüfung vor Aussage | Bevor Claude "das aktuelle X ist Y" schreibt |

---

## Kernregeln

1. **Runtime > Training** — System-Prompt, Env-Vars und Tool-Ausgaben schlagen immer das Gedächtnis. Bei Konflikt gewinnt Runtime; Quelle nennen.
2. **Zuerst zitieren, dann schließen** — Beweisfragment einfügen ("System-Prompt sagt: ...") *bevor* eine Schlussfolgerung gezogen wird.
3. **Beispiele ≠ vollständige Listen** — Ein `--model <model>` in der CLI-Hilfe ist ein Beispiel, keine vollständige Aufzählung.
4. **Hinterfragt → erneut verifizieren, nicht umformulieren** — Wenn der Nutzer widerspricht, Kontext neu lesen / Tools erneut ausführen. Die gleiche falsche Antwort umzuformulieren = Rote-Linie-Verletzung.
5. **Unsicher → unsicher sagen** — Wenn weder Kontext noch Tools verifizieren können, "Ich bin nicht sicher" sagen statt raten.

---

## Rote Linien (unverletzlich)

Rote Linien sind *dauerhaft aktive* Verbote. Eine Verletzung bedeutet, dass die Skill fehlgeschlagen ist — unabhängig davon, wie der Rest der Antwort aussieht.

| # | Rote Linie | Blockierter Halluzinationsmodus |
|---|-----------|--------------------------------|
| 1 | **Behauptung ohne Quelle** — eine Schlussfolgerung über den aktuellen Zustand ziehen, ohne Laufzeit-Beweise zu zitieren | Factuality × extrinsic hallucination |
| 2 | **Beispiel als Aufzählung** — eine vollständige Liste aus einem CLI-Help-Beispiel / Doku-Ausschnitt ableiten | Overgeneralization |
| 3 | **Umformulieren statt erneut prüfen** — dieselbe Antwort nach Nutzer-Pushback ohne neue Tool-Aufrufe wiederholen (inkl. 3a: zitierter Pushback ist riskanter) | Pushback sycophancy |
| 4 | **Code/API-Behauptung ohne Read/Grep** — behaupten, ein Symbol existiere / habe Signatur X, ohne vorher die Definitionsdatei zu lesen | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **Zitat ohne WebFetch** — URL / Paper / DOI / API-Endpoint zitieren, ohne es vorher tatsächlich abzurufen | Citation fabrication (19,9 % Basisrate laut [EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130)) |
| 6 | **Zusammenfassung ohne Zeilenverankerung** — eine Datei/PR/Log zusammenfassen, ohne pro Aussage Zeilennummern / Abschnitte zu zitieren | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

Vollständige Definitionen mit Signalen, guten/schlechten Beispielen und Grenzfällen: [references/red-lines.md](../../skills/claim-ground/references/red-lines.md).

---

## Gute / schlechte Beispiele

### Beispiel 1: aktuelles Modell

**❌ Schlecht**

> Das aktuelle Modell ist Claude Opus 4.6. Dies ist das neueste Claude-Modell.

Reine Erinnerung. Kein Zitat.

**✅ Gut**

> System-Prompt sagt: *"You are powered by the model named Opus 4.7 (1M context)"*. Das aktuelle Modell ist Opus 4.7.

### Beispiel 2: CLI-Unterstützungsliste

**❌ Schlecht**

> Die CLI-Hilfe zeigt Beispiel `claude-sonnet-4-6`, also unterstützt das CLI nur die 4.6-Serie.

**✅ Gut**

> CLI-Hilfe zeigt Beispiel `claude-sonnet-4-6` — das ist ein Platzhalter, keine vollständige Liste. Für die vollständige Liste die offiziellen Modell-Dokumente konsultieren.

### Beispiel 3: Nutzerwiderspruch

**❌ Schlecht**

> **Nutzer**: Wirklich 4.6? Ich dachte es sei aktualisiert.
> **Agent**: Ja, wie ich sagte, das neueste ist die 4.6-Serie.

**✅ Gut**

> **Nutzer**: Wirklich 4.6? Ich dachte es sei aktualisiert.
> **Agent**: Lassen Sie mich den System-Prompt erneut lesen. *"Opus 4.7 (1M context)"*. Sie haben recht — meine vorherige Antwort war falsch. Das aktuelle Modell ist Opus 4.7.

---

## Verifikations-Playbook

| Fragetyp | Primärer Beweis |
|----------|-----------------|
| Aktuelles Modell | Model-Feld im System-Prompt |
| CLI-Version / unterstützte Modelle | `<cli> --version` / `<cli> --help` + offizielle Docs |
| Installierte Pakete | `npm ls -g`, `pip show`, `brew list` |
| Env-Vars | `env`, `printenv`, `echo $VAR` |
| Datei-Existenz | `ls`, `test -e`, Read-Tool |
| Git-Status | `git branch --show-current`, `git log` |
| Aktuelles Datum | `currentDate`-Feld des System-Prompts oder `date`-Befehl |

Vollversion: `skills/claim-ground/references/playbook.md`.

---

## Interaktion mit anderen Forge-Skills

### Mit block-break

**Orthogonal, komplementär**. block-break sagt "gib nicht auf"; claim-ground sagt "behaupte nichts ohne Beweis".

Wenn beide auslösen: block-break verhindert Aufgeben, claim-ground erzwingt Neuüberprüfung.

### Mit skill-lint

**Unterschiedliche Kategorien**. skill-lint ist **anvil** (validiert statische Plugin-Dateien, gibt pass/fail aus); claim-ground ist **hammer** (beschränkt Claudes eigene epistemische Ausgabe zur Laufzeit). Keine Überschneidung der Verantwortlichkeiten.

---

## FAQ

### Warum kein Slash-Befehl?

Faktendrift kann in jeder Antwort auftreten. Ein manueller Befehl wäre in den entscheidenden Momenten leicht zu vergessen. Automatische Auslösung durch Beschreibung ist zuverlässiger.

### Löst er bei jeder Frage aus?

Nein. Nur bei zwei spezifischen Formen: **aktueller/Live-Systemzustand** oder **Nutzerwiderspruch zu einer vorherigen Aussage**.

### Was, wenn ich will, dass Claude rät?

Umformulieren als "rate fundiert über X" oder "erinnere dich aus Trainingsdaten: X". Claim Ground erkennt, dass es keine Laufzeitfrage ist.

### Woher weiß ich, ob er ausgelöst hat?

Nach Zitationsmustern in der Antwort suchen: `System-Prompt sagt: "..."`, `Befehlsausgabe: ...`. Beweis vor Schlussfolgerung = ausgelöst.

---

## Wann verwenden / Wann NICHT verwenden

### ✅ Verwenden wenn

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ Nicht verwenden wenn

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> Gateway für faktische Aussagen — garantiert Zitate, nicht deren Korrektheit, und nicht nicht-faktisches Denken.

Vollständige Grenzanalyse: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## Lizenz

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
