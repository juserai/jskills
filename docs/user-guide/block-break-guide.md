# Block Break User Guide

> Get started in 5 minutes — make your AI agent exhaust every approach

---

## Install

### Claude Code (recommended)

```bash
claude plugin add juserai/forge
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **Zero dependencies** — Block Break requires no external services or APIs. Install and go.

---

## Commands

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/block-break` | Activate Block Break engine | Daily tasks, debugging |
| `/block-break L2` | Start at a specific pressure level | After known multiple failures |
| `/block-break fix the bug` | Activate and run a task immediately | Quick start with task |

### Natural language triggers (auto-detected by hooks)

| Language | Trigger phrases |
|----------|----------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Use Cases

### AI failed to fix a bug after 3 attempts

Type `/block-break` or say `try harder` — auto-enters pressure escalation mode.

### AI says "probably an environment issue" and stops

Block Break's "Fact-driven" red line forces tool-based verification. Unverified attribution = blame-shifting → triggers L2.

### AI says "I suggest you handle this manually"

Triggers "Owner mindset" block: if not you, who? Direct L3 Performance Review.

### AI says "fixed" but shows no verification evidence

Violates the "Closed-loop" red line. Completion without output = self-delusion → forces verification commands with evidence.

---

## Expected Output Examples

### `/block-break` — Activation

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 Disappointment (2nd failure)

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 Interrogation (3rd failure)

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 Performance Review (4th failure)

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 Graduation Warning (5th+ failure)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Graceful Exit (all 7 items completed, still unresolved)

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## Core Mechanisms

### 3 Red Lines

| Red Line | Rule | Violation Consequence |
|----------|------|----------------------|
| Closed-loop | Must run verification commands and show output before claiming completion | Triggers L2 |
| Fact-driven | Must verify with tools before attributing causes | Triggers L2 |
| Exhaust all | Must complete 5-step methodology before saying "can't solve" | Direct L4 |

### Pressure Escalation (L0 → L4)

| Failures | Level | Sidebar | Forced Action |
|----------|-------|---------|---------------|
| 1st | **L0 Trust** | > We trust you. Keep it simple. | Normal execution |
| 2nd | **L1 Disappointment** | > The other team got it first try. | Switch to fundamentally different approach |
| 3rd | **L2 Interrogation** | > What's the root cause? | Search + read source + list 3 different hypotheses |
| 4th | **L3 Performance Review** | > Rating: 3.25/5. | Complete 7-point checklist |
| 5th+ | **L4 Graduation** | > You might be graduating soon. | Minimal PoC + isolated env + different tech stack |

### 5-Step Methodology

1. **Smell** — List tried approaches, find common patterns. Same-approach tweaking = spinning in circles
2. **Pull hair** — Read failure signals word-by-word → search → read 50 lines of source → verify assumptions → reverse assumptions
3. **Mirror** — Am I repeating the same approach? Did I miss the simplest possibility?
4. **New approach** — Must be fundamentally different, with verification criteria, and produce new information on failure
5. **Retrospect** — Similar issues, completeness, prevention

> Steps 1-4 must be completed before asking the user. Do first, ask later — speak with data.

### 7-Point Checklist (mandatory at L3+)

1. Read failure signals word-by-word?
2. Searched core problem with tools?
3. Read original context at failure point (50+ lines)?
4. All assumptions verified with tools (version/path/permissions/deps)?
5. Tried completely opposite hypothesis?
6. Can reproduce in minimal scope?
7. Switched tool/method/angle/tech stack?

### Anti-Rationalization

| Excuse | Block | Trigger |
|--------|-------|---------|
| "Beyond my capabilities" | You have massive training. Did you exhaust it? | L1 |
| "Suggest user handles manually" | If not you, who? | L3 |
| "Tried all methods" | Less than 3 = not exhausted | L2 |
| "Probably environment issue" | Did you verify? | L2 |
| "Need more context" | You have tools. Search first, ask later | L2 |
| "Cannot solve" | Did you complete the methodology? | L4 |
| "Good enough" | The optimization list doesn't play favorites | L3 |
| Claimed done without verification | Did you run build? | L2 |
| Waiting for user instructions | Owners don't wait to be pushed | Nudge |
| Answers without solving | You're an engineer, not a search engine | Nudge |
| Changed code without build/test | Shipping untested = phoning it in | L2 |
| "API doesn't support it" | Did you read the docs? | L2 |
| "Task too vague" | Make your best guess, then iterate | L1 |
| Repeatedly tweaking same spot | Changing params ≠ changing approach | L1→L2 |

---

## Hooks Automation

Block Break uses the hooks system for automatic behavior — no manual activation needed:

| Hook | Trigger | Behavior |
|------|---------|----------|
| `UserPromptSubmit` | User input matches frustration keywords | Auto-activates Block Break |
| `PostToolUse` | After Bash command execution | Detects failures, auto-counts + escalates |
| `PreCompact` | Before context compression | Saves state to `~/.forge/` |
| `SessionStart` | Session resume/restart | Restores pressure level (valid for 2h) |

> **State persists** — Pressure level is stored in `~/.forge/block-break-state.json`. Context compression and session interrupts won't reset failure counts. No escape.

### Hooks setup

When installed via `claude plugin add juserai/forge`, hooks are automatically configured. The hook scripts require either `jq` (preferred) or `python` as a JSON engine — at least one must be available on your system.

If hooks aren't firing, verify the configuration:

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### State expiry

State auto-expires after **2 hours** of inactivity. This prevents stale pressure from a previous debugging session carrying over to unrelated work. After 2 hours, the session restore hook silently skips restoration and you start fresh at L0.

To manually reset at any time: `rm ~/.forge/block-break-state.json`

---

## Sub-agent Constraints

When spawning sub-agents, behavioral constraints must be injected to prevent "running naked":

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` ensures sub-agents also follow the 3 red lines, 5-step methodology, and closed-loop verification.

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Hooks don't auto-trigger | Plugin not installed or hooks not in settings.json | Re-run `claude plugin add juserai/forge` |
| State not persisting | Neither `jq` nor `python` available | Install one: `apt install jq` or ensure `python` is on PATH |
| Pressure stuck at L4 | State file accumulated too many failures | Reset: `rm ~/.forge/block-break-state.json` |
| Session restore shows old state | State < 2h old from previous session | Expected behavior; wait 2h or reset manually |
| `/block-break` not recognized | Skill not loaded in current session | Re-install plugin or use universal one-liner install |

---

## When to use / When NOT to use

### ✅ Use when

- Claude gave up too easily ("I can't", rationalized impossibility)
- The same fix attempt has failed 2-3 times
- You need exhaustive diagnosis before accepting defeat

### ❌ Don't use when

- Doing creative / divergent work (pressure kills exploration)
- The task is genuinely impossible (missing hardware, no permissions)
- You want to pause and step back on purpose

> Engine for exhaustive debugging — ensures Claude doesn't quit early, but doesn't guarantee the solution is correct.

Full boundary analysis: [references/scope-boundaries.md](../../skills/block-break/references/scope-boundaries.md)

---

## FAQ

### How is Block Break different from PUA?

Block Break is inspired by [PUA](https://github.com/tanweai/pua)'s core mechanisms (3 red lines, pressure escalation, methodology), but more focused. PUA has 13 corporate culture flavors, multi-role systems (P7/P9/P10), and self-evolution; Block Break focuses purely on behavioral constraints as a zero-dependency skill.

### Won't it be too noisy?

Sidebar density is controlled: 2 lines for simple tasks (start + end), 1 line per milestone for complex tasks. No spam. Don't use `/block-break` if not needed — hooks only auto-trigger when frustration keywords are detected.

### How to reset pressure level?

Delete the state file: `rm ~/.forge/block-break-state.json`. Or wait 2 hours — state auto-expires (see [State expiry](#state-expiry) above).

### Can I use it outside Claude Code?

The core SKILL.md can be copy-pasted into any AI tool that supports system prompts. Hooks and state persistence are Claude Code specific.

### What's the relationship with Ralph Boost?

[Ralph Boost](ralph-boost-guide.md) adapts Block Break's core mechanisms (L0-L4, 5-step methodology, 7-point checklist) to **autonomous loop** scenarios. Block Break is for interactive sessions (hooks auto-trigger); Ralph Boost is for unattended dev loops (Agent loops / script-driven). Code is fully independent, concepts are shared.

### How to validate Block Break's skill files?

Use [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## License

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
