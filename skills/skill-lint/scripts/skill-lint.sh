#!/usr/bin/env bash
# Skill Lint — Structure checker for Claude Code plugin projects
#
# Usage: skill-lint.sh [plugin-root-path]
# Output: JSON { "errors": [...], "warnings": [...], "passed": [...] }

set -euo pipefail

PLUGIN_ROOT="${1:-.}"
PLUGIN_ROOT="$(cd "$PLUGIN_ROOT" && pwd)"

ERRORS=()
WARNINGS=()
PASSED=()

add_error()   { ERRORS+=("$1"); }
add_warning() { WARNINGS+=("$1"); }
add_passed()  { PASSED+=("$1"); }

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
        "$(printf '%s\n' "${ERRORS[@]}" | python3 -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin]))')" \
        "$(printf '%s\n' "${WARNINGS[@]:-}" | python3 -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')" \
        "$(printf '%s\n' "${PASSED[@]:-}" | python3 -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')"
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
    # Extract YAML frontmatter between --- delimiters
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
    # Check both formats: per-plugin name entries OR skills array paths
    if [ -f "$PLUGIN_ROOT/.claude-plugin/marketplace.json" ]; then
        if python3 -c "
import json, sys
with open('$PLUGIN_ROOT/.claude-plugin/marketplace.json') as f:
    data = json.load(f)
plugins = data.get('plugins', [])
# Check per-plugin name match
names = [p.get('name', '') for p in plugins]
if '$skill_name' in names:
    sys.exit(0)
# Check skills array paths (e.g. './skills/block-break')
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
    # Find references/ paths mentioned in SKILL.md
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
done

# --- Output JSON ---
json_array() {
    local arr=("$@")
    if [ ${#arr[@]} -eq 0 ]; then
        echo "[]"
        return
    fi
    printf '%s\n' "${arr[@]}" | python3 -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))'
}

printf '{"errors": %s, "warnings": %s, "passed": %s}\n' \
    "$(json_array "${ERRORS[@]+"${ERRORS[@]}"}")" \
    "$(json_array "${WARNINGS[@]+"${WARNINGS[@]}"}")" \
    "$(json_array "${PASSED[@]+"${PASSED[@]}"}")"
