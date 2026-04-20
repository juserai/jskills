# Guide Utilisateur de Tome Forge

> Demarrez en 5 minutes — base de connaissances personnelle avec wiki compile par LLM

---

## Installation

### Claude Code (recommande)

```bash
claude plugin add juserai/forge
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **Zero dependance** — Tome Forge ne necessite aucun service externe, aucune base de donnees vectorielle, aucune infrastructure RAG. Installez et c'est parti.

---

## Commandes

| Commande | Ce qu'elle fait | Quand l'utiliser |
|----------|----------------|------------------|
| `/tome-forge init` | Initialiser une base de connaissances | Demarrer une nouvelle KB dans n'importe quel repertoire |
| `/tome-forge capture [text]` | Capture rapide de note, lien ou presse-papiers | Noter des idees, sauvegarder des URLs, copier du contenu |
| `/tome-forge capture clip` | Capturer depuis le presse-papiers systeme | Sauvegarde rapide du contenu copie |
| `/tome-forge ingest <path>` | Compiler le materiel brut en wiki | Apres avoir ajoute des articles, papiers ou notes dans `raw/` |
| `/tome-forge ingest <path> --dry-run` | Apercu du routage sans ecriture | Verifier avant de valider les modifications |
| `/tome-forge query <question>` | Rechercher et synthetiser depuis le wiki | Trouver des reponses dans toute la base de connaissances |
| `/tome-forge lint` | Verification de sante de la structure du wiki | Avant les commits, maintenance periodique |
| `/tome-forge compile` | Compiler par lots tous les nouveaux materiels bruts | Rattraper apres l'ajout de plusieurs fichiers bruts |

---

## Comment Ca Marche

Base sur le modele LLM Wiki de Karpathy :

```
raw materials + LLM compilation = structured Markdown wiki
```

### L'Architecture a Deux Couches

| Couche | Proprietaire | Objectif |
|--------|-------------|----------|
| `raw/` | Vous | Materiaux sources immuables — papiers, articles, notes, liens |
| `wiki/` | LLM | Pages Markdown compilees, structurees et a references croisees |

Le LLM lit vos materiaux bruts et les compile en pages wiki bien structurees. Vous ne modifiez jamais `wiki/` directement — vous ajoutez des materiaux bruts et laissez le LLM maintenir le wiki.

### La Section Sacree

Chaque page wiki a une section `## Mon Delta de Comprehension`. Celle-ci est **la votre** — le LLM ne la modifiera jamais. Ecrivez ici vos reflexions personnelles, desaccords ou intuitions. Elle survit a toutes les recompilations.

---

## Decouverte de KB — Ou Vont Mes Donnees ?

Vous pouvez executer `/tome-forge` depuis **n'importe quel repertoire**. Il trouve automatiquement la bonne KB :

| Situation | Ce qui se passe |
|-----------|----------------|
| Le repertoire actuel (ou parent) contient `.tome-forge.json` | Utilise cette KB |
| Aucun `.tome-forge.json` trouve en remontant | Utilise le defaut `~/.tome-forge/` (cree automatiquement si necessaire) |

Cela signifie que vous pouvez capturer des notes depuis n'importe quel projet sans faire `cd` d'abord — tout est canalise vers votre unique KB par defaut.

Vous voulez des KBs separees par projet ? Utilisez `init .` dans le repertoire du projet.

## Flux de Travail

### 1. Initialiser

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

Apres l'initialisation, le repertoire KB ressemble a ceci :

```
~/.tome-forge/               # (or wherever you initialized)
├── .tome-forge.json         # KB marker (auto-generated)
├── CLAUDE.md                # KB schema and rules
├── index.md                 # Wiki page index
├── .gitignore
├── logs/                    # Operation logs (monthly rotation)
│   └── 2026-04.md           # One file per month, never grows too large
├── raw/                     # Your source materials (immutable)
└── wiki/                    # LLM-compiled wiki (auto-maintained)
```

### 2. Capturer

Depuis **n'importe quel repertoire**, executez simplement :

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

Les captures rapides vont dans `raw/captures/{date}/`. Pour les materiaux plus longs, deposez les fichiers directement dans `raw/papers/`, `raw/articles/`, etc.

### 3. Ingerer

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

Le LLM lit le fichier brut, le dirige vers la ou les bonne(s) page(s) wiki et fusionne les nouvelles informations tout en preservant vos notes personnelles.

### 4. Interroger

```
/tome-forge query "what is the relationship between attention and transformers?"
```

Synthetise une reponse depuis votre wiki en citant des pages specifiques. Vous indique si des informations manquent et quel materiel brut ajouter.

### 5. Maintenir

```
/tome-forge lint
/tome-forge compile
```

Lint verifie l'integrite structurelle. Compile ingere par lots tout ce qui est nouveau depuis la derniere compilation.

---

## Structure des Repertoires

```
my-knowledge-base/
├── .tome-forge.json       # KB marker (auto-generated)
├── CLAUDE.md              # Schema and rules (auto-generated)
├── index.md               # Wiki page index
├── .last_compile          # Timestamp for batch compile
├── logs/                  # Operation logs (monthly rotation)
│   └── 2026-04.md
├── raw/                   # Your source materials (immutable)
│   ├── captures/          # Quick captures by date
│   ├── papers/            # Academic papers
│   ├── articles/          # Blog posts, articles
│   ├── books/             # Book notes
│   └── conversations/     # Chat logs, interviews
└── wiki/                  # LLM-compiled wiki (auto-maintained)
    ├── ai/                # Domain directories
    ├── systems/
    └── ...
```

---

## Format de Page Wiki

Chaque page wiki suit un modele strict :

```yaml
---
domain: ai
maturity: growing        # draft | growing | stable | deprecated
last_compiled: 2026-04-15
source_refs:
  - raw/papers/attention.md
confidence: medium       # low | medium | high
compiled_by: claude-opus-4-6
---
```

Sections requises :
- **Concept Central** — Connaissances maintenues par le LLM
- **Mon Delta de Comprehension** — Vos reflexions personnelles (jamais touchees par le LLM)
- **Questions Ouvertes** — Questions sans reponse
- **Connexions** — Liens vers des pages wiki associees

---

## Cadence Recommandee

| Frequence | Action | Temps |
|-----------|--------|-------|
| **Quotidien** | `capture` pour idees, liens, presse-papiers | 2 min |
| **Hebdomadaire** | `compile` pour traiter par lots les materiaux de la semaine | 15-30 min |
| **Mensuel** | `lint` + revoir les sections Mon Delta de Comprehension | 30 min |

**Evitez l'ingestion en temps reel.** Les ingestions frequentes de fichiers individuels fragmentent la coherence du wiki. La compilation hebdomadaire par lots produit de meilleures references croisees et des pages plus coherentes.

---

## Feuille de Route de Mise a l'Echelle

| Phase | Taille du Wiki | Strategie |
|-------|---------------|-----------|
| 1. Demarrage a froid (semaine 1-4) | < 30 pages | Lecture de contexte complet, routage par index.md |
| 2. Regime stable (mois 2-3) | 30-100 pages | Fragmentation par sujet (wiki/ai/, wiki/systems/) |
| 3. Mise a l'echelle (mois 4-6) | 100-200 pages | Requetes par fragment, complement ripgrep |
| 4. Avance (6+ mois) | 200+ pages | Routage base sur les embeddings (pas la recuperation), compilation incrementale |

---

## Risques Connus

| Risque | Impact | Attenuation |
|--------|--------|-------------|
| **Derive de formulation** | Les compilations multiples lissent la voix personnelle | `compiled_by` suit le modele ; raw/ est la source de verite ; recompiler depuis raw a tout moment |
| **Plafond de mise a l'echelle** | La fenetre de contexte limite la taille du wiki | Fragmenter par domaine ; utiliser le routage par index ; couche d'embeddings quand > 200 pages |
| **Dependance au fournisseur** | Lie a un seul fournisseur LLM | Les sources brutes sont du Markdown pur ; changer de modele et recompiler |
| **Corruption du Delta** | Le LLM ecrase les reflexions personnelles | Verification diff post-ingestion restaure automatiquement le Delta original |

---

## Plateformes

| Plateforme | Fonctionnement |
|------------|---------------|
| Claude Code | Acces complet au systeme de fichiers, lectures paralleles, integration git |
| OpenClaw | Memes operations, adaptees aux conventions d'outils OpenClaw |

---

## Quand utiliser / Quand NE PAS utiliser

### ✅ Utilisez lorsque

- Building a personal knowledge base from scattered notes
- You want LLM-compiled wiki that preserves human insights
- Zero-infra solution (just Markdown + Git)

### ❌ N'utilisez pas lorsque

- Team collaboration or real-time sync
- Ad-hoc notes (too structured — plain Markdown is fine)
- Transactional data (use a real database)

> Bibliothèque personnelle compilée par LLM — préserve les insights humains, conçue pour individus, sans sync temps réel.

Analyse complète des limites: [references/scope-boundaries.md](../../../skills/tome-forge/references/scope-boundaries.md)

---

## FAQ

**Q : Quelle taille peut atteindre le wiki ?**
R : Moins de 50 pages, le LLM lit tout. De 50 a 200 pages, il utilise l'index pour naviguer. Au-dela de 200, envisagez la fragmentation par domaine.

**Q : Puis-je editer les pages wiki directement ?**
R : Seulement la section `## Mon Delta de Comprehension`. Tout le reste sera ecrase lors de la prochaine ingestion/compilation.

**Q : Faut-il une base de donnees vectorielle ?**
R : Non. Le wiki est du Markdown pur. Le LLM lit les fichiers directement — pas d'embeddings, pas de RAG, pas d'infrastructure.

**Q : Comment sauvegarder ma KB ?**
R : Ce sont tous des fichiers dans un depot git. `git push` et c'est fait.

**Q : Que faire si le LLM fait une erreur dans le wiki ?**
R : Ajoutez une correction dans `raw/` et re-ingerez. L'algorithme de fusion prefere les sources plus autoritaires. Ou notez vos desaccords dans votre Mon Delta de Comprehension.
