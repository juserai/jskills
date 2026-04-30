# insight-fuse 设计文档（v3.1）

> 版本：v3.1（v3 源可靠性增量）
> 日期：2026-04-21
> 上一版：v3.0（2026-04-20；7 阶段流水线 + 14 check）
> 上上版：v2（5 阶段流水线）位于 git 历史 `adbb208` 及之前提交

## 一、分类决策（按 CLAUDE.md §分类决策规程）

### (a) 选了什么

**`crucible`（坩埚）** — 多源融合、知识沉淀。

### (b) 为什么不是其他三类

- **非 hammer**（锤 — 施力塑形）：insight-fuse 的 OUTPUT 是**报告产出**（完整调研报告 + ADR + checklist 等），不是对 agent 的**行为指令**。hammer 的典型输出是"必须/不许做 X"（见 claim-ground、block-break），insight-fuse 不符合。
- **非 anvil**（砧 — 承托定型）：anvil 的 OUTPUT 是对**具体成品**的 **pass/fail 判定**（skill-lint 校验 skill 文件，输出 error/warning/passed）。insight-fuse 的 OUTPUT 是调研报告本身——报告是成品，不是对成品的判定。Stage 6 QA 的 14 check 是**内部质量控制**，用于驱动重写循环，不是最终输出；判定结果（Grade A/B/C/D）是报告的**附属评分块**，不独立存在。
- **非 quench**（淬火 — 冷却定性）：quench 提供辅助信息或调节节奏（news-fetch 让开发者 code 间歇浏览新闻）。insight-fuse 是**核心工作流**——一次调用可能消耗数十分钟并产出 30KB+ 内容，不是 "coding 之间的短暂休息"。

### (c) 现有兄弟

**council-fuse** — 同 `fuse` 系列，同多视角综合引擎。两者都是 crucible：council-fuse 融合 3 个 agent 的独立思辨为综合答案；insight-fuse 融合多源 + 多视角为调研报告。差异：

| | insight-fuse | council-fuse |
|---|---|---|
| 输入 | topic → WebSearch/WebFetch 主动采集 | 用户提供问题 + 上下文 |
| 阶段 | 7-stage 可配置深度 | 3-stage 固定 |
| 产出 | 调研报告（合并报告，多段落组合） | 单一综合答案 |
| 数据契约 | skeleton.yaml（v3 新）| 无 |

其他潜在兄弟：`tome-forge`（crucible）— 但 tome-forge 核心是知识库 CRUD，不做主动多源综合；和 insight-fuse 的交集是 KB 归档协议（insight-fuse Stage 6 可选归档报告到 tome-forge）。

## 二、v2 → v3 的核心架构变化

### 2.1 动机

v2（5 阶段）在 AI Native 总纲调研（670 行、49KB、100+ 引用）暴露 11 项结构性问题：

1. 人工 brainstorm 的 7 种元信息只有"sub-questions"1 种进入下游
2. Stage 1 从零扫描，浪费查询、可能偏离用户关切
3. Stage 3 → Stage 5 共识未自动传递
4. 冲突保留 vs 合成共识的界限模糊
5. 质量检查与实际验证动作脱节
6. 无业务中立性检查
7. Specialist 数据表要求软约束
8. 报告结构无黄金比例参考
9. 输出物单一（只有单份 markdown 报告，无多段落组合能力）
10. 缺 academic / product / overview 类型的预设
11. 无显式 evidence-chain 映射

### 2.2 核心变化

**一个核心 + 三层强化**：

- **一个核心**：引入 `skeleton.yaml` 作为贯穿 7 阶段的**结构化输入契约**
- **强化 1（流程）**：新增 Stage 0 (Brainstorm) + Stage 6 (QA)，共 7 阶段
- **强化 2（质量）**：14 项可执行化 check + 6 维正交评分 + A/B/C/D 等级
- **强化 3（场景）**：6 research-type 预设 + 5 段段落规范（多文件默认 / `--merge` 合并 opt-in）+ stance-override 机制

### 2.3 三层契约架构

```
Layer 1 - 骨架：skeleton.yaml 作为结构化输入契约
Layer 2 - 流水线：7 Stage，每阶段消费特定 skeleton 字段
Layer 3 - 质量尺：6 维正交评分 + 14 项 blocking check
```

## 三、设计决策

| 决策 | 选项 | 取舍理由 |
|------|------|---------|
| 分类 | crucible（多源融合产出报告）| 见 §一。OUTPUT 形态是报告产出，匹配 crucible 定义 |
| 数据契约 | YAML schema（skeleton.yaml）| 比 JSON 可读，比 TOML 成熟；schema_version 支持演进 |
| skeleton 存储 | `~/.forge/insight-fuse/skeletons/` | 遵循 CLAUDE.md §运行时约定；跨项目复用；不污染 repo |
| i18n 策略 | 全量重译 | 破坏性重构 + 7 阶段差异大；11 份人工 diff-sync 成本 > 信任模型默认；首段描述 verbatim 等于 marketplace description 作硬约束 |
| Agent 文件数 | 4 个（methodologist + generalist + critic + specialist）| stance-override 机制避免为 11 种 perspective 各建文件；与 council-fuse 的 3 agents 规模相当 |
| Stance 非文件化 | futurist/strategist/user/designer/business 等走 generalist + prompt 注入 | 灵活、可扩展；避免 agent 文件膨胀；各 stance 描述由 `references/perspectives.md` §二 Stance Registry 统一管理 |
| 向后兼容 | **不考虑** | 用户明确要求；v2 → v3 是破坏性改进；INSIGHT_RESPONSE 格式升级为 v2；所有参数语义变化 |
| FIR 主体禁 [R] | 强约束，Check 14 blocking | 环境隔离 + 主体中立的根本保障；[R] 仅允许在 Advisory Appendix（用户授权后） |

## 四、Schema 示例：skeleton.yaml

详见 `skills/insight-fuse/references/skeleton-schema.md`。核心字段：

```yaml
schema_version: 1
topic: <str>
research_type: overview|technology|market|academic|product|competitive
dimensions: [{name, rationale, weight, anchors}]
taxonomies: {<term>: <def>}
out_of_scope: [{item, reason}]
existing_consensus: [{claim, confidence, sources_hint}]
known_dissensus: [{claim, position_a, position_b}]
hypotheses: [{id, statement, falsifiability}]
business_neutral: true
```

字段 × Stage 消费矩阵（摘要，完整版见 skeleton-schema.md）：

| 字段 | Stage 0 | Stage 1 | Stage 3 | Stage 5 | Stage 6 |
|------|:-:|:-:|:-:|:-:|:-:|
| dimensions | 写 | 查询种子 | 每 agent 绑定 | 章节骨架 | Check 12 |
| out_of_scope | 写 | negative filter | Do-not-cover | — | Check 13 |
| existing_consensus | 写 | 跳过扫描 | **prior context 强制注入** | 背景引用 | — |
| known_dissensus | 写 | — | — | **自动套 Disagreement Template** | Check 12 |
| hypotheses | 写 | — | sub-question 源 | 结论分类 | 评分 |

## 五、6 维正交评分依据

6 维来自调研方法论文献的收敛——跨学术 / 产业 / 政策三大传统。每维都不是充分条件，合格报告在所有 6 维都达阈值：

| 维度 | 跨传统共识来源 |
|------|---------------|
| falsifiability | Popper 划界标准；SEP 哲学百科目录 |
| evidence_density | VTPI 研究质量框架；每实证主张可追溯 |
| reproducibility | OSIRIS 32 项共识；PLOS Biology 可复现声明 |
| source_diversity | 新闻业"三支柱"（文档+访谈+观察）；systematic review 跨库搜索 |
| actionability | GAO evidence-based policymaking；decision-usefulness |
| transparency | 跨圈一致的三底线（方法、局限、利益）|

权重分 academic vs industry 两档的理由：学术圈把方法学严谨性放第一（Frontiers on Research Metrics），产业圈把 decision-usefulness 放第一（Gartner/McKinsey 评价标准）。insight-fuse 的 `--type=academic` 对应前者，其余 type 对应后者。

## 六、14 Check 出处

| # | Check | 理论 / 实务出处 |
|---|-------|--------------|
| 1 | Source density | APA 7th 每断言内联引用规范 |
| 2 | Reference integrity | Chicago Notes-Bibliography |
| 3 | Source diversity | Bellingcat 独立性要求；40% 阈值经验值 |
| 4 | Evidence-backed | UNC Writing Center 反归纳跳跃 |
| 5 | Date line | SEC Inline XBRL live-reporting 时代规范 |
| 6 | Attribution | COPE AI 披露要求 |
| 7 | Environment isolation | insight-fuse 独立性原则 |
| 8 | Neutral body | Minto 治理句（Findings vs So-What） |
| 9 | Advisory Appendix | 授权分离原则（作者 vs 建议者）|
| 10 | Source independence | Denzin 1978 triangulation；Wirecard / Theranos 反例 |
| 11 | Causal discipline | Pearl Book of Why do-calculus；UNC Fallacies |
| 12 | **Framework preservation**（v3）| 调研方法论 §反模式"取平均" vs disagreement preservation |
| 13 | **Structure-ratio compliance**（v3）| 技术调研黄金比例 10/30/35/15/10；USC executive summary 10% 规则 |
| 14 | **FIR separation**（v3）| Fact / Inference / Recommendation 三层（方法论 §5.7） |

## 七、实施步骤（7 phase）

所有 phase 的详细步骤 + verify 命令记录在计划文档 `/home/juserch/.claude/plans/skill-skill-optimized-honey.md` 与 `/home/juserch/iuser/bin/X/docs/insight-fuse/insight-fuse-v3-refactor-plan.md`。

| Phase | 范围 | Verify |
|-------|------|-------|
| 1 | References foundation（8 files + delete scope-boundaries.md）| skill-lint（warning 允许）|
| 2 | Agents + templates（4 + 12 files）| skill-lint + 文件数 |
| 3 | SKILL.md 重写 | skill-lint PASS + 行数 |
| 4 | Marketplace hash + platform mirror | diff -rq 零输出 + hash 匹配 |
| 5 | Evals 扩到 13 check + 12 scenarios | run-trigger-test.sh PASS |
| 6 | Docs EN + design | 本文件 + guide |
| 7 | i18n（11 份 guide 重译 + 11 份 README 同步）| grep 计数 + skills-8-blue badge |

## 八、回归验证对照

重跑 v3 `/insight-fuse "AI Native：全景认知、判别框架与演进趋势" --type overview --depth full`，对照 v2 产出的 `docs/research/ai-native-overview.md`：

| 维度 | v2 | v3 预期 |
|------|-----|--------|
| 章节一致度 | baseline | ≥ 85% |
| critic 段落保留度 | baseline | ≥ baseline（Disagreement Preservation 强化）|
| 引用源数量 | baseline（32）| ≥ baseline |
| 人工对齐轮数 | 3-4 轮 | ≤ 2 轮（Stage 2/4 超时自动降级）|
| Stage 3 prompt token | baseline | -20~30%（prefix cache）|
| 14 check 通过率 | n/a（v2 为 11 check）| ≥ 90% |
| 6 维 Grade | n/a | B 或以上 |

## 九、风险与缓解

| 风险 | 缓解 |
|------|------|
| marketplace hash 与 SKILL.md 不同步 | Phase 4 的 hash 验证卡住，必须命中才进入下 phase |
| platform mirror drift | 每 phase 结尾 `diff -rq` 卡点 |
| i18n 全量重译质量不一 | 首段描述 verbatim 等于 marketplace description 作硬约束；zh-CN / ja / ko 优先 spot-check |
| FIR 主体误标 [R] | Check 14 blocking + 模板默认 `[F]`/`[I]` 标记，无 `[R]` 占位 |
| Stage 0 交互增加总耗时 | quick/standard 默认自动 skeleton 不交互；只 deep/full 交互 |
| skeleton.yaml schema 演进 | `schema_version: 1` + 迁移注记章节兜底 |

## 十、扩展点

- **新 research_type**：在 `references/research-types.md` 新增预设 + `templates/<type>.md` + evals 场景
- **新 check**：从 15 起追加到 `quality-standards.md`；verify shell 命令必填
- **新 output format**：新增 `templates/<section>.md` + `references/output-formats.md` 登记
- **新 stance**：在 `references/perspectives.md` §二 Stance Registry 追加；无需新 agent 文件
- **新 perspective**（真正的新角色，如 academic-reviewer）：才值得新建 `agents/insight-<name>.md`

## 十一、v3 → v3.1 增量：源可靠性（2026-04-21）

### 11.1 触发事件

2026-04-20 AI Native 合并报告 §6.1 数据错误：声明 "Q1 2026 VC $300B / AI $242B / 65% 被 4 家基础模型公司吸收（含 Waymo）"，真实数据是 $239B / 81% / Waymo 非基础模型。根因是二手博客（TheBranx）被当一手引用，且整个流水线无主/次源区分。完整事件见 `~/.claude/plans/indexed-strolling-finch.md`。

### 11.2 四层根因

| 层 | 症结 | v3 现状 | v3.1 补丁 |
|---|---|---|---|
| L1 信息入口 | Stage 1 返回跨源糊合摘要，不标 primary URL + verbatim | 只按 dimension 拆，不筛 tier | §4.1 Weak-citation protocol：量化声明需非聚合页 + verbatim + 白名单 |
| L2 引用标注 | 正文插入只挂单一 URL，无主/次源区分 | `[Name](url)` 单一形式 | §3.3 升级语法：`{P}` / `{S→primary-url}` |
| L3 QA 拦截 | 14 check 无"一手源必要性"条目 | C1-C14 | 新增 C15（主源绑定）+ C16（verbatim）+ C17（数字调和） |
| L4 扩散治理 | 合并/wiki 各自复制数字，修订手工逐层 | 无机制 | v3.1 未包含；P2/P3 工作（claims.yaml sidecar / fact-nodes 图）留给后续 |

### 11.3 设计决策

#### (a) 分类：保持 crucible

Check 15-17 看起来像"验证"，但其 OUTPUT 仍是**报告产出**（带新字段的报告），不是对报告的 pass/fail 判定外置。Stage 6 QA 仍是内部质控循环，与 v3 分类决策一致。不重新归 anvil。

#### (b) 契约进源 vs override

走"选项 A"：C15/C16/C17 契约定义 + 白名单 schema + reconciliation 模板全进 `skills/insight-fuse/references/` 与 `templates/`。**不开 `~/.forge/insight-fuse/overrides/` 通道**——本次目标是优化插件本身，所有 forge 用户直接受益；用户本地的可覆盖空间暂未开放，留给未来版本（若出现"按行业定制白名单"的强烈需求）。

#### (c) 分档执行（#18 横切）

三条新 check 全部 blocking 会让 `quick` 模式失去"快速探索"价值、也让 overview 类通用调研过度拘束。采用 `--type × --depth` 矩阵（详见 [references/research-types.md](../../skills/insight-fuse/references/research-types.md) §源可靠性分档）：

- `market` / `academic` 一律 blocking——钱流数字与学术声明口径刚性
- `quick` 对非 market/academic advisory——探索不被刚性阻塞
- `standard` C15 起步 blocking——最廉价的一道闸
- `deep` / `full` 全刚性——深度预算匹配高质量阈值

#### (d) 白名单不是封闭名单

未命中白名单的域名**不立即拒**，降一级 + 标 `tier-uncertain`。防止封闭白名单冻结新一手源（如新兴数据提供商）。完整规则见 [references/primary-source-whitelist.yaml](../../skills/insight-fuse/references/primary-source-whitelist.yaml)。

#### (e) 为什么 verbatim 比 URL 可达重要

AI 幻觉最隐蔽的失效模式：URL 真实存在但内容不支持声明（content_support='inferred' 的陷阱）。人工 spot-check 一份报告若只能点 URL 逐条验证，成本过高；而紧邻声明的 `> 原文："..."` 块让验证成本降到 30 秒 per 声明。

### 11.4 落地范围（2026-04-21）

- skill 源：6 个文件（4 改 + 2 新）
- platforms/openclaw：7 个文件同步（含 SKILL.md）
- marketplace.json：SHA-256 重算 + version 3.0.0 → 3.1.0 + description 更新
- evals：scenarios.md 新增 5 场景（#13-#17）
- user-guide + 11 i18n：下一批
- 设计文档：本章

### 11.5 未落地项（P2/P3 留给未来）

- `tools/triangulate.py` 跨源三角验证自动化
- `claims.yaml` sidecar + `[#claim-id]` 语法
- `expires_at` + 到期复查自动化
- 二手源黑名单 `secondary-source-blacklist.yaml`（TheBranx 种子）
- Fact-provenance 图 `fact-nodes/<id>.yaml`（全库 single-source-of-truth）

任何一项激活前需在本文档追加 11.6 / 11.7... 子节，保留设计轨迹。

### 11.6 验证路径

- `bash skills/skill-lint/scripts/skill-lint.sh .` → 0 error 0 warning（SHA / platform-parity / i18n-structure / cross-skill-category 4 防线）
- `bash evals/insight-fuse/run-trigger-test.sh` → 13/13 passed
- negative test（scenarios #13-#17）需在真实调研中触发验证——首个 market / academic 调研即是第一个真实 case

---

## 参考

- v3 实施计划：[/home/juserch/.claude/plans/skill-skill-optimized-honey.md](/home/juserch/.claude/plans/skill-skill-optimized-honey.md)
- v3 重构方案：[/home/juserch/iuser/bin/X/docs/insight-fuse/insight-fuse-v3-refactor-plan.md](/home/juserch/iuser/bin/X/docs/insight-fuse/insight-fuse-v3-refactor-plan.md)
- 分析文档汇总：`/home/juserch/iuser/bin/X/docs/insight-fuse/`（6 份，165KB）
- v3.1 源可靠性 policy 原件：[~/.claude/plans/indexed-strolling-finch.md](~/.claude/plans/indexed-strolling-finch.md)
