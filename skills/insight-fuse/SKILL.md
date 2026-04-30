---
name: insight-fuse
description: "Insight Fuse v3.3 — Systematic multi-source research engine. 8-stage pipeline (Stage 7 KB archival mandatory + observable, opt-out via --no-save) with skeleton.yaml data contract, 6 research-type presets, 6-dim quality rubric, and 5-section multi-file output (--merge for single-file)."
license: MIT
user-invokable: true
metadata:
  category: crucible
  permissions:
    network: true
    filesystem: read-write
    execution: none
    tools: [WebSearch, WebFetch, Agent, Read, Write, Bash]
argument-hint: "[topic] [--type overview|technology|market|academic|product|competitive] [--depth quick|standard|deep|full] [--skeleton path|auto|skip] [--perspectives p1,p2,p3] [--sections report,checklist,adr,decision-tree,poc] [--merge] [--focus q] [--audience role] [--strategy c|b|a] [--no-advisory] [--no-save]"
---

# Insight Fuse v3.3 — 系统化多源调研熔炼引擎

从主题到专业调研报告的 8 阶段流水线（v3.2 新增 Stage 7 — KB 归档：必须执行 + 可见日志，`--no-save` 显式 opt-out）。**skeleton.yaml 作为结构化数据契约**贯穿全程 + **6 维正交评分 + 17 项 blocking check**（v3.1 新增 C15 主源绑定 / C16 verbatim 证据 / C17 数字调和）作为质量尺 + **6 research-type 预设** 覆盖场景差异 + **5 段可选组合**：v3.3 默认每段独立 markdown 文件多文件交付，需要单文件请加 `--merge`。

## Help

当第一参数为 `help` / `--help`，**或无参数**时，输出以下 help card 并停止执行（parsing 规则详见 [CLAUDE.md § Help 模式约定](../../CLAUDE.md)）：

```
Insight Fuse — Systematic multi-source research engine (8-stage pipeline)

Usage:
  /insight-fuse <topic> [--type ...] [--depth ...] [...other flags]   Run research
  /insight-fuse help                                                   Show this help

Key flags:
  --type     overview | technology | market | academic | product | competitive
  --depth    quick | standard | deep | full
  --sections report,checklist,adr,decision-tree,poc  (each section → own file by default)
  --merge    concatenate selected sections into a single markdown (opt-in)

Examples:
  /insight-fuse Kubernetes operators --type technology --depth standard
  /insight-fuse "RAG vs fine-tuning" --type academic --depth deep
  /insight-fuse "pricing in LLM coding tools" --type market --sections report,checklist
  /insight-fuse "k8s autoscaling" --type technology --sections report,adr --merge

Full flag reference: see frontmatter argument-hint.
Guide: docs/user-guide/insight-fuse-guide.md
```

## Scope Isolation（强制约束）

insight-fuse 是**独立**调研工具。每次调用从零开始。运行时**只使用**：

- 用户消息中显式提供的 topic 与参数
- WebSearch/WebFetch 抓取的公开来源
- `skeleton.yaml`（Stage 0 产出或 `--skeleton <path>` 导入）

运行时**不使用** CWD / 附加目录 / IDE 打开文件 / CLAUDE.md / 对话中的项目上下文。例外：`--audience` / `--focus` 参数值作为用户显式授权记入 Appendix。详见 [references/research-protocol.md](references/research-protocol.md) §十。

## 参数

| 参数 | 必需 | 默认 | 说明 |
|------|------|------|------|
| topic | 是 | — | 调研主题 |
| `--type` | 否 | overview | overview / technology / market / academic / product / competitive（6 预设）|
| `--depth` | 否 | standard | quick / standard / deep / full |
| `--skeleton` | 否 | auto | `<path>` 导入 / `auto` Stage 0 自动 / `skip` 跳过（仅 quick/standard）|
| `--perspectives` | 否 | 从 --type 预设 | 逗号分隔视角列表，2-5 个 |
| `--sections` | 否 | 从 --type 预设 | report / checklist / adr / decision-tree / poc。默认每段输出为独立 markdown 文件 |
| `--merge` | 否 | false | 把选中的 sections 拼接为单一合并 markdown（H1 降级 + 续编号规则见 [references/output-formats.md](references/output-formats.md)）|
| `--focus` | 否 | — | Stage 5 显式锚点；未指定时 deep 必须用户选，full 自动推荐 |
| `--audience` | 否 | — | 多值逗号分隔；触发 Advisory Appendix |
| `--strategy` | 否 | balanced | conservative / balanced / aggressive，仅 Appendix 生效 |
| `--no-advisory` | 否 | false | 显式关闭 advisory，即 full 模式也不问 |
| `--no-save` | 否 | false | 跳过 KB 归档，仅控制台输出 |
| `--timeout-seconds` | 否 | 300 | Stage 2/4 交互超时；超时自动降级 |

## 工作流（8 阶段）

```
Stage 0 → 1 → 2 → 3 → 4 → 5 → 6 → 7
Brainstorm Scan Align Research Review Deep QA  Archive
(skeleton)                              (17 check (必须+
                                         + 6-dim   可观察)
                                         + multi-out)
```

### 深度路由

| `--depth` | 跑的阶段 | Stage 0 行为 | 交互 gate |
|-----------|---------|-------------|----------|
| quick | 0*, 1, 6, 7 | auto skeleton | 无 |
| standard（默认） | 0*, 1, 3, 6, 7 | auto skeleton | 无 |
| deep | 0, 1, 3, 5, 6, 7 | auto 或 `--skeleton` 导入 | focus selection（若无 `--focus`） |
| full | 0, 1, 2, 3, 4, 5, 6, 7 | interactive 5 问 + 2-3 候选 + section approval | Stage 0 user gate + Stage 2 + Stage 4 |

Stage 7 在所有 depth 下都执行；`--no-save` 时进入但立即输出 skip 行（见 Stage 7 规范）。

**源可靠性分档**：Check 15-17 按 `--type` × `--depth` 组合决定 `blocking` / `advisory`，见 [references/research-types.md](references/research-types.md) §源可靠性分档。`market` / `academic` 一律 blocking；`quick` 模式对其他 type 全 advisory。

`*` `--skeleton skip` 仅 quick/standard 生效；deep/full 强制 Stage 0。

### Stage 0 — Brainstorm

Spawn `insight-methodologist` sub-agent。构造 `~/.forge/insight-fuse/skeletons/<slug>-<date>.yaml`（schema 见 [references/skeleton-schema.md](references/skeleton-schema.md)）。

- **full**：5 固定多选问题（dimensions / taxonomies / out_of_scope / consensus+dissensus / hypotheses+priority）→ 提出 2-3 候选骨架 → 7 字段逐个 section approval → self-review（4 项）→ user gate
- **quick/standard**：基于 topic + type preset 自动生成 + self-review，不交互
- **`--skeleton <path>` 导入**：读取并校验 schema_version

### Stage 1 — Scan

- 每 `skeleton.dimensions[]` 一条 WebSearch（不是每 sub-question）
- `skeleton.existing_consensus` 覆盖区不扫描
- `skeleton.out_of_scope` 作 negative filter
- 输出：初步简报 + 按 dimension 的来源分布 + **覆盖缺口声明**（见 [research-protocol.md](references/research-protocol.md) §四）
- 子问题通过 4 项 quality gates（信息增益 / 可调查性 / 维度一致性 / 独立性）
- 若 `--depth quick`：按 template 生成快速报告，跳 Stage 2-5 直接 Stage 6

### Stage 2 — Align（full only）

展示简报 + 骨架对照表。Main agent 问 3 个定向问题：keep/cut dimensions？adjust hypotheses？raise known_dissensus？。`--timeout-seconds` 超时 → 自动接受并标 `assumption: auto-confirmed`，继续 Stage 3。

### Stage 3 — Research

Per `skeleton.hypotheses[]`（或子问题）spawn 1 Generalist agent，**并行**。每 agent prompt 以**不可变 skeleton 块**起头（prefix cache 跨 agent 共享，节省 ~50% token），再拼 hypothesis-specific ask。

- 每 agent 读 [agents/insight-generalist.md](agents/insight-generalist.md) + [references/research-protocol.md](references/research-protocol.md)
- 输出 INSIGHT_RESPONSE 之前默读 [references/pre-flight-checklist.md](references/pre-flight-checklist.md)（8 项自检）
- 收集所有 INSIGHT_RESPONSE v2 块，按 `--type` 对应 template 编排标准报告
- 若 `--depth standard`：直接 Stage 6

### Stage 4 — Review（full only）

展示标准报告 + Focus Selection Protocol（见 [research-protocol.md](references/research-protocol.md) §六）：按 4 信号（分歧势能 / 方法学风险 / 决策权重 / 可证伪）打分候选焦点，**附质量信号摘要**。`skeleton.known_dissensus` 项自动入选 P0 标"预知分歧"。用户裁剪；`--timeout-seconds` 超时自动选所有"分歧势能:高 + 方法学风险:高"。

### Stage 5 — Deep Dive

每焦点 spawn `--perspectives` 指定的 3 agents（默认从 `--type` 预设）。焦点 ≤5 全并行；>5 分批每批 ≤15 agents，批次间 main 做中间总结。

- Agent 1 — Generalist（sonnet）
- Agent 2 — Critic（opus）
- Agent 3 — Specialist / Methodologist / custom stance（sonnet）

每 prompt 格式：

```
You are a research team member investigating this focus:
<focus question>

Skeleton prior context:
<verbatim skeleton.yaml>

Read references/research-protocol.md for INSIGHT_RESPONSE v2 format.
If this focus hits skeleton.known_dissensus[i], you MUST render
templates/disagreement-preservation.md (立场 A / 立场 B / 综合判断).
Synthesis prohibited.

<stance-override block if custom perspective>
<agents/*.md role directives>
```

焦点命中 `skeleton.known_dissensus` → Critic **强制套** [templates/disagreement-preservation.md](templates/disagreement-preservation.md)。Check 12 blocking 扫此模式。焦点间串行，视角内并行。收集后按 [references/perspectives.md](references/perspectives.md) 匿名评分综合。

### Stage 6 — QA

纯内部，无 WebSearch。

1. 跑 17 项 blocking check（见 [references/quality-standards.md](references/quality-standards.md)），其中 C15-C17 按源可靠性分档执行（blocking / advisory）
2. 算 6 维评分（见 [references/scoring-rubric.md](references/scoring-rubric.md)），按 `--type` 加权；evidence_density 含 `primary_source_ratio` 子项
3. 若触发 Check 17 → 套 [templates/reconciliation-log.md](templates/reconciliation-log.md) 写入附录
4. 按 `--sections` 渲染段落（详见 [references/output-formats.md](references/output-formats.md)）：
   - **默认（无 `--merge`）**：每个段落独立渲染为一个 markdown 文件（`report.md` / `adr.md` / `checklist.md` / `decision-tree.md` / `poc.md`），落同一目录
   - **`--merge`**：按依赖顺序拼接（report → checklist → adr → decision-tree → poc）为单一 markdown，report 段 H1 作为文档唯一 H1，其余段 H1 降为 H2 并续编号 `§N+1`、`§N+2`…，段内 H2→H3、H3→H4 级联降一级
5. 渲染至用户响应（始终可见，多文件模式按依赖顺序贴出每段全文） + forge attribution；持久化由 Stage 7 负责

任一 blocking check 失败 → 重写目标 section，重查，最多 2 轮；第 3 轮仍失败 → 输出并标 `QA-FAILED: <check-ids>` header（advisory 级失败标 `<id>-ADVISORY`，不封顶 Grade）。

### Advisory Rendering（章节级）

主体完成后按触发矩阵决定是否追加 Advisory Appendix。详见 [references/research-protocol.md](references/research-protocol.md) §七。

| `--depth` | `--audience` | `--no-advisory` | 行为 |
|-----------|------------|---------------|------|
| 任意 | 给了 | — | 主体 + 每受众一个 Appendix（A/B/C...）|
| full | 没给 | false | 主体完成后交互询问（候选角色白名单见 quality-standards.md）|
| 非 full | 没给 | false | 主体末尾一行提示命令，不主动问 |
| 任意 | 没给 | true | 主体，零 Advisory |

### Stage 7 — KB 归档（必须，除非 --no-save）

Stage 6 渲染完成（含 Advisory Appendix 若有）后、最终 forge attribution 行之前，**必须**执行归档。这是工作流的一部分，不是事后想起来的可选项。

1. 读取 tome-forge 的归档协议文件 `skills/tome-forge/references/report-archival-protocol.md`
   - 文件存在 → 进入步骤 2
   - 文件不存在 → 输出 `Archive: skipped (tome-forge not installed)` 并跳过 Stage 7
2. 按协议执行 KB Discovery：
   - 命中 → 进入步骤 3
   - 未命中（CWD 既不在 KB 内、`~/.tome-forge/.tome-forge.json` 也不存在）→ 输出 `Archive: skipped (KB discovery failed)` 并跳过
3. 写盘（命名规则见 [references/output-formats.md](references/output-formats.md) §文件命名）：
   - **默认（多文件）**：在 `{kb_root}/raw/reports/insight-fuse/{YYYY-MM-DD}-{topic-slug}/` 目录下落 N 个段落文件，**仅 `report.md` 携带 frontmatter** 作为本次调研的规范 KB 条目；其余段落（`adr.md` / `checklist.md` / …）作为兄弟文件无 frontmatter
   - **`--merge`**：单一合并 markdown 落在 `{kb_root}/raw/reports/insight-fuse/{YYYY-MM-DD}-{topic-slug}.md`，该文件本身即规范 KB 条目，frontmatter 写在文件头
   
   两种模式下规范 KB 条目的 frontmatter 元数据相同：
   - `topic`：用户原始 topic
   - `type`：研究类型（overview / technology / market / academic / product / competitive）
   - `depth`：调研深度（quick / standard / deep / full）
   - `skeleton`：skeleton.yaml 路径或 `auto`
   - `perspectives`：实际启用的视角列表
   - `outputs`：本次输出涉及的段落列表（如 `[report, adr, checklist]`）。多文件模式下指兄弟文件；`--merge` 模式下指合并文件内含段落
   - `top_sources`：top 5 URL
   - `grade`：6 维评分综合等级
   - `blocking_checks_passed`：通过的 blocking check id 列表
4. **必须输出可见日志行**（这一行须出现在用户可见的最终响应里，不能藏在 tool result 里）。无论多文件或 `--merge` 模式，日志均**单行**指向规范条目的绝对路径：
   - 成功：`Archived to KB: {absolute_filepath_of_canonical_entry}`（多文件 → `report.md` 路径；merge → 合并文件路径）
   - 用户传 `--no-save`：`Archive: skipped (--no-save flag)`
   - 其他跳过场景：见步骤 1/2

`--no-save` 开关：用户在调用时附加（例：`/insight-fuse "AI 眼镜" --no-save`）则整个 Stage 7 跳过并输出 `Archive: skipped (--no-save flag)`。

## research-type 预设

| type | template | perspectives | 默认 sections |
|------|---------|-------------|--------------|
| overview | meta-overview | generalist+critic+specialist | report, checklist |
| technology | technology | generalist+critic+specialist | report, adr, checklist |
| market | market | generalist+specialist+futurist | report, decision-tree, checklist |
| academic | academic | generalist+critic+methodologist | report, checklist |
| product | product | user+designer+business | report, checklist, poc |
| competitive | competitive | generalist+critic+strategist | report, decision-tree |

完整预设矩阵 + stance-override 机制 + 特有 check 见 [references/research-types.md](references/research-types.md)。

## 降级策略

- 1 个 Agent 失败：评分 0，从剩余 2 个综合
- 2 个失败：输出唯一成功回答，标注单视角
- 全部失败：报告失败，建议直接提问
- WebSearch 无结果：替代查询词，记入 coverage_gap
- Stage 0 YAML 解析失败：重试一次；第二次失败 → 不带 skeleton 走原 pipeline，标 `skeleton: unavailable`

## 用法示例

```
/insight-fuse "AI 眼镜"
/insight-fuse "AI 眼镜" --type overview --depth full
/insight-fuse "k8s autoscaling" --type technology --sections report,adr,poc
/insight-fuse "向量数据库市场" --type market --depth deep --focus "开源 vs 商业化定价模型"
/insight-fuse "Sparse MoE 可解释性" --type academic --perspectives generalist,critic,methodologist
/insight-fuse "AI Coding 赛道" --type competitive --sections report,decision-tree
/insight-fuse "AI 眼镜" --audience "新入局者,投资人" --strategy aggressive
/insight-fuse "AI 眼镜" --depth full --no-advisory
/insight-fuse "临时背景调研" --depth quick --no-save
/insight-fuse "AI Native 金融" --skeleton ~/team/skeletons/ai-native-fin.yaml
/insight-fuse "k8s autoscaling" --type technology --sections report,adr --merge
```

## 定制

- **视角**：stance-override（改 [references/perspectives.md](references/perspectives.md) §二 Stance Registry）或新增 `agents/insight-<name>.md`
- **模板**：添加 `.md` 文件到 `templates/`，参考 [templates/custom-example.md](templates/custom-example.md) 的 skeleton hooks
- **Research type**：扩展 [references/research-types.md](references/research-types.md) 的预设矩阵
- **质量 check**：扩展 [references/quality-standards.md](references/quality-standards.md) 的 Check 编号（从 15 起）
- **段落**：新增 `templates/<section>.md` + 在 [references/output-formats.md](references/output-formats.md) 登记段落规范与依赖顺序

## References

- [references/skeleton-schema.md](references/skeleton-schema.md) — skeleton.yaml 数据契约
- [references/research-types.md](references/research-types.md) — 6 type 预设 + stance-override + 源可靠性分档（v3.1）
- [references/research-protocol.md](references/research-protocol.md) — INSIGHT_RESPONSE v2.1 + FIR + Focus Selection + Advisory Appendix + `{P}/{S→}` 主次源标注（v3.1）
- [references/scoring-rubric.md](references/scoring-rubric.md) — 6 维评分 + 17 check + primary_source_ratio 子项 + A/B/C/D 等级
- [references/quality-standards.md](references/quality-standards.md) — 17 blocking check 详述（C15-C17 为 v3.1 新增源可靠性）
- [references/primary-source-whitelist.yaml](references/primary-source-whitelist.yaml) — Check 15 白名单，按 research-type 分档（v3.1）
- [references/output-formats.md](references/output-formats.md) — 5 段可选段落规范（多文件默认 / `--merge` 合并）
- [references/perspectives.md](references/perspectives.md) — 多视角评分 + 综合算法
- [references/pre-flight-checklist.md](references/pre-flight-checklist.md) — 发布前 8 项自检
- [templates/reconciliation-log.md](templates/reconciliation-log.md) — Check 17 跨源数字冲突调和模板（v3.1）

> Researched by [forge/insight-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
