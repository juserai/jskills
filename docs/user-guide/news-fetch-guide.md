# News Fetch User Guide

> Get started in 3 minutes — let AI fetch your news briefing

Burned out from debugging? Take 2 minutes, catch up on what's happening in the world, and come back refreshed.

---

## Install

### Claude Code (recommended)

```bash
claude plugin add juserai/forge
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **Zero dependencies** — News Fetch requires no external services or API keys. Install and go.

---

## Commands

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/news-fetch AI` | Fetch this week's AI news | Quick industry update |
| `/news-fetch AI today` | Fetch today's AI news | Daily briefing |
| `/news-fetch robotics month` | Fetch this month's robotics news | Monthly review |
| `/news-fetch climate 2026-03-01~2026-03-31` | Fetch news for a specific date range | Targeted research |

---

## Use Cases

### Daily tech briefing

```
/news-fetch AI today
```

Get the latest AI news for today, ranked by relevance. Scan headlines and summaries in seconds.

### Industry research

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Pull news for a specific time period to support market analysis and competitive research.

### Cross-language news

Chinese topics automatically get supplementary English searches for broader coverage, and vice versa. You get the best of both worlds without extra effort.

---

## Expected Output Example

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## 3-Tier Network Fallback

News Fetch has a built-in fallback strategy to ensure news retrieval works across different network conditions:

| Tier | Tool | Data Source | Trigger |
|------|------|-------------|---------|
| **L1** | WebSearch | Google/Bing | Default (preferred) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 fails |
| **L3** | Bash curl | Same as L2 sources | L2 also fails |

When all tiers fail, a structured failure report is produced listing the failure reason for each source.

---

## Output Features

| Feature | Description |
|---------|-------------|
| **Deduplication** | When multiple sources cover the same event, the highest-scoring entry is kept; others are collapsed into "Related coverage" |
| **Summary completion** | If search results lack a summary, the article body is fetched and a summary is generated |
| **Relevance scoring** | AI scores each result by topic relevance — higher means more relevant |
| **Clickable links** | Markdown link format — clickable in IDEs and terminals |

---

## Relevance Scoring

Each article is scored 0-300 based on how well its title and summary match the requested topic:

| Score Range | Meaning |
|-------------|---------|
| 200-300 | Highly relevant — topic is the primary subject |
| 100-199 | Moderately relevant — topic is mentioned significantly |
| 0-99 | Tangentially relevant — topic appears in passing |

Articles are sorted by score in descending order. The scoring is heuristic and based on keyword density, title match, and contextual relevance.

## Network Fallback Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| L1 returns 0 results | WebSearch tool unavailable or query too specific | Broaden the topic keyword |
| L2 all sources fail | Domestic news sites blocking automated access | Wait and retry, or check if `curl` works manually |
| L3 curl timeouts | Network connectivity issue | Check `curl -I https://news.baidu.com` |
| All tiers fail | No internet access or all sources down | Verify network; the failure report lists each source's error |

---

## When to use / When NOT to use

### ✅ Use when

- You want a quick news brief between coding sessions
- Bilingual aggregation (English + domestic sources)
- Network-restricted environments (3-tier fallback handles blocked sources)

### ❌ Don't use when

- You need synthesized research (use `insight-fuse` instead)
- Targeted source monitoring (use an RSS reader)
- Translation tasks (news-fetch returns source language as-is)

> News brief for coding breaks — 2-minute scan, not a research tool or translator.

Full boundary analysis: [references/scope-boundaries.md](../../skills/news-fetch/references/scope-boundaries.md)

---

## FAQ

### Do I need an API key?

No. News Fetch relies entirely on WebSearch and public web scraping. Zero configuration required.

### Can it fetch English-language news?

Absolutely. Chinese topics automatically include supplementary English searches, and English topics work natively. Coverage spans both languages.

### What if my network is restricted?

The 3-tier fallback strategy handles this automatically. Even if WebSearch is unavailable, News Fetch falls back to domestic news sources.

### How many articles does it return?

Up to 20 (after deduplication). The actual count depends on what the data sources return.

---

## License

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
