#!/usr/bin/env bash
# Hook Fan-out Regression Test
#
# Background: prior to this PR, the 8 plugins in marketplace.json all shared
# source: "./" — so Claude Code registered the same hooks/hooks.json 8 times
# per user prompt, emitting <BLOCK_BREAK_ACTIVATED> ×8 instead of ×1.
#
# This test enforces the structural invariants that guarantee the N-fan-out
# cannot recur:
#   1. Root hooks/ MUST NOT exist (was the source of fan-out).
#   2. Only hook-owner skills (block-break, claim-ground) have skills/<name>/hooks/.
#   3. Each plugin's marketplace.json source points at its own skill dir.
#   4. Each per-skill hooks.json contains only its owner's hooks (matchers
#      unique to that skill's purpose).
#
# Plus a scripted call-counter confirming each trigger script runs exactly once
# when invoked (baseline — the platform-side N-registration would multiply
# this, but the in-script logic itself must be deterministic and side-effect
# -free enough to count correctly).

set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
cd "$REPO_ROOT"

fail() { echo "[FAIL] $*" >&2; exit 1; }
pass() { echo "[PASS] $*"; }

# ─────────────────────────────────────────────────────────────────
# 1. Root hooks/ must not exist
# ─────────────────────────────────────────────────────────────────
[ ! -e hooks ] || fail "root hooks/ still exists — N-fan-out bug would recur"
pass "root hooks/ removed"

# ─────────────────────────────────────────────────────────────────
# 2. Exactly two skills own hooks (block-break, claim-ground)
# ─────────────────────────────────────────────────────────────────
hook_owners=()
for skill_dir in skills/*/; do
    if [ -d "${skill_dir}hooks" ]; then
        hook_owners+=("$(basename "$skill_dir")")
    fi
done

expected=(block-break claim-ground)
if [ "${#hook_owners[@]}" -ne 2 ]; then
    fail "expected 2 hook-owner skills, found ${#hook_owners[@]}: ${hook_owners[*]}"
fi
for want in "${expected[@]}"; do
    printf '%s\n' "${hook_owners[@]}" | grep -qx "$want" || fail "missing hook-owner: $want"
done
pass "exactly 2 hook-owner skills: ${hook_owners[*]}"

# ─────────────────────────────────────────────────────────────────
# 3. Each marketplace plugin's source points at its own skill dir
# ─────────────────────────────────────────────────────────────────
mkfile=.claude-plugin/marketplace.json
[ -f "$mkfile" ] || fail "marketplace.json missing"

# Lightweight grep-based parse (no jq dependency):
#   every "name": "<x>" must be followed shortly after by "source": "./skills/<x>"
python3 - "$mkfile" <<'PY' || fail "marketplace source mismatch"
import json, sys
data = json.load(open(sys.argv[1]))
errors = []
for p in data["plugins"]:
    expected = f"./skills/{p['name']}"
    if p["source"] != expected:
        errors.append(f"{p['name']}: source={p['source']!r} expected={expected!r}")
    if p["skills"] != ["./"]:
        errors.append(f"{p['name']}: skills={p['skills']!r} expected=['./']")
if errors:
    print("\n".join(errors), file=sys.stderr)
    sys.exit(1)
PY
pass "all 8 plugins: source points at own skill dir, skills=['./']"

# ─────────────────────────────────────────────────────────────────
# 4. Each per-skill hooks.json contains only owner-relevant matchers
# ─────────────────────────────────────────────────────────────────
# block-break owns: frustration-trigger, failure-detector, session-restore, PreCompact prompt
python3 - <<'PY' || fail "block-break hooks.json content mismatch"
import json, sys, pathlib
hjson = json.load(open("skills/block-break/hooks/hooks.json"))
commands = []
for ev, entries in hjson["hooks"].items():
    for entry in entries:
        for h in entry["hooks"]:
            if h.get("type") == "command":
                commands.append(h["command"])
joined = "\n".join(commands)
assert "frustration-trigger.sh" in joined, "missing frustration-trigger"
assert "failure-detector.sh" in joined, "missing failure-detector"
assert "session-restore.sh" in joined, "missing session-restore"
# MUST NOT contain claim-ground scripts
for forbidden in ["epistemic-pushback-trigger", "evidence-reminder", "session-anchor"]:
    assert forbidden not in joined, f"block-break hooks.json leaks {forbidden}"
PY
pass "block-break hooks.json: 3 owner scripts present, no claim-ground leaks"

python3 - <<'PY' || fail "claim-ground hooks.json content mismatch"
import json, sys
hjson = json.load(open("skills/claim-ground/hooks/hooks.json"))
commands = []
for ev, entries in hjson["hooks"].items():
    for entry in entries:
        for h in entry["hooks"]:
            if h.get("type") == "command":
                commands.append(h["command"])
joined = "\n".join(commands)
assert "epistemic-pushback-trigger.sh" in joined
assert "evidence-reminder.sh" in joined
assert "session-anchor.sh" in joined
for forbidden in ["frustration-trigger", "failure-detector", "session-restore"]:
    assert forbidden not in joined, f"claim-ground hooks.json leaks {forbidden}"
PY
pass "claim-ground hooks.json: 3 owner scripts present, no block-break leaks"

# ─────────────────────────────────────────────────────────────────
# 5. Trigger scripts exist under owner skill, are executable, and the
#    ${CLAUDE_PLUGIN_ROOT}/hooks/ prefix resolves to skill-local paths
# ─────────────────────────────────────────────────────────────────
for owner in block-break claim-ground; do
    for cmd in $(python3 -c "
import json, re
h = json.load(open('skills/$owner/hooks/hooks.json'))
for ev, entries in h['hooks'].items():
    for entry in entries:
        for hook in entry['hooks']:
            if hook.get('type') == 'command':
                m = re.search(r'\\\${CLAUDE_PLUGIN_ROOT}/(\\S+)', hook['command'])
                if m: print(m.group(1))
"); do
        script_path="skills/$owner/$cmd"
        [ -f "$script_path" ] || fail "$owner: hooks.json references missing script: $cmd"
        [ -x "$script_path" ] || fail "$owner: $cmd not executable"
    done
done
pass "all referenced scripts exist and are executable under their owner skill"

# ─────────────────────────────────────────────────────────────────
# 6. Script invocation determinism: each trigger runs exactly once per call
# ─────────────────────────────────────────────────────────────────
tmpcounter=$(mktemp)
trap 'rm -f "$tmpcounter"' EXIT

# Invoke frustration trigger once; it writes nothing itself but should output
# deterministic content. Count how many <BLOCK_BREAK_ACTIVATED> blocks it emits.
fire_count=$(bash skills/block-break/hooks/frustration-trigger.sh 2>/dev/null \
    | grep -c "<BLOCK_BREAK_ACTIVATED>" || true)

if [ "$fire_count" -ne 1 ]; then
    fail "frustration-trigger.sh emits $fire_count BLOCK_BREAK blocks per call (expected exactly 1)"
fi
pass "frustration-trigger.sh emits exactly 1 activation block per invocation"

fire_count=$(bash skills/claim-ground/hooks/epistemic-pushback-trigger.sh 2>/dev/null \
    | grep -c "<CLAIM_GROUND_ACTIVATED>" || true)

if [ "$fire_count" -ne 1 ]; then
    fail "epistemic-pushback-trigger.sh emits $fire_count CLAIM_GROUND blocks per call (expected exactly 1)"
fi
pass "epistemic-pushback-trigger.sh emits exactly 1 activation block per invocation"

echo
echo "[OK] hook-fanout regression test passed — N-fan-out structure is gone."
