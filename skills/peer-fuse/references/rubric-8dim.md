# 8-Dimension Rubric

8 个正交维度评价研究工件质量，由 Stage 0.5 决定的 `research_type` 加权。

## 维度定义（0-10 分）

| 维度 | 评分锚点（10 = 优；0 = 失格） |
|---|---|
| **准确性** | 事实 / 定量陈述与权威来源一致；版本号 / 实验元数据无错配；定量 claim 跨源调和 |
| **全面性** | 主流方向无遗漏；OOS 边界明确；known dissensus 被显式保留 |
| **深度** | 机制层拆解（不止现象描述）；变量 / 假设 / 因果链清晰 |
| **新颖性** | 含 2024+ 整合 / 新近 evidence / 跨域综合；不仅复述 |
| **可操作性** | checklist 三件套（actor / action / metric）；可被工程落地 |
| **可读性** | 结构清晰；表格 / 跳转 / 摘要齐备 |
| **客观性** | 不掩盖反例；立场未污染主体；披露利益冲突 |
| **可证伪性** | 主张配 falsification condition；不是不可反驳的口号 |

## 按 type 加权（默认 overview，其它 type 偏移）

| 维度 | overview | technology | market | academic | product | competitive |
|---|:-:|:-:|:-:|:-:|:-:|:-:|
| 准确性 | 0.18 | 0.22 | 0.23 | 0.18 | 0.16 | 0.22 |
| 全面性 | 0.13 | 0.13 | 0.12 | 0.13 | 0.12 | 0.13 |
| 深度 | 0.13 | 0.14 | 0.10 | 0.14 | 0.13 | 0.12 |
| 新颖性 | 0.10 | 0.10 | 0.14 | 0.06 | 0.13 | 0.10 |
| 可操作性 | 0.13 | 0.16 | 0.12 | 0.07 | 0.19 | 0.13 |
| 可读性 | 0.10 | 0.09 | 0.10 | 0.07 | 0.10 | 0.10 |
| 客观性 | 0.13 | 0.10 | 0.13 | 0.17 | 0.10 | 0.17 |
| 可证伪性 | 0.10 | 0.06 | 0.06 | 0.18 | 0.07 | 0.03 |
| **合计** | **1.00** | **1.00** | **1.00** | **1.00** | **1.00** | **1.00** |

> overview 是 default 表；其它 5 type 沿同一总和约束（=1.00）按 type 特性偏移。修改本表 MUST 通过 openspec change 提案，不可单方面调整。

## 加权总分 → 字母 grade

| 范围 | grade | recommendation 默认映射 |
|---|:-:|---|
| ≥ 9.0 | A+ | accept |
| 8.5-8.9 | A | accept |
| 8.0-8.4 | A− | minor-revisions |
| 7.5-7.9 | B+ | minor-revisions |
| 7.0-7.4 | B | major-revisions |
| 6.5-6.9 | B− | major-revisions |
| 6.0-6.4 | C+ | borderline |
| 5.5-5.9 | C | borderline |
| 5.0-5.4 | C− | borderline |
| < 5.0 | D | reject |

reviewer 可基于 critical concerns 在 ±1 档微调 recommendation 并在 § Holistic Assessment Para 4 说明理由。

## 评分操作流程（Stage 5）

1. Stage 4 panel 各产 `REVIEW_RESPONSE`，含 `KEY_FINDINGS` 与 `FLAGS_RAISED`
2. 主线程对每个维度逐项打分（0-10）：
   - 综合 panel 三方 verdict（无单边赋权——三方均权）
   - 调用 Stage 1-3 的事实性扫描结果（引用密度、L1 比例、FIR 标签等）
3. 应用 `research_type` 加权 → 加权总分
4. 加权总分 → 字母 grade（上表）
5. 写入 `## § Score Matrix` 节：每维分项 + 加权 + 总分 + 字母 grade
