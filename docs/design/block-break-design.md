# Block Break 设计文档

**日期**: 2026-03-31
**状态**: 已实施（由 delve 重命名而来）

## 定位

Block Break — 高能动性行为约束引擎。被阻塞时突破它。

命名遵循 `名称-动词` 模式（与 `skill-lint` 一致）：
- **block**（名称/对象）：阻塞、卡壳
- **break**（动词/动作）：突破、打破

> **参考来源**：核心机制（三条红线、压力升级、五步方法论）参考 [PUA](https://github.com/tanweai/pua)，精简为零依赖的行为约束 skill。

## 覆盖与边界

> block-break 是**穷尽式调试的发动机**——它保证 agent 不会过早退出，但不保证退出时的方案是最优、正确或应该执行的。它管"有没有努力"，不管"努力的方向对不对"。

完整分析（能解决 / 不能解决 / 不应使用）：[references/scope-boundaries.md](../../skills/block-break/references/scope-boundaries.md)

## 命名决策

| 候选名 | 评价 | 结果 |
|--------|------|------|
| `issue-delve` | issue 偏 GitHub issue，delve 前缀冗余 | 淘汰 |
| `block-break` | 精准描述核心场景："被阻塞时突破它"，简洁有力 | **选中** |
| `issue-drill` | issue 通用性好，drill 有钻透含义 | 备选 |
| `task-delve` | 保留 delve 辨识度，task 作对象最通用 | 备选 |
| `deep-fix` | 暗示只能修 bug，范围太窄 | 淘汰 |
| `tenacity` | 精准但不直觉 | 淘汰 |

## 核心机制

| 机制 | 说明 |
|------|------|
| 三条红线 | 闭环验证 / 事实驱动 / 穷尽一切 |
| 压力升级 | L0 信任 → L1 失望 → L2 拷问 → L3 绩效 → L4 毕业 |
| 五步方法论 | 闻味道 → 揪头发 → 照镜子 → 新方案 → 复盘 |
| 7项检查清单 | L3+ 强制完成的诊断清单 |
| 抗合理化表 | 14 种常见借口的识别与封堵 |
| Hooks | 自动挫败检测 + 失败计数 + 状态持久化 |

## 文件结构

```
skills/block-break/SKILL.md                    # 核心 skill 定义
skills/block-break/references/checklist.md     # 7 项检查清单
skills/block-break/references/methodology.md   # 五步方法论
skills/block-break/references/anti-rationalization.md  # 抗合理化封堵表
skills/block-break/agents/block-break-worker.md       # Sub-agent 行为约束
evals/block-break/scenarios.md                 # 10 个评估场景
evals/block-break/run-trigger-test.sh          # 触发测试脚本
docs/user-guide/block-break-guide.md                # 用户手册
skills/block-break/hooks/hooks.json            # Hook 注册入口（UserPromptSubmit/PostToolUse/PreCompact/SessionStart）
skills/block-break/hooks/frustration-trigger.sh  # 挫败检测
skills/block-break/hooks/failure-detector.sh     # 失败计数
skills/block-break/hooks/session-restore.sh      # 状态恢复
```

## 状态持久化

- 状态文件：`~/.forge/block-break-state.json`
- 由 `skills/block-break/hooks/failure-detector.sh` 写入
- 由 `skills/block-break/hooks/session-restore.sh` 读取
- PreCompact hook 保存上下文状态
- 2 小时内有效

## 使用方式

```text
/block-break              # 激活
/block-break L2           # 从指定压力等级启动
/block-break fix the bug  # 激活后立即执行任务
```

自然语言触发：`try harder`、`别偷懒`、`又错了`、`stop spinning` 等。
