# Forge Changelog

All notable per-skill version bumps for the [forge](https://github.com/juserai/forge) skill collection.

Format inspired by [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). Versioning follows [SemVer 2.0.0](https://semver.org/spec/v2.0.0.html). Bump triggers are defined in [openspec/specs/skill-lifecycle/spec.md](openspec/specs/skill-lifecycle/spec.md).

Detailed rationale for each entry lives under `openspec/changes/<id>/` (active or archived). This file is a navigation index — read the change record for the full design context.

> Lint contract: `skill-lint` rule **S31** enforces that each skill's frontmatter `version` MUST equal the latest `### [X.Y.Z]` heading under that skill's section here. PRs that bump SKILL.md frontmatter without adding a CHANGELOG entry will be blocked.

---

## block-break

### [1.0.1] — 2026-05-08

#### Changed
- Help card now documents `/block-break L0|L1|L2|L3|L4` (specific pressure level) and `/block-break <task>` (activate + start task) entry forms. Previously only `(no args)` and `help` were listed; the level/task forms were documented in README only.
- Added frontmatter `argument-hint: "[L0|L1|L2|L3|L4] [task description...]"` (was missing).
- Reference: [openspec/changes/fix-help-card-flag-coverage](openspec/changes/fix-help-card-flag-coverage/proposal.md)

### [1.0.0] — 2026-04-15
- Initial release. Three red lines (closure / fact-driven / exhaust-all) + L0–L4 pressure escalation + 5-step methodology.

---

## claim-ground

### [1.2.1] — 2026-05-08

#### Changed
- Added frontmatter `argument-hint: "[verify <claim>]"` (was missing). Surfaces the manual `/claim-ground verify <claim>` invocation form in IDE inline hints; auto-trigger paths unchanged.
- Reference: [openspec/changes/fix-help-card-flag-coverage](openspec/changes/fix-help-card-flag-coverage/proposal.md)

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

### [1.1.1] — 2026-05-08

#### Changed
- Help card now lists `--no-save` flag (was missing — flag was documented in `argument-hint` but invisible in `/council-fuse help` output). Fixes S34 help-card-flag-coverage warning.
- Reference: [openspec/changes/fix-help-card-flag-coverage](openspec/changes/fix-help-card-flag-coverage/proposal.md)

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

### [3.4.2] — 2026-05-09

#### Fixed
- Multi-file archive default flattened from `{date}-{topic-slug}/` subdirectory to `{date}-{topic-slug}-{section}.md` flat suffix (with `report` segment as bare `{date}-{topic-slug}.md`). The subdirectory layout broke tome-forge's `*-{topic-slug}*.md` glob lookup at `skills/tome-forge/references/report-archival-protocol.md:25-29` and was inconsistent with every prior insight-fuse archive in actual user KBs (24/24 flat). `--merge` behavior unchanged. Migration: KBs that hit v3.3-v3.4.1 can run a one-time `mv` loop to flatten any `{date}-{topic-slug}/` subdirectory; the v3.3-v3.4.1 subdirectory branch had no production users in the wild.
- Stage 6 step 4 (multi-file rendering description) was pointing at the same subdirectory shape; now aligned with Stage 7 step 3 to flat-suffix naming.

### [3.4.1] — 2026-05-08

#### Changed
- Help card now enumerates all 11 `argument-hint` flags (previously only 4 were listed under "Key flags"; 7 high-frequency flags including `--no-save`, `--audience`, `--focus`, `--skeleton`, `--perspectives`, `--strategy`, `--no-advisory` were invisible to users running `/insight-fuse help`). Fixes S34 help-card-flag-coverage warning.
- Reference: [openspec/changes/fix-help-card-flag-coverage](openspec/changes/fix-help-card-flag-coverage/proposal.md)

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

### [1.1.1] — 2026-05-08

#### Changed
- Help card now lists `--no-save` flag (was missing — flag was in `argument-hint` but invisible in `/news-fetch help` output). Fixes S34 help-card-flag-coverage warning.
- Reference: [openspec/changes/fix-help-card-flag-coverage](openspec/changes/fix-help-card-flag-coverage/proposal.md)

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

### [0.2.0] — 2026-05-08

#### Changed
- `§ Document Reading`（Stage 3.5）从 300-600 字 / 5 段固定提纲扩写为
  1500-3500 字 / 5-9 段（standard 7-8）narrative arc：contextual 开场 →
  核心论点浓缩 → 章节叙事串联 → 关键张力 → meta-reflective 末段。便于直接
  对外讲述被评报告骨架。
- 禁词清单按 interpretive vs judgmental 双向重写：允许"骨架性 / 真正想交付的
  / 最值得读的 / 反直觉 / 诚实记录"等元解读语；继续禁 grade / score / flag
  code / 字母 grade / "优点 / 缺点 / 不足 / 薄弱 / 错误 / 应当改" 等质量评价语。

#### Added
- `references/narrative-discipline.md` 编码 6 条 narrative discipline 为可执行
  regex（opening / closing / verbatim / number-density / limitation-as-strength
  / output-language），含 4 个 few-shot 样本（取自既有 wiki/notes/）。能力来源：
  `plans/skill-hashed-forest.md`（原本规划为独立 skill `prose-fuse / lectio`，
  本版本融入 peer-fuse Stage 3.5）。
- 新增引用要求：≥ 3 处章节锚定（§X.Y / p.X / slide.N，按 target_format 适配）
  + ≥ 1 处 inline 外链 + verbatim 1-4 处 bold/italic 内嵌渲染。
- Stage 3.5 末尾新增 6 条 discipline regex 自检（warn-only 初版）；
  Discipline 3 渲染禁用（block quote `>` / 「」 / 编号引用） + 评审隔离禁词
  保持 fail-closed。

#### Preserved
- Stage 3.5 评审隔离三层防御中前两层不变：架构隔离（输入边界 MUST 严格）
  + 写后冻结（SHA-256 快照 + Stage 7 hash diff fail-closed）。
- review-report.md 渲染顺序不变：§ Document Reading 永在 § Holistic
  Assessment 之前。
- 不新增 `--length` 或 `--lang` flag——段数 / 语言由源报告自动适配，
  保持 peer-fuse 的 CLI surface 不变。

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

### [1.1.1] — 2026-05-08

#### Changed
- Added frontmatter `argument-hint: "[path]"` (was missing). Surfaces the optional path argument in IDE inline hints; runtime behavior unchanged.
- `.skill-lint.json` `verify-help-card-flag-coverage` promoted from `warn` to `error` after [openspec/changes/fix-help-card-flag-coverage](openspec/changes/fix-help-card-flag-coverage/proposal.md) cleared all skills.

### [1.1.0] — 2026-05-08

#### Added
- **S34 help-card-flag-coverage** (warn): each SKILL.md frontmatter `argument-hint`'s `--flag` set MUST appear in the `## Help` section's first fenced code block. Canonical + platform mirror both checked. Subcommand-only skills (no `--flag` in argument-hint) and skills without an `argument-hint` field are exempt. Initial severity = warn during observation period; upgrade to error after follow-up RFC `fix-help-card-flag-coverage` makes all skills clean.
- Reference: [openspec/changes/add-skill-lint-s34-help-flag-coverage](openspec/changes/add-skill-lint-s34-help-flag-coverage/proposal.md)

#### Backfilled (silent additions in earlier commits, now formally documented)
- **S29 version-lockstep** (error): marketplace.json `plugins[].version` MUST be SemVer 2.0.0; SKILL.md frontmatter MUST NOT have `version:` field (Claude Code schema rejects). Canonical + platform mirror.
- **S30 help-card-version-line** (error): SKILL.md help card first line MUST match `<Name> v<X.Y.Z> — <tagline>` with `X.Y.Z` equal to marketplace SSOT.
- **S31 changelog-entry** (error): each marketplace `version` MUST equal the top `### [X.Y.Z]` entry under that skill's section in root `/CHANGELOG.md`.
- **S32 docs-version-drift** (warn): `docs/user-guide/<skill>-guide.md` + `docs/i18n/<lang>/<skill>-guide.md` H1 versions MUST prefix-match marketplace SSOT.
- **S33 archived-spec-merge** (warn): each archived `openspec/changes/archive/<id>/specs/<capability>/spec.md` Requirement MUST be referenced by the main spec (`合并自 archive/<id>` mark).
- References: [openspec/changes/archive/version-governance](openspec/changes/archive/version-governance/proposal.md) (S29-S31), [openspec/changes/archive/openclaw-drift-fix](openspec/changes/archive/openclaw-drift-fix/proposal.md) (S32-S33)

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
