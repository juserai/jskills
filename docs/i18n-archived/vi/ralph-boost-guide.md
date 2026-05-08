# Hướng dẫn sử dụng Ralph Boost

> Bắt đầu trong 5 phút — giữ cho vòng lặp phát triển tự động AI của bạn không bị đình trệ

---

## Cài đặt

### Claude Code (khuyến nghị)

```bash
claude plugin add juserai/forge
```

### Cài đặt phổ quát một dòng

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **Không phụ thuộc** — Ralph Boost không phụ thuộc vào ralph-claude-code, block-break hoặc bất kỳ dịch vụ bên ngoài nào. Đường dẫn chính (vòng lặp Agent) không có phụ thuộc bên ngoài; đường dẫn dự phòng yêu cầu `jq` hoặc `python` và CLI `claude`.

---

## Lệnh

| Lệnh | Chức năng | Khi nào sử dụng |
|------|-----------|-----------------|
| `/ralph-boost setup` | Khởi tạo vòng lặp tự động trong dự án | Thiết lập lần đầu |
| `/ralph-boost run` | Bắt đầu vòng lặp tự động trong phiên hiện tại | Sau khi khởi tạo |
| `/ralph-boost status` | Xem trạng thái vòng lặp hiện tại | Theo dõi tiến trình |
| `/ralph-boost clean` | Xóa các tệp vòng lặp | Dọn dẹp |

---

## Bắt đầu nhanh

### 1. Khởi tạo dự án

```text
/ralph-boost setup
```

Claude sẽ hướng dẫn bạn qua:
- Phát hiện tên dự án
- Tạo danh sách công việc (fix_plan.md)
- Tạo thư mục `.ralph-boost/` và tất cả các tệp cấu hình

### 2. Bắt đầu vòng lặp

```text
/ralph-boost run
```

Claude điều khiển vòng lặp tự động trực tiếp trong phiên hiện tại (chế độ vòng lặp Agent). Mỗi lần lặp tạo ra một tác tử phụ để thực thi công việc, trong khi phiên chính đóng vai trò bộ điều khiển vòng lặp quản lý trạng thái.

**Dự phòng** (môi trường không giao diện / không giám sát):

```bash
# Tiền cảnh
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Nền
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Theo dõi trạng thái

```text
/ralph-boost status
```

Ví dụ đầu ra:

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## Cách hoạt động

### Vòng lặp tự động

Ralph Boost cung cấp hai đường dẫn thực thi:

**Đường dẫn chính (vòng lặp Agent)**: Claude đóng vai trò bộ điều khiển vòng lặp trong phiên hiện tại, tạo một tác tử phụ mỗi lần lặp để thực thi công việc. Phiên chính quản lý trạng thái, circuit breaker và leo thang áp lực. Không có phụ thuộc bên ngoài.

**Dự phòng (script bash)**: `boost-loop.sh` chạy các lệnh gọi `claude -p` trong vòng lặp ở nền. Hỗ trợ cả jq và python làm công cụ JSON, tự động phát hiện khi chạy. Thời gian chờ mặc định giữa các lần lặp là 1 giờ (có thể cấu hình).

Cả hai đường dẫn chia sẻ cùng quản lý trạng thái (state.json), logic leo thang áp lực và giao thức BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Circuit Breaker nâng cao (so với ralph-claude-code)

Circuit breaker của ralph-claude-code: bỏ cuộc sau 3 vòng lặp liên tiếp không có tiến triển.

Circuit breaker của ralph-boost: **leo thang áp lực dần dần** khi bị kẹt, tự phục hồi tới 6-7 vòng lặp trước khi dừng.

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## Ví dụ đầu ra mong đợi

### L0 — Thực thi bình thường

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — Chuyển đổi cách tiếp cận

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude bị buộc phải từ bỏ cách tiếp cận trước đó và thử điều gì đó **khác biệt về cơ bản**. Điều chỉnh tham số không được tính.

### L2 — Tìm kiếm và đặt giả thuyết

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude phải: đọc lỗi từng từ một → tìm kiếm hơn 50 dòng ngữ cảnh → liệt kê 3 giả thuyết khác nhau.

### L3 — Danh sách kiểm tra

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude phải hoàn thành danh sách kiểm tra 7 điểm (đọc tín hiệu lỗi, tìm vấn đề cốt lõi, đọc mã nguồn, xác minh giả định, giả thuyết ngược, tái tạo tối thiểu, chuyển đổi công cụ/phương pháp). Mỗi mục hoàn thành được ghi vào state.json.

### L4 — Bàn giao có trật tự

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude xây dựng một PoC tối thiểu, sau đó tạo báo cáo bàn giao:

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

Sau khi bàn giao hoàn tất, vòng lặp tắt một cách có trật tự. Đây không phải là "tôi không thể" — mà là "đây là ranh giới."

---

## Cấu hình

`.ralph-boost/config.json`:

| Trường | Mặc định | Mô tả |
|--------|----------|-------|
| `max_calls_per_hour` | 100 | Số lượng gọi API Claude tối đa mỗi giờ |
| `claude_timeout_minutes` | 15 | Thời gian chờ cho mỗi lần gọi |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Công cụ có sẵn cho Claude |
| `claude_model` | "" | Ghi đè model (trống = mặc định) |
| `session_expiry_hours` | 24 | Thời gian hết hạn phiên |
| `no_progress_threshold` | 7 | Ngưỡng không tiến triển trước khi tắt |
| `same_error_threshold` | 8 | Ngưỡng lỗi giống nhau trước khi tắt |
| `sleep_seconds` | 3600 | Thời gian chờ giữa các lần lặp (giây) |

### Các điều chỉnh cấu hình phổ biến

**Tăng tốc vòng lặp** (để kiểm thử):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Hạn chế quyền công cụ**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Sử dụng model cụ thể**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Cấu trúc thư mục dự án

```
.ralph-boost/
├── PROMPT.md           # Hướng dẫn phát triển (bao gồm giao thức block-break)
├── fix_plan.md         # Danh sách công việc (tự động cập nhật bởi Claude)
├── config.json         # Cấu hình
├── state.json          # Trạng thái hợp nhất (circuit breaker + áp lực + phiên)
├── handoff-report.md   # Báo cáo bàn giao L4 (tạo khi thoát có trật tự)
├── logs/
│   ├── boost.log       # Nhật ký vòng lặp
│   └── claude_output_*.log  # Đầu ra mỗi lần lặp
└── .gitignore          # Bỏ qua trạng thái và nhật ký
```

Tất cả tệp nằm trong `.ralph-boost/` — thư mục gốc dự án của bạn không bao giờ bị thay đổi.

---

## Mối quan hệ với ralph-claude-code

Ralph Boost là **sự thay thế độc lập** cho [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), không phải plugin nâng cao.

| Khía cạnh | ralph-claude-code | ralph-boost |
|-----------|-------------------|-------------|
| Hình thức | Công cụ Bash độc lập | Skill Claude Code (vòng lặp Agent) |
| Cài đặt | `npm install` | Plugin Claude Code |
| Kích thước mã | 2000+ dòng | ~400 dòng |
| Phụ thuộc bên ngoài | jq (bắt buộc) | Đường dẫn chính: không; Dự phòng: jq hoặc python |
| Thư mục | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Thụ động (bỏ cuộc sau 3 vòng lặp) | Chủ động (L0-L4, 6-7 vòng lặp tự phục hồi) |
| Cùng tồn tại | Có | Có (không xung đột tệp) |

Cả hai có thể được cài đặt đồng thời trong cùng một dự án — chúng sử dụng thư mục riêng biệt và không can thiệp lẫn nhau.

---

## Mối quan hệ với Block Break

Ralph Boost điều chỉnh các cơ chế cốt lõi của Block Break (leo thang áp lực, phương pháp 5 bước, danh sách kiểm tra) cho các kịch bản vòng lặp tự động:

| Khía cạnh | block-break | ralph-boost |
|-----------|-------------|-------------|
| Kịch bản | Phiên tương tác | Vòng lặp tự động |
| Kích hoạt | Hook tự động kích hoạt | Tích hợp trong vòng lặp Agent / script vòng lặp |
| Phát hiện | Hook PostToolUse | Phát hiện tiến trình vòng lặp Agent / phát hiện tiến trình script |
| Điều khiển | Prompt được hook chèn vào | Chèn prompt Agent / --append-system-prompt |
| Trạng thái | `~/.forge/` | `.ralph-boost/state.json` |

Mã nguồn hoàn toàn độc lập; các khái niệm được chia sẻ.

> **Tham khảo**: Leo thang áp lực (L0-L4), phương pháp 5 bước và danh sách kiểm tra 7 điểm của Block Break tạo nền tảng khái niệm cho circuit breaker của ralph-boost. Xem [Hướng dẫn sử dụng Block Break](block-break-guide.md) để biết chi tiết.

---

## Câu hỏi thường gặp

### Làm sao để chọn giữa đường dẫn chính và dự phòng?

`/ralph-boost run` sử dụng vòng lặp Agent (đường dẫn chính) theo mặc định, chạy trực tiếp trong phiên Claude Code hiện tại. Sử dụng script bash dự phòng khi bạn cần thực thi không giao diện hoặc không giám sát.

### Script vòng lặp nằm ở đâu?

Sau khi cài đặt plugin forge, script dự phòng nằm tại `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`. Bạn cũng có thể sao chép nó đến bất kỳ đâu và chạy từ đó. Script tự động phát hiện jq hoặc python làm công cụ JSON.

### Làm sao để xem nhật ký vòng lặp?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Làm sao để đặt lại mức áp lực thủ công?

Chỉnh sửa `.ralph-boost/state.json`: đặt `pressure.level` thành 0 và `circuit_breaker.consecutive_no_progress` thành 0. Hoặc đơn giản xóa state.json và khởi tạo lại.

### Làm sao để sửa danh sách công việc?

Chỉnh sửa `.ralph-boost/fix_plan.md` trực tiếp, sử dụng định dạng `- [ ] công việc`. Claude đọc nó ở đầu mỗi lần lặp.

### Làm sao để phục hồi sau khi circuit breaker mở?

Chỉnh sửa `state.json`, đặt `circuit_breaker.state` thành `"CLOSED"`, đặt lại các bộ đếm liên quan và chạy lại script.

### Tôi có cần ralph-claude-code không?

Không. Ralph Boost hoàn toàn độc lập và không phụ thuộc vào bất kỳ tệp Ralph nào.

### Những nền tảng nào được hỗ trợ?

Hiện tại hỗ trợ Claude Code (vòng lặp Agent làm đường dẫn chính). Script bash dự phòng yêu cầu bash 4+, jq hoặc python và CLI claude.

### Làm sao để xác thực các tệp skill của ralph-boost?

Sử dụng [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Khi nào dùng / Khi nào KHÔNG dùng

### ✅ Dùng khi

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ Không dùng khi

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> Động cơ vòng lặp tự động có đảm bảo hội tụ — cần mục tiêu rõ ràng và môi trường ổn định.

Phân tích phạm vi đầy đủ: [references/scope-boundaries.md](../../../skills/ralph-boost/references/scope-boundaries.md)

---

## Giấy phép

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
