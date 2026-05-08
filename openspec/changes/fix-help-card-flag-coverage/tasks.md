# Tasks — fix-help-card-flag-coverage

## Phase 1 — SKILL.md 修复

- [ ] T1.1 council-fuse: help card 加 `--no-save` Usage 行 + Examples 行；版本 1.1.0 → 1.1.1
  - 验证：`grep -A 5 "## Help" skills/council-fuse/SKILL.md | grep -- "--no-save"`
- [ ] T1.2 news-fetch: 同上 (1.1.0 → 1.1.1)
- [ ] T1.3 insight-fuse: help card "Key flags" 段从 4 → 11 flags；版本 3.4.0 → 3.4.1
  - 验证：跑 S34 应输出 PASSED 而非 WARNING
- [ ] T1.4 block-break: help card 加 `/block-break L2` / `/block-break <task>` 行；frontmatter 加 argument-hint；版本 1.0.0 → 1.0.1
- [ ] T1.5 claim-ground: frontmatter 加 argument-hint；版本 1.2.0 → 1.2.1
- [ ] T1.6 skill-lint: frontmatter 加 argument-hint；版本 1.1.0 → 1.1.1

## Phase 2 — Mirror

- [ ] T2.1 cp 6 个 canonical SKILL.md 到 platforms/openclaw/<skill>/SKILL.md
  - 验证：`for s in block-break claim-ground council-fuse insight-fuse news-fetch skill-lint; do diff -q skills/$s/SKILL.md platforms/openclaw/$s/SKILL.md; done` 全输出空

## Phase 3 — Marketplace + CHANGELOG + Lint

- [ ] T3.1 marketplace.json: 6 version bumps（block-break 1.0.0→1.0.1, claim-ground 1.2.0→1.2.1, council-fuse 1.1.0→1.1.1, insight-fuse 3.4.0→3.4.1, news-fetch 1.1.0→1.1.1, skill-lint 1.1.0→1.1.1）
- [ ] T3.2 CHANGELOG.md: 6 个 `### [X.Y.Z+1] — 2026-05-08` patch entries
- [ ] T3.3 `.skill-lint.json`: `verify-help-card-flag-coverage` warn → error
- [ ] T3.4 `bash scripts/recalc-all-hashes.sh` 重算 6 个 hash

## Phase 4 — Verification

- [ ] T4.1 `bash skills/skill-lint/scripts/skill-lint.sh .`：errors 0 / warnings 0 / passed ≥ 590
- [ ] T4.2 `bash evals/skill-lint/run-trigger-test.sh`：exit 0
- [ ] T4.3 grep 漏网：`grep -rn "v1.0.0.*Block Break\|Council Fuse v1.1.0\|News Fetch v1.1.0\|Insight Fuse v3.4.0\|Claim Ground v1.2.0\|Skill Lint v1.1.0" skills platforms` 全 0 命中

## Phase 5 — 提交 + push + archive

- [ ] T5.1 commit + push PR 2（main）
- [ ] T5.2 PR 1 + PR 2 都合并后将 add-skill-lint-s34-help-flag-coverage 与 fix-help-card-flag-coverage 一起归档到 archive/
