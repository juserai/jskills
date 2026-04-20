# INSIGHT_RESPONSE Protocol v2

Stage 3 / Stage 5 每个 sub-agent 的结构化输出格式。Main agent 按 block 解析、打分、综合。

v2 新增：EVIDENCE_CHAIN、SOURCE_TIER、STRUCTURE_COMPLIANCE 三字段；保留 v1 所有字段。v2 不向后兼容 v1 解析器。

## 一、Format

```
---INSIGHT_RESPONSE---
PERSPECTIVE: <generalist|critic|specialist|methodologist|custom-name>
CONFIDENCE: <1-10>

KEY_FINDINGS:
  - <finding 1>
  - <finding 2>
  - <finding 3>

SOURCES_USED:
  - [title](url) — <credibility L1-L5> — content_support: <verified|inferred|placeholder>
  - [title](url) — <credibility> — content_support: ...

SOURCE_TIER:
  L1: <count>
  L2: <count>
  L3: <count>
  L4: <count>
  L5: <count>

EVIDENCE_CHAIN:
  - claim: "<结论陈述>"
    support: [<url1>, <url2>]
    confidence: <0-100>
    falsifiability: "<若观察到 X，我放弃该结论>"
  - claim: "<另一结论>"
    support: [...]
    confidence: <0-100>
    falsifiability: "<...>"

GAPS_IDENTIFIED:
  - <信息缺口 1>
  - <信息缺口 2>

FALSIFICATION_CONDITIONS:                # critic 必需；其他 recommended
  - <观察到什么推翻 Finding #N，以及如何调整>

STRUCTURE_COMPLIANCE:                    # main agent 汇总阶段填；sub-agent 不必填
  sections: [<section_name>, ...]
  word_counts: {<section>: <count>, ...}
  deviations: [<超出模板 ±30% 的 section>, ...]

CONTENT:
  <完整调研内容，多段、表格、代码块均可>
  <每段首标 [F] / [I] / [R]>
---END_INSIGHT_RESPONSE---
```

## 二、Field Reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| PERSPECTIVE | **必需** | enum/string | 产出该 block 的角色。标准：generalist/critic/specialist/methodologist。自定义命名允许 |
| CONFIDENCE | **必需** | int 1-10 | 自评信心。1 = 极有限；10 = 充分验证 |
| KEY_FINDINGS | **必需** | list (2-5) | 最重要发现。Main agent 用它快速跨视角对比 |
| SOURCES_USED | **必需** | list (3+) | 所有查阅来源，含 URL、credibility、content_support tag |
| SOURCE_TIER | **必需** | dict | L1-L5 各级数量统计（自动从 SOURCES_USED 汇总）|
| EVIDENCE_CHAIN | **必需（≥3 条）** | list | 主要结论 ↔ 来源的映射 + confidence + falsifiability |
| GAPS_IDENTIFIED | **必需** | list | 找不到/未验证的信息。Critic 角色尤为关键 |
| FALSIFICATION_CONDITIONS | 必需（critic）；recommended（其他） | list (2-4) | Popper 证伪条件 |
| STRUCTURE_COMPLIANCE | main-agent 汇总阶段填 | dict | 章节比例对模板声明的偏离 |
| CONTENT | **必需** | string | 完整调研文本。每段以 `[F]` / `[I]` / `[R]` 起头 |

## 三、Rules

### 3.1 Fact / Inference / Recommendation（FIR）三层分隔

CONTENT 内每段首标三种之一（Check 14 blocking）：

| 标记 | 定义 | 示例 |
|------|------|------|
| `[F]` | **Fact** — 可从来源直接验证的客观事实 | `[F] Meta 2024 Q3 财报披露 Ray-Ban Meta 销量 > 100 万副（[Meta 10-Q](url)）` |
| `[I]` | **Inference** — 基于 `[F]` 的推论，明确分离 | `[I] 以 2024 销量线性外推，2026 年有望 > 500 万副。该推论假设无监管黑天鹅` |
| `[R]` | **Recommendation** — 针对性建议或决策含义 | `[R] 新入局者应优先布局 always-on 传感器链路，绕开 Meta 已占领的轻量化入口` |

**硬约束**：

- **报告主体**（首个 `---` 前）**禁止 `[R]`**。`[R]` 仅允许出现在 Advisory Appendix。主体只允许 `[F]` + `[I]`
- `[I]` 必须紧跟引用它的 `[F]` 段落
- `[R]` 段必须链回主体某个 `§X` 编号

Check 14 扫描：`grep -cE "^\[F\]|^\[I\]|^\[R\]" report.md` 必须等于段落总数；零段落未标记。

### 3.2 Multi-Source Requirement

CONTENT 必须引用 ≥ **3 个独立来源**。单源段落由综合阶段 flag。任一来源占 section 内引用 > **40%** → Check 3 fail。

### 3.3 Citation Format

CONTENT 内 inline：`[SourceName](url)`。每条事实性主张（统计、日期、对比、引用）必须有 ≥1 条 inline citation。未引用的事实主张视为未验证。

### 3.4 Source Credibility — L1-L5

SOURCES_USED 每条必须标注：

| 标签 | 等级 | 权重 |
|------|:-:|:-:|
| `official docs` / 原始数据 / 官方披露 | L1 | 1.0 |
| `peer-reviewed` | L2 | 0.9 |
| `industry report` | L3 | 0.7 |
| `news coverage` | L4 | 0.5 |
| `blog/opinion` | L5 | 0.2 |

academic type 下 L5 全部不计入（权重归零）；其他 type 正常计算。Accuracy 加权公式见 [perspectives.md](perspectives.md)。

### 3.5 Content Support Tag

SOURCES_USED 每条必须带 `content_support`：

- `verified` — WebFetch 返回内容，你引用/转述了支持主张的具体段落
- `inferred` — 未 fetch；由 title/abstract/snippet 推测支持度（Accuracy 自扣 1-2 分）
- `placeholder` — URL 不可达（paywall/404/timeout/rate-limited）；**必须**同步登记到 GAPS_IDENTIFIED

格式：`- [title](url) — <credibility> — content_support: verified`

**为什么**：AI 幻觉的高阶模式是"URL 真实存在但内容不支持主张"。仅验证 URL 可达 ≠ 验证内容支持。

### 3.6 EVIDENCE_CHAIN — 结论 ↔ 证据映射

每个主要 KEY_FINDING 都必须在 EVIDENCE_CHAIN 有对应条目：

```yaml
- claim: "Meta Ray-Ban 2024 销量 > 100 万副"
  support: ["https://www.meta.com/...10-Q", "https://www.sec.gov/...filing"]
  confidence: 90
  falsifiability: "若 SEC 10-K 年报披露全年销量 < 80 万副，放弃此结论"
```

硬约束：

- 每条 claim 的 support 至少 1 条；critic 视角要求 ≥ 2 条
- confidence 是 0-100 的整数百分比
- falsifiability 必填；空填 `"非事实性命题"` 也接受（但会降低 falsifiability 维度得分）

### 3.7 Independence

Stage 3 / 5 的每个 agent 独立运行（Main agent spawn 时不共享其他 agent 响应）。独立性是多视角的前提。

### 3.8 Completeness

CONTENT 必须是**完整可发布**的调研段落，不是摘要或指针。Main agent 需要完整内容去综合评分。

## 四、Sub-Question Quality Gates（Stage 1）

Stage 1 子问题**数量不设上下限**——简单主题 2 个、复杂主题 9 个都合理。数量是主题结构的自然结果，不是流水线的配额。

每个子问题必须同时通过 4 项 quality gates；未过的淘汰或重写：

1. **信息增益（Informativeness）**：回答此子问题能否显著改变对主题的认识？无判定作用 → 砍
2. **可调查性（Investigability）**：存在可行的 WebSearch 查询路径？只能推测的标 "推测性"并降权
3. **维度一致性（Dimensional Coherence）**：所有子问题必须在**同一切分维度族**内。v3 中由 `skeleton.dimensions` 统一
4. **独立性（Non-overlap）**：与其他子问题答案重叠 ≤ 30%。高重叠则合并或重写

**覆盖缺口声明（必需）**：无论子问题数量多少，Stage 1 简报必须显式列「**已知覆盖缺口**」——未拆出的相关维度（长尾子群、极端场景、反事实路径）。缺口透明 > 假装完整。

## 五、Auto-Structure Algorithm

未指定 `--template` 时，main agent 在 Stage 1 扫描后按 `research_type` + skeleton 生成结构：

1. **首节固定**「一、摘要（TL;DR / 执行摘要）」 — 金字塔原理结论先行
2. **章节骨架来自 skeleton.taxonomies + dimensions**（不从零发明）
3. 3+ 可比项 → 加入对比表 section
4. 事件/时间线驱动 → 加入 chronology section
5. 技术主题 → 加入 architecture/principles section
6. **末节固定**中立「Outlook / 格局启示」— 产业趋势、护城河、scenario-conditional 判断。**禁止针对具体组织/产品/团队的建议**，`[R]` 段全部下沉 Advisory Appendix
7. 「参考来源」章节末加 `独立性声明：...` 行（Check 10）
8. 章节数量服从主题复杂度 — standard 参考 8-12 节，quick 5-7 节，不硬性限制

## 六、Focus Selection Protocol（Stage 4 / 5）

Stage 5 深度焦点**数量不设上下限**——可能 1 个或 5 个。关键是每个焦点过质量阈值。默认话术"选 1-3 个"触发锚定偏差——改为"按质量信号裁剪"。

### 质量信号（按优先级排序）

1. **分歧势能（Disagreement Potential）**：Stage 3 各 Generalist 在该节点有观点张力或证据断层。有张力 = critic + specialist 能增量。无张力派 3 视角 = 浪费
2. **方法学风险（Methodological Risk）**：疑似因果/相关混淆（Check 11 候选）、单源 L5 推论、推测性子问题（Gate 2 降权）
3. **决策权重（Decision Leverage）**：若有 `--audience`，对读者决策影响最大的节点优先
4. **可证伪性（Falsifiability）**：存在具体证伪条件写进 Critic 的 FALSIFICATION_CONDITIONS

**`skeleton.known_dissensus` 自动入选**：所有 `known_dissensus[i]` 自动列为焦点候选 P0，标"预知分歧：骨架已识别"。

### 推荐流程

1. Stage 3 结束后，main agent 按 4 信号打分所有 sub-question + `skeleton.known_dissensus`
2. 展示「焦点候选清单」时**必须附每个候选的质量信号摘要**，例：
   `「Always-on 拍摄的隐私合法边界」— 预知分歧：骨架已识别；分歧势能：高；方法学风险：中；决策权重：高；可证伪：是`
3. 用户基于质量信号裁剪——**禁止**暗示"建议 1-3 个"
4. 用户不指定（或 Stage 4 超时 300s）→ 自动选取所有"分歧势能：高" + "方法学风险：高"候选；无候选达阈值则跳过 Stage 5，报告末尾标"未发现需深度多视角分析的焦点"

### Disagreement Preservation Template

**当焦点命中 `skeleton.known_dissensus[i]` 或 Stage 3 涌现新分歧时**，Critic 强制套 [disagreement-preservation.md](../templates/disagreement-preservation.md) 三段式：

- 立场 A — 来源、证据、逻辑
- 立场 B — 来源、证据、逻辑
- **综合判断** — 不是"取中间"，而是"在 X 条件下 A 成立，在 Y 条件下 B 成立"或"证据不足以判定，需 Z 才能决断"

**禁止合成共识**：即使综合判断表面上能找到折中，也必须先完整呈现 A 与 B 再给判断。Check 12 blocking 扫描此模式。

## 七、Advisory Appendix Protocol

Advisory Appendix **仅当用户显式授权**时渲染：

- `--audience "<role1,role2,...>"` 参数，或
- `--depth full` 下用户交互选定的角色

两者都无（或 `--no-advisory: true`） → 报告主体结束后不再附加 Appendix。

### Rendering rules

1. **每个受众一个 Appendix**，字母编号：`Appendix A`、`Appendix B`...
2. **物理分隔**：每 Appendix 必以 `---` 水平线起头，紧跟二级标题 `## Appendix {letter} — 针对 {audience} 的建议`
3. **授权戳（3 行）**，紧跟标题：
   - `> 授权戳：{YYYY-MM-DD} | --audience="{audience}" --strategy={strategy}`
   - `> 基于主体：§{cited sections} | 命令：{original /insight-fuse invocation}`
   - `> **本节非中立调研，为用户显式请求后产出**`
4. **受众值来源**：`{audience}` 必须 verbatim 来自 `--audience` 参数（或 full 模式用户交互选定）。**禁止**从 CWD / 附加目录 / IDE 文件 / 对话历史推断
5. **6 节结构**（Check 9 强制）：
   - `### 1. 受众画像` — 2-4 项
   - `### 2. 调研依据（引用主体）` — 每条必引 `§X` 主体章节；禁止引入新事实
   - `### 3. 推导链（if-then）` — 事实 + 假设 → 观察 → 结论，禁止无支撑跳跃
   - `### 4. 策略梯度` — 3 列对比表（保守 / 中庸 / 激进）。`--strategy` 指定列标为推荐
   - `### 5. 风险与反事实` — 含 ≥1 反事实（"若假设 A 不成立 → ..."）
   - `### 6. 行动清单` — 按置信度 High/Medium/Low 排序
6. **`--strategy` 只影响 §4 推荐列**，不改其他节内容
7. **禁止跨污染**：Appendix 写作过程发现主体有事实错误 → 修主体重新生成，不通过 Appendix 补丁

## 八、Parsing Logic

1. 收集 `---INSIGHT_RESPONSE---` 与 `---END_INSIGHT_RESPONSE---` 之间文本
2. 按行前缀匹配抽字段（`PERSPECTIVE:`、`CONFIDENCE:` 等）
3. Multi-line 字段（KEY_FINDINGS / SOURCES_USED / GAPS_IDENTIFIED / EVIDENCE_CHAIN）：收集 label 后所有 `  - ` 前缀行
4. CONTENT：`CONTENT:` 标签之后直到 `---END_INSIGHT_RESPONSE---` 全部文本

## 九、Error Handling

| 情形 | 动作 |
|------|------|
| 缺 INSIGHT_RESPONSE block | 维度全 0 分，从剩余 agent 综合 |
| 字段缺失 | 分数降低；用可用字段 |
| 一个 agent 产出多个 block | 只用最后一个 |
| CONFIDENCE 超出 1-10 | 截断到最近的有效值 |
| CONTENT 空 | 0 分；不纳入综合 |
| SOURCES_USED < 3 条 | 质量检查 flag；仍处理可用字段 |
| EVIDENCE_CHAIN < 3 条 | Grade 降 1 档（A→B）|
| FIR 标记缺失 > 20% 段落 | Check 14 fail，重写 |

## 十、Scope Isolation

insight-fuse 是**独立**调研工具。每次调用从零开始。运行时**只使用**：

- 用户消息显式提供的 topic + 参数
- WebSearch/WebFetch 抓取的公开来源
- `skeleton.yaml` 内容（若 `--skeleton` 指定）

运行时**不使用**：

- CWD / 附加工作目录 的名称、路径、内容
- IDE 打开的文件、最近编辑的文件、选中代码
- CLAUDE.md / AGENTS.md / GEMINI.md 中与 topic 无关的上下文
- 历史对话中与本次 topic 无直接引用关系的项目/产品/团队信息

**例外**：`--skeleton <path>` 导入外部骨架时，该 YAML 文件内容是授权输入，可引用。

此约束保证：同一 topic 在任何项目下以相同参数运行，产出一致。
