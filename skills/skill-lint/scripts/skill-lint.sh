#!/usr/bin/env bash
# Skill Lint — Structure checker for Claude Code plugin projects
#
# Usage: skill-lint.sh [plugin-root-path]
# Output: JSON { "errors": [...], "warnings": [...], "passed": [...] }
#
# Core rules (S01-S08) always run for any Claude Code plugin.
# Extended rules (S09-S17) only run when .skill-lint.json exists in the target directory.

set -euo pipefail

PLUGIN_ROOT="${1:-.}"
PLUGIN_ROOT="$(cd "$PLUGIN_ROOT" && pwd)"

ERRORS=()
WARNINGS=()
PASSED=()

add_error()   { ERRORS+=("$1"); }
add_warning() { WARNINGS+=("$1"); }
add_passed()  { PASSED+=("$1"); }

# --- Load optional .skill-lint.json config ---
CONFIG_FILE="$PLUGIN_ROOT/.skill-lint.json"
CFG_NAMING_PATTERN=""
CFG_CATEGORY_VALUES=""
CFG_REQUIRE_TRIGGER_TEST=""
CFG_REQUIRE_GUIDE=""
CFG_REQUIRE_DESIGN_DOC=""
CFG_PLATFORMS=""
CFG_I18N_DIR=""
CFG_REQUIRE_I18N_GUIDE=""
CFG_REQUIRE_PERMISSIONS=""
CFG_VERIFY_INTEGRITY=""
CFG_REQUIRE_AGENT_MODEL=""
CFG_NO_DANGEROUS_PATTERNS=""

if [ -f "$CONFIG_FILE" ]; then
    # Parse config using python
    eval "$(python3 -c "
import json, sys, shlex
with open('$CONFIG_FILE') as f:
    cfg = json.load(f)
rules = cfg.get('rules', {})
if 'naming-pattern' in rules:
    print(f'CFG_NAMING_PATTERN={shlex.quote(rules[\"naming-pattern\"])}')
if 'category-values' in rules:
    print(f'CFG_CATEGORY_VALUES={shlex.quote(\"|\".join(rules[\"category-values\"]))}')
if rules.get('require-trigger-test'):
    print('CFG_REQUIRE_TRIGGER_TEST=1')
if rules.get('require-guide'):
    print('CFG_REQUIRE_GUIDE=1')
if rules.get('require-design-doc'):
    print('CFG_REQUIRE_DESIGN_DOC=1')
if 'platforms' in rules and rules['platforms']:
    print(f'CFG_PLATFORMS={shlex.quote(\" \".join(rules[\"platforms\"]))}')
if 'i18n-dir' in rules:
    print(f'CFG_I18N_DIR={shlex.quote(rules[\"i18n-dir\"])}')
if rules.get('require-i18n-guide'):
    print('CFG_REQUIRE_I18N_GUIDE=1')
if rules.get('require-permissions-declaration'):
    print('CFG_REQUIRE_PERMISSIONS=1')
if rules.get('verify-integrity-hash'):
    print('CFG_VERIFY_INTEGRITY=1')
if rules.get('require-agent-model'):
    print('CFG_REQUIRE_AGENT_MODEL=1')
if rules.get('no-dangerous-patterns'):
    print('CFG_NO_DANGEROUS_PATTERNS=1')
" 2>/dev/null)" || true
fi

# ============================================================
# Core Rules (S01-S08) — always run
# ============================================================

# --- S01: plugin.json existence ---
if [ -f "$PLUGIN_ROOT/plugin.json" ]; then
    add_passed "S01: plugin.json exists at root"
else
    add_error "S01: plugin.json missing at root"
fi

if [ -f "$PLUGIN_ROOT/.claude-plugin/plugin.json" ]; then
    add_passed "S01: .claude-plugin/plugin.json exists"
else
    add_error "S01: .claude-plugin/plugin.json missing"
fi

# --- S02: marketplace.json existence ---
if [ -f "$PLUGIN_ROOT/.claude-plugin/marketplace.json" ]; then
    add_passed "S02: .claude-plugin/marketplace.json exists"
else
    add_error "S02: .claude-plugin/marketplace.json missing"
fi

# --- Discover skills ---
SKILLS_DIR="$PLUGIN_ROOT/skills"
if [ ! -d "$SKILLS_DIR" ]; then
    add_error "S03: skills/ directory not found"
    # Output and exit early
    printf '{"errors": %s, "warnings": %s, "passed": %s}\n' \
        "$(printf '%s\n' "${ERRORS[@]}" | python -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin]))')" \
        "$(printf '%s\n' "${WARNINGS[@]:-}" | python -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')" \
        "$(printf '%s\n' "${PASSED[@]:-}" | python -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')"
    exit 0
fi

# Enumerate skill directories
SKILL_NAMES=()
for skill_dir in "$SKILLS_DIR"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    SKILL_NAMES+=("$skill_name")
done

if [ ${#SKILL_NAMES[@]} -eq 0 ]; then
    add_warning "No skill directories found under skills/"
fi

for skill_name in "${SKILL_NAMES[@]}"; do
    skill_md="$SKILLS_DIR/$skill_name/SKILL.md"

    # --- S03: SKILL.md existence ---
    if [ -f "$skill_md" ]; then
        add_passed "S03: skills/$skill_name/SKILL.md exists"
    else
        add_error "S03: skills/$skill_name/SKILL.md missing"
        continue
    fi

    # --- S04: Frontmatter required fields ---
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_md" | sed '1d;$d')

    if echo "$frontmatter" | grep -qE '^name:'; then
        add_passed "S04: skills/$skill_name/SKILL.md has 'name' field"
    else
        add_error "S04: skills/$skill_name/SKILL.md missing required field 'name'"
    fi

    if echo "$frontmatter" | grep -qE '^description:'; then
        add_passed "S04: skills/$skill_name/SKILL.md has 'description' field"
    else
        add_error "S04: skills/$skill_name/SKILL.md missing required field 'description'"
    fi

    # --- S06: marketplace.json entry ---
    if [ -f "$PLUGIN_ROOT/.claude-plugin/marketplace.json" ]; then
        if python -c "
import json, sys
with open('$PLUGIN_ROOT/.claude-plugin/marketplace.json') as f:
    data = json.load(f)
plugins = data.get('plugins', [])
names = [p.get('name', '') for p in plugins]
if '$skill_name' in names:
    sys.exit(0)
for p in plugins:
    skills = p.get('skills', [])
    for s in skills:
        if s.rstrip('/').endswith('$skill_name'):
            sys.exit(0)
sys.exit(1)
" 2>/dev/null; then
            add_passed "S06: '$skill_name' listed in marketplace.json"
        else
            add_warning "S06: '$skill_name' not listed in .claude-plugin/marketplace.json"
        fi
    fi

    # --- S07: References link check ---
    ref_mentions=$(grep -oE 'references/[a-zA-Z0-9_-]+\.md' "$skill_md" 2>/dev/null || true)
    if [ -n "$ref_mentions" ]; then
        while IFS= read -r ref_path; do
            full_path="$SKILLS_DIR/$skill_name/$ref_path"
            if [ -f "$full_path" ]; then
                add_passed "S07: skills/$skill_name/$ref_path exists"
            else
                add_error "S07: skills/$skill_name/$ref_path referenced in SKILL.md but file missing"
            fi
        done <<< "$ref_mentions"
    fi

    # --- S08: Evals directory ---
    if [ -f "$PLUGIN_ROOT/evals/$skill_name/scenarios.md" ]; then
        add_passed "S08: evals/$skill_name/scenarios.md exists"
    else
        add_warning "S08: evals/$skill_name/scenarios.md missing — no evaluation scenarios"
    fi

    # ============================================================
    # Extended Rules (S09-S16) — only when .skill-lint.json exists
    # ============================================================

    # --- S09: Naming convention ---
    if [ -n "$CFG_NAMING_PATTERN" ]; then
        if echo "$skill_name" | grep -qE "$CFG_NAMING_PATTERN"; then
            add_passed "S09: '$skill_name' matches naming pattern ($CFG_NAMING_PATTERN)"
        else
            add_warning "S09: '$skill_name' does not match naming pattern ($CFG_NAMING_PATTERN)"
        fi
    fi

    # --- S10: Category field ---
    if [ -n "$CFG_CATEGORY_VALUES" ]; then
        category_value=$(echo "$frontmatter" | grep -E '^\s*category:' | sed 's/.*category:\s*//' | tr -d '[:space:]' || true)
        if echo "$category_value" | grep -qE "^($CFG_CATEGORY_VALUES)$"; then
            add_passed "S10: skills/$skill_name/SKILL.md has valid 'category' ($category_value)"
        elif [ -z "$category_value" ]; then
            add_error "S10: skills/$skill_name/SKILL.md missing 'category' (expected: $CFG_CATEGORY_VALUES)"
        else
            add_error "S10: skills/$skill_name/SKILL.md invalid category '$category_value' (expected: $CFG_CATEGORY_VALUES)"
        fi
    fi

    # --- S11: Trigger test script ---
    if [ -n "$CFG_REQUIRE_TRIGGER_TEST" ]; then
        if [ -f "$PLUGIN_ROOT/evals/$skill_name/run-trigger-test.sh" ]; then
            add_passed "S11: evals/$skill_name/run-trigger-test.sh exists"
        else
            add_warning "S11: evals/$skill_name/run-trigger-test.sh missing"
        fi
    fi

    # --- S12: User guide ---
    if [ -n "$CFG_REQUIRE_GUIDE" ]; then
        if [ -f "$PLUGIN_ROOT/docs/guide/$skill_name-guide.md" ]; then
            add_passed "S12: docs/guide/$skill_name-guide.md exists"
        else
            add_warning "S12: docs/guide/$skill_name-guide.md missing"
        fi
    fi

    # --- S13: Design document ---
    if [ -n "$CFG_REQUIRE_DESIGN_DOC" ]; then
        if [ -f "$PLUGIN_ROOT/docs/plans/$skill_name-design.md" ]; then
            add_passed "S13: docs/plans/$skill_name-design.md exists"
        else
            add_warning "S13: docs/plans/$skill_name-design.md missing"
        fi
    fi

    # --- S14: Platform adaptations ---
    if [ -n "$CFG_PLATFORMS" ]; then
        for platform in $CFG_PLATFORMS; do
            plat_skill="$PLUGIN_ROOT/platforms/$platform/$skill_name/SKILL.md"
            if [ -f "$plat_skill" ]; then
                add_passed "S14: platforms/$platform/$skill_name/SKILL.md exists"
            else
                add_warning "S14: platforms/$platform/$skill_name/SKILL.md missing"
            fi
            # Check references sync
            if [ -d "$PLUGIN_ROOT/skills/$skill_name/references" ] && [ -f "$plat_skill" ]; then
                for cc_ref in "$PLUGIN_ROOT/skills/$skill_name/references/"*.md; do
                    [ -f "$cc_ref" ] || continue
                    ref_basename="$(basename "$cc_ref")"
                    plat_ref="$PLUGIN_ROOT/platforms/$platform/$skill_name/references/$ref_basename"
                    if [ -f "$plat_ref" ]; then
                        add_passed "S14: platforms/$platform/$skill_name/references/$ref_basename exists"
                    else
                        add_warning "S14: platforms/$platform/$skill_name/references/$ref_basename missing"
                    fi
                done
            fi
        done
    fi

    # --- S15: i18n README coverage ---
    if [ -n "$CFG_I18N_DIR" ]; then
        i18n_path="$PLUGIN_ROOT/$CFG_I18N_DIR"
        if [ -d "$i18n_path" ]; then
            for i18n_readme in "$i18n_path/"README.*.md; do
                [ -f "$i18n_readme" ] || continue
                lang="$(basename "$i18n_readme" | sed 's/README\.//;s/\.md//')"
                if grep -q "$skill_name" "$i18n_readme" 2>/dev/null; then
                    add_passed "S15: '$skill_name' listed in README.$lang.md"
                else
                    add_warning "S15: '$skill_name' not found in $CFG_I18N_DIR/README.$lang.md"
                fi
            done
        fi
    fi

    # --- S16: i18n guide coverage ---
    if [ -n "$CFG_REQUIRE_I18N_GUIDE" ] && [ -n "$CFG_I18N_DIR" ]; then
        i18n_path="$PLUGIN_ROOT/$CFG_I18N_DIR"
        guide_i18n_dir="$PLUGIN_ROOT/docs/guide/i18n"
        if [ -d "$i18n_path" ]; then
            for i18n_readme in "$i18n_path/"README.*.md; do
                [ -f "$i18n_readme" ] || continue
                lang="$(basename "$i18n_readme" | sed 's/README\.//;s/\.md//')"
                guide_i18n_file="$guide_i18n_dir/$skill_name-guide.$lang.md"
                if [ -f "$guide_i18n_file" ]; then
                    add_passed "S16: docs/guide/i18n/$skill_name-guide.$lang.md exists"
                else
                    add_warning "S16: docs/guide/i18n/$skill_name-guide.$lang.md missing"
                fi
            done
        fi
    fi
done

# --- S17: i18n guide wrong-path guard ---
# Detect common misplacement: docs/i18n/guide/ instead of docs/guide/i18n/
if [ -n "$CFG_REQUIRE_I18N_GUIDE" ] && [ -d "$PLUGIN_ROOT/docs/i18n/guide" ]; then
    wrong_count=$(find "$PLUGIN_ROOT/docs/i18n/guide" -type f -name "*.md" 2>/dev/null | wc -l)
    if [ "$wrong_count" -gt 0 ]; then
        add_error "S17: docs/i18n/guide/ contains $wrong_count files — wrong path. i18n guides belong in docs/guide/i18n/"
    fi
fi

# --- S18: permissions declaration ---
if [ -n "$CFG_REQUIRE_PERMISSIONS" ]; then
    s18_fail=0
    for skill_md in "$PLUGIN_ROOT"/skills/*/SKILL.md; do
        [ -f "$skill_md" ] || continue
        skill_name="$(basename "$(dirname "$skill_md")")"
        if ! head -30 "$skill_md" | grep -q "permissions:"; then
            add_error "S18: $skill_name/SKILL.md missing metadata.permissions declaration"
            s18_fail=1
        fi
    done
    [ "$s18_fail" -eq 0 ] && add_passed "S18: All skills declare metadata.permissions"
fi

# --- S19: integrity hash verification ---
if [ -n "$CFG_VERIFY_INTEGRITY" ] && [ -f "$PLUGIN_ROOT/.claude-plugin/marketplace.json" ]; then
    s19_fail=0
    for skill_md in "$PLUGIN_ROOT"/skills/*/SKILL.md; do
        [ -f "$skill_md" ] || continue
        skill_name="$(basename "$(dirname "$skill_md")")"
        skill_rel="./skills/$skill_name"
        expected_hash=$(python -c "
import json
with open('$PLUGIN_ROOT/.claude-plugin/marketplace.json') as f:
    data = json.load(f)
for p in data.get('plugins', []):
    if '$skill_rel' in p.get('skills', []):
        print(p.get('integrity', {}).get('skill-md-sha256', ''))
        break
" 2>/dev/null)
        if [ -z "$expected_hash" ]; then
            add_warning "S19: $skill_name missing integrity hash in marketplace.json"
            continue
        fi
        actual_hash=$(sha256sum "$skill_md" | cut -d' ' -f1)
        if [ "$expected_hash" != "$actual_hash" ]; then
            add_error "S19: $skill_name SKILL.md hash mismatch (expected: ${expected_hash:0:12}... got: ${actual_hash:0:12}...)"
            s19_fail=1
        fi
    done
    [ "$s19_fail" -eq 0 ] && add_passed "S19: All integrity hashes match"
fi

# --- S20: agent model declaration ---
if [ -n "$CFG_REQUIRE_AGENT_MODEL" ]; then
    s20_fail=0
    for agent_md in "$PLUGIN_ROOT"/skills/*/agents/*.md; do
        [ -f "$agent_md" ] || continue
        agent_name="$(basename "$agent_md")"
        if ! head -10 "$agent_md" | grep -q "^model:"; then
            add_error "S20: $agent_name missing 'model' in frontmatter"
            s20_fail=1
        fi
    done
    [ "$s20_fail" -eq 0 ] && add_passed "S20: All agent files declare model"
fi

# --- S21: no dangerous patterns ---
if [ -n "$CFG_NO_DANGEROUS_PATTERNS" ]; then
    s21_fail=0
    dangerous_patterns="--dangerously-skip-permissions|--no-verify|rm -rf /|curl.*\| *sh"
    for skill_dir in "$PLUGIN_ROOT"/skills/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        matches=$(grep -rlE "$dangerous_patterns" "$skill_dir"SKILL.md "$skill_dir"references/ "$skill_dir"agents/ 2>/dev/null || true)
        if [ -n "$matches" ]; then
            for m in $matches; do
                rel_path="${m#$PLUGIN_ROOT/}"
                add_warning "S21: Dangerous pattern found in $rel_path"
            done
            s21_fail=1
        fi
    done
    [ "$s21_fail" -eq 0 ] && add_passed "S21: No dangerous patterns detected"
fi

# --- Output JSON ---
json_array() {
    local arr=("$@")
    if [ ${#arr[@]} -eq 0 ]; then
        echo "[]"
        return
    fi
    printf '%s\n' "${arr[@]}" | python -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))'
}

printf '{"errors": %s, "warnings": %s, "passed": %s}\n' \
    "$(json_array "${ERRORS[@]+"${ERRORS[@]}"}")" \
    "$(json_array "${WARNINGS[@]+"${WARNINGS[@]}"}")" \
    "$(json_array "${PASSED[@]+"${PASSED[@]}"}")"
