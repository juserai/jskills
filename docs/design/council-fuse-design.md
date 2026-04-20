# council-fuse 设计文档

**日期**: 2026-03-31
**状态**: 已批准

## 定位

蒸馏 Karpathy 的 LLM Council 模式：同一问题发给 3 个独立视角的 agent，匿名评分后由 Chairman 综合最优答案。适用于架构决策、技术选型、代码审查等需要多角度验证的场景。

## 覆盖与边界

> council-fuse 是**基于训练知识的辩证引擎**——它让三个视角撞一撞，把单视角盲点暴露出来，但撞出来的结论仍受限于训练知识本身。

完整分析（能解决 / 不能解决 / 不应使用）：[references/scope-boundaries.md](../../skills/council-fuse/references/scope-boundaries.md)

## 命名

遵循 `名词-动词` 模式：council(议会) + fuse(熔合)。分类为 crucible（坩埚 — 多源融合、知识沉淀）。

## 核心机制

### 三阶段流水线

```
Stage 1: Convene（并行）      Stage 2: Score          Stage 3: Synthesize
┌────────────┐
│ Generalist │──┐
│   (sonnet)  │  │
└────────────┘  │    ┌──────────────┐    ┌──────────────────┐
┌────────────┐  ├──→ │ 匿名化 A/B/C │──→ │ 以最高分为骨架    │
│   Critic   │──┤    │ 4 维评分      │    │ 融入独特洞察      │
│   (opus)   │  │    │ 共识分析      │    │ 保留有效反对意见   │
└────────────┘  │    └──────────────┘    └──────────────────┘
┌────────────┐  │
│ Specialist │──┘
│   (sonnet)  │
└────────────┘
```

### 评分维度

| 维度 | 权重 | 说明 |
|------|------|------|
| Correctness | 0-10 | 事实准确性、逻辑自洽 |
| Completeness | 0-10 | 覆盖面、是否遗漏关键方面 |
| Practicality | 0-10 | 可操作性、现实约束考量 |
| Clarity | 0-10 | 结构清晰度、可读性 |

### 共识模式

| 模式 | 定义 | 处理方式 |
|------|------|---------|
| 强共识 | 3 方核心结论一致 | 合并细节，高置信度输出 |
| 多数+异议 | 2 方一致，1 方不同 | 多数为主，异议作为 Minority Opinion |
| 三方分歧 | 核心结论各不相同 | 逐一分析优劣，给出有条件推荐 |

## Agent 设计

每个 Agent 独立运行，互不可见：

| Agent | 角色 | 模型 | 设计理由 |
|-------|------|------|---------|
| Generalist | 平衡、务实 | Sonnet | 代表主流最佳实践，成本适中 |
| Critic | 对抗、找缺陷 | Opus | 边界情况和风险需要最强推理能力 |
| Specialist | 深度技术细节 | Sonnet | 实现精度，成本适中 |

Agent 定义存放在 `agents/*.md`，可自定义替换。

## 输出结构

```markdown
## Council Fuse — Deliberation

**Question:** <原始问题>

### Score Matrix
（4 维 × 3 回答的评分矩阵）

### Consensus Analysis
（共识模式 + 一致点 + 分歧点）

### Synthesized Answer
（主要交付物）

### Minority Opinion
（有效但未采纳的少数意见）
```

## 行为约束

1. 解析用户问题
2. **并行**发起 3 个 Agent 调用（必须在同一 response 中）
3. 收集 3 个 COUNCIL_RESPONSE 块
4. 匿名化为 Response A/B/C（随机分配，不暴露来源）
5. 4 维评分，计算总分
6. 分析共识模式
7. 以最高分回答为骨架综合
8. 输出完整 Deliberation 报告
9. 末尾附加 attribution

## 降级策略

- 1 个 Agent 失败：该 Agent 评分为 0，从剩余 2 个综合
- 2 个 Agent 失败：直接输出唯一成功的回答，标注为单视角
- 全部失败：报告失败，建议用户直接提问

## 文件清单

```
skills/council-fuse/SKILL.md                          # 核心 skill 定义
skills/council-fuse/references/council-protocol.md     # 结构化输出格式
skills/council-fuse/references/synthesis-methodology.md # Chairman 综合算法
skills/council-fuse/agents/council-generalist.md       # 通才角色定义
skills/council-fuse/agents/council-critic.md           # 批评者角色定义
skills/council-fuse/agents/council-specialist.md       # 专家角色定义
evals/council-fuse/scenarios.md                        # 评估场景
evals/council-fuse/run-trigger-test.sh                 # 触发测试
docs/user-guide/council-fuse-guide.md                       # 使用手册
```

## 与现有 skill 的关系

- 零依赖，独立使用
- 无 hooks（手动触发）
- 无 scripts（纯 AI 执行）
- 可选组合：与 block-break 配合，在 agent 卡住时施加约束

## 参考来源

- [Karpathy LLM Council pattern](https://x.com/karpathy/status/1821277264996352246) — 核心灵感
- [LLM-as-a-Judge](https://arxiv.org/abs/2306.05685) — 匿名评审方法论
