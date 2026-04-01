# Ralph Boost 设计文档

**日期**: 2026-04-01
**状态**: 设计中

## 定位

Ralph Boost — 自主开发循环引擎。以 skill 形式复刻 ralph-claude-code 的核心能力，集成 block-break 的收敛保证，解决自主循环"停而不转"的问题。

命名遵循 `名称-动词` 模式：
- **ralph**（名称）：自主开发循环范式（源自 ralph-claude-code 开创的模式）
- **boost**（动词）：增强、提升

与 ralph-claude-code 完全独立：不依赖、不修改、不共享任何文件。两者可同时安装互不影响。

## 目标

### 复刻：从 ralph-claude-code 继承的核心能力

| 能力 | 来源 | 实现方式 |
|------|------|---------|
| `claude -p` 自主循环 | `ralph_loop.sh` 主循环 | `scripts/boost-loop.sh` |
| JSON 响应解析 | `lib/response_analyzer.sh` | 内嵌精简版 |
| 断路器安全停机 | `lib/circuit_breaker.sh` | 内嵌增强版（L0-L4 原生） |
| 进展检测 | git changes + FILES_MODIFIED | 同 |
| 会话连续性 | `--resume` SESSION_ID | 同 |
| 上下文注入 | `build_loop_context()` | 同，增加压力等级 |
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
| 循环脚本 | `ralph_loop.sh`（2000+ 行） | `boost-loop.sh`（~400 行） |
| 响应格式 | `---RALPH_STATUS---` | `---BOOST_STATUS---` |
| PROMPT | `.ralph/PROMPT.md` | `.ralph-boost/PROMPT.md` |
| 共享文件 | 无 | 无 |

两者可同时安装在同一项目中，各用各的目录，互不感知。

## 架构

### 整体流程

```
用户调用 /ralph-boost setup
  → 创建 .ralph-boost/ 目录结构
  → 生成 PROMPT.md（block-break 协议烘焙在内）
  → 初始化 config.json、state.json、fix_plan.md
  → 输出启动命令

用户执行 bash boost-loop.sh
  → while true:
      1. 检查速率限制
      2. 读 state.json → 获取断路器状态和压力等级
      3. 若 OPEN → 停机（优雅退出）
      4. 构建上下文（循环号 + 压力等级 + 上轮摘要）
      5. 调用 claude -p（含 PROMPT.md + 上下文注入）
      6. 解析 BOOST_STATUS
      7. 检测进展 → 更新断路器 + 压力升级/重置
      8. 写 state.json
      9. sleep
```

### Claude 调用模式

复刻 Ralph 的调用模式，数组构建防 shell 注入：

```bash
claude --output-format json \
  --allowedTools "${ALLOWED_TOOLS[@]}" \
  --resume "$SESSION_ID" \
  --append-system-prompt "$loop_context" \
  -p "$prompt_content" < /dev/null > "$output_file" 2>&1
```

### 断路器：原生 L0-L4

Ralph 的断路器是被动的（3 轮放弃）。ralph-boost 将 block-break 的压力升级原生集成到断路器中：

```
有进展 → L0 CLOSED（重置所有计数器）

无进展:
  1 轮 → L1 失望（上下文注入：切换策略指令）
  2 轮 → L2 拷问（上下文注入：搜源码 + 列假设）
  3 轮 → L3 绩效（上下文注入：完成 7 项清单）
  4 轮 → L4 毕业（上下文注入：PoC + 写交接报告）
  5+ 轮 → 检查 handoff → 有交接报告则 OPEN 停机，无则保持 L4
```

**关键区别**：压力升级由循环脚本控制（通过 `--append-system-prompt` 注入），不依赖 Claude 自觉。Claude 只需按 PROMPT.md 中的等级约束执行，并在 BOOST_STATUS 中报告当前状态。

### 压力升级表

| 等级 | 名称 | 旁白 | 强制行为（注入到 `--append-system-prompt`） |
|------|------|------|---------|
| L0 | 信任 | 因为信任所以简单 | 正常执行 |
| L1 | 失望 | 隔壁组一次就过了 | 切换本质不同方案，记录 tried_approaches |
| L2 | 拷问 | 底层逻辑是什么？ | 逐字读错误 + 搜索上下文 50 行 + 列 3 个不同假设 |
| L3 | 绩效 | 给你 3.25 | 完成 7 项检查清单，全部写入 state.json |
| L4 | 毕业 | 你可能就要毕业了 | 最小 PoC 验证 + 写交接报告 |

### 防早退规则

`STATUS: BLOCKED` 和 `EXIT_SIGNAL: true` 在以下条件**全部满足前禁止输出**（在 PROMPT.md 中约束）：
1. 压力等级已达 L4
2. 7 项检查清单全部完成
3. `.ralph-boost/handoff-report.md` 已写入

### 状态管理

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

### 配置

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

### BOOST_STATUS 格式

Claude 每轮结束时输出：

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L1
TRIED_COUNT: 1
RECOMMENDATION:
  CURRENT_APPROACH: 重构认证中间件
  RESULT: 基本框架完成，测试待补充
  NEXT_APPROACH: 添加边界用例测试
---END_BOOST_STATUS---
```

`FILES_MODIFIED` 只计任务相关文件，不计 state.json 等元数据。

### PROMPT.md 模板

从 `references/prompt-template.md` 生成，block-break 协议烘焙在内（非外挂注入）。

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

### 上下文注入

循环脚本通过 `--append-system-prompt` 注入动态上下文（~300 字）：

```
Loop #3.
Pressure: L2 拷问 — 底层逻辑是什么？抓手在哪？
Previous: Attempted to fix JSON parsing by upgrading jq, still failing.
Tried approaches: 2. Must switch to fundamentally different approach.
L2 mandatory: Read error word-by-word, search 50 lines context, list 3 different hypotheses.
```

L0 时上下文精简（仅循环号 + 上轮摘要）；L2+ 时注入等级约束指令。

## 文件结构

### Skill 文件（在 jskills 仓库中）

```
skills/ralph-boost/
├── SKILL.md                              # 入口（~80 行）
├── scripts/
│   └── boost-loop.sh                     # 自主循环脚本（~400 行）
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
│   ├── boost.log                         # 循环日志
│   └── claude_output_*.log               # 每轮 Claude 输出
└── .gitignore                            # state.json logs/ handoff-report.md
```

全部在 `.ralph-boost/` 内，不触碰项目根目录任何文件。

## 文件详细设计

### `SKILL.md`

```yaml
---
name: ralph-boost
description: "Ralph Boost — 自主开发循环引擎。复刻 ralph-claude-code 核心能力，内建 Block Break 收敛保证。setup → run → status → clean。"
license: MIT
argument-hint: "[setup|run|status|clean]"
---
```

子命令：
- `setup` — 创建 `.ralph-boost/`，生成所有文件，输出启动命令
- `run` — 提示用户执行 `bash <boost-loop.sh 路径>`
- `status` — 读取展示 state.json（压力等级、已尝试方案、清单进度）
- `clean` — 删除 `.ralph-boost/`

### `scripts/boost-loop.sh`

~400 行 Bash 脚本，模块化设计：

| 模块 | 行数估算 | 职责 |
|------|---------|------|
| 配置加载 | ~30 | 读 config.json（jq） |
| 状态读写 | ~40 | read_state / write_state |
| Claude 调用 | ~60 | 数组构建 + 超时 + 输出捕获 |
| 响应解析 | ~80 | 提取 BOOST_STATUS + 进展检测 |
| 断路器 | ~80 | L0-L4 升级/重置 + OPEN 判定 |
| 上下文注入 | ~40 | 按压力等级构建 append-system-prompt |
| 速率限制 | ~30 | 计数器 + 每小时重置 |
| 主循环 | ~40 | while + sleep + 信号处理 |

依赖：`bash 4+`、`jq`、`claude`（Claude Code CLI）。

### `references/prompt-template.md`

PROMPT 模板，`{{PROJECT_NAME}}` 占位符在 setup 时替换。

block-break 协议是模板的有机组成部分（非独立注入），包含：
- 循环开始/结束协议
- 压力等级约束
- 防早退规则
- 五步方法论（精简版）

### `references/escalation-rules.md`

交互式参考（`/ralph-boost` 调用时 Claude 读取）：
- 各等级完整定义和示例
- "本质不同"判定标准
- 7 项检查清单详细说明
- 交接报告模板

### `references/boost-status-protocol.md`

BOOST_STATUS 格式规范 + 各等级示例输出。

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
| Claude 忘记输出 BOOST_STATUS | PROMPT 多处强调 + 循环脚本 fallback 解析 |
| jq 未安装 | 启动时检查，未安装则报错退出 |
| 压力等级依赖 Claude 自觉 | 压力升级由循环脚本通过上下文注入控制，非依赖 Claude |
| 与 Ralph 冲突 | 独立目录 `.ralph-boost/`，零共享文件 |

## 实现顺序

1. `references/prompt-template.md` — PROMPT 模板 + block-break 协议
2. `scripts/boost-loop.sh` — 自主循环脚本
3. `references/escalation-rules.md` — L0-L4 详细规则
4. `references/boost-status-protocol.md` — BOOST_STATUS 规范
5. `SKILL.md` — 入口 + 子命令
6. `evals/ralph-boost/scenarios.md` — 评估场景
7. `evals/ralph-boost/run-trigger-test.sh` — 触发测试
8. `.claude-plugin/marketplace.json` 更新
9. `README.md` 更新

## 验证方式

1. `skill-lint` 校验结构完整性
2. `/ralph-boost setup` → 确认 `.ralph-boost/` 完整生成
3. 幂等性：二次 setup 提示已存在
4. 共存：已装 Ralph 的项目中 setup，确认 `.ralph/` 不受影响
5. 手动模拟各压力等级的 state.json，验证循环脚本的上下文注入
6. `bash boost-loop.sh` 验证单轮执行
7. `bash evals/ralph-boost/run-trigger-test.sh`
8. `/ralph-boost status` + `/ralph-boost clean`
