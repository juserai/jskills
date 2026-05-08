# peer-fuse — Design Document

**Skill**: peer-fuse v0.1.0
**Category**: crucible（OUTPUT 是 markdown peer-review 报告 + KB 归档）
**Sibling skills**: insight-fuse, council-fuse（同 crucible 族；都是"多 stage pipeline → 内联渲染 + KB 归档 markdown 工件"）
**RFC**: [openspec/changes/archive/add-peer-fuse-skill/](../../../openspec/changes/archive/add-peer-fuse-skill/)（merge 后归档）

## 目的

跨 skill 外审引擎：评议任意调研工件（10 种格式），与 insight-fuse Stage 6.5 同源内审并存。

## 设计决策

### 1. 4 分类 = crucible（早期误判 anvil 已纠正）

| 三元组项 | 决策 |
|---|---|
| (a) 选了什么 | **crucible** |
| (b) 为什么不是 hammer | hammer 输出"必须/不许 X"行为指令（block-break / claim-ground），peer-fuse 输出 markdown 评议工件 + KB 归档，不约束行为 |
| (b) 为什么不是 anvil | anvil 输出**瞬态控制台 diagnostic**（[skills/skill-lint/SKILL.md:127-145](../../../skills/skill-lint/SKILL.md#L127-L145) 唯一兄弟，无独立工件、无 KB 归档）；peer-fuse 输出**完整 markdown peer-review 报告 + KB 归档**，与 [skills/insight-fuse/SKILL.md:202-227](../../../skills/insight-fuse/SKILL.md#L202-L227) [skills/council-fuse/SKILL.md:108-130](../../../skills/council-fuse/SKILL.md#L108-L130) Stage 7/4 同构 |
| (b) 为什么不是 quench | quench 是辅助节奏（news-fetch），peer-fuse 是主流程评议产出 |
| (c) 兄弟 skill | **insight-fuse** + **council-fuse**（同 crucible，pipeline + KB 归档形态相同；OUTPUT 主旨不同：IF 产研究报告，CF 产合议答案，peer-fuse 产同行评议报告）|

### 早期 anvil 误判记录（保留作反例）

> **2026-05-07 修订前**：曾归类 anvil，理由 *"grade A+ ... D 像 pass/fail，sibling = skill-lint"*。
>
> **修订理由**：实勘 [skills/skill-lint/SKILL.md:127-145](../../../skills/skill-lint/SKILL.md#L127-L145) 后发现 skill-lint 输出是**控制台 ASCII 表 + 瞬态 errors/warnings 列表**，**不产生独立工件、不归档**。peer-fuse 输出的同行评议 markdown 报告是新的工件，与 IF/CF 同构。
>
> **教训**：4 分类 OUTPUT 形态判据 MUST 看"输出有没有独立工件"——这比"分数像不像 pass/fail"锋利得多。
>
> 这个反例与 [openspec/specs/category-decision/spec.md §反例](../../../openspec/specs/category-decision/spec.md) 中 claim-ground 早期误判 anvil 是同一类错误，应一并记入 review 教学材料。

### 2. 与 IF Stage 6.5 reviewer 边界（关键差异化）

peer-fuse 与 IF Stage 6.5 **并存**——前者跨 skill 他源外审，后者 IF 内部同源内审。

| 维度 | IF Stage 6.5 `insight-reviewer` | peer-fuse |
|---|---|---|
| 触发 | IF pipeline 内置（standard/deep/full 必跑）| `/peer-fuse <path>` 显式 |
| 输入格式 | IF 输出的 markdown | 10 格式（md/pdf/docx/pptx/doc/ppt/odt/odp/txt/html）|
| 评分维度 | 6 维 | 8 维（+准确性 +新颖性）|
| Check 体系 | IF 19 check (C1-C19) | 18-flag taxonomy（跨格式适用）|
| Reviewer 数 | 1（insight-reviewer agent）| 3 视角并行 panel |
| 评分修复机制 | Δ ≥ 1.0 → Reconciliation 段，作者响应 | 输出 diff 块，作者决定 |
| 适用场景 | IF 自审 | 跨 skill / 跨格式 / 第三方文档 |

**为什么不替代 Stage 6.5**：Stage 6.5 是 IF pipeline 内部 stage，跑得快、零参数、对 IF 输出有专门启发式（19 check 与 IF skeleton.yaml 数据契约耦合）；peer-fuse 是显式触发的独立 skill，跑得慢但更全面。删 Stage 6.5 = 让 IF 失去内置 self-check 能力。

**为什么不只升级 Stage 6.5**：Stage 6.5 只能审 IF 自己的 markdown，加多格式 + 跨 skill 会污染 IF 单一职责（research engine ≠ universal reviewer）。

### 3. 输入侧多格式（用户硬约束）

3-tier adapter，10 格式：

- Tier 1 native（无依赖）：md / markdown / pdf / txt
- Tier 2 pandoc：docx / html / rtf / odt
- Tier 3 libreoffice：doc / ppt / pptx / odp

**为什么需要 source_view + canonical_view 双视图**：lossy 转换（pandoc / libreoffice）会破坏位置标记（pdf 页码、pptx 幻灯片号）；peer-fuse 在 § Document Reading 需要 verbatim 引用 + 精确位置标记证明 reviewer 实读。所以 canonical_view（markdown 内存渲染供分析）+ source_view（原文件 read-only 引用供 verbatim 引用）双视图。

**位置标记按格式适配**：md `§<sec-slug>` / `L<line>`；pdf `p.<page>`；docx/odt `§<heading-slug>`；pptx/odp `slide.<n>`；txt/rtf `L<line>`。

**缺工具 fail-soft**：[scripts/detect-format-tools.sh](../../../skills/peer-fuse/scripts/detect-format-tools.sh) 在 Stage 0.5 启动时跑，缺 pandoc / libreoffice 时打具体 install hint，**不进入 Stage 1**。

### 4. `--type=auto` 默认（不让用户必填）

`--type` 默认 `auto`，由 Stage 0.5 在 `canonical_view` 上跑分类启发式。词汇表 + 启发式与 [skills/insight-fuse/references/research-types.md](../../../skills/insight-fuse/references/research-types.md) 完全对齐（family resemblance 要求）。

启发式优先级：

1. Frontmatter `type` / `research_type` 字段直读（仅 md/html）
2. 章节标题模式匹配（Abstract/Methods/Results/Discussion → academic 等）
3. 格式特征（pdf with arXiv/IEEE → academic；pptx → product/competitive）
4. 标题关键词扫描
5. 引用密度 + L1 比例（细微调整）
6. Fallback `overview`

实现见 [scripts/classify-research-type.sh](../../../skills/peer-fuse/scripts/classify-research-type.sh) + [references/type-classifier.md](../../../skills/peer-fuse/references/type-classifier.md)。

**为什么不让用户必填**：Stage 0.5 在拿到 canonical_view 后**有充分信号**做分类；强制用户指定是把"读懂文档"的工作甩回去。peer-fuse 的卖点之一是"不需要先了解文档结构就能审"。

### 5. 解读 ↔ 评审章节级隔离（用户硬约束）

§ Document Reading（Stage 3.5）与 § Holistic Assessment（Stage 5.5）严格分离。

**架构隔离**（第一层防御）：

- Stage 3.5 输入边界严格：只接受原文档 + Stage 1-3 中性扫描数据，**不接受** panel verdict / scores / flag 命中
- Stage 4 / 5 / 5.5 / 6 / 7 之间，只能**只读引用**§ Document Reading

**写后冻结**（第二层防御）：

- Stage 3.5 输出节字节级哈希在 Stage 4 启动前快照
- Stage 7 归档前 diff 校验，发现修改 → fail-closed `Archive: blocked (Document Reading modified post-Stage 3.5)`

**禁词 lint**（第三层防御）：

- § Document Reading 内禁出现 `grade / score / flag / F-XXX-NN / strong / weak / concern / 优点 / 缺点 / 不足 / 应当改 / 建议` + 字母 grade（A+/A−/B+/...）
- 与评价节 0 引用（不出现 `§ Score Matrix / § Flag List / § Multi-Perspective Panel / § Diff Suggestions / § Holistic Assessment` 字样）

三层防御缺一不可——架构防的是工程错误（写错管道），冻结防的是 LLM 幻觉/工具误用，禁词 lint 防的是语言污染。

### 6. `--no-save` 与 IF/CF 同口径（不是 `--dry-run`）

- `--no-save`：完整跑 skill，控制台输出 review，仅跳 KB 归档；日志 `Archive: skipped (--no-save flag)`
- `--dry-run`：tome-forge 用法，"预演 routing decision"——语义不同，peer-fuse 不用

family resemblance：crucible 兄弟（IF / CF / news-fetch）一律 `--no-save`，peer-fuse 沿用，避免用户认知切换成本。

## 受影响清单

- **新增**：见 [openspec/changes/add-peer-fuse-skill/proposal.md § What Changes](../../../openspec/changes/add-peer-fuse-skill/proposal.md)
- **修改**：仅 `.claude-plugin/marketplace.json` + `README.md` + 11 i18n READMEs + 根 `CHANGELOG.md`
- **不动**：8 个现存 skill 的源码与文档；不动任何横向 spec

## 跨 skill 分类声明

- peer-fuse **是 crucible 兄弟** of insight-fuse 与 council-fuse
- peer-fuse **不是 anvil 兄弟** of skill-lint（虽然功能相似——判定 + 诊断 + 修复——但 OUTPUT 形态不同：peer-fuse 产独立工件 + KB 归档，skill-lint 不产独立工件）

## Verification

见 [docs/user-guide/peer-fuse-guide.md § Verification](../../user-guide/peer-fuse-guide.md)。

## 历史与演化指针

- v0.1.0 初版（2026-05-07）：本文档定义的 7-stage pipeline、10 格式、6 type auto-classify、3-perspective panel、§ Document Reading 评审隔离
- 未来 v0.2.0 候选（不预先承诺）：基于 ≥ 8 份审查的数据驱动 flag 频次聚合（取代被删除的 tidy-pondering-willow.md Stage 2 提议）；条件成熟另开 RFC
