# Tome Forge Kullanici Kilavuzu

> 5 dakikada baslayin — LLM derlemeli viki ile kisisel bilgi tabani

---

## Kurulum

### Claude Code (onerilen)

```bash
claude plugin add juserai/forge
```

### Evrensel tek satirlik kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **Sifir bagimlilik** — Tome Forge harici hizmet, vektor veritabani veya RAG altyapisi gerektirmez. Kurun ve baslayin.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanilir |
|-------|----------|-------------------|
| `/tome-forge init` | Bilgi tabani baslatma | Herhangi bir dizinde yeni KB baslatirken |
| `/tome-forge capture [text]` | Not, baglanti veya pano hizli yakalama | Dusunceleri not alma, URL kaydetme, kes-yapistir |
| `/tome-forge capture clip` | Sistem panosundan yakalama | Kopyalanan icerigin hizli kaydedilmesi |
| `/tome-forge ingest <path>` | Ham malzemeyi vikiye derleme | `raw/` dizinine makale, bildiri veya not ekledikten sonra |
| `/tome-forge ingest <path> --dry-run` | Yazmadan yonlendirme onizleme | Degisiklikleri onaylamadan once dogrulama |
| `/tome-forge query <question>` | Vikiden arama ve sentez | Bilgi tabaninda cevap bulma |
| `/tome-forge lint` | Viki yapisinin saglik kontrolu | Commit oncesi, periyodik bakim |
| `/tome-forge compile` | Tum yeni ham malzemeleri toplu derleme | Birden fazla ham dosya ekledikten sonra yakalama |

---

## Nasil Calisir

Karpathy'nin LLM Viki kalibina dayanir:

```
raw materials + LLM compilation = structured Markdown wiki
```

### Iki Katmanli Mimari

| Katman | Sahip | Amac |
|--------|-------|------|
| `raw/` | Siz | Degismez kaynak malzemeler — bildiriler, makaleler, notlar, baglantilar |
| `wiki/` | LLM | Derlenmis, yapilandirilmis, capraz referansli Markdown sayfalari |

LLM ham malzemelerinizi okur ve iyi yapilandirilmis viki sayfalarina derler. `wiki/` dizinini asla dogrudan duzenlemezsiniz — ham malzeme ekler ve LLM'nin vikiyi yonetmesine izin verirsiniz.

### Kutsal Bolum

Her viki sayfasinin bir `## Benim Anlayis Farkliligim` bolumu vardir. Bu **sizindir** — LLM bunu asla degistirmez. Kisisel icgoruelerinizi, itirazlarinizi veya sezgilerinizi buraya yazin. Tum yeniden derlemelerde korunur.

---

## KB Kesfi — Verilerim Nereye Gidiyor?

`/tome-forge` komutunu **herhangi bir dizinden** calistirabilirsiniz. Dogru KB'yi otomatik olarak bulur:

| Durum | Ne olur |
|-------|--------|
| Mevcut dizin (veya ust dizin) `.tome-forge.json` icerir | O KB'yi kullanir |
| Yukari dogru `.tome-forge.json` bulunamadi | Varsayilan `~/.tome-forge/` kullanilir (gerekirse otomatik olusturulur) |

Bu, once `cd` yapmadan herhangi bir projeden not yakalayabileceginiz anlamina gelir — her sey tek varsayilan KB'nize akar.

Proje basina ayri KB'ler mi istiyorsunuz? O proje dizini icinde `init .` kullanin.

## Is Akisi

### 1. Baslatin

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

Baslatma sonrasi KB dizini su sekilde gorunur:

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

### 2. Yakalayin

**Herhangi bir dizinden** su komutu calistirin:

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

Hizli yakalamalar `raw/captures/{date}/` dizinine gider. Daha uzun malzemeler icin dosyalari dogrudan `raw/papers/`, `raw/articles/` vb. dizinlere koyun.

### 3. Iceri Alin

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

LLM ham dosyayi okur, dogru viki sayfasina/sayfalarina yonlendirir ve kisisel notlarinizi korurken yeni bilgileri birlestirir.

### 4. Sorgulama

```
/tome-forge query "what is the relationship between attention and transformers?"
```

Vikinizden bir cevap sentezler ve belirli sayfalara atifta bulunur. Bilgi eksikse ve hangi ham malzemenin eklenmesi gerektigini bildirir.

### 5. Bakim

```
/tome-forge lint
/tome-forge compile
```

Lint yapisal butunlugu kontrol eder. Compile son derlemeden bu yana tum yenileri toplu olarak iceri alir.

---

## Dizin Yapisi

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

## Viki Sayfa Formati

Her viki sayfasi siki bir sablonu takip eder:

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

Gerekli bolumler:
- **Temel Kavram** — LLM tarafindan yonetilen bilgi
- **Benim Anlayis Farkliligim** — Kisisel icgoruleriniz (LLM tarafindan asla dokunulmaz)
- **Acik Sorular** — Cevaplanmamis sorular
- **Baglantilar** — Ilgili viki sayfalarina linkler

---

## Onerilen Tempo

| Siklik | Eylem | Sure |
|--------|-------|------|
| **Gunluk** | Dusunceler, linkler, pano icin `capture` | 2 dk |
| **Haftalik** | Haftanin ham malzemelerini toplu islemek icin `compile` | 15-30 dk |
| **Aylik** | `lint` + Benim Anlayis Farkliligim bolumlerini gozden gecirme | 30 dk |

**Gercek zamanli iceri almadan kacinin.** Sik tek dosya iceri almalari vikinin tutarliligini parcalar. Haftalik toplu derleme daha iyi capraz referanslar ve daha tutarli sayfalar uretir.

---

## Olceklendirme Yol Haritasi

| Aşama | Viki Boyutu | Strateji |
|-------|------------|----------|
| 1. Soguk Baslangic (hafta 1-4) | < 30 sayfa | Tam baglam okuma, index.md yonlendirme |
| 2. Kararli Durum (ay 2-3) | 30-100 sayfa | Konu parcalama (wiki/ai/, wiki/systems/) |
| 3. Olcekleme (ay 4-6) | 100-200 sayfa | Parca kapsamli sorgular, ripgrep destegi |
| 4. Ileri Duzey (6+ ay) | 200+ sayfa | Gomme tabanli yonlendirme (arama degil), artimli derleme |

---

## Bilinen Riskler

| Risk | Etki | Azaltma |
|------|------|---------|
| **Ifade kaymasi** | Coklu derleme kisisel sesi yumusatir | `compiled_by` modeli izler; raw/ gercek kaynak; istediginiz zaman raw'dan yeniden derleyin |
| **Olcek tavani** | Baglam penceresi viki boyutunu sinirlar | Alana gore parcalayin; dizin yonlendirme kullanin; > 200 sayfada gomme katmani |
| **Satici bagimliligi** | Tek LLM saglayicisina bagli | Ham kaynaklar duz Markdown; model degistirin ve yeniden derleyin |
| **Delta bozulmasi** | LLM kisisel icgorulerin uzerine yazar | Iceri alma sonrasi diff dogrulamasi orijinal Delta'yi otomatik geri yukler |

---

## Platformlar

| Platform | Nasil calisir |
|----------|--------------|
| Claude Code | Tam dosya sistemi erisimi, paralel okuma, git entegrasyonu |
| OpenClaw | Ayni islemler, OpenClaw arac kurallarina uyarlanmis |

---

## SSS

**S: Viki ne kadar buyuyebilir?**
C: 50 sayfanin altinda LLM her seyi okur. 50-200 sayfa arasinda gezinmek icin dizini kullanir. 200'un uzerinde alan parcalamayi degerlendirin.

**S: Viki sayfalarini dogrudan duzenleyebilir miyim?**
C: Yalnizca `## Benim Anlayis Farkliligim` bolumu. Diger her sey bir sonraki iceri alma/derlemede uzerine yazilacaktir.

**S: Vektor veritabanina ihtiyac var mi?**
C: Hayir. Viki duz Markdown'dir. LLM dosyalari dogrudan okur — gomme yok, RAG yok, altyapi yok.

**S: KB'mi nasil yedeklerim?**
C: Her sey bir git deposundaki dosyalardir. `git push` yapmaniz yeterli.

**S: LLM vikide hata yaparsa ne olur?**
C: `raw/` dizinine bir duzeltme ekleyin ve yeniden iceri alin. Birlestirme algoritmasi daha yetkili kaynaklari tercih eder. Ya da Benim Anlayis Farkliligim bolumunuze itirazlarinizi not edin.
