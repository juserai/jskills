# Hướng dẫn Insight Fuse v3

> Engine nghiên cứu đa nguồn có hệ thống — **pipeline 7 giai đoạn + hợp đồng dữ liệu skeleton.yaml + 6 preset loại nghiên cứu + thước đo chất lượng trực giao 6 chiều + 5 định dạng đầu ra**.

Insight Fuse v3.1 biến bất kỳ chủ đề nào thành báo cáo nghiên cứu có thể xuất bản. Engine cô lập phạm vi (không rò rỉ CWD / IDE), đa góc nhìn (3 agent ẩn danh chấm điểm 4 chiều), và ưu tiên khả năng tái lập (mỗi tuyên bố có nguồn, mỗi suy luận được gắn nhãn, mỗi `known_dissensus` nhận template ba phần thay vì sụp đổ thành đồng thuận tổng hợp).

## Bắt đầu nhanh


```bash
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling options" --type technology --outputs report,adr,poc
/insight-fuse "AI Native: panorama, discrimination framework, trajectory" --type overview --depth full
/insight-fuse "AI Native in finance" --skeleton ~/team/skeletons/ai-native-fin.yaml
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI glasses" --audience "new entrants,investors" --strategy aggressive
```

## Loại nghiên cứu (6 preset)


| `--type` | Default template | Default perspectives | Default outputs |
|---|---|---|---|
| `overview` | meta-overview | generalist, critic, specialist | report, checklist |
| `technology` | technology | generalist, critic, specialist | report, adr, checklist |
| `market` | market | generalist, specialist, futurist | report, decision-tree, checklist |
| `academic` | academic | generalist, critic, methodologist | report, checklist |
| `product` | product | user, designer, business | report, checklist, poc |
| `competitive` | competitive | generalist, critic, strategist | report, decision-tree |

**Default**: `overview`.

## Pipeline 7 giai đoạn


```
Stage 0 → Stage 1 → Stage 2 → Stage 3 → Stage 4 → Stage 5 → Stage 6
Brainstorm Scan   Align   Research  Review   Deep     QA
(skeleton)                                           (17 checks
                                                      + 6-dim
                                                      + outputs)
```

| `--depth` | Stages run | Interactive gates |
|---|---|---|
| `quick` | 0*, 1, 6 | none |
| `standard` (default) | 0*, 1, 3, 6 | none |
| `deep` | 0, 1, 3, 5, 6 | focus selection |
| `full` | 0, 1, 2, 3, 4, 5, 6 | Stage 0 + Stage 2 + Stage 4 |

## skeleton.yaml — hợp đồng dữ liệu


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

## Định dạng đầu ra (5 loại)


| `--outputs` | Template | Consumer |
|---|---|---|
| `report` | `templates/<type>.md` | Decision makers |
| `checklist` | `templates/checklist.md` | Implementation owners |
| `adr` | `templates/adr.md` | Architects |
| `decision-tree` | `templates/decision-tree.md` | Developers |
| `poc` | `templates/poc.md` | Validation engineers |

## Đảm bảo chất lượng: 14 kiểm tra + điểm 6D


| Dim | Academic weight | Industry weight |
|---|---|---|
| falsifiability | 0.25 | 0.15 |
| evidence_density | 0.20 | 0.15 |
| reproducibility | 0.20 | 0.10 |
| source_diversity | 0.15 | 0.20 |
| actionability | 0.05 | 0.25 |
| transparency | 0.15 | 0.15 |

**Grade**: A ≥ 8.5 / B 7.0-8.4 / C 5.5-6.9 / D < 5.5.

## Source reliability (v3.1)

Three new blocking checks tier-gated by `--type` × `--depth`:

- **Check 15** — primary-source binding: every quantitative claim (number / % / date / ranking) needs ≥1 L1 source whose host hits the [primary-source-whitelist.yaml](../../../skills/insight-fuse/references/primary-source-whitelist.yaml) for the active `--type`
- **Check 16** — verbatim evidence: each quantitative claim renders `> 原文："..." — Source, YYYY-MM-DD` inline below it; human spot-check in 30 seconds instead of clicking through URLs
- **Check 17** — numeric variance reconciliation: cross-source conflicts > 5% trigger a [reconciliation-log.md](../../../skills/insight-fuse/templates/reconciliation-log.md) appendix with primary-source tiebreak

**Inline syntax for quantitative claims**: `[Name](url){P}` for primary, `[Name](url){S→primary-url}` for secondary tracing forward. A bare `{S}` without `→` triggers Check 15 fail.

**Tier enforcement**: `market` / `academic` always blocking. Other types: advisory in `quick`, progressively blocking in `standard` / `deep` / `full`. Full matrix in [research-types.md](../../../skills/insight-fuse/references/research-types.md) §源可靠性分档.

## Advisory Appendix (tùy chọn)

See SKILL.md § Advisory Rendering and `references/research-protocol.md` § Advisory Appendix Protocol.

## Khác biệt với council-fuse


| | insight-fuse | council-fuse |
|---|---|---|
| **Input** | Topic → WebSearch/WebFetch | User-provided question |
| **Output** | Research report + optional outputs | Synthesized answer |
| **Stages** | 7-stage pipeline | 3-stage |

## Khi nào dùng / khi nào không

- Multi-source research reports with traceable evidence chains
- Configurable-depth investigation
- Scenario research needing quality assurance

**Not for**: fast fact lookup (use `/claim-ground`), single-source deep reading, primary research requiring interviews.

## Tham chiếu

- [SKILL.md](../../../skills/insight-fuse/SKILL.md)
- [skeleton schema](../../../skills/insight-fuse/references/skeleton-schema.md)
- [research-types](../../../skills/insight-fuse/references/research-types.md)
- [scoring rubric](../../../skills/insight-fuse/references/scoring-rubric.md)
- [quality standards](../../../skills/insight-fuse/references/quality-standards.md)
- [output formats](../../../skills/insight-fuse/references/output-formats.md)

