# J Skills 开发指南

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
docs/guide/<skill>.md              # 使用手册
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
- `~/.juserch-skills/` — 运行时状态目录（失败计数、压力等级、会话恢复）

## 新增 Skill 流程

1. `skills/<name>/SKILL.md` — Claude Code 适配版，frontmatter 含 name/description/license
2. `skills/<name>/references/*.md` — 详细内容（方法论、规则等）
3. `skills/<name>/scripts/*.sh` — 辅助脚本（如有）
4. `skills/<name>/agents/*.md` — Sub-agent 定义（如有）
5. `platforms/openclaw/<name>/SKILL.md` — OpenClaw 适配版
6. `platforms/openclaw/<name>/references/` — 复制或适配 references
7. `evals/<name>/scenarios.md` — 至少 5 个评估场景
8. `evals/<name>/run-trigger-test.sh` — 可执行的触发测试脚本
9. `.claude-plugin/marketplace.json` — 在 `plugins` 数组追加条目
10. `README.md` — 在 Skills 章节追加介绍
11. 如需 Claude Code hooks，在根 `hooks/hooks.json` 中添加配置

## 新增平台流程

1. `platforms/<platform>/` — 创建平台目录
2. 为每个 skill 创建 `platforms/<platform>/<skill>/SKILL.md`（平台适配版）
3. 为每个 skill 复制或适配 references/scripts/agents
4. `README.md` — 在安装章节追加该平台说明

## 开发规范

- 根 `plugin.json` 变更时同步 `.claude-plugin/plugin.json`
- SKILL.md 保持精简，详细内容放 `references/` 按需加载，减少 token 消耗
- frontmatter 支持字段：name, description, license, argument-hint, user-invokable, metadata
- 每个 skill 保持零依赖，可独立使用
- skill 之间不应有硬依赖，可有可选组合关系
- Spawn sub-agent 时必须注入行为约束（使用同目录 agents/ 的定义）
- 各平台各自持有完整文件，修改通用内容时需同步各平台

## 状态持久化

运行时状态存储在 `~/.juserch-skills/`：
- `block-break-state.json` — 失败计数、压力等级、最后更新时间
- 由 `hooks/failure-detector.sh` 写入
- 由 `hooks/session-restore.sh` 读取
- PreCompact hook 通过 prompt 指示 agent 保存上下文状态
- 状态在 2 小时内有效，超过则不恢复

## 测试

- 场景测试：`evals/<skill>/scenarios.md`
- 自动化触发测试：`bash evals/<skill>/run-trigger-test.sh`
