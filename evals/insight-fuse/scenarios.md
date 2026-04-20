# insight-fuse v3 Trigger Scenarios

测试 insight-fuse v3 的触发、参数路由、7 阶段流水线、14 check 执行、6 维评分、多输出渲染。

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

**Input**: `/insight-fuse "Kubernetes Autoscaling 方案选型" --type technology --outputs report,adr,poc`

**Expected**:
- Template: technology.md，含 FIR 标记 + 比例声明（10/30/35/15/10）
- Specialist 强制 ≥1 comparison matrix（无则 GAPS_IDENTIFIED 显式说明）
- 特有 check：学习/迁移/维护成本 + 锁定风险识别
- 输出 3 物件：report.md + adr.md + poc.md
- ADR 含 3 条证据每条带 URL
- PoC 假设对齐 skeleton.hypotheses + 量化成功标准

**Validates**: technology 预设 + multi-output + specialist 强制数据表

---

## Scenario 5: research-type=market

**Input**: `/insight-fuse "向量数据库市场 2026" --type market --depth deep --outputs report,decision-tree`

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

**Input**: `/insight-fuse "AI 笔记产品机会" --type product --outputs report,poc`

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

## Scenario 9: multi-output generation

**Input**: `/insight-fuse "k8s 向量化 autoscaling" --type technology --outputs report,adr,decision-tree,checklist,poc`

**Expected**:
- Stage 6 依次渲染 5 个物件
- 物件间相对路径互引
- 每物件独立文件，命名 `<slug>-<date>-<kind>.md`
- ADR 引用 report §X；decision-tree 引用 report；poc 引用 skeleton.hypotheses

**Validates**: 全部 5 种输出物 + 物件间交叉引用

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
