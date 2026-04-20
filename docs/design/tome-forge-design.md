# tome-forge 设计文档

**日期**: 2026-04-15
**状态**: 已批准

## 定位

基于 Karpathy 的 LLM Wiki 模式：原始材料 + LLM 编译 = 结构化 Markdown wiki。无 RAG、无向量数据库、无基础设施依赖。个人知识库引擎。

## 覆盖与边界

> tome-forge 是**LLM 为你编纂的私人图书馆**——它让你把散材变结构化 wiki 而保留人类洞察，但只为个人设计、不做实时同步、不做权限控制。

完整分析（能解决 / 不能解决 / 不应使用）：[references/scope-boundaries.md](../../skills/tome-forge/references/scope-boundaries.md)

## 命名

遵循 `名词-动词` 模式：lore(知识/传说) + forge(锻造)。分类为 crucible（坩埚 — 多源融合、知识沉淀）。

## 核心架构

### 双层架构

```
┌─────────────────────────────────────────┐
│              wiki/ (LLM 维护)            │
│  结构化 Markdown 页面                     │
│  交叉引用、frontmatter、分域组织           │
│  ┌──────────────────────────────────┐   │
│  │ ## My Understanding Delta        │   │
│  │ （人类专属区域，LLM 永不触碰）      │   │
│  └──────────────────────────────────┘   │
├─────────────────────────────────────────┤
│              raw/ (人类维护)              │
│  不可变的原始材料                         │
│  论文、文章、书籍笔记、对话、快速捕获       │
└─────────────────────────────────────────┘
```

### 数据流

```
capture ──→ raw/captures/{date}/
               │
ingest ────────┼──→ 路由到 wiki 页面
               │       │
               │    ┌──┴──┐
               │  更新   创建
               │    │     │
               │    ▼     ▼
               │  合并内容  生成新页面
               │    │     │
               │    └──┬──┘
               │       │
               ▼       ▼
compile ──→ 批量 ingest 所有新 raw 文件
               │
lint ──────→ 结构完整性检查
               │
query ─────→ 读取 index → 读取相关页面 → 综合答案
```

## KB 发现机制

每个子命令执行前，先确定 KB 根目录：

```
当前目录向上查找 .tome-forge.json
    │
    ├─ 找到 → 该文件所在目录即为 KB root
    │
    └─ 未找到 → 使用 ~/.tome-forge/
                    │
                    ├─ 已存在 → 直接使用
                    │
                    └─ 不存在且命令非 init → 自动 init 后使用
```

**设计理由**：用 `.tome-forge.json` 专属标记而非 `raw/ + wiki/` 通用目录名，避免误匹配。用户在任何项目目录下都能 capture/query，无需 cd。多数用户只需一个默认 KB；需要隔离的项目可用 `init .` 创建本地 KB。

## 子命令设计

| 子命令 | 输入 | 输出 | 幂等性 |
|--------|------|------|--------|
| `init` | 无 | 目录结构 + CLAUDE.md | 是（已存在则跳过） |
| `capture` | 文本或 URL | raw/captures/{date}/ 文件 | 否（追加） |
| `ingest` | raw 文件路径 | wiki 页面（新建或更新） | 是（相同输入同结果） |
| `query` | 问题文本 | 综合答案 + 引用 | 是 |
| `lint` | 无 | 检查报告 | 是 |
| `compile` | 无 | 批量 ingest + lint | 否（依赖时间戳） |

## Wiki 页面模板

```yaml
---
domain: <领域>
maturity: draft | growing | stable | deprecated
last_compiled: YYYY-MM-DD
source_refs:
  - raw/path/to/source.md
confidence: low | medium | high
compiled_by: <模型 ID>
---

## Core Concept
（LLM 维护的结构化知识）

## My Understanding Delta
（人类专属 — LLM 永不修改）

## Open Questions
（未解决的问题）

## Connections
（与其他 wiki 页面的链接）
```

## 关键不变量

1. **raw/ 不可变** — 永不修改 raw/ 下的文件
2. **My Understanding Delta 神圣** — 合并时逐字保留，永不删除/修改/改进
3. **wiki/ 归 LLM** — 人类只编辑 My Understanding Delta，其余由 LLM 维护
4. **index.md 是入口** — 每次操作后更新
5. **按月轮转日志** — 追加到 `logs/{YYYY-MM}.md`，避免单文件膨胀
6. **来源可追溯** — wiki 中每个断言通过 source_refs 追溯到 raw/

## 合并算法

更新现有 wiki 页面时：

| 区段 | 操作 | 说明 |
|------|------|------|
| Core Concept | MERGE | 新信息融入，不删除现有内容 |
| My Understanding Delta | PRESERVE + VERIFY | 逐字复制，ingest 后 diff 对比验证，不匹配则恢复 |
| Open Questions | APPEND | 保留现有问题，新材料回答的移至 Core Concept |
| Connections | UNION | 只增不删，除非明确错误 |
| Frontmatter | UPDATE | 更新时间戳、追加 source_ref、重新评估 confidence、设置 compiled_by |

## 扩展路线

| 阶段 | 时间 | Wiki 规模 | 策略 |
|------|------|-----------|------|
| 冷启动 | 第 1-4 周 | < 30 页 | 全量读取，index.md 路由 |
| 稳定运行 | 第 2-3 月 | 30-100 页 | Topic Sharding（wiki/ai/、wiki/systems/） |
| 规模化 | 第 4-6 月 | 100-200 页 | 分片查询，ripgrep 全文搜索补充 |
| 高级功能 | 6 月后 | 200+ 页 | embedding 做路由层（非检索），增量编译 |

## 三大风险与缓解

| 风险 | 表现 | 缓解 |
|------|------|------|
| **措辞漂移** | 多次 compile 后个人表达被 LLM 平均化 | frontmatter `compiled_by` 追踪模型版本；raw/ 是 ground truth，随时可重新编译 |
| **规模天花板** | context window 限制 wiki 可加载大小 | 按域分片；200+ 页引入 embedding 做路由而非检索 |
| **供应商锁定** | 依赖特定 LLM 提供商 | raw/ 是纯 Markdown，换模型重新编译即可 |
| **Delta 损坏** | LLM 编译时覆盖人类洞察 | ingest 后 diff 验证，不匹配自动恢复原文 |

## 编译节奏建议

- **日常**：capture 低摩擦（2 分钟）
- **每周**：compile 批量处理（15-30 分钟），产生最佳交叉引用
- **每月**：lint + 人工审阅 My Understanding Delta

**切忌实时 ingest** — 频繁单文件 ingest 会破坏 wiki 层的内聚性。批量编译产出更一致的页面结构和交叉引用。

## lint 检查清单

- 结构错误：frontmatter 缺失/字段不完整、必需区段缺失
- 值错误：maturity/confidence/date 格式不合规
- 引用警告：source_refs 断链、wiki 链接断链、index 遗漏
- 内容提示：My Understanding Delta 为空、REVIEW 注释未解决

## 行为约束

1. 解析子命令和参数
2. 无参数时显示帮助文本
3. 每个子命令按 SKILL.md 中的步骤严格执行
4. 每次操作后追加 `logs/{YYYY-MM}.md`
5. ingest/compile 后建议但不自动 git commit
6. My Understanding Delta 保护是最高优先级约束

## 文件清单

```
skills/tome-forge/SKILL.md                       # 核心 skill 定义
skills/tome-forge/references/operations.md        # ingest/lint 详细算法
skills/tome-forge/references/schema-template.md   # wiki 页面和 CLAUDE.md 模板
evals/tome-forge/scenarios.md                     # 评估场景（10 个）
evals/tome-forge/run-trigger-test.sh              # 触发测试
docs/user-guide/tome-forge-guide.md                    # 使用手册
```

## 与现有 skill 的关系

- 零依赖，独立使用
- 无 hooks（手动触发）
- 无 scripts（纯 AI 执行）
- 无 agents（无 sub-agent 需求）
- 可选组合：与 council-fuse 配合，对有争议的知识进行多视角审议

## 参考来源

- [Karpathy LLM Wiki pattern](https://x.com/karpathy/status/1899906803339338079) — 核心灵感
- [Zettelkasten method](https://zettelkasten.de/posts/overview/) — 交叉引用和原子化页面思路
