# Tasks — add-peer-fuse-skill

## Phase 1 — Skill 本体（canonical）

- [ ] T1.1 创建 `skills/peer-fuse/SKILL.md`（frontmatter + Help 段 + 7-stage pipeline + 参数表 + 引用矩阵）
  - 验证：`grep -E "^name: peer-fuse" skills/peer-fuse/SKILL.md && grep -E "metadata:.*\n.*category: crucible" skills/peer-fuse/SKILL.md`
  - 依赖：无

- [ ] T1.2 创建 5 份 `skills/peer-fuse/references/`：rubric-8dim.md, flag-taxonomy.md, replication-tier.md, format-adapters.md, type-classifier.md
  - 验证：`ls skills/peer-fuse/references/ | wc -l` ≥ 5
  - 依赖：T1.1

- [ ] T1.3 创建 3 份 `skills/peer-fuse/agents/`：review-methodologist.md, review-adversarial.md, review-practitioner.md
  - 验证：`ls skills/peer-fuse/agents/ | wc -l` = 3；每份含 `name:` / `description:` frontmatter
  - 依赖：T1.1

- [ ] T1.4 创建 4 份 `skills/peer-fuse/templates/`：review-report.md, review-diff-block.md, document-reading.md, holistic-assessment.md
  - 验证：`ls skills/peer-fuse/templates/ | wc -l` = 4
  - 依赖：T1.1

- [ ] T1.5 创建 3 份 `skills/peer-fuse/scripts/`：detect-format-tools.sh, convert-to-canonical.sh, classify-research-type.sh（chmod 0755）
  - 验证：`find skills/peer-fuse/scripts -name "*.sh" -perm -u+x | wc -l` = 3
  - 依赖：T1.2（type-classifier.md 是 classify-research-type.sh 的 reference）

## Phase 2 — Platform mirror

- [ ] T2.1 克隆 `skills/peer-fuse/` 到 `platforms/openclaw/peer-fuse/`（结构对等，按 [openspec/specs/platform-parity/spec.md](../../specs/platform-parity/spec.md) 规则做必要的工具命名替换）
  - 验证：`diff -rq skills/peer-fuse platforms/openclaw/peer-fuse | wc -l` ≤ 实际差异（仅工具命名行）
  - 依赖：T1.1 - T1.5 全完成

## Phase 3 — Evals + Docs

- [ ] T3.1 创建 `evals/peer-fuse/scenarios.md`（≥ 10 场景含多格式 + auto-classify + fail-soft）+ `run-trigger-test.sh`（chmod 0755）
  - 验证：`bash evals/peer-fuse/run-trigger-test.sh`（应至少能解析参数）
  - 依赖：T1.1

- [ ] T3.2 创建 `docs/user-guide/peer-fuse-guide.md`（含 Interaction with other forge skills 段，对齐 vs IF Stage 6.5 边界）
  - 验证：`grep -c "^## " docs/user-guide/peer-fuse-guide.md` ≥ 6
  - 依赖：T1.1

- [ ] T3.3 创建 `docs/design/crucible/peer-fuse-design.md`（4 分类三元组 + 早期 anvil 误判记录 + Stage 6.5 边界 + sibling 声明）
  - 验证：`grep -E "sibling.*(insight-fuse|council-fuse)" docs/design/crucible/peer-fuse-design.md`
  - 依赖：T1.1

- [ ] T3.4 创建 `docs/i18n/<lang>/peer-fuse-guide.md` × 11（en/zh/ja/ko/hi/es/fr/de/pt/ru/tr）
  - 验证：`find docs/i18n -name "peer-fuse-guide.md" | wc -l` = 11
  - 依赖：T3.2（en 是源文，其余基于 en 翻译）
  - 兜底：可用脚本 `for lang in en zh ja ko hi es fr de pt ru tr; do test -f docs/i18n/$lang/peer-fuse-guide.md || echo "MISSING $lang"; done`

## Phase 4 — Marketplace + README + CHANGELOG

- [ ] T4.1 在 `.claude-plugin/marketplace.json` 新增 plugin 条目（version: "0.1.0", category metadata, source 等）
  - 验证：`jq '.plugins[] | select(.name == "peer-fuse") | .version' .claude-plugin/marketplace.json` 输出 `"0.1.0"`
  - 依赖：T1.1, T2.1

- [ ] T4.2 跑 `bash scripts/recalc-all-hashes.sh` 重算所有 SHA-256（含 peer-fuse）
  - 验证：`jq '.plugins[] | select(.name == "peer-fuse") | .integrity."skill-md-sha256"' .claude-plugin/marketplace.json` 非空且非 placeholder
  - 依赖：T4.1

- [ ] T4.3 更新 `README.md`：Crucible 章节加 peer-fuse 行 + 详情段落（按 Hammer→Crucible→Anvil→Quench 顺序）+ skills badge `skills-N-blue.svg` 计数 +1 + 首段 "N skills" 计数 +1
  - 验证：`grep "peer-fuse" README.md` 命中 ≥ 2 处（表格行 + 详情段）；`grep -oE "skills-[0-9]+-blue" README.md` 计数与 marketplace.json plugins 数量一致
  - 依赖：T1.1

- [ ] T4.4 更新 `docs/i18n/<lang>/README.md` × 11：表格行 + 详情段 + badge + 首段 N skills 计数同步
  - 验证：`for lang in en zh ja ko hi es fr de pt ru tr; do grep -q "peer-fuse" docs/i18n/$lang/README.md || echo "MISSING $lang"; done`
  - 依赖：T4.3

- [ ] T4.5 在根 `CHANGELOG.md` 新增 `## peer-fuse` 段，置于字母序合适位置；top entry `### [0.1.0] — 2026-05-07` 与 marketplace SSOT 一致（per [archive/version-governance § S31](archive/version-governance/proposal.md)）
  - 验证：`awk '/^## peer-fuse$/{flag=1; next} /^## /{flag=0} flag && /^### \[/{print; exit}' CHANGELOG.md` 输出 `### [0.1.0] — 2026-05-07`
  - 依赖：T4.1

## Phase 5 — Verification

- [ ] T5.1 跑 skill-lint 全通过（4 防线 + 27 规则含 S29/S30/S31）
  - 命令：`bash skills/skill-lint/scripts/skill-lint.sh .`
  - 期望：exit 0，所有 peer-fuse 项 PASS
  - 依赖：T1.1 - T4.5 全完成

- [ ] T5.2 漏网扫描
  - 命令：`grep -rn "peer-fuse" . --include="*.md" --include="*.json" --include="*.sh" --exclude-dir=.git`
  - 期望：每处出现都是有意引入；无残留旧 skill 名（如 `review-fuse`）
  - 依赖：T5.1

- [ ] T5.3 Hash 锁步
  - 命令：`bash scripts/recalc-all-hashes.sh && git diff --quiet .claude-plugin/marketplace.json`
  - 期望：第一次运行可能修改 hash；第二次必须 quiet
  - 依赖：T5.1

- [ ] T5.4 触发测试
  - 命令：`bash evals/peer-fuse/run-trigger-test.sh`
  - 期望：≥ 10 场景全 PASS
  - 依赖：T5.1

- [ ] T5.5 端到端 dry-run（人工核对）
  - 命令：`/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md --no-save`
  - 期望：review_grade 与外部评审 8.7 差距 ≤ 0.5；命中 ≥ 4 个 flag；§ Document Reading 禁词扫描 PASS；recommendation 字段填充
  - 依赖：T5.4

## Phase 6 — Archive

- [ ] T6.1 PR merge 后将本目录移到 `openspec/changes/archive/add-peer-fuse-skill/`
  - 命令：`git mv openspec/changes/add-peer-fuse-skill openspec/changes/archive/add-peer-fuse-skill`
  - 依赖：T5.5 通过 + 用户验收
