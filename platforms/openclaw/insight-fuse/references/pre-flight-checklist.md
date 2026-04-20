# Pre-Flight Checklist（发布前 8 项自检）

Stage 3 / Stage 5 每个 agent 在输出 INSIGHT_RESPONSE 之前、Main agent 在综合阶段落盘最终报告之前，必须对照本清单默读。任一项未过 → 返工或在 GAPS_IDENTIFIED 登记。

本清单从 [quality-standards.md](quality-standards.md) 的 14 项 mandatory checks 中挑出**最高频、最易漏**的 8 项，提前到输出前的自查环节，减少综合阶段的返工。v3 新增第 8 项 skeleton-field 自检。

---

## 8 项清单

### 1. SOURCES_USED 完整性

- [ ] 每条 source 标注了 credibility 等级（L1-L5 或对应 label）？
- [ ] 每条 source 标注了 `content_support: verified | inferred | placeholder`？
- [ ] `placeholder` 的来源已经在 GAPS_IDENTIFIED 登记？
- [ ] **v2**：SOURCE_TIER 字段已按 L1-L5 统计数量？

映射：Check 1 + Check 10 / Accuracy 加权公式 / [research-protocol.md](research-protocol.md) § Content Support Tag

### 2. 来源独立性声明

- [ ] 报告「参考来源」末尾是否有 `独立性声明：...` 行？
- [ ] 是否识别出了同源转引（共同原始文档 / 资金方 / 行业联盟 / 转载链）？
- [ ] 若全部来源追溯到同一祖本，是否已触发 Check 3 的伪三角判定？

映射：Check 10

### 3. 单源占比 ≤ 40%

- [ ] 任一 source 的引用次数 ≤ 该 section 内 total × 40%？
- [ ] 计数时把 Check 10 判定为同源的来源合并算 1 份？

映射：Check 3 + Check 10

### 4. 因果断言纪律

- [ ] 正文中"导致 / 使得 / 由 ... 造成 / because of / leads to / 驱动"等因果关键词，是否都附了 ≥ 3 种替代解释？
- [ ] 未能排除的因果断言，是否已降级为"相关 / 伴随 / 观察到"？

映射：Check 11

### 5. 比较断言有数据支撑

- [ ] "X is faster than Y" / "most popular" / "widely adopted" 等比较断言，是否都有 benchmark / 市场份额 / 采用数据引用？
- [ ] "significantly more reliable" / "革命性" / "颠覆式" 等模糊修饰是否已替换为具体数字？

映射：Check 4

### 6. Critic 输出含 FALSIFICATION_CONDITIONS + EVIDENCE_CHAIN

- [ ] Critic 的 INSIGHT_RESPONSE 是否包含 FALSIFICATION_CONDITIONS 字段（2-4 条）？
- [ ] 每条证伪条件是否是具体、可观察的证据，而非"需要更多数据"这类空泛话？
- [ ] 每条是否指向了具体的 Finding #N，而不是笼统撤销？
- [ ] **v2**：EVIDENCE_CHAIN 是否 ≥ 3 条，每条含 claim / support / confidence / falsifiability 四字段？

映射：[research-protocol.md](research-protocol.md) § EVIDENCE_CHAIN + `agents/insight-critic.md` § Falsification Discipline

### 7. 形式规范 + FIR 三层分隔

- [ ] 首节是「一、摘要（TL;DR）」，结论先行？
- [ ] 头部有日期戳 `> 日期：YYYY-MM-DD`？
- [ ] 头部有 skeleton 引用块 `> Skeleton: ...`？
- [ ] 末尾有 forge attribution block？
- [ ] 所有 inline citation 都出现在「参考来源」列表中（无 orphan URL）？
- [ ] **v3**：每段首标 `[F]` / `[I]` / `[R]`？
- [ ] **v3**：主体（首个 `---` 前）零 `[R]`？`[R]` 仅允许在 Advisory Appendix？

映射：Check 1 / 2 / 5 / 6 / 14 + [research-protocol.md](research-protocol.md) § Auto-Structure Algorithm + § FIR

### 8. Skeleton field 保全（v3 新增）

- [ ] 报告章节骨架是否对齐 `skeleton.dimensions`？
- [ ] 每个 `skeleton.dimensions[].name` 在正文中是否出现 ≥ 2 次？
- [ ] `skeleton.out_of_scope` 声明的排除项是否在报告末尾声明？
- [ ] `skeleton.known_dissensus` 每项是否渲染为三段式（立场 A / 立场 B / 综合判断），未合成？
- [ ] `skeleton.existing_consensus` 是否在相关 section 作为背景引用（不重复扫描）？
- [ ] `skeleton.hypotheses` 每条是否在 Stage 3 sub-question 对应处有回应，结论标注"已验证 / 已证伪 / 待定"？
- [ ] `skeleton.business_neutral: true` 时，是否主体无针对性专名？

映射：Check 7 + Check 8 + Check 12 + [skeleton-schema.md](skeleton-schema.md) § 字段 × Stage 消费矩阵

---

## 使用方法

- **Agent 层面**（Stage 3 / 5）：每个 Generalist / Critic / Specialist / Methodologist 在收尾 INSIGHT_RESPONSE 之前，按 8 项默读。不通过的项要么修复，要么在 GAPS_IDENTIFIED / FALSIFICATION_CONDITIONS 里记录。
- **Main agent 层面**（Stage 3 综合 / Stage 5 / Stage 6 QA）：在调用 [quality-standards.md](quality-standards.md) 的 14 项 blocking checks 之前，先跑一遍 8 项 pre-flight。pre-flight 漏掉的多数是 blocking check 会 reject 的事情——提前捕获省一轮返工。
- **Red-team 自检**：发布前最后一次对照，不放过任何一项。

## 与 blocking checks 的关系

| Pre-flight 项 | 对应 blocking check |
|--------------|----------------------|
| 1 SOURCES 完整 | Check 1, 10 |
| 2 独立性 | Check 10 |
| 3 单源 ≤ 40% | Check 3 |
| 4 因果纪律 | Check 11 |
| 5 比较断言 | Check 4 |
| 6 Critic 证伪 + EVIDENCE_CHAIN | —（但影响综合阶段评分） |
| 7 形式 + FIR | Check 2, 5, 6, 14 |
| 8 Skeleton 保全 | Check 7, 8, 12 |

Pre-flight 过了不保证 blocking checks 全过（例如 Check 9 Advisory Appendix 在 main agent 综合阶段才检查），但能覆盖 ~80% 的返工高发点。
