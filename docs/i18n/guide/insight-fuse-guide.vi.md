# Huong dan su dung Insight Fuse

> Dong co nghien cuu da nguon co he thong — Tu chu de den bao cao nghien cuu chuyen nghiep

## Bat dau nhanh

```bash
# Nghien cuu day du (5 giai doan, co diem kiem tra thu cong)
/insight-fuse AI Agent rui ro bao mat

# Quet nhanh (chi Stage 1)
/insight-fuse --depth quick tinh toan luong tu

# Su dung mau bao cao cu the
/insight-fuse --template technology WebAssembly

# Nghien cuu sau voi goc nhin tuy chinh
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist thuong mai hoa xe tu lai
```

## Tham so

| Tham so | Mo ta | Vi du |
|---------|-------|-------|
| `topic` | Chu de nghien cuu (bat buoc) | `AI Agent rui ro bao mat` |
| `--depth` | Do sau nghien cuu | `quick` / `standard` / `deep` / `full` |
| `--template` | Mau bao cao | `technology` / `market` / `competitive` |
| `--perspectives` | Danh sach goc nhin | `optimist,pessimist,pragmatist` |

## Che do do sau

### quick — Quet nhanh
Thuc thi Stage 1. 3+ truy van tim kiem, 5+ nguon, xuat bao cao tom tat. Phu hop de nhanh chong tim hieu mot chu de.

### standard — Nghien cuu tieu chuan
Thuc thi Stage 1 + 3. Tu dong nhan dien cac cau hoi phu, nghien cuu song song, bao phu toan dien. Khong co tuong tac thu cong.

### deep — Nghien cuu sau
Thuc thi Stage 1 + 3 + 5. Tren co so nghien cuu tieu chuan, phan tich sau tat ca cac cau hoi phu tu 3 goc nhin. Khong co tuong tac thu cong.

### full (mac dinh) — Quy trinh day du
Thuc thi tat ca 5 giai doan. Stage 2 va Stage 4 la cac diem kiem tra thu cong, dam bao huong di khong bi lech.

## Mau bao cao

### Mau tich hop san

- **technology** — Nghien cuu cong nghe: kien truc, so sanh, he sinh thai, xu huong
- **market** — Nghien cuu thi truong: quy mo, canh tranh, nguoi dung, du bao
- **competitive** — Phan tich canh tranh: ma tran tinh nang, SWOT, dinh gia

### Mau tuy chinh

1. Sao chep `templates/custom-example.md` thanh `templates/your-name.md`
2. Chinh sua cau truc chuong
3. Giu nguyen cac trinh giu cho `{topic}` va `{date}`
4. Chuong cuoi cung phai la "Nguon tham khao"
5. Kich hoat bang `--template your-name`

### Che do khong dung mau

Khi khong chi dinh `--template`, agent se tu dong tao cau truc bao cao thich ung dua tren noi dung nghien cuu.

## Phan tich da goc nhin

### Goc nhin mac dinh

| Goc nhin | Vai tro | Mo hinh |
|----------|---------|---------|
| Generalist | Bao phu rong, dong thuan chu dao | Sonnet |
| Critic | Dat cau hoi xac minh, tim bang chung phan bac | Opus |
| Specialist | Chieu sau ky thuat, nguon goc | Sonnet |

### Bo goc nhin thay the

| Kich ban | Goc nhin |
|----------|---------|
| Du bao xu huong | `--perspectives optimist,pessimist,pragmatist` |
| Nghien cuu san pham | `--perspectives user,developer,business` |
| Nghien cuu chinh sach | `--perspectives domestic,international,regulatory` |

### Goc nhin tuy chinh

Tao `agents/insight-{name}.md`, tham khao cau truc cac tap tin agent hien co.

## Dam bao chat luong

Moi bao cao duoc tu dong kiem tra:
- Moi chuong co it nhat 2 nguon doc lap
- Khong co tham chieu mo coi
- Ti le mot nguon khong vuot qua 40%
- Tat ca cac khang dinh so sanh deu co du lieu ho tro

## Su khac biet voi council-fuse

| | insight-fuse | council-fuse |
|---|---|---|
| **Muc dich** | Nghien cuu chu dong + tao bao cao | Thao luan da goc nhin ve thong tin da biet |
| **Nguon thong tin** | Thu thap qua WebSearch/WebFetch | Cau hoi do nguoi dung cung cap |
| **Dau ra** | Bao cao nghien cuu day du | Cau tra loi tong hop |
| **Giai doan** | 5 giai doan tien trien | 3 giai doan (trieu tap → danh gia → tong hop) |

Ca hai co the ket hop su dung: truoc tien dung insight-fuse de nghien cuu va thu thap thong tin, sau do dung council-fuse de thao luan sau ve cac quyet dinh quan trong.
