# Skill Lint User Guide

> Get started in 3 minutes — validate your Claude Code skill quality

---

## Install

### Claude Code (recommended)

```bash
claude plugin add juserai/forge
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **Zero dependencies** — Skill Lint requires no external services or APIs. Install and go.

---

## Commands

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/skill-lint` | Show usage info | View available checks |
| `/skill-lint .` | Lint the current project | Self-check during development |
| `/skill-lint /path/to/plugin` | Lint a specific path | Review another plugin |

---

## Use Cases

### Self-check after creating a new skill

After creating `skills/<name>/SKILL.md`, `commands/<name>.md`, and related files, run `/skill-lint .` to confirm the structure is complete, frontmatter is correct, and the marketplace entry has been added.

### Review someone else's plugin

When reviewing a PR or auditing another plugin, use `/skill-lint /path/to/plugin` for a quick check on file completeness and consistency.

### CI integration

`scripts/skill-lint.sh` can run directly in a CI pipeline, outputting JSON for automated parsing:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Check Items

### Structural Checks (executed by Bash script)

| Rule | What it checks | Severity |
|------|---------------|----------|
| S01 | `plugin.json` exists in both root and `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` exists | error |
| S03 | Each `skills/<name>/` contains a `SKILL.md` | error |
| S04 | SKILL.md frontmatter includes `name` and `description` | error |
| S05 | Each skill has a corresponding `commands/<name>.md` | warning |
| S06 | Each skill is listed in the marketplace.json `plugins` array | warning |
| S07 | References files cited in SKILL.md actually exist | error |
| S08 | `evals/<name>/scenarios.md` exists | warning |

### Semantic Checks (executed by AI)

| Rule | What it checks | Severity |
|------|---------------|----------|
| M01 | Description clearly states purpose and trigger conditions | warning |
| M02 | Name matches directory name; description is consistent across files | warning |
| M03 | Command routing logic correctly references the skill name | warning |
| M04 | References content is logically consistent with SKILL.md | warning |
| M05 | Eval scenarios cover core functionality paths (at least 5) | warning |

---

## Expected Output Examples

### All checks passed

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### Issues found

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Workflow

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## When to use / When NOT to use

### ✅ Use when

- Validating a Claude Code plugin's structure before release
- Checking integrity hash / convention compliance / i18n coverage
- As a CI/CD gate for plugin repositories

### ❌ Don't use when

- Non-plugin projects (rules don't apply; you'll get irrelevant errors)
- Production code quality review (not a linter / type checker / security scanner)
- License legal review (only checks the `license` field exists)

> Plugin structural CI — ensures convention compliance, not runtime correctness or security.

Full boundary analysis: [references/scope-boundaries.md](../../skills/skill-lint/references/scope-boundaries.md)

---

## FAQ

### Can I run structural checks only, without semantic checks?

Yes — run the bash script directly:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

This outputs pure JSON with no AI semantic analysis.

### Does it work on non-forge projects?

Yes. Any directory that follows the standard Claude Code plugin structure (`skills/`, `commands/`, `.claude-plugin/`) can be validated.

### What's the difference between errors and warnings?

- **error**: Structural issues that will prevent the skill from loading or publishing correctly
- **warning**: Quality issues that won't break functionality but affect maintainability and discoverability

### Other forge tools

Skill Lint is part of the forge collection and works well alongside these skills:

- [Block Break](block-break-guide.md) — High-agency behavioral constraint engine that forces AI to exhaust every approach
- [Ralph Boost](ralph-boost-guide.md) — Autonomous dev loop engine with built-in Block Break convergence guarantees

After developing a new skill, run `/skill-lint .` to verify structural completeness and confirm that frontmatter, marketplace.json, and reference links are all correct.

---

## License

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
