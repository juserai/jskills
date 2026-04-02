---
name: ralph-boost
description: "Ralph Boost — 自主开发循环引擎。复刻 ralph-claude-code 核心能力，内建 Block Break 收敛保证。setup → run → status → clean。"
license: MIT
argument-hint: "[setup|run|status|clean]"
---

# Ralph Boost — 自主开发循环引擎

以 skill 形式复刻 ralph-claude-code 的自主循环能力，集成 block-break 的 L0-L4 压力升级和五步方法论，解决自主循环"停而不转"的无保证收敛问题。

与 ralph-claude-code 完全独立：不依赖、不修改、不共享任何文件。使用独立目录 `.ralph-boost/`。

## 平台适配说明

此版本适配无 Agent 工具的平台（如 OpenClaw）。循环通过 bash 脚本 `boost-loop.sh` 驱动，脚本自动检测 jq 或 python 作为 JSON 引擎。

依赖：`bash 4+`、`jq` 或 `python`、`claude` CLI。

## 子命令

根据参数执行对应操作。无参数时显示帮助。

### `/ralph-boost setup`

在当前项目中初始化 ralph-boost 自主循环。

**执行步骤**：

1. **检查前提**：确认 `jq` 或 `python` 已安装，`claude` CLI 已安装
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
   Setup complete. To start the autonomous loop, run:
     bash <skill-path>/scripts/boost-loop.sh --project-dir <project-path>

   To run in background:
     nohup bash <skill-path>/scripts/boost-loop.sh --project-dir <project-path> > /dev/null 2>&1 &
   ```

**幂等性**：如果 `.ralph-boost/` 已存在，提示用户选择覆盖或跳过。

### `/ralph-boost run`

提示用户在终端中执行循环脚本。

此平台无 Agent 工具，循环通过 bash 脚本驱动。输出启动命令供用户执行：

```
To start the autonomous loop:
  bash <skill-path>/scripts/boost-loop.sh --project-dir $(pwd)

To run in background:
  nohup bash <skill-path>/scripts/boost-loop.sh --project-dir $(pwd) > /dev/null 2>&1 &
```

脚本自动检测 JSON 引擎（优先 jq，fallback python）。

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
| 形态 | 独立 Bash 工具 | AI skill (bash 脚本驱动) |
| 代码量 | 2000+ 行 | ~400 行 |
| 断路器 | 被动（3 轮放弃） | 主动（L0-L4，6-7 轮自救） |
| 状态 | 5+ 个文件 | 统一 state.json |
| 目录 | `.ralph/` | `.ralph-boost/` |
| JSON 引擎 | jq（必须） | jq 或 python（自动检测） |

### vs block-break

| 维度 | block-break | ralph-boost |
|------|-------------|-------------|
| 场景 | 交互式会话 | 自主循环 |
| 检测 | 自我监控失败计数 | 循环脚本进展检测 |
| 控制 | skill 指令约束 | --append-system-prompt 上下文注入 |
| 状态 | 自管理计数 | `.ralph-boost/state.json` |

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
