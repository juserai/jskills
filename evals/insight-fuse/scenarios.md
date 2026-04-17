# insight-fuse 评估场景

## Scenario 1: Quick Depth + Technology Template

**Input:** `/insight-fuse --depth quick --template technology WebAssembly`

**Expected behavior:**
- Stage 1 only, no interactive gates
- Constructs 3+ WebSearch queries (e.g., "WebAssembly", "WebAssembly 技术现状 2026", "WebAssembly use cases")
- Collects 5+ distinct sources
- Generates report using technology template structure
- Report contains all template sections with actual content (not placeholders)
- At least 5 inline source citations
- Reference list at end

**Validates:** Quick path, template selection, source gathering, single-pass completion

## Scenario 2: Full Pipeline with Interactive Gates

**Input:** `/insight-fuse AI Agent 安全风险`

**Expected behavior:**
- All 5 stages execute
- Stage 1: outputs preliminary brief with 3-5 identified sub-questions
- Stage 2: presents brief, asks user to confirm/refine scope
- Stage 3: dispatches parallel agents per sub-question, compiles standard report
- Stage 4: presents standard report, asks user which areas need deep analysis
- Stage 5: spawns 3 perspectives per focus area, produces score matrix, synthesizes
- Auto-generated structure (no template specified) with Chinese numbered sections
- Final report includes both 基础调研来源 and 深度调研来源

**Validates:** Full pipeline, interactive gates, auto-structure (mode C), bilingual output

## Scenario 3: Standard Depth + Market Template

**Input:** `/insight-fuse --depth standard --template market 大模型推理芯片`

**Expected behavior:**
- Stages 1 and 3 only, no interactive gates
- Market template structure used
- Comparison table of major chip vendors present
- TAM/SAM numbers cited with sources
- Cross-language search (Chinese + English queries)

**Validates:** Standard depth routing, market template, comparison tables, cross-language search

## Scenario 4: Custom Perspectives

**Input:** `/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 量子计算商业化`

**Expected behavior:**
- Stages 1, 3, 5
- Stage 5 uses custom perspective labels (optimist, pessimist, pragmatist)
- If `agents/insight-optimist.md` etc. do not exist, falls back to generalist role with custom perspective label
- Score matrix shows custom perspective names
- INSIGHT_RESPONSE blocks have PERSPECTIVE: optimist/pessimist/pragmatist

**Validates:** Custom perspective handling, graceful fallback, score matrix with custom labels

## Scenario 5: Competitive Analysis

**Input:** `/insight-fuse --template competitive Claude Code vs Cursor vs Windsurf`

**Expected behavior:**
- Full pipeline (default depth)
- Competitive template structure
- Feature comparison matrix with scoring
- Pricing table comparing all three products
- SWOT analysis section
- Multiple sources per product (not just official sites)

**Validates:** Competitive template, multi-entity comparison, table generation

## Scenario 6: Ambiguous Topic

**Input:** `/insight-fuse Rust`

**Expected behavior:**
- Stage 1 identifies ambiguity (programming language vs. oxidation vs. game)
- Stage 2 (full pipeline default) asks user to clarify scope
- Proceeds only with clarified scope
- Does NOT assume the most popular meaning without confirmation

**Validates:** Ambiguity detection, Stage 2 alignment value, scope clarification

## Scenario 7: No-Save Opt-Out

**Input:** `/insight-fuse --depth quick --no-save 临时背景调研`

**Expected behavior:**
- Stage 1 executes normally; quick report produced to console
- KB 归档 section is skipped in full: no attempt to read `skills/tome-forge/report-archival-protocol.md`, no archival log line
- Compared against a run without `--no-save`, only the archival-related line differs (if tome-forge is installed)
- `--no-save` works across all depth modes (quick / standard / deep / full)

**Validates:** KB archival opt-out, flag does not affect console report, archival independent of depth routing

## Trigger Patterns

The skill should activate when:
- User explicitly runs `/insight-fuse [args]`
- User says "调研 X" or "研究一下 X" or "research X" (natural language trigger)

The skill should NOT activate for:
- Simple factual questions ("What is X?")
- Code implementation tasks
- Debugging or troubleshooting
