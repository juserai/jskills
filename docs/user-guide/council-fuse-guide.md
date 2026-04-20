# Council Fuse User Guide

> Get started in 5 minutes — multi-perspective deliberation for better answers

---

## Install

### Claude Code (recommended)

```bash
claude plugin add juserai/forge
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **Zero dependencies** — Council Fuse requires no external services or APIs. Install and go.

---

## Commands

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/council-fuse <question>` | Run a full council deliberation | Important decisions, complex questions |

---

## How It Works

Council Fuse distills Karpathy's LLM Council pattern into a single command:

### Stage 1: Convene

Three agents are spawned **in parallel**, each with a different perspective:

| Agent | Role | Model | Strength |
|-------|------|-------|----------|
| Generalist | Balanced, practical | Sonnet | Mainstream best practices |
| Critic | Adversarial, finds flaws | Opus | Edge cases, risks, blind spots |
| Specialist | Deep technical detail | Sonnet | Implementation precision |

Each agent answers **independently** — they cannot see each other's responses.

### Stage 2: Score

The Chairman (main agent) anonymizes all responses as Response A/B/C, then scores each on 4 dimensions (0-10):

- **Correctness** — factual accuracy, logical soundness
- **Completeness** — coverage of all aspects
- **Practicality** — actionability, real-world applicability
- **Clarity** — structure, readability

### Stage 3: Synthesize

The highest-scored response becomes the skeleton. Unique insights from other responses are integrated. The critic's valid objections are preserved as caveats.

---

## Use Cases

### Architecture decisions

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

The generalist provides balanced tradeoffs, the critic challenges microservices hype, and the specialist details migration patterns. The synthesis gives a conditional recommendation.

### Technology choices

```
/council-fuse Redis vs PostgreSQL for our job queue
```

Three different angles ensure you don't miss operational concerns (critic), implementation details (specialist), or the pragmatic default (generalist).

### Code review

```
/council-fuse Is this error handling pattern correct? <paste code>
```

Get mainstream validation, adversarial edge-case analysis, and deep technical verification in one pass.

---

## Output Structure

Every council deliberation produces:

1. **Score Matrix** — transparent scoring of all three perspectives
2. **Consensus Analysis** — where they agree and disagree
3. **Synthesized Answer** — the fused best answer
4. **Minority Opinion** — valid dissenting views worth noting

---

## Customization

### Change perspectives

Edit `agents/*.md` to define custom council members. Alternative triads:

- Optimist / Pessimist / Pragmatist
- Architect / Implementer / Tester
- User Advocate / Developer / Security Expert

### Change models

Edit the `model:` field in each agent file:

- `model: haiku` — cost-effective councils
- `model: opus` — all-heavyweight for critical decisions

---

## Platforms

| Platform | How council members work |
|----------|------------------------|
| Claude Code | 3 independent Agent spawns in parallel |
| OpenClaw | Single agent, 3 sequential independent reasoning rounds |

---

## When to use / When NOT to use

### ✅ Use when

- Architectural decisions needing multiple perspectives
- You suspect confirmation bias in your current answer
- You want dissenting views preserved, not erased

### ❌ Don't use when

- Pure factual queries (use `claim-ground` instead)
- Creative writing (synthesis flattens style)
- Speed-critical decisions (3 agents run sequentially — not fast)

> Training-knowledge debate engine — surfaces single-perspective blind spots, but the conclusion is still bounded by training knowledge.

Full boundary analysis: [references/scope-boundaries.md](../../skills/council-fuse/references/scope-boundaries.md)

---

## FAQ

**Q: Does it cost 3x the tokens?**
A: Yes, roughly. Three independent responses plus synthesis. Use for decisions that warrant the investment.

**Q: Can I add more council members?**
A: The framework supports it — add another `agents/*.md` file and update the SKILL.md workflow. However, 3 is the sweet spot for cost vs. diversity.

**Q: What if one agent fails?**
A: The Chairman scores that member 0 and synthesizes from the remaining responses. Graceful degradation, no crash.
