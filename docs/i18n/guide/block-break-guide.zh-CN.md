# Block Break 用户指南

> 5 分钟上手 — 让你的 AI 代理穷尽一切方法

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserai/forge
```

### 通用一行安装

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **零依赖** — Block Break 无需任何外部服务或 API。安装即用。

---

## 命令

| 命令 | 功能 | 使用时机 |
|------|------|---------|
| `/block-break` | 激活 Block Break 引擎 | 日常任务、调试 |
| `/block-break L2` | 从指定压力等级开始 | 已知多次失败后 |
| `/block-break fix the bug` | 激活并立即执行任务 | 带任务快速启动 |

### 自然语言触发（由 hooks 自动检测）

| 语言 | 触发短语 |
|------|---------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## 使用场景

### AI 尝试 3 次仍未修复 bug

输入 `/block-break` 或说 `try harder` — 自动进入压力升级模式。

### AI 说"可能是环境问题"然后停下

Block Break 的"基于事实"红线强制工具验证。未经验证的归因 = 甩锅 → 触发 L2。

### AI 说"建议你手动处理"

触发"主人翁意识"拦截：你不干谁干？直接 L3 绩效评审。

### AI 说"已修复"但没有验证证据

违反"闭环"红线。没有输出的完成 = 自欺欺人 → 强制带证据的验证命令。

---

## 预期输出示例

### `/block-break` — 激活

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 失望（第 2 次失败）

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 质询（第 3 次失败）

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 绩效评审（第 4 次失败）

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 毕业警告（第 5+ 次失败）

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### 体面退出（7 项全部完成，仍未解决）

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## 核心机制

### 3 条红线

| 红线 | 规则 | 违反后果 |
|------|------|---------|
| 闭环 | 声称完成前必须运行验证命令并展示输出 | 触发 L2 |
| 基于事实 | 归因前必须用工具验证 | 触发 L2 |
| 穷尽所有 | 说"无法解决"前必须完成 5 步方法论 | 直接 L4 |

### 压力升级（L0 → L4）

| 失败次数 | 等级 | 旁白 | 强制动作 |
|---------|------|------|---------|
| 第 1 次 | **L0 信任** | > 我们信任你。保持简单。 | 正常执行 |
| 第 2 次 | **L1 失望** | > 隔壁团队一次就搞定了。 | 切换到根本不同的方法 |
| 第 3 次 | **L2 质询** | > 根本原因是什么？ | 搜索 + 阅读源码 + 列出 3 个不同假设 |
| 第 4 次 | **L3 绩效评审** | > 评分：3.25/5。 | 完成 7 点清单 |
| 第 5+ 次 | **L4 毕业** | > 你可能很快就要被替换了。 | 最小 PoC + 隔离环境 + 不同技术栈 |

### 5 步方法论

1. **闻味道** — 列出已尝试的方法，找到共同模式。同一方法微调 = 原地打转
2. **扯头发** — 逐字阅读错误信号 → 搜索 → 阅读 50 行源码 → 验证假设 → 反转假设
3. **照镜子** — 我在重复同样的方法吗？我遗漏了最简单的可能性吗？
4. **新方法** — 必须根本不同，有验证标准，且失败时能产生新信息
5. **回顾** — 类似问题、完整性、预防

> 步骤 1-4 必须在询问用户之前完成。先做后问 — 用数据说话。

### 7 点清单（L3 及以上强制执行）

1. 逐字阅读了失败信号？
2. 用工具搜索了核心问题？
3. 阅读了失败点的原始上下文（50+ 行）？
4. 所有假设都用工具验证了（版本/路径/权限/依赖）？
5. 尝试了完全相反的假设？
6. 能在最小范围内复现？
7. 更换了工具/方法/角度/技术栈？

### 反合理化

| 借口 | 拦截 | 触发 |
|------|------|------|
| "超出我的能力" | 你有海量训练数据，用完了吗？ | L1 |
| "建议用户手动处理" | 你不干谁干？ | L3 |
| "试过所有方法了" | 少于 3 种 = 没试完 | L2 |
| "可能是环境问题" | 你验证了吗？ | L2 |
| "需要更多上下文" | 你有工具。先搜索，再提问 | L2 |
| "无法解决" | 你完成方法论了吗？ | L4 |
| "够好了" | 优化清单不搞特殊化 | L3 |
| 未验证就声称完成 | 你跑 build 了吗？ | L2 |
| 等待用户指示 | 主人不等别人催 | Nudge |
| 回答但不解决 | 你是工程师，不是搜索引擎 | Nudge |
| 改了代码没跑 build/test | 不测试就交付 = 敷衍了事 | L2 |
| "API 不支持" | 你读文档了吗？ | L2 |
| "任务太模糊" | 做出最佳猜测，然后迭代 | L1 |
| 反复调整同一个地方 | 改参数 ≠ 换方法 | L1→L2 |

---

## Hooks 自动化

Block Break 使用 hooks 系统实现自动行为 — 无需手动激活：

| Hook | 触发条件 | 行为 |
|------|---------|------|
| `UserPromptSubmit` | 用户输入匹配挫败关键词 | 自动激活 Block Break |
| `PostToolUse` | Bash 命令执行后 | 检测失败，自动计数 + 升级 |
| `PreCompact` | 上下文压缩前 | 保存状态到 `~/.forge/` |
| `SessionStart` | 会话恢复/重启 | 恢复压力等级（2 小时内有效） |

> **状态持久化** — 压力等级存储在 `~/.forge/block-break-state.json` 中。上下文压缩和会话中断不会重置失败计数。无处可逃。

### Hooks 配置

通过 `claude plugin add juserai/forge` 安装时，hooks 会自动配置。Hook 脚本需要 `jq`（首选）或 `python` 作为 JSON 引擎 — 系统上至少需要有一个可用。

如果 hooks 没有触发，请验证配置：

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### 状态过期

状态在 **2 小时**无活动后自动过期。这防止了上一次调试会话中的陈旧压力延续到无关的工作中。2 小时后，会话恢复 hook 会静默跳过恢复，你从 L0 重新开始。

随时手动重置：`rm ~/.forge/block-break-state.json`

---

## Sub-agent 约束

生成 sub-agent 时，必须注入行为约束以防止"裸奔"：

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` 确保 sub-agent 也遵循 3 条红线、5 步方法论和闭环验证。

---

## 故障排除

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| Hooks 没有自动触发 | 插件未安装或 hooks 不在 settings.json 中 | 重新运行 `claude plugin add juserai/forge` |
| 状态未持久化 | `jq` 和 `python` 都不可用 | 安装其中一个：`apt install jq` 或确保 `python` 在 PATH 中 |
| 压力卡在 L4 | 状态文件积累了太多失败 | 重置：`rm ~/.forge/block-break-state.json` |
| 会话恢复显示旧状态 | 上一会话的状态不到 2 小时 | 预期行为；等待 2 小时或手动重置 |
| `/block-break` 未被识别 | 当前会话未加载 Skill | 重新安装插件或使用通用一行安装 |

---

## 常见问题

### Block Break 和 PUA 有什么区别？

Block Break 受 [PUA](https://github.com/tanweai/pua) 核心机制（3 条红线、压力升级、方法论）启发，但更加聚焦。PUA 有 13 种企业文化口味、多角色系统（P7/P9/P10）和自我进化；Block Break 纯粹聚焦于行为约束，作为零依赖 skill。

### 会不会太吵？

旁白密度受控：简单任务 2 行（开始 + 结束），复杂任务每个里程碑 1 行。不会刷屏。不需要时不要使用 `/block-break` — hooks 仅在检测到挫败关键词时自动触发。

### 如何重置压力等级？

删除状态文件：`rm ~/.forge/block-break-state.json`。或等待 2 小时 — 状态自动过期（见上方[状态过期](#状态过期)）。

### 可以在 Claude Code 之外使用吗？

核心 SKILL.md 可以复制粘贴到任何支持系统提示词的 AI 工具中。Hooks 和状态持久化是 Claude Code 特有的。

### 和 Ralph Boost 是什么关系？

[Ralph Boost](ralph-boost-guide.md) 将 Block Break 的核心机制（L0-L4、5 步方法论、7 点清单）适配到**自主循环**场景。Block Break 用于交互式会话（hooks 自动触发）；Ralph Boost 用于无人值守的开发循环（Agent 循环 / 脚本驱动）。代码完全独立，概念共享。

### 如何验证 Block Break 的 skill 文件？

使用 [Skill Lint](skill-lint-guide.md)：`/skill-lint .`

---

## 许可证

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
