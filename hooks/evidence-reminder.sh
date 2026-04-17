#!/usr/bin/env bash
# Claim Ground evidence reminder — fires after Read/Grep/Bash tool use
# Purpose: inject a just-in-time reminder so assistant quotes evidence verbatim
# rather than paraphrasing when about to assert facts about what it just read.
#
# Called by hooks.json on PostToolUse for Read|Grep|Bash matchers.
# Exit 0 always — this is advisory context injection, never a block.

cat << 'EOF'

<CLAIM_GROUND_EVIDENCE_REMINDER>
[Claim Ground 🎯 — 刚读完证据 / Just read runtime evidence]

You just ran a Read/Grep/Bash tool. Before asserting any fact about the
result, quote the specific line or output span **verbatim** — do NOT
paraphrase-only conclusions about what the evidence says.

你刚跑过 Read / Grep / Bash。若要基于此结果做事实断言，必须**逐字引用**
具体行或输出片段，不许只做 paraphrase 概括。

Rules of thumb:
- "The file shows X" → MUST be followed by an actual quoted line
- "The command output indicates Y" → MUST paste the output span
- If you would need to paraphrase because the evidence is inconclusive,
  instead say so explicitly and abstain from the factual assertion.
</CLAIM_GROUND_EVIDENCE_REMINDER>
EOF
