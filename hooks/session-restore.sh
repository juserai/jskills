#!/usr/bin/env bash
# Block Break session restore — restores pressure state from ~/.juserch-skills/block-break-state.json
# Called by hooks.json on SessionStart (after compaction or resume)

STATE_FILE="$HOME/.juserch-skills/block-break-state.json"

if [ ! -f "$STATE_FILE" ]; then
    exit 0
fi

# Check if state is fresh enough (within 2 hours)
LAST_UPDATED=$(python -c "
import json, datetime
try:
    d = json.load(open('$STATE_FILE'))
    ts = d.get('last_updated', '')
    if ts:
        dt = datetime.datetime.fromisoformat(ts)
        age = (datetime.datetime.now() - dt).total_seconds()
        print(int(age))
    else:
        print(99999)
except:
    print(99999)
" 2>/dev/null || echo "99999")

# Only restore if within 2 hours (7200 seconds)
if [ "$LAST_UPDATED" -gt 7200 ]; then
    exit 0
fi

FAILURES=$(python -c "import json; print(json.load(open('$STATE_FILE')).get('failure_count',0))" 2>/dev/null || echo "0")
LEVEL=$(python -c "import json; print(json.load(open('$STATE_FILE')).get('pressure_level',0))" 2>/dev/null || echo "0")

if [ "$FAILURES" -gt 0 ]; then
    cat << EOF

<BLOCK_BREAK_STATE_RESTORED>
[Block Break 状态恢复] 失败计数: $FAILURES | 压力等级: L$LEVEL

之前的会话中已有 $FAILURES 次失败。压力等级不会因为上下文压缩而重置。
继续从 L$LEVEL 执行。
</BLOCK_BREAK_STATE_RESTORED>
EOF
fi
