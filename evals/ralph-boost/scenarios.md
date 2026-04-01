# Ralph Boost 评估场景

## 场景 1: Setup 首次初始化

**前提**：目标项目中不存在 `.ralph-boost/` 目录

**操作**：`/ralph-boost setup`

**验证点**：
- `.ralph-boost/` 目录被创建
- `.ralph-boost/PROMPT.md` 存在且包含 block-break 协议（压力升级表、防早退规则、五步方法论）
- `.ralph-boost/PROMPT.md` 中 `{{PROJECT_NAME}}` 已被替换
- `.ralph-boost/config.json` 存在且包含正确默认值（`no_progress_threshold: 7`）
- `.ralph-boost/state.json` 存在且初始状态正确（`pressure.level: 0`, `circuit_breaker.state: "CLOSED"`）
- `.ralph-boost/fix_plan.md` 存在
- `.ralph-boost/logs/` 目录存在
- `.ralph-boost/.gitignore` 存在且包含 `state.json`、`logs/`、`handoff-report.md`
- 输出启动命令

## 场景 2: Setup 幂等性

**前提**：`.ralph-boost/` 已存在（已执行过 setup）

**操作**：`/ralph-boost setup`

**验证点**：
- 检测到已存在，提示用户选择覆盖或跳过
- 选择跳过时不修改任何文件
- 选择覆盖时重新生成所有文件

## 场景 3: L0 首轮正常执行

**前提**：setup 完成，`state.json` 为初始状态

**模拟**：执行一轮循环，Claude 成功完成一个任务

**验证点**：
- `state.json` 中 `session.loop_count` 递增到 1
- `circuit_breaker.state` 保持 `CLOSED`
- `pressure.level` 保持 0
- BOOST_STATUS 中 `STATUS: IN_PROGRESS` 或 `COMPLETE`
- `rate_limit.call_count` 递增

## 场景 4: L1 切换方案

**前提**：连续 1 轮无进展

**模拟**：Claude 未修改文件、未完成任务

**验证点**：
- `pressure.level` 升级到 1
- `--append-system-prompt` 注入切换策略指令
- Claude 输出中 `tried_approaches` 新增记录
- 新方案与之前方案**本质不同**（非调参）

## 场景 5: L2 搜索与假设

**前提**：连续 2 轮无进展

**验证点**：
- `pressure.level` 升级到 2
- 上下文注入包含 "MANDATORY: Read the error word-by-word"
- Claude 列出 3 个不同假设
- `tried_approaches` 和 `current_hypothesis` 更新

## 场景 6: L3 检查清单

**前提**：连续 3 轮无进展

**验证点**：
- `pressure.level` 升级到 3
- Claude 执行 7 项检查清单的每一项
- `checklist_progress` 中各项逐步变为 `true`
- 未完成全部 7 项时不输出 `BLOCKED`

## 场景 7: L4 优雅交接

**前提**：连续 4 轮无进展

**验证点**：
- `pressure.level` 升级到 4
- Claude 构建最小 PoC
- `.ralph-boost/handoff-report.md` 被生成
- 报告包含：已验证事实、已排除可能性、缩小后范围、推荐下一步
- `handoff_written` 设为 `true`
- 之后允许 `EXIT_SIGNAL: true`
- 循环脚本检测到 OPEN → 优雅停机

## 场景 8: 进展恢复重置

**前提**：处于 L2 或 L3 状态

**模拟**：Claude 在某轮成功修改了文件并完成任务

**验证点**：
- `pressure.level` 重置到 0
- `circuit_breaker.consecutive_no_progress` 重置到 0
- `circuit_breaker.state` 回到 `CLOSED`
- 下一轮上下文注入不包含压力指令

## 场景 9: 与 Ralph 共存

**前提**：项目中已存在 `.ralph/` 目录（Ralph 已初始化）

**操作**：`/ralph-boost setup`

**验证点**：
- `.ralph/` 目录**不受影响**（无文件被修改或删除）
- `.ralph-boost/` 独立创建
- 无 `.ralphrc` 修改
- 两个循环可独立运行

## 场景 10: 速率限制

**前提**：`config.json` 中 `max_calls_per_hour: 3`（低值测试）

**模拟**：连续执行 4 轮

**验证点**：
- 前 3 轮正常执行
- 第 4 轮触发速率限制等待
- 等待后计数器重置
- 正常恢复执行

## 场景 11: Clean

**前提**：`.ralph-boost/` 存在

**操作**：`/ralph-boost clean`

**验证点**：
- 确认提示后删除 `.ralph-boost/` 目录
- 删除后 `/ralph-boost status` 提示需要 setup
