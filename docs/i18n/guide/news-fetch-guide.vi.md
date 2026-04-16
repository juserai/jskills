# Hướng dẫn sử dụng News Fetch

> Bắt đầu trong 3 phút — để AI lấy bản tin tóm tắt cho bạn

Kiệt sức vì debug? Dành 2 phút, cập nhật những gì đang xảy ra trên thế giới, và quay lại tràn đầy năng lượng.

---

## Cài đặt

### Claude Code (khuyến nghị)

```bash
claude plugin add juserai/forge
```

### Cài đặt một dòng phổ quát

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **Không phụ thuộc** — News Fetch không yêu cầu dịch vụ bên ngoài hay khóa API. Cài đặt và bắt đầu ngay.

---

## Lệnh

| Lệnh | Chức năng | Khi nào sử dụng |
|------|----------|-----------------|
| `/news-fetch AI` | Lấy tin AI tuần này | Cập nhật ngành nhanh |
| `/news-fetch AI today` | Lấy tin AI hôm nay | Bản tin hàng ngày |
| `/news-fetch robotics month` | Lấy tin robotics tháng này | Đánh giá hàng tháng |
| `/news-fetch climate 2026-03-01~2026-03-31` | Lấy tin cho khoảng thời gian cụ thể | Nghiên cứu có mục tiêu |

---

## Trường hợp sử dụng

### Bản tin công nghệ hàng ngày

```
/news-fetch AI today
```

Nhận tin AI mới nhất trong ngày, xếp hạng theo mức độ liên quan. Quét tiêu đề và tóm tắt trong vài giây.

### Nghiên cứu ngành

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Lấy tin tức cho một khoảng thời gian cụ thể để hỗ trợ phân tích thị trường và nghiên cứu cạnh tranh.

### Tin tức đa ngôn ngữ

Các chủ đề tiếng Trung tự động nhận các tìm kiếm bổ sung bằng tiếng Anh để phủ sóng rộng hơn, và ngược lại. Bạn nhận được điều tốt nhất từ cả hai thế giới mà không cần nỗ lực thêm.

---

## Ví dụ đầu ra mong đợi

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## Dự phòng mạng 3 tầng

News Fetch có chiến lược dự phòng tích hợp để đảm bảo việc lấy tin hoạt động trong các điều kiện mạng khác nhau:

| Tầng | Công cụ | Nguồn dữ liệu | Kích hoạt |
|------|---------|---------------|-----------|
| **L1** | WebSearch | Google/Bing | Mặc định (ưu tiên) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 thất bại |
| **L3** | Bash curl | Cùng nguồn với L2 | L2 cũng thất bại |

Khi tất cả các tầng đều thất bại, một báo cáo lỗi có cấu trúc được tạo ra liệt kê lý do thất bại cho từng nguồn.

---

## Tính năng đầu ra

| Tính năng | Mô tả |
|-----------|-------|
| **Loại bỏ trùng lặp** | Khi nhiều nguồn đưa tin về cùng một sự kiện, mục có điểm cao nhất được giữ lại; các mục khác được gộp vào "Tin liên quan" |
| **Bổ sung tóm tắt** | Nếu kết quả tìm kiếm thiếu tóm tắt, nội dung bài viết được lấy về và tạo tóm tắt |
| **Chấm điểm liên quan** | AI chấm điểm mỗi kết quả theo mức độ liên quan đến chủ đề — điểm cao hơn nghĩa là liên quan hơn |
| **Liên kết có thể nhấp** | Định dạng liên kết Markdown — có thể nhấp trong IDE và terminal |

---

## Chấm điểm liên quan

Mỗi bài viết được chấm điểm 0-300 dựa trên mức độ phù hợp của tiêu đề và tóm tắt với chủ đề được yêu cầu:

| Phạm vi điểm | Ý nghĩa |
|-------------|---------|
| 200-300 | Rất liên quan — chủ đề là nội dung chính |
| 100-199 | Liên quan vừa phải — chủ đề được đề cập đáng kể |
| 0-99 | Liên quan gián tiếp — chủ đề xuất hiện thoáng qua |

Các bài viết được sắp xếp theo điểm giảm dần. Việc chấm điểm mang tính heuristic và dựa trên mật độ từ khóa, khớp tiêu đề và mức độ liên quan theo ngữ cảnh.

## Xử lý sự cố dự phòng mạng

| Triệu chứng | Nguyên nhân có thể | Giải pháp |
|-------------|-------------------|-----------|
| L1 trả về 0 kết quả | Công cụ WebSearch không khả dụng hoặc truy vấn quá cụ thể | Mở rộng từ khóa chủ đề |
| L2 tất cả nguồn thất bại | Các trang tin trong nước chặn truy cập tự động | Đợi và thử lại, hoặc kiểm tra xem `curl` có hoạt động thủ công không |
| L3 curl hết thời gian | Vấn đề kết nối mạng | Kiểm tra `curl -I https://news.baidu.com` |
| Tất cả tầng thất bại | Không có truy cập internet hoặc tất cả nguồn không hoạt động | Xác minh mạng; báo cáo lỗi liệt kê lỗi của từng nguồn |

---

## Câu hỏi thường gặp

### Tôi có cần khóa API không?

Không. News Fetch hoàn toàn dựa vào WebSearch và thu thập web công khai. Không cần cấu hình.

### Nó có thể lấy tin tức tiếng Anh không?

Chắc chắn. Các chủ đề tiếng Trung tự động bao gồm tìm kiếm bổ sung bằng tiếng Anh, và các chủ đề tiếng Anh hoạt động tự nhiên. Phạm vi bao phủ cả hai ngôn ngữ.

### Nếu mạng của tôi bị hạn chế thì sao?

Chiến lược dự phòng 3 tầng xử lý việc này tự động. Ngay cả khi WebSearch không khả dụng, News Fetch sẽ chuyển sang các nguồn tin trong nước.

### Nó trả về bao nhiêu bài viết?

Tối đa 20 (sau khi loại bỏ trùng lặp). Số lượng thực tế phụ thuộc vào những gì các nguồn dữ liệu trả về.

---

## Giấy phép

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
