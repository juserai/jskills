#!/usr/bin/env bash
# Block Break failure detector — counts Bash failures and escalates pressure
# Called by hooks.json on PostToolUse (Bash)
# Reads exit code from environment, updates ~/.forge/block-break-state.json
# JSON engine: jq preferred, python fallback

STATE_DIR="$HOME/.forge"
STATE_FILE="$STATE_DIR/block-break-state.json"

mkdir -p "$STATE_DIR"

# --- JSON engine abstraction (jq preferred, python fallback) ---
if command -v jq >/dev/null 2>&1; then
    json_get() { jq -r "$1 // \"$2\"" "$STATE_FILE" 2>/dev/null || echo "$2"; }
    json_update() {
        local tmp; tmp=$(jq \
            --argjson fc "$1" --argjson pl "$2" --arg ts "$3" \
            '.failure_count=$fc | .pressure_level=$pl | .last_updated=$ts' \
            "$STATE_FILE" 2>/dev/null) && echo "$tmp" > "$STATE_FILE"
    }
elif command -v python >/dev/null 2>&1; then
    json_get() { python -c "import json; d=json.load(open('$STATE_FILE')); print(d.get(${1//./,}, $2))" 2>/dev/null || echo "$2"; }
    json_update() {
        python -c "
import json, sys
d=json.load(open('$STATE_FILE'))
d['failure_count']=$1; d['pressure_level']=$2; d['last_updated']='$3'
json.dump(d, open('$STATE_FILE','w'), indent=2)" 2>/dev/null
    }
else
    exit 0  # No JSON engine available, skip silently
fi

# Initialize state if not exists
if [ ! -f "$STATE_FILE" ]; then
    echo '{"failure_count":0,"pressure_level":0,"session_id":"","last_updated":""}' > "$STATE_FILE"
fi

# The hook receives tool result via stdin
INPUT=$(cat)

# Detect failure patterns in Bash output
if echo "$INPUT" | grep -qiE '(error|failed|fatal|exception|traceback|command not found|permission denied|no such file|exit code [1-9])'; then
    # Read current state
    FAILURES=$(json_get '.failure_count' '0')
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
    TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%S)
    json_update "$NEW_FAILURES" "$LEVEL" "$TIMESTAMP"

    # Output pressure escalation if level >= 2
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
