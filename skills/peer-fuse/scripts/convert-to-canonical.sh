#!/usr/bin/env bash
# convert-to-canonical.sh — Stage 0.5 把任意支持格式转成 canonical_view (markdown)
# 用法: bash scripts/convert-to-canonical.sh <path>
# 输出: canonical markdown 到 stdout
# 退出码: 0 成功 / 1 转换失败 / 2 不支持的格式

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

tmpdir="$(mktemp -d -t peer-fuse-conv-XXXXXX)"
trap 'rm -rf "$tmpdir"' EXIT

case "$ext" in
  md|markdown|txt)
    cat "$path"
    ;;

  pdf)
    # PDF 转换交给 Claude Code Read tool 处理（带 pages 参数）
    # 此脚本只做 stdin/stdout pass-through 占位 — 实际 dispatch 由主线程
    echo "[[PDF DISPATCH: use Claude Code Read tool with pages param on $path]]"
    ;;

  docx|html|htm|rtf|odt)
    if ! command -v pandoc >/dev/null 2>&1; then
      echo "Error: pandoc required but not installed" >&2
      exit 1
    fi
    pandoc -f "$ext" -t markdown --wrap=none --extract-media="$tmpdir/media" "$path" 2>/dev/null \
      || { echo "Error: pandoc conversion failed for $path" >&2; exit 1; }
    ;;

  doc)
    # doc → docx via libreoffice → markdown via pandoc
    soffice_bin="$(command -v libreoffice 2>/dev/null || command -v soffice 2>/dev/null)"
    if [ -z "$soffice_bin" ]; then
      echo "Error: libreoffice/soffice required but not installed" >&2
      exit 1
    fi
    if ! command -v pandoc >/dev/null 2>&1; then
      echo "Error: pandoc required for doc → docx → markdown chain" >&2
      exit 1
    fi
    "$soffice_bin" --headless --convert-to docx --outdir "$tmpdir" "$path" >/dev/null 2>&1 \
      || { echo "Error: libreoffice doc→docx conversion failed" >&2; exit 1; }
    base="$(basename "$path" .doc)"
    intermediate="$tmpdir/${base}.docx"
    [ -f "$intermediate" ] || { echo "Error: intermediate $intermediate not produced" >&2; exit 1; }
    pandoc -f docx -t markdown --wrap=none --extract-media="$tmpdir/media" "$intermediate" 2>/dev/null \
      || { echo "Error: pandoc docx → markdown failed" >&2; exit 1; }
    ;;

  ppt|pptx|odp)
    # 演示文稿 → pdf via libreoffice，每幻灯片 = 1 page
    # 主线程随后用 Read tool 读 PDF，position marker 用 slide.<n> = p.<n>
    soffice_bin="$(command -v libreoffice 2>/dev/null || command -v soffice 2>/dev/null)"
    if [ -z "$soffice_bin" ]; then
      echo "Error: libreoffice/soffice required but not installed" >&2
      exit 1
    fi
    "$soffice_bin" --headless --convert-to pdf --outdir "$tmpdir" "$path" >/dev/null 2>&1 \
      || { echo "Error: libreoffice ${ext}→pdf conversion failed" >&2; exit 1; }
    base="$(basename "$path" ".$ext")"
    intermediate="$tmpdir/${base}.pdf"
    [ -f "$intermediate" ] || { echo "Error: intermediate PDF not produced" >&2; exit 1; }
    # 输出占位指向中转 PDF，主线程接管
    echo "[[SLIDESHOW DISPATCH: use Claude Code Read tool with pages param on $intermediate; position marker = slide.<n>]]"
    ;;

  *)
    echo "Error: unsupported format .$ext" >&2
    exit 2
    ;;
esac
