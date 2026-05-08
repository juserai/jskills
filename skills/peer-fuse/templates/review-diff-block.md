# Review Diff Block Template

Stage 6 每个失分项产一个 diff 块。patch-style，三段：位置 / 原文 / 建议。

## 单 diff 块格式

```markdown
#### Diff: <flag-code> at <position>

**Where**: <position marker, e.g. "p.3" or "§3.2 - Methods" or "slide.7">

**Original** (verbatim):

> <quote 原文片段，1-3 句最多 80 字>

**Suggested rewrite**:

> <reviewer 建议改写，保持原意但补足缺陷>

**Why**: <一句话说明为什么这样改解决了 <flag-code>>
```

## 例子

```markdown
#### Diff: F-EVD-03 at p.7

**Where**: p.7, "Results" section, paragraph 2

**Original** (verbatim):

> Models hallucinate ~15% of factual queries on average.

**Suggested rewrite**:

> Models hallucinate ~15% of factual queries on average (n=2000 queries,
> tested on Claude 3.5 Sonnet 2025-06 + GPT-4o 2025-08; methodology:
> [link to prompt set]; std dev ±3.2%).

**Why**: F-EVD-03 (缺实验元数据) — 原文给了数字但缺 model_version / sample_size / 方法链接，读者无法判断 generalizability 或复现。
```

## 约束

- **Position MUST 与 Stage 3.5 § Document Reading 用同一位置标记方案**（按 `target_format`）
- **原文 verbatim**：不重述、不改写——必须 1:1 引用源文档
- **建议改写最小变更**：只补缺失字段，不重写整段
- **每 diff 一个 flag**：如多个 flag 都指向同一段落，分别开 diff 块
- **block 数量上限**：每份 review ≤ 15 个 diff（更多说明文档需要 major-revisions 而非补丁）

## 排序

按 `flag.severity` 降序（high → med → low → info），同 severity 按位置先后。
