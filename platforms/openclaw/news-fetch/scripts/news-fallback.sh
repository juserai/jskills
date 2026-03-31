#!/usr/bin/env bash
# News Fetch L3 fallback — curl-based news fetching
# Used when WebSearch and WebFetch both fail
#
# Usage: news-fallback.sh <keyword>
# Output: HTML content from first successful source, or error JSON

set -euo pipefail

KEYWORD="${1:?Usage: news-fallback.sh <keyword>}"
ENCODED_KEYWORD=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$KEYWORD'))")
TIMEOUT=10

SOURCES=(
    "baidu|https://news.baidu.com/ns?word=${ENCODED_KEYWORD}&pn=0&cl=2&ct=0&tn=news&rn=10&ie=utf-8"
    "sina|https://search.sina.com.cn/?q=${ENCODED_KEYWORD}&c=news&range=all"
    "163|https://www.163.com/search?keyword=${ENCODED_KEYWORD}"
)

ERRORS=()

for source_entry in "${SOURCES[@]}"; do
    source_name="${source_entry%%|*}"
    source_url="${source_entry#*|}"

    result=$(curl -sL --max-time "$TIMEOUT" \
        -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
        -H "Accept: text/html,application/xhtml+xml" \
        -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8" \
        "$source_url" 2>&1) || true

    if [ -n "$result" ] && [ ${#result} -gt 500 ]; then
        # Check if it's a captcha/block page
        if echo "$result" | grep -qiE '验证码|captcha|access denied|forbidden'; then
            ERRORS+=("{\"source\": \"$source_name\", \"error\": \"blocked by captcha/access control\"}")
            continue
        fi

        # Success — output source name header + HTML content
        echo "<!-- source: $source_name -->"
        echo "$result"
        exit 0
    else
        ERRORS+=("{\"source\": \"$source_name\", \"error\": \"empty or too short response (${#result} bytes)\"}")
    fi
done

# All sources failed
printf '{"success": false, "errors": [%s]}\n' "$(IFS=,; echo "${ERRORS[*]}")"
exit 1
