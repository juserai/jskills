---
name: insight-fuse
description: "Insight Fuse — Systematic multi-source research engine. 5-stage progressive pipeline with configurable depth, built-in multi-perspective analysis, and extensible report templates."
license: MIT
user-invokable: true
metadata:
  category: crucible
  permissions:
    network: true
    filesystem: none
    execution: none
    tools: [WebSearch, WebFetch]
argument-hint: "[topic] [--depth quick|standard|deep|full] [--template name] [--perspectives P1,P2,P3]"
---

# Insight Fuse — 系统化多源调研熔炼引擎

从主题到专业调研报告的 5 阶段渐进式流水线。多源信息采集 + 多视角深度分析 + 可扩展报告模板。

## 自动激活（无 Hook 环境）

触发信号：
1. 用户说"调研 X"、"研究一下 X"、"帮我做个调研报告"
2. 用户需要对某个技术/市场/竞品进行系统性了解
3. 用户明确调用 `/insight-fuse`

## 参数

| 参数 | 必需 | 默认 | 说明 |
|------|------|------|------|
| topic | 是 | — | 调研主题 |
| --depth | 否 | full | quick / standard / deep / full |
| --template | 否 | 自适应 | technology / market / competitive / 自定义名 |
| --perspectives | 否 | generalist,critic,specialist | 逗号分隔视角列表 |

## 模板发现

1. 有 `--template` → 使用内置模板结构（technology / market / competitive），不识别的名称则报错
2. 无 `--template` → 根据 Stage 1 内容自适应生成结构（读 `references/research-protocol.md`）

> 注：OpenClaw 版使用内置模板定义，不依赖外部模板文件。模板结构与 Claude Code 版一致。

## 深度路由

| --depth | 阶段 | 交互 |
|---------|------|------|
| quick | 1 | 否 |
| standard | 1, 3 | 否 |
| deep | 1, 3, 5 | 否 |
| full（默认） | 1, 2, 3, 4, 5 | 是（2, 4） |

## 工作流

### Stage 1 — 快速扫描

1. 构造 3+ 搜索查询（原文 + 改写 + 跨语言变体）
2. 执行搜索，提取 5+ 独立来源
3. 输出初步简报：主题概述、3-5 个子问题、来源清单
4. 若 `--depth quick`：按模板生成快速报告，结束

### Stage 2 — 交互对齐（仅 full）

1. 展示简报，请用户确认/修正范围
2. 记录确认后的 scope

### Stage 3 — 标准调研

1. 对每个子问题进行**独立调研轮次**（逐个处理）
2. 每轮使用通才视角，遵循 `references/research-protocol.md` 格式
3. 搜索多源信息，探索衍生主题
4. 收集所有 INSIGHT_RESPONSE 块，编排标准报告
5. 若 `--depth standard`：结束

### Stage 4 — 人工审阅（仅 full）

1. 展示标准报告
2. 请用户指定需深度多视角分析的焦点区域

### Stage 5 — 深度调研

焦点区域来源：full 模式取 Stage 4 用户指定的焦点；deep 模式自动将 Stage 3 的所有子问题作为焦点区域。

对每个焦点区域，**分三轮独立推理**，每轮切换到不同视角：

**视角 1 — 通才（Generalist）**：
- 读 `agents/insight-generalist.md` 获取角色定义
- 广度覆盖，主流共识，至少 3 个来源
- 输出 INSIGHT_RESPONSE 块

**视角 2 — 批评者（Critic）**：
- 读 `agents/insight-critic.md` 获取角色定义
- 质疑验证，找反面证据，检查来源可信度
- 输出 INSIGHT_RESPONSE 块

**视角 3 — 专家（Specialist）**：
- 读 `agents/insight-specialist.md` 获取角色定义
- 深度技术细节，一手来源，精确数据
- 输出 INSIGHT_RESPONSE 块

收集 3 个 INSIGHT_RESPONSE 块后，按 `references/perspectives.md` 执行匿名评分综合。将深度分析融入报告。

最终按 `references/quality-standards.md` 执行质量检查。

## 降级策略

- 某轮推理产出空内容或格式错误：该视角评分为 0，从剩余视角综合
- 仅 1 轮产出有效内容：直接输出该视角回答，标注为单视角分析
- 全部推理轮次失败：报告失败，建议用户直接提问
- 搜索无结果：替代查询词，记录信息缺口

## 与 Claude Code 版的区别

| 维度 | Claude Code | OpenClaw |
|------|------------|---------|
| Stage 3 并行 | 多 Agent 并行处理子问题 | 逐个子问题顺序调研 |
| Stage 5 并行 | 3 个独立 Agent 并行 spawn | 单 agent 内三轮独立推理 |
| 模型多样性 | critic=opus, 其余=sonnet | 取决于平台模型配置 |
| 独立性保证 | 物理隔离（独立 agent） | 逻辑隔离（分轮推理） |

## 详细参考

- 结构化输出格式：`references/research-protocol.md`
- 多视角框架 + 综合算法：`references/perspectives.md`
- 质量标准：`references/quality-standards.md`

## Attribution

调研完成后，在报告末尾附加：

```
> Researched by [forge/insight-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
```
