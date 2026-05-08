# Capability: i18n-layout

## Purpose

定义 forge 仓库的多语言文档布局。本 spec 描述**目标布局**（单轨
`docs/i18n/<lang>/<file>`），同时记录**现状**（双轨过渡期）与
**迁移路径**，作为 i18n 单轨迁移 change 的契约源头。

## Migration Status

- **Current**（截至 2026-05-08）：单轨布局已落地，i18n surface 已收敛到 zh-CN 单语言
  - `docs/i18n/zh-CN/README.md` × 1 份
  - `docs/i18n/zh-CN/<skill>-guide.md` × 9 份（8 老 skill + peer-fuse）
- **Reduction**（2026-05-08）：由 [`reduce-i18n-to-zh-cn-only`](../../changes/reduce-i18n-to-zh-cn-only/proposal.md) change 把
  原 11 语言收缩到 1 语言；其它 10 语言 git mv 到 `docs/i18n-archived/<lang>/` 保留可恢复性
- **Earlier migrations**：
  - `bootstrap-openspec-and-restructure` (2026-04-29)：旧双轨 `docs/user-guide/i18n/` 与 `docs/i18n/` 合并到单轨
  - `i18n-readme-structure-refresh` (2026-04-30)：README 链表与文件命名规范化
- **Legacy**：`docs/user-guide/i18n/` 目录已删除；`.skill-lint.json` 中
  `i18n-guide-dir` 字段已移除。skill-lint S17 现作为 guard 防止旧路径回归。

## Behavior

### 目标布局

```
docs/i18n/
└── zh-CN/
    ├── README.md
    ├── block-break-guide.md
    ├── claim-ground-guide.md
    ├── council-fuse-guide.md
    ├── insight-fuse-guide.md
    ├── news-fetch-guide.md
    ├── peer-fuse-guide.md
    ├── ralph-boost-guide.md
    ├── skill-lint-guide.md
    └── tome-forge-guide.md

docs/i18n-archived/         # 收缩归档；恢复需走专项 RFC
├── de/    (9 files)
├── es/
├── fr/
├── hi/
├── ja/
├── ko/
├── pt-BR/
├── ru/
├── tr/
└── vi/
```

### 支持语言（截至 2026-05-08）

1 种：`zh-CN`（简体中文，仓库主要维护者母语审校）。

10 种归档：`de` / `es` / `fr` / `hi` / `ja` / `ko` / `pt-BR` / `ru` / `tr` / `vi`，
保存在 `docs/i18n-archived/<lang>/`。

**恢复某归档语言** MUST：

- 开专项 openspec change（如 `restore-i18n-ja`）讨论母语审校来源 + 维护承诺
- 通过后 `git mv docs/i18n-archived/<lang>/ docs/i18n/<lang>/`
- 同步本 spec § 支持语言 列表 + 主 README + zh-CN README 链表

**新增语言（首次出现，不在归档）** MUST：

- 创建 `docs/i18n/<lang>/` 目录 + 翻译 README + 全部 skill guide（共 1 + N 文件）
- 在主 README.md 顶部语言切换链表加入新语言
- 在每份现有语言（含 zh-CN）的 README 顶部链表也加入新语言（顺序一致）
- 更新本 spec § 支持语言 列表

### 文件命名

- `<lang>/README.md` — 该语言的项目级 README 翻译
- `<lang>/<skill-name>-guide.md` — 该语言的 skill 用户指南翻译
- 命名 MUST 与英文版 `docs/user-guide/<skill-name>-guide.md` 对齐
  （文件名相同，仅目录不同）

### 语言切换链表（v0.2 起：双向单条）

收缩到 zh-CN 单语言后，链表退化为双向跳转：

- 主 `README.md`：单条 `[中文](docs/i18n/zh-CN/README.md)`
- `docs/i18n/zh-CN/README.md`：单条 `[English](../../../README.md)`

**未来恢复或新增语言** 时，链表 MUST 再次扩展为完整列表，顺序与主 README.md 一致。

### 内部锚点

i18n 文件中引用其他文档时 MUST 使用相对路径：

- 引用主 README：`../../README.md`
- 引用英文 guide：`../../user-guide/<skill>-guide.md`
- 引用 design 文档：`../../design/<category>/<skill>-design.md`

### `.skill-lint.json` 配置（迁移完成后）

```json
{
  "rules": {
    "i18n-dir": "docs/i18n",
    "verify-i18n-structure-parity": true,
    "user-guide-dir": "docs/user-guide"
  }
}
```

迁移完成后 `i18n-guide-dir` 字段 MUST 移除（与 `i18n-dir` 合并）。

## Rationale

- **单轨 > 双轨的理由**：扫一种语言时所有文件聚在一起；新增 skill 时
  只需在 11 个语言目录各加一个文件，不再需要在两个 i18n 子树同时操作
- **不维持双轨的理由**：双轨需要在每次新增/修改时记住"项目级在 A 路径，
  skill 级在 B 路径"，这个区分在 forge 当前规模收益小于成本
- **目录而非文件名编码语言**：`docs/i18n/zh-CN/` vs
  `docs/i18n/README.zh-CN.md` —— 前者扩展性好，目录可以放任意数量的
  翻译文件而不污染顶层
- **过渡期兼容**：spec 显式承认双轨现状，避免 spec 与实际状态分裂；
  迁移 PR 落地后再去掉 Migration Status 段

## Verification

### 自动化

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：verify-i18n-structure-parity 通过
#   - zh-CN 目录有 README.md
#   - zh-CN 目录有 N 份 *-guide.md（与 skills/ 下数量对齐，2026-05-08 起 N=9）

# 单语言完整性（v0.2+）
ls docs/i18n/*/README.md | wc -l
# 预期：1（仅 zh-CN）

ls docs/i18n/*/*-guide.md | wc -l
# 预期：等于 skills/ 下 user-invokable skill 数量

# 归档语言完整性（保留可恢复性）
ls docs/i18n-archived/ | wc -l
# 预期：10

# 旧路径已清空
test ! -d docs/user-guide/i18n && echo "ok"
# 预期：ok
```

### 迁移期间

迁移 PR 必须在单次提交内同时完成所有文件移动 + 配置更新，避免半迁移
状态使 skill-lint 同时报旧路径不存在和新路径不完整。

### 人工核对

- [ ] 主 README.md 的链表 `[中文](docs/i18n/zh-CN/README.md)` 单条可达
- [ ] zh-CN README.md 的链表 `[English](../../../README.md)` 单条可达
- [ ] zh-CN 内所有内部锚点可正常跳转
- [ ] 归档目录 `docs/i18n-archived/` 完整保留 10 语言 × 9 文件，可在专项 RFC 后恢复
