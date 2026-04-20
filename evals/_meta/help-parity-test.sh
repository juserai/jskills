#!/usr/bin/env bash
# Help Parity Regression Test
#
# Replaces the 8-skill × 5-trigger manual verification matrix with a
# static structural check. Enforces the conventions declared in
# CLAUDE.md § "Help 模式约定":
#
#   - All 8 skills must have a `## Help` section (also checked by
#     skill-lint S25 via .skill-lint.json).
#   - Must mention `help` and `--help` tokens (backticked).
#   - The 6 "mandatory-arg" skills must declare "无参数 → help".
#   - The 2 "default-behavior" skills (block-break / skill-lint)
#     must declare "无参数 ≠ help".
#
# Run AFTER editing any skill's Help section. Failures indicate a
# template drift that users would notice.

set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
cd "$REPO_ROOT"

fail() { echo "[FAIL] $*" >&2; exit 1; }
pass() { echo "[PASS] $*"; }

all_owners=(ralph-boost tome-forge council-fuse insight-fuse news-fetch claim-ground block-break skill-lint)
mandatory_arg=(ralph-boost tome-forge council-fuse insight-fuse news-fetch claim-ground)
default_behavior=(block-break skill-lint)

# 1) Every skill has the Help section and both tokens
for skill in "${all_owners[@]}"; do
    md="skills/$skill/SKILL.md"
    [ -f "$md" ] || fail "$skill: SKILL.md missing"
    grep -qE '^## Help[[:space:]]*$' "$md" || fail "$skill: missing '## Help' heading"
    grep -q '`help`' "$md" || fail "$skill: missing \`help\` token in Help section"
    grep -q '`--help`' "$md" || fail "$skill: missing \`--help\` token in Help section"
done
pass "8/8 skills have '## Help' heading + \`help\` + \`--help\` tokens"

# 2) Mandatory-arg skills must declare "无参数 → help" (L2 enabled)
for skill in "${mandatory_arg[@]}"; do
    md="skills/$skill/SKILL.md"
    if ! grep -qE '无参数|no[- ]?args|empty args' "$md"; then
        fail "$skill: mandatory-arg skill but SKILL.md does not mention no-args behavior"
    fi
    # Must indicate L2 applies (no-args → help, not no-args ≠ help)
    if grep -qE '无参数[[:space:]]*(≠|!=|不是)[[:space:]]*help' "$md"; then
        fail "$skill: mandatory-arg skill incorrectly claims '无参数 ≠ help'"
    fi
done
pass "6/6 mandatory-arg skills declare L2 (no-args → help)"

# 3) Default-behavior skills must declare "无参数 ≠ help"
for skill in "${default_behavior[@]}"; do
    md="skills/$skill/SKILL.md"
    grep -qE '无参数[[:space:]]*(≠|!=|不是)[[:space:]]*help' "$md" \
        || fail "$skill: default-behavior skill must declare '无参数 ≠ help'"
done
pass "2/2 default-behavior skills declare '无参数 ≠ help'"

# 4) CLAUDE.md must document the convention
grep -qE '^### Help 模式约定' CLAUDE.md || fail "CLAUDE.md missing § Help 模式约定"
pass "CLAUDE.md § 'Help 模式约定' present"

echo
echo "[OK] help-parity test passed — 8 skills follow unified Help convention."
