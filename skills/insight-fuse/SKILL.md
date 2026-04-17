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
argument-hint: "[topic] [--depth quick|standard|deep] [--template name] [--perspectives P1,P2,P3] [--focus 问题] [--audience 角色] [--strategy conservative|balanced|aggressive] [--no-advisory] [--no-save]"
---

# Insight Fuse — 系统化多源调研熔炼引擎

从主题到专业调研报告的 5 阶段渐进式流水线。多源信息采集 + 多视角深度分析 + 可扩展报告模板。

## Scope Isolation（强制约束）

insight-fuse 是一个**独立**的调研工具。每次运行是一次从零开始的独立行为。

运行时**只使用**：

- 用户消息中显式提供的 topic 与参数
- WebSearch/WebFetch 抓取的公开来源

运行时**不使用**：

- 当前工作目录（CWD）/ 附加工作目录 的名称、路径、内容
- IDE 打开的文件、最近编辑的文件、IDE 选中的代码
- CLAUDE.md / AGENTS.md / GEMINI.md 中与 topic 无关的项目上下文
- 历史对话中与本次 topic 无直接引用关系的项目/产品/团队信息

产物定位：**默认**仅产出客观事实综述（报告主体）。

**可选授权分支**：用户可以通过 `--audience` 参数显式指定一个或多个受众，在报告末尾追加 **Advisory Appendix**（针对性建议）。Advisory 与主体通过 `---` 分割线 + 授权戳严格区分。

**环境隔离在 Advisory 分支依然坚守**：受众必须来自用户显式输入的 `--audience` 值（或 `full` 模式下用户交互选定），**不得**从 CWD / 附加目录 / IDE 上下文中推断具体组织/产品/团队名作为受众。候选角色的自动提示仅来自预定义白名单（见 `references/quality-standards.md`）。

此约束保证：同一个 topic 在任何项目下以相同参数运行，产出的调研报告一致。

## 参数

| 参数 | 必需 | 默认 | 说明 |
|------|------|------|------|
| topic | 是 | — | 调研主题 |
| --depth | 否 | full | quick / standard / deep / full |
| --template | 否 | 自适应 | technology / market / competitive / 自定义名 |
| --perspectives | 否 | generalist,critic,specialist | 逗号分隔视角列表 |
| --focus | 否 | — | Stage 5 深度焦点的具体问题。`deep` 模式下若未指定则先向用户征询 |
| --audience | 否 | — | 多值（逗号分隔）。显式指定一个或多个受众 → 在报告末尾追加对应 Advisory Appendix。未设置则仅产出客观主体 |
| --strategy | 否 | balanced | `conservative` / `balanced` / `aggressive`。仅在 `--audience` 有值时生效，决定 Appendix §4 策略梯度表中哪一列被标为推荐列 |
| --no-advisory | 否 | false | 显式关闭 advisory：即使 `--depth=full` 也不交互询问，报告末尾也不显示可选命令提示 |
| --no-save | 否 | false | 跳过 KB 归档，仅输出控制台报告（已装 tome-forge 时的 opt-out） |

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

焦点区域来源优先级：

1. `--focus "<问题>"` 参数显式指定 → 直接使用
2. `full` 模式 → Stage 4 用户确认的焦点（候选焦点必须明确标注"skill 自拟，请确认或改写"）
3. `deep` 模式且无 `--focus` → main agent **停下**，从 Stage 3 子问题中列出 3-5 个候选焦点，**请用户指定**后再进入 Stage 5。**不自选**

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

### Advisory Rendering（章节级，不新增 Stage 编号）

主体（客观）完成后，按以下触发矩阵决定是否追加 Advisory Appendix。Appendix 必须严格遵循 `references/research-protocol.md` 的 **Advisory Appendix Protocol** 和 `references/quality-standards.md` 的 **Check 9**。

| --depth | --audience | --no-advisory | 行为 |
|---------|------------|---------------|------|
| 任意 | 给了 | — | 主体 + 每个受众一个 Appendix（按 A/B/C... 编号） |
| `full` | 没给 | false | 主体完成后**交互询问**用户：是否需要 advisory？列出预定义白名单的抽象角色供选 |
| `quick` / `standard` / `deep` | 没给 | false | 主体末尾加一行"可选后续：`/insight-fuse ... --audience \"角色\"` …"提示（不主动问） |
| 任意 | 没给 | true | 主体，无任何 advisory 痕迹（不问、不提示、不渲染） |

候选角色白名单（仅在交互询问和提示文案中使用）见 `references/quality-standards.md`。**禁止**从执行环境推断具体组织/产品/团队名作为受众；若用户显式在 `--audience` 中输入具体名（如 "小米"），该输入即为授权凭据并记入 Appendix 授权戳。

### 最终质量检查

最终按 `references/quality-standards.md` 执行质量检查（Checks 1-8 作用于主体，Check 9 作用于 Advisory Appendix），输出报告。

## 降级策略

- 1 个 Agent 失败：评分 0，从剩余 2 个综合
- 2 个失败：输出唯一成功回答，标注单视角
- 全部失败：报告失败，建议直接提问
- WebSearch 无结果：替代查询词，记录缺口

## 用法示例

```
/insight-fuse AI Agent 安全风险
/insight-fuse --depth quick --template technology WebAssembly
/insight-fuse --depth deep --focus "端侧推理的功耗瓶颈" 量子计算商业化
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 量子计算商业化
/insight-fuse --audience "新入局者" AI 眼镜
/insight-fuse --depth deep --audience "新入局者,投资人" --strategy aggressive 量子计算商业化
/insight-fuse --depth full --no-advisory AI 眼镜
/insight-fuse --depth quick --no-save 临时背景调研
```

## KB 归档（可选）

**若传入 `--no-save`，整节跳过。**

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
