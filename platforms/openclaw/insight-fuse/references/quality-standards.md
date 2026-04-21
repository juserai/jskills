# Report Quality Standards

Main agent 在落盘最终报告前跑 17 项 **blocking checks** + 6 维评分。Any blocking check 失败 → 重写对应段落，最多 2 轮，第 3 轮仍失败则输出并在 header 标 `QA-FAILED: <check-ids>`。

**分档执行**：C15 / C16 / C17 按 `--depth` + `--type` 组合决定 blocking 或 advisory（见 [research-types.md](research-types.md) §源可靠性分档）。`quick` 模式默认 advisory；`market` / `academic` 不论 depth 一律 blocking。

## 一、17 项 Mandatory Checks

| # | Check | Criterion | 失败处理 |
|---|-------|-----------|---------|
| 1 | Source density | 每 section ≥ 2 独立 citation | 补充来源或合并 section |
| 2 | Reference integrity | 所有 inline citation 在 reference list；无 orphan URL | 补齐 reference |
| 3 | Source diversity | 任一 section 内单源占比 ≤ 40% | 多样化引用或重写 |
| 4 | Evidence-backed claims | 比较/排序主张必有数据支撑 | 加 benchmark/数据 citation，或降级措辞 |
| 5 | Date line present | header 有 `> 日期：YYYY-MM-DD` | 补 date line |
| 6 | Attribution | footer 有 forge attribution block | 补 attribution |
| 7 | Environment isolation | 主体 + Appendix 无从执行环境推断的专名 | reject 未授权名；只允许来自：① 用户消息 ② `--focus` / `--audience` 参数值 ③ WebSearch/WebFetch 源内容 |
| 8 | Neutral body | 主体（首个 `---` 前）无针对性建议 | 检测正则（中英）：`对\s*\S+\s*(的)?建议\|给\s*\S+\s*(的)?启示\|对我们的启发\|为\s*\S+\s*(设计\|打造)\|启示录\|(advice\|recommendations?)\s+(for\|to)` — 命中即 reject，要求改写中立 Outlook |
| 9 | Advisory Appendix integrity | 若有 Appendix：`---` 起始 + 标题格式 + 3 行授权戳 + 6 节结构齐全 + `{audience}` verbatim + §2 全引主体 + §4 三列 | reject 该 Appendix 要求重写 |
| 10 | Source independence | ≥2 来源时在参考列表末追加 `独立性声明：...` 行，识别同源转引 | 补充声明；若全部同源，触发 Check 3 fail |
| 11 | Causal claim discipline | 因果断言列 ≥ 3 种替代解释 | reject 或降级为"相关/伴随/观察到" |
| 12 | **Framework preservation** | `skeleton.known_dissensus[i]` 每项在报告中渲染三段式（立场 A / 立场 B / 综合判断） | 套 `templates/disagreement-preservation.md` 重写；禁止合成共识 |
| 13 | **Structure-ratio compliance** | 各章节字数在模板声明比例 ±30% | 扩写/压缩对应 section |
| 14 | **FIR separation** | 每段首标 `[F]` / `[I]` / `[R]`；主体禁 `[R]` | 补标或下沉 `[R]` 到 Appendix |
| 15 | **Primary-source binding** | 每条量化声明（数字 / 百分比 / 日期 / 排名）的 EVIDENCE_CHAIN `support[]` 含 ≥1 条 L1 来源，且 URL 域名命中 [primary-source-whitelist.yaml](primary-source-whitelist.yaml) 中该 research-type 对应的白名单（或 `common` 段）；未命中域名降一级并标 `tier-uncertain` | reject 该声明；或降级为定性陈述（"大量资金涌入" 替代 "$X B"）；或补充一手源 |
| 16 | **Verbatim evidence snippet** | 每条量化声明对应 `SOURCES_USED` 条目须含 `quote:` 子字段（≥1 整句原文，含声明中的数字）+ 来源发表日期；正文同步渲染 `> 原文："..." — <Source>, <YYYY-MM-DD>` 紧邻段块 | 触发 WebFetch 回填原文；不可达则将该声明改 `content_support: placeholder` 并登记 GAPS_IDENTIFIED |
| 17 | **Numeric variance reconciliation** | 同一量化声明 `support[]` ≥ 2 条时，跨源数字差异 > 5% → 报告附录强制套 [templates/reconciliation-log.md](../templates/reconciliation-log.md)（一手源 tiebreak + 差异说明 + 最终采用值） | reject 声明；或写入 Reconciliation log |

Check 1-11 是 v2 保留；Check 12-14 是 v3 新增（Framework / Structure / FIR）；Check 15-17 是 v3.1 新增（源可靠性，起因于 2026-04 VC 数据扩散事件）。

### 1.1 Evidence-Backed Claims Examples（Check 4）

需数据支撑的比较/排序表述：

- "X is faster than Y" → 必引 benchmark source
- "X leads the market" / "X ranks first" → 必引市场份额数据
- "X outperforms Y in Z" → 必引具体指标
- "most popular" / "widely adopted" → 必引采用数据或调研
- "more secure" / "more reliable" → 必引 CVE 统计、uptime、审计结果

✅ Acceptable：`[F] X reported 99.9% uptime ([Source](url)), compared to Y's 99.5% ([Source](url))`
❌ Not acceptable：`X is significantly more reliable than Y`（无数据）

### 1.2 Causal Claim Examples（Check 11）

触发扫描的关键词（中英）：`导致 / 使得 / 由 ... 造成 / because of / leads to / 驱动 / 触发 / causes`。

对每个触发点，报告必须二选一：

1. 列 ≥3 种替代解释（confounding / selection bias / reverse causation）并各附证据排除，**或**
2. 降级措辞为非因果（`观察到相关 / 伴随发生 / the two trends coincide`）

✅ Acceptable：
`[F] 2024-2026 全球客服岗位收缩 ≈ 12%（[来源 A](url)）；同期生成式 AI 客服部署率 +40%（[来源 B](url)）。`
`[I] **观察到相关**，但尚无 RCT 排除以下替代解释：(a) 经济周期下行、(b) 离岸外包持续、(c) 疫情后结构性调整。`

❌ Not acceptable：`AI leads to the layoffs` （未排除混淆因素）

### 1.3 Source Independence Examples（Check 10）

- 三个来源均追溯到 McKinsey 2024 某报告 → 视为单源，Check 3 fail
- 两个来源都是对同一 WSJ 报道的转载 → 视为单源
- 一个 SEC 披露 + 一个 Reuters 对该披露的报道 + 一个独立审计 → 独立性 2/3（Reuters 与 SEC 同源）

独立性声明示例：
`独立性声明：[A] 与 [B] 均引用 McKinsey 2024-Q3《全球 AI 报告》，视为同源；[C] 为独立 SEC 8-K 披露；有效独立来源 = 2。`

### 1.4 Framework Preservation（Check 12）

对 `skeleton.known_dissensus` 中每一项 `claim`，报告必须含完整三段式：

```markdown
#### <claim>

**立场 A**：<summary>
- 持方：<proponents>
- 证据：<evidence>
- 逻辑链：<F→I 推导>

**立场 B**：<summary>
- 持方：<proponents>
- 证据：<evidence>
- 逻辑链：<F→I 推导>

**综合判断**：
- 在 <条件 X> 下，立场 A 成立；在 <条件 Y> 下，立场 B 成立
- 或："证据不足以判定，需 <Z> 才能决断"
- **禁止**"取中间"或"两者都有道理"的模糊合成
```

Shell 校验：

```bash
count=$(yq '.known_dissensus | length' skeleton.yaml)
rendered=$(grep -c "^\*\*立场 A\*\*\|^\*\*Position A\*\*" report.md)
[ "$rendered" -ge "$count" ] || echo "Check 12 FAIL"
```

### 1.5 Structure-Ratio Compliance（Check 13）

各 template 在 frontmatter 或 header comment 声明章节目标比例，例如 technology：

```markdown
<!-- section ratios: 背景 10%, 对比 30%, 分析 35%, 风险 15%, 结论 10% -->
```

Stage 6 按 `## ` 切分 section 统计字数，每节偏离 ±30% 则 fail。

### 1.6 FIR Separation（Check 14）

每段必须以 `[F]` / `[I]` / `[R]` 起头。主体禁 `[R]`（仅允许在 Advisory Appendix）。详细语义见 [research-protocol.md](research-protocol.md) § FIR。

### 1.7 Primary-Source Binding（Check 15）

**"量化声明" 定义**：任何含 (a) 具体数字（金额 / 百分比 / 数量 / 增长率）、(b) 绝对日期或时间窗、(c) 排名 / 份额 / 榜单位次 的陈述。定性描述（"大规模"、"快速"、"领先"）不在此列。

**白名单匹配**：`support[]` 至少 1 条 URL 的 host 匹配 [primary-source-whitelist.yaml](primary-source-whitelist.yaml) 下：

1. `common.L1.domains`（SEC / arXiv / 官方立法 / DOI 期刊 / 原始公司披露）；**或**
2. `type_specific.<research-type>.L1.domains`（market: Crunchbase News / PitchBook / CB Insights / Dealroom；technology: RFC / 各厂商 docs 域；academic: arXiv / ACM / IEEE / Nature / Science；competitive: 对标公司官网 + SEC）

未命中白名单：

- 若 `support[]` 有其他 L1 条目 → 通过（但 tier 标 `tier-uncertain`）
- 若全部 L2-L5 → Check 15 fail

**分档执行**（由 [research-types.md](research-types.md) §源可靠性分档决定 blocking / advisory；本节只定义判据）：`quick` 默认 advisory；`standard` blocking；`deep` / `full` blocking；`market` / `academic` 一律 blocking。

**示例**：

✅ `[F] Q1 2026 全球 AI megadeal 融资 $239B（[Crunchbase News](https://news.crunchbase.com/...)）{P}`（Crunchbase News 在 market L1 白名单）

❌ `[F] Q1 2026 VC 总额 $300B（[TheBranx Blog](https://thebranx.com/...)）{P}` — TheBranx 非 L1，Check 15 fail

✅ `[I] 生态系统规模在扩张` — 定性，不触发 Check 15

### 1.8 Verbatim Evidence Snippet（Check 16）

**目的**：AI 幻觉最隐蔽的模式是"URL 真 + 数字假"——URL 可达但内容不支持声明。Verbatim quote 让人工可在 30 秒内 spot-check。

**结构要求**：

```markdown
[F] Q1 2026 全球 AI megadeal 融资 $239B，占全部 VC 81%（[Crunchbase News](https://news.crunchbase.com/...)）{P}
> 原文："AI startups raised a record $239 billion in Q1 2026, accounting for 81% of all venture funding." — Crunchbase News, 2026-04-03
```

quote 必须：

- 是源文档原文（不是改写 / 翻译 / 浓缩）——保留原语言即可
- 至少 1 整句，且**包含声明中出现的每一个具体数字**
- 附发表 / 检索日期（`YYYY-MM-DD`）
- 同时登记到对应 `SOURCES_USED` 条目的 `quote:` 字段（供解析器提取）

**回填规程**：Stage 3 Generalist 若某声明缺 verbatim → 强制 WebFetch 该 URL → 在原文中搜索数字 → 未找到则改 `content_support: placeholder` + 记入 GAPS_IDENTIFIED。禁止"凭 URL title 推测支持度"。

**分档**：`quick` advisory；`standard` advisory（可升 blocking 于 market/academic）；`deep` / `full` blocking。

### 1.9 Numeric Variance Reconciliation（Check 17）

**触发**：某量化声明 `support[]` ≥ 2 条，且不同来源返回的数字差异 > 5%（对数字）或跨类别（对排名 / 分类）。

**处理**：

1. 报告附录强制套 [templates/reconciliation-log.md](../templates/reconciliation-log.md)
2. 一手源 tiebreak：若 support[] 含 L1 则以 L1 为准
3. 若全 L1 仍冲突（口径差异）：正文采用较保守值 + 脚注标注范围 `"$239B (Crunchbase News 一手口径) - $285.5B (CB Insights 一手口径，含并购)"`
4. 同源追溯（Check 10 独立性）的二手源之间差异不触发 C17——本质是单源

**示例 Reconciliation log 段头**：

```markdown
## 附录 X — Reconciliation log

### Claim: Q1 2026 全球 AI 融资总额

| 来源 | URL | Tier | 原文数字 | 检索日期 |
|------|-----|:-:|-------:|---------|
| Crunchbase News（一手） | https://... | L1 | $239B | 2026-04-03 |
| CB Insights（一手，不同口径） | https://... | L1 | $285.5B | 2026-04-05 |
| TheBranx Blog（二手） | https://... | L5 | $300B | 2026-04-10 |

**采用值**：$239B（Crunchbase News 一手口径，排除并购）
**差异说明**：CB Insights 含 M&A，口径差 ~$46.5B；TheBranx 数字无原始口径声明，判定跨源糊合，排除。
```

**分档**：所有 `--type` 下一旦触发条件即 blocking；market / academic 额外要求 ≥ 2 条独立 L1 支撑主数字。

## 二、6 维正交评分

详细公式 + 权重表 + 等级映射见 [scoring-rubric.md](scoring-rubric.md)。

简要：

| 维度 | 含义 | academic 权重 | industry 权重 |
|------|------|:-:|:-:|
| falsifiability | Popper 可证伪 | 0.25 | 0.15 |
| evidence_density | 证据密度 | 0.20 | 0.15 |
| reproducibility | 可复现 | 0.20 | 0.10 |
| source_diversity | 来源多样 | 0.15 | 0.20 |
| actionability | 可行动 | 0.05 | 0.25 |
| transparency | 透明度 | 0.15 | 0.15 |

**等级**：A ≥ 8.5 / B 7.0-8.4 / C 5.5-6.9 / D < 5.5。**任一 blocking check 失败 → Grade 封顶 D**。

评分块模板固定插入报告 footer，例见 [scoring-rubric.md](scoring-rubric.md) §五。

## 三、Structure Requirements

- **Title**：`# <topic> 调研报告`
- **Date line**：`> 日期：YYYY-MM-DD | 基于多源信息综合分析`
- **Numbering**：major section 中文序数（一、二、三...），subsection 十进制（1.1、1.2）
- **Comparisons**：3+ 可比项用表
- **Deep sections**：Stage 5 段注明视角来源（`> 以下内容由 Insight Fuse 多视角分析综合产出`）
- **References**：拆 `### 基础调研来源` + `### 深度调研来源`（若有 Stage 5）
- **Language**：主体中文，技术术语 inline English；URL 保留英文
- **Skeleton reference block**：报告顶部（日期戳之后）含 skeleton 摘要：
  ```markdown
  > Skeleton: <topic-slug>-<date>.yaml | dimensions: <count> | known_dissensus: <count> | hypotheses: <count>
  ```

## 四、Quality Scoring Dimensions（Informational）

详见 [scoring-rubric.md](scoring-rubric.md) 的分段式评分表。以下仅供快速参考：

| Dimension | Low (1-3) | Medium (4-6) | High (7-10) |
|-----------|-----------|-------------|-------------|
| Source diversity | 1-3 来源 | 4-8 来源 | 9+ 来源 |
| Perspective balance | 单视角 | 主流+反面 | 多视角含 critic 异议 |
| Actionability (主体) | 仅描述 | 含 implication | Specific scenario-conditional outlook |
| Actionability (Appendix) | 通用建议 | 受众定制 | strategy-graded + 基于主体引用 |
| Depth | 表面概览 | 覆盖关键方面 | 技术细节 + 数据 + 分析 |

## 五、Advisory Audience Whitelist

**仅当 main agent 主动询问候选受众时**（full 模式交互 prompt，或 quick/standard/deep 报告末尾的"可选 advisory 命令"提示）使用。**不得**作为受众值来源——实际 `{audience}` 必须来自用户显式 `--audience` 或交互选定。

```
新入局者 / 现任头部 / 投资人 / 政策制定者 / 早期用户 /
开发者 / 架构师 / 产品设计者 / 企业客户 / 消费者 / 平台方
```

若用户提供白名单外的自定义受众（例如具体公司名 "小米" 或 whitelist 之外角色），输入即为授权凭据——verbatim 记入 Appendix 授权戳。**不得**自动从 topic 或调研结果扩展 whitelist。

## 六、Anti-Patterns

报告禁止包含：

- **Unsourced statistics**（例："market grew 50%" 无 citation）
- **Vague attribution**（"according to various sources"、"experts say"）
- **Single-source copy-paste**（始终 rewrite + synthesize from multiple sources）
- **Unresolved contradictions**（来源分歧时必须 both-position 显式呈现 + 证据）
- **Marketing language without substance**（"revolutionary"、"game-changing" 无数据）
- **主体中的针对性建议**：`[R]` 标记段只允许出现在 Advisory Appendix；主体出现"对 X 来说应该…"、"给 X 的启示"、"对我们的启发"、"为 X 设计"均越过中立边界
- **从执行环境推断受众**：CWD、附加目录、IDE 文件、历史对话不得作为 `{audience}` 来源
- **主体与 Appendix 混杂**：主体只描述事实与格局（允许 scenario-conditional 分析如"若 A 成立，赢家是 X 类玩家"，但禁止第二人称与特定组织称呼）
- **未授权状态下生成 Appendix**：`--audience` 未设置或 `--no-advisory` 为 true 时，报告不得出现任何 Appendix（包括空壳标题）
- **合成共识绕过 Disagreement Template**：对 `known_dissensus` 项写"两派都有道理"而不呈现完整三段式

## 七、Scope Isolation

insight-fuse 对执行环境严格隔离。详见 [research-protocol.md](research-protocol.md) § Scope Isolation。

**例外的白名单**：

- `--skeleton <path>` 导入的 YAML 文件内容
- `--audience` / `--focus` / `--perspectives` 等参数显式值
- 用户消息中出现的专名
- WebSearch/WebFetch 返回的源文本

其他一切（CWD、附加目录、IDE、CLAUDE.md 等）**禁止**作为主体或 Appendix 的输入。Check 7 扫描此约束。
