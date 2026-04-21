# Reconciliation Log — 跨源数字冲突调和模板

Check 17 触发条件：同一量化声明的 `support[]` 返回 ≥ 2 条跨源数字且差异 > 5%（或跨类别）。报告必须以附录形式套本模板，**正文采用值必须在此处说明依据**。

## 模板骨架

```markdown
## 附录 X — Reconciliation log

### Claim: <量化声明原文，含 ID 如 [#c-slug]>

| 来源 | URL | Tier | 检索日期 | 原文数字 | 口径 |
|------|-----|:-:|---------|---------|------|
| <Source 1，一手> | <url1> | L1 | YYYY-MM-DD | <value1> | <口径说明> |
| <Source 2，一手/不同口径> | <url2> | L1 | YYYY-MM-DD | <value2> | <口径说明> |
| <Source 3，二手> | <url3> | L5 | YYYY-MM-DD | <value3> | <无口径声明 / 推测混合口径> |

**采用值**：<最终正文使用的数字> （<来源理由：一手 tiebreak / 保守 / 最新 等>）

**差异说明**：
- <Source 1> 与 <Source 2> 差异 <X%>，根因是 <口径 A 含 M&A / 口径 B 排除 IPO / 时间窗错位 ...>
- <Source 3> 数字无原始口径声明，判定为 <跨源糊合 / LLM 合成 / 已知聚合博客 ...>，排除

**正文引用标注**：
- 正文该声明段以 `{P}` 引 <采用值来源>
- 其他 L1 源以 `{S→<采用值 URL>}` 作为佐证引（非推翻）
- 非 L1 源不进正文；若主题相关可写入 "5. 弱引用清单"
```

## Rule Book

### 1. 何时触发

- 同声明 support ≥ 2 条，任意两值差异 > 5%（对数字）
- 同声明 support ≥ 2 条，分类不一致（"第一名" vs "第三名"；"基础模型" vs "自动驾驶"）
- 声明含范围（"$239B - $285.5B"）且范围大小 > 20% 时必须 reconcile；否则可作 inline 范围标注不触发附录

### 2. Tiebreak 优先级

1. L1 > L2 > L3 > L4 > L5
2. 同 tier：发布日期新的优先；同日期：样本覆盖更宽的优先
3. 全 L1 但口径不同：**正文取较保守值**（通常是排除并购 / 排除二级市场 / 以 audited 为准），附录完整列出范围

### 3. 禁止的 reconcile 方式

- **取中位数 / 平均值**：除非各源口径完全一致，否则平均是信息损失
- **挑选支持某论点的数字**：必须基于 tier + 口径依据，不是结论先行
- **忽略冲突**：即便差异小，只要 > 5% 阈值就必须记录；差异小的可以一句话带过
- **口径说明为空**：每条来源必写口径；无法确定则标 `口径未声明`，此类来源权重自动降一级

### 4. 与 Check 10（Source independence）的关系

若两条"冲突"来源实际追溯到同一原始数据（例如 Reuters 转述 Crunchbase），视为**同源**，不触发 C17；而是触发 C10 独立性声明。独立性 + reconcile 的组合场景：

- A（一手） + B（A 的转述） + C（另一一手，数字不同）
  → C10 标 A 与 B 同源（有效独立 = 2）
  → C17 在 A 与 C 之间 reconcile

### 5. 写入位置

- 附录编号：若已有 Advisory Appendix A/B，Reconciliation log 用 `附录 R-1 / R-2 / ...`（R = Reconciliation）
- 多条冲突声明：每条一个 R 子附录，按正文 claim ID 字母序
- 正文长度：正文采用值之后 1 句话带过理由（如 "采用 Crunchbase News 一手口径，排除并购"），详细比对留附录

### 6. Reconciliation log 自身的 QA

Stage 6 Check 17 扫描 Reconciliation log 本身：

- `采用值` 必须明确（不是 "$X-$Y 范围"，范围要落 inline）
- 每条来源必带 `口径`（即便 `口径未声明`）
- 至少 1 条来源 tier 为 L1；全 L2-L5 的 reconcile 视为 C15 fail
- 采用值来源必须在正文对应声明的 `{P}` 引用中出现

## 最小示例（本模板自带的参考实例）

```markdown
## 附录 R-1 — Reconciliation log

### Claim [#c-q1-2026-vc-total]: Q1 2026 全球 AI megadeal 融资总额

| 来源 | URL | Tier | 检索日期 | 原文数字 | 口径 |
|------|-----|:-:|---------|---------|------|
| Crunchbase News | https://news.crunchbase.com/venture/record-breaking-funding-ai-global-q1-2026/ | L1 | 2026-04-03 | $239B | 排除并购，按股权轮次聚合 |
| CB Insights State of Venture Q1'26 | https://www.cbinsights.com/research/... | L1 | 2026-04-05 | $285.5B | 含 M&A 与战略投资 |
| TheBranx Blog | https://thebranx.com/... | L5 | 2026-04-10 | $300B | 口径未声明 |

**采用值**：$239B（Crunchbase News 一手口径，排除并购）

**差异说明**：
- Crunchbase 与 CB Insights 差异 $46.5B（≈ 19%），根因为 CB Insights 含 M&A 与战略投资
- TheBranx 数字无原始口径声明，判定跨源糊合，排除

**正文引用标注**：正文 §3.1 以 `{P}` 引 Crunchbase News；CB Insights 以 `{S→crunchbase-news-url}` 佐证口径对比表。
```

## 与其他 Check 的联动

- **Check 15** 已要求 support[] 含 L1；Reconciliation log 在此基础上处理"L1 内部也有冲突"的情形
- **Check 16** 要求每条 verbatim quote；Reconciliation log 的每条来源**不必重复 quote**（在正文 `> 原文：...` 段已有），但 URL 必须可溯
- **Check 10** 覆盖同源识别；Reconciliation log 不处理同源转述的虚假冲突
