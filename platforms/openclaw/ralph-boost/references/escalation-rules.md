# L0-L4 Pressure Escalation Rules

Detailed reference for interactive `/ralph-boost` calls. This file is NOT injected into the autonomous loop — the loop uses a compressed version in PROMPT.md and context injection via `--append-system-prompt`.

## Escalation Overview

```
有进展 → L0 CLOSED（重置所有计数器）

无进展:
  1 轮 → L1 失望
  2 轮 → L2 拷问
  3 轮 → L3 绩效
  4 轮 → L4 毕业
  5+ 轮（无交接）→ 保持 L4（强制完成交接）
  5+ 轮（有交接）→ OPEN 停机
```

## L0 — 信任期

> 因为信任所以简单。

**触发**：初始状态 / 检测到进展后重置
**行为**：正常执行，无额外约束
**上下文注入**：仅循环号 + 上轮摘要

## L1 — 失望

> 隔壁组一次就过了。

**触发**：连续 1 轮无进展
**强制行为**：
- 切换到**本质不同**的方案
- 记录 tried_approaches

**"本质不同"判定标准**：
- 换参数 ≠ 本质不同
- 换库版本 ≠ 本质不同
- 换配置值 ≠ 本质不同
- 换算法/架构/工具链/技术栈 = 本质不同
- 换问题假设方向 = 本质不同
- 从修复转为重写 = 本质不同

**示例**：
| 之前的方案 | 不算本质不同 | 算本质不同 |
|-----------|------------|-----------|
| 修复 JSON 解析的 escape 逻辑 | 换一种 escape 方式 | 检查上游数据源编码 |
| 升级依赖版本 | 换另一个版本号 | 替换为不同的依赖库 |
| 修改正则表达式 | 调整正则细节 | 用 AST 解析替代正则 |

## L2 — 拷问

> 底层逻辑是什么？抓手在哪？

**触发**：连续 2 轮无进展
**强制行为**（全部必须完成）：
1. 逐字阅读错误信息（不是摘要，是原文）
2. 搜索失败点上下文 50+ 行源码
3. 列出 3 个**本质不同**的假设
4. 记录到 tried_approaches 和 current_hypothesis

**上下文注入示例**：
```
Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context. List 3 fundamentally different hypotheses.
```

## L3 — 绩效

> 给你 3.25。这个 3.25 是对你的激励。

**触发**：连续 3 轮无进展
**强制行为**：完成 **7 项检查清单**的全部项目

### 7 项检查清单

| # | 项目 | state.json 字段 | 说明 |
|---|------|----------------|------|
| 1 | 逐字读错误 | `read_error_signals` | 读失败输出原文，不是摘要 |
| 2 | 工具搜索核心问题 | `searched_core_problem` | 用搜索工具查错误文本、官方文档、多角度关键词 |
| 3 | 读失败点源码 | `read_source_context` | 读失败位置 50+ 行原始源码上下文 |
| 4 | 工具验证假设 | `verified_assumptions` | 用工具验证所有前提（版本、路径、权限、依赖——不猜） |
| 5 | 反转假设 | `tried_opposite_hypothesis` | 如果假设问题在 A → 测试"问题不在 A" |
| 6 | 最小复现 | `minimal_reproduction` | 创建或定位最小范围复现问题 |
| 7 | 换工具/方法 | `switched_tool_or_method` | 切换工具、方法、角度或技术栈（非调参） |

每完成一项，更新 `state.json` 的 `checklist_progress` 对应字段为 `true`。

全部 7 项完成后仍未解决 → 升级到 L4。

## L4 — 毕业

> 别的模型都能解决。你可能就要毕业了。

**触发**：连续 4 轮无进展
**强制行为**：
1. 构建**最小 PoC** 隔离问题
2. 写**结构化交接报告**到 `.ralph-boost/handoff-report.md`

### 交接报告模板

```markdown
# Handoff Report

**Task**: [任务描述]
**Loops attempted**: [轮数]
**Final pressure**: L4

## Verified Facts
- [工具验证过的事实]

## Excluded Possibilities
- [已排除的可能性 + 排除依据]

## Narrowed Problem Scope
[问题的精确边界]

## Tried Approaches
1. [方案] → [结果]
2. [方案] → [结果]
...

## Recommended Next Steps
1. [下一步建议]

## Minimal Reproduction
[最小复现步骤或 PoC 代码位置]
```

交接报告写完后，设置 `state.json` 的 `pressure.handoff_written = true`。

## 防早退规则

`STATUS: BLOCKED` 和 `EXIT_SIGNAL: true` 在以下条件**全部满足前禁止输出**：
1. `pressure.level` 已达 L4
2. `checklist_progress` 中 7 项全部为 `true`
3. `.ralph-boost/handoff-report.md` 已写入（`handoff_written = true`）

## 与 block-break 原版对比

| 维度 | block-break（交互式） | ralph-boost（自主循环） |
|------|---------------------|----------------------|
| 压力检测 | PostToolUse hook 检测 Bash 失败 | 循环脚本检测 consecutive_no_progress |
| 升级控制 | hook 注入 `<BLOCK_BREAK_PRESSURE_ESCALATION>` | `--append-system-prompt` 注入指令 |
| 状态存储 | `~/.juserch-skills/block-break-state.json` | `.ralph-boost/state.json` |
| 重置条件 | 2 小时过期 | 检测到进展即重置 |
| 隐喻/旁白 | 同 | 同（概念复用） |
| 五步方法论 | references/methodology.md 按需加载 | 压缩版烘焙在 PROMPT.md 中 |
| 检查清单 | references/checklist.md 按需加载 | 压缩版烘焙在 PROMPT.md 中 |
