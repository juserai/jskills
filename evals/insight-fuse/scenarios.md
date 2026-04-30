# insight-fuse v3 Trigger Scenarios

测试 insight-fuse v3 的触发、参数路由、8 阶段流水线、14 check 执行、6 维评分、多文件 / `--merge` 段落渲染。

## Scenario 1: Brainstorm-only (Stage 0 solo)

**Input**: `/insight-fuse "AI 眼镜" --depth quick --skeleton auto`

**Expected**:
- Stage 0 `insight-methodologist` 被 spawn
- 生成 `~/.forge/insight-fuse/skeletons/ai-yan-jing-<date>.yaml`（schema_version: 1）
- skeleton 含 dimensions (3-7 条) + out_of_scope + 至少 1 条 hypotheses
- Self-review 4 项通过
- Stage 1 扫描 + Stage 6 QA 后输出 quick 报告 + checklist
- quick 模式不交互

**Validates**: Stage 0 独立可用；auto 模式无用户干预

---

## Scenario 2: Skeleton import (`--skeleton <path>`)

**Input**: `/insight-fuse "AI Native 金融" --skeleton /tmp/ai-native-fin.yaml --depth standard`

**Pre-condition**: /tmp/ai-native-fin.yaml 存在且 schema_version 为 1

**Expected**:
- Stage 0 跳过（导入模式），直接 Stage 1
- main agent 校验 schema；schema_version 不匹配 → 报错并停止
- Stage 1 query 基于导入的 skeleton.dimensions 派生
- `existing_consensus` 覆盖区不重复扫描

**Validates**: 骨架导入场景，团队共享工作流

---

## Scenario 3: research-type=overview

**Input**: `/insight-fuse "AI Native：全景认知、判别框架与演进趋势" --type overview --depth full`

**Expected**:
- Stage 0 full 模式交互 5 问 + 2-3 候选骨架 + section approval
- Default perspectives: generalist + critic + specialist
- Default template: meta-overview.md
- Stage 5 对 `known_dissensus` 每项自动套 Disagreement Preservation Template
- 报告章节含定义/判别/驱动/全景图谱/代表玩家/格局启示
- 6 维评分按 industry 权重

**Validates**: overview type 预设 + Disagreement Preservation + meta-overview template

---

## Scenario 4: research-type=technology

**Input**: `/insight-fuse "Kubernetes Autoscaling 方案选型" --type technology --sections report,adr,poc`

**Expected**:
- Template: technology.md，含 FIR 标记 + 比例声明（10/30/35/15/10）
- Specialist 强制 ≥1 comparison matrix（无则 GAPS_IDENTIFIED 显式说明）
- 特有 check：学习/迁移/维护成本 + 锁定风险识别
- 在 `<slug>-<date>/` 目录下落 3 个独立 markdown：`report.md`（携 frontmatter）+ `adr.md` + `poc.md`
- ADR 含 3 条证据每条带 URL
- PoC 假设对齐 skeleton.hypotheses + 量化成功标准
- 归档日志：单行 `Archived to KB: {abs_path_to_report.md}`

**Validates**: technology 预设 + 默认多文件输出 + specialist 强制数据表

---

## Scenario 5: research-type=market

**Input**: `/insight-fuse "向量数据库市场 2026" --type market --depth deep --sections report,decision-tree`

**Expected**:
- Perspectives: generalist + specialist + futurist（futurist 走 stance-override）
- Template: market.md
- 特有 check：必含 TAM/SAM/SOM 之一 + CAGR
- Decision tree 含 ≥2 层分支 + 量化条件阈值 + 叶子适用边界
- futurist stance 在 3-5 年趋势部分明显

**Validates**: market 预设 + stance-override + decision-tree 输出

---

## Scenario 6: research-type=academic

**Input**: `/insight-fuse "Sparse MoE 可解释性" --type academic --depth deep`

**Expected**:
- Perspectives: generalist + critic + methodologist
- Template: academic.md（IMRaD 结构）
- L5 来源权重归零（academic 硬约束）
- 每断言溯源到一手论文 + DOI/arXiv ID
- methodologist Stage 5 出现（方法学审查）
- 6 维评分按 academic 权重（falsifiability 0.25 + reproducibility 0.20 加权高）

**Validates**: academic 预设 + methodologist agent + academic 权重

---

## Scenario 7: research-type=product

**Input**: `/insight-fuse "AI 笔记产品机会" --type product --sections report,poc`

**Expected**:
- Perspectives: user + designer + business（三者都走 stance-override，无独立 agent 文件）
- Template: product.md（JTBD + solution fit + wedge）
- 必含 user quote 或 journey map
- PoC 模板从 hypotheses 抽取验证目标

**Validates**: product 预设 + 三个 stance-override + PoC 生成

---

## Scenario 8: research-type=competitive

**Input**: `/insight-fuse "AI Coding 赛道竞品" --type competitive --audience "新入局者" --strategy aggressive`

**Expected**:
- Perspectives: generalist + critic + strategist
- Template: competitive.md（SWOT + 定位矩阵 + 护城河）
- SWOT 四象限齐全（check）
- 定位矩阵 ≥2 轴（check）
- 护城河 ≥2 类识别（check）
- Advisory Appendix A（针对"新入局者"）渲染，6 节结构齐全
- §4 策略梯度表 aggressive 列标推荐

**Validates**: competitive 预设 + Advisory Appendix + Check 9 + strategy 参数

---

## Scenario 9: multi-section default (multi-file output)

**Input**: `/insight-fuse "k8s 向量化 autoscaling" --type technology --sections report,adr,decision-tree,checklist,poc`

**Expected**:
- Stage 6 渲染 5 个独立 markdown 文件到 `<slug>-<date>/` 目录
- 仅 `report.md` 携带 frontmatter（含 `outputs: [report, adr, decision-tree, checklist, poc]` 列兄弟文件）
- 其他 4 个文件无 frontmatter，相对链接互引（不改写为锚点）
- 归档日志：单行 `Archived to KB: {abs_path_to_report.md}`

**Validates**: 默认多文件模式 + 5 段全产出 + frontmatter 仅落 report.md

---

## Scenario 9b: --merge opt-in (single-file output)

**Input**: `/insight-fuse "k8s 向量化 autoscaling" --type technology --sections report,adr,decision-tree,checklist,poc --merge`

**Expected**:
- Stage 6 按依赖顺序拼接为**单份**合并 markdown，命名 `<slug>-<date>.md`
- H1 降级生效：合并文件唯一 H1 来自 report 段；非 report 段原 H1 → H2 续编号 `§N+1`、`§N+2`…，段内 H2→H3、H3→H4 级联
- 模板中相对链接（如 "基于：<report.md link>"）改写为段内锚点 `(见上文 §X)`
- frontmatter 落在合并文件头（含 `outputs: [report, adr, decision-tree, checklist, poc]`）
- 归档日志：单行 `Archived to KB: {abs_path_to_merged.md}`

**Validates**: `--merge` 合并行为 + H1 降级算法 + 段间引用改写

---

## Scenario 10: depth routing matrix

**Input**:
- `/insight-fuse "X" --depth quick`
- `/insight-fuse "X" --depth standard`
- `/insight-fuse "X" --depth deep`
- `/insight-fuse "X" --depth full`

**Expected per depth**:

| `--depth` | 应跑阶段 | 不应跑 | 交互 |
|-----------|---------|--------|------|
| quick | 0, 1, 6 | 2, 3, 4, 5 | 否 |
| standard | 0, 1, 3, 6 | 2, 4, 5 | 否 |
| deep | 0, 1, 3, 5, 6 | 2, 4 | focus selection |
| full | 0-6 全跑 | — | Stage 0/2/4 gate |

**Validates**: depth 路由矩阵正确

---

## Scenario 11: QA stage blocking (14 check)

**Input**: 喂入一个故意无来源、无 FIR 标记、合成 known_dissensus 的报告片段，触发 Stage 6 QA

**Expected fail**:
- Check 1 (source density) fail — 段落无 citation
- Check 12 (framework preservation) fail — known_dissensus 被合成而非三段式
- Check 14 (FIR separation) fail — 段落无 [F]/[I] 标记
- 第 1 轮重写 → 仍有 Check 14 fail → 第 2 轮重写 → 通过
- 或：3 轮后仍失败 → 输出标 `QA-FAILED: <check-ids>` header

**Validates**: 14 check blocking + 重写循环 + 最终降级

---

## Scenario 12: edge cases combined

**Input**: `/insight-fuse "X" --depth full --timeout-seconds 5`

**Expected**:
- Stage 2 gate 5 秒超时 → `assumption: auto-confirmed` flag 写入
- Stage 4 5 秒超时 → 自动选"分歧势能:高 + 方法学风险:高"焦点
- 所有来源都是 L5 → Accuracy ≤ 4 封顶 → 6 维 source_diversity 低分 → Grade C 或 D
- `known_dissensus` 中一项来源全部追溯到 McKinsey 同一报告 → Check 10 独立性声明声明"有效独立来源 = 1" → Check 3 视为单源占比 100% → fail
- 因果关键词"导致" + 无替代解释 → Check 11 fail

**Validates**: 超时降级 + L5 封顶 + 伪三角 + 因果纪律

---

## Scenario 13: C15 primary-source binding fail（v3.1）

**Input**: `/insight-fuse "Q1 2026 全球 AI 融资" --type market --depth standard`

**Pre-condition**: 模拟 Stage 3 Generalist 返回的 INSIGHT_RESPONSE 中 EVIDENCE_CHAIN 含量化声明 "$300B"，其 support[] 只有 `thebranx.com`（L5，非白名单）。

**Expected**:
- Stage 6 Check 15 fail（market + standard 为 blocking）
- 重写 round 1：main agent 触发 WebFetch 尝试找到一手源（Crunchbase News / CB Insights / SEC）
- 成功：support[] 增加 L1 源 + URL 命中 `news.crunchbase.com`（white list market L1）→ C15 pass
- 失败场景：重写后仍无 L1 → 第 2 轮降级为定性 "AI 领域资金规模显著" → C15 pass（因不再是量化声明）
- Grade 评分：primary_source_ratio 子项低时 evidence_density 降级

**Validates**: Check 15 blocking；白名单匹配；降级路径

---

## Scenario 14: C16 verbatim evidence fail（v3.1）

**Input**: 手工构造一份含量化声明 "Ray-Ban Meta 2024 销量 > 100 万副" 但 SOURCES_USED 缺 `quote:` 字段的 Stage 3 响应

**Expected**:
- Stage 6 Check 16 fail（deep/full 为 blocking；standard 为 advisory 但扣分）
- 重写 round 1：main agent 对该 source URL 跑 WebFetch，从返回 HTML 中提取含 "100 万" 或 "1 million" 的句子
- 成功：quote 回填到 SOURCES_USED + 正文该段下紧邻 `> 原文："..." — Meta 10-Q, 2024-11-XX` → C16 pass
- 失败（URL 不可达）：content_support 改 `placeholder` + 登记 GAPS_IDENTIFIED + 量化声明降级或整段删除

**Validates**: Check 16；WebFetch 回填；placeholder 降级路径

---

## Scenario 15: C17 numeric variance reconciliation（v3.1）

**Input**: `/insight-fuse "Q1 2026 全球 VC 总额" --type market --depth deep`

**Pre-condition**: Stage 3 收集到两条 L1 冲突：Crunchbase News "$239B" vs CB Insights "$285.5B"（差异 ≈ 19%）。

**Expected**:
- Stage 6 检测 support[] 数字差异 > 5% → Check 17 触发
- 自动套 [templates/reconciliation-log.md](../../skills/insight-fuse/templates/reconciliation-log.md) 生成 "附录 R-1"
- Tiebreak：按较保守值 $239B 采用（Crunchbase 排除 M&A）
- 正文该段 `{P}` 引 Crunchbase News，CB Insights 以 `{S→crunchbase-news-url}` 作口径佐证
- 附录含 3 列（URL / Tier / 原文数字 / 检索日期 / 口径） + "采用值" 明示 + "差异说明" 段

**Validates**: Check 17；Reconciliation log 模板；一手 tiebreak；多 L1 不同口径处理

---

## Scenario 16: C15-C17 分档 advisory（v3.1）

**Input**: `/insight-fuse "xR 硬件概览" --type overview --depth quick`

**Pre-condition**: 同 Scenario 13 的弱引用场景（L5 为主）。

**Expected**:
- overview + quick 对 C15/C16/C17 全 advisory
- Stage 6 检测到 C15 fail，但**不封顶 Grade**；在 header 标 `C15-ADVISORY`
- evidence_density 维度得分扣分（primary_source_ratio 低）
- Grade 照算，可能落 C 但不强制 D

**Validates**: 分档策略；advisory 不封顶；quick 模式不被刚性源要求阻塞

---

## Scenario 17: market/academic 一律 blocking（v3.1）

**Input**:
- `/insight-fuse "Sparse MoE 可解释性" --type academic --depth quick`
- `/insight-fuse "向量数据库市场 2026" --type market --depth quick`

**Expected**:
- 两个调用即使 `--depth quick`，C15 / C16 / C17 仍 blocking（覆盖 quick 的默认 advisory）
- academic：所有量化声明 support 必含 arxiv.org / doi.org / 期刊域名；否则 C15 fail
- market：所有金额 / 百分比 support 必含 news.crunchbase.com / pitchbook.com / cbinsights.com / sec.gov 之一；否则 C15 fail

**Validates**: 分档表"market/academic 行覆盖 quick 列" 的硬约束
