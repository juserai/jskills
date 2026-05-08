# Type Auto-Classifier

`--type=auto` 时 Stage 0.5 跑分类启发式。词汇表与判据对齐 [skills/insight-fuse/references/research-types.md](../../insight-fuse/references/research-types.md)。

## 6 预设词汇表

| type | 触发关键词（中英） |
|---|---|
| `overview` | 综述 / 全景 / 判别框架 / 怎么看 / overview / landscape |
| `technology` | 选型 / 架构对比 / 性能 / benchmark / migration / runtime cost |
| `market` | 市场规模 / 趋势 / 增长 / TAM / SAM / pricing / market sizing |
| `academic` | peer-reviewed / 方法学 / 学术 / hypothesis / methodology / abstract / methods / results / discussion |
| `product` | 产品机会 / user job / PMF / JTBD / persona / journey / GTM |
| `competitive` | 竞品 / SWOT / 定位 / 护城河 / moat / competitor / positioning matrix |

## 优先级链（高 → 低，命中即返回）

1. **Frontmatter `type` 字段直读**（仅 md / html）
   - canonical_view frontmatter 含 `type: <value>` 且 value ∈ 6 预设 → 直接采用
   - 含 `research_type:` 同等处理（兼容 IF 字段名）

2. **章节标题模式匹配**
   - 出现 `Abstract` + `Methods` + `Results` + `Discussion` ≥ 3 项 → `academic`
   - 出现 `Executive Summary` + `Findings` + `Recommendations` ≥ 2 项 → `overview`（默认）；若同时出现 `competitor` / `SWOT` → `competitive`
   - 出现 `JTBD` / `User Persona` / `Customer Journey` / `PMF` ≥ 1 项 → `product`
   - 出现 `Market Sizing` / `TAM` / `Pricing` / `Revenue Model` ≥ 2 项 → `market`
   - 出现 `Architecture Comparison` / `Benchmark` / `Migration Path` ≥ 1 项 → `technology`

3. **格式特征**
   - target_format = `pdf` 且首页含 arXiv / Nature / Science / IEEE / ACM / Springer 字样 → `academic`
   - target_format = `pdf` 且首页含咨询公司名（Gartner / McKinsey / IDC / Forrester）→ `market`
   - target_format ∈ {pptx, odp} → 倾向 `product` 或 `competitive`（看后续标题关键词二选一；都没有 → `competitive`）
   - target_format = `docx` 且无任何匹配 → 进 4

4. **标题关键词扫描**
   - 文件名 + 文档 H1（或 PDF 首页大标题 / PPTX 首页标题）按词汇表逐条匹配，命中第一个返回

5. **引用密度 + L1 比例**（细微调整）
   - L1 primary_source_ratio ≥ 0.6 → 偏 `academic`
   - 引用密度 < 1/page 且无 footnote → 偏 `product` / `overview`

6. **Fallback**: `overview`（最安全的通用型）

## 输出契约

```yaml
research_type: <one of 6 presets>
type_detection: auto    # 或 explicit（用户传了 --type=<具体值>）
classification_path: [<rule N>, <rule N+1>, ...]  # 调试用，记录命中链
```

`type_detection: explicit` 时跳过整个分类启发式，但仍记录 `classification_path: [user-explicit]`。

## 冲突处理

- 用户传 `--type=market` 但 frontmatter 写 `type: academic` → 用户显式优先（type_detection: explicit），但写入 `type_override: <user-value>` + `original_type: academic` 字段，便于审计

## 边界情况

- **空文件 / 不可读**：error 退出，不进入分类
- **canonical_view < 200 字**：仅靠规则 1 + 4，规则 2-3-5 跳过
- **多 type 同时命中**（如 academic + technology）：优先 academic（学术 rigor 最高，避免归错）
- **0 type 命中**：fallback `overview` + 标 `low-confidence-classification: true`
