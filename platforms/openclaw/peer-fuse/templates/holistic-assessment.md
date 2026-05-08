# § Holistic Assessment Template

Stage 5.5 输出。评价性叙述。可只读引用 § Document Reading，**MUST NOT** 修改它。

## 4 段提纲

### Methodological appraisal

评 argumentation chain：研究类型对应方法是否得当、证据 vs 主张张力、未受质疑的假设、与 best evidence 的距离。引用 panel methodologist 的 KEY_FINDINGS 与 Stage 1-3 中性数据。

### Strengths in context

**具体优点**——点出哪一节哪一处做得好以及好在哪。

**禁空话清单**（lint warning）：

- ❌ "comprehensive coverage" / "thorough analysis" / "well-structured"
- ❌ "good methodology" / "solid evidence base"
- ❌ "deep insights" / "broad perspective"
- ✅ "§3.2 把 hallucination 拆成三个层级，且每层级配独立 benchmark——这种
       framework-first approach 在 reviewer 见过的 12 份同主题报告里仅 2 份做到"
- ✅ "p.7 的 Reconciliation log 把跨源 ±3% 数字差异归因到测试日期不同（2024-Q3
       vs 2024-Q4），这是 IF Check 17 的标准做法但 50% 报告会跳过"

### Critical concerns

最影响 grade 的 2-3 个核心问题。**叙述化呈现**："为什么这是问题、对结论的影响如何"——不要把 Flag List 的 bullet 抄成长 bullet。

模式：

> Concern 1: <叙述 issue>
>
> The argument in <pos> rests on <single source / averaged range / unstated
> assumption>. <Why this matters>: <effect on conclusions>. <What would resolve it>:
> <pointer to suggested fix in § Diff Suggestions>.

不强制 bullet 化。如果有 3 个 concern，写 3 段；2 个 concern，2 段；不为凑数稀释。

### Recommendation

明确推荐等级（**Accept** / **Accept with minor revisions** / **Accept with major revisions** / **Borderline** / **Reject**）+ 一句话理由。

**等级映射**（映射 grade，可在 ±1 档微调）：

| review_grade | 默认 recommendation |
|---|---|
| A+ / A | Accept |
| A− / B+ | Accept with minor revisions |
| B / B− | Accept with major revisions |
| C+ / C / C− | Borderline |
| D | Reject |

微调要求：写出"why ±1"——例如 "B+ + Critical concerns are all minor → 我推
minor 而非 major"。

## 字数 / 段数

- 总字数：400-700 字（中英任一语种）
- 4 段（每段 100-175 字）
- 禁嵌套 bullet（叙述体）

## 引用方向约束（HARD）

- ✅ 可只读引用 § Document Reading：`如 § Document Reading 所述...`、`Para 2 描述的论证链...`
- ❌ MUST NOT 修改 § Document Reading（Stage 7 hash diff 校验）
- ✅ 可引用 Stage 4 panel KEY_FINDINGS（"as methodologist noted, ..."）
- ✅ 可引用 Stage 5 分数（"准确性维 7.5 主要扣在 ..."）
- ✅ 可引用 Stage 6 diff 块位置（"具体改写见 § Diff Suggestions Diff 3"）

## panel 综合方式

Stage 5.5 不是机械拼接 3 个 panel verdict。主线程做综合：

1. 三方 KEY_FINDINGS 取并集，去重，按 severity 排序
2. 三方 FLAGS_RAISED 取并集；冲突时（一方说有、一方没说）信任有的那方
3. 三方 VERDICT_SUMMARY 提炼共同点 + 分歧点
4. 综合写出 4 段，**不再标注**"methodologist 说 X"——已被综合，但可以引用具体 finding
