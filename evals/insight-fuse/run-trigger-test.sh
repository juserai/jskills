#!/bin/bash
# insight-fuse trigger test — verifies structural integrity
# Usage: ./evals/insight-fuse/run-trigger-test.sh

set -euo pipefail

SKILL_DIR="skills/insight-fuse"
OPENCLAW_DIR="platforms/openclaw/insight-fuse"
ERRORS=0

check() {
    if [ ! -f "$1" ]; then
        echo "FAIL: Missing $1"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: $1"
    fi
}

check_frontmatter() {
    local file="$1"
    local field="$2"
    if ! head -20 "$file" | grep -q "^${field}:"; then
        echo "FAIL: $file missing frontmatter field '$field'"
        ERRORS=$((ERRORS + 1))
    fi
}

check_placeholder() {
    local file="$1"
    if ! grep -q '{topic}' "$file" || ! grep -q '{date}' "$file"; then
        echo "FAIL: $file missing {topic} or {date} placeholder"
        ERRORS=$((ERRORS + 1))
    fi
}

check_contains() {
    local file="$1"
    local pattern="$2"
    local label="$3"
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo "  OK: $file contains $label"
    else
        echo "FAIL: $file missing $label"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "=== insight-fuse Structural Integrity Test ==="
echo ""

echo "[1/9] Core files..."
check "$SKILL_DIR/SKILL.md"
check_frontmatter "$SKILL_DIR/SKILL.md" "name"
check_frontmatter "$SKILL_DIR/SKILL.md" "description"
check_frontmatter "$SKILL_DIR/SKILL.md" "user-invokable"

echo ""
echo "[2/9] Agent files..."
for role in generalist critic specialist; do
    check "$SKILL_DIR/agents/insight-${role}.md"
    if [ -f "$SKILL_DIR/agents/insight-${role}.md" ]; then
        check_frontmatter "$SKILL_DIR/agents/insight-${role}.md" "name"
        check_frontmatter "$SKILL_DIR/agents/insight-${role}.md" "model"
    fi
done

echo ""
echo "[3/9] Reference files..."
check "$SKILL_DIR/references/research-protocol.md"
check "$SKILL_DIR/references/perspectives.md"
check "$SKILL_DIR/references/quality-standards.md"

echo ""
echo "[4/9] Template files..."
for tmpl in technology market competitive custom-example; do
    check "$SKILL_DIR/templates/${tmpl}.md"
    if [ -f "$SKILL_DIR/templates/${tmpl}.md" ]; then
        check_placeholder "$SKILL_DIR/templates/${tmpl}.md"
    fi
done

echo ""
echo "[5/9] Eval files..."
check "evals/insight-fuse/scenarios.md"

echo ""
echo "[6/9] Documentation..."
check "docs/guide/insight-fuse-guide.md"

echo ""
echo "[7/9] Marketplace entry..."
if grep -q "insight-fuse" ".claude-plugin/marketplace.json" 2>/dev/null; then
    echo "  OK: marketplace.json contains insight-fuse"
else
    echo "FAIL: marketplace.json missing insight-fuse entry"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "[8/9] OpenClaw platform files..."
check "$OPENCLAW_DIR/SKILL.md"
if [ -f "$OPENCLAW_DIR/SKILL.md" ]; then
    check_frontmatter "$OPENCLAW_DIR/SKILL.md" "name"
    check_frontmatter "$OPENCLAW_DIR/SKILL.md" "user-invokable"
fi
for role in generalist critic specialist; do
    check "$OPENCLAW_DIR/agents/insight-${role}.md"
done
check "$OPENCLAW_DIR/references/research-protocol.md"
check "$OPENCLAW_DIR/references/perspectives.md"
check "$OPENCLAW_DIR/references/quality-standards.md"

echo ""
echo "[9/9] i18n README files..."
for lang_file in docs/i18n/README.*.md; do
    if [ -f "$lang_file" ]; then
        check_contains "$lang_file" "insight-fuse" "insight-fuse"
    fi
done

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "=== ALL CHECKS PASSED ==="
else
    echo "=== $ERRORS CHECK(S) FAILED ==="
    exit 1
fi
