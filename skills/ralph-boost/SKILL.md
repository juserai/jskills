---
name: ralph-boost
description: "Ralph Boost — Autonomous dev loop engine with convergence guarantee. Built-in Block Break integration. setup → run → status → clean."
license: MIT
metadata:
  category: hammer
  permissions:
    network: false
    filesystem: read-write
    execution: sandboxed
    tools: [Read, Write, Bash, Agent]
argument-hint: "[setup|run|status|clean]"
---

# Ralph Boost — 自主开发循环引擎

以 skill 形式复刻 ralph-claude-code 的自主循环能力，集成 block-break 的 L0-L4 压力升级和五步方法论，解决自主循环"停而不转"的无保证收敛问题。

与 ralph-claude-code 完全独立：不依赖、不修改、不共享任何文件。使用独立目录 `.ralph-boost/`。

## Help

当第一参数为 `help` / `--help`，**或无参数**时，输出以下 help card 并停止执行（parsing 规则详见 [CLAUDE.md § Help 模式约定](../../CLAUDE.md)）：

```
Ralph Boost — Autonomous dev loop engine with convergence guarantee

Usage:
  /ralph-boost setup             Initialize ralph-boost in current project
  /ralph-boost run               Start the autonomous loop
  /ralph-boost status            Show current loop state + pressure level
  /ralph-boost clean             Clean .ralph-boost/ artifacts
  /ralph-boost help              Show this help

Examples:
  /ralph-boost setup
  /ralph-boost run
  /ralph-boost status

Guide: docs/user-guide/ralph-boost-guide.md
```

## 子命令

### `/ralph-boost setup`

在当前项目中初始化 ralph-boost 自主循环。

**执行步骤**：

1. **检查前提**：确认 `claude` CLI 已安装（仅 fallback bash 路径需要）
2. **创建目录**：`.ralph-boost/`、`.ralph-boost/logs/`
3. **生成 PROMPT.md**：
   - 读取 `references/prompt-template.md`
   - 询问用户项目名称（或从 package.json / Cargo.toml 等自动检测）
   - 替换 `{{PROJECT_NAME}}` 占位符
   - 写入 `.ralph-boost/PROMPT.md`
4. **生成 fix_plan.md**：
   - 询问用户初始任务列表（或检测 TODO/FIXME/GitHub Issues）
   - 格式化为 `- [ ] task` 清单
   - 写入 `.ralph-boost/fix_plan.md`
5. **生成 config.json**：
   ```json
   {
     "max_calls_per_hour": 100,
     "claude_timeout_minutes": 15,
     "allowed_tools": ["Write", "Read", "Edit", "Bash", "Glob", "Grep"],
     "claude_model": "",
     "session_expiry_hours": 24,
     "no_progress_threshold": 7,
     "same_error_threshold": 8,
     "sleep_seconds": 3600
   }
   ```
6. **初始化 state.json**：
   ```json
   {
     "version": 1,
     "circuit_breaker": {
       "state": "CLOSED",
       "consecutive_no_progress": 0,
       "consecutive_same_error": 0,
       "last_progress_loop": 0,
       "total_opens": 0,
       "reason": ""
     },
     "pressure": {
       "level": 0,
       "tried_approaches": [],
       "excluded_causes": [],
       "current_hypothesis": "",
       "checklist_progress": {
         "read_error_signals": false,
         "searched_core_problem": false,
         "read_source_context": false,
         "verified_assumptions": false,
         "tried_opposite_hypothesis": false,
         "minimal_reproduction": false,
         "switched_tool_or_method": false
       },
       "handoff_written": false
     },
     "session": {
       "id": "",
       "created_at": "",
       "loop_count": 0
     },
     "rate_limit": {
       "call_count": 0,
       "last_reset_hour": ""
     },
     "last_updated": ""
   }
   ```
7. **创建 .gitignore**：
   ```
   state.json
   logs/
   handoff-report.md
   ```
8. **输出启动命令**：
   ```
   Setup complete. To start the autonomous loop:
     /ralph-boost run

   [Fallback] For headless/unattended environments:
     bash <skill-path>/scripts/boost-loop.sh --project-dir <project-path>
   ```

**幂等性**：如果 `.ralph-boost/` 已存在，提示用户选择覆盖或跳过。

### `/ralph-boost run`

在当前会话内启动自主开发循环。

**Fallback 提示**（循环启动前输出）：
```
[Fallback] To run as standalone bash loop (for headless/unattended environments):
  bash <skill-base-dir>/scripts/boost-loop.sh --project-dir $(pwd)
```

**执行步骤（循环控制器）**：

你（Claude）作为循环控制器，按以下逻辑反复执行直到停止：

#### 初始化

1. 确认 `.ralph-boost/` 已初始化（state.json、PROMPT.md、fix_plan.md 存在），否则提示运行 `setup`
2. Read `.ralph-boost/config.json` 获取配置参数
3. 输出 `Ralph Boost loop starting...`

#### 每轮循环

重复执行以下步骤：

**Step 1 — 读取状态**

Read `.ralph-boost/state.json`，提取：
- `circuit_breaker.state`、`circuit_breaker.consecutive_no_progress`、`circuit_breaker.consecutive_same_error`
- `pressure.level`
- `session.loop_count`
- `rate_limit.call_count`、`rate_limit.last_reset_hour`

**Step 2 — 断路器检查**

如果 `circuit_breaker.state == "OPEN"`：
- 输出 halt 状态（见 status 子命令格式）
- 停止循环

**Step 3 — Rate Limit 检查**

获取当前小时 `date -u +"%Y-%m-%dT%H"`：
- 如果 `last_reset_hour` != 当前小时 → 重置 `call_count = 0`
- 如果 `call_count >= max_calls_per_hour` → 输出 "Rate limit reached. Pausing." 并停止循环，等待用户输入继续

**Step 4 — 构建压力上下文**

根据 `pressure.level` 构建上下文字符串：

| Level | 上下文注入 |
|-------|----------|
| L0 | `Loop #N.` |
| L1 | + `Pressure: L1 Disappointment. The team next door got it on the first try. MANDATORY: Switch to fundamentally different approach. Parameter tweaks do NOT count. Tried approaches: N.` |
| L2 | + `Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point? MANDATORY: Read error word-by-word. Search 50+ lines context. List 3 fundamentally different hypotheses. Tried approaches: N.` |
| L3 | + `Pressure: L3 Performance Review. Rating: 3.25. This 3.25 is your motivation. MANDATORY: Complete ALL 7 checklist items in state.json checklist_progress. No shortcuts. Tried approaches: N.` |
| L4 | + `Pressure: L4 Graduation. Other models can solve this. You might be graduating soon. MANDATORY: Build minimal PoC. Write handoff report to .ralph-boost/handoff-report.md. Tried approaches: N.` |

如果 `.ralph-boost/logs/last_summary.txt` 存在，追加 `Previous: <内容>`。

**Step 5 — Spawn Agent**

使用 Agent 工具 spawn 前台子 agent：
- 读取 `agents/loop-worker.md` 作为 agent 行为基础
- 读取 `.ralph-boost/PROMPT.md` 获取项目专属指令
- 将 PROMPT.md 内容 + 压力上下文作为 agent prompt：

```
<PROMPT.md 内容>

---

<压力上下文字符串>
```

等待 Agent 完成，获取返回文本。

**Step 6 — 解析 BOOST_STATUS**

从 Agent 返回文本中提取 `---BOOST_STATUS---` 到 `---END_BOOST_STATUS---` 之间的内容。
解析字段：STATUS、TASKS_COMPLETED_THIS_LOOP、FILES_MODIFIED、TESTS_STATUS、EXIT_SIGNAL、PRESSURE_LEVEL、TRIED_COUNT。
提取 CURRENT_APPROACH + RESULT 写入 `.ralph-boost/logs/last_summary.txt`。

如果未找到 BOOST_STATUS 块，视为无进展。

**Step 7 — 检测进展**

有进展的条件（任一为 true）：
- `Bash("git status --porcelain | grep -cv '.ralph-boost/'")` 输出 > 0
- FILES_MODIFIED > 0
- TASKS_COMPLETED_THIS_LOOP > 0
- STATUS == "COMPLETE"

**Step 8 — 更新断路器和压力**

如果有进展：
```json
circuit_breaker.state = "CLOSED"
circuit_breaker.consecutive_no_progress = 0
circuit_breaker.consecutive_same_error = 0
circuit_breaker.last_progress_loop = session.loop_count
circuit_breaker.reason = "Progress detected"
pressure.level = 0
```

如果无进展：
```
consecutive_no_progress += 1
pressure.level = min(consecutive_no_progress, 4)

if consecutive_no_progress >= 2: circuit_breaker.state = "HALF_OPEN"
if consecutive_no_progress >= no_progress_threshold:
  if pressure.handoff_written == true:
    circuit_breaker.state = "OPEN"
    circuit_breaker.reason = "No progress after N loops, handoff complete"
  else:
    pressure.level = 4  # Force L4, keep running
    circuit_breaker.reason = "L4 active, waiting for handoff report"

if consecutive_same_error >= same_error_threshold:
  circuit_breaker.state = "OPEN"
  circuit_breaker.reason = "Same error repeated N times"
```

**Step 9 — 更新 session 和 timestamp**

```json
session.loop_count += 1
rate_limit.call_count += 1
last_updated = "<current UTC timestamp>"
```

**Step 10 — Write state.json**

将更新后的完整 state.json 写回 `.ralph-boost/state.json`。

**Step 11 — 检查退出信号**

如果 BOOST_STATUS 中 `EXIT_SIGNAL == true`：
- 输出最终状态（见 status 格式）
- 停止循环

**Step 12 — 输出轮次摘要，继续下一轮**

输出：`Loop #N complete | <pressure_name> | <STATUS> | Tasks: <N> | Files: <N>`

回到 Step 1。

### `/ralph-boost status`

读取并展示 `.ralph-boost/state.json` 的当前状态。

输出格式：
```
Ralph Boost Status
==================
Circuit Breaker:  CLOSED / HALF_OPEN / OPEN
Pressure Level:   L0 Trust / L1 Disappointment / ...
Loop Count:       N
Tried Approaches: N
Checklist:        N/7 completed
Last Updated:     <timestamp>

Tried Approaches:
  1. [approach] → [result] (loop N)
  2. ...

Checklist Progress:
  [x] read_error_signals
  [ ] searched_core_problem
  ...
```

如果 `.ralph-boost/` 不存在，提示运行 `setup`。

### `/ralph-boost clean`

删除 `.ralph-boost/` 目录。

执行前确认：
```
This will delete .ralph-boost/ and all state. Continue? [y/N]
```

## 核心特性

### vs ralph-claude-code

| 维度 | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| 形态 | 独立 Bash 工具 | Claude Code skill (Agent 循环) |
| 代码量 | 2000+ 行 | ~400 行 |
| 断路器 | 被动（3 轮放弃） | 主动（L0-L4，6-7 轮自救） |
| 状态 | 5+ 个文件 | 统一 state.json |
| 目录 | `.ralph/` | `.ralph-boost/` |

### vs block-break

| 维度 | block-break | ralph-boost |
|------|-------------|-------------|
| 场景 | 交互式会话 | 自主循环 |
| 检测 | PostToolUse hook | Agent 循环进展检测 / 循环脚本进展检测 |
| 控制 | hook 注入提示 | Agent prompt 注入 / --append-system-prompt |
| 状态 | `~/.forge/` | `.ralph-boost/state.json` |

### 压力升级

| 等级 | 名称 | 强制行为 |
|------|------|---------|
| L0 | 信任 | 正常执行 |
| L1 | 失望 | 切换本质不同方案 |
| L2 | 拷问 | 逐字读错误 + 50 行上下文 + 3 个假设 |
| L3 | 绩效 | 完成 7 项检查清单 |
| L4 | 毕业 | 最小 PoC + 交接报告 |

详细规则见 `references/escalation-rules.md`。
BOOST_STATUS 格式见 `references/boost-status-protocol.md`。
循环 Agent 行为定义见 `agents/loop-worker.md`。

## Attribution & Cross-Skill

循环完成或优雅交接时，在最终输出末尾附加：

```
> Powered by [forge/ralph-boost](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
```

交接报告中提示：

> Ralph Boost uses Block Break's L0-L4 pressure escalation internally. For interactive debugging, you can also use `/block-break` directly.
