# Hướng dẫn Sử dụng Skill Lint

> Bắt đầu trong 3 phút — xác thực chất lượng skill Claude Code của bạn

---

## Cài đặt

### Claude Code (khuyến nghị)

```bash
claude plugin add juserai/forge
```

### Cài đặt một dòng lệnh

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **Không phụ thuộc** — Skill Lint không yêu cầu dịch vụ bên ngoài hay API. Cài đặt và sử dụng ngay.

---

## Lệnh

| Lệnh | Chức năng | Khi nào sử dụng |
|------|----------|-----------------|
| `/skill-lint` | Hiển thị thông tin sử dụng | Xem các kiểm tra có sẵn |
| `/skill-lint .` | Kiểm tra dự án hiện tại | Tự kiểm tra trong quá trình phát triển |
| `/skill-lint /path/to/plugin` | Kiểm tra một đường dẫn cụ thể | Xem xét plugin khác |

---

## Trường hợp Sử dụng

### Tự kiểm tra sau khi tạo skill mới

Sau khi tạo `skills/<name>/SKILL.md`, `commands/<name>.md` và các tệp liên quan, chạy `/skill-lint .` để xác nhận cấu trúc hoàn chỉnh, frontmatter chính xác và mục marketplace đã được thêm.

### Xem xét plugin của người khác

Khi xem xét PR hoặc kiểm tra plugin khác, sử dụng `/skill-lint /path/to/plugin` để kiểm tra nhanh tính đầy đủ và nhất quán của tệp.

### Tích hợp CI

`scripts/skill-lint.sh` có thể chạy trực tiếp trong pipeline CI, xuất JSON để phân tích tự động:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Các Mục Kiểm tra

### Kiểm tra Cấu trúc (thực thi bởi script Bash)

| Quy tắc | Kiểm tra gì | Mức độ |
|---------|-------------|--------|
| S01 | `plugin.json` tồn tại ở cả thư mục gốc và `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` tồn tại | error |
| S03 | Mỗi `skills/<name>/` chứa một `SKILL.md` | error |
| S04 | Frontmatter SKILL.md bao gồm `name` và `description` | error |
| S05 | Mỗi skill có một `commands/<name>.md` tương ứng | warning |
| S06 | Mỗi skill được liệt kê trong mảng `plugins` của marketplace.json | warning |
| S07 | Các tệp tham chiếu được trích dẫn trong SKILL.md thực sự tồn tại | error |
| S08 | `evals/<name>/scenarios.md` tồn tại | warning |

### Kiểm tra Ngữ nghĩa (thực thi bởi AI)

| Quy tắc | Kiểm tra gì | Mức độ |
|---------|-------------|--------|
| M01 | Mô tả nêu rõ mục đích và điều kiện kích hoạt | warning |
| M02 | Tên khớp với tên thư mục; mô tả nhất quán giữa các tệp | warning |
| M03 | Logic định tuyến lệnh tham chiếu đúng tên skill | warning |
| M04 | Nội dung tham chiếu nhất quán logic với SKILL.md | warning |
| M05 | Kịch bản đánh giá bao phủ các đường dẫn chức năng cốt lõi (ít nhất 5) | warning |

---

## Ví dụ Đầu ra Dự kiến

### Tất cả kiểm tra đều đạt

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### Phát hiện vấn đề

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Quy trình Làm việc

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## Câu hỏi Thường gặp

### Tôi có thể chỉ chạy kiểm tra cấu trúc mà không cần kiểm tra ngữ nghĩa không?

Có — chạy script bash trực tiếp:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Lệnh này xuất JSON thuần túy không có phân tích ngữ nghĩa AI.

### Nó có hoạt động trên các dự án không phải forge không?

Có. Bất kỳ thư mục nào tuân theo cấu trúc plugin tiêu chuẩn của Claude Code (`skills/`, `commands/`, `.claude-plugin/`) đều có thể được xác thực.

### Sự khác biệt giữa lỗi và cảnh báo là gì?

- **error**: Vấn đề cấu trúc sẽ ngăn skill tải hoặc xuất bản đúng cách
- **warning**: Vấn đề chất lượng không ảnh hưởng đến chức năng nhưng tác động đến khả năng bảo trì và khám phá

### Các công cụ forge khác

Skill Lint là một phần của bộ sưu tập forge và hoạt động tốt cùng với các skill sau:

- [Block Break](block-break-guide.md) — Công cụ ràng buộc hành vi năng lực cao buộc AI phải khai thác mọi phương pháp
- [Ralph Boost](ralph-boost-guide.md) — Công cụ vòng lặp phát triển tự động với đảm bảo hội tụ Block Break tích hợp

Sau khi phát triển một skill mới, chạy `/skill-lint .` để xác minh tính đầy đủ cấu trúc và xác nhận rằng frontmatter, marketplace.json và các liên kết tham chiếu đều chính xác.

---

## Khi nào dùng / Khi nào KHÔNG dùng

### ✅ Dùng khi

- Validating a Claude Code plugin's structure before release
- Checking integrity hash / convention compliance / i18n coverage
- As a CI/CD gate for plugin repositories

### ❌ Không dùng khi

- Non-plugin projects (rules don't apply; you'll get irrelevant errors)
- Production code quality review (not a linter / type checker / security scanner)
- License legal review (only checks the `license` field exists)

> Structural CI cho Claude Code plugin — đảm bảo tuân thủ quy ước và đồng nhất hash, không đảm bảo hành vi runtime.

Phân tích phạm vi đầy đủ: [references/scope-boundaries.md](../../../skills/skill-lint/references/scope-boundaries.md)

---

## Giấy phép

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
