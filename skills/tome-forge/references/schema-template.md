# KB Wiki Schema Template

This file contains the CLAUDE.md template to be written during `/tome-forge init`, and the wiki page template used during ingest.

## CLAUDE.md Template

Write this content as `./CLAUDE.md` in the knowledge base root:

```markdown
# Knowledge Base Schema

## Identity
This is a personal knowledge base. You are the wiki compiler and maintainer.

## Architecture
- `raw/` — immutable source material. NEVER modify files here.
- `wiki/` — compiled knowledge. You own this layer entirely.
- `index.md` — content catalog. Update after every wiki change.
- `raw/reports/` — archived reports from other skills (auto-populated, do not modify).
- `logs/{YYYY-MM}.md` — monthly operation logs (auto-rotated).

## Wiki Page Format
Every wiki page MUST use this template:

---
domain: <category>
maturity: draft|growing|stable|deprecated
last_compiled: YYYY-MM-DD
source_refs:
  - raw/path/to/source.md
compiled_by: <model-id>
confidence: low|medium|high
---

## Core Concept
<factual, well-structured explanation>

## My Understanding Delta
<CRITICAL: personal insights, unique perspectives, disagreements with mainstream>
<NEVER delete or overwrite without explicit approval>

## Open Questions
- <genuine unresolved questions — do NOT convert to answers>

## Connections
- [[wiki/related/page]]

## Rules
- NEVER modify files in raw/
- NEVER delete My Understanding Delta content
- NEVER convert Open Questions into answers without new evidence
- ALWAYS update index.md after wiki changes
- ALWAYS log operations to `logs/{YYYY-MM}.md`
- ALWAYS include source_refs tracing back to raw/
```

## Wiki Page Template

When creating a new wiki page during ingest, use this structure:

```markdown
---
domain: {inferred_domain}
maturity: draft
last_compiled: {today}
source_refs:
  - {raw_file_path}
compiled_by: {model_id}
confidence: medium
---

## Core Concept

{comprehensive explanation compiled from raw material}

## My Understanding Delta

*To be filled by human — your personal insights go here.*

## Open Questions

- {genuine questions raised by the material}

## Connections

- [[wiki/{related_topic}]]
```

## Frontmatter Field Reference

| Field | Required | Values | Description |
|-------|----------|--------|-------------|
| domain | yes | free text | Knowledge category (e.g., ai, systems, biology) |
| maturity | yes | draft, growing, stable, deprecated | Content maturity level |
| last_compiled | yes | YYYY-MM-DD | Last LLM compilation date |
| source_refs | yes | list of paths | Raw files this page was compiled from |
| compiled_by | yes | model ID string | Which LLM model compiled this page |
| confidence | yes | low, medium, high | Confidence in content accuracy |

## Maturity Transitions

- `draft` — newly created, minimal content
- `growing` — actively being updated with new ingests
- `stable` — well-established, no major changes expected
- `deprecated` — outdated, pending removal or rewrite
