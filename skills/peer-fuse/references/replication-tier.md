# Replication Tier

每个核心发现 SHOULD 标注复现层级。peer-fuse Stage 2 检查覆盖率（F-EVD-04）。

## 三档定义

| Tier | 标记 | 判据 |
|---|---|---|
| **preliminary** | `[prelim]` | 单一研究 / 单一团队 / 单一数据集；无独立复现 |
| **replicated** | `[repl]` | ≥ 2 独立团队 / 数据集复现；同向但效应量可能差异 |
| **strongly_replicated** | `[strong-repl]` | ≥ 3 独立复现 + meta-analysis 或系统综述支撑；效应量稳定 |

## 标注位置

- markdown / html：行内紧跟主张，如 `Models hallucinate ~15% of factual queries [prelim]`
- pdf / docx / pptx：reviewer 在 § Document Reading 中标注（原文档可能不带，peer-fuse 不强行篡改原文，只在 review 中标注）

## 判定流程（Stage 2）

1. 提取核心发现（H1-H5 假设；TL;DR 中的 quantitative claims）
2. 对每个发现搜索引用列表，统计独立来源数
3. 应用判据 → tier
4. 与原文档既有标注比对：
   - 一致 → 不报 flag
   - 不一致 → reviewer 自己的 tier 写入 § Holistic Assessment（不改 § Document Reading）
   - 原文档完全无标注 → F-EVD-04 触发（med 级）

## 反例

- ❌ 把 1 篇 arXiv preprint 当成 strongly_replicated（preprint 本身就是 preliminary）
- ❌ 把"作者团队后续 3 篇 follow-up"当独立复现（同团队不计独立）
- ❌ 漏标 → 默认 preliminary（保守）
- ✅ Anthropic + DeepMind + OpenAI 三家独立观察 → strongly_replicated
