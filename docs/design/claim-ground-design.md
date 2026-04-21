# claim-ground 设计文档

**日期**: 2026-04-17（2026-04-17 修订：新增 epistemic-pushback hook；2026-04-21 修订 v1.1：Manual Execution Mode 1 + R7 术语红线 + Rule 7 词族扩展 + Playbook 标准体行 + hook 自调用 guard）
**状态**: 已批准
**版本**: 1.1.0

## 定位

自动触发的认知约束 skill。行为约束为主，配一个 UserPromptSubmit hook 作为质疑信号兜底，无 sub-agent。

覆盖两类场景：

1. **事实类当前状态查询** — 模型版本、工具版本、安装状态、配置值、功能可用性等"此刻是什么"的问题
2. **用户对既往断言的质疑** — "真的吗 / 不对吧 / 已经更新了吧" 等反驳语气

触发后强制 Claude：先查 runtime context（系统 prompt / env vars / 工具输出）→ 引用原文证据 → 再下结论。被反驳时**重新验证**，不允许换措辞重申错误答案。

## 覆盖与边界

> claim-ground 是**事实类断言的入口闸门**——保证每个"此刻状态"事实有可验证来源，但管不了来源是否真实、是否被正确解读，也管不了非事实类判断。

完整分析（能解决 / 不能解决 / 不应使用）：[references/scope-boundaries.md](../../skills/claim-ground/references/scope-boundaries.md)

## 动机

训练知识与运行时 context 冲突时，Claude 倾向于复述训练记忆。典型表现：

- 系统 prompt 明确写了 `Opus 4.7`，Claude 仍回答"最新是 4.6"
- CLI help 示例里出现 `sonnet-4-6`，Claude 据此判定"CLI 不支持 4.7"
- 用户质疑错误答案时，Claude 换个措辞重申同一错误

这类错误在长对话中反复出现，手动纠正代价高。skill 化后可被 description matcher 自动触发，前置拦截。

## 设计决策

| 决策点 | 选择 | 理由 |
|--------|------|------|
| 类型 | 纯 skill（SKILL.md 行为约束） | 无需 runtime 状态，认知层面 |
| 触发方式 | 自动（description-based） | 事实类问题随时出现，手动 command 会漏触发 |
| 分类 | hammer | 对"事实断言"行为施加认知约束，与 block-break 同类（行为约束、auto-trigger、hook 兜底）。不输出 pass/fail 判定，不属 anvil |
| 与 block-break 关系 | 正交互补 | block-break 处理"卡住"，claim-ground 处理"事实输出"。两者可同时激活 |
| Hooks | 1 × UserPromptSubmit | description 激活不确定性高；对"真的吗 / 你确定 / really? / are you sure"等**质疑信号**用 hook 兜底，避免 Claude 漏激活后换措辞重申错误答案。事实类查询仍由 description 匹配触发，不加 hook（避免过度激活） |
| Sub-agents | 无 | 约束作用于主 agent 的输出链路，无需分叉子任务 |
| Scripts | 无 | 纯文本规则，无需脚本计算 |
| Permissions | read-only / no execution | 仅消费 context，不产生副作用 |

## 核心规则

SKILL.md 正文保持精简，列出 5 条核心规则；详细反例、playbook 放 `references/`。

1. **Runtime > Training** — 系统 prompt / env vars / 工具输出 > 训练记忆。冲突时 runtime 赢
2. **先引用，后断言** — 回答前贴原文片段，再下结论。查不到原文 → 明说"未验证推测"
3. **示例 ≠ 穷举** — CLI help、文档、错误消息里的举例不等于完整列表
4. **被质疑 → 重查，不重申** — 用户反驳时重新验证（重读 context / 跑工具），换措辞重申 = 红线
5. **不确定就说不确定** — runtime 查不到的直接说"我不确定"，不猜

## 文件清单

```text
skills/claim-ground/
├── SKILL.md                      # Claude Code 主定义
└── references/
    ├── red-lines.md              # 3 条红线 + 反例
    └── playbook.md               # 按问题类型的查证策略

platforms/openclaw/claim-ground/
├── SKILL.md                      # OpenClaw 适配版
└── references/
    ├── red-lines.md
    └── playbook.md

evals/claim-ground/
├── scenarios.md                  # ≥5 场景
└── run-trigger-test.sh           # 自动化触发测试

docs/
├── guide/claim-ground-guide.md
├── i18n/guide/claim-ground-guide.<lang>.md × 11 语言
└── plans/claim-ground-design.md  # 本文档

.claude-plugin/marketplace.json   # 追加条目 + SHA-256
README.md + docs/i18n/README.*.md # Anvil 章节追加条目
```

## 工作流

1. Claude 收到用户消息
2. Description matcher 判断是否触发（事实类问题 / 用户反驳）
3. 触发后进入回答流程：
   - 查 runtime context（系统 prompt、环境变量、已有工具输出）
   - 找到原文 → 在回答中**引用原文片段**，再下结论
   - 找不到原文但可以验证 → 调工具（Read / Bash / Grep）验证
   - 既无 context 也无工具可验证 → 明说"我不确定"
4. 被用户反驳时：
   - **必须**重新查证据（不允许换措辞重申）
   - 新证据支持原答案 → 贴新证据说明
   - 新证据推翻原答案 → 承认错误并更正

## 输出示例

**Good**（触发 claim-ground 后）：

> 根据系统 prompt 原文："You are powered by the model named Opus 4.7 (1M context)"，当前模型是 Claude Opus 4.7。

**Bad**（未触发 / 红线）：

> 当前是 Claude Opus 4.6，这是最新的 Claude 模型。

## 与 block-break 的协同

block-break 和 claim-ground 正交，可同时激活：

- **claim-ground 单独触发**：用户问事实性问题（没有"卡住"情境）
- **block-break 单独触发**：调试卡住（不涉及事实类断言）
- **两者共同触发**：调试过程中 Claude 断言"这个函数不存在"，用户反驳"你查过吗" → claim-ground 强制重查 + block-break 强制不许放弃

## Out of Scope

- 不修改 `block-break`（保持职责单一）
- 不加事实类查询 hook（description 匹配已足够，且加 hook 容易过度激活）
- 不加 `commands/claim-ground.md`（自动触发 skill，手动 command 多余）
- 不做"幻觉检测"的通用化（聚焦**当前状态查询**和**质疑响应**两类场景，避免过宽触发）

## Hook 设计（2026-04-17 新增）

**epistemic-pushback-trigger**（UserPromptSubmit）：

- **matcher**：`真的吗|不对吧|你确定|已经更新|官方不是|我记得.*已经|不是.*已经|really\?|are you sure|I thought.*(was|were)|isn'?t it already`
- **脚本**：[skills/claim-ground/hooks/epistemic-pushback-trigger.sh](../../skills/claim-ground/hooks/epistemic-pushback-trigger.sh)
- **输出**：`<CLAIM_GROUND_ACTIVATED>` 块，强制 Claude 重新验证（重读 context / 跑工具），不允许换措辞重申
- **与 block-break 正交**：block-break matcher 捕获挫败信号（"又错了 / 降智"等），此 hook 捕获**事实质疑**信号，两者可同时激活但输出不同指令
- **why not same hook**：block-break 强制"不许放弃 + 换方案"，claim-ground 强制"不许重申 + 重查证据"，动作不同，必须分开

## v1.1 修订（2026-04-21）

### 触发事件

之前一个会话用户问 "商业分析（BA）和投资分析（IA）有什么区别"，回答凭训练记忆套了 SWOT/Porter 五力。但 BA 的权威定义在 IIBA《BABOK Guide》、IA 的权威定义在 CFA Institute Curriculum——两个都是有明确标准体的术语。R1（无源断言）理论上能盖此场景，但 R1 的反例几乎全是 live-state（模型版本、CLI 版本、env），模型容易给"术语定义"打豁免。R7 把这个豁免堵死。

同时暴露另一缺陷：手动 `/claim-ground <args>` 走 help 卡片回落，没有 main path——用户想主动接地某断言时只能用"自然语言+反驳"绕路。

完整 Plan 原文：[~/.claude/plans/skill-help-dazzling-wombat.md](~/.claude/plans/skill-help-dazzling-wombat.md)

### v1.1 改动范围（Tier 2 取舍）

执行 Tier 2 = A-Mode-1 + C + D + E + F；**不做** Mode 2 anchor CRUD（改变契约）、Mode 3 自由文本兜底（与 insight-fuse scope 重叠）。

| 改动 | 落地 | 文件 |
|---|---|---|
| **A-Mode-1**：`/claim-ground verify <claim>` 显式接地路径 | 收 | `SKILL.md` § Manual Execution |
| **A-Mode-2**：anchor CRUD | **拒**（改变现有契约：anchors 由 skill 写入，不是用户 CRUD） | — |
| **A-Mode-3**：未识别 token 兜底进 verify | **拒**（与 insight-fuse 边界重叠；改为输出明确错误并引导） | — |
| **B**：定义性提问预防 hook | **延后**（Tier 1/2 价值已大；regex 收敛策略待先实测） | — |
| **C**：Red Line 7 术语凭印象 | 收 | `SKILL.md` §红线 + `references/red-lines.md` §红线 7 |
| **D**：Rule 7 扫描词族扩展（定义性动词 + 权威断言） | 收 | `SKILL.md` §核心规则 7 |
| **E**：Playbook 新增标准体术语行 | 收 | `SKILL.md` §查证 Playbook + `references/playbook.md` §9.5 |
| **F**：hook 自调用 guard | 收 | `hooks/epistemic-pushback-trigger.sh`（读 stdin JSON `.prompt`，前缀 `/claim-ground` 则静默退出）|

### 设计决策

#### (a) 为什么 Mode 1 verify 但不 Mode 3 兜底

`/claim-ground` 的边界是 "**runtime-context-first reasoning** for current/live state and definitional assertions"。Mode 1 verify 的输入是**具体可接地的断言**——单点接地，不做综合。Mode 3 兜底（任意自由文本进 verify）会扩成"verify anything"——和 insight-fuse 的"systematic multi-source research"重叠。两个 skill 角色清晰是 forge 设计原则，scope creep 比 UX 摩擦更危险。未识别 token 输出明确错误 + 推荐 `/insight-fuse`，把边界守住。

#### (b) 为什么 Mode 2 anchor CRUD 被拒

[references/anchors.md](../../skills/claim-ground/references/anchors.md) 当前契约：anchors 由 skill 在成功 verify runtime 证据后**自行写入**。这是"skill-managed cache"模型，不是"user-facing CRUD"。把 CRUD 暴露给用户会改变 anchors 的语义性质——从"已验证缓存"变成"用户主张库"。后者很危险（用户写错了 anchor 会污染未来 session）。延后到 P2，等出现真实需求再考虑。

#### (c) 为什么 R7 单独立条而不是 R1 子项

R1 的反例几乎全是 live-state（模型版本、CLI 版本、env）。模型读 R1 时容易给"术语定义"打"训练里就有，应该 OK"的豁免。R7 把"专业术语 + 标准体存在"这一组合显式列为独立红线，并配 6 大领域映射表 + 反例。识别成本降到看 SKILL.md 一眼。

#### (d) 为什么 hook 用 stdin JSON 而不是 env var

Plan 原文假定 `$CLAUDE_USER_PROMPT` env var——实测 forge 仓里所有现有 hook（block-break frustration-trigger / claim-ground evidence-reminder / session-anchor）都不用 env var。Claude Code 的 UserPromptSubmit hook 通过 stdin 传 JSON `{"prompt": "...", ...}`。F 的实现读 stdin → jq/python 解析 `.prompt` → 前缀匹配 → 静默退出，与现有 hook 工具链一致。

测试覆盖（场景 33-34）：

- 自调用："/claim-ground verify 真的吗 你确定" → 静默退出，不 emit
- 真反驳："真的吗？你之前说 X" → 正常 emit `<CLAIM_GROUND_ACTIVATED>`
- 空 stdin → 兜底 emit（保留旧行为，不破坏）

### 不做的事（v1.1 边界）

- 不引入 R8（红线编号到 R7 已满，再扩张影响认知容量）
- 不动 SessionStart anchors / PostToolUse evidence-reminder hook（两者职责清晰）
- 不动 block-break 任何配置
- 不引入 user-facing anchor CRUD（见 (b)）
- 不引入 Mode 3 自由文本兜底（见 (a)）
- 不实现 definition-detector pre-emptive hook（B 延后；先看 v1.1 文档强化的实际效果）

### 验证

- skill-lint：0 error / 0 warning / 497 passed（C24 cross-skill-category + S19 hash + S23 i18n parity 均过）
- hook guard 单元测试（stdin 模拟，3 case）：自调用静默 / 真反驳 emit / 空 stdin emit
- evals/claim-ground/scenarios.md：新增场景 29-36（Mode 1 三种作用域 / 未识别 token / hook guard 双向测 / Rule 7 词族扫描两例）
- trigger-test 实跑（21 case × claude CLI）：因 forge 仓 4 个 trigger-test 脚本统一缺 `--verbose` flag（pre-existing CLI 版本兼容问题，非本次回归），claim-ground 脚本已在本次顺手补上 `--verbose`；其他 3 个脚本同样问题不在本次任务范围
- platforms/openclaw 镜像：SKILL.md + 2 references 三文件 diff 零差异；hook 不镜像（CLAUDE.md 约定）
- marketplace.json：版本 1.0.0 → 1.1.0；SHA-256 重算为 `b15c22f1...`

### 后续可考虑

- B（definition-detector hook，AND 两段式 regex）—— 若文档强化收敛性不够，再补一道 hook 闸
- Mode 2 anchor CRUD —— 仅当出现明确"团队共享 anchor"用例时再考虑
- 修复 forge 仓 3 个其他 trigger-test 脚本的 `--verbose` flag —— 系统性 housekeeping，独立 PR
