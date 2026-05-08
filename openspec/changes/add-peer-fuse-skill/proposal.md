# Add `peer-fuse` skill — generic cross-skill peer-reviewer for research artifacts

> 这次 change 解决的张力：forge 当前**没有跨 skill 的外审引擎**。insight-fuse v3.4
> Stage 6.5 是 IF 同源内审（reviewer 与 author 同 pipeline 同 rubric），无法审
> CF / news-fetch / 外部 PDF / 商业 PPT。一份外部评审（A−，8.7）vs IF 自评（B+，
> 7.8）的 1.0 分差距证实自评盲点存在，独立的跨 skill peer-reviewer 是结构性补位。

## Why

三类已观察到的覆盖缺口：

1. **跨 skill 外审缺位**：IF Stage 6.5 reviewer 只评 IF 自己产的 markdown，CF / news-fetch / 外部学术 PDF / 商业 PPTX 都无对应外审通路。用户当前若要二意见只能手工。
2. **同源内审的结构盲点**：自评 + 同源内审仍共享同一 rubric / 同一启发式集，cross-report 自评分 inversion（[archive/insight-fuse-v3-4-self-review-and-calibration §Why](archive/insight-fuse-v3-4-self-review-and-calibration/proposal.md)）证明**单源 reviewer 不充分**。需要不同视角面板（方法学 / 对抗性 / 工程落地）独立打分后再综合。
3. **多格式工件无法纳入质量纪律**：研究产出 50%+ 不是 markdown（学术 PDF / 商业 docx / 内部 pptx），forge 现有 quality 设施全部假设 markdown 输入。

三类共享同一根因：**质量审查能力没有从 IF 内部解耦出来**。本 change 新建独立 `peer-fuse` skill 作为跨 skill 外审引擎；不改动 IF Stage 6.5（保留同源内审），peer-fuse 与之并存——前者是他源外审，后者是同源内审。

## What Changes

**新增 skill**（forge skill-lifecycle 场景 A 全 11 项工件）：

- `skills/peer-fuse/{SKILL.md, references/*, agents/*, templates/*, scripts/*}`
- `platforms/openclaw/peer-fuse/`（结构对等克隆）
- `evals/peer-fuse/{scenarios.md, run-trigger-test.sh}`
- `docs/user-guide/peer-fuse-guide.md`
- `docs/i18n/{en,zh,ja,ko,hi,es,fr,de,pt,ru,tr}/peer-fuse-guide.md`
- `docs/design/crucible/peer-fuse-design.md`
- `.claude-plugin/marketplace.json` 新增 plugin 条目（`version: "0.1.0"`，重算 hash）
- `README.md` Crucible 章节加行 + skills badge +1 + 首段 N skills +1
- `docs/i18n/<lang>/README.md` × 11 同步
- 根 `CHANGELOG.md` 新增 `## peer-fuse` 段，top entry `### [0.1.0]`

**核心架构**：

- 4 分类 = **crucible**（输出是 markdown peer-review 报告 + KB 归档；兄弟 = insight-fuse / council-fuse）
- 7-stage pipeline：Stage 0 scope → 0.5 format adapter + type auto-classify → 1 结构审 → 2 证据审 → 3 逻辑审 → 3.5 Document Reading（评审隔离区）→ 4 3-perspective panel → 5 8-dim scoring → 5.5 Holistic Assessment → 6 diff suggestions → 7 KB 归档
- **解读 ↔ 评审章节级隔离**（用户硬约束）：§ Document Reading 在 Stage 3.5 freeze，禁评价词 + 与评审节 0 引用 + Stage 7 前 hash 校验
- 输入支持 **10 格式 × 3 tier**：md/pdf/txt 原生 + docx/html/rtf/odt 走 pandoc + doc/ppt/pptx/odp 走 libreoffice；缺工具 fail-soft 含 install hint
- `--type=auto` **默认**：Stage 0.5 在 canonical_view 上跑分类启发式（mirror [skills/insight-fuse/references/research-types.md:9-14](../../../skills/insight-fuse/references/research-types.md)），不强制用户指定
- `--depth` ∈ {quick, standard, deep, full}，默认 `standard`（与 IF 完全对齐）
- `--no-save` 与 IF / CF / news-fetch 同口径，输出 `Archive: skipped (--no-save flag)`

**不引入新横向 capability**：沿用现有 skill-lifecycle / category-decision / platform-parity / runtime-state / i18n-layout / help-mode / repo-invariants 契约，故 `specs/` 子目录为空。

## Non-goals

- **不预先定义 Stage 2 数据驱动回灌 IF C20+**：原 tidy-pondering-willow.md Stage 2 提议被显式删除；等 peer-fuse 跑过 ≥ 8 份审查、特定 flag 频次 ≥ 60% 后另开 RFC。
- **不替代 IF Stage 6.5**：peer-fuse 与 Stage 6.5 并存，前者跨 skill 他源外审，后者 IF 内部同源内审。覆盖面、rubric、agent panel 都不同。
- **不引入运行时状态文件**：peer-fuse 无聚合需求，不创建 `~/.forge/peer-fuse-state.json`；版本溯源由 tome-forge `prior_versions` 处理。
- **不覆盖 hook 类自动触发**：peer-fuse 显式 `/peer-fuse <path>` 触发，不进入 `repo-invariants` hook owner 名单。
- **不为 v0.1.0 引入 panel 子 agent 多语言版本**：3 子 agent 仅英文 + 简体中文双语，其余 9 语言只翻 user-guide。
