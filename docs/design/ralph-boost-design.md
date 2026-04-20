# Ralph Boost 设计文档

**日期**: 2026-04-02
**状态**: 已实施

## 定位

Ralph Boost — 自主开发循环引擎。以 skill 形式复刻 ralph-claude-code 的核心能力，集成 block-break 的收敛保证，解决自主循环"停而不转"的问题。

命名遵循 `名称-动词` 模式：
- **ralph**（名称）：自主开发循环范式（源自 ralph-claude-code 开创的模式）
- **boost**（动词）：增强、提升

与 ralph-claude-code 完全独立：不依赖、不修改、不共享任何文件。两者可同时安装互不影响。

> **参考来源**：循环模式参考 [ralph-claude-code](https://github.com/frankbria/ralph-claude-code)；收敛保证机制（L0-L4 压力升级、五步方法论、7 项检查清单）来自同项目的 [Block Break](../guide/block-break-guide.md)，后者参考 [PUA](https://github.com/tanweai/pua)。

## 覆盖与边界

> ralph-boost 是**带收敛保证的自主循环引擎**——它把 block-break 的"别放弃"嵌进 loop，让 agent 能在无人值守下跑几小时而不空转，但它需要**清晰的目标**和**稳态环境**才能真正收敛。

完整分析（能解决 / 不能解决 / 不应使用）：[references/scope-boundaries.md](../../skills/ralph-boost/references/scope-boundaries.md)

## 目标

### 复刻：从 ralph-claude-code 继承的核心能力

| 能力 | 来源 | 实现方式 |
|------|------|---------|
| `claude -p` 自主循环 | `ralph_loop.sh` 主循环 | Agent 循环 / `scripts/boost-loop.sh` |
| JSON 响应解析 | `lib/response_analyzer.sh` | BOOST_STATUS 文本解析 |
| 断路器安全停机 | `lib/circuit_breaker.sh` | 内嵌增强版（L0-L4 原生） |
| 进展检测 | git changes + FILES_MODIFIED | 同 |
| 会话连续性 | `--resume` SESSION_ID | 同（仅 fallback 路径） |
| 上下文注入 | `build_loop_context()` | Agent prompt 注入 / `--append-system-prompt` |
| 速率限制 | 计数器 + 每小时重置 | 同 |
| 项目初始化 | `ralph_enable.sh` | `/ralph-boost setup` |

不复刻的功能（Ralph 特有，非核心）：
- 监控面板 `ralph_monitor.sh` — 用 `/ralph-boost status` 替代
- CI 集成 `ralph_enable_ci.sh` — 不需要
- 流式输出 — 不需要
- 交互式 Wizard — 不需要

### 增强：从 block-break 集成的收敛保证

| 能力 | 来源 | 集成方式 |
|------|------|---------|
| L0-L4 压力升级 | block-break 压力等级 | 原生内建在断路器中 |
| 五步方法论 | block-break 方法论 | 烘焙在 PROMPT 模板中 |
| 7 项检查清单 | block-break 检查清单 | 烘焙在 PROMPT 模板中 |
| 防早退规则 | block-break 三条红线 | 烘焙在 PROMPT 模板中 |
| 已尝试方案追踪 | block-break tried_approaches | 持久化在 state.json 中 |
| 结构化交接报告 | block-break 失败报告 | L4 时生成 handoff-report.md |

### 独立性保证

| 维度 | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| 项目目录 | `.ralph/` | `.ralph-boost/` |
| 配置文件 | `.ralphrc` | `.ralph-boost/config.json` |
| 状态文件 | `.ralph/.circuit_breaker_state` 等 5+ 文件 | `.ralph-boost/state.json`（统一） |
| 循环脚本 | `ralph_loop.sh`（2000+ 行） | Agent 循环 / `boost-loop.sh`（~400 行） |
| 响应格式 | `---RALPH_STATUS---` | `---BOOST_STATUS---` |
| PROMPT | `.ralph/PROMPT.md` | `.ralph-boost/PROMPT.md` |
| 共享文件 | 无 | 无 |

两者可同时安装在同一项目中，各用各的目录，互不感知。

## 架构

### 双路径概览

```
/ralph-boost run
    │
    ├─ 主路径：Agent 循环（skill 层）
    │   Claude 作为循环控制器，每轮 spawn Agent 子任务
    │   Read/Write 管理状态，零外部依赖
    │   适用：交互式会话、Claude Code 环境
    │
    └─ Fallback：boost-loop.sh（bash 脚本）
        运行时检测 jq / python，自动选择 JSON 引擎
        调用 claude CLI 执行每轮任务
        适用：headless/无人值守环境、无 Agent 能力的平台
```

两条路径共享以下契约：

| 契约 | 说明 |
|------|------|
| state.json schema | 完全一致，版本号 v1 |
| 压力计算公式 | 0→L0, 1→L1, 2→L2, 3→L3, 4+→L4 |
| 断路器转换 | CLOSED → HALF_OPEN → OPEN，含 threshold |
| BOOST_STATUS 格式 | 两者解析同一格式 |
| 防早退规则 | L4 + 7/7 checklist + handoff |
| fix_plan.md 格式 | `- [ ]` / `- [x]` 清单 |
| config.json 字段 | 两者读取相同字段 |

### 主路径：Agent 循环

Claude 在交互式会话中作为循环控制器，按以下 12 步反复执行：

```
初始化：
  确认 .ralph-boost/ 已初始化 → 读取 config.json → 输出启动信息

每轮循环：
  Step 1  读取 state.json
  Step 2  断路器检查 → OPEN 则停机
  Step 3  Rate Limit 检查 → 超限则暂停
  Step 4  构建压力上下文（按等级注入指令）
  Step 5  Spawn 前台 Agent（注入 PROMPT.md + 压力上下文）
  Step 6  解析 Agent 返回中的 BOOST_STATUS
  Step 7  检测进展（git status + BOOST_STATUS 字段）
  Step 8  更新断路器和压力等级
  Step 9  更新 session 和 timestamp
  Step 10 Write state.json
  Step 11 检查 EXIT_SIGNAL → true 则停止
  Step 12 输出轮次摘要，继续下一轮
```

Agent 行为由 `agents/loop-worker.md` 定义：每轮 Agent 读取 fix_plan.md 选取最高优先级任务，按压力等级约束执行，更新 state.json 的 pressure 字段，输出 BOOST_STATUS 块。

主路径的优势：
- 零外部依赖（不需要 jq、python、额外 shell）
- Agent 天然上下文隔离（每轮是独立 Agent）
- 跨平台可移植（Agent spawn 是所有 AI 编程平台的通用概念）

### Fallback：boost-loop.sh

bash 脚本实现，用于 headless/无人值守环境。启动时自动检测 JSON 引擎：

```
jq → python → python → 报错退出
```

所有 JSON 操作通过抽象函数分派：

| 函数 | 作用 |
|------|------|
| `json_get_str` | 从 stdin JSON 读取字段 |
| `json_get_file` | 从文件读取字段 |
| `json_set_field` | 设置 JSON 字段（管道链式调用） |
| `json_format` | 校验并格式化 JSON |
| `json_array_length` | 获取数组长度 |
| `json_build` | 从 key-value 构建 JSON 对象 |
| `json_extract_claude_text` | 从 Claude CLI 输出提取文本 |
| `json_extract_session_id` | 提取会话 ID |

每个函数内部 `case "$JSON_ENGINE"` 分派到 jq 或 python 实现。

依赖：`bash 4+`、`jq` 或 `python`、`claude`（Claude Code CLI）。

### Claude 调用模式（Fallback 路径）

复刻 Ralph 的调用模式，数组构建防 shell 注入：

```bash
claude --output-format json \
  --allowedTools "${ALLOWED_TOOLS[@]}" \
  --resume "$SESSION_ID" \
  --append-system-prompt "$loop_context" \
  -p "$prompt_content" < /dev/null > "$output_file" 2>&1
```

## 断路器：原生 L0-L4

### 状态机

Ralph 的断路器是被动的（3 轮放弃）。ralph-boost 将 block-break 的压力升级原生集成到断路器中：

```
有进展 → CLOSED（重置所有计数器，pressure → L0）

无进展:
  consecutive_no_progress = 1 → CLOSED, L1
  consecutive_no_progress = 2 → HALF_OPEN, L2
  consecutive_no_progress = 3 → HALF_OPEN, L3
  consecutive_no_progress = 4 → HALF_OPEN, L4（强制完成交接）
  consecutive_no_progress >= no_progress_threshold:
    handoff_written = true → OPEN（停机）
    handoff_written = false → 保持 L4（继续运行直到交接完成）
  consecutive_same_error >= same_error_threshold → OPEN（停机）
```

**关键区别**：压力升级由循环控制器驱动（主路径通过 Agent prompt 注入，Fallback 通过 `--append-system-prompt`），不依赖 Claude 自觉。Claude 只需按压力等级约束执行，并在 BOOST_STATUS 中报告状态。

### 压力升级表

| 等级 | 名称 | 旁白 | 强制行为 |
|------|------|------|---------|
| L0 | 信任 | 因为信任所以简单 | 正常执行 |
| L1 | 失望 | 隔壁组一次就过了 | 切换本质不同方案，记录 tried_approaches |
| L2 | 拷问 | 底层逻辑是什么？ | 逐字读错误 + 搜索上下文 50 行 + 列 3 个不同假设 |
| L3 | 绩效 | 给你 3.25 | 完成 7 项检查清单，全部写入 state.json |
| L4 | 毕业 | 你可能就要毕业了 | 最小 PoC 验证 + 写交接报告 |

### 防早退规则

`STATUS: BLOCKED` 和 `EXIT_SIGNAL: true` 在以下条件**全部满足前禁止输出**：
1. 压力等级已达 L4
2. 7 项检查清单全部完成
3. `.ralph-boost/handoff-report.md` 已写入

## 状态管理

### state.json

统一状态文件 `.ralph-boost/state.json`：

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

`circuit_breaker.consecutive_no_progress` 直接驱动 `pressure.level`，同一文件内无需跨文件同步。

主路径中，Agent 只更新 `pressure.*` 字段；其余字段（`circuit_breaker`、`session`、`rate_limit`）由循环控制器管理。

### config.json

`.ralph-boost/config.json`：

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

## BOOST_STATUS 协议

Claude 每轮结束时输出：

```
---BOOST_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: PASSING | FAILING | NOT_RUN
WORK_TYPE: IMPLEMENTATION | TESTING | DOCUMENTATION | REFACTORING | DEBUGGING
EXIT_SIGNAL: false | true
PRESSURE_LEVEL: L<N>
TRIED_COUNT: <number>
RECOMMENDATION:
  CURRENT_APPROACH: <what you tried>
  RESULT: <outcome>
  NEXT_APPROACH: <what should be tried next>
---END_BOOST_STATUS---
```

`FILES_MODIFIED` 只计任务相关文件，不计 state.json 等元数据。

`EXIT_SIGNAL: true` 的条件：
- 全部任务完成（fix_plan.md 全部 `[x]`）且测试通过
- 或 L4 优雅退出（满足防早退三条件）

## PROMPT.md 模板

从 `references/prompt-template.md` 生成，`{{PROJECT_NAME}}` 占位符在 setup 时替换。block-break 协议是模板的有机组成部分（非外挂注入）。

内容结构：
1. **角色与目标**：你是自主开发 agent，项目名 `{{PROJECT_NAME}}`
2. **任务来源**：读 `.ralph-boost/fix_plan.md`
3. **执行原则**：每轮一个任务、搜索后再实现、运行测试验证
4. **循环协议**：读 state.json → 按压力等级执行 → 输出 BOOST_STATUS → 更新 state.json
5. **压力升级表**：L0-L4 精简版（含隐喻和旁白）
6. **防早退规则**：3 个条件
7. **五步方法论**：5 个一行 bullet
8. **受保护文件**：`.ralph-boost/` 不可删除

Token 预算：~1500 字（~2200 token）。

## 上下文注入

循环控制器通过 Agent prompt（主路径）或 `--append-system-prompt`（Fallback）注入动态上下文（~300 字）：

```
Loop #3.
Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
Previous: Attempted to fix JSON parsing by upgrading jq, still failing.
Tried approaches: 2.
MANDATORY: Read error word-by-word. Search 50+ lines context. List 3 fundamentally different hypotheses.
```

L0 时上下文精简（仅循环号 + 上轮摘要）；L2+ 时注入等级约束指令。

## 文件结构

### Skill 文件（forge 仓库）

```
skills/ralph-boost/
├── SKILL.md                              # 入口 + Agent 循环控制器逻辑
├── agents/
│   └── loop-worker.md                    # 每轮 Agent 行为定义
├── scripts/
│   └── boost-loop.sh                     # Fallback 自主循环脚本（jq/python 双引擎）
└── references/
    ├── prompt-template.md                # PROMPT 模板（block-break 协议烘焙在内）
    ├── escalation-rules.md               # L0-L4 详细规则
    └── boost-status-protocol.md          # BOOST_STATUS 格式规范

evals/ralph-boost/
├── scenarios.md                          # 评估场景
└── run-trigger-test.sh                   # 触发测试脚本
```

### 目标项目中生成的文件

```
.ralph-boost/
├── PROMPT.md                             # 从模板生成（含 block-break 协议）
├── fix_plan.md                           # 任务清单
├── config.json                           # 配置
├── state.json                            # 统一状态
├── handoff-report.md                     # L4 交接报告（优雅退出时生成）
├── logs/
│   ├── boost.log                         # 循环日志（Fallback 路径）
│   ├── last_summary.txt                  # 上轮摘要（两条路径均写入）
│   └── claude_output_*.log               # 每轮 Claude 输出（Fallback 路径）
└── .gitignore                            # state.json logs/ handoff-report.md
```

全部在 `.ralph-boost/` 内，不触碰项目根目录任何文件。

## 核心对比

### vs ralph-claude-code

| 维度 | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| 形态 | 独立 Bash 工具 | Claude Code skill (Agent 循环) |
| 代码量 | 2000+ 行 | ~400 行 |
| 断路器 | 被动（3 轮放弃） | 主动（L0-L4，6-7 轮自救） |
| 状态 | 5+ 个文件 | 统一 state.json |
| 目录 | `.ralph/` | `.ralph-boost/` |
| 外部依赖 | jq（必须） | 主路径零依赖；Fallback 需 jq 或 python |

### vs block-break

| 维度 | block-break | ralph-boost |
|------|-------------|-------------|
| 场景 | 交互式会话 | 自主循环 |
| 检测 | PostToolUse hook | Agent 循环进展检测 / 循环脚本进展检测 |
| 控制 | hook 注入提示 | Agent prompt 注入 / --append-system-prompt |
| 状态 | `~/.forge/` | `.ralph-boost/state.json` |

## 评估场景

| # | 场景 | 验证点 |
|---|------|-------|
| 1 | setup 首次 | .ralph-boost/ 完整创建 |
| 2 | setup 幂等 | 检测已存在，提示覆盖 |
| 3 | L0 正常执行 | state.json loop_count 递增 |
| 4 | L1 切换方案 | tried_approaches 记录，方案本质不同 |
| 5 | L2 搜索与假设 | 3 个假设列出，逐字读错误 |
| 6 | L3 检查清单 | 7 项全部完成并记录 |
| 7 | L4 优雅交接 | handoff-report.md 生成后才允许停机 |
| 8 | 进展恢复 | 有进展 → pressure 重置到 L0 |
| 9 | 与 Ralph 共存 | .ralph/ 和 .ralph-boost/ 互不影响 |
| 10 | 速率限制 | 达上限后等待重置 |
| 11 | clean | .ralph-boost/ 完全删除 |

## 风险与缓解

| 风险 | 缓解 |
|------|------|
| state.json 损坏 | 写入前校验，损坏时 fallback 到初始状态 |
| PROMPT.md 过长 | 控制 ~1500 字，详细内容留 references/ |
| Claude 忘记输出 BOOST_STATUS | PROMPT 多处强调 + 无 BOOST_STATUS 视为无进展 |
| jq 和 python 均未安装 | 仅影响 Fallback 路径；主路径零外部依赖 |
| Agent spawn 失败 | Fallback 到 bash 路径 |
| 压力等级依赖 Claude 自觉 | 压力升级由循环控制器驱动，非依赖 Claude |
| 与 Ralph 冲突 | 独立目录 `.ralph-boost/`，零共享文件 |
