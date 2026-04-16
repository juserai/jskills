# Block Break Guide Utilisateur

> Démarrez en 5 minutes — faites en sorte que votre agent IA épuise toutes les approches

---

## Installation

### Claude Code (recommandé)

```bash
claude plugin add juserai/forge
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **Aucune dépendance** — Block Break ne nécessite aucun service externe ni API. Installez et c'est parti.

---

## Commandes

| Commande | Fonction | Quand l'utiliser |
|----------|----------|------------------|
| `/block-break` | Activer le moteur Block Break | Tâches quotidiennes, débogage |
| `/block-break L2` | Démarrer à un niveau de pression spécifique | Après plusieurs échecs connus |
| `/block-break fix the bug` | Activer et exécuter une tâche immédiatement | Démarrage rapide avec une tâche |

### Déclencheurs en langage naturel (détectés automatiquement par les hooks)

| Langue | Phrases déclencheuses |
|--------|----------------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Cas d'Utilisation

### L'IA n'a pas réussi à corriger un bug après 3 tentatives

Tapez `/block-break` ou dites `try harder` — entre automatiquement en mode d'escalade de pression.

### L'IA dit « probablement un problème d'environnement » et s'arrête

La ligne rouge « Basé sur les faits » de Block Break force la vérification par outils. Attribution non vérifiée = rejet de responsabilité → déclenche L2.

### L'IA dit « je vous suggère de gérer cela manuellement »

Déclenche le blocage « Mentalité de propriétaire » : si ce n'est pas toi, qui ? Directement L3 Évaluation de Performance.

### L'IA dit « corrigé » mais ne montre aucune preuve de vérification

Viole la ligne rouge « Boucle fermée ». Achèvement sans sortie = auto-illusion → force les commandes de vérification avec preuves.

---

## Exemples de Sortie Attendue

### `/block-break` — Activation

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

### `/block-break` — L1 Déception (2e échec)

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

### `/block-break` — L2 Interrogatoire (3e échec)

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

### `/block-break` — L3 Évaluation de Performance (4e échec)

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

### `/block-break` — L4 Avertissement de Fin de Contrat (5e+ échec)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Sortie Ordonnée (les 7 points complétés, toujours non résolu)

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

## Mécanismes Principaux

### 3 Lignes Rouges

| Ligne Rouge | Règle | Conséquence en cas de Violation |
|-------------|-------|-------------------------------|
| Boucle fermée | Doit exécuter des commandes de vérification et montrer la sortie avant de déclarer l'achèvement | Déclenche L2 |
| Basé sur les faits | Doit vérifier avec des outils avant d'attribuer des causes | Déclenche L2 |
| Tout épuiser | Doit compléter la méthodologie en 5 étapes avant de dire « impossible à résoudre » | Directement L4 |

### Escalade de Pression (L0 → L4)

| Échecs | Niveau | Barre latérale | Action Forcée |
|--------|--------|----------------|---------------|
| 1er | **L0 Confiance** | > Nous te faisons confiance. Reste simple. | Exécution normale |
| 2e | **L1 Déception** | > L'autre équipe a réussi du premier coup. | Passer à une approche fondamentalement différente |
| 3e | **L2 Interrogatoire** | > Quelle est la cause profonde ? | Rechercher + lire le code source + lister 3 hypothèses différentes |
| 4e | **L3 Évaluation de Performance** | > Note : 3,25/5. | Compléter la liste de vérification en 7 points |
| 5e+ | **L4 Fin de Contrat** | > Tu pourrais être remplacé bientôt. | PoC minimal + environnement isolé + stack technologique différent |

### Méthodologie en 5 Étapes

1. **Flairer** — Lister les approches tentées, trouver les motifs communs. Ajuster la même approche = tourner en rond
2. **S'arracher les cheveux** — Lire les signaux d'échec mot par mot → rechercher → lire 50 lignes de code source → vérifier les hypothèses → inverser les hypothèses
3. **Miroir** — Est-ce que je répète la même approche ? Ai-je manqué la possibilité la plus simple ?
4. **Nouvelle approche** — Doit être fondamentalement différente, avec des critères de vérification, et produire de nouvelles informations en cas d'échec
5. **Rétrospective** — Problèmes similaires, exhaustivité, prévention

> Les étapes 1-4 doivent être complétées avant de solliciter l'utilisateur. Agir d'abord, demander ensuite — parler avec des données.

### Liste de Vérification en 7 Points (obligatoire à partir de L3)

1. Signaux d'échec lus mot par mot ?
2. Problème central recherché avec des outils ?
3. Contexte original lu au point d'échec (50+ lignes) ?
4. Toutes les hypothèses vérifiées avec des outils (version/chemin/permissions/dépendances) ?
5. Hypothèse complètement opposée tentée ?
6. Reproductible dans un périmètre minimal ?
7. Outil/méthode/angle/stack technologique changé ?

### Anti-Rationalisation

| Excuse | Blocage | Déclencheur |
|--------|---------|-------------|
| « Au-delà de mes capacités » | Tu as un entraînement massif. L'as-tu épuisé ? | L1 |
| « Je suggère que l'utilisateur le fasse manuellement » | Si ce n'est pas toi, qui ? | L3 |
| « J'ai essayé toutes les méthodes » | Moins de 3 = pas épuisé | L2 |
| « Probablement un problème d'environnement » | L'as-tu vérifié ? | L2 |
| « Besoin de plus de contexte » | Tu as des outils. Cherche d'abord, demande ensuite | L2 |
| « Impossible à résoudre » | As-tu complété la méthodologie ? | L4 |
| « Assez bien » | La liste d'optimisation ne fait pas de favoritisme | L3 |
| Déclaré terminé sans vérification | As-tu lancé le build ? | L2 |
| En attente d'instructions utilisateur | Les propriétaires n'attendent pas qu'on les pousse | Nudge |
| Répond sans résoudre | Tu es ingénieur, pas un moteur de recherche | Nudge |
| Code modifié sans build/test | Livrer sans tester = bâcler le travail | L2 |
| « L'API ne le supporte pas » | As-tu lu la documentation ? | L2 |
| « Tâche trop vague » | Fais ta meilleure estimation, puis itère | L1 |
| Ajuste répétitivement le même endroit | Changer les paramètres ≠ changer d'approche | L1→L2 |

---

## Automatisation des Hooks

Block Break utilise le système de hooks pour un comportement automatique — aucune activation manuelle nécessaire :

| Hook | Déclencheur | Comportement |
|------|-------------|--------------|
| `UserPromptSubmit` | L'entrée utilisateur correspond à des mots-clés de frustration | Active automatiquement Block Break |
| `PostToolUse` | Après l'exécution d'une commande Bash | Détecte les échecs, compte automatiquement + escalade |
| `PreCompact` | Avant la compression du contexte | Sauvegarde l'état dans `~/.forge/` |
| `SessionStart` | Reprise/redémarrage de session | Restaure le niveau de pression (valide 2h) |

> **L'état persiste** — Le niveau de pression est stocké dans `~/.forge/block-break-state.json`. La compression du contexte et les interruptions de session ne réinitialisent pas les compteurs d'échecs. Pas d'échappatoire.

### Configuration des Hooks

Lors de l'installation via `claude plugin add juserai/forge`, les hooks sont automatiquement configurés. Les scripts de hooks nécessitent soit `jq` (préféré) soit `python` comme moteur JSON — au moins un doit être disponible sur votre système.

Si les hooks ne se déclenchent pas, vérifiez la configuration :

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### Expiration de l'état

L'état expire automatiquement après **2 heures** d'inactivité. Cela empêche la pression obsolète d'une session de débogage précédente de se reporter sur un travail non lié. Après 2 heures, le hook de restauration de session ignore silencieusement la restauration et vous repartez de zéro à L0.

Pour réinitialiser manuellement à tout moment : `rm ~/.forge/block-break-state.json`

---

## Contraintes des Sub-agents

Lors de la création de sub-agents, les contraintes comportementales doivent être injectées pour éviter une « exécution sans protection » :

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` garantit que les sub-agents suivent également les 3 lignes rouges, la méthodologie en 5 étapes et la vérification en boucle fermée.

---

## Dépannage

| Problème | Cause | Solution |
|----------|-------|----------|
| Les hooks ne se déclenchent pas automatiquement | Plugin non installé ou hooks absents de settings.json | Relancer `claude plugin add juserai/forge` |
| L'état ne persiste pas | Ni `jq` ni `python` disponibles | En installer un : `apt install jq` ou s'assurer que `python` est dans le PATH |
| Pression bloquée à L4 | Le fichier d'état a accumulé trop d'échecs | Réinitialiser : `rm ~/.forge/block-break-state.json` |
| La restauration de session montre un ancien état | État < 2h de la session précédente | Comportement attendu ; attendre 2h ou réinitialiser manuellement |
| `/block-break` non reconnu | Skill non chargé dans la session actuelle | Réinstaller le plugin ou utiliser l'installation universelle en une ligne |

---

## FAQ

### En quoi Block Break diffère-t-il de PUA ?

Block Break s'inspire des mécanismes principaux de [PUA](https://github.com/tanweai/pua) (3 lignes rouges, escalade de pression, méthodologie), mais est plus ciblé. PUA a 13 variantes de culture d'entreprise, des systèmes multi-rôles (P7/P9/P10) et de l'auto-évolution ; Block Break se concentre uniquement sur les contraintes comportementales en tant que skill sans dépendances.

### Ne sera-t-il pas trop bruyant ?

La densité de la barre latérale est contrôlée : 2 lignes pour les tâches simples (début + fin), 1 ligne par jalon pour les tâches complexes. Pas de spam. N'utilisez pas `/block-break` si ce n'est pas nécessaire — les hooks ne se déclenchent automatiquement que lorsque des mots-clés de frustration sont détectés.

### Comment réinitialiser le niveau de pression ?

Supprimer le fichier d'état : `rm ~/.forge/block-break-state.json`. Ou attendre 2 heures — l'état expire automatiquement (voir [Expiration de l'état](#expiration-de-létat) ci-dessus).

### Peut-on l'utiliser en dehors de Claude Code ?

Le SKILL.md principal peut être copié-collé dans n'importe quel outil IA supportant les prompts système. Les hooks et la persistance d'état sont spécifiques à Claude Code.

### Quelle est la relation avec Ralph Boost ?

[Ralph Boost](ralph-boost-guide.md) adapte les mécanismes principaux de Block Break (L0-L4, méthodologie en 5 étapes, liste de vérification en 7 points) aux scénarios de **boucle autonome**. Block Break est pour les sessions interactives (les hooks se déclenchent automatiquement) ; Ralph Boost est pour les boucles de développement sans surveillance (boucles d'agent / pilotées par scripts). Le code est entièrement indépendant, les concepts sont partagés.

### Comment valider les fichiers skill de Block Break ?

Utilisez [Skill Lint](skill-lint-guide.md) : `/skill-lint .`

---

## Licence

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
