# § Document Reading Template

Stage 3.5 输出。**评审隔离区**——纯描述性叙述，与评审结果严格隔离。

## 工作流隔离

```
            [Stage 1-3 中性扫描结果]
                    ↓
                    ↓ ← (输入边界)
                    ↓
       Stage 3.5 ─────→ § Document Reading ─→ FREEZE (hash snapshot)
                                                 │
                                                 ↓ (read-only ref)
       Stage 4 panel ─→ Stage 5 scores ─→ Stage 5.5 § Holistic Assessment

                       ✗ NEVER write back into § Document Reading
```

## 输入边界（MUST 严格）

✅ **接受**：
- 原文档 `source_view` / `canonical_view`
- Stage 1 结构审的事实结果（"frontmatter 缺失"、"H1/H2/H3 hierarchy 是 1-2-3"、"参考文献页存在于 p.42"）
- Stage 2 证据审的事实结果（"引用密度 = 3.2/section"、"L1 比例 = 0.6"）
- Stage 3 逻辑审的事实结果（FIR 标签出现位置、OOS 关键词列表）

❌ **拒绝**：
- Stage 4 panel verdict / KEY_FINDINGS / FLAGS_RAISED
- Stage 5 任何分项分数 / 加权总分 / 字母 grade
- Stage 5/6 命中的 flag code
- 任何评价语（"strong"、"weak"、"concern"、"problem"、"应当"、"建议"）

> 区分原则：**事实**（"frontmatter 缺失"）vs **评价**（"frontmatter 不完整"）。前者描述事实，后者已含评价倾向。Stage 3.5 只用前者。

## 5 段提纲

### Para 1 — Manuscript summary（必有）

reviewer 用自己的话**重述**文档讲了什么：核心论点、论证骨架、关键证据、目标读者、文档自我定位的边界（什么是它声称要做的、什么不是）。

**MUST**：≥ 1 处原文 verbatim 引用，带位置标记（按 `target_format` 适配）。

例子（md 格式）：

> 这份报告的核心是把 LLM hallucination 拆成三个层级：事实错（factuality
> error）、构念混淆（construct conflation）、与生成偏移（generative drift）。
> 第 2 节给出操作化定义："Hallucination is any output not grounded in
> retrievable evidence under the model's stated retrieval policy"（§2.1）。

### Para 2 — Argumentation chain

文档**怎么论证**：从前提到结论的链条、关键证据来源（不评价，只描述出处）、跨节如何递进、是否使用 dissensus preservation 等结构化手法。

例子：

> 第 3 节用三组 benchmark（TriviaQA / NaturalQuestions / 内部 RealEval-2024）
> 给出层级一的失败率，第 4 节继续把同样三组 benchmark 切到层级二，并新增
> Anthropic 内部 measure-agent-autonomy 数据集做层级三。Section 5 把三层
> 结果对照 Apple EMNLP 2024 论文的 attention-shift 假说做机制层串联。

### Para 3 — Key claims & evidence base

文档的**主要声明**和它们各自的**支持证据是什么**——只列出，不评价质量。

例子：

> 主要声明有四：H1（层级一在 SOTA 模型上稳定低于 5%）、H2（层级二与
> 模型规模负相关）、H3（层级三由 attention-shift 主导）、H4（RAG 仅缓解
> 层级一）。H1 引 5 篇 2024+ benchmark 论文；H2 引 Anthropic + DeepMind
> scaling 数据；H3 引 Apple EMNLP；H4 引 Stanford LangChain 评测。

### Para 4 — Scope & boundary（如适用）

文档**自己声明**的 scope / OOS / 假设——只复述，不评价是否合理。

例子：

> 文档明示三个 OOS：多模态生成（only text-to-text）、模型微调对幻觉的
> 影响（only off-the-shelf）、商用闭源 RAG 系统（only public benchmarks）。
> 在 §1.3 与 §6 各重申一次。

### Para 5 — Audience & format note（如适用）

文档为谁写、什么场合用——基于格式 / 章节风格 / 词汇判断。

例子：

> 行文以技术 lead 与 ML 研究员为目标读者：术语门槛高（attention-shift /
> calibration / FIR 标签皆默认读者熟悉），表格密度高，TL;DR 在 §1 而非
> 文末——倾向"被引用"而非"被通读"的结构。

## 字数 / 段数

- 总字数：300-600 字（中英任一语种）
- 段数：3-5 段（Para 1 + Para 2 必有；其余按文档实际情况裁剪）
- 禁嵌套 bullet（Stage 3.5 是叙述体，结构化条目留给 Stage 5+）

## 禁词清单（lint 强制）

本节内 **MUST NOT** 出现：

- 评价性词汇：`grade / score / flag / strong / weak / concern / issue / problem / shortcoming / fail / violate / 优点 / 缺点 / 不足 / 薄弱 / 错误 / 应当改 / 建议 / better / worse`
- Flag code 字面量：`F-EVD-NN` / `F-STAT-NN` / `F-LOGIC-NN` / `F-SCOPE-NN` / `F-COST-NN` / `F-METHOD-NN` / `F-DISAGREE-NN` / `F-CONSTRUCT-NN` / `F-CITE-NN` / `F-CONF-NN` / `F-DELTA-NN`
- 字母 grade 上下文：`A+ / A / A− / A- / B+ / B / B− / B- / C+ / C / C− / C- / D`（在评分语境下；如纯引用原文标题"Section A" 不算）
- 评价节引用：`§ Score Matrix` / `§ Flag List` / `§ Multi-Perspective Panel` / `§ Diff Suggestions` / `§ Holistic Assessment`

## 写后冻结（HARD）

Stage 3.5 完成后：

1. 主线程对 § Document Reading 全文计算 SHA-256，存入内存
2. Stage 4 / 5 / 5.5 / 6 期间不重写本节
3. Stage 7 归档前重新计算 hash，与 Stage 3.5 后快照对比：
   - 一致 → 归档
   - 不一致 → fail-closed：`Archive: blocked (Document Reading modified post-Stage 3.5)`，**不写文件**

> 写后冻结是用户硬约束的最后防线。架构隔离 + 禁词 lint + hash 校验三层防御缺一不可。
