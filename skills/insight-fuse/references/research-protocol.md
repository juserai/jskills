# INSIGHT_RESPONSE Protocol

INSIGHT_RESPONSE is the structured output format for insight-fuse research agents. Each sub-agent outputs exactly one INSIGHT_RESPONSE block. The main agent parses all blocks to score, synthesize, and compile the final report.

## Format

```
---INSIGHT_RESPONSE---
PERSPECTIVE: <generalist|critic|specialist|custom-name>
CONFIDENCE: <1-10>
KEY_FINDINGS:
  - <finding 1>
  - <finding 2>
  - <finding 3>
SOURCES_USED:
  - [title](url) — <credibility note>
  - [title](url) — <credibility note>
  - [title](url) — <credibility note>
GAPS_IDENTIFIED:
  - <information gap 1>
  - <information gap 2>
CONTENT:
  <full research content — multi-paragraph, tables, code blocks allowed>
---END_INSIGHT_RESPONSE---
```

## Field Reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| PERSPECTIVE | **required** | enum/string | Which research role produced this. Standard: generalist, critic, specialist. Custom names allowed |
| CONFIDENCE | **required** | int 1-10 | Self-assessed confidence. 1 = very limited info, 10 = thoroughly verified |
| KEY_FINDINGS | **required** | list (2-5) | Most important discoveries. Main agent uses these for quick cross-perspective comparison |
| SOURCES_USED | **required** | list (3+) | Every source consulted, with URL and credibility annotation |
| GAPS_IDENTIFIED | **required** | list | Information that could not be found or verified. Critical for the critic role |
| CONTENT | **required** | string | Full research text. Must be standalone — not a summary or outline |

## Rules

### Multi-Source Requirement

CONTENT must cite at least **3 distinct sources**. Single-source sections are flagged during synthesis. No single source may account for more than **40%** of citations within a CONTENT block.

### Citation Format

Inline citations within CONTENT: `[SourceName](url)`. Every factual claim — statistics, dates, comparisons, quotes — must have at least one inline citation. Uncited factual claims are treated as unverified.

### Source Credibility

In SOURCES_USED, annotate each source briefly:
- `official docs` — primary/authoritative
- `peer-reviewed` — academic
- `industry report` — Gartner, McKinsey, etc.
- `news coverage` — secondary, verify independently
- `blog/opinion` — lowest weight, cross-check required

### Independence

Each research agent produces their response **independently** via separate Agent instances. They do NOT see other agents' responses. This ensures perspective diversity.

### Completeness

CONTENT should be a complete, publishable research section — not a summary or pointer. The main agent needs full content to evaluate and integrate into the report.

## Auto-Structure Algorithm

When no `--template` is specified, the main agent generates report structure after Stage 1 scan:

1. Analyze collected sources to identify natural topic clusters
2. Generate section headers using Chinese numbered format (一、二、三...)
3. If 3+ comparable items found → include comparison table section
4. If topic is event/timeline-driven → include chronology section
5. If technology topic → include architecture/principles section
6. Always include: overview section (first), action recommendations (second-to-last), references (last)
7. Aim for 8-12 sections for standard depth, 5-7 for quick

## Parsing Logic

1. Collect text between `---INSIGHT_RESPONSE---` and `---END_INSIGHT_RESPONSE---`
2. Extract fields by line-prefix matching (`PERSPECTIVE:`, `CONFIDENCE:`, etc.)
3. Multi-line fields (KEY_FINDINGS, SOURCES_USED, GAPS_IDENTIFIED): collect all `  - ` prefixed lines after the label
4. CONTENT: everything after `CONTENT:` label until `---END_INSIGHT_RESPONSE---`

## Error Handling

| Scenario | Action |
|----------|--------|
| Missing INSIGHT_RESPONSE block | Score 0 on all dimensions; synthesize from remaining |
| Missing fields | Score lower; use available fields |
| Multiple blocks from one agent | Use only the last block |
| CONFIDENCE outside 1-10 | Clamp to nearest valid value |
| Empty CONTENT | Score 0; exclude from synthesis |
| Fewer than 3 sources in SOURCES_USED | Flag in quality check; proceed with available |
