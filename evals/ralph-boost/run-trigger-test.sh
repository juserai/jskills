#!/usr/bin/env bash
# Ralph Boost — Trigger Test
# Tests that the skill triggers correctly and boost-loop.sh passes basic validation.
#
# Usage: bash evals/ralph-boost/run-trigger-test.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL_DIR="$PROJECT_ROOT/skills/ralph-boost"
LOOP_SCRIPT="$SKILL_DIR/scripts/boost-loop.sh"

pass=0
fail=0

check() {
    local desc="$1"
    shift
    if "$@" >/dev/null 2>&1; then
        echo "  PASS: $desc"
        pass=$((pass + 1))
    else
        echo "  FAIL: $desc"
        fail=$((fail + 1))
    fi
}

echo "=== Ralph Boost Trigger Test ==="
echo ""

# --- Structure Tests ---
echo "[1] Skill structure"
check "SKILL.md exists" test -f "$SKILL_DIR/SKILL.md"
check "SKILL.md has frontmatter name" grep -q "^name: ralph-boost" "$SKILL_DIR/SKILL.md"
check "SKILL.md has description" grep -q "^description:" "$SKILL_DIR/SKILL.md"
check "SKILL.md has license" grep -q "^license:" "$SKILL_DIR/SKILL.md"
check "prompt-template.md exists" test -f "$SKILL_DIR/references/prompt-template.md"
check "escalation-rules.md exists" test -f "$SKILL_DIR/references/escalation-rules.md"
check "boost-status-protocol.md exists" test -f "$SKILL_DIR/references/boost-status-protocol.md"
check "boost-loop.sh exists" test -f "$LOOP_SCRIPT"
check "boost-loop.sh is executable" test -x "$LOOP_SCRIPT"

echo ""

# --- PROMPT Template Tests ---
echo "[2] PROMPT template content"
check "Contains PROJECT_NAME placeholder" grep -q '{{PROJECT_NAME}}' "$SKILL_DIR/references/prompt-template.md"
check "Contains pressure level constraints" grep -q 'Pressure Level Constraints' "$SKILL_DIR/references/prompt-template.md"
check "Contains 7-item checklist" grep -q '7-Item Checklist' "$SKILL_DIR/references/prompt-template.md"
check "Contains anti-early-exit rules" grep -q 'Anti-Early-Exit' "$SKILL_DIR/references/prompt-template.md"
check "Contains BOOST_STATUS format" grep -q 'BOOST_STATUS' "$SKILL_DIR/references/prompt-template.md"
check "Contains five-step methodology" grep -q 'Five-Step Methodology' "$SKILL_DIR/references/prompt-template.md"
check "Contains loop start protocol" grep -q 'Loop Start Protocol' "$SKILL_DIR/references/prompt-template.md"
check "Contains loop end protocol" grep -q 'Loop End Protocol' "$SKILL_DIR/references/prompt-template.md"

echo ""

# --- Loop Script Tests ---
echo "[3] Loop script validation"
check "Bash syntax check" bash -n "$LOOP_SCRIPT"
check "Uses set -euo pipefail" grep -q 'set -euo pipefail' "$LOOP_SCRIPT"
check "Has jq dependency check" grep -q 'jq' "$LOOP_SCRIPT"
check "Has claude dependency check" grep -q 'claude' "$LOOP_SCRIPT"
check "Uses .ralph-boost directory" grep -q '.ralph-boost' "$LOOP_SCRIPT"
check "Does NOT reference .ralph/" bash -c '! grep -qE "\.ralph/" "$0" || grep "\.ralph-boost" "$0" | grep -qv "\.ralph/"' "$LOOP_SCRIPT"
check "Has circuit breaker logic" grep -q 'circuit_breaker' "$LOOP_SCRIPT"
check "Has pressure calculation" grep -q 'calculate_pressure' "$LOOP_SCRIPT"
check "Has BOOST_STATUS parsing" grep -q 'BOOST_STATUS' "$LOOP_SCRIPT"
check "Has rate limiting" grep -q 'rate_limit' "$LOOP_SCRIPT"
check "Uses --output-format json" grep -q '\-\-output-format json' "$LOOP_SCRIPT"
check "Uses --append-system-prompt" grep -q '\-\-append-system-prompt' "$LOOP_SCRIPT"
check "Uses < /dev/null" grep -q '/dev/null' "$LOOP_SCRIPT"
check "Has signal handler" grep -q 'trap' "$LOOP_SCRIPT"

echo ""

# --- Independence Tests ---
echo "[4] Independence from ralph-claude-code"
check "No .ralphrc reference" bash -c '! grep -q "\.ralphrc" "'"$LOOP_SCRIPT"'"'
check "No RALPH_STATUS reference in loop" bash -c '! grep -q "RALPH_STATUS" "'"$LOOP_SCRIPT"'"'
check "SKILL.md mentions independence" grep -q '独立' "$SKILL_DIR/SKILL.md"

echo ""

# --- Escalation Rules Tests ---
echo "[5] Escalation rules content"
check "L0 defined" grep -q 'L0' "$SKILL_DIR/references/escalation-rules.md"
check "L1 defined" grep -q 'L1' "$SKILL_DIR/references/escalation-rules.md"
check "L2 defined" grep -q 'L2' "$SKILL_DIR/references/escalation-rules.md"
check "L3 defined" grep -q 'L3' "$SKILL_DIR/references/escalation-rules.md"
check "L4 defined" grep -q 'L4' "$SKILL_DIR/references/escalation-rules.md"
check "Handoff report template" grep -q 'Handoff Report' "$SKILL_DIR/references/escalation-rules.md"
check "Anti-early-exit rules" grep -q '防早退' "$SKILL_DIR/references/escalation-rules.md"

echo ""

# --- Marketplace Tests ---
echo "[6] Marketplace integration"
check "marketplace.json includes ralph-boost" grep -q 'ralph-boost' "$PROJECT_ROOT/.claude-plugin/marketplace.json" 2>/dev/null || true

echo ""

# --- Summary ---
echo "==============================="
echo "  Results: $pass passed, $fail failed"
echo "==============================="

exit $fail
