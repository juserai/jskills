# Ralph Boost User Guide

> Get started in 5 minutes — keep your AI autonomous dev loop from stalling out

---

## Install

### Claude Code (recommended)

```bash
claude plugin add juserai/forge
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **Zero dependencies** — Ralph Boost does not depend on ralph-claude-code, block-break, or any external service. The primary path (Agent loop) has zero external dependencies; the fallback path requires `jq` or `python` and the `claude` CLI.

---

## Commands

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/ralph-boost setup` | Initialize autonomous loop in your project | First-time setup |
| `/ralph-boost run` | Start the autonomous loop in the current session | After initialization |
| `/ralph-boost status` | View current loop state | Monitor progress |
| `/ralph-boost clean` | Remove loop files | Cleanup |

---

## Quick Start

### 1. Initialize the project

```text
/ralph-boost setup
```

Claude will walk you through:
- Detecting the project name
- Generating a task list (fix_plan.md)
- Creating the `.ralph-boost/` directory and all configuration files

### 2. Start the loop

```text
/ralph-boost run
```

Claude drives the autonomous loop directly within the current session (Agent loop mode). Each iteration spawns a sub-agent to execute a task, while the main session acts as the loop controller managing state.

**Fallback** (headless / unattended environments):

```bash
# Foreground
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Background
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Monitor status

```text
/ralph-boost status
```

Example output:

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## How It Works

### Autonomous Loop

Ralph Boost provides two execution paths:

**Primary path (Agent loop)**: Claude acts as the loop controller within the current session, spawning a sub-agent each iteration to execute tasks. The main session manages state, the circuit breaker, and pressure escalation. Zero external dependencies.

**Fallback (bash script)**: `boost-loop.sh` runs `claude -p` calls in a loop in the background. Supports both jq and python as JSON engines, auto-detected at runtime. Default sleep between iterations is 1 hour (configurable).

Both paths share the same state management (state.json), pressure escalation logic, and BOOST_STATUS protocol.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Enhanced Circuit Breaker (vs ralph-claude-code)

ralph-claude-code's circuit breaker: gives up after 3 consecutive loops with no progress.

ralph-boost's circuit breaker: **escalates pressure progressively** when stuck, up to 6-7 loops of self-recovery before stopping.

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## Expected Output Examples

### L0 — Normal Execution

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — Approach Switch

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude is forced to abandon the previous approach and try something **fundamentally different**. Tweaking parameters doesn't count.

### L2 — Search and Hypothesize

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude must: read the error word-by-word → search 50+ lines of context → list 3 different hypotheses.

### L3 — Checklist

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude must complete the 7-point checklist (read error signals, search core problem, read source, verify assumptions, reverse hypothesis, minimal reproduction, switch tools/methods). Each completed item is written to state.json.

### L4 — Graceful Handoff

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude builds a minimal PoC, then generates a handoff report:

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

After the handoff is complete, the loop shuts down gracefully. This isn't "I can't" — it's "here's where the boundary is."

---

## Configuration

`.ralph-boost/config.json`:

| Field | Default | Description |
|-------|---------|-------------|
| `max_calls_per_hour` | 100 | Maximum Claude API calls per hour |
| `claude_timeout_minutes` | 15 | Timeout per individual call |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Tools available to Claude |
| `claude_model` | "" | Model override (empty = default) |
| `session_expiry_hours` | 24 | Session expiration time |
| `no_progress_threshold` | 7 | No-progress threshold before shutdown |
| `same_error_threshold` | 8 | Same-error threshold before shutdown |
| `sleep_seconds` | 3600 | Wait time between iterations (seconds) |

### Common configuration tweaks

**Speed up the loop** (for testing):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Restrict tool permissions**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Use a specific model**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Project Directory Structure

```
.ralph-boost/
├── PROMPT.md           # Dev instructions (includes block-break protocol)
├── fix_plan.md         # Task list (auto-updated by Claude)
├── config.json         # Configuration
├── state.json          # Unified state (circuit breaker + pressure + session)
├── handoff-report.md   # L4 handoff report (generated on graceful exit)
├── logs/
│   ├── boost.log       # Loop log
│   └── claude_output_*.log  # Per-iteration output
└── .gitignore          # Ignores state and logs
```

All files stay within `.ralph-boost/` — your project root is never touched.

---

## Relationship with ralph-claude-code

Ralph Boost is an **independent replacement** for [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), not an enhancement plugin.

| Aspect | ralph-claude-code | ralph-boost |
|--------|-------------------|-------------|
| Form | Standalone Bash tool | Claude Code skill (Agent loop) |
| Install | `npm install` | Claude Code plugin |
| Code size | 2000+ lines | ~400 lines |
| External deps | jq (required) | Primary path: zero; Fallback: jq or python |
| Directory | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Passive (gives up after 3 loops) | Active (L0-L4, 6-7 loops of self-recovery) |
| Coexistence | Yes | Yes (zero file conflicts) |

Both can be installed in the same project simultaneously — they use separate directories and don't interfere with each other.

---

## Relationship with Block Break

Ralph Boost adapts Block Break's core mechanisms (pressure escalation, 5-step methodology, checklist) to autonomous loop scenarios:

| Aspect | block-break | ralph-boost |
|--------|-------------|-------------|
| Scenario | Interactive sessions | Autonomous loops |
| Activation | Hooks auto-trigger | Built into Agent loop / loop script |
| Detection | PostToolUse hook | Agent loop progress detection / script progress detection |
| Control | Hook-injected prompts | Agent prompt injection / --append-system-prompt |
| State | `~/.forge/` | `.ralph-boost/state.json` |

Code is fully independent; concepts are shared.

> **Reference**: Block Break's pressure escalation (L0-L4), 5-step methodology, and 7-point checklist form the conceptual foundation of ralph-boost's circuit breaker. See the [Block Break User Guide](block-break-guide.md) for details.

---

## When to use / When NOT to use

### ✅ Use when

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ Don't use when

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> Autonomous dev loop with convergence guarantee — needs clear goals and a stable environment to truly converge.

Full boundary analysis: [references/scope-boundaries.md](../../skills/ralph-boost/references/scope-boundaries.md)

---

## FAQ

### How do I choose between the primary path and fallback?

`/ralph-boost run` uses the Agent loop (primary path) by default, running directly within the current Claude Code session. Use the fallback bash script when you need headless or unattended execution.

### Where is the loop script located?

After installing the forge plugin, the fallback script is at `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`. You can also copy it anywhere and run it from there. The script auto-detects jq or python as its JSON engine.

### How do I view the loop logs?

```bash
tail -f .ralph-boost/logs/boost.log
```

### How do I manually reset the pressure level?

Edit `.ralph-boost/state.json`: set `pressure.level` to 0 and `circuit_breaker.consecutive_no_progress` to 0. Or simply delete state.json and re-initialize.

### How do I modify the task list?

Edit `.ralph-boost/fix_plan.md` directly, using `- [ ] task` format. Claude reads it at the start of each iteration.

### How do I recover after the circuit breaker opens?

Edit `state.json`, set `circuit_breaker.state` to `"CLOSED"`, reset the relevant counters, and re-run the script.

### Do I need ralph-claude-code?

No. Ralph Boost is fully independent and does not depend on any Ralph files.

### What platforms are supported?

Currently supports Claude Code (Agent loop primary path). The fallback bash script requires bash 4+, jq or python, and the claude CLI.

### How to validate ralph-boost's skill files?

Use [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## License

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
