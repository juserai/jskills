# Forge 开发指南

## 项目概述

多平台 AI agent skill 集合。每个 skill 是独立自包含单元，通过 SKILL.md 注入 AI 上下文。各平台各自持有完整文件，互不依赖，零运行时依赖。

## 仓库布局

```text
skills/<skill>/                    # Claude Code 平台
├── SKILL.md                       # 平台适配版
├── references/*.md                # 按需加载的详细内容
├── scripts/*.sh                   # 辅助脚本（按需）
└── agents/*.md                    # Sub-agent 定义（按需）

platforms/<platform>/<skill>/      # 其他平台适配（同构）
evals/<skill>/                     # 评估场景 + 触发测试（跨平台共享）
docs/guide/<skill>-guide.md        # 使用手册（英文）
docs/i18n/guide/<skill>-guide.<lang>.md  # 使用手册多语言版（11 语言）
docs/plans/<topic>-design.md       # 设计文档
hooks/                             # Claude Code 平台的 hook 配置和脚本
.claude-plugin/marketplace.json    # Claude Code Marketplace 入口
.claude-plugin/plugin.json         # Claude Code 发布元数据
plugin.json                        # 根级集合元数据
```

### 关键路径的职责

| 路径 | 角色 |
|------|------|
| `plugin.json` + `.claude-plugin/plugin.json` | 集合级元数据，两处必须一致 |
| `.claude-plugin/marketplace.json` | Marketplace 条目，含每个 skill 的 `integrity.skill-md-sha256` |
| `skills/<name>/SKILL.md` | Claude Code 平台的 skill 定义（规范版） |
| `platforms/<platform>/<name>/SKILL.md` | 其他平台的适配版，内容允许精简但语义须一致 |
| `hooks/` | Claude Code 专有的 UserPromptSubmit / PostToolUse / SessionStart / PreCompact 配置 |
| `~/.forge/` | 运行时状态根目录（见下方 "运行时约定"） |

## 命名与分类

### 命名规范

- Skill 目录名与 frontmatter `name` 必须使用 `noun-verb` 格式，kebab-case
- ✅ `block-break`、`council-fuse`、`news-fetch`、`tome-forge`
- ❌ `breaking-blocks`（verb-noun）、`lint`（单词）、`my_skill`（下划线）
- 命名应体现 skill 的核心隐喻：**名词是对象，动词是动作**

### 分类定义

每个 skill 必须归入一个 Forge 分类，通过 frontmatter `metadata.category` 声明（`category` 非 Claude Code 原生字段，须放在 `metadata:` 下）：

| 分类 | 锻造隐喻 | 定位 | 判断标准 | OUTPUT 形态 |
|------|---------|------|---------|-------------|
| `hammer` | 锤 — 施力塑形 | 主动施压、驱动执行 | 核心是推动 agent 执行、施加约束或驱动循环 | **行为指令**（"必须/不许做 X"） |
| `crucible` | 坩埚 — 熔炼提纯 | 多源融合、知识沉淀 | 核心是融合多个来源/视角 | **融合产出**（比输入更精炼） |
| `anvil` | 砧 — 承托定型 | 验证、校验、质量保证 | 核心是检验**具体成品**，输出**通过/不通过判定** | 对工件的 **pass/fail 判定** |
| `quench` | 淬火 — 冷却定性 | 休息、信息补给 | 不直接参与开发，提供辅助信息或调节节奏 | **辅助信息**或节奏调节 |

### 分类决策规程

定位描述宽松、容易套用，以 **OUTPUT 形态** 为锋利判据。新增 skill 时，在 `docs/plans/<name>-design.md` 的"设计决策"表格里，`分类` 行必须同时写明：

- **（a）选了什么**
- **（b）为什么不是其他三类**（逐类排除，不是泛泛"感觉不像"）
- **（c）现有同类 skill 中的兄弟是谁**（family resemblance 检查）

找不到兄弟 → 要么分类错了，要么真的开新支线；后者需在 README 对应分类章节专门说明。

**反例**（claim-ground 早期误分到 anvil 的教训）：

- "验证事实证据" 听起来像 anvil 的"验证"
- 但 anvil 的成品是**被校验的工件**（skill-lint 校验 skill 文件，输出 error/warning/passed）
- claim-ground 没有工件，输出的是**行为指令**（"必须引用 runtime 证据"）
- 兄弟对比：claim-ground 与 block-break 都是 auto-trigger + hook + 行为约束 → 同属 hammer

## Skill 生命周期

所有生命周期操作都以 [变更审计](#变更审计) 的清单为准——本节给出入口和要点，详细清单在下面一节。

### 新增 skill

1. 先想清楚**分类**和**命名**（噁前两节）
2. 写 `docs/plans/<name>-design.md`——含分类决策三元组（a/b/c）
3. 按 [变更审计 § 场景 A](#场景-a--新增-skill) 清单逐项创建产物
4. 运行自检三命令（见下）

### 修改 skill（描述 / frontmatter / 内容）

按 [变更审计 § 场景 B](#场景-b--修改-skill) 处理镜像同步。任何改动 `skills/<name>/SKILL.md` 必须重算 SHA-256 并更新 marketplace.json。

### 调整分类

按 [变更审计 § 场景 C](#场景-c--调整分类)。涉及 24 处同步点（2 份 SKILL.md + marketplace hash + 12 份 README + 设计文档）。

### 删除 skill

1. 删除 `skills/<name>/`、`platforms/*/（<name>`、`evals/<name>/`、`docs/guide/<name>-guide.md`、`docs/i18n/guide/<name>-guide.*.md`、`docs/plans/<name>-design.md`
2. 从 `.claude-plugin/marketplace.json` 的 `plugins` 数组移除条目
3. 从 `README.md` + 11 份 `docs/i18n/README.*.md` 移除：Skills 表格行、详情段落、skills badge 计数 -1、首段 "N skills" 计数 -1
4. 若该 skill 有专属 hook，从 `hooks/hooks.json` 移除对应 matcher，删除 `hooks/<xxx>-trigger.sh`
5. 全文 `grep -rn "<name>"` 确认零残留引用
6. 运行 skill-lint 验证

### 重命名 skill

等价于"删除旧名 + 新增新名"。特别注意：

- `git mv` 而非 `rm + add`，保留提交历史
- hook 的 matcher / 脚本名都要更新
- marketplace.json 的 skill-md-sha256 必须重算（路径变了 SHA 不变，但 `skills` 数组里的路径必须同步）

### 新增平台

1. 创建 `platforms/<new-platform>/` 目录
2. 为每个现有 skill 创建 `platforms/<new-platform>/<skill>/`：SKILL.md（平台适配版）+ references/scripts/agents 的复制或适配
3. 在 `README.md` 的安装章节追加该平台说明

## 变更审计

**任何改动 skill 都要先做全文 grep 扫描**，对每一处出现核对一致性。之前多次漏网的场景（claim-ground 分类错位、README 详情段落顺序、i18n skills badge 停留在旧计数），全部来自"只改显性部分、没扫对称结构"。

### 扫描命令

```bash
grep -rn "<skill-name>" . --include="*.md" --include="*.json" --include="*.sh" \
  --exclude-dir=node_modules --exclude-dir=.git
```

### 场景 A — 新增 skill

扫描 `<new-skill>` 的每处出现必须存在且一致：

- [ ] `skills/<name>/SKILL.md`（frontmatter: name / description / license / metadata.category / metadata.permissions）
- [ ] `skills/<name>/references/*.md`（若 SKILL.md 引用了）
- [ ] `platforms/<platform>/<name>/` 与 references 镜像
- [ ] `evals/<name>/scenarios.md`（≥ 5 场景）+ `run-trigger-test.sh`（可执行）
- [ ] `docs/guide/<name>-guide.md`
- [ ] `docs/i18n/guide/<name>-guide.<lang>.md` **× 11 语言**
- [ ] `docs/plans/<name>-design.md`（含分类决策三元组）
- [ ] `.claude-plugin/marketplace.json`（新增 plugin 条目 + `integrity.skill-md-sha256`）
- [ ] `README.md`：Skills 表格（对应分类章节）+ 详情段落（位置按 Hammer→Crucible→Anvil→Quench）
- [ ] `docs/i18n/README.*.md` **× 11**：同上 + skills badge（`skills-N-blue.svg`）+ 首段 "N skills" 计数全部 +1
- [ ] `hooks/` 与 `hooks/hooks.json`（若该 skill 需要 hook）

### 场景 B — 修改 skill

- [ ] 若 `skills/<name>/SKILL.md` 被改动：重算 SHA-256 并更新 marketplace.json 的 integrity hash
- [ ] 若 description 被改：同步 `marketplace.json.plugins[].description` + `platforms/<platform>/<name>/SKILL.md` + `docs/guide/<name>-guide.md` 首段 + 11 份 i18n guide 首段
- [ ] 若 metadata.permissions 变动：同步平台适配版
- [ ] 若 references 结构变动：检查 SKILL.md 内的引用、检查 platforms 镜像

### 场景 C — 调整分类

- [ ] `skills/<name>/SKILL.md` 与 `platforms/<platform>/<name>/SKILL.md` frontmatter 的 `metadata.category` 两处同步
- [ ] marketplace.json 重算 integrity hash
- [ ] `docs/plans/<name>-design.md` 更新分类决策行（加修订日期 + 新理由）
- [ ] `README.md` Skills 表格：把行从旧章节移到新章节；详情段落按新分类调整顺序（Hammer→Crucible→Anvil→Quench）
- [ ] `docs/i18n/README.*.md` **× 11**：两处同步（表格 + 详情段落位置）
- [ ] `docs/guide/<name>-guide.md` 的"Interaction with other forge skills"段 — 全部跨 skill 分类声明（如 "Same category"、"sibling of X"）
- [ ] `docs/i18n/guide/<name>-guide.*.md` **× 11** — 同上，每份 i18n guide 都要核对跨 skill 分类声明
- [ ] 全文 grep 该 skill 名，确认没有遗留的旧分类描述（如 "anvil sibling of skill-lint"）
- [ ] 额外跑一轮多语言关键词扫描（见下方"自检关键动作"）

### 场景 D — 删除或重命名

- [ ] 按 [Skill 生命周期 § 删除/重命名](#删除-skill) 的步骤
- [ ] 全文 grep 旧名，**零残留**才算完成
- [ ] 重命名还要 grep 新名，确认所有引用都已创建
- [ ] skills badge + "N skills" 首段计数正确（删除 -1，重命名不变）

### 自检关键动作

改完以后必须执行一次：

```bash
bash skills/skill-lint/scripts/skill-lint.sh .                       # 结构检查（含 hash/platform-parity/i18n-structure/cross-skill-category 4 条防线）
grep -rn "<skill-name>" . --include="*.md" --include="*.json"        # 漏网扫描
grep -rn "skills-[0-9]*-blue" README.md docs/i18n/README.*.md        # badge 一致性

# 多语言跨 skill 分类声明扫描（场景 C 必跑，防止 i18n guide 残留旧分类）
grep -rnE "(Same category|同一分类|同カテゴリ|동일 카테고리|समान श्रेणी|Misma categoría|Même catégorie|Gleiche Kategorie|Mesma categoria|Та же категория|Aynı kategori|Cùng phân loại)" docs/
```

任何一项发现不一致，视为变更未完成。skill-lint 的 4 条新增防线（hash-integrity / platform-parity / i18n-structure-parity / cross-skill-category-claim）是自动化主防线，CI 环境应当把它们作为 blocker。

## 开发规范

### 架构原则

- 每个 skill 保持**零依赖**，可独立使用
- skill 之间不应有**硬依赖**，可有可选的组合关系
- 各平台各自持有完整文件，修改通用内容时需同步各平台
- Spawn sub-agent 时必须注入行为约束（使用同目录 `agents/` 的定义）

### 文件同步与一致性

- 根 `plugin.json` 变更时同步 `.claude-plugin/plugin.json`
- SKILL.md 保持精简，详细内容放 `references/` 按需加载，减少 token 消耗
- SKILL.md frontmatter 支持字段：`name` / `description` / `license` / `argument-hint` / `user-invokable` / `metadata`（含 `category`、`permissions`）
- marketplace.json 中每个 skill 条目须包含 `integrity.skill-md-sha256`，值为对应 SKILL.md 的 SHA-256 hash
- **修改 SKILL.md 后须重新计算 hash 并更新 marketplace.json**

### 测试

- 场景测试：`evals/<skill>/scenarios.md`（≥ 5 个场景）
- 自动化触发测试：`bash evals/<skill>/run-trigger-test.sh`

### 安全与权限

- 每个 skill 必须在 frontmatter `metadata.permissions` 中声明最小权限集（`network` / `filesystem` / `execution` / `tools`）
- 安全编码指南详见 [docs/guide/security-guidelines.md](docs/guide/security-guidelines.md)

## 运行时约定

运行时状态统一放 `~/.forge/`：

- 每个需要状态的 skill 自行管理其状态文件（如 `block-break-state.json`）
- 跨 skill 不共享状态，避免隐式耦合
- 各状态文件的 schema 和生命周期由对应 skill 的 `references/` 文档说明
- hooks 目录下的 `failure-detector.sh` / `session-restore.sh` 是项目级的 hook 脚本（Claude Code 平台专有）
