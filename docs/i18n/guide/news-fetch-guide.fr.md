# Guide Utilisateur de News Fetch

> Démarrez en 3 minutes — laissez l'IA récupérer votre briefing d'actualités

Épuisé par le débogage ? Prenez 2 minutes, rattrapez ce qui se passe dans le monde et revenez rafraîchi.

---

## Installation

### Claude Code (recommandé)

```bash
claude plugin add juserai/forge
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **Aucune dépendance** — News Fetch ne nécessite aucun service externe ni clé API. Installez et c'est parti.

---

## Commandes

| Commande | Fonction | Quand l'utiliser |
|----------|----------|-----------------|
| `/news-fetch AI` | Récupérer les actualités IA de la semaine | Mise à jour rapide du secteur |
| `/news-fetch AI today` | Récupérer les actualités IA du jour | Briefing quotidien |
| `/news-fetch robotics month` | Récupérer les actualités robotique du mois | Bilan mensuel |
| `/news-fetch climate 2026-03-01~2026-03-31` | Récupérer les actualités pour une période spécifique | Recherche ciblée |

---

## Cas d'Utilisation

### Briefing tech quotidien

```
/news-fetch AI today
```

Obtenez les dernières actualités IA du jour, classées par pertinence. Parcourez les titres et résumés en quelques secondes.

### Recherche sectorielle

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Récupérez les actualités d'une période spécifique pour soutenir l'analyse de marché et la veille concurrentielle.

### Actualités multilingues

Les sujets en chinois obtiennent automatiquement des recherches complémentaires en anglais pour une couverture plus large, et vice versa. Vous obtenez le meilleur des deux mondes sans effort supplémentaire.

---

## Exemple de Sortie Attendue

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## Repli Réseau à 3 Niveaux

News Fetch dispose d'une stratégie de repli intégrée pour garantir que la récupération d'actualités fonctionne dans différentes conditions réseau :

| Niveau | Outil | Source de Données | Déclencheur |
|--------|-------|-------------------|-------------|
| **L1** | WebSearch | Google/Bing | Par défaut (préféré) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 échoue |
| **L3** | Bash curl | Mêmes sources que L2 | L2 échoue également |

Lorsque tous les niveaux échouent, un rapport d'échec structuré est produit listant la raison de l'échec pour chaque source.

---

## Fonctionnalités de Sortie

| Fonctionnalité | Description |
|----------------|-------------|
| **Déduplication** | Lorsque plusieurs sources couvrent le même événement, l'entrée avec le score le plus élevé est conservée ; les autres sont regroupées dans « Couverture associée » |
| **Complétion de résumé** | Si les résultats de recherche manquent de résumé, le corps de l'article est récupéré et un résumé est généré |
| **Score de pertinence** | L'IA note chaque résultat par pertinence thématique — plus c'est élevé, plus c'est pertinent |
| **Liens cliquables** | Format de lien Markdown — cliquable dans les IDE et terminaux |

---

## Score de Pertinence

Chaque article est noté de 0 à 300 selon la correspondance entre son titre et son résumé avec le sujet demandé :

| Plage de Score | Signification |
|----------------|---------------|
| 200-300 | Très pertinent — le sujet est le thème principal |
| 100-199 | Modérément pertinent — le sujet est mentionné de manière significative |
| 0-99 | Tangentiellement pertinent — le sujet apparaît en passant |

Les articles sont triés par score en ordre décroissant. Le score est heuristique et basé sur la densité de mots-clés, la correspondance du titre et la pertinence contextuelle.

## Dépannage du Repli Réseau

| Symptôme | Cause Probable | Solution |
|----------|---------------|----------|
| L1 renvoie 0 résultat | Outil WebSearch indisponible ou requête trop spécifique | Élargir le mot-clé du sujet |
| L2 toutes les sources échouent | Sites d'actualités nationaux bloquant l'accès automatisé | Attendre et réessayer, ou vérifier si `curl` fonctionne manuellement |
| L3 curl délais d'attente | Problème de connectivité réseau | Vérifier `curl -I https://news.baidu.com` |
| Tous les niveaux échouent | Pas d'accès internet ou toutes les sources hors service | Vérifier le réseau ; le rapport d'échec liste l'erreur de chaque source |

---

## FAQ

### Ai-je besoin d'une clé API ?

Non. News Fetch repose entièrement sur WebSearch et le scraping web public. Aucune configuration requise.

### Peut-il récupérer des actualités en anglais ?

Absolument. Les sujets en chinois incluent automatiquement des recherches complémentaires en anglais, et les sujets en anglais fonctionnent nativement. La couverture s'étend aux deux langues.

### Que faire si mon réseau est restreint ?

La stratégie de repli à 3 niveaux gère cela automatiquement. Même si WebSearch n'est pas disponible, News Fetch se rabat sur les sources d'actualités nationales.

### Combien d'articles sont renvoyés ?

Jusqu'à 20 (après déduplication). Le nombre réel dépend de ce que les sources de données renvoient.

---

## Licence

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
