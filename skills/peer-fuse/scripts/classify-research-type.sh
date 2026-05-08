#!/usr/bin/env bash
# classify-research-type.sh — Stage 0.5 type auto-classifier
# 用法: bash scripts/classify-research-type.sh <canonical-view-path>
# 输出: research_type=<value> + classification_path=<rule chain>
# 启发式优先级链与 references/type-classifier.md 一致

set -uo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <canonical-view-path>" >&2
  exit 2
fi

cv="$1"

if [ ! -f "$cv" ]; then
  echo "Error: canonical view file not found: $cv" >&2
  exit 2
fi

declare -a path=()
result=""

# Rule 1 — frontmatter type 字段直读
if head -30 "$cv" | grep -qE "^(research_type|type):\s*"; then
  ft=$(head -30 "$cv" | grep -E "^(research_type|type):\s*" | head -1 | sed -E 's/^(research_type|type):\s*([a-z]+).*/\2/' | tr -d '"')
  case "$ft" in
    overview|technology|market|academic|product|competitive)
      result="$ft"
      path=("rule-1-frontmatter-type-field")
      ;;
  esac
fi

# Rule 2 — 章节标题模式匹配
if [ -z "$result" ]; then
  body="$(cat "$cv")"
  acad_count=0
  for term in "Abstract" "Methods" "Methodology" "Results" "Discussion" "Limitations"; do
    grep -qiE "^#+\s*${term}\b" "$cv" && acad_count=$((acad_count + 1))
  done
  if [ "$acad_count" -ge 3 ]; then
    result="academic"
    path=("rule-2-academic-section-pattern")
  fi
fi

if [ -z "$result" ]; then
  if grep -qiE "^#+\s*(JTBD|User Persona|Customer Journey|PMF|Product[- ]Market Fit)\b" "$cv"; then
    result="product"
    path=("rule-2-product-section-pattern")
  fi
fi

if [ -z "$result" ]; then
  market_count=0
  for term in "Market Sizing" "TAM" "Pricing" "Revenue Model" "Market Trend"; do
    grep -qiE "^#+\s*.*${term}\b" "$cv" && market_count=$((market_count + 1))
  done
  if [ "$market_count" -ge 2 ]; then
    result="market"
    path=("rule-2-market-section-pattern")
  fi
fi

if [ -z "$result" ]; then
  if grep -qiE "^#+\s*(SWOT|Competitor|Positioning Matrix|护城河|Moat)\b" "$cv"; then
    result="competitive"
    path=("rule-2-competitive-section-pattern")
  fi
fi

if [ -z "$result" ]; then
  tech_count=0
  for term in "Architecture Comparison" "Benchmark" "Migration Path" "选型" "性能对比"; do
    grep -qiE "^#+\s*.*${term}\b" "$cv" && tech_count=$((tech_count + 1))
  done
  if [ "$tech_count" -ge 1 ]; then
    result="technology"
    path=("rule-2-technology-section-pattern")
  fi
fi

# Rule 3 — 格式特征 (由主线程在 Stage 0.5 (a) 部分判断；脚本仅尝试通过文件名)
if [ -z "$result" ]; then
  basename_lower=$(basename "$cv" | tr '[:upper:]' '[:lower:]')
  case "$basename_lower" in
    *arxiv*|*nature*|*science*|*ieee*|*acm*|*springer*)
      result="academic"
      path=("rule-3-format-academic-publisher")
      ;;
  esac
fi

# Rule 4 — 标题关键词扫描 (取第一个 H1)
if [ -z "$result" ]; then
  h1=$(grep -m 1 "^# " "$cv" | sed 's/^# //' | tr '[:upper:]' '[:lower:]')
  if echo "$h1" | grep -qE "(综述|landscape|overview|全景|判别)"; then
    result="overview"; path=("rule-4-h1-overview")
  elif echo "$h1" | grep -qE "(选型|架构|benchmark|migration|technology|technical)"; then
    result="technology"; path=("rule-4-h1-technology")
  elif echo "$h1" | grep -qE "(market|市场|pricing|tam|增长)"; then
    result="market"; path=("rule-4-h1-market")
  elif echo "$h1" | grep -qE "(academic|学术|methodology|hypothesis|peer-review)"; then
    result="academic"; path=("rule-4-h1-academic")
  elif echo "$h1" | grep -qE "(product|jtbd|pmf|persona|gtm)"; then
    result="product"; path=("rule-4-h1-product")
  elif echo "$h1" | grep -qE "(competitor|swot|竞品|positioning|moat|护城河)"; then
    result="competitive"; path=("rule-4-h1-competitive")
  fi
fi

# Rule 6 — Fallback overview
if [ -z "$result" ]; then
  result="overview"
  path=("rule-6-fallback-overview")
fi

echo "research_type=$result"
echo "classification_path=$(IFS=,; echo "${path[*]}")"
