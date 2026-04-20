# Forge

> Travaillez plus dur, puis faites une pause. 8 skills pour un meilleur rythme de développement avec Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-8-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

### Démonstration rapide

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## Installation

```bash
# Claude Code (une seule commande)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

> Chaque skill supporte `/<skill> help` (également `--help`) pour afficher sa carte d'utilisation. Les skills à arguments obligatoires affichent aussi l'aide sans argument.

### Hammer

| Skill | Ce qu'il fait | Essayez-le |
|-------|--------------|------------|
| **block-break** | Force une résolution exhaustive des problèmes avant d'abandonner | `/block-break` |
| **ralph-boost** | Boucles de développement autonomes avec garantie de convergence | `/ralph-boost setup` |
| **claim-ground** | Ancre chaque affirmation du "moment présent" à une preuve runtime | auto-déclenché |

### Crucible

| Skill | Ce qu'il fait | Essayez-le |
|-------|--------------|------------|
| **council-fuse** | Délibération multi-perspectives pour de meilleures réponses | `/council-fuse <question>` |
| **insight-fuse** | Moteur de recherche en 7 étapes avec contrat skeleton.yaml & grille de qualité 6D | `/insight-fuse <topic>` |
| **tome-forge** | Base de connaissances personnelle avec wiki compilée par LLM | `/tome-forge init` |

### Anvil

| Skill | Ce qu'il fait | Essayez-le |
|-------|--------------|------------|
| **skill-lint** | Valide n'importe quel plugin skill Claude Code | `/skill-lint .` |

### Quench

| Skill | Ce qu'il fait | Essayez-le |
|-------|--------------|------------|
| **news-fetch** | Actualités rapides entre les sessions de développement | `/news-fetch AI today` |

---

## Block Break — Moteur de contraintes comportementales

Votre IA a abandonné ? `/block-break` la force à épuiser toutes les approches d'abord.

Lorsque Claude se retrouve bloqué, Block Break active un système d'escalade de pression qui empêche l'abandon prématuré. Il force l'agent à traverser des étapes de résolution de problèmes de plus en plus rigoureuses avant d'autoriser toute réponse de type "je ne peux pas faire ça".

| Mécanisme | Description |
|-----------|-------------|
| **3 Red Lines** | Vérification en boucle fermée / Basé sur les faits / Épuiser toutes les options |
| **Escalade de pression** | L0 Confiance → L1 Déception → L2 Interrogation → L3 Évaluation de performance → L4 Diplôme |
| **Méthode en 5 étapes** | Flairer → Tirer les cheveux → Miroir → Nouvelle approche → Rétrospective |
| **Checklist en 7 points** | Checklist de diagnostic obligatoire à partir de L3 |
| **Anti-rationalisation** | Identifie et bloque 14 schémas d'excuses courants |
| **Hooks** | Détection automatique de la frustration + comptage des échecs + persistance de l'état |

```text
/block-break              # Activer le mode Block Break
/block-break L2           # Démarrer à un niveau de pression spécifique
/block-break fix the bug  # Activer et démarrer immédiatement une tâche
```

Se déclenche également en langage naturel : `try harder`, `stop spinning`, `figure it out`, `you keep failing`, etc. (détecté automatiquement par les hooks).

> Inspiré par [PUA](https://github.com/tanweai/pua), distillé en un skill sans dépendance.

## Ralph Boost — Moteur de boucle de développement autonome

Des boucles de développement autonomes qui convergent réellement. Configuration en 30 secondes.

Reproduit la capacité de boucle autonome de ralph-claude-code sous forme de skill, avec une escalade de pression Block Break L0-L4 intégrée pour garantir la convergence. Résout le problème de "tourner en rond sans progresser" dans les boucles autonomes.

| Fonctionnalité | Description |
|----------------|-------------|
| **Boucle à double chemin** | Boucle agent (principale, zéro dépendance externe) + fallback script bash (moteurs jq/python) |
| **Disjoncteur amélioré** | Escalade de pression L0-L4 intégrée : de "abandonner après 3 tours" à "6-7 tours d'auto-sauvetage progressif" |
| **Suivi d'état** | state.json unifié pour disjoncteur + pression + stratégie + session |
| **Transfert en douceur** | L4 génère un rapport de transfert structuré au lieu d'un crash brut |
| **Indépendant** | Utilise le répertoire `.ralph-boost/`, aucune dépendance envers ralph-claude-code |

```text
/ralph-boost setup        # Initialiser le projet
/ralph-boost run          # Démarrer la boucle autonome
/ralph-boost status       # Vérifier l'état actuel
/ralph-boost clean        # Nettoyer
```

> Inspiré par [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), réimaginé en un skill sans dépendance avec garantie de convergence.

## Claim Ground — Moteur de Contrainte Épistémique

Arrêtez d'halluciner des faits obsolètes. `claim-ground` ancre chaque affirmation du "moment présent" à une preuve runtime.

Auto-déclenché (pas de commande slash). Lorsque Claude est sur le point de répondre à des questions factuelles sur l'état actuel — modèle en cours d'exécution, outils installés, variables d'environnement, valeurs de configuration — ou lorsque l'utilisateur conteste une affirmation antérieure, Claim Ground force la citation du prompt système / sortie d'outil / contenu de fichier *avant* de tirer une conclusion. Lorsqu'il est contesté, Claude revérifie au lieu de reformuler.

| Mécanisme | Description |
|-----------|-------------|
| **3 lignes rouges** | Pas d'affirmation non sourcée / Pas d'exemple-comme-exhaustif / Pas de réponse par reformulation |
| **Runtime > Training** | Prompt système, env et sortie d'outils surpassent toujours la mémoire d'entraînement |
| **Citer-puis-conclure** | Fragment de preuve brut cité en ligne avant toute conclusion |
| **Playbook de vérification** | Type de question → source de preuve (modèle / CLI / paquets / env / fichiers / git / date) |

Exemples de déclenchement (auto-détectés par description) :

- "Quel modèle tourne ?" / "What model is running?"
- "Quelle version de X est installée ?"
- "Vraiment ? / Êtes-vous sûr ? / Je pensais que c'était à jour"

Fonctionne orthogonalement avec block-break : quand les deux s'activent, block-break empêche "j'abandonne", claim-ground empêche "j'ai juste reformulé ma mauvaise réponse".

## Council Fuse — Moteur de délibération multi-perspectives

De meilleures réponses grâce au débat structuré. `/council-fuse` génère 3 perspectives indépendantes, les évalue anonymement et synthétise la meilleure réponse.

Inspiré par le [LLM Council de Karpathy](https://github.com/karpathy/llm-council) — distillé en une seule commande.

| Mécanisme | Description |
|-----------|-------------|
| **3 Perspectives** | Généraliste (équilibré) / Critique (adversarial) / Spécialiste (technique approfondi) |
| **Évaluation Anonyme** | Évaluation en 4 dimensions : Exactitude, Complétude, Praticité, Clarté |
| **Synthèse** | Réponse la mieux notée comme ossature, enrichie d'insights uniques |
| **Opinion Minoritaire** | Les opinions dissidentes valides sont préservées, pas supprimées |

```text
/council-fuse Devrions-nous utiliser des microservices ?
/council-fuse Examine ce patron de gestion des erreurs
/council-fuse Redis vs PostgreSQL pour les files de tâches
```

## Insight Fuse — Moteur de Recherche Multi-Sources Systématique (v3)

Du sujet au rapport de recherche professionnel. `/insight-fuse` exécute un pipeline en 7 étapes avec `skeleton.yaml` comme contrat de données : brainstorm → scan → align → research → review → deep dive → QA.

Analyse multi-perspectives intégrée, 6 préréglages de type de recherche (overview / technology / market / academic / product / competitive), 5 formats de sortie (report / checklist / ADR / decision-tree / PoC), et une grille de qualité à 6 dimensions avec 14 vérifications bloquantes. Le frère de la série fuse de council-fuse — tandis que council-fuse délibère sur les informations connues, insight-fuse collecte et synthétise activement de nouvelles informations.

| Mécanisme | Description |
|-----------|-------------|
| **Pipeline 7 étapes** | Brainstorm (squelette) → Scan → Align → Research → Review → Deep Dive → QA |
| **Types de recherche** | overview / technology / market / academic / product / competitive — bundle préréglé (modèle + perspectives + checks spécifiques) |
| **Profondeur configurable** | quick / standard / deep / full — quick saute Stage 2-5 ; full exécute les 7 étapes avec portes interactives |
| **Skeleton.yaml** | Contrat de données à 7 champs (dimensions / taxonomies / out_of_scope / existing_consensus / known_dissensus / hypotheses / business_neutral) consommé par chaque stage |
| **Grille de qualité** | Score 6-dim (falsifiabilité / densité de preuves / reproductibilité / diversité des sources / actionnabilité / transparence) + 14 vérifications bloquantes + note A/B/C/D |
| **Multi-sortie** | report / checklist / ADR / decision-tree / PoC — `--outputs` sélectionne les combinaisons |

```text
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling" --type technology --outputs report,adr,poc
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI Native landscape" --type overview --depth full --audience "new entrants"
```

## Tome Forge — Moteur de base de connaissances personnelle

Construisez une base de connaissances personnelle qu'un LLM compile et maintient. Basé sur le [patron LLM Wiki de Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — du Markdown brut compilé en un wiki structuré, sans RAG ni base de données vectorielle.

| Fonctionnalité | Description |
|----------------|-------------|
| **Architecture à Trois Couches** | Sources brutes (immuables) / Wiki (compilé par LLM) / Schéma (CLAUDE.md) |
| **6 Opérations** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | Section sacrée pour les insights humains — le LLM ne l'écrase jamais |
| **Zero Infra** | Markdown pur + Git. Pas de bases de données, d'embeddings ni de serveurs |

```text
/tome-forge init              # Initialiser la KB dans le répertoire courant
/tome-forge capture "idea"    # Capture rapide d'une note
/tome-forge ingest raw/paper  # Compiler le matériel brut dans le wiki
/tome-forge query "question"  # Rechercher et synthétiser
/tome-forge lint              # Vérification de santé de la structure wiki
/tome-forge compile           # Compiler par lots tous les nouveaux matériaux
```

> Inspiré par le [LLM Wiki de Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), construit comme un skill sans dépendance.

## Skill Lint — Validateur de plugins skill

Validez vos plugins Claude Code en une seule commande.

Vérifie l'intégrité structurelle et la qualité sémantique des fichiers skill dans n'importe quel projet de plugin Claude Code. Les scripts bash gèrent les vérifications structurelles, l'IA gère les vérifications sémantiques — une couverture complémentaire.

| Type de vérification | Description |
|---------------------|-------------|
| **Structurelle** | Champs requis du frontmatter / existence des fichiers / liens de référence / entrées marketplace |
| **Sémantique** | Qualité de la description / cohérence des noms / routage des commandes / couverture des évaluations |

```text
/skill-lint              # Afficher l'utilisation
/skill-lint .            # Valider le projet actuel
/skill-lint /path/to/plugin  # Valider un chemin spécifique
```

## News Fetch — Votre pause mentale entre les sprints

Épuisé par le débogage ? `/news-fetch` — votre pause mentale de 2 minutes.

Les autres skills vous poussent à travailler plus dur. Celui-ci vous rappelle de souffler un peu. Récupérez les dernières actualités sur n'importe quel sujet, directement depuis votre terminal — pas de changement de contexte, pas de spirale dans le navigateur. Juste un rapide coup d'œil et retour au travail, rafraîchi.

| Fonctionnalité | Description |
|----------------|-------------|
| **Fallback à 3 niveaux** | L1 WebSearch → L2 WebFetch (sources régionales) → L3 curl |
| **Déduplication et fusion** | Un même événement provenant de plusieurs sources est fusionné automatiquement, le score le plus élevé est conservé |
| **Score de pertinence** | L'IA note et trie par correspondance au sujet |
| **Résumé automatique** | Les résumés manquants sont générés automatiquement à partir du corps de l'article |

```text
/news-fetch AI                    # Actualités IA de la semaine
/news-fetch AI today              # Actualités IA du jour
/news-fetch robotics month        # Actualités robotique du mois
/news-fetch climate 2026-03-01~2026-03-31  # Plage de dates personnalisée
```

## Qualité

- Plus de 10 scénarios d'évaluation par skill avec tests de déclenchement automatisés
- Auto-validé par son propre skill-lint
- Zéro dépendance externe — zéro risque
- Licence MIT, entièrement open source

## Structure du projet

```text
forge/
├── skills/                        # Plateforme Claude Code
│   └── <skill>/
│       ├── SKILL.md               # Définition du skill
│       ├── references/            # Contenu détaillé (chargé à la demande)
│       ├── scripts/               # Scripts auxiliaires
│       ├── agents/                # Définitions de sous-agents
│       └── hooks/                 # Hooks Claude Code par skill (uniquement les skills propriétaires de hooks)
├── platforms/                     # Adaptations pour d'autres plateformes
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # Adaptation OpenClaw
│           ├── references/        # Contenu spécifique à la plateforme
│           └── scripts/           # Scripts spécifiques à la plateforme
├── .claude-plugin/                # Métadonnées du marketplace Claude Code
├── evals/                         # Scénarios d'évaluation multi-plateformes
├── docs/
│   ├── user-guide/                # Guides d'utilisation (anglais)
│   ├── design/                    # Documents de conception
│   └── i18n/                      # Traductions (11 languages)
│       ├── README.*.md            # README traduits
│       └── (translated guides moved to docs/user-guide/i18n/)
└── plugin.json                    # Métadonnées de la collection
```

## Contribuer

1. `skills/<name>/SKILL.md` — Skill Claude Code + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — Adaptation OpenClaw + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Scénarios d'évaluation
4. `.claude-plugin/marketplace.json` — Ajouter une entrée au tableau `plugins`
5. Hooks si nécessaire : créez `skills/<name>/hooks/hooks.json` + scripts ; le `source` dans marketplace.json doit pointer vers `./skills/<name>`

Consultez [CLAUDE.md](../../CLAUDE.md) pour les directives complètes de développement.

## Licence

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
