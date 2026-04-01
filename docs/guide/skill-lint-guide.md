# Skill Lint 使用手册

> 3 分钟上手，校验你的 Claude Code Skill 质量

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserch/jskills
```

### 通用单行安装

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **零依赖** — Skill Lint 不依赖任何外部服务或 API。安装即用。

---

## 命令一览

| 命令 | 功能 | 场景 |
|------|------|------|
| `/skill-lint` | 显示说明 | 查看校验项 |
| `/skill-lint .` | 校验当前项目 | 开发中自检 |
| `/skill-lint /path/to/plugin` | 校验指定路径 | 校验其他 plugin |

---

## 使用场景

### 新增 Skill 后自检

创建完 `skills/<name>/SKILL.md`、`commands/<name>.md` 等文件后，运行 `/skill-lint .` 确认结构完整、frontmatter 正确、marketplace 条目已添加。

### 审查他人的 Plugin

收到 PR 或评审他人 plugin 时，用 `/skill-lint /path/to/plugin` 快速检查文件完整性和一致性。

### CI 集成

`scripts/skill-lint.sh` 可直接在 CI 管道中运行，输出 JSON 格式便于自动化解析：

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## 检查项

### 结构检查（Bash 脚本执行）

| 规则 | 检查内容 | 级别 |
|------|---------|------|
| S01 | `plugin.json` 根目录和 `.claude-plugin/` 下均存在 | error |
| S02 | `.claude-plugin/marketplace.json` 存在 | error |
| S03 | 每个 `skills/<name>/` 包含 `SKILL.md` | error |
| S04 | SKILL.md frontmatter 含 `name` 和 `description` | error |
| S05 | 每个 skill 有对应 `commands/<name>.md` | warning |
| S06 | 每个 skill 在 marketplace.json `plugins` 数组中 | warning |
| S07 | SKILL.md 中引用的 references 文件实际存在 | error |
| S08 | `evals/<name>/scenarios.md` 存在 | warning |

### 语义检查（AI 执行）

| 规则 | 检查内容 | 级别 |
|------|---------|------|
| M01 | description 清晰描述用途和触发条件 | warning |
| M02 | name 与目录名一致，description 跨文件对齐 | warning |
| M03 | command 路由逻辑正确引用 skill 名称 | warning |
| M04 | references 内容与 SKILL.md 逻辑一致 | warning |
| M05 | eval 场景覆盖核心功能路径（至少 5 个） | warning |

---

## 预期输出示例

### 全部通过

```
Skill Lint 完成
┌──────────┬───────────────────────────────┐
│ 目标路径 │ /path/to/plugin               │
├──────────┼───────────────────────────────┤
│ 结构检查 │ ✓ 19 passed · ✗ 0 errors     │
├──────────┼───────────────────────────────┤
│ 语义检查 │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────┴───────────────────────────────┘
```

### 有问题

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

---

## 工作流

```
/skill-lint [path]
      │
      ▼
  运行 skill-lint.sh ──→ JSON 结构检查结果
      │
      ▼
  AI 读取 skill 文件 ──→ 语义检查
      │
      ▼
  合并输出（error > warning > passed）
```

---

## FAQ

### 能只跑结构检查不跑语义检查吗？

直接执行 bash 脚本即可：

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

输出纯 JSON，无 AI 语义检查。

### 支持校验非 jskills 项目吗？

支持。只要目标目录遵循 Claude Code plugin 的标准结构（`skills/`、`commands/`、`.claude-plugin/`），都可以校验。

### error 和 warning 的区别？

- **error**: 结构性问题，会导致 skill 无法正常加载或发布
- **warning**: 质量问题，不影响功能但影响可维护性和发现性

---

## License

[MIT](LICENSE) - [juserch](https://github.com/juserch)
