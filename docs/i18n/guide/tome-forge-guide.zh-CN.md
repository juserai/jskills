# Tome Forge 用户指南

> 5 分钟快速上手 — 基于 LLM 编译的个人知识库 Wiki

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserai/forge
```

### 通用一行安装

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **零依赖** — Tome Forge 不需要任何外部服务、向量数据库或 RAG 基础设施。安装即用。

---

## 命令

| 命令 | 功能 | 使用时机 |
|------|------|---------|
| `/tome-forge init` | 初始化知识库 | 在任意目录中启动新的 KB |
| `/tome-forge capture [text]` | 快速捕获笔记、链接或剪贴板内容 | 记录想法、保存 URL、剪辑内容 |
| `/tome-forge capture clip` | 从系统剪贴板捕获 | 快速保存已复制的内容 |
| `/tome-forge ingest <path>` | 将原始材料编译到 Wiki | 向 `raw/` 添加论文、文章或笔记后 |
| `/tome-forge ingest <path> --dry-run` | 预览路由但不写入 | 在确认更改前验证 |
| `/tome-forge query <question>` | 从 Wiki 中搜索和综合 | 在知识库中查找答案 |
| `/tome-forge lint` | Wiki 结构健康检查 | 提交前、定期维护 |
| `/tome-forge compile` | 批量编译所有新的原始材料 | 添加多个原始文件后集中处理 |

---

## 工作原理

基于 Karpathy 的 LLM Wiki 模式：

```
raw materials + LLM compilation = structured Markdown wiki
```

### 双层架构

| 层级 | 所有者 | 用途 |
|------|--------|------|
| `raw/` | 你 | 不可变的源材料 — 论文、文章、笔记、链接 |
| `wiki/` | LLM | 编译后的、结构化的、交叉引用的 Markdown 页面 |

LLM 读取你的原始材料并将其编译为结构良好的 Wiki 页面。你永远不要直接编辑 `wiki/` — 你添加原始材料，让 LLM 维护 Wiki。

### 神圣区域

每个 Wiki 页面都有一个 `## 我的理解差异` 区域。这是**你的** — LLM 永远不会修改它。在这里写下你的个人见解、异议或直觉。它在所有重新编译中都会保留。

---

## KB 发现 — 我的数据去哪了？

你可以从**任意目录**运行 `/tome-forge`。它会自动找到正确的 KB：

| 情况 | 发生什么 |
|------|---------|
| 当前目录（或父目录）包含 `.tome-forge.json` | 使用该 KB |
| 向上未找到 `.tome-forge.json` | 使用默认的 `~/.tome-forge/`（如有需要自动创建） |

这意味着你可以从任何项目中捕获笔记，无需先 `cd` — 所有内容都汇入你的单一默认 KB。

想要每个项目单独的 KB？在该项目目录内使用 `init .`。

## 工作流程

### 1. 初始化

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

初始化后，KB 目录结构如下：

```
~/.tome-forge/               # (or wherever you initialized)
├── .tome-forge.json         # KB marker (auto-generated)
├── CLAUDE.md                # KB schema and rules
├── index.md                 # Wiki page index
├── .gitignore
├── logs/                    # Operation logs (monthly rotation)
│   └── 2026-04.md           # One file per month, never grows too large
├── raw/                     # Your source materials (immutable)
└── wiki/                    # LLM-compiled wiki (auto-maintained)
```

### 2. 捕获

从**任意目录**直接运行：

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

快速捕获保存到 `raw/captures/{date}/`。对于较长的材料，直接将文件放入 `raw/papers/`、`raw/articles/` 等目录。

### 3. 摄入

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

LLM 读取原始文件，将其路由到正确的 Wiki 页面，并在保留你的个人笔记的同时合并新信息。

### 4. 查询

```
/tome-forge query "what is the relationship between attention and transformers?"
```

从你的 Wiki 中综合答案，引用具体页面。如果信息缺失，会告诉你需要添加什么原始材料。

### 5. 维护

```
/tome-forge lint
/tome-forge compile
```

Lint 检查结构完整性。Compile 批量摄入自上次编译以来的所有新内容。

---

## 目录结构

```
my-knowledge-base/
├── .tome-forge.json       # KB marker (auto-generated)
├── CLAUDE.md              # Schema and rules (auto-generated)
├── index.md               # Wiki page index
├── .last_compile          # Timestamp for batch compile
├── logs/                  # Operation logs (monthly rotation)
│   └── 2026-04.md
├── raw/                   # Your source materials (immutable)
│   ├── captures/          # Quick captures by date
│   ├── papers/            # Academic papers
│   ├── articles/          # Blog posts, articles
│   ├── books/             # Book notes
│   └── conversations/     # Chat logs, interviews
└── wiki/                  # LLM-compiled wiki (auto-maintained)
    ├── ai/                # Domain directories
    ├── systems/
    └── ...
```

---

## Wiki 页面格式

每个 Wiki 页面遵循严格的模板：

```yaml
---
domain: ai
maturity: growing        # draft | growing | stable | deprecated
last_compiled: 2026-04-15
source_refs:
  - raw/papers/attention.md
confidence: medium       # low | medium | high
compiled_by: claude-opus-4-6
---
```

必需的区域：
- **核心概念** — LLM 维护的知识
- **我的理解差异** — 你的个人见解（LLM 绝不触碰）
- **开放问题** — 未回答的问题
- **关联** — 相关 Wiki 页面的链接

---

## 推荐节奏

| 频率 | 操作 | 时间 |
|------|------|------|
| **每天** | `capture` 想法、链接、剪贴板内容 | 2 分钟 |
| **每周** | `compile` 批量处理本周的原始材料 | 15-30 分钟 |
| **每月** | `lint` + 审查我的理解差异区域 | 30 分钟 |

**避免实时摄入。** 频繁的单文件摄入会破坏 Wiki 的连贯性。每周批量编译能产生更好的交叉引用和更一致的页面。

---

## 扩展路线图

| 阶段 | Wiki 大小 | 策略 |
|------|----------|------|
| 1. 冷启动（第 1-4 周） | < 30 页 | 全量上下文读取，index.md 路由 |
| 2. 稳定状态（第 2-3 月） | 30-100 页 | 主题分片（wiki/ai/、wiki/systems/） |
| 3. 扩展（第 4-6 月） | 100-200 页 | 分片范围查询，ripgrep 补充 |
| 4. 高级（6 个月以上） | 200+ 页 | 基于嵌入的路由（非检索），增量编译 |

---

## 已知风险

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| **措辞漂移** | 多次编译会磨平个人风格 | `compiled_by` 追踪模型；raw/ 是事实来源；随时从 raw 重新编译 |
| **扩展上限** | 上下文窗口限制 Wiki 大小 | 按领域分片；使用索引路由；> 200 页时引入嵌入层 |
| **供应商锁定** | 绑定单一 LLM 供应商 | 原始资源是纯 Markdown；切换模型后重新编译 |
| **差异区损坏** | LLM 覆盖个人见解 | 摄入后 diff 验证自动恢复原始差异区 |

---

## 平台

| 平台 | 工作方式 |
|------|---------|
| Claude Code | 完整文件系统访问、并行读取、git 集成 |
| OpenClaw | 相同操作，适配 OpenClaw 工具规范 |

---

## 常见问题

**问：Wiki 能有多大？**
答：50 页以下，LLM 读取全部内容。50-200 页，使用索引导航。超过 200 页，考虑按领域分片。

**问：能直接编辑 Wiki 页面吗？**
答：只能编辑 `## 我的理解差异` 区域。其他所有内容会在下次摄入/编译时被覆盖。

**问：需要向量数据库吗？**
答：不需要。Wiki 是纯 Markdown。LLM 直接读取文件 — 无嵌入、无 RAG、无基础设施。

**问：如何备份我的 KB？**
答：全部是 git 仓库中的文件。`git push` 即可。

**问：如果 LLM 在 Wiki 中出错怎么办？**
答：在 `raw/` 中添加更正内容并重新摄入。合并算法优先选择更权威的来源。或者在你的我的理解差异中记录异议。
