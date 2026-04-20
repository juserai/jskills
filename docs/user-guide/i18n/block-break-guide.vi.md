# Block Break Hướng dẫn Sử dụng

> Bắt đầu trong 5 phút — buộc AI agent của bạn thử hết mọi cách tiếp cận

---

## Cài đặt

### Claude Code (khuyến nghị)

```bash
claude plugin add juserai/forge
```

### Cài đặt một dòng lệnh phổ quát

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **Không phụ thuộc** — Block Break không yêu cầu dịch vụ bên ngoài hay API. Cài đặt và bắt đầu ngay.

---

## Lệnh

| Lệnh | Chức năng | Khi nào sử dụng |
|------|-----------|-----------------|
| `/block-break` | Kích hoạt động cơ Block Break | Công việc hàng ngày, gỡ lỗi |
| `/block-break L2` | Bắt đầu từ mức áp lực cụ thể | Sau nhiều lần thất bại đã biết |
| `/block-break fix the bug` | Kích hoạt và chạy tác vụ ngay lập tức | Khởi động nhanh với tác vụ |

### Kích hoạt bằng ngôn ngữ tự nhiên (tự động phát hiện bởi hooks)

| Ngôn ngữ | Cụm từ kích hoạt |
|----------|------------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Trường hợp Sử dụng

### AI không sửa được bug sau 3 lần thử

Gõ `/block-break` hoặc nói `try harder` — tự động vào chế độ leo thang áp lực.

### AI nói "có lẽ là vấn đề môi trường" và dừng lại

Lằn ranh đỏ "Dựa trên sự thật" của Block Break buộc xác minh bằng công cụ. Quy kết chưa xác minh = đổ lỗi → kích hoạt L2.

### AI nói "tôi đề xuất bạn xử lý thủ công"

Kích hoạt chặn "Tư duy chủ sở hữu": nếu không phải bạn thì ai? Trực tiếp L3 Đánh giá Hiệu suất.

### AI nói "đã sửa" nhưng không có bằng chứng xác minh

Vi phạm lằn ranh đỏ "Vòng kín". Hoàn thành không có đầu ra = tự lừa mình → buộc lệnh xác minh có bằng chứng.

---

## Ví dụ Đầu ra Mong đợi

### `/block-break` — Kích hoạt

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 Thất vọng (lần thất bại thứ 2)

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 Thẩm vấn (lần thất bại thứ 3)

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 Đánh giá Hiệu suất (lần thất bại thứ 4)

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 Cảnh báo Tốt nghiệp (lần thất bại thứ 5+)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Thoát ra có Trật tự (hoàn thành cả 7 mục, vẫn chưa giải quyết)

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## Cơ chế Cốt lõi

### 3 Lằn ranh Đỏ

| Lằn ranh Đỏ | Quy tắc | Hậu quả Vi phạm |
|-------------|---------|-----------------|
| Vòng kín | Phải chạy lệnh xác minh và hiển thị đầu ra trước khi tuyên bố hoàn thành | Kích hoạt L2 |
| Dựa trên sự thật | Phải xác minh bằng công cụ trước khi quy kết nguyên nhân | Kích hoạt L2 |
| Thử hết tất cả | Phải hoàn thành phương pháp luận 5 bước trước khi nói "không thể giải quyết" | Trực tiếp L4 |

### Leo thang Áp lực (L0 → L4)

| Thất bại | Mức | Thanh bên | Hành động Bắt buộc |
|---------|-----|-----------|-------------------|
| Lần 1 | **L0 Tin tưởng** | > Chúng tôi tin bạn. Hãy đơn giản thôi. | Thực thi bình thường |
| Lần 2 | **L1 Thất vọng** | > Đội bên kia làm được ngay lần đầu. | Chuyển sang cách tiếp cận hoàn toàn khác |
| Lần 3 | **L2 Thẩm vấn** | > Nguyên nhân gốc rễ là gì? | Tìm kiếm + đọc mã nguồn + liệt kê 3 giả thuyết khác nhau |
| Lần 4 | **L3 Đánh giá Hiệu suất** | > Điểm: 3,25/5. | Hoàn thành danh sách kiểm tra 7 điểm |
| Lần 5+ | **L4 Tốt nghiệp** | > Bạn có thể sớm bị thay thế. | PoC tối thiểu + môi trường cô lập + ngăn xếp công nghệ khác |

### Phương pháp luận 5 Bước

1. **Đánh hơi** — Liệt kê các cách tiếp cận đã thử, tìm mẫu chung. Tinh chỉnh cùng cách tiếp cận = chạy vòng tròn
2. **Vò đầu bứt tóc** — Đọc tín hiệu lỗi từng từ một → tìm kiếm → đọc 50 dòng mã nguồn → xác minh giả định → đảo ngược giả định
3. **Soi gương** — Tôi có đang lặp lại cùng cách tiếp cận không? Tôi có bỏ sót khả năng đơn giản nhất không?
4. **Cách tiếp cận mới** — Phải khác biệt về bản chất, có tiêu chí xác minh, và tạo ra thông tin mới khi thất bại
5. **Nhìn lại** — Vấn đề tương tự, tính đầy đủ, phòng ngừa

> Bước 1-4 phải được hoàn thành trước khi hỏi người dùng. Làm trước, hỏi sau — nói bằng dữ liệu.

### Danh sách Kiểm tra 7 Điểm (bắt buộc từ L3)

1. Đã đọc tín hiệu lỗi từng từ một?
2. Đã tìm kiếm vấn đề cốt lõi bằng công cụ?
3. Đã đọc ngữ cảnh gốc tại điểm lỗi (50+ dòng)?
4. Tất cả giả định đã xác minh bằng công cụ (phiên bản/đường dẫn/quyền/phụ thuộc)?
5. Đã thử giả thuyết hoàn toàn ngược lại?
6. Có thể tái tạo trong phạm vi tối thiểu?
7. Đã đổi công cụ/phương pháp/góc nhìn/ngăn xếp công nghệ?

### Chống Hợp lý hóa

| Lý do | Chặn | Kích hoạt |
|-------|------|-----------|
| "Ngoài khả năng của tôi" | Bạn có lượng huấn luyện khổng lồ. Đã dùng hết chưa? | L1 |
| "Đề xuất người dùng xử lý thủ công" | Nếu không phải bạn thì ai? | L3 |
| "Đã thử mọi phương pháp" | Ít hơn 3 = chưa hết | L2 |
| "Có lẽ là vấn đề môi trường" | Bạn đã xác minh chưa? | L2 |
| "Cần thêm ngữ cảnh" | Bạn có công cụ. Tìm trước, hỏi sau | L2 |
| "Không thể giải quyết" | Bạn đã hoàn thành phương pháp luận chưa? | L4 |
| "Đủ tốt rồi" | Danh sách tối ưu hóa không thiên vị | L3 |
| Tuyên bố hoàn thành mà không xác minh | Bạn đã chạy build chưa? | L2 |
| Chờ chỉ dẫn từ người dùng | Chủ sở hữu không chờ bị đẩy | Nudge |
| Trả lời mà không giải quyết | Bạn là kỹ sư, không phải công cụ tìm kiếm | Nudge |
| Đổi mã mà không build/test | Giao hàng chưa test = làm qua loa | L2 |
| "API không hỗ trợ" | Bạn đã đọc tài liệu chưa? | L2 |
| "Tác vụ quá mơ hồ" | Đoán tốt nhất có thể, rồi lặp lại | L1 |
| Liên tục tinh chỉnh cùng một chỗ | Đổi tham số ≠ đổi cách tiếp cận | L1→L2 |

---

## Tự động hóa Hooks

Block Break sử dụng hệ thống hooks cho hành vi tự động — không cần kích hoạt thủ công:

| Hook | Kích hoạt | Hành vi |
|------|-----------|---------|
| `UserPromptSubmit` | Đầu vào người dùng khớp với từ khóa thất vọng | Tự động kích hoạt Block Break |
| `PostToolUse` | Sau khi thực thi lệnh Bash | Phát hiện thất bại, tự đếm + leo thang |
| `PreCompact` | Trước khi nén ngữ cảnh | Lưu trạng thái vào `~/.forge/` |
| `SessionStart` | Tiếp tục/khởi động lại phiên | Khôi phục mức áp lực (có hiệu lực 2 giờ) |

> **Trạng thái được duy trì** — Mức áp lực được lưu trong `~/.forge/block-break-state.json`. Nén ngữ cảnh và gián đoạn phiên không đặt lại bộ đếm thất bại. Không lối thoát.

### Thiết lập Hooks

Khi cài đặt qua `claude plugin add juserai/forge`, hooks được cấu hình tự động. Các script hook yêu cầu `jq` (ưu tiên) hoặc `python` làm công cụ JSON — ít nhất một phải có sẵn trên hệ thống của bạn.

Nếu hooks không kích hoạt, xác minh cấu hình:

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### Hết hạn trạng thái

Trạng thái tự hết hạn sau **2 giờ** không hoạt động. Điều này ngăn áp lực cũ từ phiên gỡ lỗi trước lan sang công việc không liên quan. Sau 2 giờ, hook khôi phục phiên âm thầm bỏ qua khôi phục và bạn bắt đầu lại từ L0.

Để đặt lại thủ công bất cứ lúc nào: `rm ~/.forge/block-break-state.json`

---

## Ràng buộc Sub-agent

Khi tạo sub-agent, các ràng buộc hành vi phải được tiêm vào để ngăn "chạy không bảo vệ":

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` đảm bảo sub-agent cũng tuân theo 3 lằn ranh đỏ, phương pháp luận 5 bước và xác minh vòng kín.

---

## Khắc phục Sự cố

| Vấn đề | Nguyên nhân | Cách sửa |
|--------|-------------|----------|
| Hooks không tự kích hoạt | Plugin chưa cài hoặc hooks không có trong settings.json | Chạy lại `claude plugin add juserai/forge` |
| Trạng thái không được duy trì | Cả `jq` và `python` đều không có | Cài một cái: `apt install jq` hoặc đảm bảo `python` có trong PATH |
| Áp lực bị kẹt ở L4 | File trạng thái tích lũy quá nhiều thất bại | Đặt lại: `rm ~/.forge/block-break-state.json` |
| Khôi phục phiên hiển thị trạng thái cũ | Trạng thái < 2 giờ từ phiên trước | Hành vi mong đợi; đợi 2 giờ hoặc đặt lại thủ công |
| `/block-break` không được nhận diện | Skill chưa được tải trong phiên hiện tại | Cài lại plugin hoặc dùng cài đặt một dòng lệnh phổ quát |

---

## FAQ

### Block Break khác PUA như thế nào?

Block Break lấy cảm hứng từ các cơ chế cốt lõi của [PUA](https://github.com/tanweai/pua) (3 lằn ranh đỏ, leo thang áp lực, phương pháp luận), nhưng tập trung hơn. PUA có 13 biến thể văn hóa doanh nghiệp, hệ thống đa vai trò (P7/P9/P10) và tự tiến hóa; Block Break tập trung thuần túy vào ràng buộc hành vi như một skill không phụ thuộc.

### Nó có quá ồn ào không?

Mật độ thanh bên được kiểm soát: 2 dòng cho tác vụ đơn giản (bắt đầu + kết thúc), 1 dòng mỗi mốc cho tác vụ phức tạp. Không spam. Đừng dùng `/block-break` nếu không cần — hooks chỉ tự kích hoạt khi phát hiện từ khóa thất vọng.

### Cách đặt lại mức áp lực?

Xóa file trạng thái: `rm ~/.forge/block-break-state.json`. Hoặc đợi 2 giờ — trạng thái tự hết hạn (xem [Hết hạn trạng thái](#hết-hạn-trạng-thái) ở trên).

### Có thể dùng ngoài Claude Code không?

SKILL.md cốt lõi có thể sao chép và dán vào bất kỳ công cụ AI nào hỗ trợ system prompt. Hooks và lưu trữ trạng thái là đặc thù của Claude Code.

### Mối quan hệ với Ralph Boost?

[Ralph Boost](ralph-boost-guide.md) chuyển thể các cơ chế cốt lõi của Block Break (L0-L4, phương pháp luận 5 bước, danh sách kiểm tra 7 điểm) cho kịch bản **vòng lặp tự trị**. Block Break dành cho phiên tương tác (hooks tự kích hoạt); Ralph Boost dành cho vòng lặp phát triển không giám sát (vòng lặp Agent / điều khiển bằng script). Mã hoàn toàn độc lập, khái niệm được chia sẻ.

### Cách xác minh file skill của Block Break?

Dùng [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Khi nào dùng / Khi nào KHÔNG dùng

### ✅ Dùng khi

- Claude gave up too easily ("I can't", rationalized impossibility)
- The same fix attempt has failed 2-3 times
- You need exhaustive diagnosis before accepting defeat

### ❌ Không dùng khi

- Doing creative / divergent work (pressure kills exploration)
- The task is genuinely impossible (missing hardware, no permissions)
- You want to pause and step back on purpose

> Động cơ debug cạn kiệt — đảm bảo Claude không bỏ cuộc sớm, nhưng không đảm bảo giải pháp đúng.

Phân tích phạm vi đầy đủ: [references/scope-boundaries.md](../../../skills/block-break/references/scope-boundaries.md)

---

## Giấy phép

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
