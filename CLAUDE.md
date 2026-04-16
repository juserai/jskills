# Forge 开发指南

## 项目概述

多平台 AI agent skill 集合项目。每个 skill 是独立的自包含单元，通过 SKILL.md 注入 AI 上下文。各平台各自持有完整文件，互不依赖。

## 目录约定

```text
skills/<skill>/                    # Claude Code 平台
├── SKILL.md                       # Claude Code 适配版
├── references/*.md                # 按需加载的详细内容
├── scripts/*.sh                   # 辅助脚本（按需）
└── agents/*.md                    # Sub-agent 定义（按需）

platforms/<platform>/<skill>/      # 其他平台适配
├── SKILL.md                       # 该平台适配版
├── references/*.md                # 该平台的详细内容
├── scripts/*.sh                   # 该平台的辅助脚本
└── agents/*.md                    # 该平台的 Sub-agent 定义

evals/<skill>/scenarios.md         # 评估场景（跨平台）
evals/<skill>/run-trigger-test.sh  # 自动化触发测试
docs/guide/<skill>-guide.md        # 使用手册
docs/i18n/guide/<skill>-guide.<lang>.md  # 使用手册多语言版
docs/plans/<topic>-design.md       # 设计文档
```

## 文件职责

- `plugin.json`（根）— 集合级元数据
- `.claude-plugin/plugin.json` — Claude Code 发布用元数据（与根级保持一致）
- `.claude-plugin/marketplace.json` — Claude Code Marketplace 入口，`skills` 数组指向 `./skills/<name>`
- `skills/<name>/SKILL.md` — Claude Code 平台的 skill 定义
- `skills/<name>/references/` — Claude Code 平台的详细内容
- `platforms/<platform>/<name>/SKILL.md` — 非 Claude Code 平台的 skill 定义
- `platforms/<platform>/<name>/references/` — 该平台的详细内容
- `hooks/` — Claude Code 平台专有的 hook 配置和脚本
- `~/.forge/` — 运行时状态目录（失败计数、压力等级、会话恢复）

## 新增 Skill 流程

1. `skills/<name>/SKILL.md` — Claude Code 适配版，frontmatter 含 name/description/license/metadata.category
2. `skills/<name>/references/*.md` — 详细内容（方法论、规则等）
3. `skills/<name>/scripts/*.sh` — 辅助脚本（如有）
4. `skills/<name>/agents/*.md` — Sub-agent 定义（如有）
5. `platforms/openclaw/<name>/SKILL.md` — OpenClaw 适配版
6. `platforms/openclaw/<name>/references/` — 复制或适配 references
7. `evals/<name>/scenarios.md` — 至少 5 个评估场景
8. `evals/<name>/run-trigger-test.sh` — 可执行的触发测试脚本
9. `docs/guide/<name>-guide.md` — 使用手册
10. `docs/i18n/guide/<name>-guide.<lang>.md` — 使用手册多语言版，为每个 `docs/i18n/README.*.md` 对应的语言创建
11. `docs/plans/<name>-design.md` — 设计文档
12. `.claude-plugin/marketplace.json` — 在 `plugins` 数组追加条目
13. `README.md` — 在对应分类章节追加介绍，同步所有 `docs/i18n/README.*.md`
14. 如需 Claude Code hooks，在根 `hooks/hooks.json` 中添加配置
15. 运行 `/skill-lint .` 验证所有检查通过（`.skill-lint.json` 已配置扩展规则）

## 新增平台流程

1. `platforms/<platform>/` — 创建平台目录
2. 为每个 skill 创建 `platforms/<platform>/<skill>/SKILL.md`（平台适配版）
3. 为每个 skill 复制或适配 references/scripts/agents
4. `README.md` — 在安装章节追加该平台说明

## 命名规范

- Skill 目录名和 frontmatter `name` 必须使用 `noun-verb` 格式，kebab-case
- 正确示例：`block-break`、`council-fuse`、`news-fetch`、`tome-forge`
- 错误示例：`breaking-blocks`（verb-noun）、`lint`（单词）、`my_skill`（下划线）
- 命名应体现 skill 的核心隐喻：名词是对象，动词是动作

## 分类约定

每个 skill 必须归入一个 Forge 分类，通过 frontmatter `metadata.category` 字段声明（`category` 非 Claude Code 原生字段，须放在 `metadata:` 下）：

| 分类 | 锻造隐喻 | 定位 | 判断标准 |
|------|---------|------|---------|
| `hammer` | 锤 — 施力塑形 | 主动施压、驱动执行 | skill 的核心是推动 agent 执行、施加约束或驱动循环 |
| `crucible` | 坩埚 — 熔炼提纯 | 多源融合、知识沉淀 | skill 的核心是融合多个来源/视角，产出比输入更精炼的结果 |
| `anvil` | 砧 — 承托定型 | 验证、校验、质量保证 | skill 的核心是检验成品质量，输出通过/不通过判定 |
| `quench` | 淬火 — 冷却定性 | 休息、信息补给 | skill 不直接参与开发，提供辅助信息或调节节奏 |

分类变更时需同步更新所有 README.md 的 Skills 章节。

## 开发规范

- 根 `plugin.json` 变更时同步 `.claude-plugin/plugin.json`
- SKILL.md 保持精简，详细内容放 `references/` 按需加载，减少 token 消耗
- frontmatter 支持字段：name, description, license, argument-hint, user-invokable, metadata（含 category、permissions）
- 每个 skill 保持零依赖，可独立使用
- skill 之间不应有硬依赖，可有可选组合关系
- Spawn sub-agent 时必须注入行为约束（使用同目录 agents/ 的定义）
- 各平台各自持有完整文件，修改通用内容时需同步各平台
- 每个 skill 必须在 frontmatter `metadata.permissions` 中声明最小权限集（network/filesystem/execution/tools）
- `.claude-plugin/marketplace.json` 中每个 skill 条目须包含 `integrity.skill-md-sha256` 字段，值为对应 SKILL.md 的 SHA-256 hash
- 修改 SKILL.md 后须重新计算 hash 并更新 marketplace.json
- 安全编码指南详见 `docs/guide/security-guidelines.md`

## 状态持久化

运行时状态存储在 `~/.forge/`：
- `block-break-state.json` — 失败计数、压力等级、最后更新时间
- 由 `hooks/failure-detector.sh` 写入
- 由 `hooks/session-restore.sh` 读取
- PreCompact hook 通过 prompt 指示 agent 保存上下文状态
- 状态在 2 小时内有效，超过则不恢复

## 测试

- 场景测试：`evals/<skill>/scenarios.md`
- 自动化触发测试：`bash evals/<skill>/run-trigger-test.sh`
