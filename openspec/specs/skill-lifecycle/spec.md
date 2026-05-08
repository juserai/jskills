# Capability: skill-lifecycle

## Purpose

定义 skill 在 forge 仓库中的"创建 / 修改 / 调整分类 / 删除·重命名"
四种生命周期场景下，必须同步变更的所有镜像产物清单。这条 spec 是
变更审计的 single source of truth——skill-lint 的 4 条防线
（hash-integrity / platform-parity / i18n-structure-parity /
cross-skill-category-claim）以本 spec 为权威定义。

## Behavior

### 通用前置：全文扫描命令（任何场景执行前 MUST 运行一次）

```bash
grep -rn "<skill-name>" . --include="*.md" --include="*.json" --include="*.sh" \
  --exclude-dir=node_modules --exclude-dir=.git
```

### 场景 A — 新增 skill

新增 `<new-skill>` 时，下列产物 MUST 全部存在并彼此一致：

- [ ] `skills/<name>/SKILL.md`（frontmatter: `name` / `description` /
      `license` / `metadata.category` / `metadata.permissions`）
- [ ] `skills/<name>/references/*.md`（若 SKILL.md 引用了）
- [ ] `platforms/<platform>/<name>/` 与 references 镜像（每个现有平台都要有）
- [ ] `evals/<name>/scenarios.md`（≥ 5 场景）+ `run-trigger-test.sh`（可执行）
- [ ] `docs/user-guide/<name>-guide.md`
- [ ] `docs/i18n/<lang>/<name>-guide.md` × 1 语言（zh-CN，2026-05-08 起；详见 `i18n-layout` spec § 当前支持语言）
- [ ] `docs/design/<category>/<name>-design.md`（含分类决策三元组，详见
      `category-decision` spec；`<category>` ∈ {hammer, crucible, anvil, quench, cross}）
- [ ] `.claude-plugin/marketplace.json`：新增 plugin 条目 + 正确的
      `integrity.skill-md-sha256`
- [ ] `README.md`：Skills 表格（对应分类章节）+ 详情段落
      （位置按 Hammer→Crucible→Anvil→Quench）
- [ ] `docs/i18n/<lang>/README.md` × 1（zh-CN）：同上 + skills badge（`skills-N-blue.svg`）
      + 首段 "N skills" 计数 +1
- [ ] `skills/<name>/hooks/` 与 `skills/<name>/hooks/hooks.json`（仅当该 skill
      需要 hook；marketplace.json 中对应 plugin 的 `source` 必须指向
      `./skills/<name>`）

### 场景 B — 修改 skill

- [ ] 若 `skills/<name>/SKILL.md` 被改动：MUST 重算 SHA-256 并更新
      `.claude-plugin/marketplace.json` 的 `integrity.skill-md-sha256`
- [ ] 若 `description` 被改：MUST 同步 `marketplace.json.plugins[].description`
      + `platforms/<platform>/<name>/SKILL.md`
      + `docs/user-guide/<name>-guide.md` 首段
      + 1 份 i18n guide 首段（zh-CN）
- [ ] 若 `metadata.permissions` 变动：MUST 同步平台适配版
- [ ] 若 references 结构变动：MUST 检查 SKILL.md 内的引用 + 检查 platforms 镜像
- [ ] **决策版本位**（MAJOR / MINOR / PATCH / 不 bump），并在 PR description
      简述理由
- [ ] 若 bump：MUST 同步 `.claude-plugin/marketplace.json` `plugins[].version`
      + `skills/<name>/SKILL.md` `## Help` 段 code block 第一行版本字面量
      + `/CHANGELOG.md` `## <name>` 段顶部插入新 `### [X.Y.Z]` 条目
- [ ] 若 bump 且 `platforms/<platform>/<name>/SKILL.md` 含 `## Help` 段：
      同步 platform mirror help-card 第一行版本字面量

#### Version bump 触发规则（SemVer 2.0.0）

| 改动类别 | 触发条件 | 版本位 |
|---|---|---|
| **MAJOR**（X.y.z） | 删除/重命名一条红线；改 hook 触发条件不向后兼容；删除/重命名 frontmatter 必填字段；删除/重命名 user-invokable 命令子命令 | 升 X，y/z 归零 |
| **MINOR**（x.Y.z） | 新增 hook surface；新增 flag / 子命令；新增 stage / check / red line；行为强化 | 升 Y，z 归零 |
| **PATCH**（x.y.Z） | 修 typo / 排版 / 链接修复；不影响行为的文档勘误 | 升 Z |

无行为意义改动 SHALL 不 bump。skill-lint 不检测语义层面，但 S29/S30/S31 强制 bump
后 marketplace.json + help-card + CHANGELOG 三处字面量同步（合并自
[`version-governance`](../../changes/archive/version-governance/specs/skill-lifecycle/spec.md) spec delta）

### 场景 C — 调整分类

调整某 skill 的 `metadata.category` 时，下列 24 处同步点 MUST 全部更新：

- [ ] `skills/<name>/SKILL.md` 与 `platforms/<platform>/<name>/SKILL.md`
      frontmatter 的 `metadata.category` 两处同步
- [ ] `marketplace.json` 重算 `integrity.skill-md-sha256`
- [ ] `docs/design/<name>-design.md` 更新分类决策行（加修订日期 + 新理由，
      详见 `category-decision` spec）
- [ ] `README.md` Skills 表格：把行从旧章节移到新章节；详情段落按新分类
      调整顺序（Hammer→Crucible→Anvil→Quench）
- [ ] `docs/i18n/<lang>/README.md` × 1（zh-CN）：两处同步（表格 + 详情段落位置）
- [ ] `docs/user-guide/<name>-guide.md` 的"Interaction with other forge skills"
      段——所有跨 skill 分类声明（如 "Same category"、"sibling of X"）
- [ ] `docs/i18n/<lang>/<name>-guide.md` × 1（zh-CN）——同上，核对跨 skill 分类声明
- [ ] 全文 grep 该 skill 名，确认零遗留旧分类描述（如
      "anvil sibling of skill-lint"）
- [ ] 多语言关键词扫描（见下方"自检关键动作"）

### 场景 D — 删除或重命名

**删除**：

- [ ] 删除 `skills/<name>/`、`platforms/*/<name>`、`evals/<name>/`、
      `docs/user-guide/<name>-guide.md`、`docs/i18n/zh-CN/<name>-guide.md`、
      `docs/i18n-archived/*/<name>-guide.md`（如有，归档语言中也要清掉对应文件）、
      `docs/design/<category>/<name>-design.md`
- [ ] 从 `.claude-plugin/marketplace.json` 的 `plugins` 数组移除条目
- [ ] 从 `README.md` + 1 份 `docs/i18n/zh-CN/README.md` 移除：Skills 表格行、
      详情段落、skills badge 计数 -1、首段 "N skills" 计数 -1
- [ ] 若该 skill 有专属 hook，删除整个 `skills/<name>/hooks/` 目录
- [ ] 全文 `grep -rn "<name>"` 确认零残留引用
- [ ] 运行 skill-lint 验证

**重命名**：

等价于"删除旧名 + 新增新名"，特别注意：

- [ ] `git mv` 而非 `rm + add`，保留提交历史
- [ ] hook 的 matcher / 脚本名都要更新
- [ ] marketplace.json 的 `skill-md-sha256` 必须重算（路径变了 SHA 不变，
      但 `skills` 数组里的路径必须同步）

### 自检关键动作（任何场景结束 MUST 运行）

```bash
# 结构检查（含 hash / platform-parity / i18n-structure / cross-skill-category 4 条防线）
bash skills/skill-lint/scripts/skill-lint.sh .

# 漏网扫描
grep -rn "<skill-name>" . --include="*.md" --include="*.json"

# Badge 一致性
grep -rn "skills-[0-9]*-blue" README.md docs/i18n/*/README.md

# 多语言跨 skill 分类声明扫描（场景 C 必跑）
grep -rnE "(Same category|同一分类|同カテゴリ|동일 카테고리|समान श्रेणी|Misma categoría|Même catégorie|Gleiche Kategorie|Mesma categoria|Та же категория|Aynı kategori|Cùng phân loại)" docs/
```

任何一项发现不一致，视为变更**未完成**。

## Rationale

- **24 处同步点的来历**：claim-ground 早期分类误判事件中，从 anvil
  调整为 hammer 涉及 24 处，遗漏任何一处都会让用户在某些语言版本看到
  "anvil sibling of skill-lint"的错误描述
- **场景化清单**：把"修改 skill 要做什么"从口头默契变成 24 项具体动作，
  避免依赖个人记忆
- **skill-lint 是主防线**：4 条 verify-* 规则在 CI 环境应当作为 blocker，
  本 spec 是规则的契约源头
- **i18n 单轨**：本 spec 引用 `docs/i18n/<lang>/<file>` 单轨布局，过渡期已于
  2026-04-29 通过 `bootstrap-openspec-and-restructure` change 结束
  （详见 `i18n-layout` spec）

## Verification

### 自动化

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：以下 4 条防线全部通过
#   - hash-integrity（marketplace.json 中的 SHA 与 SKILL.md 一致）
#   - platform-parity（每 skill × 每 platform 都有目录）
#   - i18n-structure-parity（每 skill × 每语言都有 guide）
#   - cross-skill-category-claim（跨 skill 分类声明在所有语言版本一致）
```

### 人工核对

任何一次 skill 变更 PR 描述里 MUST 贴出"我执行的场景是 A/B/C/D"，
以及对应清单的逐项勾选状态。
