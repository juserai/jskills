# Guide d'utilisation de Council Fuse

> Demarrez en 5 minutes — deliberation multi-perspectives pour de meilleures reponses

---

## Installation

### Claude Code (recommande)

```bash
claude plugin add juserai/forge
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **Zero dependance** — Council Fuse ne necessite aucun service externe ni API. Installez et c'est parti.

---

## Commandes

| Commande | Fonction | Quand l'utiliser |
|----------|----------|------------------|
| `/council-fuse <question>` | Executer une deliberation complete du conseil | Decisions importantes, questions complexes |

---

## Fonctionnement

Council Fuse distille le pattern LLM Council de Karpathy en une seule commande :

### Etape 1 : Convoquer

Trois agents sont lances **en parallele**, chacun avec une perspective differente :

| Agent | Role | Modele | Force |
|-------|------|--------|-------|
| Generaliste | Equilibre, pratique | Sonnet | Meilleures pratiques courantes |
| Critique | Contradictoire, trouve les failles | Opus | Cas limites, risques, angles morts |
| Specialiste | Detail technique approfondi | Sonnet | Precision d'implementation |

Chaque agent repond **independamment** — ils ne peuvent pas voir les reponses des autres.

### Etape 2 : Evaluer

Le President (agent principal) anonymise toutes les reponses en Reponse A/B/C, puis note chacune sur 4 dimensions (0-10) :

- **Exactitude** — precision factuelle, coherence logique
- **Exhaustivite** — couverture de tous les aspects
- **Praticite** — applicabilite, pertinence dans le monde reel
- **Clarte** — structure, lisibilite

### Etape 3 : Synthetiser

La reponse la mieux notee devient le squelette. Les idees uniques des autres reponses sont integrees. Les objections valides du critique sont conservees comme reserves.

---

## Cas d'utilisation

### Decisions d'architecture

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

Le generaliste fournit des compromis equilibres, le critique remet en question l'engouement pour les microservices et le specialiste detaille les patterns de migration. La synthese donne une recommandation conditionnelle.

### Choix technologiques

```
/council-fuse Redis vs PostgreSQL for our job queue
```

Trois angles differents garantissent que vous ne manquez ni les preoccupations operationnelles (critique), ni les details d'implementation (specialiste), ni le choix pragmatique par defaut (generaliste).

### Revue de code

```
/council-fuse Is this error handling pattern correct? <paste code>
```

Obtenez une validation conventionnelle, une analyse contradictoire des cas limites et une verification technique approfondie en une seule passe.

---

## Structure de sortie

Chaque deliberation du conseil produit :

1. **Matrice de scores** — notation transparente des trois perspectives
2. **Analyse du consensus** — points d'accord et de desaccord
3. **Reponse synthetisee** — la meilleure reponse fusionnee
4. **Opinion minoritaire** — points de vue dissidents valides a noter

---

## Personnalisation

### Changer les perspectives

Editez `agents/*.md` pour definir des membres personnalises du conseil. Triades alternatives :

- Optimiste / Pessimiste / Pragmatique
- Architecte / Implementeur / Testeur
- Defenseur de l'utilisateur / Developpeur / Expert en securite

### Changer les modeles

Editez le champ `model:` dans chaque fichier d'agent :

- `model: haiku` — conseils economiques
- `model: opus` — poids lourds pour les decisions critiques

---

## Plateformes

| Plateforme | Fonctionnement des membres du conseil |
|------------|---------------------------------------|
| Claude Code | 3 spawns d'agents independants en parallele |
| OpenClaw | Agent unique, 3 rounds de raisonnement independants sequentiels |

---

## Quand utiliser / Quand NE PAS utiliser

### ✅ Utilisez lorsque

- Architectural decisions needing multiple perspectives
- You suspect confirmation bias in your current answer
- You want dissenting views preserved, not erased

### ❌ N'utilisez pas lorsque

- Pure factual queries (use `claim-ground` instead)
- Creative writing (synthesis flattens style)
- Speed-critical decisions (3 agents run sequentially — not fast)

> Moteur de débat basé sur les connaissances d'entraînement — révèle les angles morts d'une seule perspective, mais les conclusions restent limitées.

Analyse complète des limites: [references/scope-boundaries.md](../../../skills/council-fuse/references/scope-boundaries.md)

---

## FAQ

**Q : Est-ce que cela coute 3 fois plus de tokens ?**
R : Oui, approximativement. Trois reponses independantes plus la synthese. Utilisez-le pour les decisions qui justifient l'investissement.

**Q : Puis-je ajouter plus de membres au conseil ?**
R : Le framework le supporte — ajoutez un autre fichier `agents/*.md` et mettez a jour le workflow dans SKILL.md. Cependant, 3 est le point optimal entre cout et diversite.

**Q : Que se passe-t-il si un agent echoue ?**
R : Le President attribue un score de 0 a ce membre et synthetise a partir des reponses restantes. Degradation elegante, pas de crash.
