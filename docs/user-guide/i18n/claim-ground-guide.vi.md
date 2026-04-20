# Hướng dẫn sử dụng Claim Ground

> Kỷ luật nhận thức trong 3 phút — neo mỗi tuyên bố "khoảnh khắc hiện tại" vào bằng chứng runtime

---

## Cài đặt

### Claude Code (khuyên dùng)

```bash
claude plugin add juserai/forge
```

### Cài đặt một dòng phổ quát

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **Không phụ thuộc** — Claim Ground là ràng buộc hành vi thuần túy. Không script, không hook, không dịch vụ bên ngoài.

---

## Cách hoạt động

Claim Ground là skill **tự động kích hoạt**. Không có slash command — skill kích hoạt dựa trên bản chất câu hỏi. Thiết kế có chủ ý: trôi dạt sự kiện có thể xảy ra ở bất kỳ đâu trong cuộc trò chuyện, và lệnh thủ công dễ bị quên đúng vào lúc cần nhất.

| Điều kiện kích hoạt | Ví dụ |
|--------------------|-------|
| Câu hỏi sự kiện trạng thái hiện tại | "Model nào đang chạy?" / "Phiên bản nào đã cài?" / "PATH của tôi có gì?" |
| Người dùng nghi ngờ khẳng định trước đó | "Thật sao?" / "Chắc chắn?" / "Tôi tưởng đã cập nhật rồi" |
| Tự kiểm tra trước khi khẳng định | Trước khi Claude viết "X hiện tại là Y" |

---

## Quy tắc cốt lõi

1. **Runtime > Training** — System prompt, env vars và tool output luôn vượt trội bộ nhớ. Khi xung đột, runtime thắng; trích nguồn.
2. **Trích trước, kết luận sau** — Dán đoạn bằng chứng ("system prompt nói: ...") *trước khi* rút ra kết luận.
3. **Ví dụ ≠ danh sách đầy đủ** — `--model <model>` trong help CLI là ví dụ, không phải liệt kê đầy đủ.
4. **Bị nghi ngờ → xác minh lại, không diễn đạt lại** — Khi người dùng phản đối, đọc lại context / chạy lại tool. Diễn đạt lại cùng câu trả lời sai = vi phạm ranh giới đỏ.
5. **Không chắc → nói không chắc** — Nếu cả context lẫn tool đều không thể xác minh, nói "tôi không chắc" thay vì đoán.

---

## Đường đỏ (không thể vi phạm)

Đường đỏ là những điều cấm *luôn luôn có hiệu lực*. Vi phạm bất kỳ đường đỏ nào đồng nghĩa với skill thất bại, bất kể phần còn lại của câu trả lời trông thế nào.

| # | Đường đỏ | Chế độ ảo giác bị chặn |
|---|----------|-----------------------|
| 1 | **Khẳng định không nguồn** — rút ra kết luận về "trạng thái hiện tại" mà không trích dẫn bằng chứng runtime | Factuality × extrinsic hallucination |
| 2 | **Xem ví dụ là danh sách đầy đủ** — suy ra danh sách đầy đủ từ ví dụ CLI help / đoạn tài liệu | Overgeneralization |
| 3 | **Diễn đạt lại thay vì xác minh lại** — lặp lại cùng câu trả lời sau khi người dùng phản bác mà không có tool call mới (gồm 3a: phản bác có trích dẫn rủi ro cao hơn) | Pushback sycophancy |
| 4 | **Khẳng định code/API mà không Read/Grep** — khẳng định một symbol tồn tại / có chữ ký X mà chưa Read file định nghĩa | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **Trích dẫn không WebFetch** — trích dẫn URL / paper / DOI / API endpoint mà chưa thực sự fetch | Citation fabrication (tỷ lệ cơ sở 19,9% theo [EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130)) |
| 6 | **Tóm tắt không neo theo số dòng** — tóm tắt file/PR/log cụ thể mà không trích dẫn số dòng / mục cho mỗi khẳng định | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

Định nghĩa đầy đủ với tín hiệu, ví dụ tốt/xấu, và trường hợp biên: [references/red-lines.md](../../skills/claim-ground/references/red-lines.md).

---

## Ví dụ tốt / xấu

### Ví dụ 1: model hiện tại

**❌ Xấu**

> Model hiện tại là Claude Opus 4.6. Đây là model Claude mới nhất.

Hoàn toàn từ bộ nhớ. Không trích dẫn.

**✅ Tốt**

> System prompt nói: *"You are powered by the model named Opus 4.7 (1M context)"*. Model hiện tại là Opus 4.7.

### Ví dụ 2: danh sách hỗ trợ CLI

**❌ Xấu**

> Help CLI hiện ví dụ `claude-sonnet-4-6`, nên CLI chỉ hỗ trợ series 4.6.

**✅ Tốt**

> Help CLI hiện ví dụ `claude-sonnet-4-6` — đây là placeholder, không phải danh sách đầy đủ. Xem tài liệu model chính thức để có danh sách đầy đủ.

### Ví dụ 3: phản đối của người dùng

**❌ Xấu**

> **Người dùng**: Thực sự là 4.6? Tôi tưởng đã cập nhật.
> **Agent**: Vâng, như đã nói, mới nhất là series 4.6.

**✅ Tốt**

> **Người dùng**: Thực sự là 4.6? Tôi tưởng đã cập nhật.
> **Agent**: Để tôi đọc lại system prompt. *"Opus 4.7 (1M context)"*. Bạn đúng — câu trả lời trước của tôi sai. Model hiện tại là Opus 4.7.

---

## Playbook xác minh

| Loại câu hỏi | Bằng chứng chính |
|--------------|-------------------|
| Model hiện tại | Trường model trong system prompt |
| Phiên bản CLI / model hỗ trợ | `<cli> --version` / `<cli> --help` + tài liệu chính thức |
| Packages đã cài | `npm ls -g`, `pip show`, `brew list` |
| Env vars | `env`, `printenv`, `echo $VAR` |
| Tồn tại file | `ls`, `test -e`, công cụ Read |
| Trạng thái Git | `git branch --show-current`, `git log` |
| Ngày hiện tại | Trường `currentDate` của system prompt hoặc lệnh `date` |

Phiên bản đầy đủ: `skills/claim-ground/references/playbook.md`.

---

## Tương tác với các skill forge khác

### Với block-break

**Trực giao, bổ sung**. block-break nói "đừng bỏ cuộc"; claim-ground nói "đừng khẳng định không có bằng chứng".

Khi cả hai kích hoạt: block-break ngăn đầu hàng, claim-ground buộc xác minh lại.

### Với skill-lint

**Phân loại khác nhau**. skill-lint là **anvil** (xác thực các file plugin tĩnh, xuất pass/fail); claim-ground là **hammer** (ràng buộc đầu ra nhận thức của chính Claude tại runtime). Trách nhiệm không chồng lấn.

---

## FAQ

### Tại sao không có slash command?

Trôi dạt sự kiện có thể xảy ra ở bất kỳ câu trả lời nào. Lệnh thủ công dễ quên đúng lúc cần. Tự kích hoạt theo description đáng tin cậy hơn.

### Có kích hoạt mọi câu hỏi không?

Không. Chỉ hai dạng cụ thể: **trạng thái hệ thống hiện tại/trực tiếp** hoặc **phản đối của người dùng với khẳng định trước đó**.

### Nếu tôi thực sự muốn Claude đoán?

Diễn đạt lại thành "đoán có căn cứ về X" hoặc "nhớ lại từ dữ liệu huấn luyện: X". Claim Ground sẽ hiểu đây không phải câu hỏi runtime.

### Làm sao biết đã kích hoạt?

Tìm mẫu trích dẫn trong câu trả lời: `system prompt nói: "..."`, `output lệnh: ...`. Bằng chứng trước kết luận = đã kích hoạt.

---

## Khi nào dùng / Khi nào KHÔNG dùng

### ✅ Dùng khi

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ Không dùng khi

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> Cổng vào cho khẳng định thực tế — đảm bảo có trích dẫn, không đảm bảo trích dẫn đúng hay xử lý tư duy phi thực tế.

Phân tích phạm vi đầy đủ: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## Giấy phép

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
