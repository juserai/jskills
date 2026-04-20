# Guide Utilisateur de Skill Lint

> Commencez en 3 minutes — validez la qualité de votre skill Claude Code

---

## Installation

### Claude Code (recommandé)

```bash
claude plugin add juserai/forge
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **Aucune dépendance** — Skill Lint ne nécessite aucun service externe ni API. Installez et c'est parti.

---

## Commandes

| Commande | Fonction | Quand utiliser |
|----------|----------|----------------|
| `/skill-lint` | Afficher les informations d'utilisation | Voir les vérifications disponibles |
| `/skill-lint .` | Vérifier le projet actuel | Auto-vérification pendant le développement |
| `/skill-lint /path/to/plugin` | Vérifier un chemin spécifique | Examiner un autre plugin |

---

## Cas d'Utilisation

### Auto-vérification après la création d'un nouveau skill

Après avoir créé `skills/<name>/SKILL.md`, `commands/<name>.md` et les fichiers associés, exécutez `/skill-lint .` pour confirmer que la structure est complète, que le frontmatter est correct et que l'entrée marketplace a été ajoutée.

### Examiner le plugin de quelqu'un d'autre

Lors de la revue d'un PR ou de l'audit d'un autre plugin, utilisez `/skill-lint /path/to/plugin` pour une vérification rapide de la complétude des fichiers et de la cohérence.

### Intégration CI

`scripts/skill-lint.sh` peut s'exécuter directement dans un pipeline CI, produisant du JSON pour une analyse automatisée :

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Éléments de Vérification

### Vérifications Structurelles (exécutées par script Bash)

| Règle | Ce qui est vérifié | Sévérité |
|-------|-------------------|----------|
| S01 | `plugin.json` existe à la racine et dans `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` existe | error |
| S03 | Chaque `skills/<name>/` contient un `SKILL.md` | error |
| S04 | Le frontmatter de SKILL.md inclut `name` et `description` | error |
| S05 | Chaque skill a un `commands/<name>.md` correspondant | warning |
| S06 | Chaque skill est listé dans le tableau `plugins` de marketplace.json | warning |
| S07 | Les fichiers de références cités dans SKILL.md existent réellement | error |
| S08 | `evals/<name>/scenarios.md` existe | warning |

### Vérifications Sémantiques (exécutées par l'IA)

| Règle | Ce qui est vérifié | Sévérité |
|-------|-------------------|----------|
| M01 | La description indique clairement l'objectif et les conditions de déclenchement | warning |
| M02 | Le nom correspond au nom du répertoire ; la description est cohérente entre les fichiers | warning |
| M03 | La logique de routage des commandes référence correctement le nom du skill | warning |
| M04 | Le contenu des références est logiquement cohérent avec SKILL.md | warning |
| M05 | Les scénarios d'évaluation couvrent les chemins de fonctionnalité principaux (au moins 5) | warning |

---

## Exemples de Sortie Attendue

### Toutes les vérifications réussies

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### Problèmes détectés

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Flux de Travail

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## FAQ

### Puis-je exécuter uniquement les vérifications structurelles, sans les vérifications sémantiques ?

Oui — exécutez le script bash directement :

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Cela produit du JSON pur sans analyse sémantique par l'IA.

### Fonctionne-t-il sur des projets non-forge ?

Oui. Tout répertoire suivant la structure standard de plugin Claude Code (`skills/`, `commands/`, `.claude-plugin/`) peut être validé.

### Quelle est la différence entre les erreurs et les avertissements ?

- **error** : Problèmes structurels qui empêcheront le skill de se charger ou de se publier correctement
- **warning** : Problèmes de qualité qui n'affecteront pas la fonctionnalité mais impactent la maintenabilité et la découvrabilité

### Autres outils forge

Skill Lint fait partie de la collection forge et fonctionne bien avec ces skills :

- [Block Break](block-break-guide.md) — Moteur de contrainte comportementale à haute capacité qui force l'IA à épuiser chaque approche
- [Ralph Boost](ralph-boost-guide.md) — Moteur de boucle de développement autonome avec garanties de convergence Block Break intégrées

Après avoir développé un nouveau skill, exécutez `/skill-lint .` pour vérifier la complétude structurelle et confirmer que le frontmatter, marketplace.json et les liens de référence sont tous corrects.

---

## Quand utiliser / Quand NE PAS utiliser

### ✅ Utilisez lorsque

- Validating a Claude Code plugin's structure before release
- Checking integrity hash / convention compliance / i18n coverage
- As a CI/CD gate for plugin repositories

### ❌ N'utilisez pas lorsque

- Non-plugin projects (rules don't apply; you'll get irrelevant errors)
- Production code quality review (not a linter / type checker / security scanner)
- License legal review (only checks the `license` field exists)

> CI structurel pour plugins Claude Code — garantit la conformité aux conventions et la cohérence des hash, pas l'exactitude runtime.

Analyse complète des limites: [references/scope-boundaries.md](../../../skills/skill-lint/references/scope-boundaries.md)

---

## Licence

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
