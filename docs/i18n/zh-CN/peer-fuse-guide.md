# Peer Fuse v0.1.0 使用手册

> 通用调研工件评议器 — **8 阶段流水线（Stage 7 KB 归档 mandatory + observable，可用 `--no-save` 退出）+ 10 格式输入适配器（md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html，三层分发）+ 6 种研究类型预设（自动分类）+ 8 维加权评分表 + 18 项 flag 分类法 + 3 视角评议团 + § Document Reading 冻结（评议隔离硬约束）**。

Peer-Fuse 接收任意 markdown / PDF / Office 文档，产出一份 markdown 评议报告，含 A+/A−/.../D 等级、分级 quality flag 列表、多视角评议团综合意见，以及 patch 风格的 diff 改写建议。它与 [insight-fuse Stage 6.5 评议器](insight-fuse-guide.md) 共存 —— Stage 6.5 是 IF 内部的同源评议；peer-fuse 则是**跨 skill 外部评议器**，覆盖 Stage 6.5 处理不了的格式与场景。

## Quick start 快速开始

```bash
# 自动分类类型，默认深度，归档至 KB
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# PDF 学术论文（类型由 arXiv/IEEE/Nature 头自动识别）
/peer-fuse papers/transformer-2017.pdf

# PPTX 文档显式指定类型
/peer-fuse decks/q4-roadmap.pptx --type product

# 快速深度（跳过 Stage 4 评议团 + Stage 5.5 总评）+ 跳过 KB 归档
/peer-fuse handbook.docx --depth quick --no-save

# 显示帮助
/peer-fuse help
# 或不带参数
/peer-fuse
```

## 默认值与 flag

| Flag | 默认 | 取值 |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag —— 跳过 Stage 7 KB 归档，仅控制台输出 |

`--type=auto` 让 peer-fuse 在读取文档后通过启发式规则分类（frontmatter type 字段 → 章节模式 → 引用密度 → 格式/标题线索 → 兜底 overview）。优先级链见 [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md)。

## 支持的格式

| Tier | 工具要求 | 格式 |
|:-:|---|---|
| 1 | 无（原生） | `.md`、`.markdown`、`.txt`、`.pdf` |
| 2 | `pandoc` | `.docx`、`.html`、`.htm`、`.rtf`、`.odt` |
| 3 | `libreoffice`（`.doc` 还需 `pandoc`） | `.doc`、`.ppt`、`.pptx`、`.odp` |

工具缺失 → fail-soft，给出具体安装提示（`brew install pandoc`、`apt install libreoffice` 等），并在 Stage 1 之前退出。详见 [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md)。

## 你会拿到什么

两份并列的交付物：

1. **会话内联渲染的评议**，结构如下：
   - § Document Reading —— 描述性叙述（文档讲了什么），3-5 段，300-600 字
   - § Holistic Assessment —— 评价性叙述（方法论 / 优势 / 关切 / 建议），4 段，400-700 字
   - § Score Matrix —— 8 维加权得分 → 字母等级
   - § Flag List —— 来自 18 项分类法的 flag 代码及位置
   - § Multi-Perspective Panel —— 方法论者 / 对抗者 / 实践者裁决
   - § Diff Suggestions —— 针对每条扣分的 patch 风格改写
   - § Reconciliation —— target 自评分 vs review_grade 的 Δ

2. **KB 归档** 位于 `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md`（用 `--no-save` 跳过）。归档日志行 `Archived to KB: <path>` 始终出现在用户可见的回复中。

## 硬约束：§ Document Reading 评议隔离

peer-fuse 最重要的架构决策：

**§ Document Reading 不得被评议结论污染。** 它是评议者对文档的忠实、描述性阅读 —— frontmatter、结构、断言、证据、范围。它运行在 Stage 3.5，**先于** Stage 4 评议团和 Stage 5 评分，输入边界严格：

- ✅ 接受：原始文档、Stage 1-3 事实扫描结果
- ❌ 拒绝：评议团裁决、评分、flag 命中

该章节在 Stage 3.5 之后**冻结**：进入 Stage 4 之前取一次 SHA-256 哈希，Stage 7 在归档前校验哈希。任何修改 → fail-closed。Lint 同时禁止该章节出现评价性词汇（`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`）和字母等级字面量。

这是用户提出的硬约束，在三个层面强制：架构隔离 + 写一次冻结 + 禁词 lint。

## 与其他 forge skill 的关系

| Skill | 关系 |
|---|---|
| **insight-fuse** Stage 6.5 评议器 | 共存 —— Stage 6.5 是 IF 内部同源评议（同评分表、同启发式、仅 IF markdown）。peer-fuse 是**跨 skill 外部评议**，覆盖更广的 8 维评分、18 项 flag、10 种格式、3-agent 评议团。重要的 IF 报告两者都应跑。 |
| **council-fuse** | 同胞 crucible —— peer-fuse 复用 council-fuse 的并行 sub-agent 分发模式（Stage 4 评议团镜像 council-fuse Stage 1）。 |
| **tome-forge** | 归档后端 —— peer-fuse Stage 7 调用 tome-forge 的 report-archival-protocol；不重新实现 KB 写入逻辑。 |
| **skill-lint** | 模式同胞（不同分类，anvil）—— 两者都裁决工件并产出诊断，但 skill-lint 输出短暂的控制台诊断，而 peer-fuse 输出持久化的 markdown 评议工件。 |

## 何时用 peer-fuse vs IF Stage 6.5

| 场景 | 用 |
|---|:-:|
| 你刚跑完 `/insight-fuse <topic>`，想要 IF 报告的二次意见 | IF Stage 6.5 已内联跑过；如需具备跨格式能力的二层外部评议，运行 `/peer-fuse <if-output-path>` |
| 你有第三方 PDF 研究论文要评估 | peer-fuse |
| 你有 PPTX 商业 deck 要打分 | peer-fuse |
| 你有 council-fuse 综合输出要打分 | peer-fuse |
| 你想用同一评分表对比多份工件 | peer-fuse（跨工件评分一致） |

## 具体示例

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 探测
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 产出 § Document Reading（冻结）
# Stage 4 评议团并行跑 3 个 sub-agent
# Stage 5 评分 → 8.6 / A-
# Stage 5.5 总评
# Stage 6 diff 建议：5 个 block
# Stage 7 归档

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

控制台内联渲染完整评议；KB 归档是持久化的权威版本。

## 校验

```bash
# 静态检查
bash skills/skill-lint/scripts/skill-lint.sh .

# 触发测试
bash evals/peer-fuse/run-trigger-test.sh

# Hash 锁步
bash scripts/recalc-all-hashes.sh
```

## 参考资料

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) —— 运行时 skill 定义
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) —— 架构决策 + 4 分类依据
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) —— RFC（合并后）
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) —— 同胞 crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) —— 同胞 crucible（评议团模式来源）
