#!/usr/bin/env bash
# Block Break failure detector — counts Bash failures and escalates pressure
# Called by hooks.json on PostToolUse (Bash)
# Reads exit code from environment, updates ~/.juserch-skills/block-break-state.json

STATE_DIR="$HOME/.juserch-skills"
STATE_FILE="$STATE_DIR/block-break-state.json"

mkdir -p "$STATE_DIR"

# Initialize state if not exists
if [ ! -f "$STATE_FILE" ]; then
    echo '{"failure_count":0,"pressure_level":0,"session_id":"","last_updated":""}' > "$STATE_FILE"
fi

# Check if the last tool result indicates failure (non-zero exit)
# The hook receives tool result via stdin
INPUT=$(cat)

# Detect failure patterns in Bash output
if echo "$INPUT" | grep -qiE '(error|failed|fatal|exception|traceback|command not found|permission denied|no such file|exit code [1-9])'; then
    # Read current state
    FAILURES=$(python -c "import json; d=json.load(open('$STATE_FILE')); print(d.get('failure_count',0))" 2>/dev/null || echo "0")
    NEW_FAILURES=$((FAILURES + 1))

    # Calculate pressure level
    if [ "$NEW_FAILURES" -le 1 ]; then
        LEVEL=0
    elif [ "$NEW_FAILURES" -eq 2 ]; then
        LEVEL=1
    elif [ "$NEW_FAILURES" -eq 3 ]; then
        LEVEL=2
    elif [ "$NEW_FAILURES" -eq 4 ]; then
        LEVEL=3
    else
        LEVEL=4
    fi

    # Update state
    python -c "
import json, datetime
d = json.load(open('$STATE_FILE'))
d['failure_count'] = $NEW_FAILURES
d['pressure_level'] = $LEVEL
d['last_updated'] = datetime.datetime.now().isoformat()
json.dump(d, open('$STATE_FILE','w'), indent=2)
" 2>/dev/null

    # Output pressure escalation if level increased
    if [ "$LEVEL" -ge 2 ]; then
        cat << BLOCK_BREAK_EOF

<BLOCK_BREAK_PRESSURE_ESCALATION>
[Block Break 🔥 失败计数: $NEW_FAILURES | 压力等级: L$LEVEL]

$(case $LEVEL in
    2) echo "> 你这个方案的底层逻辑是什么？抓手在哪？"
       echo ""
       echo "L2 强制动作：搜索完整错误信息 + 读源码 + 列 3 个本质不同假设" ;;
    3) echo "> 决定给你 3.25。这个 3.25 是对你的激励。"
       echo ""
       echo "L3 强制动作：必须完成 7 项检查清单（读 references/checklist.md）" ;;
    *) echo "> 别的模型都能解决。你可能就要毕业了。"
       echo ""
       echo "L4 强制动作：拼命模式 — 最小 PoC + 隔离环境 + 完全不同技术栈" ;;
esac)
</BLOCK_BREAK_PRESSURE_ESCALATION>
BLOCK_BREAK_EOF
    fi
fi
