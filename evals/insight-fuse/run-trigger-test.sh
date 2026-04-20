#!/bin/bash
# insight-fuse v3 trigger test — verifies structural integrity
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
    for ph in "{topic}" "{date}"; do
        if ! grep -qF "$ph" "$file"; then
            echo "FAIL: $file missing placeholder $ph"
            ERRORS=$((ERRORS + 1))
        fi
    done
}

check_fir_legend() {
    local file="$1"
    if ! grep -q "FIR legend" "$file"; then
        echo "FAIL: $file missing FIR legend marker"
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

echo "=== insight-fuse v3 Structural Integrity Test ==="
echo ""

echo "[1/13] Core SKILL.md..."
check "$SKILL_DIR/SKILL.md"
check_frontmatter "$SKILL_DIR/SKILL.md" "name"
check_frontmatter "$SKILL_DIR/SKILL.md" "description"
check_frontmatter "$SKILL_DIR/SKILL.md" "user-invokable"
check_frontmatter "$SKILL_DIR/SKILL.md" "argument-hint"

echo ""
echo "[2/13] Agent files (4 expected: generalist, critic, specialist, methodologist)..."
for role in generalist critic specialist methodologist; do
    check "$SKILL_DIR/agents/insight-${role}.md"
    if [ -f "$SKILL_DIR/agents/insight-${role}.md" ]; then
        check_frontmatter "$SKILL_DIR/agents/insight-${role}.md" "name"
        check_frontmatter "$SKILL_DIR/agents/insight-${role}.md" "model"
    fi
done

echo ""
echo "[3/13] Core reference files..."
check "$SKILL_DIR/references/research-protocol.md"
check "$SKILL_DIR/references/perspectives.md"
check "$SKILL_DIR/references/quality-standards.md"
check "$SKILL_DIR/references/pre-flight-checklist.md"

echo ""
echo "[4/13] New reference files (v3)..."
check "$SKILL_DIR/references/skeleton-schema.md"
check "$SKILL_DIR/references/research-types.md"
check "$SKILL_DIR/references/scoring-rubric.md"
check "$SKILL_DIR/references/output-formats.md"

echo ""
echo "[5/13] Template files (11 expected)..."
for tmpl in technology market competitive custom-example academic product meta-overview disagreement-preservation adr decision-tree poc checklist; do
    check "$SKILL_DIR/templates/${tmpl}.md"
    # disagreement-preservation is a snippet; checklist/adr/decision-tree/poc are output templates
    # Only main report templates need {topic}+{date}+FIR legend
    case "$tmpl" in
        technology|market|competitive|custom-example|academic|product|meta-overview)
            check_placeholder "$SKILL_DIR/templates/${tmpl}.md"
            check_fir_legend "$SKILL_DIR/templates/${tmpl}.md"
            ;;
    esac
done

echo ""
echo "[6/13] Eval files..."
check "evals/insight-fuse/scenarios.md"

echo ""
echo "[7/13] Documentation..."
check "docs/user-guide/insight-fuse-guide.md"
check "docs/design/insight-fuse-design.md"

echo ""
echo "[8/13] Marketplace entry + hash match..."
if grep -q "insight-fuse" ".claude-plugin/marketplace.json" 2>/dev/null; then
    echo "  OK: marketplace.json contains insight-fuse"
else
    echo "FAIL: marketplace.json missing insight-fuse entry"
    ERRORS=$((ERRORS + 1))
fi
EXPECTED_HASH=$(sha256sum "$SKILL_DIR/SKILL.md" | cut -d' ' -f1)
if grep -q "\"skill-md-sha256\": \"$EXPECTED_HASH\"" .claude-plugin/marketplace.json; then
    echo "  OK: SKILL.md hash matches marketplace integrity"
else
    echo "FAIL: SKILL.md hash ($EXPECTED_HASH) does not match marketplace integrity"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "[9/13] OpenClaw platform mirror — byte-identical..."
check "$OPENCLAW_DIR/SKILL.md"
if diff -rq "$SKILL_DIR" "$OPENCLAW_DIR" > /tmp/insight-fuse-diff.out 2>&1; then
    echo "  OK: platform mirror byte-identical"
else
    echo "FAIL: platform mirror diverged"
    cat /tmp/insight-fuse-diff.out
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "[10/13] skeleton-schema.md has schema_version marker..."
check_contains "$SKILL_DIR/references/skeleton-schema.md" "schema_version: 1" "schema_version marker"

echo ""
echo "[11/13] scoring-rubric.md has grade mapping..."
check_contains "$SKILL_DIR/references/scoring-rubric.md" "A.*8.5" "A-grade threshold"
check_contains "$SKILL_DIR/references/scoring-rubric.md" "D.*5.5" "D-grade threshold"

echo ""
echo "[12/13] All 6 research-types represented in research-types.md + templates/..."
for t in overview technology market academic product competitive; do
    check_contains "$SKILL_DIR/references/research-types.md" "\`$t\`" "research-type '$t'"
done

echo ""
echo "[13/13] i18n README + guide parity..."
for lang_file in docs/i18n/README.*.md; do
    if [ -f "$lang_file" ]; then
        check_contains "$lang_file" "insight-fuse" "insight-fuse mention"
    fi
done
LANG_COUNT=$(ls docs/user-guide/i18n/insight-fuse-guide.*.md 2>/dev/null | wc -l)
if [ "$LANG_COUNT" -eq 11 ]; then
    echo "  OK: 11 i18n guide files present"
else
    echo "FAIL: expected 11 i18n guides, found $LANG_COUNT"
    ERRORS=$((ERRORS + 1))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "=== ALL CHECKS PASSED ==="
else
    echo "=== $ERRORS CHECK(S) FAILED ==="
    exit 1
fi
