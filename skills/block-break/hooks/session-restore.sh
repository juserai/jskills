#!/usr/bin/env bash
# Block Break session restore — restores pressure state from ~/.forge/block-break-state.json
# Called by hooks.json on SessionStart (after compaction or resume)
# JSON engine: jq preferred, python fallback

STATE_FILE="$HOME/.forge/block-break-state.json"

if [ ! -f "$STATE_FILE" ]; then
    exit 0
fi

# --- JSON engine abstraction (jq preferred, python fallback) ---
if command -v jq >/dev/null 2>&1; then
    json_get() { jq -r "$1 // \"$2\"" "$STATE_FILE" 2>/dev/null || echo "$2"; }
elif command -v python >/dev/null 2>&1; then
    json_get() { python -c "import json; d=json.load(open('$STATE_FILE')); print(d.get('${1//.}', '$2'))" 2>/dev/null || echo "$2"; }
else
    exit 0  # No JSON engine available, skip silently
fi

# Check if state is fresh enough (within 2 hours / 7200 seconds)
LAST_UPDATED=$(json_get '.last_updated' '')
if [ -z "$LAST_UPDATED" ]; then
    exit 0
fi

# Calculate age in seconds (POSIX-compatible)
if command -v jq >/dev/null 2>&1 && command -v date >/dev/null 2>&1; then
    THEN=$(date -d "$LAST_UPDATED" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "$LAST_UPDATED" +%s 2>/dev/null || echo "0")
    NOW=$(date +%s)
    AGE=$(( NOW - THEN ))
elif command -v python >/dev/null 2>&1; then
    AGE=$(python -c "
import datetime
try:
    dt=datetime.datetime.fromisoformat('$LAST_UPDATED')
    print(int((datetime.datetime.now()-dt).total_seconds()))
except: print(99999)" 2>/dev/null || echo "99999")
else
    AGE=99999
fi

if [ "$AGE" -gt 7200 ]; then
    exit 0
fi

FAILURES=$(json_get '.failure_count' '0')
LEVEL=$(json_get '.pressure_level' '0')

if [ "$FAILURES" -gt 0 ]; then
    cat << EOF

<BLOCK_BREAK_STATE_RESTORED>
[Block Break 状态恢复] 失败计数: $FAILURES | 压力等级: L$LEVEL

之前的会话中已有 $FAILURES 次失败。压力等级不会因为上下文压缩而重置。
继续从 L$LEVEL 执行。
</BLOCK_BREAK_STATE_RESTORED>
EOF
fi
