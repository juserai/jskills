# Tasks — reduce-i18n-to-zh-cn-only

## Phase 1 — 目录迁移

- [ ] T1.1 `mkdir -p docs/i18n-archived/`
- [ ] T1.2 git mv 10 语言：`for lang in de es fr hi ja ko pt-BR ru tr vi; do git mv "docs/i18n/$lang" "docs/i18n-archived/$lang"; done`
  - 验证：`ls docs/i18n/` 只输出 `zh-CN`；`ls docs/i18n-archived/ | wc -l` = 10

## Phase 2 — README link list

- [ ] T2.1 `README.md` line 11：把 11 语言 link list 缩成单条 `[中文](docs/i18n/zh-CN/README.md)`
  - 验证：`grep -c "i18n/" README.md`（应 ≤ 2，line 11 + line 308 描述）

- [ ] T2.2 `README.md` line 308：tree 注释 "Translations (11 languages, single-track)" → "Translations (zh-CN only; archived languages in `docs/i18n-archived/`)"

- [ ] T2.3 `docs/i18n/zh-CN/README.md` line 11：link list 缩成单条 `[English](../../../README.md)`
  - 验证：`grep -c "i18n/" docs/i18n/zh-CN/README.md` 不命中其它语言路径

## Phase 3 — Spec delta

- [ ] T3.1 `openspec/specs/i18n-layout/spec.md`：
  - "11 种" / "× 11 份" / "× 88 份" → "1 种" / "× 1 份" / "× 9 份"（peer-fuse 上线后是 9 个 skill）
  - 在"### 支持语言"段后追加"### 当前支持语言（v0.2 后）"短段：说明 2026-05-08 起从 11 收缩到 1（zh-CN），保留路径在 `docs/i18n-archived/`，恢复需走专项 RFC

- [ ] T3.2 `openspec/specs/skill-lifecycle/spec.md` 场景 A/B/C/D：
  - 所有 `× 11 语言` / `× 11`（指 i18n）→ `× 1 语言（zh-CN）` / `× 1`
  - 在场景 A 顶部加注："2026-05-08 后：i18n broadcast 收敛到 zh-CN 单语言（详见 archived [reduce-i18n-to-zh-cn-only](archive/reduce-i18n-to-zh-cn-only/proposal.md)）"

- [ ] T3.3 `CLAUDE.md` line 19 `docs/i18n/<lang>/<file>`：注释词改成 `多语言（README + skill guide；当前仅 zh-CN）`，保留通配语法

## Phase 4 — Verification

- [ ] T4.1 `bash skills/skill-lint/scripts/skill-lint.sh .`：errors 0；warnings 不增（S32 仍只对 zh-CN 报漂移）；passed 数 ≥ 之前-N（S15/S16/S23 检查项数减少）
- [ ] T4.2 grep 残留检查：`grep -rn "× 11 \|× 88 \|11 语言\|11 份" CLAUDE.md openspec/specs README.md` 应无命中（除归档说明上下文）
- [ ] T4.3 链路完整：`grep "../../README.md\|../../../README.md" docs/i18n/zh-CN/README.md` 应命中

## Phase 5 — 提交 + push + archive

- [ ] T5.1 git add + commit + push 到 main
- [ ] T5.2 RFC merge 后将 `openspec/changes/reduce-i18n-to-zh-cn-only/` 移到 archive/
