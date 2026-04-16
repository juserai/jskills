# Guide d'utilisation Insight Fuse

> Moteur systematique de recherche multi-sources — Du sujet au rapport de recherche professionnel

## Demarrage rapide

```bash
# Recherche complete (5 etapes, avec points de controle manuels)
/insight-fuse AI Agent risques de securite

# Scan rapide (Stage 1 uniquement)
/insight-fuse --depth quick informatique quantique

# Utiliser un modele specifique
/insight-fuse --template technology WebAssembly

# Recherche approfondie avec perspectives personnalisees
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist commercialisation de la conduite autonome
```

## Parametres

| Parametre | Description | Exemple |
|-----------|-------------|---------|
| `topic` | Sujet de recherche (obligatoire) | `AI Agent risques de securite` |
| `--depth` | Profondeur de recherche | `quick` / `standard` / `deep` / `full` |
| `--template` | Modele de rapport | `technology` / `market` / `competitive` |
| `--perspectives` | Liste de perspectives | `optimist,pessimist,pragmatist` |

## Modes de profondeur

### quick — Scan rapide
Execute Stage 1. 3+ requetes de recherche, 5+ sources, produit un rapport succinct. Ideal pour decouvrir rapidement un sujet.

### standard — Recherche standard
Execute Stage 1 + 3. Identifie automatiquement les sous-questions, recherche en parallele, couverture complete. Aucune interaction manuelle.

### deep — Recherche approfondie
Execute Stage 1 + 3 + 5. En complement de la recherche standard, analyse toutes les sous-questions selon 3 perspectives en profondeur. Aucune interaction manuelle.

### full (par defaut) — Pipeline complet
Execute les 5 etapes. Stage 2 et Stage 4 sont des points de controle manuels pour s'assurer que la direction reste correcte.

## Modeles de rapport

### Modeles integres

- **technology** — Recherche technologique : architecture, comparaison, ecosysteme, tendances
- **market** — Etude de marche : taille, concurrence, utilisateurs, previsions
- **competitive** — Analyse concurrentielle : matrice fonctionnelle, SWOT, tarification

### Modeles personnalises

1. Copiez `templates/custom-example.md` en `templates/your-name.md`
2. Modifiez la structure des chapitres
3. Conservez les espaces reserves `{topic}` et `{date}`
4. Le dernier chapitre doit etre « Sources de reference »
5. Activez avec `--template your-name`

### Mode sans modele

Lorsque `--template` n'est pas specifie, l'agent genere la structure du rapport de maniere adaptative en fonction du contenu de la recherche.

## Analyse multi-perspectives

### Perspectives par defaut

| Perspective | Role | Modele |
|-------------|------|--------|
| Generalist | Couverture large, consensus general | Sonnet |
| Critic | Questionnement, recherche de preuves contraires | Opus |
| Specialist | Profondeur technique, sources primaires | Sonnet |

### Ensembles de perspectives alternatifs

| Scenario | Perspectives |
|----------|-------------|
| Prevision de tendances | `--perspectives optimist,pessimist,pragmatist` |
| Recherche produit | `--perspectives user,developer,business` |
| Recherche politique | `--perspectives domestic,international,regulatory` |

### Perspectives personnalisees

Creez `agents/insight-{name}.md` en vous inspirant de la structure des fichiers d'agent existants.

## Assurance qualite

Chaque rapport est automatiquement verifie :
- Au moins 2 sources independantes par chapitre
- Aucune reference orpheline
- Une seule source ne depasse pas 40 % du total
- Toutes les affirmations comparatives sont etayees par des donnees

## Difference avec council-fuse

| | insight-fuse | council-fuse |
|---|---|---|
| **Objectif** | Recherche active + generation de rapports | Deliberation multi-perspectives sur des informations connues |
| **Source d'information** | Collecte via WebSearch/WebFetch | Questions fournies par l'utilisateur |
| **Sortie** | Rapport de recherche complet | Reponse synthetisee |
| **Etapes** | 5 etapes progressives | 3 etapes (convocation → evaluation → synthese) |

Les deux peuvent etre combines : utilisez d'abord insight-fuse pour rechercher et collecter des informations, puis council-fuse pour deliberer en profondeur sur les decisions cles.
