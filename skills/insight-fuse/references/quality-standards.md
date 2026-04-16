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

### Evidence-Backed Claims Examples

Comparison/ranking statements that require data support:

- "X is faster than Y" → must cite benchmark source
- "X leads the market" / "X ranks first" → must cite market share data
- "X outperforms Y in Z" → must cite specific metrics
- "most popular" / "widely adopted" → must cite adoption numbers or survey
- "more secure" / "more reliable" → must cite CVE counts, uptime data, or audit results

Acceptable: "X reported 99.9% uptime ([Source](url)), compared to Y's 99.5% ([Source](url))"
Not acceptable: "X is significantly more reliable than Y"

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
| Actionability | Descriptive only | Includes implications | Specific recommendations with tradeoffs |
| Depth | Surface overview | Covers key aspects | Technical details + data + analysis |

## Anti-Patterns

Do NOT produce reports that contain:

- Unsourced statistics (e.g., "market grew 50%" without citation)
- Vague attribution ("according to various sources", "experts say")
- Single-source copy-paste (always rewrite and synthesize from multiple sources)
- Unresolved contradictions (if sources disagree, state both positions with evidence)
- Marketing language without substance ("revolutionary", "game-changing" without data)
