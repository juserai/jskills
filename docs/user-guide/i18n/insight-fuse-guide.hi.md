# Insight Fuse v3 मार्गदर्शिका

> व्यवस्थित बहु-स्रोत अनुसंधान इंजन — **7-चरण पाइपलाइन + skeleton.yaml डेटा अनुबंध + 6 अनुसंधान प्रकार प्रीसेट + 6-आयामी ऑर्थोगोनल गुणवत्ता मानक + 5 आउटपुट फॉर्मेट**।

Insight Fuse v3 किसी भी विषय को प्रकाशन योग्य अनुसंधान रिपोर्ट में बदल देता है। इंजन स्कोप अलग-थलग है (कोई CWD / IDE रिसाव नहीं), बहु-दृष्टिकोण (3 अनाम agent 4 आयामों पर स्कोर), पुनरुत्पादकता-पहले (प्रत्येक दावे का स्रोत है, प्रत्येक अनुमान लेबल किया गया है, प्रत्येक `known_dissensus` को सिंथेटिक झूठी सहमति के बजाय तीन-भाग टेम्पलेट मिलता है)।

## त्वरित प्रारंभ


```bash
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling options" --type technology --outputs report,adr,poc
/insight-fuse "AI Native: panorama, discrimination framework, trajectory" --type overview --depth full
/insight-fuse "AI Native in finance" --skeleton ~/team/skeletons/ai-native-fin.yaml
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI glasses" --audience "new entrants,investors" --strategy aggressive
```

## अनुसंधान प्रकार (6 प्रीसेट)


| `--type` | Default template | Default perspectives | Default outputs |
|---|---|---|---|
| `overview` | meta-overview | generalist, critic, specialist | report, checklist |
| `technology` | technology | generalist, critic, specialist | report, adr, checklist |
| `market` | market | generalist, specialist, futurist | report, decision-tree, checklist |
| `academic` | academic | generalist, critic, methodologist | report, checklist |
| `product` | product | user, designer, business | report, checklist, poc |
| `competitive` | competitive | generalist, critic, strategist | report, decision-tree |

**Default**: `overview`.

## 7-चरण पाइपलाइन


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

## skeleton.yaml — डेटा अनुबंध


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

## आउटपुट फॉर्मेट (5 प्रकार)


| `--outputs` | Template | Consumer |
|---|---|---|
| `report` | `templates/<type>.md` | Decision makers |
| `checklist` | `templates/checklist.md` | Implementation owners |
| `adr` | `templates/adr.md` | Architects |
| `decision-tree` | `templates/decision-tree.md` | Developers |
| `poc` | `templates/poc.md` | Validation engineers |

## गुणवत्ता आश्वासन: 14 जांच + 6D स्कोरिंग


| Dim | Academic weight | Industry weight |
|---|---|---|
| falsifiability | 0.25 | 0.15 |
| evidence_density | 0.20 | 0.15 |
| reproducibility | 0.20 | 0.10 |
| source_diversity | 0.15 | 0.20 |
| actionability | 0.05 | 0.25 |
| transparency | 0.15 | 0.15 |

**Grade**: A ≥ 8.5 / B 7.0-8.4 / C 5.5-6.9 / D < 5.5.

## सलाहकार परिशिष्ट (वैकल्पिक)

See SKILL.md § Advisory Rendering and `references/research-protocol.md` § Advisory Appendix Protocol.

## council-fuse से अंतर


| | insight-fuse | council-fuse |
|---|---|---|
| **Input** | Topic → WebSearch/WebFetch | User-provided question |
| **Output** | Research report + optional outputs | Synthesized answer |
| **Stages** | 7-stage pipeline | 3-stage |

## कब उपयोग करें / कब नहीं

- Multi-source research reports with traceable evidence chains
- Configurable-depth investigation
- Scenario research needing quality assurance

**Not for**: fast fact lookup (use `/claim-ground`), single-source deep reading, primary research requiring interviews.

## संदर्भ

- [SKILL.md](../../../skills/insight-fuse/SKILL.md)
- [skeleton schema](../../../skills/insight-fuse/references/skeleton-schema.md)
- [research-types](../../../skills/insight-fuse/references/research-types.md)
- [scoring rubric](../../../skills/insight-fuse/references/scoring-rubric.md)
- [quality standards](../../../skills/insight-fuse/references/quality-standards.md)
- [output formats](../../../skills/insight-fuse/references/output-formats.md)

