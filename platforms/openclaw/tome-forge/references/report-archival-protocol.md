# Report Archival Protocol

Shared protocol for archiving skill outputs to the tome-forge knowledge base. This file is read by other skills (insight-fuse, council-fuse, news-fetch) at runtime. If this file does not exist, those skills silently skip archival.

## KB Discovery

Self-contained KB detection logic (does not depend on tome-forge SKILL.md being loaded):

1. Walk up from the current working directory, looking for `.tome-forge.json`
2. If found → that directory is the KB root
3. If not found → check `~/.tome-forge/`
4. If `~/.tome-forge/.tome-forge.json` exists → KB root is `~/.tome-forge/`
5. If neither exists → **return silently, do not archive**

## Save Algorithm

### Save (Version Append)

每次归档都保存为独立版本文件，不覆盖旧文件：

```
1. KB Discovery → kb_root (or silent exit)
2. Target dir: {kb_root}/raw/reports/{skill_name}/
   - Create directory if it does not exist
3. Target file: {YYYY-MM-DD}-{topic-slug}.md
   - topic-slug: kebab-case of topic, truncated to 50 characters
   - If file already exists (同日同主题多次调研): append -2, -3, etc.
4. Check version lineage:
   - Glob: {kb_root}/raw/reports/{skill_name}/*-{topic-slug}*.md
   - If prior versions exist → set `version` = count + 1, record `prior_versions` list
   - If no prior versions → set `version` = 1
5. Write: YAML frontmatter + blank line + report body
6. Append to {kb_root}/logs/{YYYY-MM}.md:
   - First version: "- [{date} {HH:MM}] **archive**: {skill_name} report → {filepath}"
   - Subsequent: "- [{date} {HH:MM}] **archive**: {skill_name} report → {filepath} (v{N}, topic: {topic-slug})"
7. Output: "Archived to KB: {filepath}" or "Archived to KB: {filepath} (v{N} of {topic})"
```

### Version Lineage (同主题多版本)

同主题的多次调研产生多个独立版本文件，通过 frontmatter 关联：

- `version`: 当前版本号（1, 2, 3...）
- `prior_versions`: 同主题旧版本文件路径列表（从旧到新）
- 每个版本是完整的独立报告，可单独 ingest，也可作为时间线参考
- tome-forge ingest 时可选择：仅 ingest 最新版本，或合并所有版本的信息

**示例：**

```
raw/reports/insight-fuse/
├── 2026-03-10-ai-agent-security.md   ← v1
├── 2026-04-16-ai-agent-security.md   ← v2, prior_versions: [v1 path]
└── 2026-05-20-ai-agent-security.md   ← v3, prior_versions: [v1, v2 paths]
```

### news-fetch Version Strategy

新闻按日期天然分版本，无需特殊处理：

- 文件名: `{YYYY-MM-DD}-{topic-slug}.md`（日期 + 主题）
- 不同日期同主题 → 各自独立文件（天然版本）
- 同日同主题多次获取 → 追加序号 `-2`, `-3`（同日多版本）

## Frontmatter Schema

All archived reports use this frontmatter structure:

```yaml
---
# Common fields (required):
source_skill: insight-fuse | council-fuse | news-fetch
source_version: 1
date: YYYY-MM-DD
topic: "<original topic or question>"
tags:
  - keyword1
  - keyword2
source_urls:
  - https://...

# Version lineage:
version: 1
prior_versions: []          # paths to older versions of same topic

# insight-fuse specific (optional):
depth: quick | standard | deep | full
template: technology | market | competitive | auto
perspectives:
  - generalist
  - critic
  - specialist

# council-fuse specific (optional):
consensus_pattern: strong | majority-dissent | three-way-split
confidence: 1-10

# news-fetch specific (optional):
time_range: today | week | month | YYYY-MM-DD~YYYY-MM-DD
item_count: N
fetch_tier: L1 | L2 | L3
---
```

### Field Reference

| Field | Required | Type | Applies to | Description |
|-------|----------|------|------------|-------------|
| source_skill | yes | enum | all | Which skill produced this report |
| source_version | yes | int | all | Schema version, currently `1` |
| date | yes | date | all | Date report was generated (updated on revision) |
| topic | yes | string | all | Original research topic or question |
| tags | yes | list | all | Auto-extracted keywords from topic |
| source_urls | no | list | all | Top 3-5 URLs referenced |
| version | yes | int | all | Version number for this topic (1, 2, 3...) |
| prior_versions | no | list | all | Paths to older versions of same topic |
| depth | no | enum | insight-fuse | Research depth level |
| template | no | string | insight-fuse | Template used, or "auto" |
| perspectives | no | list | insight-fuse, council-fuse | Perspective names used |
| consensus_pattern | no | enum | council-fuse | Agreement pattern from scoring |
| confidence | no | int | council-fuse | Average confidence across members |
| time_range | no | string | news-fetch | Time range queried |
| item_count | no | int | news-fetch | Number of news items |
| fetch_tier | no | enum | news-fetch | Data retrieval tier used |

## Tag Extraction

Auto-extract 2-5 keyword tags from the topic:

- Split topic into significant nouns/phrases
- Remove stop words and generic terms
- Prefer domain-specific terminology
- Use lowercase kebab-case for multi-word tags
- Examples:
  - "AI Agent 安全风险" → `[ai, agent, security]`
  - "Rust vs Go for backend services" → `[rust, go, backend]`
  - "大模型推理芯片" → `[llm, inference, chip]`
