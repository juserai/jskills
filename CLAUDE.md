# Forge 开发指南

多平台 AI agent skill 集合。每个 skill 独立自包含，通过 SKILL.md 注入 AI 上下文，
各平台各自持有完整文件，零运行时依赖。

## 仓库布局

```text
skills/<skill>/                                  # Claude Code 规范版
├── SKILL.md                                     # 平台 skill 定义
├── references/*.md                              # 按需加载的详细内容
├── scripts/*.sh                                 # 辅助脚本（按需）
├── agents/*.md                                  # Sub-agent 定义（按需）
└── hooks/                                       # 仅 hook owner skill 才有

platforms/<platform>/<skill>/                    # 其他平台适配（同构）
evals/<skill>/                                   # 跨平台 eval 场景 + 触发测试
docs/user-guide/<skill>-guide.md                 # 英文用户手册
docs/i18n/<lang>/<file>                          # 多语言（README + skill guide；当前仅 zh-CN）
docs/i18n-archived/<lang>/<file>                 # 归档语言（10 种），恢复需走专项 RFC
docs/design/<category>/<skill>-design.md         # 按 4 分类组织的设计文档
docs/design/cross/<topic>-design.md              # 横向设计文档
docs/dev-guide/                                  # 跨切面开发文档（如安全指南）

openspec/                                        # 演化元仓库
├── config.yaml                                  # 项目级 context + artifact 规则
├── specs/<capability>/spec.md                   # 横向能力契约（见下表）
└── changes/<id>/                                # 在飞 RFC（archive/<id>/ 存档）

.claude-plugin/marketplace.json                  # Claude Code Marketplace 入口
.claude-plugin/plugin.json                       # Claude Code 发布元数据
plugin.json                                      # 根级集合元数据
.skill-lint.json                                 # skill-lint 规则配置
scripts/recalc-all-hashes.sh                     # 重算 marketplace.json SHA-256
~/.forge/<skill>-state.json                      # 运行时状态（gitignored）
```

## 横向能力契约（开发前必读）

所有横向规则都在 `openspec/specs/` 下，本文件只是导航。改任何一处之前，
先读对应 spec：

| 主题 | 契约文件 | 何时读 |
|------|---------|-------|
| **Skill 生命周期** | [skill-lifecycle/spec.md](openspec/specs/skill-lifecycle/spec.md) | **改任何 skill 必读**——含场景 A/B/C/D 审计清单 |
| 4 分类决策 | [category-decision/spec.md](openspec/specs/category-decision/spec.md) | 新增 skill / 调整分类时（含三元组判据） |
| Help 模式 | [help-mode/spec.md](openspec/specs/help-mode/spec.md) | 修改 SKILL.md 的 Help 段时 |
| 运行时状态 | [runtime-state/spec.md](openspec/specs/runtime-state/spec.md) | skill 需要持久化状态时 |
| 仓库不变量 | [repo-invariants/spec.md](openspec/specs/repo-invariants/spec.md) | 引入新依赖 / hook owner / SKILL.md hash 锁步 |
| i18n 布局 | [i18n-layout/spec.md](openspec/specs/i18n-layout/spec.md) | 改任何翻译文件 / 加新语言 |
| 平台广播 | [platform-parity/spec.md](openspec/specs/platform-parity/spec.md) | 加 skill / 加 platform 时 |

## 4 分类速览

| 分类 | 隐喻 | OUTPUT 形态 |
|------|------|------------|
| `hammer`   | 锤——施力塑形 | 行为指令 |
| `crucible` | 坩埚——熔炼提纯 | 融合产出 |
| `anvil`    | 砧——承托定型 | pass/fail 判定 |
| `quench`   | 淬火——冷却定性 | 辅助信息 |

判据见 [category-decision/spec.md](openspec/specs/category-decision/spec.md)。

## 自检三命令

任何 skill 改动结束 MUST 跑：

```bash
bash skills/skill-lint/scripts/skill-lint.sh .                       # 4 条防线 + 27 条规则(含 S29/S30/S31 版本治理)
grep -rn "<skill-name>" . --include="*.md" --include="*.json"        # 漏网扫描
bash scripts/recalc-all-hashes.sh                                    # 重算 marketplace.json hash
```

任何一项不通过 = 变更未完成。详见 [skill-lifecycle/spec.md § 自检关键动作](openspec/specs/skill-lifecycle/spec.md)。

**版本治理提示**(2026-05-07 起):skill 版本号 SSOT 在 `.claude-plugin/marketplace.json plugins[].version`(**不**在 SKILL.md frontmatter——Claude Code schema 拒绝该字段)。skill-lint S29 自动作为 frontmatter regression guard 扫描 `version:` 字段;S30 校验 help-card 第一行 `v<X.Y.Z>` 字面量;S31 校验 [/CHANGELOG.md](CHANGELOG.md) top entry。详见 [repo-invariants § Skill version SSOT](openspec/specs/repo-invariants/spec.md)。

## 用 OpenSpec 迭代

新增/修改横向契约：用 `openspec/changes/<id>/` 起 RFC（proposal + design +
tasks + 涉及的 spec.md），review 通过后归档到 `openspec/changes/archive/`。
artifact 格式约束在 `openspec/config.yaml`。

安全编码指南详见 [docs/dev-guide/security-guidelines.md](docs/dev-guide/security-guidelines.md)。
