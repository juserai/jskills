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
CFG_VERIFY_PLATFORM_SUBDIRS=""
CFG_VERIFY_I18N_STRUCTURE=""
CFG_VERIFY_CROSS_SKILL_CATEGORY=""
# Path config (see rules.md): fallback to legacy layout if keys absent.
CFG_USER_GUIDE_DIR="docs/guide"
CFG_DESIGN_DIR="docs/plans"
CFG_I18N_GUIDE_DIR="docs/i18n/guide"

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
if rules.get('verify-platform-subdirs'):
    print('CFG_VERIFY_PLATFORM_SUBDIRS=1')
if rules.get('verify-i18n-structure-parity'):
    print('CFG_VERIFY_I18N_STRUCTURE=1')
if rules.get('verify-cross-skill-category-claim'):
    print('CFG_VERIFY_CROSS_SKILL_CATEGORY=1')
# Path config — single source of truth; legacy defaults applied in shell if absent.
if 'user-guide-dir' in rules:
    print(f'CFG_USER_GUIDE_DIR={shlex.quote(rules[\"user-guide-dir\"])}')
if 'design-dir' in rules:
    print(f'CFG_DESIGN_DIR={shlex.quote(rules[\"design-dir\"])}')
if 'i18n-guide-dir' in rules:
    print(f'CFG_I18N_GUIDE_DIR={shlex.quote(rules[\"i18n-guide-dir\"])}')
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
        if [ -f "$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR/$skill_name-guide.md" ]; then
            add_passed "S12: $CFG_USER_GUIDE_DIR/$skill_name-guide.md exists"
        else
            add_warning "S12: $CFG_USER_GUIDE_DIR/$skill_name-guide.md missing"
        fi
    fi

    # --- S13: Design document ---
    if [ -n "$CFG_REQUIRE_DESIGN_DOC" ]; then
        if [ -f "$PLUGIN_ROOT/$CFG_DESIGN_DIR/$skill_name-design.md" ]; then
            add_passed "S13: $CFG_DESIGN_DIR/$skill_name-design.md exists"
        else
            add_warning "S13: $CFG_DESIGN_DIR/$skill_name-design.md missing"
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
    # Path driven by CFG_I18N_GUIDE_DIR (default docs/i18n/guide).
    if [ -n "$CFG_REQUIRE_I18N_GUIDE" ] && [ -n "$CFG_I18N_DIR" ]; then
        i18n_path="$PLUGIN_ROOT/$CFG_I18N_DIR"
        guide_i18n_dir="$PLUGIN_ROOT/$CFG_I18N_GUIDE_DIR"
        if [ -d "$i18n_path" ]; then
            for i18n_readme in "$i18n_path/"README.*.md; do
                [ -f "$i18n_readme" ] || continue
                lang="$(basename "$i18n_readme" | sed 's/README\.//;s/\.md//')"
                guide_i18n_file="$guide_i18n_dir/$skill_name-guide.$lang.md"
                if [ -f "$guide_i18n_file" ]; then
                    add_passed "S16: $CFG_I18N_GUIDE_DIR/$skill_name-guide.$lang.md exists"
                else
                    add_warning "S16: $CFG_I18N_GUIDE_DIR/$skill_name-guide.$lang.md missing"
                fi
            done
        fi
    fi
done

# --- S17: i18n guide wrong-path guard ---
# Guard against the reversed misplacement: <user-guide-dir>/i18n/ (where files would be invisible to S16).
if [ -n "$CFG_REQUIRE_I18N_GUIDE" ] \
    && [ "$CFG_I18N_GUIDE_DIR" != "$CFG_USER_GUIDE_DIR/i18n" ] \
    && [ -d "$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR/i18n" ]; then
    wrong_count=$(find "$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR/i18n" -type f -name "*.md" 2>/dev/null | wc -l)
    if [ "$wrong_count" -gt 0 ]; then
        add_error "S17: $CFG_USER_GUIDE_DIR/i18n/ contains $wrong_count files — wrong path. i18n guides belong in $CFG_I18N_GUIDE_DIR/"
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

# --- S22: platform-parity for agents/ templates/ scripts/ subdirs ---
# Extends S14 which only covers references/.
# When "platforms" and "verify-platform-subdirs" are set, mirror-check every subdir under skills/<name>/
# against platforms/<platform>/<name>/.
if [ -n "$CFG_VERIFY_PLATFORM_SUBDIRS" ] && [ -n "$CFG_PLATFORMS" ]; then
    s22_fail=0
    for skill_name in "${SKILL_NAMES[@]}"; do
        for platform in $CFG_PLATFORMS; do
            for subdir in agents templates scripts; do
                cc_sub="$PLUGIN_ROOT/skills/$skill_name/$subdir"
                plat_sub="$PLUGIN_ROOT/platforms/$platform/$skill_name/$subdir"
                [ -d "$cc_sub" ] || continue
                for cc_file in "$cc_sub"/*; do
                    [ -f "$cc_file" ] || continue
                    fname="$(basename "$cc_file")"
                    plat_file="$plat_sub/$fname"
                    if [ -f "$plat_file" ]; then
                        add_passed "S22: platforms/$platform/$skill_name/$subdir/$fname exists"
                    else
                        add_warning "S22: platforms/$platform/$skill_name/$subdir/$fname missing (present in skills/$skill_name/$subdir/)"
                        s22_fail=1
                    fi
                done
            done
        done
    done
    [ "$s22_fail" -eq 0 ] && add_passed "S22: All skill subdirectories mirrored to platforms"
fi

# --- S23: i18n structure parity (H2 headings) ---
# For each skill's English guide, ensure each i18n guide has >= 90% of the H2 headings.
if [ -n "$CFG_VERIFY_I18N_STRUCTURE" ] && [ -n "$CFG_I18N_DIR" ]; then
    s23_fail=0
    guide_dir="$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR"
    i18n_guide_dir="$PLUGIN_ROOT/$CFG_I18N_GUIDE_DIR"
    for skill_name in "${SKILL_NAMES[@]}"; do
        en_guide="$guide_dir/$skill_name-guide.md"
        [ -f "$en_guide" ] || continue
        en_h2_count=$(grep -c "^## " "$en_guide" 2>/dev/null || echo 0)
        [ "$en_h2_count" -eq 0 ] && continue
        for i18n_file in "$i18n_guide_dir/$skill_name-guide."*.md; do
            [ -f "$i18n_file" ] || continue
            lang=$(basename "$i18n_file" | sed "s/^$skill_name-guide\\.//;s/\\.md$//")
            i18n_h2_count=$(grep -c "^## " "$i18n_file" 2>/dev/null || echo 0)
            # require i18n to have >= ceil(en * 0.9) sections
            threshold=$(( (en_h2_count * 90 + 99) / 100 ))
            if [ "$i18n_h2_count" -ge "$threshold" ]; then
                add_passed "S23: $skill_name.$lang H2 parity OK ($i18n_h2_count/$en_h2_count)"
            else
                add_error "S23: $skill_name.$lang H2 structure gap ($i18n_h2_count/$en_h2_count, need >= $threshold)"
                s23_fail=1
            fi
        done
    done
    [ "$s23_fail" -eq 0 ] && add_passed "S23: All i18n guides match English structure within 90%"
fi

# --- S24: cross-skill category-claim detection ---
# Detect "same category" / "different category" claims in guide files and flag for manual review
# when they reference a category keyword. Does not prove correctness (full semantic check is out
# of scope for bash lint), but warns on the pattern that caused past regressions.
if [ -n "$CFG_VERIFY_CROSS_SKILL_CATEGORY" ]; then
    s24_fail=0
    cat_keywords='hammer|crucible|anvil|quench'
    same_category_patterns='Same category|Different categories?|同一分类|不同分类|同カテゴリ|異なるカテゴリ|동일 카테고리|다른 카테고리|समान श्रेणी|अलग श्रेणी|Misma categoría|Categorías diferentes|Même catégorie|Catégories différentes|Gleiche Kategorie|Unterschiedliche Kategorien|Mesma categoria|Categorias diferentes|Та же категория|Разные категории|Aynı kategori|Farklı kategoriler|Cùng phân loại|Phân loại khác'
    declare -A seen_categories
    # Build skill → category map
    for skill_name in "${SKILL_NAMES[@]}"; do
        skill_md="$SKILLS_DIR/$skill_name/SKILL.md"
        [ -f "$skill_md" ] || continue
        cat_val=$(grep -E '^\s*category:' "$skill_md" | head -1 | sed 's/.*category:[[:space:]]*//' | tr -d '[:space:]')
        [ -n "$cat_val" ] && seen_categories[$skill_name]=$cat_val
    done
    # Scan guide files for potentially stale claims
    for guide_file in "$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR/"*.md "$PLUGIN_ROOT/$CFG_I18N_GUIDE_DIR/"*.md; do
        [ -f "$guide_file" ] || continue
        # Find lines matching "<same/different category phrase> ... (<category keyword>)" OR "... is <category>"
        matches=$(grep -nE "($same_category_patterns).*\\((${cat_keywords})\\)|\\*\\*(${cat_keywords})\\*\\*" "$guide_file" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            # Check if this guide is for a specific skill
            guide_basename=$(basename "$guide_file")
            guide_skill=$(echo "$guide_basename" | sed 's/-guide.*$//')
            if [ -n "${seen_categories[$guide_skill]:-}" ]; then
                # The guide belongs to a known skill — verify claims against the referenced other skill
                declared_category="${seen_categories[$guide_skill]}"
                # Check each matched line: does it mention another skill? If so, is the stated category consistent?
                while IFS= read -r line; do
                    [ -n "$line" ] || continue
                    # Determine whether "same" or "different" is being claimed
                    is_same=0; is_different=0
                    if echo "$line" | grep -qE "(Same category|同一分类|同カテゴリ|동일 카테고리|समान श्रेणी|Misma categoría|Même catégorie|Gleiche Kategorie|Mesma categoria|Та же категория|Aynı kategori|Cùng phân loại)" 2>/dev/null; then
                        is_same=1
                    fi
                    if echo "$line" | grep -qE "(Different categories?|不同分类|異なるカテゴリ|다른 카테고리|अलग श्रेणी|Categorías diferentes|Catégories différentes|Unterschiedliche Kategorien|Categorias diferentes|Разные категории|Farklı kategoriler|Phân loại khác)" 2>/dev/null; then
                        is_different=1
                    fi
                    [ $is_same -eq 0 ] && [ $is_different -eq 0 ] && continue
                    # Which other skill is being referenced in this line?
                    other_skill=""
                    for s in "${!seen_categories[@]}"; do
                        [ "$s" = "$guide_skill" ] && continue
                        if echo "$line" | grep -qw "$s" 2>/dev/null; then
                            other_skill="$s"
                            break
                        fi
                    done
                    [ -z "$other_skill" ] && continue
                    other_cat="${seen_categories[$other_skill]}"
                    if [ $is_same -eq 1 ] && [ "$declared_category" != "$other_cat" ]; then
                        add_error "S24: $guide_basename claims 'same category' between $guide_skill($declared_category) and $other_skill($other_cat) — mismatch"
                        s24_fail=1
                    elif [ $is_different -eq 1 ] && [ "$declared_category" = "$other_cat" ]; then
                        add_error "S24: $guide_basename claims 'different categories' between $guide_skill($declared_category) and $other_skill($other_cat) — but they're the same"
                        s24_fail=1
                    fi
                done <<< "$matches"
            fi
        fi
    done
    [ "$s24_fail" -eq 0 ] && add_passed "S24: Cross-skill category claims consistent with SKILL.md frontmatter"
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
