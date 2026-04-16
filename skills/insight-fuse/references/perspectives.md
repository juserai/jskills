# Multi-Perspective Framework

Defines how the main agent scores, analyzes consensus, and synthesizes multiple research perspectives into a unified report section.

## Default Perspectives

| Perspective | Focus | Model | Unique Contribution |
|-------------|-------|-------|---------------------|
| Generalist | Breadth, mainstream consensus | Sonnet | Comprehensive coverage, accessible context |
| Critic | Gaps, risks, counter-evidence | Opus | Bias detection, source verification, omission analysis |
| Specialist | Depth, primary sources, data | Sonnet | Technical precision, concrete numbers, expert detail |

## Scoring Dimensions

Rate each anonymous response on 4 research-specific dimensions, 0-10 scale:

| Dimension | What to evaluate | 0 | 5 | 10 |
|-----------|-----------------|---|---|-----|
| **Accuracy** | Source quality + factual correctness | Unsourced or demonstrably wrong | Mostly correct, some weak sources | All claims verified with authoritative sources |
| **Coverage** | Topic breadth, aspects covered | Addresses a fragment | Covers main points, misses some angles | Comprehensive, nothing important omitted |
| **Depth** | Technical detail, data precision | Surface overview only | Reasonable detail, some data | Expert-level with specific numbers and analysis |
| **Objectivity** | Bias detection, balanced presentation | Single viewpoint, marketing language | Mostly balanced with minor bias | Multiple viewpoints, conflicts acknowledged |

### Scoring Rules

1. Score independently — evaluate each response on its own merit before comparing
2. Penalize uncited claims — factual claims without inline citations reduce Accuracy
3. Reward gap identification — meaningful GAPS_IDENTIFIED that reveal research limits improve Coverage
4. Weight source quality — primary sources (official docs, papers) score higher on Accuracy than secondary coverage

### Score Matrix Output

```markdown
| Dimension      | Response A (perspective) | Response B (perspective) | Response C (perspective) |
|----------------|------------------------|------------------------|------------------------|
| Accuracy       | X | X | X |
| Coverage       | X | X | X |
| Depth          | X | X | X |
| Objectivity    | X | X | X |
| **Total**      | XX | XX | XX |
```

## Synthesis Algorithm

### Step 1: Anonymize

Strip PERSPECTIVE labels. Assign random labels Response A/B/C. Randomization prevents positional bias.

### Step 2: Score

Rate each anonymous response on 4 dimensions. Apply scoring rules above.

### Step 3: Consensus Analysis

| Pattern | Condition | Action |
|---------|-----------|--------|
| **Strong consensus** | All 3 KEY_FINDINGS align | High confidence. Use highest-scored as skeleton |
| **Majority + dissent** | 2 align, 1 diverges | Medium confidence. Majority as skeleton, evaluate dissent explicitly |
| **Three-way split** | All 3 diverge | Lower confidence. Highest total score as skeleton, acknowledge disagreement |

### Step 4: Synthesize

1. **Select skeleton**: Highest total score becomes structural foundation
2. **Enrich**: For each non-skeleton response, identify unique insights not in skeleton. If valid, integrate
3. **Preserve objections**: Critic's GAPS_IDENTIFIED and counter-evidence become risk/limitation paragraphs
4. **Reconcile conflicts**: Favor higher Accuracy score. If tied (within 1 point), present both positions

### Step 5: Format

Integrate synthesized content into the report section. Add perspective attribution for deep research sections.

## Built-in Alternative Perspective Sets

| Set | Perspectives | Best for |
|-----|-------------|----------|
| Default | generalist, critic, specialist | General research |
| Futures | optimist, pessimist, pragmatist | Trend forecasting, outlook |
| Product | user, developer, business | Product/technology research |
| Policy | domestic, international, regulatory | Market/policy research |

## Custom Perspectives

1. Create `agents/insight-{name}.md` following the agent template (frontmatter + role + constraints + output)
2. Use `--perspectives name1,name2,name3` to activate (minimum 2, maximum 5)
3. If a named agent file does not exist, fall back to generalist role with the custom perspective label
4. Custom perspectives use the same INSIGHT_RESPONSE format and scoring dimensions

## Anti-Patterns

1. **Average positions** — synthesis is not compromise. Only merge when genuinely warranted
2. **Inflate consensus** — if perspectives genuinely disagree, say so
3. **Ignore the critic** — GAPS_IDENTIFIED always deserve explicit evaluation
4. **Fabricate disagreement** — if all agree, note consensus. Do not invent conflict
5. **Over-synthesize simple topics** — if research converges, brief synthesis beats verbose repetition
