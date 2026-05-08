# Guide Peer Fuse v0.1.0

> Reviewer générique pour artefacts de recherche — **pipeline 8 étapes (archivage KB Stage 7 obligatoire + observable, opt-out via `--no-save`) + adaptateur d'entrée 10 formats (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, dispatch 3 niveaux) + 6 presets de type de recherche (auto-classifiés) + grille pondérée 8 dimensions + taxonomie 18 flags + panel 3 perspectives + gel § Document Reading (contrainte dure d'isolation review)**.

Peer-Fuse prend n'importe quel document markdown / PDF / Office et produit un rapport de peer-review markdown avec une note A+/A−/.../D, une liste hiérarchisée de flags qualité, une synthèse panel multi-perspectives et des suggestions de diff style patch. Il coexiste avec [le reviewer Stage 6.5 d'insight-fuse](insight-fuse-guide.md) — Stage 6.5 est une review interne IF même-source ; peer-fuse est le **reviewer externe cross-skill** qui gère les formats et skills que Stage 6.5 ne peut pas traiter.

## Démarrage rapide

```bash
# Auto-classification du type, profondeur par défaut, archivage KB
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Article académique PDF (type auto-détecté depuis l'en-tête arXiv/IEEE/Nature)
/peer-fuse papers/transformer-2017.pdf

# Deck PPTX avec type explicite
/peer-fuse decks/q4-roadmap.pptx --type product

# Profondeur quick (skip Stage 4 panel + Stage 5.5 holistique) + skip archivage KB
/peer-fuse handbook.docx --depth quick --no-save

# Afficher l'aide
/peer-fuse help
# ou sans arguments
/peer-fuse
```

## Defaults & flags

| Flag | Default | Values |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — saute l'archivage KB Stage 7, sortie console uniquement |

`--type=auto` laisse peer-fuse classifier après lecture du document via heuristiques (champ type frontmatter → pattern de section → densité de citations → indices format/titre → fallback overview). Voir [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) pour la chaîne de priorité.

## Formats supportés

| Tier | Outil requis | Formats |
|:-:|---|---|
| 1 | aucun (natif) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` pour `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Outil manquant → fail-soft avec indication d'installation concrète (`brew install pandoc`, `apt install libreoffice`, etc.) et sortie avant Stage 1. Voir [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md).

## Ce que vous obtenez en retour

Deux livrables parallèles :

1. **Review rendue inline** dans votre conversation, structurée comme suit :
   - § Document Reading — narration descriptive (ce que dit le document), 3-5 paragraphes, 300-600 mots
   - § Holistic Assessment — narration évaluative (méthodologie / forces / préoccupations / recommandation), 4 paragraphes, 400-700 mots
   - § Score Matrix — scores pondérés 8 dimensions → grade alphabétique
   - § Flag List — codes de flag de la taxonomie 18 avec positions
   - § Multi-Perspective Panel — verdicts methodologist / adversarial / practitioner
   - § Diff Suggestions — réécritures style patch pour chaque démérite
   - § Reconciliation — Δ entre target self-grade et review_grade

2. **Archive KB** à `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` (skipper avec `--no-save`). La ligne de log d'archivage `Archived to KB: <path>` apparaît toujours dans la réponse visible par l'utilisateur.

## Contrainte dure : § Document Reading est review-isolated

La décision architecturale la plus importante de peer-fuse :

**§ Document Reading ne doit pas être pollué par les verdicts de review.** C'est la lecture fidèle et descriptive du document par le reviewer — frontmatter, structure, claims, evidence, scope. Elle s'exécute à Stage 3.5, **avant** le panel Stage 4 et le scoring Stage 5, et la frontière d'entrée est stricte :

- ✅ Accepte : document original, résultats de scan factuel Stage 1-3
- ❌ Rejette : verdicts de panel, scores, hits de flag

La section est **gelée** après Stage 3.5 : un hash SHA-256 est pris avant Stage 4, et Stage 7 vérifie le hash avant archivage. Toute modification → fail-closed. Le lint interdit aussi le vocabulaire évaluatif (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) et les littéraux de grade alphabétique dans cette section.

C'est la contrainte dure énoncée par l'utilisateur, et elle est appliquée à trois niveaux : isolation architecturale + gel write-once + lint forbidden-word.

## Interaction avec les autres skills forge

| Skill | Relation |
|---|---|
| **insight-fuse** reviewer Stage 6.5 | Coexiste — Stage 6.5 est une review interne IF même-source (même grille, même heuristiques, markdown IF uniquement). peer-fuse est une **review externe cross-skill** avec une grille 8-dim plus large, 18 flags, 10 formats, panel 3 agents. Les deux devraient être exécutés pour les rapports IF importants. |
| **council-fuse** | Crucible frère — peer-fuse réutilise le pattern de dispatch sub-agent parallèle de council-fuse (le panel Stage 4 reflète le Stage 1 de council-fuse). |
| **tome-forge** | Backend d'archivage — Stage 7 de peer-fuse appelle le report-archival-protocol de tome-forge ; ne réimplémente pas la logique d'écriture KB. |
| **skill-lint** | Frère par pattern (catégorie différente, anvil) — les deux jugent des artefacts et émettent des diagnostics, mais skill-lint produit un diagnostic console éphémère tandis que peer-fuse produit un artefact peer-review markdown persistant. |

## Quand utiliser peer-fuse vs Stage 6.5 d'IF

| Scénario | À utiliser |
|---|:-:|
| Vous venez d'exécuter `/insight-fuse <topic>` et voulez une seconde opinion sur le rapport IF | Stage 6.5 d'IF s'est déjà exécuté inline ; si vous voulez une review externe de second niveau avec capacité cross-format, exécutez `/peer-fuse <if-output-path>` |
| Vous avez un article de recherche PDF tiers à évaluer | peer-fuse |
| Vous avez un deck business PPTX que vous voulez noter | peer-fuse |
| Vous avez une sortie de synthèse council-fuse que vous voulez noter | peer-fuse |
| Vous voulez comparer plusieurs artefacts sur la même grille | peer-fuse (scoring cohérent à travers les artefacts) |

## Exemple concret

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 detection
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 produces § Document Reading (frozen)
# Stage 4 panel runs 3 sub-agents in parallel
# Stage 5 scoring → 8.6 / A-
# Stage 5.5 holistic assessment
# Stage 6 diff suggestions: 5 blocks
# Stage 7 archive

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

La console rend la review complète inline ; l'archive KB est la version canonique persistante.

## Vérification

```bash
# Vérification statique
bash skills/skill-lint/scripts/skill-lint.sh .

# Test de déclenchement
bash evals/peer-fuse/run-trigger-test.sh

# Lockstep des hashes
bash scripts/recalc-all-hashes.sh
```

## Voir aussi

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — définition runtime du skill
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — décisions architecturales + justification 4 catégories
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (après merge)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — crucible frère
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — crucible frère (source du pattern panel)
