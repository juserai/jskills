# Design — reduce-i18n-to-zh-cn-only

影响分类：**cross**（i18n 是横向能力，缩 surface 影响所有 skill）。

## 设计决策

### 1. 归档路径：`docs/i18n-archived/<lang>/`（不是删除、不是 `_archive/` 子目录）

- **选了什么**：sibling 目录 `docs/i18n-archived/`
- **为什么不删除**：用户硬约束 *"暂时归档"*——保留可恢复性。git 历史也保留但目录可见性强于纯历史回滚
- **为什么不放 `docs/i18n/_archive/<lang>/` 子目录**：skill-lint S15/S16/S23 用 `os.listdir(docs/i18n)` 扫描语言目录，会把 `_archive` 当成一个伪语言去校验 README/guide 覆盖率 → lint 红
- **为什么不放仓库根 `archive/i18n/`**：与 `openspec/changes/archive/` 的命名分裂；docs 内的产物归档到 `docs/<archive-suffix>/` 更内聚

### 2. 归档保留全部文件（不只是 guide）

- 每个归档语言保留 9 个文件：README.md + 8 skill-guide.md + peer-fuse-guide.md
- 未来恢复某语言只需 `git mv docs/i18n-archived/<lang>/ docs/i18n/<lang>/` + 重跑 lint + spec 回滚
- 删除式归档（保留 git 历史 + 删工作树）会让"恢复"必须 cherry-pick + 翻译同步，重启成本高

### 3. README 链表语义：保留双向跳转

- 主 `README.md` line 11：`[中文](docs/i18n/zh-CN/README.md)` 单条
- `docs/i18n/zh-CN/README.md` line 11：`[English](../../../README.md)` 单条
- **为什么不直接删整行**：双向跳转是 i18n surface 的入口语义；只剩 1 语言时仍提供"我能看到中文"的发现路径

### 4. spec 词汇统一：`× 1 语言（zh-CN）`

- 沿用现有 spec 的 `× N 语言` 表达，不重写为 `(only zh-CN)` 等替代措辞
- spec.md 顶部加"### 当前支持语言"短段说明 11 → 1 的收缩与原因
- 未来恢复某语言仅需把 `× 1` 改回 `× 2`（或别的数字）+ 列表更新

### 5. lint 自动收敛（不动 .skill-lint.json）

- skill-lint S15/S16/S23 用 `os.listdir(i18n_dir)` 取真实语言集，归档目录 `docs/i18n-archived` 不在扫描范围
- S32 仍会扫 zh-CN（保持 docs-drift 检测在 zh-CN 上有效）
- `.skill-lint.json` 的 `i18n-dir: "docs/i18n"` 不变；`require-i18n-guide: true` 不变（"每个 skill 必须有 zh-CN guide"——zh-CN 9 文件已齐）

### 6. 不引入新 capability spec

- 复用现有 `i18n-layout` 与 `skill-lifecycle` capability，仅做 spec delta（reduce 当前支持语言数）
- 不引入新概念（"归档语言"是策略不是契约），不写 specs/<new-cap>/spec.md

## 受影响清单

- **修改**：
  - `README.md`（line 11 lang switch link list + line 308 i18n tree comment）
  - `docs/i18n/zh-CN/README.md`（line 11 lang switch link list）
  - `openspec/specs/i18n-layout/spec.md`（× 11 → × 1，新增收缩说明段）
  - `openspec/specs/skill-lifecycle/spec.md`（场景 A/B/C/D 中 × 11 → × 1）
  - `CLAUDE.md`（如有 11 langs 字面量；line 19 是 `<lang>` 通配，应该不需动）
- **迁移（git mv）**：
  - `docs/i18n/{de,es,fr,hi,ja,ko,pt-BR,ru,tr,vi}/` → `docs/i18n-archived/{...}/`
- **不动**：
  - 9 个 SKILL.md（marketplace.json 不变 → hash 不变）
  - 任何 skill 的 references / templates / agents / scripts
  - `.skill-lint.json`
  - `.claude-plugin/marketplace.json`
  - `CHANGELOG.md`（无 skill 版本变化）

## Verification

```bash
# 1. 移动后只剩 zh-CN
ls docs/i18n/
# 期望: zh-CN（一行）

ls docs/i18n-archived/ | wc -l
# 期望: 10

# 2. lint 仍是 0 error（S34 仍 PASS）
bash skills/skill-lint/scripts/skill-lint.sh . > /tmp/lint.json
python3 -c "import json; d=json.load(open('/tmp/lint.json')); print('errors:', len(d['errors']))"
# 期望: errors: 0

# 3. README 链表双向
grep -c "i18n/zh-CN/README" README.md
# 期望: ≥ 1
grep -c "../../README.md\|../../../README.md" docs/i18n/zh-CN/README.md
# 期望: ≥ 1
```
