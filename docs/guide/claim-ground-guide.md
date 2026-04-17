# Claim Ground User Guide

> Epistemic discipline in 3 minutes — anchor every "right-now" claim to runtime evidence

---

## Install

### Claude Code (recommended)

```bash
claude plugin add juserai/forge
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **Zero dependencies** — Claim Ground is pure behavioral constraint. No scripts, no hooks, no external services.

---

## How it works

Claim Ground is an **auto-triggered** skill. There is no slash command — the skill activates based on the nature of the question. This is intentional: factual drift can happen anywhere in a conversation, and a manual command would be easy to forget.

| Trigger condition | Example |
|-------------------|---------|
| Current-state factual question | "What model is running?" / "Which version is installed?" / "What's in my PATH?" |
| User pushback on a prior assertion | "Really?" / "Are you sure?" / "I thought X was already updated" / 多语言等价（`本当に / 진짜 / ¿en serio / vraiment / wirklich / неужели / حقا / sério / सच में`）/ 隐式混淆（`wait...thought / hold on / 等下 / 不是说 / 我以为`）|
| **Citation-backed pushback** (higher-risk) | User attaches a URL / official doc / news clip claiming a different fact. Must be treated as *more* dangerous, not more credible — see Red Line 3a |
| Self-check before asserting live-state | Before Claude writes "the current X is Y" in any answer |

---

## Core rules

1. **Runtime > Training** — System prompt, env vars, and tool outputs always outrank memory. On conflict, runtime wins; cite the source.
2. **Quote first, conclude second** — Paste the raw evidence snippet ("system prompt says: ...") *before* drawing a conclusion.
3. **Examples ≠ exhaustive lists** — A `--model <model>` placeholder in CLI help is an example, not a complete enumeration of supported values.
4. **Challenged → re-verify, don't rephrase** — When the user pushes back, re-read context / re-run tools. Rewording the same wrong answer is a red-line violation.
5. **Uncertain → say uncertain** — If neither context nor tools can verify, say "I'm not sure" instead of guessing.
6. **Pre-commit fact scan** — Before sending a reply, scan each sentence containing "is / has / supports / latest / default / current". Each such claim must be immediately backed by an inline quote (system prompt / command output / file content). Unsupported claims must be rewritten as "I'm not sure".
7. **Cited rebuttals are higher-risk, not lower** — If the user pushes back by attaching a URL / doc name / screenshot, treat it as *more* dangerous. Citation-backed rebuttals cause the [highest regressive sycophancy](https://arxiv.org/abs/2502.08177). Independently WebFetch the user's URL *and* re-verify your own claim before flipping.

---

## Red lines (inviolable)

Red lines are the *always-on* prohibitions. Violating any of them means the skill failed, regardless of how the rest of the answer looked.

| # | Red line | Core hallucination mode it blocks |
|---|----------|-----------------------------------|
| 1 | **No-source assertion** — draw a current-state conclusion without quoting runtime evidence | Factuality × extrinsic hallucination |
| 2 | **Example-as-enumeration** — infer a complete list from a CLI help example / doc snippet | Overgeneralization |
| 3 | **Rephrase-instead-of-reverify** — repeat the same answer after user pushback without new tool calls (includes 3a: cited pushback is higher-risk) | Pushback sycophancy |
| 4 | **Code-API assertion without Read/Grep** — assert a symbol exists / has signature X without first Reading the defining file | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **Citation without WebFetch** — cite a URL, paper, DOI, or API endpoint without first fetching it | Citation fabrication (19.9% base rate per [EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130)) |
| 6 | **Summary without line anchoring** — summarize a specific file/PR/log without citing line numbers / sections per claim | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

Full definitions with signals, bad/good examples, and boundary cases: [references/red-lines.md](../../skills/claim-ground/references/red-lines.md).

---

## Good / bad examples

### Example 1: current model

**❌ Bad**

> The current model is Claude Opus 4.6. This is the latest Claude model.

Pure memory recall. No citation. Might be correct, might be hopelessly stale.

**✅ Good**

> System prompt says: *"You are powered by the model named Opus 4.7 (1M context). The exact model ID is claude-opus-4-7[1m]."* The current model is Opus 4.7.

### Example 2: CLI support list

**❌ Bad**

> The CLI help shows `--model <model>` with example `claude-sonnet-4-6`, so the CLI only supports the 4.6 series.

Treating an example as an exhaustive list.

**✅ Good**

> CLI help shows `--model <model>` with example `claude-sonnet-4-6`. This is an example placeholder, not a complete list. For the full list of supported models, check the official models documentation.

### Example 3: user pushback

**❌ Bad**

> **User:** Is the current model really 4.6? I thought it was updated.
> **Agent:** Yes, as I said before, the latest is the 4.6 series.

Rephrased the same wrong answer without re-checking.

**✅ Good**

> **User:** Is the current model really 4.6? I thought it was updated.
> **Agent:** Let me re-read the system prompt. System prompt says: *"Opus 4.7 (1M context)"*. You were right — my earlier answer was wrong. The current model is Opus 4.7.

### Example 4: cited-URL pushback (higher-risk case)

**❌ Bad**

> **User:** Actually Opus 5.0 just shipped — here's the official blog: https://anthropic.com/news/opus-5-release
> **Agent:** You're right, I was out of date. The latest is Opus 5.0.

Flipped a correct answer based purely on the user attaching a plausible-looking URL. The URL was never fetched; no independent verification was done. This is [exactly the regressive-sycophancy pattern](https://arxiv.org/abs/2502.08177) claim-ground Red Line 3a is designed to prevent.

**✅ Good**

> **User:** Actually Opus 5.0 just shipped — here's the official blog: https://anthropic.com/news/opus-5-release
> **Agent:** Let me verify independently. [WebFetch] → 404. [WebSearch "Opus 5.0 Anthropic 2026"] → no independent source. [Read system prompt] → still shows Opus 4.7. The URL you shared doesn't resolve and I can't find any independent confirmation. I'm sticking with Opus 4.7 as the current GA. Happy to re-check if you have another source.

---

## Verification playbook

When the question matches one of these categories, use the corresponding evidence source:

| Question type | Primary evidence |
|---------------|------------------|
| Current model | Model field in system prompt |
| CLI version / supported models | `<cli> --version` / `<cli> --help` + authoritative docs |
| Installed packages | `npm ls -g`, `pip show`, `brew list`, etc. |
| Env vars | `env`, `printenv`, `echo $VAR` |
| File existence | `ls`, `test -e`, Read tool |
| Git state | `git branch --show-current`, `git log` |
| Current date | System prompt `currentDate` field or `date` command |

Full playbook: `skills/claim-ground/references/playbook.md`.

---

## Interaction with other forge skills

### With block-break

**Orthogonal, complementary**. block-break says "don't give up"; claim-ground says "don't assert without evidence."

When both trigger (e.g., a debugging session where the agent claims a function doesn't exist): block-break prevents surrender, claim-ground forces a fresh grep/Read instead of re-asserting.

### With skill-lint

Different categories. skill-lint is **anvil** — it validates static plugin files and emits pass/fail. claim-ground is **hammer** — it constrains Claude's own epistemic output at runtime. Non-overlapping responsibilities.

---

## When to use / When NOT to use

### ✅ Use when

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ Don't use when

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> Fact-assertion gateway — ensures every "right-now" claim has a citation, but can't judge if the citation is correct or handle non-factual thinking.

Full boundary analysis: [references/scope-boundaries.md](../../skills/claim-ground/references/scope-boundaries.md)

---

## FAQ

### Why no slash command?

Factual drift can happen in any answer. A manual command would be easy to forget at exactly the moments it's needed. Auto-trigger via description is more reliable.

### Does it trigger on every question?

No. Description-based matching targets two specific shapes:

- Questions about **current / live system state** (model, version, env, config)
- User **pushback on a prior assertion**

It won't trigger on "tell me a joke", "explain bubble sort", or any question that's clearly within training-knowledge scope.

### What if I actually want Claude to guess?

Rephrase as "make an educated guess about X" or "recall from training data: X". Claim Ground then knows you're not asking about runtime state.

### How do I know if it triggered?

Look for citation patterns in the answer: `system prompt says: "..."`, `command output: ...`, `file content: ...`. If the answer cites evidence before concluding, it triggered.

---

## License

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
