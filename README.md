# Forge

> Forge stronger AI agents. 7 skills for a better coding rhythm with Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-7-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[中文](docs/i18n/README.zh-CN.md) | [日本語](docs/i18n/README.ja.md) | [한국어](docs/i18n/README.ko.md) | [Español](docs/i18n/README.es.md) | [Português](docs/i18n/README.pt-BR.md) | [Français](docs/i18n/README.fr.md) | [Deutsch](docs/i18n/README.de.md) | [Русский](docs/i18n/README.ru.md) | [हिन्दी](docs/i18n/README.hi.md) | [Türkçe](docs/i18n/README.tr.md) | [Tiếng Việt](docs/i18n/README.vi.md)

### Quick Demo

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## Install

```bash
# Claude Code (one command)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Hammer

| Skill | What it does | Try it |
|-------|-------------|--------|
| **block-break** | Forces exhaustive problem-solving before giving up | `/block-break` |
| **ralph-boost** | Autonomous dev loops with convergence guarantee | `/ralph-boost setup` |

### Crucible

| Skill | What it does | Try it |
|-------|-------------|--------|
| **council-fuse** | Multi-perspective deliberation for better answers | `/council-fuse <question>` |
| **insight-fuse** | Systematic multi-source research with professional reports | `/insight-fuse <topic>` |
| **tome-forge** | Personal knowledge base with LLM-compiled wiki | `/tome-forge init` |

### Anvil

| Skill | What it does | Try it |
|-------|-------------|--------|
| **skill-lint** | Validate any Claude Code skill plugin | `/skill-lint .` |

### Quench

| Skill | What it does | Try it |
|-------|-------------|--------|
| **news-fetch** | Quick news between coding sessions | `/news-fetch AI today` |

---

## Block Break — Behavioral Constraint Engine

Your AI gave up? `/block-break` forces it to exhaust every approach first.

When Claude gets stuck, Block Break activates a pressure escalation system that prevents premature surrender. It forces the agent through increasingly rigorous problem-solving stages before allowing any kind of "I can't do this" response.

| Mechanism | Description |
|-----------|-------------|
| **3 Red Lines** | Closed-loop verification / Fact-driven / Exhaust all options |
| **Pressure Escalation** | L0 Trust → L1 Disappointment → L2 Interrogation → L3 Performance Review → L4 Graduation |
| **5-Step Method** | Smell → Pull hair → Mirror → New approach → Retrospect |
| **7-Point Checklist** | Mandatory diagnostic checklist at L3+ |
| **Anti-Rationalization** | Identifies and blocks 14 common excuse patterns |
| **Hooks** | Auto frustration detection + failure counting + state persistence |

```text
/block-break              # Activate Block Break mode
/block-break L2           # Start at a specific pressure level
/block-break fix the bug  # Activate and immediately start a task
```

Also triggers via natural language: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, etc. (auto-detected by hooks).

> Inspired by [PUA](https://github.com/tanweai/pua), distilled into a zero-dependency skill.

## Ralph Boost — Autonomous Dev Loop Engine

Autonomous dev loops that actually converge. Setup in 30 seconds.

Replicates ralph-claude-code's autonomous loop capability as a skill, with built-in Block Break L0-L4 pressure escalation to guarantee convergence. Solves the "spinning without progress" problem in autonomous loops.

| Feature | Description |
|---------|-------------|
| **Dual-Path Loop** | Agent loop (primary, zero external deps) + bash script fallback (jq/python engines) |
| **Enhanced Circuit Breaker** | L0-L4 pressure escalation built-in: from "give up after 3 rounds" to "6-7 rounds of progressive self-rescue" |
| **State Tracking** | Unified state.json for circuit breaker + pressure + strategy + session |
| **Graceful Handoff** | L4 generates structured handoff report instead of raw crash |
| **Independent** | Uses `.ralph-boost/` directory, no dependency on ralph-claude-code |

```text
/ralph-boost setup        # Initialize project
/ralph-boost run          # Start autonomous loop
/ralph-boost status       # Check current state
/ralph-boost clean        # Clean up
```

> Inspired by [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), reimagined as a zero-dependency skill with convergence guarantee.

## Council Fuse — Multi-Perspective Deliberation Engine

Better answers through structured debate. `/council-fuse` spawns 3 independent perspectives, scores them anonymously, and synthesizes the best answer.

Inspired by [Karpathy's LLM Council](https://github.com/karpathy/llm-council) — distilled into a single command.

| Mechanism | Description |
|-----------|-------------|
| **3 Perspectives** | Generalist (balanced) / Critic (adversarial) / Specialist (deep technical) |
| **Anonymous Scoring** | 4-dimension evaluation: Correctness, Completeness, Practicality, Clarity |
| **Synthesis** | Highest-scored response as skeleton, enriched with unique insights |
| **Minority Opinion** | Valid dissenting views preserved, not silenced |

```text
/council-fuse Should we use microservices?
/council-fuse Review this error handling pattern
/council-fuse Redis vs PostgreSQL for job queues
```

## Insight Fuse — Multi-Source Research Engine

From topic to professional research report. `/insight-fuse` runs a 5-stage progressive pipeline: scan → align → research → review → deep dive.

Built-in multi-perspective analysis (Generalist/Critic/Specialist), extensible report templates, and configurable depth. The fuse-series sibling to council-fuse — while council-fuse deliberates on known information, insight-fuse actively gathers and synthesizes new information.

| Mechanism | Description |
|-----------|-------------|
| **5-Stage Pipeline** | Scan → Align → Research → Review → Deep Dive |
| **Configurable Depth** | quick (scan only) / standard (auto research) / deep (+ multi-perspective) / full (+ human gates) |
| **3 Perspectives** | Generalist (breadth) / Critic (verification) / Specialist (precision) |
| **Report Templates** | technology / market / competitive / custom — or auto-generated structure |
| **Quality Standards** | Multi-source enforcement, citation integrity, source diversity checks |

```text
/insight-fuse AI Agent 安全风险
/insight-fuse --depth quick --template technology WebAssembly
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 量子计算商业化
```

## Skill Lint — Skill Plugin Validator

Validate your Claude Code plugins in one command.

Checks structural integrity and semantic quality of skill files in any Claude Code plugin project. Bash scripts handle structural checks, AI handles semantic checks — complementary coverage.

| Check Type | Description |
|------------|-------------|
| **Structural** | Frontmatter required fields / file existence / reference links / marketplace entries |
| **Semantic** | Description quality / name consistency / command routing / eval coverage |

```text
/skill-lint              # Show usage
/skill-lint .            # Validate current project
/skill-lint /path/to/plugin  # Validate a specific path
```

## News Fetch — Your Mental Break Between Sprints

Burned out from debugging? `/news-fetch` — your 2-minute mental break.

The other skills push you to work harder. This one reminds you to take a breath. Grab the latest news on any topic, right from your terminal — no context switching, no browser rabbit holes. Just a quick scan and back to work, refreshed.

| Feature | Description |
|---------|-------------|
| **3-Tier Fallback** | L1 WebSearch → L2 WebFetch (regional sources) → L3 curl |
| **Dedup & Merge** | Same event from multiple sources auto-merged, highest-scoring kept |
| **Relevance Scoring** | AI scores and sorts by topic match |
| **Auto-Summary** | Missing abstracts auto-generated from article body |

```text
/news-fetch AI                    # This week's AI news
/news-fetch AI today              # Today's AI news
/news-fetch robotics month        # This month's robotics news
/news-fetch climate 2026-03-01~2026-03-31  # Custom date range
```

## Tome Forge — Personal Knowledge Base Engine

Build a personal knowledge base that an LLM compiles and maintains. Based on [Karpathy's LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — raw Markdown sources compiled into a structured wiki, no RAG or vector DB needed.

| Feature | Description |
|---------|-------------|
| **Three-Layer Architecture** | Raw Sources (immutable) / Wiki (LLM-compiled) / Schema (CLAUDE.md) |
| **6 Operations** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | Sacred section for human insights — LLM never overwrites |
| **Zero Infra** | Pure Markdown + Git. No databases, no embeddings, no servers |

```text
/tome-forge init              # Initialize KB in current directory
/tome-forge capture "idea"    # Quick-capture a note
/tome-forge ingest raw/paper  # Compile raw material into wiki
/tome-forge query "question"  # Search and synthesize
/tome-forge lint              # Health-check wiki structure
/tome-forge compile           # Batch compile all new materials
```

> Inspired by [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), built as a zero-dependency skill.

## Quality

- 10+ eval scenarios per skill with automated trigger tests
- Self-validated by its own skill-lint
- Zero external dependencies — zero risk
- MIT licensed, fully open source

## Project Structure

```text
forge/
├── skills/                        # Claude Code platform
│   └── <skill>/
│       ├── SKILL.md               # Skill definition
│       ├── references/            # Detailed content (loaded on demand)
│       ├── scripts/               # Helper scripts
│       └── agents/                # Sub-agent definitions
├── platforms/                     # Other platform adaptations
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw adaptation
│           ├── references/        # Platform-specific content
│           └── scripts/           # Platform-specific scripts
├── .claude-plugin/                # Claude Code marketplace metadata
├── hooks/                         # Claude Code platform hooks
├── evals/                         # Cross-platform eval scenarios
├── docs/
│   ├── guide/                     # User guides (English)
│   ├── plans/                     # Design documents
│   └── i18n/                      # Translations (11 languages)
│       ├── README.*.md            # Translated READMEs
│       └── guide/*-guide.*.md     # Translated guides
└── plugin.json                    # Collection metadata
```

## Contributing

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw adaptation + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Eval scenarios
4. `.claude-plugin/marketplace.json` — Add entry to `plugins` array
5. Hooks if needed in `hooks/hooks.json`

See [CLAUDE.md](CLAUDE.md) for full development guidelines.

## License

[MIT](LICENSE) - [Juneq Cheung](https://github.com/juserai)
