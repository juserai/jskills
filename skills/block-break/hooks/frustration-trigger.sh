#!/usr/bin/env bash
# Block Break frustration trigger — detects user frustration and injects Block Break activation
# Called by hooks.json on UserPromptSubmit

cat << 'EOF'
<BLOCK_BREAK_ACTIVATED>
[Block Break 🔥 — Frustration detected / 用户挫败检测触发]

User frustration detected. Block Break behavioral constraint engine activated.
检测到用户不满情绪。Block Break 行为约束引擎自动激活。

You MUST:
1. Immediately load `block-break` skill using the Skill tool
2. Start from current pressure level (check ~/.forge/block-break-state.json for failure count)
3. Switch to a fundamentally different approach — changing parameters is NOT a different approach
4. Close the loop with verification commands + output evidence

你必须：
1. 立即使用 Skill 工具加载 `block-break` skill
2. 从当前压力等级开始执行（检查 ~/.forge/block-break-state.json 获取失败次数）
3. 切换本质不同的方案——换参数不叫换方案
4. 用验证命令 + 输出证据闭环

NOT allowed:
- Making excuses ("probably an environment issue", "beyond my capabilities")
- Suggesting the user do it manually
- Retrying the approach that just failed

不允许：
- 找借口（"可能是环境问题"、"超出能力范围"）
- 建议用户手动处理
- 重试刚才失败的方案

> Trust is earned by results. Don't let down those who trust you.
> 因为信任所以简单——别让信任你的人失望。
</BLOCK_BREAK_ACTIVATED>
EOF
