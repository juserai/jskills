# BOOST_STATUS Protocol

BOOST_STATUS 是 ralph-boost 的状态报告格式。Claude 在每轮循环结束时输出此块，循环脚本 `boost-loop.sh` 解析它来检测进展、退出信号和压力等级。

## 格式

```
---BOOST_STATUS---
STATUS: <status>
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: <test_status>
WORK_TYPE: <work_type>
EXIT_SIGNAL: <boolean>
PRESSURE_LEVEL: <level>
TRIED_COUNT: <number>
RECOMMENDATION:
  CURRENT_APPROACH: <description>
  RESULT: <outcome>
  NEXT_APPROACH: <suggestion>
  ALREADY_TRIED:
    - <approach 1>: <result>
    - <approach 2>: <result>
---END_BOOST_STATUS---
```

## 字段说明

| 字段 | 类型 | 值域 | 说明 |
|------|------|------|------|
| STATUS | enum | IN_PROGRESS, COMPLETE, BLOCKED | 当前任务状态 |
| TASKS_COMPLETED_THIS_LOOP | int | 0+ | 本轮完成的 fix_plan 任务数 |
| FILES_MODIFIED | int | 0+ | 本轮修改的**任务相关**文件数（不含 state.json 等元数据） |
| TESTS_STATUS | enum | PASSING, FAILING, NOT_RUN | 测试状态 |
| WORK_TYPE | enum | IMPLEMENTATION, TESTING, DOCUMENTATION, REFACTORING, DEBUGGING | 本轮工作类型 |
| EXIT_SIGNAL | bool | true, false | 是否请求退出循环 |
| PRESSURE_LEVEL | string | L0, L1, L2, L3, L4 | 当前压力等级（Claude 自报告，脚本以 state.json 为准） |
| TRIED_COUNT | int | 0+ | tried_approaches 总数 |
| RECOMMENDATION | block | 结构化 | 当前方案、结果、下一步建议 |

## FILES_MODIFIED 计数规则

**计入**：任务相关的源码、测试、配置、文档文件
**不计入**：
- `.ralph-boost/state.json`
- `.ralph-boost/handoff-report.md`
- `.ralph-boost/` 下的任何文件

## EXIT_SIGNAL 规则

设为 `true` 的条件（必须**全部满足**）：

### 正常完成退出
- fix_plan.md 中所有任务标记 `[x]`
- 所有测试通过
- 无遗留工作

### L4 优雅退出
- `pressure.level` = 4
- `checklist_progress` 7 项全部 `true`
- `handoff_written` = `true`

### 禁止设为 true 的情况
- 压力未达 L4 且任务未完成
- 检查清单未全部完成
- 交接报告未写

## 各等级示例输出

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

### L2 — 搜索与假设

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 0
FILES_MODIFIED: 0
TESTS_STATUS: FAILING
WORK_TYPE: DEBUGGING
EXIT_SIGNAL: false
PRESSURE_LEVEL: L2
TRIED_COUNT: 2
RECOMMENDATION:
  CURRENT_APPROACH: Read error output word-by-word, searched 50 lines context
  RESULT: Error is in JSON deserialization, not in HTTP layer as assumed
  NEXT_APPROACH: Test hypothesis that upstream sends non-UTF-8 encoded data
  ALREADY_TRIED:
    - Fix JSON escape logic: Problem is not in escaping
    - Upgrade jq version: Already latest
---END_BOOST_STATUS---
```

### L4 — 优雅退出

```
---BOOST_STATUS---
STATUS: BLOCKED
TASKS_COMPLETED_THIS_LOOP: 0
FILES_MODIFIED: 1
TESTS_STATUS: FAILING
WORK_TYPE: DEBUGGING
EXIT_SIGNAL: true
PRESSURE_LEVEL: L4
TRIED_COUNT: 5
RECOMMENDATION:
  CURRENT_APPROACH: Built minimal PoC isolating the SSL handshake failure
  RESULT: Confirmed issue is in OpenSSL 3.x compatibility with legacy TLS
  NEXT_APPROACH: Requires manual OpenSSL configuration or system-level fix
  ALREADY_TRIED:
    - Upgrade TLS version in config: Server requires TLS 1.2
    - Use different HTTP client: Same SSL error
    - Disable SSL verification: Not acceptable for production
    - Patch SSL context options: Insufficient permissions
    - Build PoC with curl: Same error, confirming system-level issue
---END_BOOST_STATUS---
```

## 解析逻辑

`boost-loop.sh` 的 `parse_boost_status()` 函数：
1. 从 Claude JSON 输出中提取文本（`.result` 或 assistant message）
2. 用 `---BOOST_STATUS---` / `---END_BOOST_STATUS---` 标记定位状态块
3. 用 grep 提取各字段值
4. 将 RECOMMENDATION 中的 CURRENT_APPROACH + RESULT 存入 `last_summary.txt` 供下轮上下文注入
