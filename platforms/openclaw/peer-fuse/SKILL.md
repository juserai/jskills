---
name: peer-fuse
description: "Peer-Fuse v0.1.0 — Generic peer-reviewer for research artifacts in md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html. 8-dim rubric weighted by 6 research types (auto-classified) + 18-flag taxonomy + 3-perspective panel. Stage 7 KB archival mandatory + observable, opt-out via --no-save."
license: MIT
user-invokable: true
metadata:
  category: crucible
  permissions:
    network: false
    filesystem: read-write
    execution: bash
    tools: [Read, Write, Edit, Bash, Agent]
argument-hint: "<path-to-artifact> [--type auto|overview|technology|market|academic|product|competitive] [--depth quick|standard|deep|full] [--no-save]"
---

# Peer-Fuse v0.1.0 — 通用调研工件 peer-review 引擎

跨 skill 外审引擎：给定任意调研工件（md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html），输出**同行评议 markdown 报告**——含 § Document Reading（评审隔离的连贯解读）+ § Holistic Assessment（评价综述）+ Score Matrix（8 维加权 → A+...D）+ Flag List（18 类 taxonomy）+ Multi-Perspective Panel（3 视角）+ Diff Suggestions + Reconciliation。与 [skills/insight-fuse/](../insight-fuse/) Stage 6.5 同源内审并存——peer-fuse 是**他源外审**，覆盖 IF Stage 6.5 不能审的所有场景（跨 skill / 跨格式 / 显式触发）。

## Help

当第一参数为 `help` / `--help`，**或无参数**时，输出以下 help card 并停止执行（parsing 规则详见 [openspec/specs/help-mode/spec.md](../../openspec/specs/help-mode/spec.md)）：

```
Peer-Fuse v0.1.0 — Generic peer-reviewer for research artifacts (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html).

Usage:
  /peer-fuse <path>                              Review with auto-detected type
  /peer-fuse <path> --type <auto|overview|technology|market|academic|product|competitive>
  /peer-fuse <path> --depth <quick|standard|deep|full> --no-save
  /peer-fuse help                                Show this help

Defaults:
  --type   auto       Peer-Fuse classifies after reading the document
                      (frontmatter type field → section pattern → citation
                      density → title keywords → fallback overview)
  --depth  standard   Full pipeline; quick skips Stage 4 panel + 5.5 holistic

Supported formats:
  Tier 1 (native):     .md, .pdf, .txt
  Tier 2 (pandoc):     .docx, .html, .rtf, .odt
  Tier 3 (libreoffice): .doc, .ppt, .pptx, .odp
  Run /peer-fuse <path> with unsupported format → error with install hint.

Examples:
  /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md
  /peer-fuse papers/transformer.pdf                         (type auto-detected)
  /peer-fuse decks/q4-roadmap.pptx --type product
  /peer-fuse handbook.docx --depth quick --no-save

Guide: docs/user-guide/peer-fuse-guide.md
```

## Scope Isolation（强制约束）

peer-fuse 是**独立**评审工具。每次调用从零开始。运行时**只使用**：

- 用户消息中显式提供的 `<path>` 与参数
- 在 `<path>` 下的目标工件（read-only）
- skill 自身的 `references/` / `templates/` / `scripts/`

运行时**不使用** CWD 其它文件 / 附加目录 / IDE 打开文件 / CLAUDE.md / 对话中的项目上下文 / 网络（无 WebSearch / WebFetch）。peer-fuse 不查找新证据，只评议给定工件。

## 硬约束（HARD）

1. **§ Document Reading 与 § Holistic Assessment 必须各自成章节，且评审结果不得污染解读内容。** 三层防御见 Stage 3.5 / 5.5 与 [references/document-reading-guard.md](references/document-reading-guard.md)（如未单独成文，约束散落在 `templates/document-reading.md` 与 Stage 3.5 / 5.5 描述中）。
2. **不替代 IF Stage 6.5**：peer-fuse 与 IF 内置 Stage 6.5 reviewer **并存**，不互删。
3. **多格式输入**：MUST 通过 Stage 0.5 Format Adapter 统一处理；MUST NOT 假设 markdown。
4. **不引入运行时状态文件**：peer-fuse 无聚合需求，不创建 `~/.forge/peer-fuse-state.json`。

## 参数

| 参数 | 必需 | 默认 | 说明 |
|------|------|------|------|
| path | 是 | — | 被评审工件的文件路径 |
| `--type` | 否 | **`auto`** | auto / overview / technology / market / academic / product / competitive。auto 时 Stage 0.5 自动分类（启发式 mirror [skills/insight-fuse/references/research-types.md](../insight-fuse/references/research-types.md)）|
| `--depth` | 否 | standard | quick / standard / deep / full（与 IF 对齐）|
| `--no-save` | 否 | false | 跳过 Stage 7 KB 归档，仅控制台输出（与 IF/CF/news-fetch 同口径，日志 `Archive: skipped (--no-save flag)`）|

## 工作流（8 阶段 pipeline）

```
Stage 0 → 0.5 → 1 → 2 → 3 → 3.5 → 4 → 5 → 5.5 → 6 → 7
Scope    Format Struct Evid Logic Reading Panel Score Holistic Diff Archive
         + Type        audit audit (FREEZE) (3   (8-dim) Assess        (KB)
         classify                          视角)
```

### 深度路由

| `--depth` | 跑的阶段 | 备注 |
|-----------|---------|------|
| quick | 0, 0.5, 1, 2, 3, 3.5, 5, 6, 7 | 跳 Stage 4 panel + Stage 5.5 Holistic Assessment |
| standard（默认） | 0, 0.5, 1, 2, 3, 3.5, 4, 5, 5.5, 6, 7 | 全 pipeline |
| deep | 同 standard，Stage 3 启发式深度加倍 | logic audit 多扫一轮 |
| full | 同 deep，Stage 4 panel 加 specialist + futurist 子视角 | 5 视角 panel |

Stage 7 在所有 depth 下都执行；`--no-save` 时进入但立即输出 skip 行。

### Stage 0 — Scope

解析 `<path>` + flags。校验路径存在；若 `--type` ∈ 6 显式预设之一，标 `type_detection: explicit`；否则标 `type_detection: auto`，将分类工作推迟到 Stage 0.5 之后（拿到 canonical_view 才分类）。

### Stage 0.5 — Format Adapter + Type Auto-Classifier

**(a) Format dispatch**：按 [references/format-adapters.md](references/format-adapters.md) 的 3-tier 矩阵 dispatch。

1. 跑 `bash scripts/detect-format-tools.sh` 输出可用 tier 集合
2. 按文件扩展名选 adapter：
   - Tier 1（native）：md/markdown 直读；pdf 用 Read tool（含 `pages` 参数）；txt 直读
   - Tier 2（pandoc）：`pandoc -f <ext> -t markdown <path>` → canonical_view
   - Tier 3（libreoffice）：`libreoffice --headless --convert-to <intermediate>` → 走 Tier 1/2
3. 缺工具 fail-soft：打印具体 install hint（`brew install pandoc` / `apt install libreoffice` / 等）并停止前置，**不**进入 Stage 1
4. 产出：`canonical_view`（in-memory markdown，供 Stage 1-6 分析）+ `source_view`（原文件 read-only 引用，供 Stage 3.5 verbatim 引用）+ `target_format` 元数据 + `adapter_tier` 元数据

**(b) Type classify**（仅 type_detection=auto）：跑 `bash scripts/classify-research-type.sh <canonical_view>`，按 [references/type-classifier.md](references/type-classifier.md) 启发式：

1. 读 canonical_view frontmatter `type` / `research_type` 字段——命中 6 预设直接采用
2. 章节标题模式匹配（Abstract/Methods/Results/Discussion → academic；Exec Summary/Findings/Recommendations → overview/competitive；JTBD/PMF → product；SWOT/竞品矩阵 → competitive；市场规模/趋势 → market；选型/对比 → technology）
3. 引用密度 + 格式特征（pdf with arXiv/journal headers → academic；pptx → product/competitive）
4. 标题关键词
5. fallback `overview`

输出最终 `research_type`。

### Stage 1 — 结构审

按 `target_format` 选择子规则（[references/format-adapters.md §结构审差异](references/format-adapters.md)）：

- md/html：frontmatter 完整性、H1/H2 结构齐备、所有 markdown link 可达
- pdf：frontmatter 跳过，标 `format_skip: frontmatter`；检查 TOC / 章节齐备 / 参考文献页存在
- docx/odt：frontmatter 跳过，标 `format_skip: frontmatter`；检查 heading hierarchy
- pptx/odp：frontmatter 跳过；检查首尾 slides（标题 / 议程 / 总结 / 参考）齐备
- txt/rtf：仅检查文件非空 + 段落分隔

### Stage 2 — 证据审

引用密度 / L1·L2 比例 / 引用真实性抽检 / replication-tier 标注覆盖率。L1 源识别复用 [skills/insight-fuse/references/primary-source-whitelist.yaml](../insight-fuse/references/primary-source-whitelist.yaml)（read-only 跨 skill 引用）。

引用样式按格式适配：md 查 markdown link；pdf 查脚注 + 参考文献页；pptx 查超链接 + 参考页幻灯片；docx 查 hyperlinks + footnotes。

### Stage 3 — 逻辑审

启发式扫 FIR 违规（仅 md/IF-style）/ OOS 邻接溢出 / 单源量化主张 / ρ 区间均化 / 同构念基准对内 ρ 低未讨论。具体规则与 flag code 见 [references/flag-taxonomy.md](references/flag-taxonomy.md)。

### Stage 3.5 — § Document Reading（评审隔离区）⚡硬约束

主线程仅基于 `source_view` + `canonical_view` + Stage 1-3 中性扫描结果（结构 / 引用密度 / FIR 标签等**事实性**数据）写 3-5 段 ~300-600 字描述性叙述。模板与禁词清单见 [templates/document-reading.md](templates/document-reading.md)。

**输入边界**（MUST 严格）：

- ✅ 接受：原文档 `source_view` / `canonical_view` / Stage 1-3 中性扫描结果（"frontmatter 缺失"是事实，"frontmatter 不完整"是评价——前者可入，后者不可）
- ❌ 拒绝：Stage 4 panel verdict / Stage 5 scores / Stage 5/6 命中的 flag

**禁词扫描**（lint 强制）：本节内不得出现 `grade / score / flag / F-XXX-NN / strong / weak / concern / issue / problem / fail / violate / 优点 / 缺点 / 不足 / 薄弱 / 应当改 / 建议` + 字母 grade（A+/A−/B+/...）。

**verbatim 引用**：≥ 1 处带位置标记。位置标记按格式：

| target_format | 位置标记 |
|---|---|
| md / html / docx / odt | `§<sec-slug>` 或 `L<line>` 或 `§<heading-slug>` |
| pdf | `p.<page>` |
| pptx / odp | `slide.<n>` |
| txt / rtf | `L<line>` |

**写后冻结**：Stage 3.5 输出节字节级哈希在 Stage 4 启动前快照；Stage 7 归档前 diff 校验，发现修改 → fail-closed 拒绝归档。

### Stage 4 — 3-Perspective Panel（standard / deep / full）

仿 [skills/council-fuse/SKILL.md:60-91](../council-fuse/SKILL.md) Stage 1 的并行 dispatch 模式，单条 turn 内并行发 3 个 Agent 调用：

- [agents/review-methodologist.md](agents/review-methodologist.md) — 方法学 / 构念效度 / 可证伪性
- [agents/review-adversarial.md](agents/review-adversarial.md) — 对抗性挑刺 / falsification / 单边构念
- [agents/review-practitioner.md](agents/review-practitioner.md) — 工程落地 / 可操作性 / 成本-收益

各产 `REVIEW_RESPONSE` 块（PERSPECTIVE / CONFIDENCE 1-10 / KEY_FINDINGS / FLAGS_RAISED / VERDICT_SUMMARY）。

### Stage 5 — 8-dim Weighted Scoring

8 维：准确性 / 全面性 / 深度 / 新颖性 / 可操作性 / 可读性 / 客观性 / 可证伪性，0-10 分。按 Stage 0.5 决定的 `research_type` 加权（见 [references/rubric-8dim.md](references/rubric-8dim.md) §按 type 加权）。

加权总分 → grade：≥ 9.0 A+；8.5-8.9 A；8.0-8.4 A−；7.5-7.9 B+；7.0-7.4 B；6.5-6.9 B−；6.0-6.4 C+；5.5-5.9 C；5.0-5.4 C−；< 5.0 D。

### Stage 5.5 — § Holistic Assessment（standard / deep / full）

主线程在 Stage 4 panel + Stage 5 评分 + flag 命中之上写 4 段 ~400-700 字评价性叙述。模板见 [templates/holistic-assessment.md](templates/holistic-assessment.md)：

1. Methodological appraisal
2. Strengths in context
3. Critical concerns（与 Flag List 互补：本段是"为什么重要"的叙述，Flag List 是结构化索引）
4. Recommendation tier（accept / minor-revisions / major-revisions / borderline / reject）映射 grade 并允许 ±1 档微调

**MUST 单向引用规则**：本节可只读引用 § Document Reading（"如解读所述..."），**MUST NOT 修改它**（Stage 7 hash diff 校验）。

### Stage 6 — Diff Suggestions

每个失分项产 patch-style 块：`位置 + 原文片段 (verbatim) + 建议改写`。模板见 [templates/review-diff-block.md](templates/review-diff-block.md)。

### Stage 7 — KB 归档（必须，除非 --no-save）

按 [tome-forge/references/report-archival-protocol.md](../tome-forge/references/report-archival-protocol.md)。

1. **tome-forge 检测**：寻找 `.tome-forge.json`（CWD 上溯）或 `~/.tome-forge/`
   - 不存在 → 输出 `Archive: skipped (tome-forge not installed)` 跳过
2. **路径**：`{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{target-slug}-review.md`
3. **frontmatter**：

```yaml
source_skill: peer-fuse
target_report: <path>
target_self_grade: <如 frontmatter 含 grade 字段>
review_grade: <Stage 5 字母 grade>
delta: <review - target_self>
research_type: <Stage 0.5 决定>
type_detection: auto | explicit
target_format: <md|pdf|docx|...>
adapter_tier: <1|2|3>
depth: <quick|standard|deep|full>
flags: [<F-XXX-NN ids>]
panel: [methodologist, adversarial, practitioner]
recommendation: <accept|minor-revisions|major-revisions|borderline|reject>
date: <YYYY-MM-DD>
```

4. **MUST 输出可见日志行**（不藏在 tool result，必出现在用户最终响应）：
   - 成功：`Archived to KB: {absolute_filepath}`
   - 跳过：`Archive: skipped (--no-save flag)` / `Archive: skipped (tome-forge not installed)` / `Archive: skipped (KB discovery failed)`

5. **§ Document Reading freeze 校验**：归档前 hash diff，发现 § Document Reading 被修改 → fail-closed `Archive: blocked (Document Reading modified post-Stage 3.5)`，不写文件。

## 与其它 forge skill 的关系

- **insight-fuse Stage 6.5**：同源内审，IF 内部跑；peer-fuse 是**他源外审**，跨 skill / 跨格式 / 显式触发。**并存不互删**。
- **council-fuse**：crucible 兄弟，并行多 agent dispatch 模式参照；peer-fuse 复用 panel 调度模式但替换 agent 角色。
- **tome-forge**：归档协议复用，peer-fuse 不重写 ingest 路径。
- **skill-lint**：anvil（不同族），但启发地相似——都是对工件的判定 + 诊断 + 修复提示。skill-lint 校 SKILL.md，peer-fuse 校研究工件。

## Attribution

评议完成后，在控制台最终响应末尾附加：

```
> Reviewed by [forge/peer-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
```
