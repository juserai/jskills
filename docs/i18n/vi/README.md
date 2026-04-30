# Forge

> Làm việc chăm chỉ hơn, rồi nghỉ ngơi một chút. 8 skill giúp bạn có nhịp code tốt hơn với Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-8-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../../README.md) | [中文](../zh-CN/README.md) | [日本語](../ja/README.md) | [한국어](../ko/README.md) | [Español](../es/README.md) | [Português](../pt-BR/README.md) | [Français](../fr/README.md) | [Deutsch](../de/README.md) | [Русский](../ru/README.md) | [हिन्दी](../hi/README.md) | [Türkçe](../tr/README.md) | [Tiếng Việt](README.md)

### Demo nhanh

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## Cài đặt

```bash
# Claude Code (một lệnh duy nhất)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Các Skill

> Mỗi skill hỗ trợ `/<skill> help` (cả `--help`) để hiển thị thẻ hướng dẫn sử dụng. Các skill có đối số bắt buộc cũng hiển thị trợ giúp khi gọi không có đối số.

### Hammer

| Skill | Chức năng | Thử ngay |
|-------|-----------|----------|
| **block-break** | Buộc phải thử hết mọi cách trước khi bỏ cuộc | `/block-break` |
| **ralph-boost** | Vòng lặp phát triển tự động với đảm bảo hội tụ | `/ralph-boost setup` |
| **claim-ground** | Neo mỗi tuyên bố "khoảnh khắc hiện tại" vào bằng chứng runtime | tự kích hoạt |

### Crucible

| Skill | Chức năng | Thử ngay |
|-------|-----------|----------|
| **council-fuse** | Thảo luận đa góc nhìn để có câu trả lời tốt hơn | `/council-fuse <question>` |
| **insight-fuse** | Engine nghiên cứu 7 giai đoạn với hợp đồng dữ liệu skeleton.yaml & thước đo chất lượng 6 chiều | `/insight-fuse <topic>` |
| **tome-forge** | Cơ sở tri thức cá nhân với wiki biên soạn bởi LLM | `/tome-forge init` |

### Anvil

| Skill | Chức năng | Thử ngay |
|-------|-----------|----------|
| **skill-lint** | Kiểm tra tính hợp lệ của bất kỳ Claude Code skill plugin nào | `/skill-lint .` |

### Quench

| Skill | Chức năng | Thử ngay |
|-------|-----------|----------|
| **news-fetch** | Đọc tin nhanh giữa các phiên code | `/news-fetch AI today` |

---

## Block Break — Công cụ Ràng buộc Hành vi

AI của bạn bỏ cuộc rồi à? `/block-break` buộc nó phải thử hết mọi cách trước đã.

Khi Claude bị kẹt, Block Break kích hoạt hệ thống leo thang áp lực ngăn chặn việc đầu hàng sớm. Nó buộc agent đi qua các giai đoạn giải quyết vấn đề ngày càng nghiêm ngặt trước khi cho phép bất kỳ phản hồi "tôi không làm được" nào.

| Cơ chế | Mô tả |
|--------|-------|
| **3 Lằn ranh Đỏ** | Xác minh vòng kín / Dựa trên dữ kiện / Thử hết mọi phương án |
| **Leo thang Áp lực** | L0 Tin tưởng → L1 Thất vọng → L2 Chất vấn → L3 Đánh giá Hiệu suất → L4 Tốt nghiệp |
| **Phương pháp 5 Bước** | Đánh hơi → Vò đầu bứt tai → Soi gương → Cách tiếp cận mới → Nhìn lại |
| **Checklist 7 Điểm** | Checklist chẩn đoán bắt buộc ở L3+ |
| **Chống Hợp lý hóa** | Nhận diện và chặn 14 kiểu bào chữa phổ biến |
| **Hook** | Tự động phát hiện bế tắc + đếm lỗi + lưu trạng thái |

```text
/block-break              # Kích hoạt chế độ Block Break
/block-break L2           # Bắt đầu ở mức áp lực cụ thể
/block-break fix the bug  # Kích hoạt và bắt đầu ngay một task
```

Cũng được kích hoạt qua ngôn ngữ tự nhiên: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, v.v. (tự động phát hiện bởi hook).

> Lấy cảm hứng từ [PUA](https://github.com/tanweai/pua), tinh gọn thành một skill không phụ thuộc.

## Ralph Boost — Công cụ Vòng lặp Phát triển Tự động

Vòng lặp phát triển tự động thực sự hội tụ. Thiết lập trong 30 giây.

Tái tạo khả năng vòng lặp tự động của ralph-claude-code dưới dạng skill, tích hợp sẵn leo thang áp lực Block Break L0-L4 để đảm bảo hội tụ. Giải quyết vấn đề "quay vòng không tiến triển" trong các vòng lặp tự động.

| Tính năng | Mô tả |
|-----------|-------|
| **Vòng lặp Hai Đường** | Vòng lặp agent (chính, không phụ thuộc bên ngoài) + bash script dự phòng (jq/python engine) |
| **Circuit Breaker Nâng cao** | Tích hợp leo thang áp lực L0-L4: từ "bỏ cuộc sau 3 vòng" lên "6-7 vòng tự cứu lũy tiến" |
| **Theo dõi Trạng thái** | state.json hợp nhất cho circuit breaker + áp lực + chiến lược + phiên |
| **Bàn giao Mượt mà** | L4 tạo báo cáo bàn giao có cấu trúc thay vì crash thô |
| **Độc lập** | Sử dụng thư mục `.ralph-boost/`, không phụ thuộc ralph-claude-code |

```text
/ralph-boost setup        # Khởi tạo dự án
/ralph-boost run          # Bắt đầu vòng lặp tự động
/ralph-boost status       # Kiểm tra trạng thái hiện tại
/ralph-boost clean        # Dọn dẹp
```

> Lấy cảm hứng từ [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), tái thiết kế thành skill không phụ thuộc với đảm bảo hội tụ.

## Claim Ground — Công cụ Ràng buộc Nhận thức

Ngừng ảo giác các sự kiện lỗi thời. `claim-ground` neo mỗi tuyên bố "khoảnh khắc hiện tại" vào bằng chứng runtime.

Tự động kích hoạt (không có slash command). Khi Claude sắp trả lời các câu hỏi sự kiện về trạng thái hiện tại — model đang chạy, công cụ đã cài, env vars, giá trị cấu hình — hoặc khi người dùng phản đối một khẳng định trước đó, Claim Ground buộc trích dẫn system prompt / output của tool / nội dung file **trước khi** rút ra kết luận. Khi bị phản đối, Claude xác minh lại thay vì diễn đạt lại.

| Cơ chế | Mô tả |
|--------|-------|
| **3 Ranh giới Đỏ** | Không khẳng định không nguồn / Không coi ví dụ là danh sách đầy đủ / Không phản hồi phản đối bằng diễn đạt lại |
| **Runtime > Training** | System prompt, env và output tool luôn vượt trội bộ nhớ huấn luyện |
| **Trích trước-kết luận sau** | Đoạn bằng chứng thô được trích dẫn inline trước mọi kết luận |
| **Playbook Xác minh** | Loại câu hỏi → nguồn bằng chứng (model / CLI / packages / env / files / git / ngày) |

Ví dụ kích hoạt (tự động phát hiện qua description):

- "Model nào đang chạy?" / "What model is running?"
- "Phiên bản nào của X đã cài?"
- "Thật sao? / Chắc chứ? / Tôi tưởng đã cập nhật rồi"

Hoạt động trực giao với block-break: khi cả hai kích hoạt, block-break ngăn "tôi bỏ cuộc", claim-ground ngăn "tôi chỉ diễn đạt lại câu trả lời sai".

## Council Fuse — Công cụ Thảo luận Đa Góc nhìn

Câu trả lời tốt hơn thông qua tranh luận có cấu trúc. `/council-fuse` tạo 3 góc nhìn độc lập, đánh giá ẩn danh và tổng hợp câu trả lời tốt nhất.

Lấy cảm hứng từ [LLM Council của Karpathy](https://github.com/karpathy/llm-council) — cô đọng trong một lệnh duy nhất.

| Cơ chế | Mô tả |
|--------|-------|
| **3 Góc nhìn** | Generalist (cân bằng) / Critic (phản biện) / Specialist (kỹ thuật chuyên sâu) |
| **Đánh giá Ẩn danh** | Đánh giá 4 chiều: Chính xác, Đầy đủ, Thực tiễn, Rõ ràng |
| **Tổng hợp** | Câu trả lời điểm cao nhất làm khung, bổ sung những hiểu biết độc đáo |
| **Ý kiến Thiểu số** | Phản đối hợp lý được giữ lại, không bị đè nén |

```text
/council-fuse Có nên dùng microservices không?
/council-fuse Xem lại pattern xử lý lỗi này
/council-fuse Redis vs PostgreSQL cho hàng đợi công việc
```

## Insight Fuse — Engine Nghiên Cứu Đa Nguồn Có Hệ Thống (v3)

Từ chủ đề đến báo cáo nghiên cứu chuyên nghiệp. `/insight-fuse` chạy pipeline 7 giai đoạn với `skeleton.yaml` làm hợp đồng dữ liệu: brainstorm → scan → align → research → review → deep dive → QA.

Phân tích đa góc nhìn tích hợp sẵn, 6 preset loại nghiên cứu (overview / technology / market / academic / product / competitive), 5 định dạng đầu ra (report / checklist / ADR / decision-tree / PoC), và thước đo chất lượng 6 chiều với 14 kiểm tra chặn. Skill anh em fuse-series của council-fuse — trong khi council-fuse thảo luận thông tin đã biết, insight-fuse chủ động thu thập và tổng hợp thông tin mới.

| Cơ chế | Mô tả |
|--------|-------|
| **Pipeline 7 giai đoạn** | Brainstorm (khung) → Scan → Align → Research → Review → Deep Dive → QA |
| **Loại nghiên cứu** | overview / technology / market / academic / product / competitive — gói preset (template + góc nhìn + kiểm tra đặc thù) |
| **Độ sâu cấu hình được** | quick / standard / deep / full — quick bỏ qua Stage 2-5; full chạy toàn bộ 7 giai đoạn với cổng tương tác |
| **Skeleton.yaml** | Hợp đồng dữ liệu 7 trường (dimensions / taxonomies / out_of_scope / existing_consensus / known_dissensus / hypotheses / business_neutral) được mỗi stage tiêu thụ |
| **Thước đo chất lượng** | Điểm 6 chiều (khả năng phản chứng / mật độ bằng chứng / khả năng tái lập / đa dạng nguồn / khả năng hành động / minh bạch) + 14 kiểm tra chặn + hạng A/B/C/D |
| **Đa phần** | report / checklist / ADR / decision-tree / PoC — `--sections` chọn các phần; mặc định mỗi phần được render thành tệp `.md` riêng, `--merge` gộp tất cả thành một |

```text
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling" --type technology --sections report,adr,poc
/insight-fuse "Kubernetes autoscaling" --type technology --sections report,adr,poc --merge
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI Native landscape" --type overview --depth full --audience "new entrants"
```

## Tome Forge — Công cụ Cơ sở Tri thức Cá nhân

Tạo cơ sở tri thức cá nhân được LLM biên soạn và duy trì. Dựa trên [mẫu LLM Wiki của Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — biên dịch Markdown thô thành wiki có cấu trúc, không RAG hay vector DB.

| Tính năng | Mô tả |
|-----------|-------|
| **Kiến trúc Ba Tầng** | Nguồn thô (bất biến) / Wiki (LLM biên soạn) / Schema (CLAUDE.md) |
| **6 Thao tác** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | Phần thiêng liêng dành cho hiểu biết của con người — LLM không bao giờ ghi đè |
| **Zero Infra** | Markdown thuần + Git. Không database, embedding hay server |

```text
/tome-forge init              # Khởi tạo KB trong thư mục hiện tại
/tome-forge capture "idea"    # Ghi chú nhanh
/tome-forge ingest raw/paper  # Biên soạn tài liệu thô thành wiki
/tome-forge query "question"  # Tìm kiếm và tổng hợp
/tome-forge lint              # Kiểm tra sức khỏe cấu trúc wiki
/tome-forge compile           # Biên soạn hàng loạt tất cả tài liệu mới
```

> Lấy cảm hứng từ [LLM Wiki của Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), xây dựng thành skill không phụ thuộc.

## Skill Lint — Công cụ Kiểm tra Skill Plugin

Kiểm tra Claude Code plugin của bạn chỉ với một lệnh.

Kiểm tra tính toàn vẹn cấu trúc và chất lượng ngữ nghĩa của các file skill trong bất kỳ dự án Claude Code plugin nào. Bash script xử lý kiểm tra cấu trúc, AI xử lý kiểm tra ngữ nghĩa — bổ trợ lẫn nhau.

| Loại kiểm tra | Mô tả |
|---------------|-------|
| **Cấu trúc** | Các trường bắt buộc trong frontmatter / sự tồn tại file / liên kết tham chiếu / mục marketplace |
| **Ngữ nghĩa** | Chất lượng mô tả / tính nhất quán tên / định tuyến lệnh / phạm vi eval |

```text
/skill-lint              # Hiển thị hướng dẫn sử dụng
/skill-lint .            # Kiểm tra dự án hiện tại
/skill-lint /path/to/plugin  # Kiểm tra một đường dẫn cụ thể
```

## News Fetch — Giải lao Tinh thần Giữa các Sprint

Kiệt sức vì debug? `/news-fetch` — 2 phút giải lao tinh thần cho bạn.

Các skill khác đẩy bạn làm việc chăm chỉ hơn. Skill này nhắc bạn hít thở. Lấy tin tức mới nhất về bất kỳ chủ đề nào, ngay từ terminal — không cần chuyển ngữ cảnh, không lạc vào hố thỏ trình duyệt. Lướt nhanh rồi quay lại công việc, tinh thần sảng khoái.

| Tính năng | Mô tả |
|-----------|-------|
| **Dự phòng 3 Tầng** | L1 WebSearch → L2 WebFetch (nguồn khu vực) → L3 curl |
| **Loại trùng & Gộp** | Cùng sự kiện từ nhiều nguồn tự động gộp, giữ bản điểm cao nhất |
| **Chấm điểm Liên quan** | AI chấm điểm và sắp xếp theo độ phù hợp chủ đề |
| **Tóm tắt Tự động** | Tóm tắt thiếu được tự động tạo từ nội dung bài viết |

```text
/news-fetch AI                    # Tin AI tuần này
/news-fetch AI today              # Tin AI hôm nay
/news-fetch robotics month        # Tin robotics tháng này
/news-fetch climate 2026-03-01~2026-03-31  # Khoảng thời gian tùy chọn
```

## Chất lượng

- 10+ kịch bản đánh giá mỗi skill với kiểm tra kích hoạt tự động
- Tự kiểm tra bằng chính skill-lint của mình
- Không phụ thuộc bên ngoài — không rủi ro
- Giấy phép MIT, mã nguồn mở hoàn toàn

## Cấu trúc Dự án

```text
forge/
├── skills/                        # Nền tảng Claude Code
│   └── <skill>/
│       ├── SKILL.md               # Định nghĩa skill
│       ├── references/            # Nội dung chi tiết (tải khi cần)
│       ├── scripts/               # Script hỗ trợ
│       ├── agents/                # Định nghĩa sub-agent
│       └── hooks/                 # Hook Claude Code theo skill (chỉ hook-owner skill)
├── platforms/                     # Thích ứng nền tảng khác
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # Phiên bản OpenClaw
│           ├── references/        # Nội dung riêng nền tảng
│           └── scripts/           # Script riêng nền tảng
├── .claude-plugin/                # Metadata marketplace Claude Code
├── evals/                         # Kịch bản đánh giá đa nền tảng
├── docs/
│   ├── user-guide/                # Hướng dẫn sử dụng (tiếng Anh)
│   ├── dev-guide/                 # Tài liệu cho lập trình viên
│   ├── design/<category>/         # Tài liệu thiết kế theo 4 phân loại
│   └── i18n/<lang>/               # Bản dịch (README + hướng dẫn skill)
├── openspec/                      # Meta-repo tiến hóa
│   ├── specs/<capability>/        # Hợp đồng năng lực ngang
│   └── changes/<id>/              # RFC đang xử lý (đã hoàn thành ở archive/)
└── plugin.json                    # Metadata bộ sưu tập
```

## Đóng góp

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — Phiên bản OpenClaw + references/scripts (xem [platform-parity](../../../openspec/specs/platform-parity/spec.md) cho hợp đồng broadcast)
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Kịch bản đánh giá
4. `.claude-plugin/marketplace.json` — Thêm mục vào mảng `plugins`
5. Hook nếu cần: tạo `skills/<name>/hooks/hooks.json` + scripts; `source` trong marketplace.json phải trỏ đến `./skills/<name>`

Xem [CLAUDE.md](../../../CLAUDE.md) để biết đầy đủ hướng dẫn phát triển.

## Giấy phép

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
