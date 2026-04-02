#!/usr/bin/env bash
# Ralph Boost — Autonomous Development Loop Engine
# Usage: bash boost-loop.sh [--project-dir <path>]
#
# Prerequisites: bash 4+, jq OR python3, claude (Claude Code CLI)

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

BOOST_DIR=".ralph-boost"
CONFIG_FILE="$BOOST_DIR/config.json"
STATE_FILE="$BOOST_DIR/state.json"
PROMPT_FILE="$BOOST_DIR/PROMPT.md"
FIX_PLAN_FILE="$BOOST_DIR/fix_plan.md"
LOG_DIR="$BOOST_DIR/logs"
BOOST_LOG="$LOG_DIR/boost.log"
HANDOFF_FILE="$BOOST_DIR/handoff-report.md"

# Defaults (overridden by config.json)
MAX_CALLS_PER_HOUR=100
CLAUDE_TIMEOUT_MINUTES=15
CLAUDE_MODEL=""
SESSION_EXPIRY_HOURS=24
NO_PROGRESS_THRESHOLD=7
SAME_ERROR_THRESHOLD=8
SLEEP_SECONDS=3600
ALLOWED_TOOLS=("Write" "Read" "Edit" "Bash" "Glob" "Grep")

# ============================================================
# Utilities
# ============================================================

log() {
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "[$timestamp] $*" | tee -a "$BOOST_LOG"
}

die() {
    log "FATAL: $*"
    exit 1
}

# ============================================================
# JSON Engine (jq / python3 dual support)
# ============================================================

JSON_ENGINE=""

detect_json_engine() {
    if command -v jq >/dev/null 2>&1; then
        JSON_ENGINE="jq"
    elif command -v python3 >/dev/null 2>&1; then
        JSON_ENGINE="python3"
    elif command -v python >/dev/null 2>&1; then
        JSON_ENGINE="python"
    else
        die "Requires jq or python3, neither found"
    fi
    log "JSON engine: $JSON_ENGINE"
}

# Read a field from a JSON string on stdin. Args: jq_path, default
json_get_str() {
    local jq_path="$1" default="${2:-}"
    case "$JSON_ENGINE" in
        jq)
            jq -r "${jq_path} // \"${default}\""
            ;;
        python3|python)
            $JSON_ENGINE -c "
import json, sys
d = json.load(sys.stdin)
path = '''${jq_path}'''.lstrip('.')
keys = [k for k in path.split('.') if k]
v = d
for k in keys:
    if isinstance(v, dict):
        v = v.get(k)
    else:
        v = None
    if v is None:
        break
if v is None:
    print('''${default}''')
else:
    print(v)
"
            ;;
    esac
}

# Read a field from a JSON file. Args: file, jq_path, default
json_get_file() {
    local file="$1" jq_path="$2" default="${3:-}"
    cat "$file" | json_get_str "$jq_path" "$default"
}

# Set a field in a JSON string. Input on stdin. Args: dotpath, value_json
# Outputs updated JSON string
json_set_field() {
    local dotpath="$1" value="$2"
    case "$JSON_ENGINE" in
        jq)
            jq "${dotpath} = ${value}"
            ;;
        python3|python)
            $JSON_ENGINE -c "
import json, sys
d = json.load(sys.stdin)
path = '''${dotpath}'''.lstrip('.')
keys = [k for k in path.split('.') if k]
obj = d
for k in keys[:-1]:
    obj = obj[k]
obj[keys[-1]] = json.loads('''${value}''')
print(json.dumps(d, indent=2))
"
            ;;
    esac
}

# Validate and pretty-print JSON from stdin
json_format() {
    case "$JSON_ENGINE" in
        jq)
            jq '.'
            ;;
        python3|python)
            $JSON_ENGINE -c "import json,sys; print(json.dumps(json.load(sys.stdin),indent=2))"
            ;;
    esac
}

# Get length of array at path. Input on stdin. Args: jq_path
json_array_length() {
    local jq_path="$1"
    case "$JSON_ENGINE" in
        jq)
            jq "${jq_path} | length"
            ;;
        python3|python)
            $JSON_ENGINE -c "
import json, sys
d = json.load(sys.stdin)
path = '''${jq_path}'''.lstrip('.')
keys = [k for k in path.split('.') if k]
v = d
for k in keys:
    if isinstance(v, dict):
        v = v.get(k, [])
    elif isinstance(v, list):
        break
print(len(v) if isinstance(v, list) else 0)
"
            ;;
    esac
}

# Build a JSON object from key-value pairs. Args: key1 val1 key2 val2 ...
# Values that are pure integers are treated as numbers, otherwise strings
json_build() {
    case "$JSON_ENGINE" in
        jq)
            local args=()
            while [[ $# -ge 2 ]]; do
                local key="$1" val="$2"
                shift 2
                if [[ "$val" =~ ^[0-9]+$ ]]; then
                    args+=(--argjson "$key" "$val")
                else
                    args+=(--arg "$key" "$val")
                fi
            done
            jq -n "${args[@]}" '$ARGS.named'
            ;;
        python3|python)
            local pairs="{"
            local first=true
            while [[ $# -ge 2 ]]; do
                local key="$1" val="$2"
                shift 2
                [[ "$first" == "true" ]] && first=false || pairs+=","
                if [[ "$val" =~ ^[0-9]+$ ]]; then
                    pairs+="\"$key\":$val"
                else
                    # Escape quotes in value
                    val="${val//\\/\\\\}"
                    val="${val//\"/\\\"}"
                    pairs+="\"$key\":\"$val\""
                fi
            done
            pairs+="}"
            echo "$pairs"
            ;;
    esac
}

# Extract text from Claude CLI JSON output file. Args: output_file
json_extract_claude_text() {
    local output_file="$1"
    case "$JSON_ENGINE" in
        jq)
            if jq -e '.result' "$output_file" >/dev/null 2>&1; then
                jq -r '.result // ""' "$output_file"
            elif jq -e '.[].message' "$output_file" >/dev/null 2>&1; then
                jq -r '.[] | select(.type == "assistant") | .message // ""' "$output_file" 2>/dev/null || true
            else
                cat "$output_file"
            fi
            ;;
        python3|python)
            $JSON_ENGINE -c "
import json
with open('''${output_file}''') as f:
    try:
        d = json.load(f)
    except:
        with open('''${output_file}''') as f2:
            print(f2.read())
        exit()
if isinstance(d, dict) and 'result' in d:
    print(d.get('result', ''))
elif isinstance(d, list):
    for item in d:
        if isinstance(item, dict) and item.get('type') == 'assistant':
            print(item.get('message', ''))
            break
else:
    with open('''${output_file}''') as f2:
        print(f2.read())
" 2>/dev/null || cat "$output_file"
            ;;
    esac
}

# Extract session ID from Claude CLI JSON output file. Args: output_file
json_extract_session_id() {
    local output_file="$1"
    case "$JSON_ENGINE" in
        jq)
            jq -r '.session_id // .sessionId // empty' "$output_file" 2>/dev/null || true
            ;;
        python3|python)
            $JSON_ENGINE -c "
import json
with open('''${output_file}''') as f:
    try:
        d = json.load(f)
    except:
        exit()
sid = d.get('session_id', d.get('sessionId', ''))
if sid:
    print(sid)
" 2>/dev/null || true
            ;;
    esac
}

check_dependencies() {
    detect_json_engine
    command -v claude >/dev/null 2>&1 || die "claude CLI is required but not installed"
    [[ -d "$BOOST_DIR" ]] || die "$BOOST_DIR directory not found. Run '/ralph-boost setup' first"
    [[ -f "$CONFIG_FILE" ]] || die "$CONFIG_FILE not found"
    [[ -f "$STATE_FILE" ]] || die "$STATE_FILE not found"
    [[ -f "$PROMPT_FILE" ]] || die "$PROMPT_FILE not found"
}

# ============================================================
# Configuration Loading
# ============================================================

load_config() {
    MAX_CALLS_PER_HOUR=$(json_get_file "$CONFIG_FILE" ".max_calls_per_hour" "100")
    CLAUDE_TIMEOUT_MINUTES=$(json_get_file "$CONFIG_FILE" ".claude_timeout_minutes" "15")
    CLAUDE_MODEL=$(json_get_file "$CONFIG_FILE" ".claude_model" "")
    SESSION_EXPIRY_HOURS=$(json_get_file "$CONFIG_FILE" ".session_expiry_hours" "24")
    NO_PROGRESS_THRESHOLD=$(json_get_file "$CONFIG_FILE" ".no_progress_threshold" "7")
    SAME_ERROR_THRESHOLD=$(json_get_file "$CONFIG_FILE" ".same_error_threshold" "8")
    SLEEP_SECONDS=$(json_get_file "$CONFIG_FILE" ".sleep_seconds" "3600")

    # Load allowed_tools array
    local tools_list
    tools_list=$(json_get_file "$CONFIG_FILE" ".allowed_tools" "")
    if [[ -n "$tools_list" ]] && [[ "$tools_list" != "None" ]]; then
        case "$JSON_ENGINE" in
            jq)
                mapfile -t ALLOWED_TOOLS < <(cat "$CONFIG_FILE" | jq -r '.allowed_tools[]')
                ;;
            python3|python)
                mapfile -t ALLOWED_TOOLS < <($JSON_ENGINE -c "
import json
with open('${CONFIG_FILE}') as f: d = json.load(f)
for t in d.get('allowed_tools', []): print(t)
")
                ;;
        esac
    fi
}

# ============================================================
# State Management
# ============================================================

read_state() {
    cat "$STATE_FILE"
}

write_state() {
    local new_state="$1"
    local formatted
    if formatted=$(echo "$new_state" | json_format 2>/dev/null); then
        echo "$formatted" > "$STATE_FILE.tmp"
        mv "$STATE_FILE.tmp" "$STATE_FILE"
    else
        log "WARNING: Invalid JSON state, not writing"
    fi
}

get_field() {
    local state="$1" path="$2"
    echo "$state" | json_get_str "$path" ""
}

get_field_int() {
    local state="$1" path="$2"
    echo "$state" | json_get_str "$path" "0"
}

# ============================================================
# Pressure Level Calculation
# ============================================================

calculate_pressure() {
    local consecutive_no_progress="$1"
    if [[ $consecutive_no_progress -le 0 ]]; then echo 0
    elif [[ $consecutive_no_progress -eq 1 ]]; then echo 1
    elif [[ $consecutive_no_progress -eq 2 ]]; then echo 2
    elif [[ $consecutive_no_progress -eq 3 ]]; then echo 3
    else echo 4
    fi
}

pressure_name() {
    case "$1" in
        0) echo "L0 Trust" ;;
        1) echo "L1 Disappointment" ;;
        2) echo "L2 Interrogation" ;;
        3) echo "L3 Performance Review" ;;
        4) echo "L4 Graduation" ;;
        *) echo "L0 Trust" ;;
    esac
}

pressure_aside() {
    case "$1" in
        0) echo "" ;;
        1) echo "The team next door got it on the first try." ;;
        2) echo "What is the underlying logic? Where is the leverage point?" ;;
        3) echo "Rating: 3.25. This 3.25 is your motivation." ;;
        4) echo "Other models can solve this. You might be graduating soon." ;;
        *) echo "" ;;
    esac
}

# ============================================================
# Context Injection (--append-system-prompt)
# ============================================================

build_loop_context() {
    local state="$1"
    local loop_count
    loop_count=$(get_field_int "$state" ".session.loop_count")

    local pressure_level
    pressure_level=$(get_field_int "$state" ".pressure.level")

    local context="Loop #${loop_count}."

    # Previous loop summary (from last Claude output analysis)
    local last_output="$LOG_DIR/last_summary.txt"
    if [[ -f "$last_output" ]]; then
        local prev_summary
        prev_summary=$(head -c 200 "$last_output")
        context+=" Previous: ${prev_summary}"
    fi

    # Pressure-specific injection
    if [[ $pressure_level -ge 1 ]]; then
        local pname
        pname=$(pressure_name "$pressure_level")
        local paside
        paside=$(pressure_aside "$pressure_level")
        context+=" Pressure: ${pname}."
        [[ -n "$paside" ]] && context+=" ${paside}"

        local tried_count
        tried_count=$(echo "$state" | json_array_length ".pressure.tried_approaches")
        context+=" Tried approaches: ${tried_count}."
    fi

    case $pressure_level in
        1)
            context+=" MANDATORY: Switch to a fundamentally different approach. Parameter tweaks do NOT count."
            ;;
        2)
            context+=" MANDATORY: Read the error word-by-word. Search 50+ lines of context. List 3 fundamentally different hypotheses."
            ;;
        3)
            context+=" MANDATORY: Complete ALL 7 checklist items in state.json checklist_progress. No shortcuts."
            ;;
        4)
            context+=" MANDATORY: Build a minimal PoC to isolate the problem. Write handoff report to .ralph-boost/handoff-report.md."
            ;;
    esac

    # Truncate to ~500 chars
    echo "${context:0:500}"
}

# ============================================================
# Claude Invocation
# ============================================================

build_claude_cmd() {
    local session_id="$1" context="$2"
    local -a cmd=("claude")

    if [[ -n "$CLAUDE_MODEL" ]]; then
        cmd+=(--model "$CLAUDE_MODEL")
    fi

    cmd+=(--output-format json)

    # Allowed tools
    if [[ ${#ALLOWED_TOOLS[@]} -gt 0 ]]; then
        cmd+=(--allowedTools "${ALLOWED_TOOLS[@]}")
    fi

    # Session continuity
    if [[ -n "$session_id" ]]; then
        cmd+=(--resume "$session_id")
    fi

    # Context injection
    if [[ -n "$context" ]]; then
        cmd+=(--append-system-prompt "$context")
    fi

    # Prompt content
    local prompt_content
    prompt_content=$(cat "$PROMPT_FILE")
    cmd+=(-p "$prompt_content")

    printf '%s\0' "${cmd[@]}"
}

invoke_claude() {
    local session_id="$1" context="$2"
    local output_file="$LOG_DIR/claude_output_$(date -u +%Y%m%d_%H%M%S).log"
    local timeout_seconds=$((CLAUDE_TIMEOUT_MINUTES * 60))

    local -a cmd
    while IFS= read -r -d '' arg; do
        cmd+=("$arg")
    done < <(build_claude_cmd "$session_id" "$context")

    log "Invoking Claude (timeout: ${CLAUDE_TIMEOUT_MINUTES}m)..."

    local exit_code=0
    if command -v timeout >/dev/null 2>&1; then
        timeout "${timeout_seconds}s" "${cmd[@]}" < /dev/null > "$output_file" 2>&1 || exit_code=$?
    else
        "${cmd[@]}" < /dev/null > "$output_file" 2>&1 || exit_code=$?
    fi

    if [[ $exit_code -ne 0 ]] && [[ $exit_code -ne 124 ]]; then
        log "WARNING: Claude exited with code $exit_code"
    fi
    if [[ $exit_code -eq 124 ]]; then
        log "WARNING: Claude timed out after ${CLAUDE_TIMEOUT_MINUTES} minutes"
    fi

    echo "$output_file"
}

# ============================================================
# Response Parsing
# ============================================================

parse_boost_status() {
    local output_file="$1"
    local result="{}"

    # Try to extract BOOST_STATUS block from JSON output
    local raw_text=""
    raw_text=$(json_extract_claude_text "$output_file")

    # Extract BOOST_STATUS block
    local status_block=""
    if echo "$raw_text" | grep -q -- "---BOOST_STATUS---"; then
        status_block=$(echo "$raw_text" | sed -n '/---BOOST_STATUS---/,/---END_BOOST_STATUS---/p')
    fi

    # Parse fields from status block
    local status="UNKNOWN" exit_signal="false" files_modified=0
    local tasks_completed=0 tests_status="NOT_RUN" work_type="UNKNOWN"
    local pressure_level="L0" tried_count=0

    if [[ -n "$status_block" ]]; then
        status=$(echo "$status_block" | grep -oP 'STATUS:\s*\K\S+' | head -1 || echo "UNKNOWN")
        exit_signal=$(echo "$status_block" | grep -oP 'EXIT_SIGNAL:\s*\K\S+' | head -1 || echo "false")
        files_modified=$(echo "$status_block" | grep -oP 'FILES_MODIFIED:\s*\K\d+' | head -1 || echo "0")
        tasks_completed=$(echo "$status_block" | grep -oP 'TASKS_COMPLETED_THIS_LOOP:\s*\K\d+' | head -1 || echo "0")
        tests_status=$(echo "$status_block" | grep -oP 'TESTS_STATUS:\s*\K\S+' | head -1 || echo "NOT_RUN")
        work_type=$(echo "$status_block" | grep -oP 'WORK_TYPE:\s*\K\S+' | head -1 || echo "UNKNOWN")
        pressure_level=$(echo "$status_block" | grep -oP 'PRESSURE_LEVEL:\s*\K\S+' | head -1 || echo "L0")
        tried_count=$(echo "$status_block" | grep -oP 'TRIED_COUNT:\s*\K\d+' | head -1 || echo "0")

        # Extract recommendation summary for next loop context
        local recommendation
        recommendation=$(echo "$status_block" | grep -oP 'CURRENT_APPROACH:\s*\K.*' | head -1 || echo "")
        local result_text
        result_text=$(echo "$status_block" | grep -oP 'RESULT:\s*\K.*' | head -1 || echo "")
        echo "${recommendation}: ${result_text}" > "$LOG_DIR/last_summary.txt"
    fi

    # Build result JSON
    json_build \
        status "$status" \
        exit_signal "$exit_signal" \
        files_modified "$files_modified" \
        tasks_completed "$tasks_completed" \
        tests_status "$tests_status" \
        work_type "$work_type" \
        pressure_level "$pressure_level" \
        tried_count "$tried_count"
}

# ============================================================
# Progress Detection
# ============================================================

detect_progress() {
    local parse_result="$1"
    local has_progress=false

    # Check git changes (excluding .ralph-boost/)
    local git_changes=0
    if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git_changes=$(git status --porcelain | grep -v "^.. .ralph-boost/" | wc -l || echo 0)
    fi

    if [[ $git_changes -gt 0 ]]; then
        has_progress=true
    fi

    # Check FILES_MODIFIED from status report
    local files_modified
    files_modified=$(echo "$parse_result" | json_get_str ".files_modified" "0")
    if [[ $files_modified -gt 0 ]]; then
        has_progress=true
    fi

    # Check explicit completion
    local status
    status=$(echo "$parse_result" | json_get_str ".status" "UNKNOWN")
    if [[ "$status" == "COMPLETE" ]]; then
        has_progress=true
    fi

    # Check tasks completed
    local tasks_completed
    tasks_completed=$(echo "$parse_result" | json_get_str ".tasks_completed" "0")
    if [[ $tasks_completed -gt 0 ]]; then
        has_progress=true
    fi

    echo "$has_progress"
}

detect_same_error() {
    local output_file="$1"
    local last_error_file="$LOG_DIR/last_error.txt"

    # Extract error patterns from output
    local current_errors
    current_errors=$(grep -iE "(error|failed|exception|traceback)" "$output_file" | head -5 | sort -u || true)

    if [[ -f "$last_error_file" ]] && [[ -n "$current_errors" ]]; then
        local last_errors
        last_errors=$(cat "$last_error_file")
        if [[ "$current_errors" == "$last_errors" ]]; then
            echo "true"
            return
        fi
    fi

    [[ -n "$current_errors" ]] && echo "$current_errors" > "$last_error_file"
    echo "false"
}

# ============================================================
# Circuit Breaker (Native L0-L4)
# ============================================================

update_circuit_breaker() {
    local state="$1" has_progress="$2" is_same_error="$3"
    local new_state="$state"

    local cb_state
    cb_state=$(get_field "$state" ".circuit_breaker.state")
    local consecutive_no_progress
    consecutive_no_progress=$(get_field_int "$state" ".circuit_breaker.consecutive_no_progress")
    local consecutive_same_error
    consecutive_same_error=$(get_field_int "$state" ".circuit_breaker.consecutive_same_error")
    local loop_count
    loop_count=$(get_field_int "$state" ".session.loop_count")

    if [[ "$has_progress" == "true" ]]; then
        # Progress detected — reset everything
        new_state=$(echo "$new_state" | json_set_field ".circuit_breaker.state" '"CLOSED"' \
            | json_set_field ".circuit_breaker.consecutive_no_progress" '0' \
            | json_set_field ".circuit_breaker.consecutive_same_error" '0' \
            | json_set_field ".circuit_breaker.last_progress_loop" "$loop_count" \
            | json_set_field ".circuit_breaker.reason" '"Progress detected"' \
            | json_set_field ".pressure.level" '0')
        log "Circuit breaker: CLOSED (progress detected)"
    else
        # No progress
        consecutive_no_progress=$((consecutive_no_progress + 1))
        local pressure
        pressure=$(calculate_pressure "$consecutive_no_progress")

        # Same error tracking
        if [[ "$is_same_error" == "true" ]]; then
            consecutive_same_error=$((consecutive_same_error + 1))
        else
            consecutive_same_error=0
        fi

        # Determine circuit breaker state
        local new_cb_state="CLOSED"
        local reason=""

        if [[ $consecutive_same_error -ge $SAME_ERROR_THRESHOLD ]]; then
            new_cb_state="OPEN"
            reason="Same error repeated ${consecutive_same_error} times"
        elif [[ $consecutive_no_progress -ge $NO_PROGRESS_THRESHOLD ]]; then
            # Check if handoff is written before opening
            local handoff_written
            handoff_written=$(get_field "$state" ".pressure.handoff_written")
            if [[ "$handoff_written" == "true" ]]; then
                new_cb_state="OPEN"
                reason="No progress after ${consecutive_no_progress} loops, handoff complete"
            else
                # Force L4 — keep running until handoff is written
                new_cb_state="CLOSED"
                reason="L4 active, waiting for handoff report"
                pressure=4
            fi
        elif [[ $consecutive_no_progress -ge 2 ]]; then
            new_cb_state="HALF_OPEN"
            reason="Monitoring: ${consecutive_no_progress} loops without progress"
        fi

        new_state=$(echo "$new_state" | json_set_field ".circuit_breaker.state" "\"$new_cb_state\"" \
            | json_set_field ".circuit_breaker.consecutive_no_progress" "$consecutive_no_progress" \
            | json_set_field ".circuit_breaker.consecutive_same_error" "$consecutive_same_error" \
            | json_set_field ".circuit_breaker.reason" "\"$reason\"" \
            | json_set_field ".pressure.level" "$pressure")

        local pname
        pname=$(pressure_name "$pressure")
        log "Circuit breaker: ${new_cb_state} | ${pname} | ${reason}"
    fi

    echo "$new_state"
}

should_halt() {
    local state="$1"
    local cb_state
    cb_state=$(get_field "$state" ".circuit_breaker.state")
    [[ "$cb_state" == "OPEN" ]]
}

# ============================================================
# Rate Limiting
# ============================================================

check_rate_limit() {
    local state="$1"
    local call_count
    call_count=$(get_field_int "$state" ".rate_limit.call_count")
    local last_reset_hour
    last_reset_hour=$(get_field "$state" ".rate_limit.last_reset_hour")
    local current_hour
    current_hour=$(date -u +"%Y-%m-%dT%H")

    if [[ "$last_reset_hour" != "$current_hour" ]]; then
        # New hour — reset counter
        echo "$state" | json_set_field ".rate_limit.call_count" '0' \
            | json_set_field ".rate_limit.last_reset_hour" "\"$current_hour\""
        return
    fi

    if [[ $call_count -ge $MAX_CALLS_PER_HOUR ]]; then
        log "Rate limit reached ($call_count/$MAX_CALLS_PER_HOUR). Waiting for next hour..."
        local seconds_left
        seconds_left=$(( 3600 - $(date -u +%s) % 3600 ))
        sleep "$seconds_left"
        local new_hour
        new_hour=$(date -u +"%Y-%m-%dT%H")
        echo "$state" | json_set_field ".rate_limit.call_count" '0' \
            | json_set_field ".rate_limit.last_reset_hour" "\"$new_hour\""
        return
    fi

    echo "$state"
}

increment_call_count() {
    local state="$1"
    local cc
    cc=$(echo "$state" | json_get_str ".rate_limit.call_count" "0")
    cc=$((cc + 1))
    echo "$state" | json_set_field ".rate_limit.call_count" "$cc"
}

# ============================================================
# Session Management
# ============================================================

get_session_id() {
    local state="$1"
    local session_id
    session_id=$(get_field "$state" ".session.id")
    local created_at
    created_at=$(get_field "$state" ".session.created_at")

    # Check session expiry
    if [[ -n "$session_id" ]] && [[ -n "$created_at" ]]; then
        local created_epoch
        created_epoch=$(date -d "$created_at" +%s 2>/dev/null || echo 0)
        local now_epoch
        now_epoch=$(date -u +%s)
        local expiry_seconds=$((SESSION_EXPIRY_HOURS * 3600))

        if [[ $((now_epoch - created_epoch)) -gt $expiry_seconds ]]; then
            log "Session expired, creating new session"
            session_id=""
        fi
    fi

    echo "$session_id"
}

update_session() {
    local state="$1" output_file="$2"
    local new_session_id=""

    # Try to extract session ID from Claude output
    if [[ -f "$output_file" ]]; then
        new_session_id=$(json_extract_session_id "$output_file")
    fi

    local current_id
    current_id=$(get_field "$state" ".session.id")

    if [[ -n "$new_session_id" ]] && [[ "$new_session_id" != "$current_id" ]]; then
        local now_ts
        now_ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        state=$(echo "$state" | json_set_field ".session.id" "\"$new_session_id\"" \
            | json_set_field ".session.created_at" "\"$now_ts\"")
    fi

    # Increment loop count
    local lc
    lc=$(echo "$state" | json_get_str ".session.loop_count" "0")
    lc=$((lc + 1))
    state=$(echo "$state" | json_set_field ".session.loop_count" "$lc")

    echo "$state"
}

# ============================================================
# Exit Detection
# ============================================================

check_exit_signal() {
    local parse_result="$1"
    local exit_signal
    exit_signal=$(echo "$parse_result" | json_get_str ".exit_signal" "false")
    [[ "$exit_signal" == "true" ]]
}

# ============================================================
# Halt Display
# ============================================================

show_halt_message() {
    local state="$1"
    local reason
    reason=$(get_field "$state" ".circuit_breaker.reason")
    local total_opens
    total_opens=$(get_field_int "$state" ".circuit_breaker.total_opens")
    local loop_count
    loop_count=$(get_field_int "$state" ".session.loop_count")
    local pressure
    pressure=$(get_field_int "$state" ".pressure.level")

    echo ""
    echo "========================================"
    echo "  Ralph Boost — Loop Halted"
    echo "========================================"
    echo "  Loops completed:  $loop_count"
    echo "  Final pressure:   $(pressure_name "$pressure")"
    echo "  Reason:           $reason"
    echo "  Total opens:      $total_opens"
    echo ""

    if [[ -f "$HANDOFF_FILE" ]]; then
        echo "  Handoff report:   $HANDOFF_FILE"
    fi

    echo ""
    echo "  To review: cat $LOG_DIR/boost.log"
    echo "  To resume: bash $0"
    echo "========================================"
}

# ============================================================
# Signal Handling
# ============================================================

cleanup() {
    log "Received interrupt signal, saving state and exiting..."
    exit 0
}

trap cleanup SIGINT SIGTERM

# ============================================================
# Main Loop
# ============================================================

main() {
    # Parse arguments
    local project_dir="."
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --project-dir) project_dir="$2"; shift 2 ;;
            *) die "Unknown argument: $1" ;;
        esac
    done

    cd "$project_dir" || die "Cannot cd to $project_dir"
    mkdir -p "$LOG_DIR"

    log "Ralph Boost starting..."
    check_dependencies
    load_config
    log "Config loaded: max_calls=$MAX_CALLS_PER_HOUR, timeout=${CLAUDE_TIMEOUT_MINUTES}m, threshold=$NO_PROGRESS_THRESHOLD"

    while true; do
        local state
        state=$(read_state)

        # Rate limit check
        state=$(check_rate_limit "$state")

        # Halt check
        if should_halt "$state"; then
            local to
            to=$(echo "$state" | json_get_str ".circuit_breaker.total_opens" "0")
            to=$((to + 1))
            state=$(echo "$state" | json_set_field ".circuit_breaker.total_opens" "$to")
            write_state "$state"
            show_halt_message "$state"
            break
        fi

        # Build context and invoke Claude
        local session_id
        session_id=$(get_session_id "$state")
        local context
        context=$(build_loop_context "$state")
        local loop_count
        loop_count=$(get_field_int "$state" ".session.loop_count")

        log "=== Loop #$((loop_count + 1)) | $(pressure_name "$(get_field_int "$state" ".pressure.level")") ==="

        state=$(increment_call_count "$state")
        local output_file
        output_file=$(invoke_claude "$session_id" "$context")

        log "Claude output: $output_file"

        # Parse response
        local parse_result
        parse_result=$(parse_boost_status "$output_file")

        # Detect progress and errors
        local has_progress
        has_progress=$(detect_progress "$parse_result")
        local is_same_error
        is_same_error=$(detect_same_error "$output_file")

        # Update circuit breaker and pressure
        state=$(update_circuit_breaker "$state" "$has_progress" "$is_same_error")

        # Update session
        state=$(update_session "$state" "$output_file")

        # Update timestamp
        local now_ts
        now_ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        state=$(echo "$state" | json_set_field ".last_updated" "\"$now_ts\"")

        # Write state
        write_state "$state"

        # Check for exit signal
        if check_exit_signal "$parse_result"; then
            log "Exit signal received — task complete"
            show_halt_message "$state"
            break
        fi

        # Sleep between loops
        log "Sleeping ${SLEEP_SECONDS}s before next loop..."
        sleep "$SLEEP_SECONDS"
    done

    log "Ralph Boost stopped."
}

main "$@"
