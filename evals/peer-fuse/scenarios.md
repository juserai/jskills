# peer-fuse v0.1.0 Trigger Scenarios

测试 peer-fuse v0.1.0 的触发、参数路由、Stage 0.5 format adapter + type auto-classifier、Stage 3.5 § Document Reading 评审隔离、Stage 4 panel 并行、Stage 5 8-dim 加权、Stage 5.5 § Holistic Assessment、Stage 7 KB 归档。

## Scenario 1: Help card L1 — explicit token

**Input**: `/peer-fuse help`

**Expected**:
- 输出 help card 含 `Peer-Fuse v0.1.0 — Generic peer-reviewer for research artifacts ...`
- Help card 含 Usage / Defaults / Supported formats / Examples 段
- 主流程不触发：无文件读取、无子 agent、无 KB 归档

**Validates**: help-mode L1 显式 token

---

## Scenario 2: Help card L2 — no args

**Input**: `/peer-fuse`

**Expected**: 同 Scenario 1 输出 help card

**Validates**: help-mode L2 隐式 no-args（peer-fuse 是必填参数 skill）

---

## Scenario 3: 审 IF 报告（md，type auto-detect）

**Input**: `/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md`

**Expected**:
- Stage 0.5: target_format = md (Tier 1), type_detection = auto
  - frontmatter `type` 字段直读命中（rule-1-frontmatter-type-field）→ research_type = academic 或 overview（取决于 frontmatter）
- Stage 3.5: § Document Reading 含 ≥ 1 处 verbatim 引用 + 位置标记 `§<sec>` / `L<n>`
- Stage 5: review_grade ≈ A−（与外部评审 8.7 差距 ≤ 0.5）
- Stage 5: 命中 ≥ 4 个 flag，至少含 F-EVD-03 / F-STAT-01 / F-METHOD-01 / F-COST-01
- Stage 5.5: § Holistic Assessment 4 段齐 + recommendation 字段填充
- Stage 7: KB 归档到 `raw/reports/peer-fuse/2026-05-07-...-review.md`
- 可见日志行 `Archived to KB: <path>`

**Validates**: md 格式 + auto-classify + 完整 pipeline

---

## Scenario 4: 审 PDF 学术论文（type auto-classify）

**Input**: `/peer-fuse papers/transformer-2017.pdf`

**Expected**:
- Stage 0.5: target_format = pdf (Tier 1), adapter = Read tool with pages param
- type_detection = auto → rule-3-format-academic-publisher（首页 arXiv/Nature/IEEE 字样命中）→ research_type = academic
- Stage 1: format_skip = [frontmatter]（pdf 跳过 frontmatter 检查）
- Stage 3.5 verbatim 位置标记用 `p.<n>`（不是 `§<sec>`）
- 可见日志行齐

**Validates**: PDF Tier 1 native + 格式特征驱动的 auto-classify + 位置标记格式适配

---

## Scenario 5: 审 PPTX 商业 deck（type auto + libreoffice）

**Pre-condition**: `command -v libreoffice` 可用

**Input**: `/peer-fuse decks/q4-roadmap.pptx --type product`

**Expected**:
- Stage 0.5: target_format = pptx (Tier 3), adapter = libreoffice (pptx → pdf 中转)
- type_detection = explicit (用户传了 --type=product)
- Stage 3.5 verbatim 位置标记用 `slide.<n>`
- F-CITE-01 引用密度阈值按 deck 调整（< 1/slide，参考页除外）
- Stage 7 frontmatter 含 `target_format: pptx, adapter_tier: 3`

**Validates**: PPTX Tier 3 + 显式 type + 位置标记适配

---

## Scenario 6: 审 DOCX 行业研报（pandoc）

**Pre-condition**: `command -v pandoc` 可用

**Input**: `/peer-fuse handbook.docx --depth quick --no-save`

**Expected**:
- Stage 0.5: target_format = docx (Tier 2), adapter = pandoc
- type_detection = auto → rule-2 章节标题模式匹配
- `--depth=quick` 跳过 Stage 4 panel + Stage 5.5 § Holistic Assessment
- 仍渲染 § Document Reading + § Score Matrix + § Flag List + § Diff Suggestions + § Reconciliation
- `--no-save` → Stage 7 输出 `Archive: skipped (--no-save flag)`，KB 目录无新增文件
- 位置标记用 `§<heading-slug>`

**Validates**: DOCX Tier 2 + quick depth 删减 + --no-save 与 IF/CF 同口径

---

## Scenario 7: 格式不支持降级

**Input**: `/peer-fuse weird.xyz`

**Expected**:
- Stage 0.5 detect-format-tools.sh exit 2
- 错误信息含 `Unsupported format: .xyz` + 完整支持列表
- **不进入 Stage 1**
- 无 KB 归档尝试

**Validates**: 格式黑名单 fail-fast

---

## Scenario 8: 缺工具降级

**Pre-condition**: 临时 mock pandoc 不存在 — `PATH=$(echo $PATH | tr ':' '\n' | grep -v pandoc | paste -sd ':')`

**Input**: `/peer-fuse handbook.docx`

**Expected**:
- Stage 0.5 detect-format-tools.sh exit 1
- 错误信息含具体 install hint：`brew install pandoc` / `apt install pandoc`
- **不进入 Stage 1**
- 退出码非 0

**Validates**: 缺工具 fail-soft + install hint

---

## Scenario 9: § Document Reading 评审隔离硬约束

**Input**: `/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md`

**Expected (post-render lint)**:
- § Document Reading 段 3-5 段，~300-600 字
- 段内**禁词扫描 PASS**：无 `grade / score / flag / F-XXX-NN / strong / weak / concern / 优点 / 缺点 / 应当 / 建议` 等评价词
- 段内**字母 grade 字面量扫描 PASS**：评分语境下无 `A+/A−/B+/...`
- 段内**评价节引用扫描 PASS**：无 `§ Score Matrix / § Flag List / § Multi-Perspective Panel / § Diff Suggestions / § Holistic Assessment` 出现
- Stage 7 归档前 hash diff：§ Document Reading 字节级哈希与 Stage 3.5 后快照一致

**Validates**: 用户硬约束"自成章节，不要让评审结果影响原文档的解读内容"——三层防御（架构隔离 + 写后冻结 + 禁词 lint）

---

## Scenario 10: type override 冲突记录

**Input**: `/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md --type market`

**Pre-condition**: 该 IF 报告 frontmatter `type` 字段 ∈ {academic, overview}（与 market 冲突）

**Expected**:
- type_detection = explicit
- Stage 0.5 检测到 frontmatter type 与用户 --type 冲突
- 归档 frontmatter 含 `type_override: market` + `original_type: academic`
- Stage 5 按 market 的 8-dim 权重计算（不是 academic 的）
- review_grade 与 Scenario 3 不同（不同权重 → 不同总分）

**Validates**: 显式 type override 优先级 + 元数据审计

---

## Scenario 11: --depth 全档比对（quick / standard / deep / full）

**Input** (4 次跑同一文件)：
- `/peer-fuse <path> --depth quick`
- `/peer-fuse <path> --depth standard`
- `/peer-fuse <path> --depth deep`
- `/peer-fuse <path> --depth full`

**Expected**:
- quick: 无 § Holistic Assessment + 无 § Multi-Perspective Panel；其它段齐
- standard: 全段齐，3 视角 panel
- deep: 全段齐，3 视角，Stage 3 启发式深度加倍（log 显示扫描轮次 ×2）
- full: 全段齐，5 视角 panel（加 specialist + futurist）

**Validates**: depth 路由分级正确

---

## Scenario 12: 跨格式 review_grade 一致性 sanity

**Input** (同一份 IF 报告手工导出三格式)：
- `/peer-fuse <path>.md`
- `/peer-fuse <path>.pdf`（pandoc 导出）
- `/peer-fuse <path>.docx`（pandoc 导出）

**Expected**:
- 三次 review_grade 差异 ≤ 0.3（同一份内容跨格式应该几乎同分）
- 命中的 flag 集合至少 60% 重合
- 位置标记按格式适配（`§<sec>` / `p.<n>` / `§<heading-slug>`）

**Validates**: format adapter 不引入显著 bias
