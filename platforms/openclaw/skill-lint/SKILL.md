---
name: skill-lint
description: "Skill Lint — Validate Claude Code skill plugins. Structural + semantic checks for any plugin project."
license: MIT
metadata:
  category: anvil
  permissions:
    network: false
    filesystem: read-only
    execution: sandboxed
    tools: [Read, Bash, Glob, Grep]
---

# Skill Lint — AI Agent Skill 校验工具

校验 AI agent plugin 项目中 skill 文件的结构完整性和语义质量。

## 工作流

1. 确定目标路径（用户参数或当前目录）
2. 运行结构检查脚本（如可用）；无脚本环境下按下方清单逐项人工检查
3. 读取目标路径下所有 skill 文件，执行 AI 语义检查
4. 合并输出，按 error > warning > passed 排列

## 结构检查

优先运行 `scripts/skill-lint.sh` 自动检查。如果平台不支持脚本执行，则按以下清单逐项人工检查（AI 辅助判断）：

1. **plugin.json 存在性** — 根目录的 plugin.json 是否存在
2. **Marketplace 元数据存在性** — marketplace 入口文件是否存在
3. **SKILL.md 存在性** — `skills/<name>/SKILL.md` 是否存在
4. **Frontmatter 必填字段** — 每个 SKILL.md 必须有 `name` 和 `description`
5. **Marketplace 条目** — 每个 skill 是否在 marketplace 元数据中注册
6. **References 引用检查** — SKILL.md 中引用的 `references/` 文件是否实际存在
7. **Evals 目录** — `evals/<name>/scenarios.md` 是否存在

输出 JSON：`{"errors": [...], "warnings": [...], "passed": [...]}`

解析结果，errors 非空则标记结构检查失败。

## 语义检查（AI 执行）

在结构检查完成后，读取各 skill 文件并检查：

1. **Description 质量** — 是否清晰描述 skill 用途和触发条件，不能只有名字重复
2. **Frontmatter 一致性**：
   - `name` 与目录名是否一致（`skills/foo/SKILL.md` 的 name 应为 `foo`）
   - `description` 在 SKILL.md 和 marketplace 元数据间是否语义对齐
3. **References 内容连贯性** — SKILL.md 引用的 references 内容是否与主文件逻辑一致、无孤立文件
4. **Eval 场景覆盖度** — `scenarios.md` 是否覆盖 skill 的核心功能路径（至少 5 个场景）

语义检查发现问题标记为 warning（非阻断性），因为涉及判断。

## 输出格式

```text
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
  2. marketplace metadata: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description 与 marketplace 元数据不一致
```

## 规则详情

完整规则说明见 `references/rules.md`。
