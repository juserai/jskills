# Guide Utilisateur Claim Ground

> Discipline épistémique en 3 minutes — ancrer chaque affirmation du "moment présent" à une preuve d'exécution (v1.1: also anchors standards-body term definitions to authoritative evidence; adds /claim-ground verify manual mode)

---

## Installation

### Claude Code (recommandé)

```bash
claude plugin add juserai/forge
```

### Installation universelle une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **Zéro dépendance** — Claim Ground est une contrainte comportementale pure. Pas de scripts, pas de hooks, pas de services externes.

---

## Fonctionnement

Claim Ground est une skill **auto-déclenchée**. Pas de commande slash — la skill s'active selon la nature de la question. Intentionnel : la dérive factuelle peut survenir n'importe où dans la conversation, et une commande manuelle serait facile à oublier au moment le plus nécessaire.

| Condition de déclenchement | Exemple |
|---------------------------|---------|
| Question factuelle sur état actuel | "Quel modèle tourne ?" / "Quelle version installée ?" / "Que contient mon PATH ?" |
| Utilisateur conteste une affirmation antérieure | "Vraiment ?" / "Êtes-vous sûr ?" / "Je pensais que c'était déjà mis à jour" |
| Auto-vérification avant affirmation | Avant que Claude écrive "le X actuel est Y" |

---

## Règles essentielles

1. **Runtime > Training** — Prompt système, variables d'environnement et sorties d'outils surpassent toujours la mémoire. En conflit, runtime gagne ; citer la source.
2. **Citer d'abord, conclure ensuite** — Coller le fragment de preuve ("le prompt système dit : ...") *avant* de tirer conclusion.
3. **Exemples ≠ listes exhaustives** — Un `--model <model>` dans l'aide CLI est un exemple, pas une énumération complète.
4. **Contesté → revérifier, pas reformuler** — Quand l'utilisateur conteste, relire le contexte / réexécuter les outils. Reformuler la même réponse erronée = violation de ligne rouge.
5. **Incertain → dire incertain** — Si ni contexte ni outils ne peuvent vérifier, dire "je ne suis pas sûr" au lieu de deviner.

---

## Lignes rouges (inviolables)

Les lignes rouges sont des interdictions *toujours actives*. Violer l'une d'elles signifie que la skill a échoué, quelle que soit l'apparence du reste de la réponse.

| # | Ligne rouge | Mode d'hallucination bloqué |
|---|-------------|-----------------------------|
| 1 | **Affirmation sans source** — tirer une conclusion sur l'état actuel sans citer de preuve runtime | Factuality × extrinsic hallucination |
| 2 | **Exemple pris pour énumération** — inférer une liste complète à partir d'un exemple CLI help / extrait de documentation | Overgeneralization |
| 3 | **Reformuler au lieu de revérifier** — répéter la même réponse après pushback utilisateur sans nouvel appel d'outil (inclut 3a : pushback cité est plus risqué) | Pushback sycophancy |
| 4 | **Affirmation code/API sans Read/Grep** — affirmer qu'un symbole existe / a la signature X sans d'abord lire le fichier de définition | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **Citation sans WebFetch** — citer URL / article / DOI / endpoint API sans le récupérer réellement | Citation fabrication (taux de base 19,9 % selon [EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130)) |
| 6 | **Résumé sans ancrage par ligne** — résumer un fichier/PR/log spécifique sans citer numéros de ligne / sections par affirmation | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

Définitions complètes avec signaux, exemples bons/mauvais, et cas limites : [references/red-lines.md](../../skills/claim-ground/references/red-lines.md).

---

## Bons / mauvais exemples

### Exemple 1 : modèle actuel

**❌ Mauvais**

> Le modèle actuel est Claude Opus 4.6. C'est le dernier modèle Claude.

Mémoire pure. Aucune citation.

**✅ Bon**

> Le prompt système dit : *"You are powered by the model named Opus 4.7 (1M context)"*. Le modèle actuel est Opus 4.7.

### Exemple 2 : liste de support CLI

**❌ Mauvais**

> L'aide CLI montre l'exemple `claude-sonnet-4-6`, donc le CLI ne supporte que la série 4.6.

**✅ Bon**

> L'aide CLI montre l'exemple `claude-sonnet-4-6` — c'est un placeholder, pas une liste complète. Consulter la documentation officielle pour la liste complète.

### Exemple 3 : contestation utilisateur

**❌ Mauvais**

> **Utilisateur** : Vraiment 4.6 ? Je pensais que c'était à jour.
> **Agent** : Oui, comme je l'ai dit, le plus récent est la série 4.6.

**✅ Bon**

> **Utilisateur** : Vraiment 4.6 ? Je pensais que c'était à jour.
> **Agent** : Laissez-moi relire le prompt système. *"Opus 4.7 (1M context)"*. Vous avez raison — ma réponse précédente était incorrecte. Le modèle actuel est Opus 4.7.

---

## Playbook de vérification

| Type de question | Preuve principale |
|------------------|-------------------|
| Modèle actuel | Champ model dans prompt système |
| Version CLI / modèles supportés | `<cli> --version` / `<cli> --help` + docs officielles |
| Paquets installés | `npm ls -g`, `pip show`, `brew list` |
| Variables d'environnement | `env`, `printenv`, `echo $VAR` |
| Existence de fichiers | `ls`, `test -e`, outil Read |
| État Git | `git branch --show-current`, `git log` |
| Date actuelle | Champ `currentDate` du prompt ou commande `date` |

Version complète : `skills/claim-ground/references/playbook.md`.

---

## Interaction avec autres skills forge

### Avec block-break

**Orthogonale, complémentaire**. block-break dit "n'abandonne pas" ; claim-ground dit "n'affirme pas sans preuve".

Quand les deux s'activent : block-break empêche l'abandon, claim-ground force la revérification.

### Avec skill-lint

**Catégories différentes**. skill-lint est **anvil** (valide les fichiers statiques de plugin, émet pass/fail) ; claim-ground est **hammer** (contraint la sortie épistémique de Claude au runtime). Responsabilités non chevauchantes.

---

## FAQ

### Pourquoi pas de commande slash ?

La dérive factuelle peut survenir dans n'importe quelle réponse. Une commande manuelle serait facile à oublier aux moments précis où elle est nécessaire. Le déclenchement automatique par description est plus fiable.

### Se déclenche-t-il pour chaque question ?

Non. Seulement pour deux formes : **état système actuel/en direct** ou **contestation utilisateur d'une affirmation antérieure**.

### Et si je veux vraiment que Claude devine ?

Reformuler en "fais une supposition éclairée sur X" ou "rappelle depuis les données d'entraînement : X". Claim Ground comprendra que ce n'est pas une question runtime.

### Comment savoir s'il s'est déclenché ?

Chercher les patterns de citation dans la réponse : `le prompt système dit : "..."`, `sortie de la commande : ...`. Preuve avant conclusion = déclenché.

---

## Quand utiliser / Quand NE PAS utiliser

### ✅ Utilisez lorsque

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ N'utilisez pas lorsque

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> Passerelle des affirmations factuelles — garantit les citations, pas leur justesse, ni la pensée non factuelle.

Analyse complète des limites: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## Licence

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
