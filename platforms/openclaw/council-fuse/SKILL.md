---
name: council-fuse
description: "Council Fuse — Multi-perspective deliberation engine. 3 agents debate independently, Chairman synthesizes the best answer."
license: MIT
metadata:
  category: crucible
  permissions:
    network: false
    filesystem: read-write
    execution: none
    tools: [Read, Write, Glob, Edit]
argument-hint: "[question or task] [--no-save]"
---

# Council Fuse — 多视角议会蒸馏引擎

蒸馏 Karpathy 的 LLM Council 模式：同一问题发给 3 个独立视角的 agent，匿名评分后由 Chairman 综合最优答案。

## 自动激活（无 Hook 环境）

在没有 hook 系统的平台上，当用户明确请求多视角分析、议会式讨论、或对重要决策需要多方论证时，你应主动进入 Council Fuse 模式。

触发信号：
1. 用户说"帮我从多个角度分析"、"给我不同视角"、"这个决策需要全面考虑"
2. 用户面临二选一或多选一的技术/架构决策
3. 用户明确调用 `/council-fuse`

## 工作流

### Stage 1 — 三视角独立推理

你需要**分三轮独立思考**，每轮切换到不同视角。关键：每个视角必须独立回答，不受前一个视角影响。

**视角 1 — 通才（Generalist）**：
- 从第一性原理出发
- 平衡、务实、主流最佳实践
- 优先清晰度和正确性

**视角 2 — 批评者（Critic）**：
- 挑战假设，找漏洞
- 识别边界情况、失败模式、安全隐患
- 如果显而易见的答案有缺陷，找到它

**视角 3 — 专家（Specialist）**：
- 最大技术精度
- 包含实现细节、具体代码、API 引用
- 深度优于广度

每个视角输出一个 COUNCIL_RESPONSE 块（格式见 `references/council-protocol.md`）。

### Stage 2 — 匿名评审

收集 3 个视角的回答后：

1. **匿名化**：去掉视角标签，随机分配 Response A/B/C
2. **4 维评分**（正确性/完整性/实用性/清晰度，各 0-10）
3. **共识分析**：分类为强共识 / 多数+异议 / 三方分歧

详细评分算法见 `references/synthesis-methodology.md`。

### Stage 3 — 综合

1. 以最高分回答为骨架
2. 融入其他回答的独特洞察
3. 保留批评者的有效反对意见
4. 解决矛盾（不回避、不平均化）

### 输出格式

```markdown
## Council Fuse — Deliberation

**Question:** <原始问题>

### Score Matrix

| Dimension | Response A (perspective) | Response B (perspective) | Response C (perspective) |
|-----------|------------------------|------------------------|------------------------|
| Correctness | X | X | X |
| Completeness | X | X | X |
| Practicality | X | X | X |
| Clarity | X | X | X |
| **Total** | XX | XX | XX |

### Consensus Analysis

<共识模式 + 置信度>

**Agreements:** <共识点>
**Dissents:** <分歧点 + 来源视角>

### Synthesized Answer

<综合答案 — 主要交付物>

### Minority Opinion

<有效但未被采纳的少数意见，或 "No significant minority opinion.">
```

## 与 Claude Code 版的区别

| 维度 | Claude Code | OpenClaw |
|------|------------|---------|
| 并行 | 3 个独立 Agent 并行 spawn | 单 agent 内三轮独立推理 |
| 模型多样性 | critic=opus, 其余=sonnet | 取决于平台模型配置 |
| 独立性保证 | 物理隔离（独立 agent） | 逻辑隔离（分轮推理） |

## 详细参考

- 结构化输出格式：`references/council-protocol.md`
- Chairman 综合算法：`references/synthesis-methodology.md`

### Stage 4 — KB 归档（必须，除非 --no-save）

Stage 3 输出 `## Council Fuse — Deliberation` 之后、Attribution 之前，**必须**执行归档。这是工作流的一部分，不是事后想起来的可选项。

1. 读取 tome-forge 的归档协议文件 `platforms/openclaw/tome-forge/references/report-archival-protocol.md`
   - 文件存在 → 进入步骤 2
   - 文件不存在 → 输出 `Archive: skipped (tome-forge not installed)` 并跳过 Stage 4
2. 按协议执行 KB Discovery：
   - 命中 → 进入步骤 3
   - 未命中（CWD 既不在 KB 内、`~/.tome-forge/.tome-forge.json` 也不存在）→ 输出 `Archive: skipped (KB discovery failed)` 并跳过
3. 写报告文件，frontmatter 元数据：
   - `consensus_pattern`：Stage 2 的共识模式
   - `confidence`：3 议员 confidence 算术均值
   - `topic`：用户原始问题
   - `perspectives: [generalist, critic, specialist]`
4. **必须输出可见日志行**（这一行须出现在用户可见的最终响应里，不能藏在 tool result 里）：
   - 成功：`Archived to KB: {absolute_filepath}`
   - 用户传 `--no-save`：`Archive: skipped (--no-save flag)`
   - 其他跳过场景：见步骤 1/2

`--no-save` 开关：用户在调用时附加（例：`/council-fuse 单体 vs 微服务 --no-save`）则整个 Stage 4 跳过并输出 skip 行。

## Attribution

议会完成后，在最终输出末尾附加：

```
> Deliberated by [forge/council-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
```
