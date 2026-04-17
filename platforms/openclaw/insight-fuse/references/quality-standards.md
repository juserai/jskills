# Report Quality Standards

Quality checklist for insight-fuse research reports. The main agent runs these checks before outputting the final report.

## Mandatory Checks

These are **blocking** — report is not valid until all pass:

| # | Check | Criterion |
|---|-------|-----------|
| 1 | Source density | Every section has at least 2 distinct source citations |
| 2 | Reference integrity | All inline citations appear in the reference list; no orphan URLs |
| 3 | Source diversity | No single source accounts for >40% of citations in any section |
| 4 | Evidence-backed claims | All comparison/ranking statements have supporting data (see examples below) |
| 5 | Date line present | Header includes `> 日期：YYYY-MM-DD` |
| 6 | Attribution | Report ends with forge attribution block |
| 7 | Environment isolation | 报告正文（包括主体与 Advisory Appendix）不得出现任何从执行环境（CWD / 附加目录 / 打开文件 / IDE 选中内容）推断的组织名、产品名、团队名。Compile 前做一次 grep 比对 —— 只允许出现在：① 用户消息 ② `--focus` / `--audience` 参数值 ③ WebSearch/WebFetch 返回的来源内容 中已出现的专名。命中未授权名即 reject |
| 8 | Neutral body only (scope: main body) | **作用域限定在"主体"**——即首个 `---` 分割线之前的正文（若无 Appendix，则整篇报告均为主体）。主体不得含针对性建议章节。检测正则（Chinese+English）：`对\s*\S+\s*(的)?建议\|给\s*\S+\s*(的)?启示\|对我们的启发\|为\s*\S+\s*(设计\|打造)\|启示录\|(advice\|recommendations?)\s+(for\|to)` —— 任一命中即 reject 末尾 section，要求 main agent 重写为中立 Outlook。**Advisory Appendix 区不受此约束**，由 Check 9 独立把关 |
| 9 | Advisory Appendix integrity | 若报告存在 Advisory Appendix，每个 Appendix 必须同时满足：① 以 `---` 起始，紧接标题 `## Appendix {A,B,...} — 针对 {audience} 的建议` ② 标题后 3 行授权戳（date / 参数 / 基于主体 §X）均存在 ③ 6 节结构全齐且顺序正确：受众画像 / 调研依据 / 推导链 / 策略梯度 / 风险与反事实 / 行动清单 ④ `{audience}` 值与 `--audience` 参数值（或 `full` 模式用户选定值）逐字一致 ⑤ §2 每条依据必须含 "§X" 式的主体章节引用 ⑥ §4 策略梯度为 3 列（保守/中庸/激进）对比表，`--strategy` 指定的那一列被标为推荐列。任一违反即 reject 该 Appendix，要求 main agent 重写 |

### Evidence-Backed Claims Examples

Comparison/ranking statements that require data support:

- "X is faster than Y" → must cite benchmark source
- "X leads the market" / "X ranks first" → must cite market share data
- "X outperforms Y in Z" → must cite specific metrics
- "most popular" / "widely adopted" → must cite adoption numbers or survey
- "more secure" / "more reliable" → must cite CVE counts, uptime data, or audit results

Acceptable: "X reported 99.9% uptime ([Source](url)), compared to Y's 99.5% ([Source](url))"
Not acceptable: "X is significantly more reliable than Y"

### Advisory Audience Whitelist

Used **only** when the main agent needs to surface candidate audiences (in `full` mode's interactive prompt, or in the "optional advisory command" hint at the end of `quick/standard/deep` reports). **Never** treat this list as a source of audience values — actual `{audience}` must come from the user's explicit `--audience` input or interactive selection.

```
新入局者 / 现任头部 / 投资人 / 政策制定者 / 早期用户 /
开发者 / 架构师 / 产品设计者 / 企业客户 / 消费者 / 平台方
```

If the user supplies a custom audience via `--audience` (e.g., a specific company name like "小米" or a role not in the whitelist), the input is authoritative — record it verbatim in the Appendix authorization stamp. Do NOT expand the whitelist automatically from the topic or research findings.

## Structure Requirements

- **Title**: `# {topic} 调研报告`
- **Date line**: `> 日期：YYYY-MM-DD | 基于多源信息综合分析`
- **Numbering**: Chinese numerals for major sections (一、二、三...), decimal for subsections (1.1, 1.2)
- **Comparisons**: Use tables when comparing 3+ items
- **Deep sections**: Attribute to perspective source when from Stage 5 (e.g., `> 以下内容由 Insight Fuse 多视角分析综合产出`)
- **References**: Split into `### 基础调研来源` and `### 深度调研来源`（if Stage 5 was executed）
- **Language**: Chinese primary, English technical terms inline. URLs in English

## Quality Scoring (Informational)

Non-blocking, for report quality self-assessment:

| Dimension | Low (1-3) | Medium (4-6) | High (7-10) |
|-----------|-----------|-------------|-------------|
| Source diversity | 1-3 sources | 4-8 sources | 9+ sources |
| Perspective balance | Single viewpoint | Mainstream + alternative | Multi-perspective with critic dissent |
| Actionability (main body) | Descriptive only | Includes implications | Specific **scenario-conditional** outlook (e.g., "if trend A continues, X-type players benefit"). Must stay impersonal — no "you / 读者 / 新入局者 / 我们" addressing |
| Actionability (Advisory Appendix, if present) | Generic advice | Audience-specific implications | Specific recommendations with tradeoffs, strategy-graded (conservative/balanced/aggressive), and grounded in main-body citations. Check 9 governs structural compliance |
| Depth | Surface overview | Covers key aspects | Technical details + data + analysis |

## Anti-Patterns

Do NOT produce reports that contain:

- Unsourced statistics (e.g., "market grew 50%" without citation)
- Vague attribution ("according to various sources", "experts say")
- Single-source copy-paste (always rewrite and synthesize from multiple sources)
- Unresolved contradictions (if sources disagree, state both positions with evidence)
- Marketing language without substance ("revolutionary", "game-changing" without data)
- **主体中的针对性建议**：报告**主体**（首个 `---` 之前）若出现"对 X 来说应该…"、"给 X 的启示"、"对我们的启发"、"X 的产品设计建议"、"为 X 设计" —— 均越过了主体的中立边界。这类内容只能出现在 Advisory Appendix 中，且需满足 Check 9
- **从执行环境推断受众**：不得把 CWD、附加工作目录名、最近打开的文件名、IDE 选中内容作为"调研对象"或"建议受众"依据。即使用户要求 Advisory，`{audience}` 也必须来自 `--audience` 参数值或 `full` 模式下用户交互选定 —— 不从环境推断具体组织/产品名
- **主体与 Appendix 混杂**：调研主体只描述事实与格局（允许 scenario-conditional 分析，如"若 A 成立，赢家是 X 类玩家"，但禁止第二人称与特定组织称呼）。Advisory 内容一律下沉到 Appendix，且必须有 `---` 分割线 + 授权戳
- **未授权状态下生成 Appendix**：若 `--audience` 未设置（或 `--no-advisory` 为 true），报告不得出现任何 Appendix，包括空壳 Appendix 标题
