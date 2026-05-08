# Forge Changelog

All notable per-skill version bumps for the [forge](https://github.com/juserai/forge) skill collection.

Format inspired by [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). Versioning follows [SemVer 2.0.0](https://semver.org/spec/v2.0.0.html). Bump triggers are defined in [openspec/specs/skill-lifecycle/spec.md](openspec/specs/skill-lifecycle/spec.md).

Detailed rationale for each entry lives under `openspec/changes/<id>/` (active or archived). This file is a navigation index — read the change record for the full design context.

> Lint contract: `skill-lint` rule **S31** enforces that each skill's frontmatter `version` MUST equal the latest `### [X.Y.Z]` heading under that skill's section here. PRs that bump SKILL.md frontmatter without adding a CHANGELOG entry will be blocked.

---

## block-break

### [1.0.0] — 2026-04-15
- Initial release. Three red lines (closure / fact-driven / exhaust-all) + L0–L4 pressure escalation + 5-step methodology.

---

## claim-ground

### [1.2.0] — 2026-05-06

#### Added
- 5 hook surfaces (UserPromptSubmit / PreToolUse / PostToolUse / SessionStart): `prompt-gate`, `pre-tool-gate`, `evidence-reminder`, `session-anchor`, `epistemic-pushback-trigger`.
- Red Lines R8–R15 covering path anchor pollution, ambiguity disambiguation, destructive-action confirmation, test-result distinction, env-var verification, scope creep, hard-constraint persistence, ecosystem-scope WebSearch.
- Dual-platform mirror: Claude Code (bash) + OpenClaw (TS handler) sharing `~/.forge/claim-ground-anchors.json`.
- Reference: [openspec/changes/archive/2026-05-06-claim-ground-failure-mode-defense](openspec/changes/archive/2026-05-06-claim-ground-failure-mode-defense/proposal.md)

### [1.1.0]

#### Added
- Manual `/claim-ground verify <claim>` mode for explicit grounding without pushback (Mode 1).
- Red Line R7: term/definition assertions MUST cite authoritative standards body verbatim.

### [1.0.0]
- Initial release. Six red lines + epistemic-pushback / session-anchor hooks for runtime-context-first reasoning.

---

## council-fuse

### [1.1.0] — 2026-04-22

#### Added
- Stage 4 KB archival promoted from H2 "可选" appendix (silently skipped) to mandatory H3 stage with visible output.
- `--no-save` flag for explicit opt-out.
- Manifest correction: `filesystem: read-write`, `tools: [Agent, Read, Write, Glob, Edit]`.
- Reference: [openspec/changes/archive/archival-mandatory-observable](openspec/changes/archive/archival-mandatory-observable/proposal.md)

### [1.0.0]
- Initial release. 3-agent (generalist / critic / specialist) independent deliberation + Chairman synthesis.

---

## insight-fuse

### [3.4.0] — 2026-05-07

#### Added
- Stage 6.5 reviewer pass: independent reviewer agent breaks the self-evaluation loop between Stage 6 (QA) and Stage 7 (KB archival).
- Blocking check C18 LOAD_BEARING — flags single sources carrying load-bearing arguments across ≥ 2 sections.
- Blocking check C19 calibration discipline — numeric confidence claims MUST have base rate / reference class anchor.
- Reference: [openspec/changes/insight-fuse-v3-4-self-review-and-calibration](openspec/changes/insight-fuse-v3-4-self-review-and-calibration/proposal.md)

### [3.3.0] — 2026-04-29

#### Changed
- Default delivery is multi-file (each section → own markdown file). Use `--merge` to opt-in to single-file (was the previous default).

### [3.2.0]

#### Added
- Stage 7 KB archival mandatory + observable, opt-out via `--no-save`.
- Reference: [openspec/changes/archive/archival-mandatory-observable](openspec/changes/archive/archival-mandatory-observable/proposal.md)

### [3.1.0]

#### Added
- Blocking check C15 primary source binding, C16 verbatim evidence, C17 cross-source numeric reconciliation.
- Source reliability tier system (L1–L4).

### [3.0.0]
- Initial release. 8-stage pipeline + skeleton.yaml data contract + 6 research-type presets + 6-dim quality rubric.

---

## news-fetch

### [1.1.0] — 2026-04-22

#### Added
- Stage 4 KB archival mandatory + observable, opt-out via `--no-save`.
- `argument-hint` frontmatter field.
- Manifest correction: `filesystem` / `tools` updated.
- Reference: [openspec/changes/archive/archival-mandatory-observable](openspec/changes/archive/archival-mandatory-observable/proposal.md)

### [1.0.0]
- Initial release. 3-tier network-fallback news fetcher with structured Markdown output.

---

## peer-fuse

### [0.1.0] — 2026-05-07

- Initial release: generic peer-reviewer for research artifacts in 10 formats
  (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html / rtf) via
  Stage 0.5 format adapter (Tier 1 native / Tier 2 pandoc / Tier 3 libreoffice).
- 8-stage pipeline (Stage 0 scope → 0.5 format adapter + type auto-classify →
  1 structural audit → 2 evidence audit → 3 logic audit → 3.5 § Document Reading
  freeze → 4 3-perspective panel → 5 8-dim weighted scoring → 5.5 § Holistic
  Assessment → 6 diff suggestions → 7 KB archival).
- 6 research-type presets (overview / technology / market / academic / product /
  competitive) with `--type=auto` default — heuristic classifier mirrors
  insight-fuse research-types vocabulary.
- 8-dim rubric (accuracy / comprehensiveness / depth / novelty / actionability /
  readability / objectivity / falsifiability) weighted by research_type.
- 18-flag taxonomy (F-EVD / F-STAT / F-LOGIC / F-SCOPE / F-COST / F-METHOD /
  F-DISAGREE / F-CONSTRUCT / F-CITE / F-CONF / F-DELTA categories).
- 3-perspective panel (review-methodologist / review-adversarial /
  review-practitioner) dispatched in parallel — pattern adapted from council-fuse
  Stage 1.
- § Document Reading review-isolation hard constraint (architectural input
  boundary + write-once freeze + forbidden-word lint, all three layers).
- Sibling of insight-fuse and council-fuse (crucible category); coexists with
  insight-fuse Stage 6.5 internal-source reviewer (peer-fuse is cross-skill
  external reviewer).
- Reference: [openspec/changes/add-peer-fuse-skill](openspec/changes/add-peer-fuse-skill/proposal.md)

---

## ralph-boost

### [1.0.0]
- Initial release. Autonomous dev loop with built-in Block Break L0–L4 escalation and 5-step methodology, isolated to `.ralph-boost/`.

---

## skill-lint

### [1.0.0]
- Initial release. Structural rules S01–S28 covering plugin metadata / SKILL.md / references / evals / i18n / platform mirror / cross-namespace protection / hook parity / terminology watchlist, with tri-state config in `.skill-lint.json`.

---

## tome-forge

### [1.1.0] — 2026-04-22

#### Changed
- Report archival protocol upgraded: silent-skip → mandatory observable output with 4 documented skip-reason enum values.
- Reference: [openspec/changes/archive/archival-mandatory-observable](openspec/changes/archive/archival-mandatory-observable/proposal.md)

### [1.0.0]
- Initial release. LLM-compiled wiki based on Karpathy's pattern. No RAG / vector DB / infra.

---

## Forge collection (集合级)

> Collection-level `plugin.json` version policy is intentionally NOT defined in this changelog yet — see [openspec/changes/archive/version-governance/proposal.md § Non-goals](openspec/changes/archive/version-governance/proposal.md). A follow-up RFC will govern when collection-level version bumps happen and how they relate to per-skill bumps. Until then, `plugin.json` and `.claude-plugin/plugin.json` remain at `1.0.0` per [openspec/specs/repo-invariants/spec.md § Plugin metadata 双份一致](openspec/specs/repo-invariants/spec.md).
