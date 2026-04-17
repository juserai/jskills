#!/usr/bin/env bash
# Claim Ground Triggering Test
# Tests whether the skill triggers on correct prompts and doesn't trigger on incorrect ones
#
# Usage: ./run-trigger-test.sh [--plugin-dir <path>]
# Requires: claude CLI

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${1:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
RESULTS_DIR="/tmp/claim-ground-evals/$(date +%s)"
mkdir -p "$RESULTS_DIR"

echo "=== Claim Ground Trigger Tests ==="
echo "Plugin dir: $PLUGIN_DIR"
echo "Results: $RESULTS_DIR"
echo ""

PASS=0
FAIL=0

test_prompt() {
    local prompt="$1"
    local should_trigger="$2"
    local label="$3"
    local outfile="$RESULTS_DIR/$(echo "$label" | tr ' ' '_').json"

    timeout 120 claude -p "$prompt" \
        --plugin-dir "$PLUGIN_DIR" \
        --dangerously-skip-permissions \
        --max-turns 2 \
        --output-format stream-json \
        > "$outfile" 2>&1 || true

    local triggered=false
    if grep -q '"skill":"claim-ground"' "$outfile" 2>/dev/null; then
        triggered=true
    fi

    if [ "$should_trigger" = "yes" ] && [ "$triggered" = "true" ]; then
        echo "  ✅ PASS: $label (correctly triggered)"
        PASS=$((PASS + 1))
    elif [ "$should_trigger" = "no" ] && [ "$triggered" = "false" ]; then
        echo "  ✅ PASS: $label (correctly NOT triggered)"
        PASS=$((PASS + 1))
    elif [ "$should_trigger" = "yes" ] && [ "$triggered" = "false" ]; then
        echo "  ❌ FAIL: $label (should trigger but didn't)"
        FAIL=$((FAIL + 1))
    else
        echo "  ❌ FAIL: $label (should NOT trigger but did)"
        FAIL=$((FAIL + 1))
    fi
}

echo "--- Should Trigger ---"
test_prompt "What is the current model running?" "yes" "current-model"
test_prompt "当前运行的模型是什么？" "yes" "current-model-zh"
test_prompt "What version of the claude CLI is installed?" "yes" "cli-version"
test_prompt "Which packages are installed globally via npm?" "yes" "installed-packages"
test_prompt "真的吗？我记得已经更新到 4.7 了" "yes" "user-pushback-zh"
test_prompt "Are you sure? I thought it was updated" "yes" "user-pushback-en"
test_prompt "What's in my PATH env var?" "yes" "env-var-query"
test_prompt "本当に？最新モデルが更新されたと思います" "yes" "user-pushback-ja"
test_prompt "¿en serio? ya pensaba que se había actualizado" "yes" "user-pushback-es"
test_prompt "wait, I thought that was already changed" "yes" "implicit-pushback-en"
test_prompt "不对，最新是 Opus 5.0，官方博客：https://anthropic.com/news/opus-5-release" "yes" "cited-url-pushback"
test_prompt "claude CLI 支持哪些模型？" "yes" "cli-model-list-scan"
test_prompt "axios 里怎么设置全局请求超时？" "yes" "code-api-assertion"
test_prompt "Claude API 怎么取消 batch？给我官方文档链接" "yes" "cited-url-required"
test_prompt "summarize CLAUDE.md" "yes" "summarize-file-anchor"

echo ""
echo "--- Should NOT Trigger ---"
test_prompt "Tell me a joke" "no" "casual-chat"
test_prompt "What's the difference between list and tuple in Python?" "no" "training-knowledge"
test_prompt "Help me refactor this function" "no" "coding-task"
test_prompt "Explain the bubble sort algorithm" "no" "algorithm-explain"
test_prompt "/news-fetch AI" "no" "other-skill-command"
test_prompt "promise 和 async/await 的概念区别是什么？" "no" "conceptual-explain"

echo ""
echo "=== Results ==="
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo "Total:  $((PASS + FAIL))"
echo "Results dir: $RESULTS_DIR"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
