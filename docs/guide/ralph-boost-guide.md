# Ralph Boost 使用手册

> 5 分钟上手，让 AI 自主开发循环不再"停而不转"

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserch/jskills
```

### 通用单行安装

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **零依赖** — 不依赖 ralph-claude-code、block-break 或任何外部服务。主路径（Agent 循环）零外部依赖；Fallback 路径需要 `jq` 或 `python` 和 `claude` CLI。

---

## 命令一览

| 命令 | 功能 | 场景 |
|------|------|------|
| `/ralph-boost setup` | 在项目中初始化自主循环 | 首次使用 |
| `/ralph-boost run` | 在当前会话内启动自主循环 | 初始化后 |
| `/ralph-boost status` | 查看当前循环状态 | 监控进度 |
| `/ralph-boost clean` | 删除循环文件 | 清理 |

---

## 快速开始

### 1. 初始化项目

```text
/ralph-boost setup
```

Claude 会引导你完成：
- 检测项目名称
- 生成任务清单（fix_plan.md）
- 创建 `.ralph-boost/` 目录和所有配置

### 2. 启动循环

```text
/ralph-boost run
```

Claude 会在当前会话内直接驱动自主循环（Agent 循环模式）。每轮 spawn 一个子 Agent 执行任务，主会话作为循环控制器管理状态。

**Fallback**（headless/无人值守环境）：

```bash
# 前台运行
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# 后台运行
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. 监控状态

```text
/ralph-boost status
```

输出示例：

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

## 它做了什么？

### 自主循环

Ralph Boost 提供两条执行路径：

**主路径（Agent 循环）**：Claude 在当前会话中作为循环控制器，每轮 spawn 一个子 Agent 执行任务。主会话管理状态、断路器和压力升级。零外部依赖。

**Fallback（bash 脚本）**：`boost-loop.sh` 在后台运行 `claude -p` 调用循环。支持 jq 和 python 双 JSON 引擎，运行时自动检测。每轮之间默认 sleep 1 小时（可配置）。

两条路径共享同一套状态管理（state.json）、压力升级逻辑和 BOOST_STATUS 协议。

```
读任务 → 执行 → 检测进展 → 调整策略 → 报告 → 下一轮
```

### 增强断路器（vs ralph-claude-code）

ralph-claude-code 的断路器：连续 3 轮无进展就放弃。

ralph-boost 的断路器：连续无进展时**逐级升压**，最多 6-7 轮渐进式自救。

```
有进展 → L0（重置，继续正常工作）

无进展:
  1 轮 → L1 失望（强制切换方案）
  2 轮 → L2 拷问（逐字读错误 + 搜源码 + 列 3 个假设）
  3 轮 → L3 绩效（完成 7 项检查清单）
  4 轮 → L4 毕业（最小 PoC + 写交接报告）
  5+ 轮 → 优雅停机（带结构化交接报告）
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

### L1 — 切换方案

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

上下文注入：
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude 被迫放弃之前的思路，换一个**本质不同**的方案。调参数不算。

### L2 — 搜索与假设

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

上下文注入：
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude 必须：逐字读错误 → 搜 50 行上下文 → 列 3 个不同假设。

### L3 — 检查清单

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude 必须完成 7 项检查清单（逐字读错误、搜核心问题、读源码、验证假设、反转假设、最小复现、换工具方法）。每项完成后写入 state.json。

### L4 — 优雅交接

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude 构建最小 PoC，然后生成交接报告：

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

交接完成后，循环优雅停机。不是"我不行"，是"问题的边界在这里"。

---

## 配置

`.ralph-boost/config.json`：

| 字段 | 默认值 | 说明 |
|------|--------|------|
| `max_calls_per_hour` | 100 | 每小时最大 Claude 调用次数 |
| `claude_timeout_minutes` | 15 | 单次调用超时 |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claude 可用工具 |
| `claude_model` | "" | 模型覆盖（空 = 默认） |
| `session_expiry_hours` | 24 | 会话过期时间 |
| `no_progress_threshold` | 7 | 无进展停机阈值 |
| `same_error_threshold` | 8 | 同一错误停机阈值 |
| `sleep_seconds` | 3600 | 轮间等待秒数 |

### 常用配置调整

**加快循环速度**（测试用）：

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
├── PROMPT.md           # 开发指令（含 block-break 协议）
├── fix_plan.md         # 任务清单（Claude 自动更新）
├── config.json         # 配置
├── state.json          # 统一状态（断路器 + 压力 + 会话）
├── handoff-report.md   # L4 交接报告（优雅退出时生成）
├── logs/
│   ├── boost.log       # 循环日志
│   └── claude_output_*.log  # 每轮输出
└── .gitignore          # 忽略状态和日志
```

所有文件都在 `.ralph-boost/` 内，不触碰项目根目录。

---

## 与 ralph-claude-code 的关系

Ralph Boost 是 ralph-claude-code 的**独立平替**，不是增强插件。

| 维度 | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| 形态 | 独立 Bash 工具 | Claude Code skill (Agent 循环) |
| 安装 | `npm install` | Claude Code plugin |
| 代码量 | 2000+ 行 | ~400 行 |
| 外部依赖 | jq（必须） | 主路径零依赖；Fallback 需 jq 或 python |
| 目录 | `.ralph/` | `.ralph-boost/` |
| 断路器 | 被动（3 轮放弃） | 主动（L0-L4，6-7 轮自救） |
| 共存 | 可以 | 可以（零文件冲突） |

两者可同时安装在同一项目中，各用各的目录，互不影响。

---

## 与 block-break 的关系

Ralph Boost 将 block-break 的核心机制（压力升级、五步方法论、检查清单）适配到自主循环场景：

| 维度 | block-break | ralph-boost |
|------|-------------|-------------|
| 场景 | 交互式会话 | 自主循环 |
| 激活 | Hooks 自动触发 | Agent 循环 / 循环脚本内建 |
| 检测 | PostToolUse hook | Agent 循环进展检测 / 循环脚本进展检测 |
| 控制 | hook 注入提示 | Agent prompt 注入 / --append-system-prompt |
| 状态 | `~/.juserch-skills/` | `.ralph-boost/state.json` |

代码完全独立，概念复用。

> **参考来源**：Block Break 的压力升级（L0-L4）、五步方法论和 7 项检查清单是 ralph-boost 断路器的概念基础。详见 [Block Break 使用手册](block-break-guide.md)。

---

## FAQ

### 主路径和 Fallback 怎么选？

`/ralph-boost run` 默认使用 Agent 循环（主路径），在当前 Claude Code 会话内直接运行。如果需要 headless/无人值守运行，使用 Fallback bash 脚本。

### 循环脚本放在哪里？

安装 jskills plugin 后，Fallback 脚本在 `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh`。也可以把它复制到任意位置运行。脚本自动检测 jq 或 python 作为 JSON 引擎。

### 如何查看循环日志？

```bash
tail -f .ralph-boost/logs/boost.log
```

### 如何手动重置压力等级？

编辑 `.ralph-boost/state.json`，将 `pressure.level` 设为 0，`circuit_breaker.consecutive_no_progress` 设为 0。或直接删除 state.json 重新初始化。

### 如何修改任务清单？

直接编辑 `.ralph-boost/fix_plan.md`，使用 `- [ ] task` 格式。Claude 会在每轮开始时读取。

### 断路器打开后怎么恢复？

编辑 `state.json` 将 `circuit_breaker.state` 设为 `"CLOSED"`，重置相关计数器后重新运行脚本。

### 需要 ralph-claude-code 吗？

不需要。Ralph Boost 完全独立，不依赖 Ralph 的任何文件。

### 支持哪些平台？

当前支持 Claude Code 平台（Agent 循环主路径）。Fallback bash 脚本需要 bash 4+、jq 或 python、claude CLI。

### 如何校验 ralph-boost 的 skill 文件？

使用 [Skill Lint](skill-lint-guide.md) 校验结构完整性和语义质量：`/skill-lint .`。

---

## License

[MIT](LICENSE) - [juserch](https://github.com/juserch)
