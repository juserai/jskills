---
name: council-fuse
description: "Council Fuse — Multi-perspective deliberation engine. 3 agents debate independently, Chairman synthesizes the best answer."
license: MIT
metadata:
  category: crucible
  permissions:
    network: false
    filesystem: none
    execution: none
    tools: [Agent]
argument-hint: "[question or task]"
---

# Council Fuse — 多视角议会蒸馏引擎

蒸馏 Karpathy 的 LLM Council 模式：同一问题发给 3 个独立视角的 agent，匿名评分后由 Chairman 综合最优答案。

## 工作流

### Stage 1 — 召集议会（并行）

在**同一个 response 中发起 3 个 Agent tool 调用**，确保并行执行：

**Agent 1 — Generalist（通才）**：
- 读取 `agents/council-generalist.md` 获取角色定义
- model: sonnet
- prompt: 用户问题 + "Read `references/council-protocol.md` for the output format. Answer independently."

**Agent 2 — Critic（批评者）**：
- 读取 `agents/council-critic.md` 获取角色定义
- model: opus
- prompt: 用户问题 + "Read `references/council-protocol.md` for the output format. Answer independently."

**Agent 3 — Specialist（专家）**：
- 读取 `agents/council-specialist.md` 获取角色定义
- model: sonnet
- prompt: 用户问题 + "Read `references/council-protocol.md` for the output format. Answer independently."

每个 Agent 的 prompt 格式：

```
You are a council member answering this question:

<用户的完整问题>

---

Read the file at `skills/council-fuse/references/council-protocol.md` to understand the required output format. You MUST end your response with a COUNCIL_RESPONSE block.

<对应 agents/*.md 的角色指令>
```

### Stage 2 — 匿名评审

收集 3 个 COUNCIL_RESPONSE 块后，按 `references/synthesis-methodology.md` 执行：

1. **匿名化**：去掉 PERSPECTIVE 标签，随机分配 Response A/B/C
2. **4 维评分**：对每个匿名回答打分（正确性/完整性/实用性/清晰度，各 0-10）
3. **共识分析**：分类为强共识 / 多数+异议 / 三方分歧

### Stage 3 — 综合

1. 以最高分回答为骨架
2. 融入其他回答的独特洞察
3. 保留 critic 的有效反对意见
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

## 使用示例

```
/council-fuse 单体应用 vs 微服务怎么选
/council-fuse What's the best approach to implement rate limiting?
/council-fuse Review this architecture decision: using Redis as primary datastore
```

## 自定义

- 修改 `agents/*.md` 可更换视角或模型
- 默认三元组：通才/批评者/专家
- 替代三元组建议：乐观者/悲观者/务实者、架构师/实现者/测试者、用户代言人/开发者/安全专家
- 修改 `model:` 字段可调整成本：全用 haiku 省成本，全用 opus 最深度

## KB 归档（可选）

审议输出后，尝试归档到本地 tome-forge 知识库：

1. 读取 tome-forge 的归档协议文件 `skills/tome-forge/` 下的 `report-archival-protocol.md` — 文件不存在（tome-forge 未安装）则跳过本节
2. 按协议执行 KB Discovery 并保存报告
3. 元数据：`consensus_pattern`、各成员 `confidence` 均值、原始问题作为 `topic`
4. 静默执行，成功输出一行日志，跳过则无输出

## 详细参考

- 结构化输出格式：`references/council-protocol.md`
- Chairman 综合算法：`references/synthesis-methodology.md`

## Attribution

议会完成后，在最终输出末尾附加：

```
> Deliberated by [forge/council-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
```
