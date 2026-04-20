# Guide Insight Fuse v3

> Moteur de recherche multi-sources systématique — **pipeline 7 étapes + contrat de données skeleton.yaml + 6 presets de type de recherche + grille de qualité orthogonale 6D + 5 formats de sortie**.

Insight Fuse v3 transforme n'importe quel sujet en rapport de recherche publiable. Le moteur est isolé en portée (pas de fuites CWD / IDE), multi-perspectives (3 agents anonymes notés sur 4 dimensions) et axé reproductibilité (chaque affirmation a une source, chaque inférence est étiquetée, chaque `known_dissensus` reçoit un modèle en trois parties au lieu de s'effondrer en consensus synthétique).

## Démarrage rapide


```bash
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling options" --type technology --outputs report,adr,poc
/insight-fuse "AI Native: panorama, discrimination framework, trajectory" --type overview --depth full
/insight-fuse "AI Native in finance" --skeleton ~/team/skeletons/ai-native-fin.yaml
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI glasses" --audience "new entrants,investors" --strategy aggressive
```

## Types de recherche (6 presets)


| `--type` | Default template | Default perspectives | Default outputs |
|---|---|---|---|
| `overview` | meta-overview | generalist, critic, specialist | report, checklist |
| `technology` | technology | generalist, critic, specialist | report, adr, checklist |
| `market` | market | generalist, specialist, futurist | report, decision-tree, checklist |
| `academic` | academic | generalist, critic, methodologist | report, checklist |
| `product` | product | user, designer, business | report, checklist, poc |
| `competitive` | competitive | generalist, critic, strategist | report, decision-tree |

**Default**: `overview`.

## Pipeline 7 étapes


```
Stage 0 → Stage 1 → Stage 2 → Stage 3 → Stage 4 → Stage 5 → Stage 6
Brainstorm Scan   Align   Research  Review   Deep     QA
(skeleton)                                           (14 checks
                                                      + 6-dim
                                                      + outputs)
```

| `--depth` | Stages run | Interactive gates |
|---|---|---|
| `quick` | 0*, 1, 6 | none |
| `standard` (default) | 0*, 1, 3, 6 | none |
| `deep` | 0, 1, 3, 5, 6 | focus selection |
| `full` | 0, 1, 2, 3, 4, 5, 6 | Stage 0 + Stage 2 + Stage 4 |

## skeleton.yaml — le contrat de données


```yaml
schema_version: 1
topic: "AI glasses"
research_type: overview
dimensions:
  - name: Hardware form factor
    weight: 0.25
    anchors: ["waveguide", "micro-OLED", "bone conduction"]
out_of_scope:
  - item: "VR headsets"
    reason: "Different form factor"
known_dissensus:
  - claim: "Legal boundary of always-on recording"
    position_a: {summary: "GDPR Art. 6 requires consent"}
    position_b: {summary: "Public space recording is fair use"}
hypotheses:
  - id: H1
    statement: "Waveguide cost < $50 is necessary for mass-market"
    falsifiability: "2027 product priced < $300 with > 1M sales NOT using waveguide"
business_neutral: true
```

Full schema: `skills/insight-fuse/references/skeleton-schema.md`.

## Formats de sortie (5 types)


| `--outputs` | Template | Consumer |
|---|---|---|
| `report` | `templates/<type>.md` | Decision makers |
| `checklist` | `templates/checklist.md` | Implementation owners |
| `adr` | `templates/adr.md` | Architects |
| `decision-tree` | `templates/decision-tree.md` | Developers |
| `poc` | `templates/poc.md` | Validation engineers |

## Assurance qualité : 14 vérifications + score 6D


| Dim | Academic weight | Industry weight |
|---|---|---|
| falsifiability | 0.25 | 0.15 |
| evidence_density | 0.20 | 0.15 |
| reproducibility | 0.20 | 0.10 |
| source_diversity | 0.15 | 0.20 |
| actionability | 0.05 | 0.25 |
| transparency | 0.15 | 0.15 |

**Grade**: A ≥ 8.5 / B 7.0-8.4 / C 5.5-6.9 / D < 5.5.

## Annexe consultative (opt-in)

See SKILL.md § Advisory Rendering and `references/research-protocol.md` § Advisory Appendix Protocol.

## vs council-fuse


| | insight-fuse | council-fuse |
|---|---|---|
| **Input** | Topic → WebSearch/WebFetch | User-provided question |
| **Output** | Research report + optional outputs | Synthesized answer |
| **Stages** | 7-stage pipeline | 3-stage |

## Quand utiliser / ne pas utiliser

- Multi-source research reports with traceable evidence chains
- Configurable-depth investigation
- Scenario research needing quality assurance

**Not for**: fast fact lookup (use `/claim-ground`), single-source deep reading, primary research requiring interviews.

## Références

- [SKILL.md](../../../skills/insight-fuse/SKILL.md)
- [skeleton schema](../../../skills/insight-fuse/references/skeleton-schema.md)
- [research-types](../../../skills/insight-fuse/references/research-types.md)
- [scoring rubric](../../../skills/insight-fuse/references/scoring-rubric.md)
- [quality standards](../../../skills/insight-fuse/references/quality-standards.md)
- [output formats](../../../skills/insight-fuse/references/output-formats.md)

