#!/usr/bin/env bash
# Claim Ground session anchor — injects verified-fact digest at SessionStart
# Reads ~/.forge/claim-ground-anchors.json and emits an anchor block
# JSON engine: jq preferred, python fallback
# Schema: {session_id, anchors: [{key,value,source,verified_at}], user_corrections: [], last_updated}

ANCHORS_FILE="$HOME/.forge/claim-ground-anchors.json"
MAX_AGE_SECONDS=604800   # 7 days — anchors staler than this are skipped

if [ ! -f "$ANCHORS_FILE" ]; then
    exit 0
fi

# --- JSON engine abstraction (jq preferred, python fallback) ---
if command -v jq >/dev/null 2>&1; then
    JSON_ENGINE="jq"
elif command -v python3 >/dev/null 2>&1; then
    JSON_ENGINE="python"
elif command -v python >/dev/null 2>&1; then
    JSON_ENGINE="python"
else
    exit 0  # No JSON engine available, skip silently
fi

# Defensive parse — fall back to silent skip on corruption
if [ "$JSON_ENGINE" = "jq" ]; then
    if ! jq empty "$ANCHORS_FILE" 2>/dev/null; then
        exit 0
    fi
else
    if ! python3 -c "import json; json.load(open('$ANCHORS_FILE'))" >/dev/null 2>&1 \
     && ! python -c "import json; json.load(open('$ANCHORS_FILE'))" >/dev/null 2>&1; then
        exit 0
    fi
fi

# --- Age check ---
if [ "$JSON_ENGINE" = "jq" ]; then
    LAST_UPDATED=$(jq -r '.last_updated // ""' "$ANCHORS_FILE" 2>/dev/null)
else
    LAST_UPDATED=$(python3 -c "import json; d=json.load(open('$ANCHORS_FILE')); print(d.get('last_updated',''))" 2>/dev/null \
                || python  -c "import json; d=json.load(open('$ANCHORS_FILE')); print(d.get('last_updated',''))" 2>/dev/null)
fi

if [ -z "$LAST_UPDATED" ]; then
    exit 0
fi

if command -v date >/dev/null 2>&1; then
    THEN=$(date -d "$LAST_UPDATED" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "$LAST_UPDATED" +%s 2>/dev/null || echo "0")
    NOW=$(date +%s)
    AGE=$(( NOW - THEN ))
else
    AGE=0
fi

if [ "$AGE" -gt "$MAX_AGE_SECONDS" ]; then
    exit 0
fi

# --- Build digest ---
if [ "$JSON_ENGINE" = "jq" ]; then
    ANCHOR_COUNT=$(jq '.anchors | length' "$ANCHORS_FILE" 2>/dev/null)
    CORRECTION_COUNT=$(jq '.user_corrections // [] | length' "$ANCHORS_FILE" 2>/dev/null)
    if [ "${ANCHOR_COUNT:-0}" = "0" ] && [ "${CORRECTION_COUNT:-0}" = "0" ]; then
        exit 0
    fi
    ANCHOR_LINES=$(jq -r '.anchors[]? | "  - \(.key): \"\(.value)\" [\(.source) @ \(.verified_at)]"' "$ANCHORS_FILE" 2>/dev/null)
    CORRECTION_LINES=$(jq -r '.user_corrections[]? | "  - was \"\(.wrong)\" → is \"\(.right)\" [\(.source)]"' "$ANCHORS_FILE" 2>/dev/null)
else
    # Python fallback — use single quotes inside f-string expressions
    # to avoid shell-escape complexity with nested double quotes.
    PY_CMD='import json
d=json.load(open("'"$ANCHORS_FILE"'"))
a=d.get("anchors",[]); c=d.get("user_corrections",[])
if not a and not c: raise SystemExit(1)
print("__ANCHORS__")
for x in a:
    k=x.get("key","?"); v=x.get("value","?"); s=x.get("source","?"); t=x.get("verified_at","?")
    print("  - " + k + ": \"" + v + "\" [" + s + " @ " + t + "]")
print("__CORRECTIONS__")
for x in c:
    w=x.get("wrong","?"); r=x.get("right","?"); s=x.get("source","?")
    print("  - was \"" + w + "\" -> is \"" + r + "\" [" + s + "]")'
    OUT=$(python3 -c "$PY_CMD" 2>/dev/null) || OUT=$(python -c "$PY_CMD" 2>/dev/null) || exit 0
    ANCHOR_LINES=$(echo "$OUT" | sed -n '/^__ANCHORS__$/,/^__CORRECTIONS__$/p' | sed '1d;$d')
    CORRECTION_LINES=$(echo "$OUT" | sed -n '/^__CORRECTIONS__$/,$p' | sed '1d')
fi

# --- Emit digest (nothing shown if both lists empty; already returned above) ---
cat << EOF

<CLAIM_GROUND_ANCHORS>
[Claim Ground 🎯 — 已验证事实锚点已加载 / Verified-fact anchors restored]

These facts were cited to runtime evidence in a prior turn or session. Treat
them as verified priors for this session — do NOT re-assert them from memory
alone, but you MAY cite them directly when the same question recurs.

以下事实在上一轮/上一会话已经通过 runtime 证据验证过。本会话视为已知锚点；
同类问题可以直接引用，但不得凭记忆重新断言。

${ANCHOR_LINES:+Anchors:
${ANCHOR_LINES}
}${CORRECTION_LINES:+Prior user corrections (respect these):
${CORRECTION_LINES}
}
> Last updated: ${LAST_UPDATED}
> Source schema: skills/claim-ground/references/anchors.md
</CLAIM_GROUND_ANCHORS>
EOF
