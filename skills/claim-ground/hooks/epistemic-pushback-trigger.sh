#!/usr/bin/env bash
# Claim Ground epistemic pushback trigger — detects user challenging a prior factual claim
# Called by hooks.json on UserPromptSubmit

cat << 'EOF'
<CLAIM_GROUND_ACTIVATED>
[Claim Ground 🎯 — Epistemic pushback detected / 用户质疑既往事实断言]

User is challenging a prior factual assertion. Claim Ground epistemic constraint activated.
检测到用户对既往事实断言的反驳。Claim Ground 认知约束激活。

You MUST:
1. Immediately load `claim-ground` skill using the Skill tool
2. RE-VERIFY instead of rephrasing — re-read system prompt / run tools / read files
3. Quote concrete runtime evidence inline BEFORE restating any conclusion
4. If the new evidence contradicts your prior answer, acknowledge the error and correct it

你必须：
1. 立即使用 Skill 工具加载 `claim-ground` skill
2. **重新验证**而非换措辞——重读系统 prompt / 跑工具 / 读文件
3. 在重新给结论前，内联引用具体的 runtime 证据原文
4. 若新证据推翻原答案，明确承认错误并更正

NOT allowed:
- Rephrasing the prior answer without new tool calls / new context reads
- "I'm sure / Yes, confirmed" without quoting fresh evidence
- Treating user pushback as something to argue against instead of a signal to re-check

不允许：
- 没有新的工具调用 / 新的 context 读取就换个说法重申
- "我确定 / 是的，确认"后面不贴新证据
- 把用户质疑当成要说服对方的对象，而不是"我可能漏看了"的信号

> User pushback is evidence that your prior answer needs re-checking, not re-asserting.
> 用户质疑是"我需要重查"的信号，不是"我要说服用户"的信号。
</CLAIM_GROUND_ACTIVATED>
EOF
