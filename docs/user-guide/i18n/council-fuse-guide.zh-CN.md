# Council Fuse 用户指南

> 5 分钟上手 — 多视角审议，获得更优答案

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserai/forge
```

### 通用一行安装

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **零依赖** — Council Fuse 无需任何外部服务或 API。安装即用。

---

## 命令

| 命令 | 功能 | 使用场景 |
|------|------|---------|
| `/council-fuse <问题>` | 运行完整的评议会审议 | 重要决策、复杂问题 |

---

## 工作原理

Council Fuse 将 Karpathy 的 LLM Council 模式浓缩为单个命令：

### 阶段 1：召集

三个代理以不同视角**并行**生成：

| 代理 | 角色 | 模型 | 优势 |
|------|------|------|------|
| 通才 | 平衡、务实 | Sonnet | 主流最佳实践 |
| 批评者 | 对抗性、查找缺陷 | Opus | 边界情况、风险、盲点 |
| 专家 | 深入技术细节 | Sonnet | 实现精度 |

每个代理**独立**回答 — 彼此看不到对方的回复。

### 阶段 2：评分

主席（主代理）将所有回复匿名化为回复 A/B/C，然后在 4 个维度上评分（0-10）：

- **正确性** — 事实准确度、逻辑合理性
- **完整性** — 各方面的覆盖程度
- **实用性** — 可操作性、现实世界适用性
- **清晰度** — 结构、可读性

### 阶段 3：综合

得分最高的回复成为骨架。其他回复中的独特见解被整合。批评者的合理异议作为注意事项保留。

---

## 使用场景

### 架构决策

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

通才提供平衡的权衡分析，批评者质疑微服务炒作，专家详述迁移模式。综合结果给出有条件的建议。

### 技术选型

```
/council-fuse Redis vs PostgreSQL for our job queue
```

三个不同角度确保你不会遗漏运维顾虑（批评者）、实现细节（专家）或务实的默认选择（通才）。

### 代码评审

```
/council-fuse Is this error handling pattern correct? <paste code>
```

一次获得主流验证、对抗性边界分析和深入技术校验。

---

## 输出结构

每次评议会审议生成：

1. **评分矩阵** — 三个视角的透明评分
2. **共识分析** — 一致与分歧之处
3. **综合答案** — 融合后的最佳答案
4. **少数意见** — 值得关注的合理异议

---

## 自定义

### 更改视角

编辑 `agents/*.md` 定义自定义评议会成员。备选三人组：

- 乐观者 / 悲观者 / 务实者
- 架构师 / 实现者 / 测试者
- 用户代言人 / 开发者 / 安全专家

### 更改模型

编辑每个代理文件中的 `model:` 字段：

- `model: haiku` — 经济型评议会
- `model: opus` — 全重量级，用于关键决策

---

## 平台

| 平台 | 评议会成员工作方式 |
|------|------------------|
| Claude Code | 3 个独立 Agent 并行生成 |
| OpenClaw | 单个代理，3 轮顺序独立推理 |

---

## 使用场景 / 不应使用场景

### ✅ 适用

- Architectural decisions needing multiple perspectives
- You suspect confirmation bias in your current answer
- You want dissenting views preserved, not erased

### ❌ 不适用

- Pure factual queries (use `claim-ground` instead)
- Creative writing (synthesis flattens style)
- Speed-critical decisions (3 agents run sequentially — not fast)

> 基于训练知识的辩证引擎——暴露单视角盲点，但结论仍受训练知识限制。

完整边界分析: [references/scope-boundaries.md](../../../skills/council-fuse/references/scope-boundaries.md)

---

## 常见问题

**问：是否消耗 3 倍 token？**
答：大致如此。三个独立回复加上综合处理。请在值得投入的决策上使用。

**问：可以添加更多评议会成员吗？**
答：框架支持——添加一个 `agents/*.md` 文件并更新 SKILL.md 工作流即可。不过，3 是成本与多样性的最佳平衡点。

**问：如果某个代理失败了怎么办？**
答：主席将该成员评分为 0，从剩余回复中综合。优雅降级，不会崩溃。
