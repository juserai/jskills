# Peer Fuse v0.1.0 Guide

> Generic peer-reviewer for research artifacts — **8-stage pipeline (Stage 7 KB archival mandatory + observable, opt-out via `--no-save`) + 10-format input adapter (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, 3-tier dispatch) + 6 research-type presets (auto-classified) + 8-dimensional weighted rubric + 18-flag taxonomy + 3-perspective panel + § Document Reading freeze (review-isolation hard constraint)**.

Peer-Fuse takes any markdown / PDF / Office document and produces a peer-review markdown report with an A+/A−/.../D grade, a tiered list of quality flags, a multi-perspective panel synthesis, and patch-style diff suggestions. It coexists with [insight-fuse Stage 6.5 reviewer](insight-fuse-guide.md) — Stage 6.5 is IF-internal same-source review; peer-fuse is the **cross-skill external reviewer** that handles formats and skills Stage 6.5 cannot.

## Quick start

```bash
# Auto-classify type, default depth, archive to KB
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# PDF academic paper (type auto-detected from arXiv/IEEE/Nature header)
/peer-fuse papers/transformer-2017.pdf

# PPTX deck with explicit type
/peer-fuse decks/q4-roadmap.pptx --type product

# Quick depth (skip Stage 4 panel + Stage 5.5 holistic) + skip KB archive
/peer-fuse handbook.docx --depth quick --no-save

# Show help
/peer-fuse help
# or no-args
/peer-fuse
```

## Defaults & flags

| Flag | Default | Values |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — skips Stage 7 KB archive, console output only |

`--type=auto` lets peer-fuse classify after reading the document via heuristics (frontmatter type field → section pattern → citation density → format/title hints → fallback overview). See [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) for the priority chain.

## Supported formats

| Tier | Tool requirement | Formats |
|:-:|---|---|
| 1 | none (native) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` for `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Missing tool → fail-soft with concrete install hint (`brew install pandoc`, `apt install libreoffice`, etc.) and exit before Stage 1. See [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md).

## What you get back

Two parallel deliverables:

1. **Inline rendered review** in your conversation, structured as:
   - § Document Reading — descriptive narrative (what the document says), 3-5 paragraphs, 300-600 words
   - § Holistic Assessment — evaluative narrative (methodology / strengths / concerns / recommendation), 4 paragraphs, 400-700 words
   - § Score Matrix — 8-dim weighted scores → letter grade
   - § Flag List — flag codes from 18-taxonomy with positions
   - § Multi-Perspective Panel — methodologist / adversarial / practitioner verdicts
   - § Diff Suggestions — patch-style rewrites for each demerit
   - § Reconciliation — target self-grade vs review_grade Δ

2. **KB archive** at `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` (skip with `--no-save`). Archive log line `Archived to KB: <path>` always appears in the user-visible response.

## Hard constraint: § Document Reading is review-isolated

The most important architectural decision in peer-fuse:

**§ Document Reading must not be polluted by review verdicts.** It is the reviewer's faithful, descriptive reading of the document — frontmatter, structure, claims, evidence, scope. It runs at Stage 3.5, **before** Stage 4 panel and Stage 5 scoring, and the input boundary is strict:

- ✅ Accepts: original document, Stage 1-3 factual scan results
- ❌ Rejects: panel verdicts, scores, flag hits

The section is **frozen** after Stage 3.5: a SHA-256 hash is taken before Stage 4, and Stage 7 verifies the hash before archive. Any modification → fail-closed. Lint also forbids evaluative vocabulary (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) and letter-grade literals from this section.

This is the user-stated hard constraint and is enforced at three levels: architectural isolation + write-once freeze + forbidden-word lint.

## Interaction with other forge skills

| Skill | Relationship |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | Coexists — Stage 6.5 is IF-internal same-source review (same rubric, same heuristics, IF markdown only). peer-fuse is **cross-skill external review** with broader 8-dim rubric, 18 flags, 10 formats, 3-agent panel. Both should run for important IF reports. |
| **council-fuse** | Sibling crucible — peer-fuse reuses council-fuse's parallel sub-agent dispatch pattern (Stage 4 panel mirrors council-fuse Stage 1). |
| **tome-forge** | Archive backend — peer-fuse Stage 7 calls tome-forge's report-archival-protocol; does not reimplement KB write logic. |
| **skill-lint** | Sibling-by-pattern (different category, anvil) — both judge artifacts and emit diagnostics, but skill-lint outputs ephemeral console diagnostic while peer-fuse outputs a persistent markdown peer-review artifact. |

## When to use peer-fuse vs IF Stage 6.5

| Scenario | Use |
|---|:-:|
| You just ran `/insight-fuse <topic>` and want a second opinion on the IF report | IF Stage 6.5 already ran inline; if you want a second-layer external review with cross-format readiness, run `/peer-fuse <if-output-path>` |
| You have a third-party PDF research paper to evaluate | peer-fuse |
| You have a PPTX business deck you want graded | peer-fuse |
| You have a council-fuse synthesis output you want graded | peer-fuse |
| You want to compare multiple artifacts on the same rubric | peer-fuse (consistent scoring across artifacts) |

## Concrete example

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

The console renders the full review inline; the KB archive is the persistent canonical version.

## Verification

```bash
# Static check
bash skills/skill-lint/scripts/skill-lint.sh .

# Trigger test
bash evals/peer-fuse/run-trigger-test.sh

# Hash lockstep
bash scripts/recalc-all-hashes.sh
```

## See also

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — runtime skill definition
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — architectural decisions + 4-category rationale
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (after merge)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — sibling crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — sibling crucible (panel pattern source)
