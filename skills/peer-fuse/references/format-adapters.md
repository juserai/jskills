# Format Adapters

10 格式 × 3 tier 支持矩阵。Stage 0.5 dispatch。

## 支持矩阵

| 扩展名 | Tier | adapter | 命令 | 位置标记 | Frontmatter |
|---|:-:|---|---|---|:-:|
| `.md`, `.markdown` | 1 | pass-through | `cat` | `§<sec-slug>` / `L<line>` | 通常有 |
| `.txt` | 1 | pass-through | `cat` | `L<line>` | 无 |
| `.pdf` | 1 | Claude Code Read tool | `Read tool with pages param` | `p.<page>` | 无 |
| `.docx` | 2 | pandoc | `pandoc -f docx -t markdown <path>` | `§<heading-slug>` | 通常无 |
| `.html`, `.htm` | 2 | pandoc | `pandoc -f html -t markdown <path>` | `§<heading-slug>` | 偶有 |
| `.rtf` | 2 | pandoc | `pandoc -f rtf -t markdown <path>` | `L<line>` | 无 |
| `.odt` | 2 | pandoc | `pandoc -f odt -t markdown <path>` | `§<heading-slug>` | 无 |
| `.doc` | 3 | libreoffice | `libreoffice --headless --convert-to docx <path>` → 走 Tier 2 | `§<heading-slug>` | 无 |
| `.ppt`, `.pptx` | 3 | libreoffice | `libreoffice --headless --convert-to pdf <path>` → 走 Tier 1 PDF（每幻灯片 = 1 page）| `slide.<n>` | 无 |
| `.odp` | 3 | libreoffice | 同 ppt | `slide.<n>` | 无 |

## 工具检测（[scripts/detect-format-tools.sh](../scripts/detect-format-tools.sh)）

启动时跑，输出可用 tier 集合。失败 fallback：

```
✗ Format <ext> requires `<tool>` but it's not installed.
  Install:
    macOS:  brew install <tool>
    Ubuntu: apt install <tool>
    Windows: choco install <tool>
  Or convert manually to .md/.pdf/.txt and re-run.
```

立即 exit 1，**不进入 Stage 1**。

## Adapter 细则

### Tier 1 — md / txt / pdf

- **md / txt**：Read tool 直读 → canonical_view = source content。位置标记保留行号。
- **pdf**：Read tool 含 `pages` 参数。> 10 页时分批读；canonical_view 拼接每页文本（含 page 边界标记 `[[p.<n>]]`）。位置标记用 `p.<n>`。

### Tier 2 — pandoc

```bash
pandoc -f <fmt> -t markdown --wrap=none --extract-media=/tmp/peer-fuse-media-$$ <path>
```

`--wrap=none` 保持原有行布局；`--extract-media` 把图片导出避免 base64 噪声。位置标记从转换后 markdown 的 heading slug 提取。

### Tier 3 — libreoffice

中转格式策略：

- doc → docx（Tier 2 pandoc 接管）
- ppt / pptx / odp → pdf（Tier 1 PDF 接管，每幻灯片 = 1 page，标记 `slide.<n>` = `p.<n>`）

```bash
libreoffice --headless --convert-to <intermediate> --outdir /tmp/peer-fuse-conv-$$ <path>
```

转换失败（libreoffice exit ≠ 0）→ fail-soft 提示用户手工转换为 pdf 并重试。

## Stage 1 结构审差异

按 `target_format` 分支：

| target_format | frontmatter 检查 | 章节齐备 | source_refs 可达 |
|---|:-:|---|---|
| md / html | 必查（`research_type` / `topic` / `tags` 三段必有）| H1/H2/H3 hierarchy | 所有 markdown link / `<a href>` 可达（HTTP 200 或本地文件存在）|
| pdf | 跳过，标 `format_skip: frontmatter` | TOC（如有）+ Abstract / Methods / Results / Discussion / References（学术）or Exec Summary / Findings / Recommendations（行业）| 参考文献页存在；脚注 ID 配对 |
| docx / odt | 跳过 | heading hierarchy 无跳级 | hyperlinks + footnotes 配对 |
| pptx / odp | 跳过 | 首页（标题）+ 议程（如有）+ 参考页（如有）+ 末页齐备 | 超链接 + 参考页幻灯片存在 |
| txt / rtf | 跳过 | 仅检查文件非空 + 段落分隔 | — |

## 输出元数据（写入归档 frontmatter）

- `target_format`: 扩展名（去前导点，全小写）
- `adapter_tier`: 1 / 2 / 3
- `format_skip`: 列出本次 Stage 1 跳过的检查项（如 `[frontmatter]`）

## 错误模式

| 模式 | 处理 |
|---|---|
| 未知扩展名 | error + 提示支持列表，exit 1 |
| 工具缺失 | fail-soft 含 install hint，exit 1 |
| 转换失败 | fail-soft 提示手动转换，exit 1 |
| pdf 加密 | error 提示去密后重跑 |
| pdf > 100 页 | warn + 询问是否继续（Stage 0 user gate）|
