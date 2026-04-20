# skill-lint 设计文档

**日期**: 2026-03-31
**状态**: 已批准

## 定位

通用 Claude Code skill 校验工具。纯 skill（行为约束），手动触发（`/skill-lint [path]`）。
由 bash 脚本做结构检查 + AI 做语义检查，互补覆盖。

## 覆盖与边界

> skill-lint 是**Claude Code plugin 的结构 CI**——它保证"符合约定、hash 一致、文件齐全"，但不保证"skill 运行时真的能跑"，也不取代代码质量 / 安全 / 许可证评审。

完整分析（能解决 / 不能解决 / 不应使用）：[references/scope-boundaries.md](../../skills/skill-lint/references/scope-boundaries.md)

## 设计决策

| 决策点 | 选择 | 理由 |
|--------|------|------|
| 类型 | 纯 skill | 与项目现有模式一致 |
| 检查范围 | 通用 Claude Code plugin | 可被其他项目复用 |
| 触发方式 | 手动 `/skill-lint` | 保持简单，按需使用 |
| 架构 | bash 脚本 + AI 语义检查 | 机器检查可靠，AI 检查灵活 |

## 检查规则

### Bash 脚本检查（scripts/skill-lint.sh）

1. **Frontmatter 必填字段** — `name`、`description` 必须存在于 SKILL.md
2. **SKILL.md 存在性** — `skills/<name>/SKILL.md` 文件是否存在
3. **Commands 对应** — 每个 skill 是否有 `commands/<name>.md`
4. **marketplace.json 条目** — skill 是否在 `.claude-plugin/marketplace.json` 的 `plugins` 数组中
5. **plugin.json 存在性** — 根目录和 `.claude-plugin/` 下的 plugin.json 是否存在
6. **References 引用检查** — SKILL.md 中引用的 references 文件是否实际存在
7. **Evals 目录** — `evals/<name>/scenarios.md` 是否存在

脚本接受参数：`skill-lint.sh [path]`，默认当前目录。输出 JSON：`{errors: [], warnings: [], passed: []}`

### AI 语义检查（SKILL.md 行为约束）

1. **Description 质量** — 是否清晰描述了 skill 的用途和触发条件
2. **Frontmatter 一致性** — name 与目录名是否一致、description 在 SKILL.md 和 marketplace.json 间是否对齐
3. **Command 路由逻辑** — commands/*.md 是否正确加载对应 skill
4. **References 内容连贯性** — SKILL.md 引用的 references 内容是否与主文件逻辑一致
5. **Eval 场景覆盖度** — scenarios.md 是否覆盖了 skill 的核心功能路径

## 文件清单

```
skills/skill-lint/SKILL.md              # 核心 skill 定义
skills/skill-lint/references/rules.md   # 完整规则详细说明
skills/skill-lint/scripts/skill-lint.sh # bash 结构检查脚本
commands/skill-lint.md                  # /skill-lint 入口
evals/skill-lint/scenarios.md           # 评估场景
evals/skill-lint/run-trigger-test.sh    # 触发测试
```

## 输出格式

```
Skill Lint 完成
┌──────────┬───────────────────────────────┐
│ 目标路径 │ /path/to/plugin               │
├──────────┼───────────────────────────────┤
│ 结构检查 │ ✓ 5 passed · ✗ 2 errors      │
├──────────┼───────────────────────────────┤
│ 语义检查 │ ✓ 3 passed · ⚠ 1 warning     │
└──────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description 与 marketplace.json 不一致
```

## 工作流

1. 用户调用 `/skill-lint [path]`
2. 运行 `scripts/skill-lint.sh [path]` 获取结构检查结果
3. AI 读取目标路径下所有 skill 文件，执行语义检查
4. 合并输出，按 error > warning > passed 排列
