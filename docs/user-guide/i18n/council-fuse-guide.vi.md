# Huong dan su dung Council Fuse

> Bat dau trong 5 phut — thao luan da goc nhin de co cau tra loi tot hon

---

## Cai dat

### Claude Code (khuyen nghi)

```bash
claude plugin add juserai/forge
```

### Cai dat mot dong toan cau

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **Khong phu thuoc** — Council Fuse khong yeu cau dich vu ben ngoai hay API nao. Cai dat va bat dau ngay.

---

## Lenh

| Lenh | Chuc nang | Khi nao su dung |
|------|-----------|-----------------|
| `/council-fuse <cau hoi>` | Chay mot phien thao luan hoi dong day du | Quyet dinh quan trong, cau hoi phuc tap |

---

## Cach hoat dong

Council Fuse chung cat mo hinh LLM Council cua Karpathy thanh mot lenh duy nhat:

### Giai doan 1: Trieu tap

Ba tac tu duoc tao **song song**, moi tac tu voi mot goc nhin khac nhau:

| Tac tu | Vai tro | Mo hinh | The manh |
|--------|---------|---------|----------|
| Nguoi tong hop | Can bang, thuc te | Sonnet | Cac thuc hanh tot pho bien |
| Nguoi phan bien | Doi lap, tim loi | Opus | Truong hop bien, rui ro, diem mu |
| Chuyen gia | Chi tiet ky thuat sau | Sonnet | Do chinh xac trien khai |

Moi tac tu tra loi **doc lap** — ho khong the thay cau tra loi cua nhau.

### Giai doan 2: Cham diem

Chu tich (tac tu chinh) an danh hoa tat ca cac cau tra loi thanh Cau tra loi A/B/C, sau do cham diem tung cau tren 4 chieu (0-10):

- **Chinh xac** — do chinh xac thuc te, tinh hop ly logic
- **Day du** — muc do bao phu tat ca cac khia canh
- **Thuc tien** — kha nang thuc hien, ung dung thuc te
- **Ro rang** — cau truc, de doc

### Giai doan 3: Tong hop

Cau tra loi co diem cao nhat tro thanh khung xuong. Nhung thong tin doc dao tu cac cau tra loi khac duoc tich hop. Cac phan doi hop le cua nguoi phan bien duoc giu lai nhu luu y.

---

## Truong hop su dung

### Quyet dinh kien truc

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

Nguoi tong hop cung cap cac danh doi can bang, nguoi phan bien thach thuc su pho bien cua microservices, va chuyen gia trinh bay chi tiet cac mo hinh di chuyen. Ket qua tong hop dua ra khuyen nghi co dieu kien.

### Lua chon cong nghe

```
/council-fuse Redis vs PostgreSQL for our job queue
```

Ba goc do khac nhau dam bao ban khong bo sot cac moi quan ngai van hanh (nguoi phan bien), chi tiet trien khai (chuyen gia), hoac lua chon mac dinh thuc dung (nguoi tong hop).

### Danh gia ma nguon

```
/council-fuse Is this error handling pattern correct? <paste code>
```

Nhan duoc xac thuc pho bien, phan tich doi lap truong hop bien va xac minh ky thuat sau trong mot lan chay.

---

## Cau truc dau ra

Moi phien thao luan hoi dong tao ra:

1. **Ma tran diem** — cham diem minh bach cho ca ba goc nhin
2. **Phan tich dong thuan** — diem dong y va bat dong
3. **Cau tra loi tong hop** — cau tra loi tot nhat da ket hop
4. **Y kien thieu so** — quan diem bat dong hop le dang luu y

---

## Tuy chinh

### Thay doi goc nhin

Chinh sua `agents/*.md` de dinh nghia thanh vien hoi dong tuy chinh. Bo ba thay the:

- Lac quan / Bi quan / Thuc dung
- Kien truc su / Nguoi trien khai / Nguoi kiem thu
- Dai dien nguoi dung / Lap trinh vien / Chuyen gia bao mat

### Thay doi mo hinh

Chinh sua truong `model:` trong moi tap tin tac tu:

- `model: haiku` — hoi dong tiet kiem chi phi
- `model: opus` — hang nang toan bo cho quyet dinh quan trong

---

## Nen tang

| Nen tang | Cach thanh vien hoi dong hoat dong |
|----------|-----------------------------------|
| Claude Code | 3 Agent doc lap sinh song song |
| OpenClaw | Mot tac tu duy nhat, 3 vong suy luan doc lap tuan tu |

---

## Khi nào dùng / Khi nào KHÔNG dùng

### ✅ Dùng khi

- Architectural decisions needing multiple perspectives
- You suspect confirmation bias in your current answer
- You want dissenting views preserved, not erased

### ❌ Không dùng khi

- Pure factual queries (use `claim-ground` instead)
- Creative writing (synthesis flattens style)
- Speed-critical decisions (3 agents run sequentially — not fast)

> Động cơ tranh biện dựa trên tri thức huấn luyện — phơi bày điểm mù đơn góc nhìn, nhưng kết luận vẫn giới hạn bởi tri thức huấn luyện.

Phân tích phạm vi đầy đủ: [references/scope-boundaries.md](../../../skills/council-fuse/references/scope-boundaries.md)

---

## Cau hoi thuong gap

**H: Co ton 3 lan token khong?**
D: Co, xap xi. Ba cau tra loi doc lap cong them tong hop. Su dung cho nhung quyet dinh xung dang voi chi phi.

**H: Toi co the them thanh vien hoi dong khong?**
D: Framework ho tro dieu nay — them mot tap tin `agents/*.md` khac va cap nhat luong cong viec trong SKILL.md. Tuy nhien, 3 la diem toi uu giua chi phi va su da dang.

**H: Neu mot tac tu that bai thi sao?**
D: Chu tich cham tac tu do 0 diem va tong hop tu cac cau tra loi con lai. Suy giam nhe nhang, khong bi loi.
