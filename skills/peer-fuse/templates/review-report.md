# Review Report Template

Stage 7 归档与内联渲染共用此结构。

## 完整结构

```markdown
---
source_skill: peer-fuse
target_report: <path-to-target>
target_self_grade: <e.g. "B+ (7.8)" or null if no self-grade>
review_grade: <字母 grade>
delta: <review - self if both present, else null>
research_type: <one of 6 presets>
type_detection: auto | explicit
target_format: <ext>
adapter_tier: <1|2|3>
depth: <quick|standard|deep|full>
flags: [<F-XXX-NN>, ...]
panel: [methodologist, adversarial, practitioner]
recommendation: <accept|minor-revisions|major-revisions|borderline|reject>
date: <YYYY-MM-DD>
---

## Peer Fuse — Peer Review Report

**Target**: [path](../path/to/target)
**Review grade**: <X>
**Recommendation**: <tier>

---

### § Document Reading

<3-5 段散文，纯描述性，写于 Stage 3.5，FREEZE 后不可改>

---

### § Holistic Assessment

<4 段散文，写于 Stage 5.5>

#### Methodological appraisal

<段落>

#### Strengths in context

<段落>

#### Critical concerns

<段落>

#### Recommendation

<段落，含 recommendation tier 与理由>

---

### § Score Matrix

| 维度 | 分项 (0-10) | 权重 (research_type=<X>) | 加权 |
|---|---:|---:|---:|
| 准确性 | <n> | <w> | <n×w> |
| ... | ... | ... | ... |
| **加权总分** | | | **<sum>** |
| **字母 grade** | | | **<letter>** |

---

### § Flag List

| Code | 严重度 | 位置 | 简述 |
|---|:-:|---|---|
| F-EVD-01 | high | <pos> | <reason> |
| ... | ... | ... | ... |

---

### § Multi-Perspective Panel

#### Methodologist

CONFIDENCE: <n>/10

<KEY_FINDINGS 摘录>
<VERDICT_SUMMARY>

#### Adversarial

<同结构>

#### Practitioner

<同结构>

---

### § Diff Suggestions

<每个失分项一个 review-diff-block，详见 templates/review-diff-block.md>

---

### § Reconciliation

target_self_grade: <X> vs review_grade: <Y>
Δ = <Y − X>

<若 |Δ| ≥ 1.0 grade，给一段说明 review 与 self 差距来源>

---

> Reviewed by [forge/peer-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
```

## 渲染顺序约束（HARD）

1. **§ Document Reading 永远在最前**（仅次于 H2 标题）——它是评审隔离区的产出，描述性叙述先于评价
2. **§ Holistic Assessment 紧随其后**——叙述性评价对比 § Document Reading
3. 结构化条目段（Score Matrix / Flag List / Panel / Diff / Reconciliation）在叙述段之后

## quick depth 删减

`--depth=quick` 时，删除 § Holistic Assessment + § Multi-Perspective Panel，其余结构保留（仍渲染 § Document Reading + § Score Matrix + § Flag List + § Diff Suggestions + § Reconciliation）。
