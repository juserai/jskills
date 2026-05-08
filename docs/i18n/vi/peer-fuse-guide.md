# Hướng dẫn Peer Fuse v0.1.0

> Trình peer-reviewer tổng quát cho các artifact nghiên cứu — **pipeline 8 giai đoạn (Stage 7 lưu trữ KB bắt buộc + quan sát được, opt-out qua `--no-save`) + adapter đầu vào 10 định dạng (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, dispatch 3 tầng) + 6 preset loại nghiên cứu (tự phân loại) + thước đo trọng số 8 chiều + phân loại 18 flag + panel 3 góc nhìn + đóng băng § Document Reading (ràng buộc cứng review-isolation)**.

Peer-Fuse nhận bất kỳ tài liệu markdown / PDF / Office nào và tạo ra báo cáo peer-review markdown với điểm A+/A−/.../D, danh sách phân tầng các flag chất lượng, tổng hợp panel đa góc nhìn, và gợi ý chỉnh sửa kiểu patch-style diff. Nó cùng tồn tại với [trình reviewer Stage 6.5 của insight-fuse](insight-fuse-guide.md) — Stage 6.5 là review nội bộ IF cùng nguồn; peer-fuse là **trình review ngoại sinh xuyên skill** xử lý các định dạng và skill mà Stage 6.5 không thể.

## Bắt đầu nhanh

```bash
# Tự phân loại type, depth mặc định, lưu trữ vào KB
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Bài báo học thuật PDF (type tự nhận từ header arXiv/IEEE/Nature)
/peer-fuse papers/transformer-2017.pdf

# Bộ slide PPTX với type chỉ định rõ
/peer-fuse decks/q4-roadmap.pptx --type product

# Depth nhanh (bỏ qua Stage 4 panel + Stage 5.5 holistic) + bỏ qua lưu trữ KB
/peer-fuse handbook.docx --depth quick --no-save

# Hiển thị help
/peer-fuse help
# hoặc không tham số
/peer-fuse
```

## Mặc định & flag

| Flag | Mặc định | Giá trị |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — bỏ qua Stage 7 lưu trữ KB, chỉ in ra console |

`--type=auto` cho phép peer-fuse phân loại sau khi đọc tài liệu qua heuristics (trường type trong frontmatter → mẫu section → mật độ trích dẫn → gợi ý format/title → fallback overview). Xem [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) để biết chuỗi ưu tiên.

## Định dạng được hỗ trợ

| Tier | Yêu cầu công cụ | Định dạng |
|:-:|---|---|
| 1 | không (native) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` cho `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Thiếu công cụ → fail-soft với gợi ý cài đặt cụ thể (`brew install pandoc`, `apt install libreoffice`, v.v.) và thoát trước Stage 1. Xem [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md).

## Bạn nhận lại được gì

Hai sản phẩm song song:

1. **Bản review render inline** trong cuộc hội thoại của bạn, được cấu trúc như sau:
   - § Document Reading — tường thuật mô tả (tài liệu nói gì), 3-5 đoạn, 300-600 từ
   - § Holistic Assessment — tường thuật đánh giá (phương pháp luận / điểm mạnh / mối lo ngại / khuyến nghị), 4 đoạn, 400-700 từ
   - § Score Matrix — điểm trọng số 8 chiều → letter grade
   - § Flag List — mã flag từ phân loại 18 mục với vị trí
   - § Multi-Perspective Panel — kết luận của methodologist / adversarial / practitioner
   - § Diff Suggestions — viết lại kiểu patch-style cho mỗi điểm trừ
   - § Reconciliation — Δ giữa self-grade mục tiêu và review_grade

2. **Lưu trữ KB** tại `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` (bỏ qua với `--no-save`). Dòng log lưu trữ `Archived to KB: <path>` luôn xuất hiện trong phản hồi user-visible.

## Ràng buộc cứng: § Document Reading được cô lập review

Quyết định kiến trúc quan trọng nhất trong peer-fuse:

**§ Document Reading không được phép bị nhiễm bởi các kết luận review.** Nó là sự đọc trung thực, mang tính mô tả của reviewer về tài liệu — frontmatter, cấu trúc, tuyên bố, bằng chứng, phạm vi. Nó chạy ở Stage 3.5, **trước** Stage 4 panel và Stage 5 chấm điểm, và ranh giới đầu vào nghiêm ngặt:

- ✅ Chấp nhận: tài liệu gốc, kết quả quét sự kiện Stage 1-3
- ❌ Từ chối: kết luận panel, điểm số, hit của flag

Section này được **đóng băng** sau Stage 3.5: hash SHA-256 được lấy trước Stage 4, và Stage 7 xác minh hash trước khi lưu trữ. Mọi sửa đổi → fail-closed. Lint cũng cấm từ vựng đánh giá (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) và letter-grade literal khỏi section này.

Đây là ràng buộc cứng do người dùng đặt ra và được thực thi ở ba cấp độ: cô lập kiến trúc + đóng băng write-once + lint từ cấm.

## Tương tác với các skill forge khác

| Skill | Quan hệ |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | Cùng tồn tại — Stage 6.5 là review nội bộ IF cùng nguồn (cùng rubric, cùng heuristics, chỉ markdown IF). peer-fuse là **review ngoại sinh xuyên skill** với rubric 8 chiều rộng hơn, 18 flag, 10 định dạng, panel 3 agent. Cả hai nên chạy cho các báo cáo IF quan trọng. |
| **council-fuse** | Crucible cùng cấp — peer-fuse tái sử dụng mẫu dispatch sub-agent song song của council-fuse (Stage 4 panel phản chiếu council-fuse Stage 1). |
| **tome-forge** | Backend lưu trữ — Stage 7 của peer-fuse gọi report-archival-protocol của tome-forge; không cài lại logic ghi KB. |
| **skill-lint** | Cùng pattern (khác phân loại, anvil) — cả hai đều phán xét artifact và phát chẩn đoán, nhưng skill-lint xuất chẩn đoán console phù du trong khi peer-fuse xuất artifact peer-review markdown bền vững. |

## Khi nào dùng peer-fuse vs IF Stage 6.5

| Tình huống | Dùng |
|---|:-:|
| Bạn vừa chạy `/insight-fuse <topic>` và muốn ý kiến thứ hai về báo cáo IF | IF Stage 6.5 đã chạy inline; nếu bạn muốn lớp review ngoại sinh thứ hai với khả năng sẵn sàng đa định dạng, chạy `/peer-fuse <if-output-path>` |
| Bạn có bài báo nghiên cứu PDF của bên thứ ba cần đánh giá | peer-fuse |
| Bạn có bộ slide kinh doanh PPTX muốn được chấm điểm | peer-fuse |
| Bạn có đầu ra tổng hợp council-fuse muốn được chấm điểm | peer-fuse |
| Bạn muốn so sánh nhiều artifact trên cùng rubric | peer-fuse (chấm điểm nhất quán xuyên artifact) |

## Ví dụ cụ thể

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 detection
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 produces § Document Reading (frozen)
# Stage 4 panel runs 3 sub-agents in parallel
# Stage 5 scoring → 8.6 / A-
# Stage 5.5 holistic assessment
# Stage 6 diff suggestions: 5 blocks
# Stage 7 archive

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

Console render đầy đủ bản review inline; lưu trữ KB là phiên bản chuẩn bền vững.

## Xác minh

```bash
# Kiểm tra tĩnh
bash skills/skill-lint/scripts/skill-lint.sh .

# Test trigger
bash evals/peer-fuse/run-trigger-test.sh

# Đồng bộ hash
bash scripts/recalc-all-hashes.sh
```

## Xem thêm

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — định nghĩa skill runtime
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — quyết định kiến trúc + lý do phân loại 4 nhóm
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (sau khi merge)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — crucible cùng cấp
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — crucible cùng cấp (nguồn của panel pattern)
