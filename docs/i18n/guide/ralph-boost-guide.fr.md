# Guide utilisateur de Ralph Boost

> Démarrez en 5 minutes — empêchez votre boucle de développement autonome IA de stagner

---

## Installation

### Claude Code (recommandé)

```bash
claude plugin add juserai/forge
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **Zéro dépendance** — Ralph Boost ne dépend pas de ralph-claude-code, block-break ou de tout service externe. Le chemin principal (boucle Agent) n'a aucune dépendance externe ; le chemin de secours nécessite `jq` ou `python` et la CLI `claude`.

---

## Commandes

| Commande | Fonction | Quand l'utiliser |
|----------|----------|------------------|
| `/ralph-boost setup` | Initialiser la boucle autonome dans votre projet | Première configuration |
| `/ralph-boost run` | Démarrer la boucle autonome dans la session actuelle | Après l'initialisation |
| `/ralph-boost status` | Voir l'état actuel de la boucle | Surveiller la progression |
| `/ralph-boost clean` | Supprimer les fichiers de la boucle | Nettoyage |

---

## Démarrage rapide

### 1. Initialiser le projet

```text
/ralph-boost setup
```

Claude vous guidera à travers :
- Détection du nom du projet
- Génération d'une liste de tâches (fix_plan.md)
- Création du répertoire `.ralph-boost/` et de tous les fichiers de configuration

### 2. Démarrer la boucle

```text
/ralph-boost run
```

Claude pilote la boucle autonome directement dans la session actuelle (mode boucle Agent). Chaque itération génère un sous-agent pour exécuter une tâche, tandis que la session principale agit comme contrôleur de boucle gérant l'état.

**Secours** (environnements sans interface / non surveillés) :

```bash
# Premier plan
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Arrière-plan
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Surveiller l'état

```text
/ralph-boost status
```

Exemple de sortie :

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## Fonctionnement

### Boucle autonome

Ralph Boost propose deux chemins d'exécution :

**Chemin principal (boucle Agent)** : Claude agit comme contrôleur de boucle dans la session actuelle, générant un sous-agent à chaque itération pour exécuter les tâches. La session principale gère l'état, le circuit breaker et l'escalade de pression. Aucune dépendance externe.

**Secours (script bash)** : `boost-loop.sh` exécute des appels `claude -p` en boucle en arrière-plan. Supporte jq et python comme moteurs JSON, auto-détectés à l'exécution. Le délai d'attente par défaut entre les itérations est de 1 heure (configurable).

Les deux chemins partagent la même gestion d'état (state.json), la même logique d'escalade de pression et le même protocole BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Circuit Breaker amélioré (vs ralph-claude-code)

Circuit breaker de ralph-claude-code : abandonne après 3 boucles consécutives sans progrès.

Circuit breaker de ralph-boost : **escalade la pression progressivement** en cas de blocage, jusqu'à 6-7 boucles d'auto-récupération avant l'arrêt.

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## Exemples de sortie attendue

### L0 — Exécution normale

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — Changement d'approche

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude est contraint d'abandonner l'approche précédente et d'essayer quelque chose de **fondamentalement différent**. Ajuster les paramètres ne compte pas.

### L2 — Rechercher et formuler des hypothèses

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude doit : lire l'erreur mot par mot → rechercher 50+ lignes de contexte → lister 3 hypothèses différentes.

### L3 — Liste de vérification

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude doit compléter la liste de vérification en 7 points (lire les signaux d'erreur, chercher le problème central, lire le code source, vérifier les hypothèses, hypothèse inverse, reproduction minimale, changer d'outils/méthodes). Chaque point complété est écrit dans state.json.

### L4 — Transfert ordonné

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude construit un PoC minimal, puis génère un rapport de transfert :

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

Une fois le transfert terminé, la boucle s'arrête de manière ordonnée. Ce n'est pas « je ne peux pas » — c'est « voici où se trouve la limite. »

---

## Configuration

`.ralph-boost/config.json` :

| Champ | Par défaut | Description |
|-------|------------|-------------|
| `max_calls_per_hour` | 100 | Nombre maximum d'appels à l'API Claude par heure |
| `claude_timeout_minutes` | 15 | Délai d'attente par appel individuel |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Outils disponibles pour Claude |
| `claude_model` | "" | Remplacement du modèle (vide = par défaut) |
| `session_expiry_hours` | 24 | Durée d'expiration de la session |
| `no_progress_threshold` | 7 | Seuil sans progrès avant l'arrêt |
| `same_error_threshold` | 8 | Seuil de même erreur avant l'arrêt |
| `sleep_seconds` | 3600 | Temps d'attente entre les itérations (secondes) |

### Ajustements de configuration courants

**Accélérer la boucle** (pour les tests) :

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Restreindre les permissions d'outils** :

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Utiliser un modèle spécifique** :

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Structure du répertoire du projet

```
.ralph-boost/
├── PROMPT.md           # Instructions de développement (inclut le protocole block-break)
├── fix_plan.md         # Liste de tâches (mise à jour automatiquement par Claude)
├── config.json         # Configuration
├── state.json          # État unifié (circuit breaker + pression + session)
├── handoff-report.md   # Rapport de transfert L4 (généré à la sortie ordonnée)
├── logs/
│   ├── boost.log       # Journal de la boucle
│   └── claude_output_*.log  # Sortie par itération
└── .gitignore          # Ignore l'état et les journaux
```

Tous les fichiers restent dans `.ralph-boost/` — la racine de votre projet n'est jamais touchée.

---

## Relation avec ralph-claude-code

Ralph Boost est un **remplacement indépendant** de [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), pas un plugin d'amélioration.

| Aspect | ralph-claude-code | ralph-boost |
|--------|-------------------|-------------|
| Forme | Outil Bash autonome | Skill Claude Code (boucle Agent) |
| Installation | `npm install` | Plugin Claude Code |
| Taille du code | 2000+ lignes | ~400 lignes |
| Dépendances externes | jq (requis) | Chemin principal : zéro ; Secours : jq ou python |
| Répertoire | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Passif (abandonne après 3 boucles) | Actif (L0-L4, 6-7 boucles d'auto-récupération) |
| Coexistence | Oui | Oui (aucun conflit de fichiers) |

Les deux peuvent être installés simultanément dans le même projet — ils utilisent des répertoires séparés et n'interfèrent pas entre eux.

---

## Relation avec Block Break

Ralph Boost adapte les mécanismes centraux de Block Break (escalade de pression, méthodologie en 5 étapes, liste de vérification) aux scénarios de boucle autonome :

| Aspect | block-break | ralph-boost |
|--------|-------------|-------------|
| Scénario | Sessions interactives | Boucles autonomes |
| Activation | Les hooks se déclenchent automatiquement | Intégré dans la boucle Agent / script de boucle |
| Détection | Hook PostToolUse | Détection de progrès de la boucle Agent / détection de progrès du script |
| Contrôle | Prompts injectés par les hooks | Injection de prompts Agent / --append-system-prompt |
| État | `~/.forge/` | `.ralph-boost/state.json` |

Le code est entièrement indépendant ; les concepts sont partagés.

> **Référence** : L'escalade de pression (L0-L4), la méthodologie en 5 étapes et la liste de vérification en 7 points de Block Break forment la base conceptuelle du circuit breaker de ralph-boost. Voir le [Guide utilisateur de Block Break](block-break-guide.md) pour les détails.

---

## FAQ

### Comment choisir entre le chemin principal et le secours ?

`/ralph-boost run` utilise la boucle Agent (chemin principal) par défaut, s'exécutant directement dans la session Claude Code actuelle. Utilisez le script bash de secours lorsque vous avez besoin d'une exécution sans interface ou non surveillée.

### Où se trouve le script de boucle ?

Après l'installation du plugin forge, le script de secours se trouve à `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`. Vous pouvez également le copier n'importe où et l'exécuter de là. Le script auto-détecte jq ou python comme moteur JSON.

### Comment voir les journaux de la boucle ?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Comment réinitialiser manuellement le niveau de pression ?

Modifiez `.ralph-boost/state.json` : définissez `pressure.level` à 0 et `circuit_breaker.consecutive_no_progress` à 0. Ou supprimez simplement state.json et réinitialisez.

### Comment modifier la liste de tâches ?

Modifiez `.ralph-boost/fix_plan.md` directement, en utilisant le format `- [ ] tâche`. Claude la lit au début de chaque itération.

### Comment récupérer après l'ouverture du circuit breaker ?

Modifiez `state.json`, définissez `circuit_breaker.state` à `"CLOSED"`, réinitialisez les compteurs concernés et relancez le script.

### Ai-je besoin de ralph-claude-code ?

Non. Ralph Boost est entièrement indépendant et ne dépend d'aucun fichier Ralph.

### Quelles plateformes sont supportées ?

Actuellement supporte Claude Code (boucle Agent comme chemin principal). Le script bash de secours nécessite bash 4+, jq ou python et la CLI claude.

### Comment valider les fichiers de skill de ralph-boost ?

Utilisez [Skill Lint](skill-lint-guide.md) : `/skill-lint .`

---

## Licence

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
