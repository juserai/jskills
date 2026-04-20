# Ralph Boost 用户指南

> 5 分钟上手 — 让你的 AI 自主开发循环不再卡死

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserai/forge
```

### 通用一行安装

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **零依赖** — Ralph Boost 不依赖 ralph-claude-code、block-break 或任何外部服务。主路径（Agent 循环）零外部依赖；备用路径需要 `jq` 或 `python` 以及 `claude` CLI。

---

## 命令

| 命令 | 功能 | 使用时机 |
|------|------|---------|
| `/ralph-boost setup` | 在项目中初始化自主循环 | 首次设置 |
| `/ralph-boost run` | 在当前会话中启动自主循环 | 初始化之后 |
| `/ralph-boost status` | 查看当前循环状态 | 监控进度 |
| `/ralph-boost clean` | 移除循环文件 | 清理 |

---

## 快速开始

### 1. 初始化项目

```text
/ralph-boost setup
```

Claude 将引导你完成：
- 检测项目名称
- 生成任务列表（fix_plan.md）
- 创建 `.ralph-boost/` 目录及所有配置文件

### 2. 启动循环

```text
/ralph-boost run
```

Claude 在当前会话中直接驱动自主循环（Agent 循环模式）。每次迭代生成一个子代理执行任务，主会话作为循环控制器管理状态。

**备用方案**（无界面 / 无人值守环境）：

```bash
# 前台
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# 后台
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. 监控状态

```text
/ralph-boost status
```

示例输出：

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## 工作原理

### 自主循环

Ralph Boost 提供两种执行路径：

**主路径（Agent 循环）**：Claude 在当前会话中充当循环控制器，每次迭代生成一个子代理来执行任务。主会话管理状态、circuit breaker 和压力升级。零外部依赖。

**备用方案（bash 脚本）**：`boost-loop.sh` 在后台以循环方式运行 `claude -p` 调用。同时支持 jq 和 python 作为 JSON 引擎，运行时自动检测。迭代之间的默认等待时间为 1 小时（可配置）。

两种路径共享相同的状态管理（state.json）、压力升级逻辑和 BOOST_STATUS 协议。

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### 增强型 Circuit Breaker（对比 ralph-claude-code）

ralph-claude-code 的 circuit breaker：连续 3 个循环没有进展后放弃。

ralph-boost 的 circuit breaker：卡住时**逐步升级压力**，在停止之前可自我恢复 6-7 个循环。

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## 预期输出示例

### L0 — 正常执行

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — 切换方法

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude 被强制放弃之前的方法，尝试**根本性不同**的方案。微调参数不算数。

### L2 — 搜索并提出假设

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude 必须：逐字阅读错误 → 搜索 50+ 行上下文 → 列出 3 个不同的假设。

### L3 — 检查清单

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude 必须完成 7 项检查清单（读取错误信号、搜索核心问题、阅读源代码、验证假设、反向假设、最小复现、切换工具/方法）。每完成一项都会写入 state.json。

### L4 — 有序交接

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude 构建一个最小 PoC，然后生成交接报告：

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

交接完成后，循环有序关闭。这不是"我做不到"——而是"边界在这里"。

---

## 配置

`.ralph-boost/config.json`：

| 字段 | 默认值 | 说明 |
|------|--------|------|
| `max_calls_per_hour` | 100 | 每小时最大 Claude API 调用次数 |
| `claude_timeout_minutes` | 15 | 单次调用超时时间 |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claude 可用的工具 |
| `claude_model` | "" | 模型覆盖（空 = 默认） |
| `session_expiry_hours` | 24 | 会话过期时间 |
| `no_progress_threshold` | 7 | 关闭前的无进展阈值 |
| `same_error_threshold` | 8 | 关闭前的相同错误阈值 |
| `sleep_seconds` | 3600 | 迭代之间的等待时间（秒） |

### 常见配置调整

**加速循环**（用于测试）：

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**限制工具权限**：

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**使用特定模型**：

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## 项目目录结构

```
.ralph-boost/
├── PROMPT.md           # 开发指令（包含 block-break 协议）
├── fix_plan.md         # 任务列表（由 Claude 自动更新）
├── config.json         # 配置
├── state.json          # 统一状态（circuit breaker + 压力 + 会话）
├── handoff-report.md   # L4 交接报告（有序退出时生成）
├── logs/
│   ├── boost.log       # 循环日志
│   └── claude_output_*.log  # 每次迭代输出
└── .gitignore          # 忽略状态和日志
```

所有文件保留在 `.ralph-boost/` 内——你的项目根目录不会被修改。

---

## 与 ralph-claude-code 的关系

Ralph Boost 是 [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) 的**独立替代品**，不是增强插件。

| 方面 | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| 形式 | 独立 Bash 工具 | Claude Code skill（Agent 循环） |
| 安装 | `npm install` | Claude Code 插件 |
| 代码量 | 2000+ 行 | 约 400 行 |
| 外部依赖 | jq（必需） | 主路径：零；备用：jq 或 python |
| 目录 | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | 被动（3 个循环后放弃） | 主动（L0-L4，6-7 个循环自我恢复） |
| 共存 | 是 | 是（零文件冲突） |

两者可以同时安装在同一项目中——它们使用独立的目录，互不干扰。

---

## 与 Block Break 的关系

Ralph Boost 将 Block Break 的核心机制（压力升级、5 步方法论、检查清单）适配到自主循环场景：

| 方面 | block-break | ralph-boost |
|------|-------------|-------------|
| 场景 | 交互式会话 | 自主循环 |
| 激活 | Hook 自动触发 | 内置于 Agent 循环 / 循环脚本 |
| 检测 | PostToolUse hook | Agent 循环进度检测 / 脚本进度检测 |
| 控制 | Hook 注入的提示 | Agent 提示注入 / --append-system-prompt |
| 状态 | `~/.forge/` | `.ralph-boost/state.json` |

代码完全独立；概念共享。

> **参考**：Block Break 的压力升级（L0-L4）、5 步方法论和 7 项检查清单构成了 ralph-boost circuit breaker 的概念基础。详见 [Block Break 用户指南](block-break-guide.md)。

---

## 常见问题

### 如何选择主路径和备用方案？

`/ralph-boost run` 默认使用 Agent 循环（主路径），直接在当前 Claude Code 会话中运行。当需要无界面或无人值守执行时，使用备用 bash 脚本。

### 循环脚本在哪里？

安装 forge 插件后，备用脚本位于 `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`。你也可以将其复制到任何位置运行。脚本自动检测 jq 或 python 作为 JSON 引擎。

### 如何查看循环日志？

```bash
tail -f .ralph-boost/logs/boost.log
```

### 如何手动重置压力级别？

编辑 `.ralph-boost/state.json`：将 `pressure.level` 设为 0，`circuit_breaker.consecutive_no_progress` 设为 0。或者直接删除 state.json 并重新初始化。

### 如何修改任务列表？

直接编辑 `.ralph-boost/fix_plan.md`，使用 `- [ ] 任务` 格式。Claude 在每次迭代开始时读取它。

### circuit breaker 打开后如何恢复？

编辑 `state.json`，将 `circuit_breaker.state` 设为 `"CLOSED"`，重置相关计数器，然后重新运行脚本。

### 我需要 ralph-claude-code 吗？

不需要。Ralph Boost 完全独立，不依赖任何 Ralph 文件。

### 支持哪些平台？

目前支持 Claude Code（Agent 循环作为主路径）。备用 bash 脚本需要 bash 4+、jq 或 python 以及 claude CLI。

### 如何验证 ralph-boost 的 skill 文件？

使用 [Skill Lint](skill-lint-guide.md)：`/skill-lint .`

---

## 使用场景 / 不应使用场景

### ✅ 适用

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ 不适用

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> 带收敛保证的自主循环引擎——需要清晰目标和稳态环境才能真正收敛。

完整边界分析: [references/scope-boundaries.md](../../../skills/ralph-boost/references/scope-boundaries.md)

---

## 许可证

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
