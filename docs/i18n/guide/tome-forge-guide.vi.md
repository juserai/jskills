# Huong Dan Su Dung Tome Forge

> Bat dau trong 5 phut — co so tri thuc ca nhan voi wiki duoc LLM bien dich

---

## Cai Dat

### Claude Code (khuyen nghi)

```bash
claude plugin add juserai/forge
```

### Cai dat pho quat mot dong

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **Khong phu thuoc** — Tome Forge khong can dich vu ben ngoai, co so du lieu vector, hay ha tang RAG. Cai dat va su dung ngay.

---

## Cac Lenh

| Lenh | Chuc nang | Khi nao su dung |
|------|----------|----------------|
| `/tome-forge init` | Khoi tao co so tri thuc | Khi bat dau KB moi trong bat ky thu muc nao |
| `/tome-forge capture [text]` | Bat nhanh ghi chu, lien ket hoac bo nho tam | Ghi lai y tuong, luu URL, cat dan noi dung |
| `/tome-forge capture clip` | Bat tu bo nho tam he thong | Luu nhanh noi dung da sao chep |
| `/tome-forge ingest <path>` | Bien dich tai lieu tho thanh wiki | Sau khi them bai bao, bai viet hoac ghi chu vao `raw/` |
| `/tome-forge ingest <path> --dry-run` | Xem truoc dinh tuyen ma khong ghi | Xac minh truoc khi xac nhan thay doi |
| `/tome-forge query <question>` | Tim kiem va tong hop tu wiki | Tim cau tra loi trong toan bo co so tri thuc |
| `/tome-forge lint` | Kiem tra suc khoe cau truc wiki | Truoc khi commit, bao tri dinh ky |
| `/tome-forge compile` | Bien dich hang loat tat ca tai lieu tho moi | Bat kip sau khi them nhieu tep tho |

---

## Cach Hoat Dong

Dua tren mo hinh LLM Wiki cua Karpathy:

```
raw materials + LLM compilation = structured Markdown wiki
```

### Kien Truc Hai Tang

| Tang | Chu so huu | Muc dich |
|------|-----------|---------|
| `raw/` | Ban | Tai lieu nguon bat bien — bai bao, bai viet, ghi chu, lien ket |
| `wiki/` | LLM | Cac trang Markdown duoc bien dich, cau truc hoa, tham chieu cheo |

LLM doc tai lieu tho cua ban va bien dich chung thanh cac trang wiki co cau truc tot. Ban khong bao gio chinh sua `wiki/` truc tiep — ban them tai lieu tho va de LLM duy tri wiki.

### Phan Thieng

Moi trang wiki co mot phan `## Chenh Lech Hieu Biet Cua Toi`. Day la cua **ban** — LLM se khong bao gio sua doi no. Viet nhung hieu biet ca nhan, bat dong hoac truc giac cua ban o day. No ton tai qua moi lan bien dich lai.

---

## Kham Pha KB — Du Lieu Cua Toi Di Dau?

Ban co the chay `/tome-forge` tu **bat ky thu muc nao**. No tu dong tim KB phu hop:

| Tinh huong | Dieu gi xay ra |
|-----------|---------------|
| Thu muc hien tai (hoac thu muc cha) chua `.tome-forge.json` | Su dung KB do |
| Khong tim thay `.tome-forge.json` phia tren | Su dung mac dinh `~/.tome-forge/` (tu dong tao neu can) |

Dieu nay co nghia ban co the bat ghi chu tu bat ky du an nao ma khong can `cd` truoc — tat ca deu chay vao KB mac dinh duy nhat cua ban.

Muon KB rieng cho tung du an? Su dung `init .` ben trong thu muc du an do.

## Quy Trinh Lam Viec

### 1. Khoi Tao

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

Sau khi khoi tao, thu muc KB trong nhu sau:

```
~/.tome-forge/               # (or wherever you initialized)
├── .tome-forge.json         # KB marker (auto-generated)
├── CLAUDE.md                # KB schema and rules
├── index.md                 # Wiki page index
├── .gitignore
├── logs/                    # Operation logs (monthly rotation)
│   └── 2026-04.md           # One file per month, never grows too large
├── raw/                     # Your source materials (immutable)
└── wiki/                    # LLM-compiled wiki (auto-maintained)
```

### 2. Bat

Tu **bat ky thu muc nao**, chi can chay:

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

Bat nhanh se vao `raw/captures/{date}/`. Voi tai lieu dai hon, dat tep truc tiep vao `raw/papers/`, `raw/articles/`, v.v.

### 3. Nap

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

LLM doc tep tho, dinh tuyen den (cac) trang wiki phu hop va gop thong tin moi trong khi bao toan ghi chu ca nhan cua ban.

### 4. Truy Van

```
/tome-forge query "what is the relationship between attention and transformers?"
```

Tong hop cau tra loi tu wiki cua ban, trich dan cac trang cu the. Thong bao neu thieu thong tin va can them tai lieu tho nao.

### 5. Bao Tri

```
/tome-forge lint
/tome-forge compile
```

Lint kiem tra tinh toan ven cau truc. Compile nap hang loat tat ca noi dung moi tu lan bien dich cuoi.

---

## Cau Truc Thu Muc

```
my-knowledge-base/
├── .tome-forge.json       # KB marker (auto-generated)
├── CLAUDE.md              # Schema and rules (auto-generated)
├── index.md               # Wiki page index
├── .last_compile          # Timestamp for batch compile
├── logs/                  # Operation logs (monthly rotation)
│   └── 2026-04.md
├── raw/                   # Your source materials (immutable)
│   ├── captures/          # Quick captures by date
│   ├── papers/            # Academic papers
│   ├── articles/          # Blog posts, articles
│   ├── books/             # Book notes
│   └── conversations/     # Chat logs, interviews
└── wiki/                  # LLM-compiled wiki (auto-maintained)
    ├── ai/                # Domain directories
    ├── systems/
    └── ...
```

---

## Dinh Dang Trang Wiki

Moi trang wiki tuan theo mau nghiem ngat:

```yaml
---
domain: ai
maturity: growing        # draft | growing | stable | deprecated
last_compiled: 2026-04-15
source_refs:
  - raw/papers/attention.md
confidence: medium       # low | medium | high
compiled_by: claude-opus-4-6
---
```

Cac phan bat buoc:
- **Khai Niem Cot Loi** — Tri thuc do LLM duy tri
- **Chenh Lech Hieu Biet Cua Toi** — Hieu biet ca nhan cua ban (LLM khong bao gio dong den)
- **Cau Hoi Mo** — Cac cau hoi chua duoc tra loi
- **Ket Noi** — Lien ket den cac trang wiki lien quan

---

## Nhip Do Khuyen Nghi

| Tan suat | Hanh dong | Thoi gian |
|---------|---------|----------|
| **Hang ngay** | `capture` cho y tuong, lien ket, bo nho tam | 2 phut |
| **Hang tuan** | `compile` de xu ly hang loat tai lieu trong tuan | 15-30 phut |
| **Hang thang** | `lint` + xem lai cac phan Chenh Lech Hieu Biet Cua Toi | 30 phut |

**Tranh nap thoi gian thuc.** Nap tung tep thuong xuyen lam mat tinh nhat quan cua wiki. Bien dich hang loat hang tuan tao ra tham chieu cheo tot hon va cac trang nhat quan hon.

---

## Lo Trinh Mo Rong

| Giai doan | Kich thuoc Wiki | Chien luoc |
|-----------|----------------|-----------|
| 1. Khoi dong nguoi (tuan 1-4) | < 30 trang | Doc toan bo ngu canh, dinh tuyen qua index.md |
| 2. Trang thai on dinh (thang 2-3) | 30-100 trang | Phan manh theo chu de (wiki/ai/, wiki/systems/) |
| 3. Mo rong (thang 4-6) | 100-200 trang | Truy van trong pham vi phan manh, bo sung ripgrep |
| 4. Nang cao (6+ thang) | 200+ trang | Dinh tuyen dua tren embedding (khong phai truy xuat), bien dich tang dan |

---

## Rui Ro Da Biet

| Rui ro | Tac dong | Giam thieu |
|--------|---------|-----------|
| **Troi dat cach dien** | Bien dich nhieu lan lam mat giong ca nhan | `compiled_by` theo doi mo hinh; raw/ la nguon su that; bien dich lai tu raw bat ky luc nao |
| **Tran mo rong** | Cua so ngu canh gioi han kich thuoc wiki | Phan manh theo linh vuc; su dung dinh tuyen chi muc; lop embedding khi > 200 trang |
| **Phu thuoc nha cung cap** | Rang buoc vao mot nha cung cap LLM | Nguon tho la Markdown thuan; doi mo hinh va bien dich lai |
| **Hong Delta** | LLM ghi de hieu biet ca nhan | Xac minh diff sau nap tu dong khoi phuc Delta goc |

---

## Nen Tang

| Nen tang | Cach hoat dong |
|---------|---------------|
| Claude Code | Truy cap toan bo he thong tep, doc song song, tich hop git |
| OpenClaw | Cung cac thao tac, thich ung voi quy uoc cong cu OpenClaw |

---

## Cau Hoi Thuong Gap

**H: Wiki co the lon den muc nao?**
D: Duoi 50 trang, LLM doc tat ca. 50-200 trang, no su dung chi muc de dieu huong. Tren 200, hay xem xet phan manh theo linh vuc.

**H: Toi co the chinh sua truc tiep trang wiki khong?**
D: Chi phan `## Chenh Lech Hieu Biet Cua Toi`. Moi thu khac se bi ghi de trong lan nap/bien dich tiep theo.

**H: No co can co so du lieu vector khong?**
D: Khong. Wiki la Markdown thuan. LLM doc tep truc tiep — khong embedding, khong RAG, khong ha tang.

**H: Lam the nao de sao luu KB?**
D: Tat ca la cac tep trong kho git. `git push` la xong.

**H: Neu LLM mac loi trong wiki thi sao?**
D: Them ban sua vao `raw/` va nap lai. Thuat toan gop uu tien nguon co tham quyen hon. Hoac ghi chu bat dong trong Chenh Lech Hieu Biet Cua Toi cua ban.
