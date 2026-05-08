# Design — add-peer-fuse-skill

影响分类：**crucible**（OUTPUT = peer-review markdown 报告 + KB 归档；与 insight-fuse / council-fuse 同族）。

## 设计决策

### 1. 4 分类 = crucible（不是 anvil）

- **选了什么**：crucible
- **为什么不是 anvil**：anvil 输出**瞬态控制台 diagnostic**（[skills/skill-lint/SKILL.md:127-145](../../../skills/skill-lint/SKILL.md#L127-L145) 唯一兄弟，无独立工件、无 KB 归档）。peer-fuse 输出是**完整的 markdown peer-review 报告 + KB 归档到 `raw/reports/peer-fuse/{date}-{slug}-review.md`**，与 [skills/insight-fuse/SKILL.md:202-227](../../../skills/insight-fuse/SKILL.md#L202-L227) [skills/council-fuse/SKILL.md:108-130](../../../skills/council-fuse/SKILL.md#L108-L130) Stage 7/4 同构。
- **为什么不是 hammer**：hammer 输出"必须/不许 X"行为指令（block-break / claim-ground），peer-fuse 输出评议工件，不约束行为。
- **为什么不是 quench**：quench 是辅助节奏（news-fetch），peer-fuse 是主流程评议产出。
- **反例自检**（按 [openspec/specs/category-decision/spec.md §反例](../../specs/category-decision/spec.md)）：先写 OUTPUT = `raw/reports/peer-fuse/{date}-{slug}-review.md`（独立 markdown 工件，frontmatter + 评分 + flag + diff），再反查 → 融合产出，crucible。

> **早期误判记录**：本方案 v0 曾归类 anvil（"grade 像 pass/fail，sibling = skill-lint"），实勘 skill-lint 输出形态后纠正——skill-lint 无独立工件、无 KB 归档，peer-fuse 两者皆有。OUTPUT 形态判据先于过程描述。

### 2. 与 IF Stage 6.5 reviewer 的边界（关键差异化）

- **选了什么**：peer-fuse 是**跨 skill 外审引擎**，与 IF Stage 6.5 **并存**，覆盖 IF Stage 6.5 不能审的所有场景。
- **为什么不替代 Stage 6.5**：Stage 6.5 是 IF pipeline 内部 stage，跑得快、零参数、对 IF 输出有专门启发式（19 check）；peer-fuse 是显式触发的独立 skill，跑得慢但更全面。删 Stage 6.5 = 让 IF 失去内置 self-check 能力。
- **为什么不只升级 Stage 6.5**：Stage 6.5 只能审 IF 自己的 markdown，加多格式 + 跨 skill 会污染 IF 单一职责（research engine ≠ universal reviewer）。
- **family resemblance**：peer-fuse 在 `--type` / `--depth` / `--no-save` 三参数 + 6 type 词汇表上**完全对齐 IF**（mirror [skills/insight-fuse/SKILL.md:13](../../../skills/insight-fuse/SKILL.md#L13)），保证用户无认知切换成本。

| 维度 | IF Stage 6.5 | peer-fuse |
|---|---|---|
| 触发 | IF pipeline 内置 | `/peer-fuse <path>` 显式 |
| 输入格式 | IF 输出的 markdown | 10 格式（md/pdf/docx/pptx/...）|
| 评分维度 | 6 维 | 8 维（+准确性 +新颖性）|
| Check 体系 | IF 19 check | 18-flag taxonomy（跨格式适用）|
| Reviewer 数 | 1 | 3 视角并行 panel |
| 评分修复 | Δ ≥ 1.0 → Reconciliation | 输出 diff 块，作者决定 |

### 3. 输入侧多格式（用户硬约束）

- **选了什么**：3-tier adapter，10 格式
  - Tier 1 native（无依赖）：md / pdf / txt
  - Tier 2 pandoc：docx / html / rtf / odt
  - Tier 3 libreoffice：doc / ppt / pptx / odp
- **为什么不是 markdown only**：用户硬约束 + 学术 PDF / 商业 PPTX 是真实输入。
- **为什么不是"全部转 markdown 一次性"**：lossy 转换会破坏位置标记（pdf 页码 / pptx 幻灯片号）；peer-fuse 需要 verbatim 引用 + 精确位置标记证明 reviewer 实读，所以**双视图**：`canonical_view`（markdown 内存渲染供分析）+ `source_view`（原文件 read-only 引用供 verbatim 引用）。
- **位置标记按格式适配**：md `§<sec-slug>` / `L<line>`；pdf `p.<page>`；docx/odt `§<heading-slug>`；pptx/odp `slide.<n>`；txt/rtf `L<line>`。
- **缺工具 fail-soft**：[scripts/detect-format-tools.sh](../../../skills/peer-fuse/scripts/detect-format-tools.sh) 在 Stage 0.5 启动时跑，缺 pandoc / libreoffice 时打具体 install hint（`brew install pandoc` 等）并停止前置，不进入 Stage 1。

### 4. `--type` 默认 `auto`，由 Stage 0.5 自动分类

- **选了什么**：`--type=auto` 默认；6 显式预设词汇表与 IF 对齐（overview/technology/market/academic/product/competitive）。
- **为什么不让用户必填**：peer-fuse 在 Stage 0.5 拿到 `canonical_view` 后**有充分信号**（frontmatter `type` 字段直读 / 章节标题模式 / 引用密度 / 格式特征 / 标题关键词）；强制用户指定 = 把"读懂文档"的工作甩回去。
- **为什么不发明新词**：IF 6 预设是 forge 标准词汇表（[archive/bootstrap-openspec-and-restructure](archive/bootstrap-openspec-and-restructure/proposal.md) 已定型），family resemblance 要求 peer-fuse 沿用。
- **分类启发式**：mirror [skills/insight-fuse/references/research-types.md:9-14](../../../skills/insight-fuse/references/research-types.md)，落地为 [skills/peer-fuse/scripts/classify-research-type.sh](../../../skills/peer-fuse/scripts/classify-research-type.sh) + [references/type-classifier.md](../../../skills/peer-fuse/references/type-classifier.md)。
- **分类元数据写入归档 frontmatter**：`research_type` + `type_detection: auto|explicit`，便于跨报告分析。

### 5. 解读 ↔ 评审章节级隔离（用户硬约束）

- **选了什么**：§ Document Reading（Stage 3.5）与 § Holistic Assessment（Stage 5.5）严格分离；前者纯描述、写后冻结，后者评价、可单向引用前者。
- **为什么不合并**：用户显式硬约束 *"自成章节，不要让评审结果影响原文档的解读内容"*；学术 peer-review 传统做法（"summary of contribution" 先于 "assessment"）也是这个分离。
- **三层防御**：
  1. **架构隔离**：Stage 3.5 输入边界严格——只接受原文档 + Stage 1-3 中性扫描数据，**不接受** panel verdict / scores / flag 命中
  2. **写后冻结**：Stage 3.5 输出节字节级哈希在 Stage 4 启动前快照；Stage 7 归档前 diff 校验，发现修改 → fail-closed 拒绝归档
  3. **禁词 lint**：§ Document Reading 内禁出现 `grade / score / flag / F-XXX-NN / strong / weak / concern / 优点 / 缺点 / 不足 / 应当改 / 建议` + 字母 grade 字面量；与评价节 0 引用

### 6. `--no-save` 与 IF/CF 同口径

- **选了什么**：`--no-save`（不是 `--dry-run`），日志格式 `Archive: skipped (--no-save flag)`。
- **为什么不是 `--dry-run`**：`--dry-run` 在 [skills/tome-forge/SKILL.md:138-151](../../../skills/tome-forge/SKILL.md#L138-L151) 已用于"预演 routing decision"，语义不同。peer-fuse 想要的语义是"全跑但不归档"，正是 `--no-save`。crucible 兄弟（IF / CF / news-fetch）一律 `--no-save`，family resemblance 要求 peer-fuse 沿用。

## 受影响清单

- **新增**：见 [proposal.md § What Changes](proposal.md)。
- **修改**：仅 `.claude-plugin/marketplace.json` + `README.md` + 11 i18n READMEs + 根 `CHANGELOG.md`（按 skill-lifecycle 场景 A）。
- **不动**：IF / CF / news-fetch / skill-lint / tome-forge / block-break / claim-ground / ralph-boost 8 个现存 skill 的源码与文档；不动任何 spec.md。
