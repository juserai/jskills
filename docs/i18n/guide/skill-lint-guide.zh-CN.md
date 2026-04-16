# Skill Lint 用户指南

> 3 分钟上手 — 验证你的 Claude Code skill 质量

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserai/forge
```

### 通用一行安装

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **零依赖** — Skill Lint 不需要任何外部服务或 API。安装即用。

---

## 命令

| 命令 | 功能 | 使用场景 |
|------|------|---------|
| `/skill-lint` | 显示使用信息 | 查看可用检查项 |
| `/skill-lint .` | 检查当前项目 | 开发过程中自检 |
| `/skill-lint /path/to/plugin` | 检查指定路径 | 审查其他插件 |

---

## 使用场景

### 创建新 skill 后自检

创建 `skills/<name>/SKILL.md`、`commands/<name>.md` 及相关文件后，运行 `/skill-lint .` 以确认结构完整、frontmatter 正确、marketplace 条目已添加。

### 审查他人的插件

在审查 PR 或审计其他插件时，使用 `/skill-lint /path/to/plugin` 快速检查文件完整性和一致性。

### CI 集成

`scripts/skill-lint.sh` 可直接在 CI 流水线中运行，输出 JSON 供自动化解析：

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## 检查项

### 结构检查（由 Bash 脚本执行）

| 规则 | 检查内容 | 严重程度 |
|------|---------|---------|
| S01 | `plugin.json` 在根目录和 `.claude-plugin/` 中都存在 | error |
| S02 | `.claude-plugin/marketplace.json` 存在 | error |
| S03 | 每个 `skills/<name>/` 包含 `SKILL.md` | error |
| S04 | SKILL.md frontmatter 包含 `name` 和 `description` | error |
| S05 | 每个 skill 有对应的 `commands/<name>.md` | warning |
| S06 | 每个 skill 在 marketplace.json 的 `plugins` 数组中列出 | warning |
| S07 | SKILL.md 中引用的参考文件确实存在 | error |
| S08 | `evals/<name>/scenarios.md` 存在 | warning |

### 语义检查（由 AI 执行）

| 规则 | 检查内容 | 严重程度 |
|------|---------|---------|
| M01 | 描述清晰说明用途和触发条件 | warning |
| M02 | 名称与目录名匹配；描述在文件间保持一致 | warning |
| M03 | 命令路由逻辑正确引用 skill 名称 | warning |
| M04 | 参考内容与 SKILL.md 逻辑一致 | warning |
| M05 | 评估场景覆盖核心功能路径（至少 5 个） | warning |

---

## 预期输出示例

### 全部检查通过

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### 发现问题

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## 工作流程

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## 常见问题

### 可以只运行结构检查，不运行语义检查吗？

可以 — 直接运行 bash 脚本：

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

输出纯 JSON，不包含 AI 语义分析。

### 适用于非 forge 项目吗？

适用。任何遵循标准 Claude Code 插件结构（`skills/`、`commands/`、`.claude-plugin/`）的目录都可以被验证。

### 错误和警告有什么区别？

- **error**：会阻止 skill 正确加载或发布的结构性问题
- **warning**：不会破坏功能但影响可维护性和可发现性的质量问题

### 其他 forge 工具

Skill Lint 是 forge 合集的一部分，与以下 skill 配合使用效果良好：

- [Block Break](block-break-guide.md) — 高自主性行为约束引擎，强制 AI 穷尽所有方法
- [Ralph Boost](ralph-boost-guide.md) — 自主开发循环引擎，内置 Block Break 收敛保证

开发新 skill 后，运行 `/skill-lint .` 验证结构完整性，确认 frontmatter、marketplace.json 和参考链接全部正确。

---

## 许可证

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
