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
    tools: [WebSearch, WebFetch, Agent]
argument-hint: "[topic] [--depth quick|standard|deep] [--template name] [--perspectives P1,P2,P3]"
---

# Insight Fuse — 系统化多源调研熔炼引擎

从主题到专业调研报告的 5 阶段渐进式流水线。多源信息采集 + 多视角深度分析 + 可扩展报告模板。

## 参数

| 参数 | 必需 | 默认 | 说明 |
|------|------|------|------|
| topic | 是 | — | 调研主题 |
| --depth | 否 | full | quick / standard / deep / full |
| --template | 否 | 自适应 | technology / market / competitive / 自定义名 |
| --perspectives | 否 | generalist,critic,specialist | 逗号分隔视角列表 |

## 模板发现

1. 有 `--template` → 读 `templates/{name}.md`，不存在则报错并列出可用模板
2. 无 `--template` → 根据 Stage 1 内容自适应生成结构（读 `references/research-protocol.md`）
3. 列出可用 → glob `templates/*.md`，排除 `custom-example.md`

## 工作流

### 深度路由

| --depth | 阶段 | 交互 |
|---------|------|------|
| quick | 1 | 否 |
| standard | 1, 3 | 否 |
| deep | 1, 3, 5 | 否 |
| full（默认） | 1, 2, 3, 4, 5 | 是（2, 4） |

### Stage 1 — 快速扫描

1. 构造 3+ 搜索查询（原文 + 改写 + 跨语言变体）
2. 并行 WebSearch 所有查询
3. 提取 5+ 独立来源
4. 输出初步简报：主题概述、3-5 个子问题、来源清单
5. 若 `--depth quick`：按模板生成快速报告，结束

### Stage 2 — 交互对齐（仅 full）

1. 展示简报，请用户确认/修正：主题范围、子问题、排除领域
2. 记录确认后的 scope

### Stage 3 — 标准调研

1. 为每个子问题派 1 个 Generalist agent（并行）。子问题来源：full 取 Stage 2 确认列表，其他取 Stage 1 自动识别
2. 每个 agent 读 `agents/insight-generalist.md` + 遵循 `references/research-protocol.md`
3. WebSearch + WebFetch 多源覆盖，探索 1-2 个衍生主题
4. 收集 INSIGHT_RESPONSE 块，按模板编排标准报告
5. 若 `--depth standard`：结束

### Stage 4 — 人工审阅（仅 full）

1. 展示标准报告
2. 请用户指定需深度多视角分析的焦点区域

### Stage 5 — 深度调研

焦点区域来源：full 模式取 Stage 4 用户指定的焦点；deep 模式自动将 Stage 3 的所有子问题作为焦点区域。

对每个焦点区域，在**同一 response 中**发起 3 个 Agent 调用：

- Agent 1 — Generalist：读 `agents/insight-generalist.md`，model: sonnet
- Agent 2 — Critic：读 `agents/insight-critic.md`，model: opus
- Agent 3 — Specialist：读 `agents/insight-specialist.md`，model: sonnet

每个 Agent 的 prompt 格式：

```
You are a research team member investigating this topic:

<焦点区域的具体问题>

---

Read the file at `references/research-protocol.md` for the required output format. You MUST end your response with an INSIGHT_RESPONSE block.

<对应 agents/*.md 的角色指令>
```

收集 3 个 INSIGHT_RESPONSE 块后，按 `references/perspectives.md` 执行匿名评分综合。焦点间串行，视角内并行。

最终按 `references/quality-standards.md` 执行质量检查，输出报告。

## 降级策略

- 1 个 Agent 失败：评分 0，从剩余 2 个综合
- 2 个失败：输出唯一成功回答，标注单视角
- 全部失败：报告失败，建议直接提问
- WebSearch 无结果：替代查询词，记录缺口

## 用法示例

```
/insight-fuse AI Agent 安全风险
/insight-fuse --depth quick --template technology WebAssembly
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 量子计算商业化
```

## KB 归档（可选）

报告输出后，尝试归档到本地 tome-forge 知识库：

1. 读取 tome-forge 的归档协议文件 `skills/tome-forge/` 下的 `report-archival-protocol.md` — 文件不存在（tome-forge 未安装）则跳过本节
2. 按协议执行 KB Discovery 并保存报告
3. 元数据：`depth`、`template`（或 "auto"）、`perspectives` 列表、引用来源中前 5 个 URL
4. 静默执行，成功输出一行日志，跳过则无输出

## 定制

- 视角：修改 `agents/*.md` 或创建 `agents/insight-{name}.md`。详见 `references/perspectives.md`
- 模板：添加 `.md` 文件到 `templates/`。参考 `templates/custom-example.md`
- 质量：调整 `references/quality-standards.md`

> Researched by [forge/insight-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
