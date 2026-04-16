# KB Archival — 设计文档

## 概述

将 insight-fuse（调研报告）、council-fuse（审议报告）、news-fetch（新闻摘要）的输出自动归档到 tome-forge 个人知识库，实现「调研 → 积累 → 检索」的知识闭环。

## 动机

- insight-fuse 和 council-fuse 产出高质量的结构化报告，但输出后即消散在对话中
- 用户需要长期积累调研成果，并支持跨时间检索和增量迭代
- news-fetch 的新闻摘要可作为时事参考纳入知识库

## 数据流

```
insight-fuse ─┐
council-fuse ──┤── report-archival-protocol ──→ raw/reports/{skill}/ ──→ tome-forge ingest ──→ wiki/
news-fetch ───┘                                      ▲                         │
                                                     │                         ▼
                                              增量更新（同主题合并）       wiki 页面迭代合并
```

## 核心设计决策

### 1. 零硬依赖（独立性保证）

各 skill 的 SKILL.md 中增加「KB 归档（可选）」节，首先尝试读取 `skills/tome-forge/references/report-archival-protocol.md`：

- **文件存在**（tome-forge 已安装）→ 执行归档
- **文件不存在**（tome-forge 未安装）→ 静默跳过

这是运行时文件存在性检查，不构成代码级依赖。符合 CLAUDE.md 的「可选组合关系」规范。

### 2. 共享归档协议

归档逻辑集中在 `skills/tome-forge/references/report-archival-protocol.md`，包含：

- KB Discovery 算法（自包含，不依赖 tome-forge SKILL.md）
- Frontmatter schema（统一的元数据结构）
- 保存算法（版本追加模式）
- Tag 提取规则

### 3. 版本追加策略（不覆盖旧文件）

每次调研都保存为独立版本文件，通过 frontmatter `version` + `prior_versions` 关联同主题的历史版本。

**调研/审议报告**（insight-fuse, council-fuse）：
- 文件名: `{YYYY-MM-DD}-{topic-slug}.md`
- 同主题再次调研 → 新建独立文件，`version` +1，`prior_versions` 记录旧版本路径
- 示例: `2026-03-10-ai-agent-security.md` (v1) → `2026-04-16-ai-agent-security.md` (v2)

**新闻摘要**（news-fetch）：
- 按日期天然分版本
- 不同日期同主题 → 各自独立文件
- 同日同主题多次获取 → 追加序号 `-2`, `-3`

### 4. tome-forge Ingest 增强

operations.md 新增报告路由规则：
- 有 `source_skill` frontmatter → 用 `topic` + `tags` 精准路由
- 多版本报告: 通过 `prior_versions` 找到已有 wiki 页面，ingest 最新版本为主源
- wiki 页 `source_refs` 列出所有版本路径（最新在前）

## Frontmatter Schema

| Field | Required | Applies to | Description |
| ----- | -------- | ---------- | ----------- |
| source_skill | yes | all | 来源 skill |
| source_version | yes | all | Schema 版本 |
| date | yes | all | 生成/更新日期 |
| topic | yes | all | 原始主题 |
| tags | yes | all | 自动提取关键词 |
| version | yes | all | 版本号 (1, 2, 3...) |
| prior_versions | no | all | 同主题旧版本路径列表 |
| source_urls | no | all | 引用 URL |
| depth | no | insight-fuse | 调研深度 |
| template | no | insight-fuse | 报告模板 |
| perspectives | no | insight-fuse, council-fuse | 视角列表 |
| consensus_pattern | no | council-fuse | 共识模式 |
| confidence | no | council-fuse | 置信度均值 |
| time_range | no | news-fetch | 查询时间范围 |
| item_count | no | news-fetch | 新闻条数 |
| fetch_tier | no | news-fetch | 数据获取层级 |

## 目录约定

```
{kb_root}/
├── raw/
│   ├── reports/
│   │   ├── insight-fuse/
│   │   │   └── {YYYY-MM-DD}-{topic-slug}.md
│   │   ├── council-fuse/
│   │   │   └── {YYYY-MM-DD}-{topic-slug}.md
│   │   └── news-fetch/
│   │       └── {YYYY-MM-DD}-{topic-slug}.md
│   ├── captures/
│   ├── papers/
│   └── ...
└── wiki/
    └── {domain}/{topic}.md  ← ingest 编译产物
```

## 变更文件清单

| 文件 | 操作 | 说明 |
| ---- | ---- | ---- |
| `skills/tome-forge/references/report-archival-protocol.md` | NEW | 共享归档协议 |
| `skills/tome-forge/references/operations.md` | MODIFY | 报告路由 + 迭代合并规则 |
| `skills/tome-forge/references/schema-template.md` | MODIFY | Architecture 追加 raw/reports/ |
| `skills/tome-forge/SKILL.md` | MODIFY | Key Principle #7 |
| `skills/insight-fuse/SKILL.md` | MODIFY | KB 归档可选节 |
| `skills/council-fuse/SKILL.md` | MODIFY | KB 归档可选节 |
| `skills/news-fetch/SKILL.md` | MODIFY | KB 归档可选节 |
| `docs/plans/kb-archival-design.md` | NEW | 本文档 |
