#!/bin/bash
# peer-fuse v0.1.0 trigger test — verifies structural integrity
# Usage: ./evals/peer-fuse/run-trigger-test.sh
# Exit: 0 = all PASS, 1+ = number of FAIL items

set -uo pipefail

SKILL_DIR="skills/peer-fuse"
OPENCLAW_DIR="platforms/openclaw/peer-fuse"
ERRORS=0

check() {
  if [ ! -f "$1" ]; then
    echo "FAIL: missing $1"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK: $1"
  fi
}

check_executable() {
  if [ ! -x "$1" ]; then
    echo "FAIL: $1 not executable (chmod +x)"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK: $1 (executable)"
  fi
}

check_frontmatter_field() {
  local file="$1"
  local field="$2"
  local expect="$3"  # optional
  if ! head -20 "$file" | grep -qE "^${field}:"; then
    echo "FAIL: $file missing frontmatter field '$field'"
    ERRORS=$((ERRORS + 1))
    return
  fi
  if [ -n "$expect" ]; then
    if ! head -20 "$file" | grep -qE "^${field}:.*${expect}"; then
      echo "FAIL: $file frontmatter '$field' doesn't match '$expect'"
      ERRORS=$((ERRORS + 1))
    fi
  fi
}

check_no_string() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if grep -qE "$pattern" "$file"; then
    echo "FAIL: $file contains forbidden pattern $label ('$pattern')"
    ERRORS=$((ERRORS + 1))
  fi
}

cd "$(dirname "$0")/../.." || exit 2

echo "=== Phase A: Canonical structure ==="
check "$SKILL_DIR/SKILL.md"
check "$SKILL_DIR/references/rubric-8dim.md"
check "$SKILL_DIR/references/flag-taxonomy.md"
check "$SKILL_DIR/references/replication-tier.md"
check "$SKILL_DIR/references/format-adapters.md"
check "$SKILL_DIR/references/type-classifier.md"
check "$SKILL_DIR/agents/review-methodologist.md"
check "$SKILL_DIR/agents/review-adversarial.md"
check "$SKILL_DIR/agents/review-practitioner.md"
check "$SKILL_DIR/templates/review-report.md"
check "$SKILL_DIR/templates/review-diff-block.md"
check "$SKILL_DIR/templates/document-reading.md"
check "$SKILL_DIR/templates/holistic-assessment.md"
check "$SKILL_DIR/scripts/detect-format-tools.sh"
check "$SKILL_DIR/scripts/convert-to-canonical.sh"
check "$SKILL_DIR/scripts/classify-research-type.sh"

echo ""
echo "=== Phase B: Scripts executable ==="
check_executable "$SKILL_DIR/scripts/detect-format-tools.sh"
check_executable "$SKILL_DIR/scripts/convert-to-canonical.sh"
check_executable "$SKILL_DIR/scripts/classify-research-type.sh"

echo ""
echo "=== Phase C: SKILL.md frontmatter ==="
check_frontmatter_field "$SKILL_DIR/SKILL.md" "name" "peer-fuse"
check_frontmatter_field "$SKILL_DIR/SKILL.md" "description" "Peer-Fuse v0.1.0"
check_frontmatter_field "$SKILL_DIR/SKILL.md" "license" "MIT"
check_frontmatter_field "$SKILL_DIR/SKILL.md" "user-invokable" "true"
check_frontmatter_field "$SKILL_DIR/SKILL.md" "argument-hint" ""
# version regression guard (S29) — MUST NOT exist
if head -20 "$SKILL_DIR/SKILL.md" | grep -qE "^\s*version:"; then
  echo "FAIL: $SKILL_DIR/SKILL.md frontmatter contains forbidden 'version:' field (S29 regression)"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "=== Phase D: Help card v0.1.0 line (S30) ==="
if ! grep -qE "^Peer-Fuse v0\.1\.0 —" "$SKILL_DIR/SKILL.md"; then
  echo "FAIL: $SKILL_DIR/SKILL.md help card missing 'Peer-Fuse v0.1.0 —' first line"
  ERRORS=$((ERRORS + 1))
else
  echo "  OK: help card v0.1.0 line present"
fi

echo ""
echo "=== Phase E: Platform mirror ==="
check "$OPENCLAW_DIR/SKILL.md"
check "$OPENCLAW_DIR/references/rubric-8dim.md"
check "$OPENCLAW_DIR/agents/review-methodologist.md"
check "$OPENCLAW_DIR/templates/review-report.md"
check "$OPENCLAW_DIR/scripts/detect-format-tools.sh"

echo ""
echo "=== Phase F: detect-format-tools.sh smoke ==="
# Tier 1 happy path
echo "test content" > /tmp/peer-fuse-test.md
result=$(bash "$SKILL_DIR/scripts/detect-format-tools.sh" /tmp/peer-fuse-test.md 2>&1) || true
if echo "$result" | grep -q "tier=1" && echo "$result" | grep -q "format=md"; then
  echo "  OK: Tier 1 .md detection"
else
  echo "FAIL: Tier 1 .md detection. Got: $result"
  ERRORS=$((ERRORS + 1))
fi
# Unknown format (file MUST exist so detection logic runs, not file-not-found)
echo "test" > /tmp/peer-fuse-test.xyz
result=$(bash "$SKILL_DIR/scripts/detect-format-tools.sh" /tmp/peer-fuse-test.xyz 2>&1) || true
if echo "$result" | grep -q "Unsupported format"; then
  echo "  OK: unknown format rejected"
else
  echo "FAIL: unknown format not rejected. Got: $result"
  ERRORS=$((ERRORS + 1))
fi
rm -f /tmp/peer-fuse-test.md /tmp/peer-fuse-test.xyz

echo ""
echo "=== Phase G: classify-research-type.sh smoke ==="
# Frontmatter type field detection
cat > /tmp/peer-fuse-academic.md <<EOF
---
type: academic
title: Test
---

# Test
Body.
EOF
result=$(bash "$SKILL_DIR/scripts/classify-research-type.sh" /tmp/peer-fuse-academic.md 2>&1) || true
if echo "$result" | grep -q "research_type=academic"; then
  echo "  OK: rule-1 frontmatter type detection"
else
  echo "FAIL: rule-1 not triggered. Got: $result"
  ERRORS=$((ERRORS + 1))
fi
rm -f /tmp/peer-fuse-academic.md

# Section pattern detection (academic)
cat > /tmp/peer-fuse-pattern.md <<EOF
# Some Paper

## Abstract
text

## Methods
text

## Results
text

## Discussion
text
EOF
result=$(bash "$SKILL_DIR/scripts/classify-research-type.sh" /tmp/peer-fuse-pattern.md 2>&1) || true
if echo "$result" | grep -q "research_type=academic"; then
  echo "  OK: rule-2 academic section pattern"
else
  echo "FAIL: rule-2 not triggered. Got: $result"
  ERRORS=$((ERRORS + 1))
fi
rm -f /tmp/peer-fuse-pattern.md

# Fallback overview
cat > /tmp/peer-fuse-fallback.md <<EOF
# Random Text

Some unrelated content with no signal.
EOF
result=$(bash "$SKILL_DIR/scripts/classify-research-type.sh" /tmp/peer-fuse-fallback.md 2>&1) || true
if echo "$result" | grep -q "research_type=overview"; then
  echo "  OK: rule-6 fallback overview"
else
  echo "FAIL: rule-6 fallback. Got: $result"
  ERRORS=$((ERRORS + 1))
fi
rm -f /tmp/peer-fuse-fallback.md

echo ""
echo "=== Phase H: Document Reading template forbidden words spec ==="
# 模板自身应文档化禁词清单（不是模板内容包含禁词，而是它说明这些是禁的）
if grep -qE "禁词清单|禁词扫描|forbidden.+words?" "$SKILL_DIR/templates/document-reading.md"; then
  echo "  OK: document-reading.md documents forbidden-word lint"
else
  echo "FAIL: document-reading.md missing forbidden-word lint spec"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "==========================="
if [ "$ERRORS" -eq 0 ]; then
  echo "ALL PASS"
  exit 0
else
  echo "FAIL: $ERRORS errors"
  exit "$ERRORS"
fi
