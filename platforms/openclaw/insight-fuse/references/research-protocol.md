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
6. Always include: overview section (first), references (last). End the body with a neutral **"Outlook / 格局启示"** section — describe industry trends, moat structures, likely winners and losers as impersonal observations. Do NOT address any specific reader, company, or product team. Do NOT write sections titled "对 X 的建议 / 给 X 的启示 / 对我们的启发 / 为 X 设计"; those belong to advisory/brainstorming skills, not research
7. Aim for 8-12 sections for standard depth, 5-7 for quick

## Advisory Appendix Protocol

Advisory Appendix is rendered **only when the user explicitly authorizes it** via:

- `--audience "<角色1,角色2,...>"` parameter, or
- In `--depth full` mode, user-confirmed audiences via interactive prompt

If neither condition holds (or `--no-advisory` is set), the report body ends after the Outlook section and references; **no Appendix is produced**.

### Rendering rules

1. **One Appendix per audience**, lettered sequentially: `Appendix A`, `Appendix B`, `Appendix C`…
2. **Physical separation from the main body**: each Appendix MUST begin with a `---` horizontal rule, followed by a level-2 heading `## Appendix {letter} — 针对 {audience} 的建议`.
3. **Authorization stamp (3 lines)** immediately after the heading, as a blockquote:
   - Line 1: `> 授权戳：{YYYY-MM-DD} | --audience="{audience}" --strategy={strategy}`
   - Line 2: `> 基于主体：§{cited sections} | 命令：{original /insight-fuse invocation}`
   - Line 3: `> **本节非中立调研，为用户显式请求后产出**`
4. **Audience value provenance**: the `{audience}` token MUST be copied verbatim from the `--audience` parameter value (or from the user's interactive selection in `full` mode). It MUST NOT be inferred from CWD, additional working directories, IDE-opened files, chat history, or any other environmental signal.
5. **Six-section structure** (strict — see `quality-standards.md` Check 9 for the full rubric):
   - `### 1. 受众画像` — 2-4 items describing the audience's concerns, constraints, decision boundaries
   - `### 2. 调研依据（引用主体）` — every claim must cite a main-body section by number (e.g., "§三对比表显示…"); no new external facts introduced here
   - `### 3. 推导链（if-then）` — stepwise reasoning from facts + assumptions → observations → conclusions; no unsupported leaps
   - `### 4. 策略梯度` — a comparison table with three columns (保守 / 中庸 / 激进). The column matching the `--strategy` parameter is marked as the recommended column (e.g., with a ✓ or bold)
   - `### 5. 风险与反事实` — enumerated risks with mitigations, plus at least one counterfactual ("若假设 A 不成立 → ...")
   - `### 6. 行动清单` — items ranked by confidence: **High** (strong data) / **Medium** (needs verifiable assumption) / **Low** (exploratory)
6. **Strategy parameter effect**: `--strategy` only affects which column in §4 is highlighted. It does NOT change the content of other sections (all three strategy options are described in §4 for comparison).
7. **No cross-contamination**: Appendix content MUST NOT alter the main body. If writing the Appendix reveals a factual error in the body, the main agent should fix the body and regenerate; do not patch via Appendix.

### Failure handling

- If the `--audience` value is empty after trimming, treat as "no audience" (skip Advisory).
- If a specified audience appears outside the whitelist (see `quality-standards.md`), treat it as a user-authorized custom audience and record it verbatim in the authorization stamp.
- If the main body has fewer than 3 numbered sections, the Appendix §2 constraint ("cite main body by section number") may fail Check 9 — in that case, main agent should note this limitation and proceed, or ask the user to re-run with a deeper `--depth`.

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
