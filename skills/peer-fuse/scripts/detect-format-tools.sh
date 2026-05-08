#!/usr/bin/env bash
# detect-format-tools.sh — Stage 0.5 工具检测
# 用法: bash scripts/detect-format-tools.sh <path>
# 退出码: 0 工具齐全 / 1 缺工具（已打印 install hint）/ 2 不支持的格式

set -uo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <path-to-artifact>" >&2
  exit 2
fi

path="$1"

if [ ! -f "$path" ]; then
  echo "Error: file not found: $path" >&2
  exit 2
fi

ext="${path##*.}"
ext="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"

# Tier 1 — native, no extra deps
case "$ext" in
  md|markdown|txt|pdf)
    echo "tier=1"
    echo "format=$ext"
    exit 0
    ;;
esac

# Tier 2 — pandoc
case "$ext" in
  docx|html|htm|rtf|odt)
    if ! command -v pandoc >/dev/null 2>&1; then
      cat >&2 <<EOF
✗ Format .${ext} requires \`pandoc\` but it's not installed.
  Install:
    macOS:  brew install pandoc
    Ubuntu: apt install pandoc
    Windows: choco install pandoc
  Or convert manually to .md/.pdf/.txt and re-run.
EOF
      exit 1
    fi
    echo "tier=2"
    echo "format=$ext"
    exit 0
    ;;
esac

# Tier 3 — libreoffice
case "$ext" in
  doc|ppt|pptx|odp)
    if ! command -v libreoffice >/dev/null 2>&1 && ! command -v soffice >/dev/null 2>&1; then
      cat >&2 <<EOF
✗ Format .${ext} requires \`libreoffice\` (or \`soffice\`) but it's not installed.
  Install:
    macOS:  brew install --cask libreoffice
    Ubuntu: apt install libreoffice
    Windows: choco install libreoffice-fresh
  Or convert manually to .pdf and re-run.
EOF
      exit 1
    fi
    # libreoffice + pandoc both needed for doc → docx → markdown
    if [ "$ext" = "doc" ] && ! command -v pandoc >/dev/null 2>&1; then
      cat >&2 <<EOF
✗ Format .doc requires both \`libreoffice\` and \`pandoc\` (doc → docx → markdown).
  Install pandoc:
    macOS:  brew install pandoc
    Ubuntu: apt install pandoc
EOF
      exit 1
    fi
    echo "tier=3"
    echo "format=$ext"
    exit 0
    ;;
esac

# Unknown
cat >&2 <<EOF
✗ Unsupported format: .${ext}
  Supported (Tier 1 native):     .md, .markdown, .txt, .pdf
  Supported (Tier 2 pandoc):     .docx, .html, .htm, .rtf, .odt
  Supported (Tier 3 libreoffice): .doc, .ppt, .pptx, .odp
  Convert to one of the above and re-run.
EOF
exit 2
