# Fix help-card flag coverage across 6 skills + promote S34 warn → error

> 这次 change 解决的张力：[add-skill-lint-s34-help-flag-coverage](../add-skill-lint-s34-help-flag-coverage/proposal.md) 引入 S34 lint 规则后暴露出 4 个 skill 的 help card 与 argument-hint 漂移（council-fuse / news-fetch / insight-fuse 的 `--no-save` 系列漏列、block-break 的 `L0-L4` / `<task>` 入口漏列），另有 2 个 skill (claim-ground / skill-lint) 缺 frontmatter argument-hint 字段。本 change 一次性修齐 6 skill，并把 S34 从 warn 升 error 提供持续保护。

## Why

S34 上线后 lint 输出（PR 1 commit `65c2484`）：

```
errors: 0  warnings: 6  passed: 585
- S34: skills/council-fuse/SKILL.md argument-hint has flags not listed in help card: --no-save
- S34: skills/insight-fuse/SKILL.md argument-hint has flags not listed in help card: --audience --focus --no-advisory --no-save --perspectives --skeleton --strategy
- S34: skills/news-fetch/SKILL.md argument-hint has flags not listed in help card: --no-save
- S34: platforms/openclaw/council-fuse/SKILL.md argument-hint has flags not listed in help card: --no-save
- S34: platforms/openclaw/insight-fuse/SKILL.md argument-hint has flags not listed in help card: --audience --focus --no-advisory --no-save --perspectives --skeleton --strategy
- S34: platforms/openclaw/news-fetch/SKILL.md argument-hint has flags not listed in help card: --no-save
```

外加 P1/P2 审计发现：

- `block-break`：[README.md](../../../README.md) 文档了 `/block-break L2` 与 `/block-break <task>`，help card 仅列 `(no args) + help`；frontmatter 无 argument-hint 字段
- `claim-ground`：help card 已含 `verify <claim>` mode，但 frontmatter 无 argument-hint 字段
- `skill-lint`：help card 已含 `<path>` 用法，但 frontmatter 无 argument-hint 字段

## What Changes

**6 个 skill 文档 + 元数据修复**（每 skill patch bump + canonical/mirror 同步 + CHANGELOG entry + marketplace.json 重算 hash）：

| Skill | Old → New | Change |
|---|---|---|
| block-break | 1.0.0 → 1.0.1 | help card 加 `L0-L4` / `<task>` 入口；frontmatter 加 argument-hint |
| claim-ground | 1.2.0 → 1.2.1 | frontmatter 加 argument-hint |
| council-fuse | 1.1.0 → 1.1.1 | help card 加 `--no-save` |
| insight-fuse | 3.4.0 → 3.4.1 | help card 列全 11 flags |
| news-fetch | 1.1.0 → 1.1.1 | help card 加 `--no-save` |
| skill-lint | 1.1.0 → 1.1.1 | frontmatter 加 argument-hint |

**S34 升级**：

- `.skill-lint.json` `verify-help-card-flag-coverage`: `warn` → `error`
- 修完后 lint 0 errors / 0 warnings 重新建立基线，未来任何 help-card / argument-hint 漂移直接 PR 阻塞

## Non-goals

- 不动 ralph-boost / tome-forge：argument-hint 用子命令枚举（`[setup|run|...]`），无 `--flag`，S34 自动豁免
- 不动 peer-fuse：v0.1.0 已合规
- 不引入新 spec capability：本 change 仅修文档元数据 + 升级现有 lint 规则的 severity，沿用 [skill-lifecycle](../../specs/skill-lifecycle/spec.md) / [help-mode](../../specs/help-mode/spec.md) / [repo-invariants](../../specs/repo-invariants/spec.md) 现有契约
- 不补全 6 skill 的 i18n guide：本 change 只动 SKILL.md 与 marketplace.json + CHANGELOG，文档版本 drift 由 [S32](../../../skills/skill-lint/scripts/skill-lint.sh) 单独检查（warn 级；不阻塞）
