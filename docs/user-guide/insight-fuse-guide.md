# Insight Fuse v3.3 Guide

> Systematic multi-source research engine — **8-stage pipeline (Stage 7 KB archival mandatory + observable, opt-out via `--no-save`) + skeleton.yaml data contract + 6 research-type presets + 6-dimensional quality rubric + 17 blocking checks (incl. primary-source binding / verbatim snippet / numeric reconciliation, v3.1) + 5 output formats with multi-file default and `--merge` opt-in single-file**.

Insight Fuse v3.3 turns any topic into a publishable research report. The engine is scoped isolation (no CWD / IDE leakage), multi-perspective (3 anonymous agents scored on 4 dimensions), and reproducibility-first (every claim has a source, every inference is labeled, every `known_dissensus` gets a three-part template instead of collapsing into synthetic consensus).

## Quick start

```bash
# Overview research (default type, standard depth) — produces report + checklist
/insight-fuse "AI glasses"

# Technology selection with ADR + PoC outputs (default: 3 separate .md files)
/insight-fuse "Kubernetes autoscaling options" --type technology --sections report,adr,poc

# Same selection but bundled into one merged markdown
/insight-fuse "Kubernetes autoscaling options" --type technology --sections report,adr,poc --merge

# Full pipeline with interactive brainstorming + focus selection
/insight-fuse "AI Native: panorama, discrimination framework, trajectory" --type overview --depth full

# Import a shared team skeleton
/insight-fuse "AI Native in finance" --skeleton ~/team/skeletons/ai-native-fin.yaml

# Academic literature review with L5 sources disallowed
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep

# Advisory appendix targeted at specific audiences
/insight-fuse "AI glasses" --audience "new entrants,investors" --strategy aggressive
```

## Research types (6 presets)

| `--type` | When to use | Default template | Default perspectives | Default outputs |
|---|---|---|---|---|
| `overview` | Panorama / discrimination framework | meta-overview | generalist, critic, specialist | report, checklist |
| `technology` | Stack selection, architecture evaluation | technology | generalist, critic, specialist | report, adr, checklist |
| `market` | Market size, growth, competitive landscape | market | generalist, specialist, futurist | report, decision-tree, checklist |
| `academic` | Peer-reviewed literature synthesis | academic | generalist, critic, methodologist | report, checklist |
| `product` | JTBD / PMF / product opportunity | product | user, designer, business | report, checklist, poc |
| `competitive` | Competitor mapping, SWOT, moat | competitive | generalist, critic, strategist | report, decision-tree |

**Default type**: `overview` (safest general-purpose).

## The 7-stage pipeline

```
Stage 0 → Stage 1 → Stage 2 → Stage 3 → Stage 4 → Stage 5 → Stage 6
Brainstorm Scan   Align   Research  Review   Deep     QA
(skeleton)  (scan)  (full)  (parallel) (full)  (3-ways) (17 checks
                                                         + 6-dim
                                                         + outputs)
```

| Stage | Purpose | Skeleton fields consumed |
|---|---|---|
| 0 | Build `skeleton.yaml` — the data contract for all later stages | (writes all) |
| 1 | WebSearch anchored by `dimensions.anchors`; `out_of_scope` filters; skip `existing_consensus` areas | dimensions, taxonomies, out_of_scope, existing_consensus |
| 2 | **Full only** — user confirms scope and dimensional adjustments | dimensions, priority |
| 3 | One Generalist agent per `hypothesis`, parallel, shared skeleton prefix cache | hypotheses, existing_consensus |
| 4 | **Full only** — Focus Selection Protocol scores candidates by 4 quality signals | known_dissensus, hypotheses |
| 5 | 3-perspective deep dive per focus; `known_dissensus` auto-triggers Disagreement Preservation Template | known_dissensus (critical) |
| 6 | 17 blocking checks + 6-dim scoring + multi-output rendering; triggers reconciliation-log template on numeric conflicts | business_neutral |

### Depth routing

| `--depth` | Stages run | Interactive gates |
|---|---|---|
| `quick` | 0*, 1, 6 | none |
| `standard` (default) | 0*, 1, 3, 6 | none |
| `deep` | 0, 1, 3, 5, 6 | focus selection (if no `--focus`) |
| `full` | 0, 1, 2, 3, 4, 5, 6 | Stage 0 user gate + Stage 2 + Stage 4 |

`*` `--skeleton skip` bypasses Stage 0 only for quick/standard; deep/full always run Stage 0.

## skeleton.yaml — the data contract

Stage 0 produces (or `--skeleton <path>` imports) a YAML file at `~/.forge/insight-fuse/skeletons/<topic-slug>-<YYYYMMDD>.yaml`:

```yaml
schema_version: 1
topic: "AI glasses"
research_type: overview
created_at: 2026-04-20
source: brainstorm
dimensions:
  - name: Hardware form factor
    rationale: Display/camera/audio schemes unconverged, source of all narratives
    weight: 0.25
    anchors: ["waveguide", "micro-OLED", "bone conduction"]
  - name: Deployment scenarios
    rationale: toB vs toC split determines business model
    weight: 0.20
    anchors: ["always-on recording", "navigation", "captions"]
taxonomies:
  always-on: "hardware supporting continuous sensing/recording, not user-triggered"
out_of_scope:
  - item: "VR headsets"
    reason: "Different form factor, separate investigation"
existing_consensus:
  - claim: "Display schemes not yet converged"
    confidence: 0.85
    sources_hint: ["https://counterpointresearch.com/..."]
known_dissensus:
  - claim: "Legal boundary of always-on recording privacy"
    position_a:
      summary: "GDPR Art. 6 requires explicit consent + indicator LED"
      proponents: ["EDPB", "consumer advocacy"]
      evidence_hint: ["https://edpb.europa.eu/..."]
    position_b:
      summary: "Public space recording is fair use under US one-party consent"
      proponents: ["Meta legal whitepaper"]
      evidence_hint: []
hypotheses:
  - id: H1
    statement: "Waveguide cost < $50 is necessary for mass-market"
    falsifiability: "2027 product priced < $300 with > 1M sales but NOT using waveguide"
business_neutral: true
```

Every later stage consumes specific fields — see `skills/insight-fuse/references/skeleton-schema.md` for the full field × stage matrix.

## Output formats (5 types)

| `--sections` value | Template | Consumer |
|---|---|---|
| `report` | `templates/<type>.md` | Decision makers, peers |
| `checklist` | `templates/checklist.md` | Implementation owners |
| `adr` | `templates/adr.md` | Architects (tech decisions) |
| `decision-tree` | `templates/decision-tree.md` | Developers (fast selection) |
| `poc` | `templates/poc.md` | Validation engineers |

**Default: multi-file output.** `--sections report,adr,checklist,decision-tree,poc` renders all five as separate `.md` files in a single directory; only `report.md` carries frontmatter and acts as the canonical KB entry, the rest are sibling files.

**Opt-in single file: `--merge`.** Add `--merge` to concatenate selected sections into one markdown using H1-demotion + continuation numbering (report stays as the document's only H1; other sections' H1 → H2 numbered `§N+1`, `§N+2`…). Internal links between sections are rewritten to anchor references inside the merged file.

## Quality assurance: 17 checks + 6-dim scoring

Stage 6 runs all 17 blocking checks. Any failure triggers rewrite, up to 2 rounds. After 3rd failure, report is emitted with a `QA-FAILED: <check-ids>` header. Advisory-mode failures are tagged `<id>-ADVISORY` but do not cap Grade.

**Check highlights** (full list in `skills/insight-fuse/references/quality-standards.md`):
- Check 7: environment isolation — no proper nouns inferred from CWD/IDE
- Check 10: source independence declaration (detect pseudo-triangulation)
- Check 11: causal discipline (≥3 alternative explanations required)
- Check 12 (v3): framework preservation — each `known_dissensus` renders three-part template
- Check 13 (v3): structure-ratio compliance — section word counts within ±30% of template
- Check 14 (v3): FIR separation — every paragraph tagged `[F]` / `[I]` / `[R]`
- Check 15 (v3.1): **primary-source binding** — every quantitative claim needs at least one L1 source whose host hits the research-type whitelist
- Check 16 (v3.1): **verbatim evidence snippet** — every quantitative claim renders `> 原文："..." — Source, YYYY-MM-DD` inline below it (spot-check in 30 seconds instead of clicking through URLs)
- Check 17 (v3.1): **numeric variance reconciliation** — cross-source conflicts > 5% trigger a `reconciliation-log.md` appendix with primary-source tiebreak

## Source reliability (v3.1)

Version 3.1 hardens the pipeline against the "URL real, number fake" hallucination mode by introducing three new blocking checks, tiered by `--type` × `--depth`. Full rationale in [docs/design/crucible/insight-fuse-design.md §11](../design/crucible/insight-fuse-design.md).

**Tier enforcement** (blocking `block` vs advisory `adv`; C15 / C16 / C17 in order):

| `--type` / `--depth` | quick | standard | deep | full |
|---|---|---|---|---|
| `overview` / `technology` / `product` / `competitive` | adv / adv / adv | **block** / adv / adv | **block** / **block** / **block** | **block** / **block** / **block** |
| `market` / `academic` | **block** / **block** / **block** | **block** / **block** / **block** | **block** / **block** / **block** | **block** / **block** / **block** |

**Primary/secondary inline syntax** (quantitative claims only):

```markdown
[F] Q1 2026 global AI megadeal funding hit $239B, 81% of all venture funding ([Crunchbase News](https://news.crunchbase.com/...){P})
> 原文："AI startups raised a record $239 billion in Q1 2026, accounting for 81% of all venture funding." — Crunchbase News, 2026-04-03
```

- `{P}` = primary source (URL host must hit [primary-source-whitelist.yaml](../../skills/insight-fuse/references/primary-source-whitelist.yaml) for the active `--type`)
- `{S→<primary-url>}` = secondary source tracing forward to a primary; a bare `{S}` without `→` triggers C15 fail

**Whitelist** (see the yaml for full list): SEC / DOI / EUR-Lex / gov domains in `common.L1`; `market` adds Crunchbase / PitchBook / CB Insights / Dealroom; `technology` adds RFC / vendor docs; `academic` adds arXiv / Nature / Science / ACM / IEEE. Non-whitelisted domains are downgraded one tier with a `tier-uncertain` flag — not hard-rejected.

**Reconciliation**: when two L1 sources disagree (e.g. Crunchbase $239B vs CB Insights $285.5B), the report auto-appends `## 附录 R-X — Reconciliation log` with a source-tier table, conservative tiebreak value, and methodological explanation of the gap. Template: [templates/reconciliation-log.md](../../skills/insight-fuse/templates/reconciliation-log.md).

**6-dim scoring** — `total = Σ (dim × weight)` per research_type weighting table (academic emphasizes falsifiability + reproducibility; industry emphasizes actionability + source_diversity):

| Dim | Academic | Industry |
|---|---|---|
| falsifiability | 0.25 | 0.15 |
| evidence_density | 0.20 | 0.15 |
| reproducibility | 0.20 | 0.10 |
| source_diversity | 0.15 | 0.20 |
| actionability | 0.05 | 0.25 |
| transparency | 0.15 | 0.15 |

**Grade mapping**: A ≥ 8.5 / B 7.0-8.4 / C 5.5-6.9 / D < 5.5. Any blocking check failure caps Grade at D.

## Advisory Appendix (opt-in)

By default the report body is neutral — no "recommendations for X" anywhere. When you pass `--audience "<role>"`, the engine appends a structured Advisory Appendix per audience, separated by `---` horizontal rule and stamped with an authorization block. Audience value is verbatim from your input; never inferred from environment.

Each Appendix has 6 mandatory sections (enforced by Check 9): 受众画像, 调研依据, 推导链, 策略梯度, 风险与反事实, 行动清单. `--strategy conservative|balanced|aggressive` only affects which column in 策略梯度 is marked recommended.

## vs council-fuse

| | insight-fuse | council-fuse |
|---|---|---|
| **Purpose** | Active research + report generation | Multi-perspective deliberation on known input |
| **Input** | Topic → WebSearch/WebFetch | User-provided question + context |
| **Output** | Full research report (+ optional outputs) | Synthesized answer |
| **Stages** | 7-stage pipeline | 3-stage (council → score → synthesize) |

Both are `crucible` skills. Compose them: use insight-fuse to research, then council-fuse to deliberate on critical decisions.

## When to use / when not to use

**✅ Use insight-fuse for**:
- Multi-source research reports with traceable evidence chains
- Configurable-depth investigation (quick scan → deep multi-perspective)
- Scenario research needing 6-dim quality assurance

**❌ Not for**:
- Fast fact lookup (use `/claim-ground` or WebSearch)
- Single-source deep reading (pipeline adds no value)
- Primary research requiring real-world interviews (desk research only)

## References

- [SKILL.md](../../skills/insight-fuse/SKILL.md)
- [skeleton schema](../../skills/insight-fuse/references/skeleton-schema.md)
- [research-types](../../skills/insight-fuse/references/research-types.md) (incl. v3.1 source-reliability tier table)
- [scoring rubric](../../skills/insight-fuse/references/scoring-rubric.md)
- [quality standards (17 checks)](../../skills/insight-fuse/references/quality-standards.md)
- [primary-source whitelist](../../skills/insight-fuse/references/primary-source-whitelist.yaml) (v3.1)
- [reconciliation-log template](../../skills/insight-fuse/templates/reconciliation-log.md) (v3.1)
- [output formats](../../skills/insight-fuse/references/output-formats.md)
