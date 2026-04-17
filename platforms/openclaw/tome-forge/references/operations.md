# KB Wiki Operations Reference

Detailed algorithms for ingest and lint operations.

## Ingest Algorithm

### Step 1: Route

Given raw content and the current `index.md`, determine which wiki pages need updating or creating.

**Routing rules:**
- If raw content discusses an existing wiki topic → update that page
- If raw content introduces a new concept not in the wiki → create a new page
- One raw file may route to multiple wiki pages
- Prefer updating existing pages over creating new ones (consolidation > fragmentation)

**Report routing (for files in `raw/reports/`):**
- If the raw file has `source_skill` in frontmatter → use `topic` + `tags` for routing instead of content analysis
- Prefer routing to existing wiki pages whose `domain` matches the report's `tags`
- insight-fuse reports: typically route to 1-3 wiki pages (split by sub-topics within the report)
- council-fuse reports: typically route to 1 wiki page matching the deliberation question
- news-fetch digests: route to `wiki/{domain}/` pages grouped by topic; individual news items may split across pages
- When creating new pages from reports, set initial `confidence` based on metadata:
  - council-fuse: consensus "strong" → high, "majority-dissent" → medium, "three-way-split" → low
  - insight-fuse: depth "deep"/"full" → high, "standard" → medium, "quick" → low
  - news-fetch: always `low` (news is ephemeral, needs corroboration)

**Multi-version reports (same topic, different dates):**
- When a raw report has `version > 1` and `prior_versions`, it is a newer version of an existing topic
- Routing: use `topic` to find wiki pages already created from prior versions (check wiki page `source_refs` for paths in `prior_versions`)
- Ingest the latest version as the primary source; prior versions provide historical context
- Merge strategy follows standard Step 2, with additional rules:
  - Wiki page `source_refs` should list ALL version paths (latest first)
  - After multi-version merge, wiki page `maturity` must be at least `growing` (multiple rounds of evidence)
  - If prior versions contradict the latest, prefer latest content in Core Concept; note evolution in Open Questions

**Naming convention for new pages:**
- Path: `wiki/{domain}/{topic-name}.md`
- Use kebab-case for filenames
- Domain should match existing domains in the wiki when possible

### Step 2: Merge (for updates)

When updating an existing wiki page with new raw material:

1. **Core Concept**: MERGE new information into existing content
   - Add new facts, examples, or details
   - Correct factual errors if the new source is more authoritative
   - Do NOT delete existing content unless it's demonstrably wrong
   - Preserve the existing structure and flow

2. **My Understanding Delta**: PRESERVE EXACTLY
   - Copy this section verbatim from the old version
   - NEVER modify, summarize, or "improve" it
   - This is the human's personal insight — hands off

3. **Open Questions**: APPEND
   - Keep existing questions unless the new material directly answers them
   - Add new questions raised by the new material
   - If new material answers an existing question, move the answer to Core Concept and remove the question

4. **Connections**: UNION
   - Keep all existing connections
   - Add new connections implied by the new material
   - Do NOT remove connections unless they are clearly wrong

5. **Frontmatter**: UPDATE
   - `last_compiled`: set to today
   - `source_refs`: append the new raw file path
   - `compiled_by`: set to current model ID
   - `maturity`: set to `growing` if it was `draft`, otherwise keep
   - `confidence`: re-evaluate based on total evidence

### Step 3: Validate (with Delta diff verification)

After writing the updated page:

1. **Delta diff check** (mandatory for updates):
   - Extract `## My Understanding Delta` content from the NEW page
   - Compare byte-for-byte with the SAVED copy from Step 2
   - If ANY difference is detected → RESTORE the saved Delta, overwrite the corrupted section, and log a warning: `DELTA_RESTORED: {wiki_path}`
   - This is a hard gate — do not proceed to index update if Delta restoration fails

2. Additional checks:
   - [ ] All source_refs point to existing files
   - [ ] Connections use valid `[[wiki/...]]` syntax
   - [ ] Frontmatter has all required fields including `compiled_by`
   - [ ] If uncertain about a merge, add `<!-- REVIEW: explanation -->`

### Step 4: Update Index

After all pages are written:
- Read all `wiki/**/*.md` files
- Regenerate `index.md` with one entry per page:
  ```
  - [wiki/domain/topic.md](wiki/domain/topic.md) — domain: X, maturity: Y
  ```
- Sort by domain, then by filename

### Step 5: Log

Append to `logs/{YYYY-MM}.md` (create file if the month's log doesn't exist yet):
```
- [{date} {HH:MM}] **ingest**: {raw_path} -> {wiki_pages} ({action: created|updated})
```

---

## Lint Checklist

For each `wiki/**/*.md` file, check:

### Structure (Errors — must fix)
- [ ] File starts with YAML frontmatter (`---` delimited)
- [ ] Frontmatter contains: domain, maturity, last_compiled, source_refs, confidence
- [ ] Section `## Core Concept` exists
- [ ] Section `## My Understanding Delta` exists
- [ ] Section `## Open Questions` exists
- [ ] Section `## Connections` exists

### Values (Errors — must fix)
- [ ] `maturity` is one of: draft, growing, stable, deprecated
- [ ] `confidence` is one of: low, medium, high
- [ ] `last_compiled` is valid date format (YYYY-MM-DD)

### References (Warnings — should fix)
- [ ] Each `source_refs` entry points to an existing file under `raw/`
- [ ] Each `[[wiki/...]]` link in Connections points to an existing wiki page
- [ ] Page is listed in `index.md`

### Content (Info — human action needed)
- [ ] My Understanding Delta is not empty or just the placeholder text
- [ ] No `<!-- REVIEW: -->` comments remain
- [ ] Open Questions are genuinely open (not answered in Core Concept)

### Staleness (Warnings)
- [ ] Fast-moving domains (ai, frameworks): warn if `last_compiled` > 90 days ago
- [ ] Stable domains: warn if `last_compiled` > 365 days ago

---

## Scaling Guide

| Wiki Size | Strategy | Notes |
|-----------|----------|-------|
| < 50 pages | Read all pages for query | Fits easily in context |
| 50-200 pages | Read index + relevant pages | Two-hop: index routes to pages |
| > 200 pages | Topic sharding | Split wiki/ into domain subdirs, query within shard |

When the wiki grows beyond comfortable context size:
1. Always read `index.md` first
2. Only read pages identified as relevant by the index
3. For cross-domain queries, read the top page from each relevant domain
