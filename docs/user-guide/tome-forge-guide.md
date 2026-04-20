# Tome Forge User Guide

> Get started in 5 minutes — personal knowledge base with LLM-compiled wiki

---

## Install

### Claude Code (recommended)

```bash
claude plugin add juserai/forge
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **Zero dependencies** — Tome Forge requires no external services, no vector DB, no RAG infra. Install and go.

---

## Commands

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/tome-forge init` | Initialize a knowledge base | Starting a new KB in any directory |
| `/tome-forge capture [text]` | Quick-capture note, link, or clipboard | Jotting down thoughts, saving URLs, clipping |
| `/tome-forge capture clip` | Capture from system clipboard | Quick save of copied content |
| `/tome-forge ingest <path>` | Compile raw material into wiki | After adding papers, articles, or notes to `raw/` |
| `/tome-forge ingest <path> --dry-run` | Preview routing without writing | Verify before committing changes |
| `/tome-forge query <question>` | Search and synthesize from wiki | Finding answers across your knowledge base |
| `/tome-forge lint` | Health-check wiki structure | Before commits, periodic maintenance |
| `/tome-forge compile` | Batch compile all new raw materials | Catching up after adding multiple raw files |

---

## How It Works

Based on Karpathy's LLM Wiki pattern:

```
raw materials + LLM compilation = structured Markdown wiki
```

### The Two-Layer Architecture

| Layer | Owner | Purpose |
|-------|-------|---------|
| `raw/` | You | Immutable source materials — papers, articles, notes, links |
| `wiki/` | LLM | Compiled, structured, cross-referenced Markdown pages |

The LLM reads your raw materials and compiles them into well-structured wiki pages. You never edit `wiki/` directly — you add raw materials and let the LLM maintain the wiki.

### The Sacred Section

Every wiki page has a `## My Understanding Delta` section. This is **yours** — the LLM will never modify it. Write your personal insights, disagreements, or intuitions here. It survives all recompilations.

---

## KB Discovery — Where Does My Data Go?

You can run `/tome-forge` from **any directory**. It automatically finds the right KB:

| Situation | What happens |
|-----------|-------------|
| Current dir (or parent) contains `.tome-forge.json` | Uses that KB |
| No `.tome-forge.json` found upward | Uses default `~/.tome-forge/` (auto-created if needed) |

This means you can capture notes from any project without `cd`-ing first — everything funnels into your single default KB.

Want separate KBs per project? Use `init .` inside that project directory.

## Workflow

### 1. Initialize

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

After init, the KB directory looks like:

```
~/.tome-forge/               # (or wherever you initialized)
├── .tome-forge.json         # KB marker (auto-generated)
├── CLAUDE.md                # KB schema and rules
├── index.md                 # Wiki page index
├── .gitignore
├── logs/                    # Operation logs (monthly rotation)
│   └── 2026-04.md           # One file per month, never grows too large
├── raw/                     # Your source materials (immutable)
└── wiki/                    # LLM-compiled wiki (auto-maintained)
```

### 2. Capture

From **any directory**, just run:

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

Quick captures go to `raw/captures/{date}/`. For longer materials, drop files directly into `raw/papers/`, `raw/articles/`, etc.

### 3. Ingest

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

The LLM reads the raw file, routes it to the right wiki page(s), and merges new information while preserving your personal notes.

### 4. Query

```
/tome-forge query "what is the relationship between attention and transformers?"
```

Synthesizes an answer from your wiki, citing specific pages. Tells you if information is missing and what raw material to add.

### 5. Maintain

```
/tome-forge lint
/tome-forge compile
```

Lint checks structural integrity. Compile batch-ingests everything new since the last compile.

---

## Directory Structure

```
my-knowledge-base/
├── .tome-forge.json       # KB marker (auto-generated)
├── CLAUDE.md              # Schema and rules (auto-generated)
├── index.md               # Wiki page index
├── .last_compile          # Timestamp for batch compile
├── logs/                  # Operation logs (monthly rotation)
│   └── 2026-04.md
├── raw/                   # Your source materials (immutable)
│   ├── captures/          # Quick captures by date
│   ├── papers/            # Academic papers
│   ├── articles/          # Blog posts, articles
│   ├── books/             # Book notes
│   └── conversations/     # Chat logs, interviews
└── wiki/                  # LLM-compiled wiki (auto-maintained)
    ├── ai/                # Domain directories
    ├── systems/
    └── ...
```

---

## Wiki Page Format

Every wiki page follows a strict template:

```yaml
---
domain: ai
maturity: growing        # draft | growing | stable | deprecated
last_compiled: 2026-04-15
source_refs:
  - raw/papers/attention.md
confidence: medium       # low | medium | high
compiled_by: claude-opus-4-6
---
```

Required sections:
- **Core Concept** — LLM-maintained knowledge
- **My Understanding Delta** — Your personal insights (never touched by LLM)
- **Open Questions** — Unanswered questions
- **Connections** — Links to related wiki pages

---

## Recommended Cadence

| Frequency | Action | Time |
|-----------|--------|------|
| **Daily** | `capture` thoughts, links, clipboard | 2 min |
| **Weekly** | `compile` to batch-process the week's raw materials | 15-30 min |
| **Monthly** | `lint` + review My Understanding Delta sections | 30 min |

**Avoid real-time ingest.** Frequent single-file ingests fragment the wiki's coherence. Batch compile weekly produces better cross-references and more consistent pages.

---

## Scaling Roadmap

| Phase | Wiki Size | Strategy |
|-------|-----------|----------|
| 1. Cold Start (week 1-4) | < 30 pages | Full context read, index.md routing |
| 2. Steady State (month 2-3) | 30-100 pages | Topic sharding (wiki/ai/, wiki/systems/) |
| 3. Scale (month 4-6) | 100-200 pages | Shard-scoped queries, ripgrep supplement |
| 4. Advanced (6+ months) | 200+ pages | Embedding-based routing (not retrieval), incremental compile |

---

## Known Risks

| Risk | Impact | Mitigation |
|------|--------|-----------|
| **Phrasing drift** | Multi-compile smooths out personal voice | `compiled_by` tracks model; raw/ is source of truth; re-compile from raw anytime |
| **Scale ceiling** | Context window limits wiki size | Shard by domain; use index routing; embedding layer when > 200 pages |
| **Vendor lock-in** | Tied to one LLM provider | Raw sources are plain Markdown; switch model and re-compile |
| **Delta corruption** | LLM overwrites personal insights | Post-ingest diff verification auto-restores original Delta |

---

## Platforms

| Platform | How it works |
|----------|-------------|
| Claude Code | Full file system access, parallel reads, git integration |
| OpenClaw | Same operations, adapted for OpenClaw tool conventions |

---

## When to use / When NOT to use

### ✅ Use when

- Building a personal knowledge base from scattered notes
- You want LLM-compiled wiki that preserves human insights
- Zero-infra solution (just Markdown + Git)

### ❌ Don't use when

- Team collaboration or real-time sync (no conflict resolution)
- Ad-hoc notes (too structured — plain Markdown is fine)
- Transactional data (use a real database)

> LLM-compiled personal library — preserves human insights, but built for individuals, not teams or real-time workflows.

Full boundary analysis: [references/scope-boundaries.md](../../skills/tome-forge/references/scope-boundaries.md)

---

## FAQ

**Q: How big can the wiki get?**
A: Under 50 pages, the LLM reads everything. 50-200 pages, it uses the index to navigate. Beyond 200, consider domain sharding.

**Q: Can I edit wiki pages directly?**
A: Only the `## My Understanding Delta` section. Everything else will be overwritten on the next ingest/compile.

**Q: Does it need a vector database?**
A: No. The wiki is plain Markdown. The LLM reads files directly — no embeddings, no RAG, no infra.

**Q: How do I back up my KB?**
A: It's all files in a git repo. `git push` and you're done.

**Q: What if the LLM makes a mistake in the wiki?**
A: Add a correction to `raw/` and re-ingest. The merge algorithm prefers more authoritative sources. Or note disagreements in your My Understanding Delta.
