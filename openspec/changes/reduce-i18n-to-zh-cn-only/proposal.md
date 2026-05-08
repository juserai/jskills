# Reduce i18n surface to zh-CN only (archive 10 other languages)

> 这次 change 解决的张力：当前 i18n 矩阵 `11 langs × 9 skills = 99 文件`，每次新增 skill 都要广播 11 份 i18n guide；多数翻译质量未经母语审校（v0.1.0 翻译 agent 自动产物），维护成本高于实际读者收益。在审校机制就位之前，**收敛到 zh-CN 单语言** 把 9 文件维护住。

## Why

实勘事实：

1. **维护负载与审校缺位失衡**：`docs/i18n/{de,es,fr,hi,ja,ko,pt-BR,ru,tr,vi}/` 共 10 语言 × 9 文件 = 90 份 markdown，每个新 skill 出 11 翻译。peer-fuse v0.1.0 的 11 份 i18n guide 由并行翻译 agent 自动生成，**无母语审校**——发布出去用户看到的可能是技术词不准的二手译稿。
2. **新增 skill 流程被 i18n broadcast 拖慢**：[openspec/specs/skill-lifecycle/spec.md § 场景 A](../../specs/skill-lifecycle/spec.md) 强制要求 `× 11 语言`，加 1 个 skill 要写 11 份翻译；S32 docs-version-drift 还要求版本号字面量在每份 guide 里同步 → bump 一个 skill 要改 11 份 H1。这个开销与读者价值不匹配。
3. **zh-CN 是唯一明确母语审校** 的语言（仓库主要维护者母语为中文，其它语言均为机翻 + 个别校对）。集中维护 zh-CN 让翻译质量真的过关。

本 change 把"翻译质量"问题从"凑齐 11 份"改为"做好 1 份"。其余 10 语言移到 `docs/i18n-archived/<lang>/` 保留历史，未来需要某语言时基于此 archive 重启专项 RFC。

## What Changes

**目录迁移**（git mv，保留历史）：

- `docs/i18n/{de,es,fr,hi,ja,ko,pt-BR,ru,tr,vi}/` → `docs/i18n-archived/{de,es,fr,hi,ja,ko,pt-BR,ru,tr,vi}/`
- `docs/i18n/zh-CN/` 保留原位

**README.md 修改**（共 2 处）：

- 顶部语言切换链表：从 11 语言切换条简化为仅 `[中文](docs/i18n/zh-CN/README.md)`
- 项目结构 ASCII 图："Translations (11 languages, single-track)" → "Translations (zh-CN only; archived languages in `docs/i18n-archived/`)"

**docs/i18n/zh-CN/README.md 修改**：

- 顶部语言切换链表：从 11 语言条简化为仅 `[English](../../../README.md)`

**Spec 修改**（影响 i18n-layout 与 skill-lifecycle）：

- `openspec/specs/i18n-layout/spec.md`：支持语言数 11 → 1（zh-CN）；`× 11 份` 与 `× 88 份` 全部改为 `× 1 份` 与 `× 8 份`（peer-fuse 上线后是 9）；新增"归档语言重启"段说明从 archive 恢复某语言需走专项 RFC
- `openspec/specs/skill-lifecycle/spec.md` 场景 A/B/C/D：`× 11 语言` 改为 `× 1 语言（zh-CN）`；归档语言不在 lint 扫描范围

**lint 影响**：

- skill-lint S15 / S16 / S23 / S32 **自动收敛**到只扫 zh-CN（它们 `os.listdir(docs/i18n)` 取实际存在的语言）
- 不需改 lint 代码或 .skill-lint.json
- S32 现有 9 条 docs-drift warnings（zh-CN guide H1 旧版本）依然存在，由 follow-up `sync-zh-cn-docs-version` 单独处理

**集合级 plugin.json 不动**：i18n surface 收缩不是 collection 功能变化，version 1.0.0 维持。

## Non-goals

- **不修翻译质量**：本 change 只做"收缩"，不审校 zh-CN 任一字。zh-CN 母语审校另开 RFC `audit-zh-cn-translations`。
- **不删除归档语言文件**：`docs/i18n-archived/` 保留全部 10 语言 × 9 文件，git 历史也保留。未来某语言要复活，从 archive 恢复并跑专项 i18n review。
- **不改 i18n 单轨布局**：仍是 `docs/i18n/<lang>/<file>` 结构，只是 lang 集合从 11 缩到 1。
- **不引入 i18n 自动化翻译流水线**：不预设"以后翻译归回来" 时机，由实际需求触发。
- **不改 skill 自身的 SKILL.md 内描述**：6 个 skill 的 description 不动；description i18n 由 marketplace.json 单语言（English）覆盖（既有约定）。
- **不动 zh-CN guide H1 版本字面量**：S32 docs-drift warnings 仍由独立 follow-up 处理，本 change 不解决。
