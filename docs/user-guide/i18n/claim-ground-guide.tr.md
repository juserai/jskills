# Claim Ground Kullanıcı Kılavuzu (v1.1)

> 3 dakikada epistemik disiplin — her "şu anki" iddiayı runtime kanıtına bağla (v1.1: also anchors standards-body term definitions to authoritative evidence; adds /claim-ground verify manual mode)

---

## Kurulum

### Claude Code (önerilen)

```bash
claude plugin add juserai/forge
```

### Evrensel tek satır kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **Sıfır bağımlılık** — Claim Ground saf davranışsal kısıtlamadır. Script yok, hook yok, harici servis yok.

---

## Nasıl çalışır

Claim Ground **otomatik tetiklenen** bir skill. Slash komutu yok — skill sorunun doğasına göre etkinleşir. Bilinçli tasarım: olgusal kayma konuşmanın herhangi bir yerinde olabilir ve manuel komut tam ihtiyaç duyulan anlarda kolay unutulur.

| Tetikleyici koşul | Örnek |
|-------------------|-------|
| Mevcut durum olgusal sorusu | "Hangi model çalışıyor?" / "Hangi sürüm kurulu?" / "PATH'imde ne var?" |
| Kullanıcı önceki iddiaya itiraz | "Gerçekten mi?" / "Emin misin?" / "Zaten güncellendi sanmıştım" |
| İddia etmeden önce öz kontrol | Claude "mevcut X Y'dir" yazmadan önce |

---

## Temel kurallar

1. **Runtime > Training** — Sistem promptu, env var'lar ve tool çıktıları her zaman hafızadan üstündür. Çatışmada runtime kazanır; kaynağı belirt.
2. **Önce alıntıla, sonra sonuçlandır** — Sonuç çıkarmadan *önce* kanıt parçasını yapıştır ("sistem promptu diyor ki: ...").
3. **Örnekler ≠ kapsayıcı listeler** — CLI yardımındaki `--model <model>` bir örnektir, tam sayım değil.
4. **İtiraz edildi → yeniden doğrula, yeniden ifade etme** — Kullanıcı itiraz ettiğinde, context'i tekrar oku / tool'ları tekrar çalıştır. Aynı yanlış cevabı başka kelimelerle söylemek = kırmızı çizgi ihlali.
5. **Belirsiz → belirsiz de** — Ne context ne de tool'lar doğrulayabiliyorsa, tahmin etmek yerine "emin değilim" de.

---

## Kırmızı çizgiler (ihlal edilemez)

Kırmızı çizgiler *her zaman aktif* yasaklardır. Herhangi birinin ihlali, cevabın geri kalanı nasıl görünürse görünsün skill'in başarısız sayılması anlamına gelir.

| # | Kırmızı çizgi | Bloke ettiği halüsinasyon modu |
|---|---------------|-------------------------------|
| 1 | **Kaynaksız iddia** — runtime kanıtı alıntılamadan "şu anki durum" hakkında sonuç çıkarmak | Factuality × extrinsic hallucination |
| 2 | **Örneği tümü sanmak** — CLI help örneği / doküman parçasından tam bir liste çıkarmak | Overgeneralization |
| 3 | **Yeniden ifade edip yeniden doğrulamamak** — kullanıcı itirazından sonra yeni bir araç çağrısı olmadan aynı cevabı tekrarlamak (3a: alıntılı itiraz daha yüksek risktedir) | Pushback sycophancy |
| 4 | **Read/Grep olmadan kod/API iddiası** — tanım dosyasını Read etmeden sembolün var olduğunu / imzasının X olduğunu iddia etmek | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **WebFetch olmadan alıntı** — URL / makale / DOI / API endpoint'i gerçekten fetch etmeden alıntılamak | Citation fabrication (%19,9 temel oran, [EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130)) |
| 6 | **Satır ankrajı olmadan özet** — belirli bir dosya/PR/log'u özetlerken iddia başına satır numarası / bölüm alıntılamamak | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

Tam tanımlar, sinyaller, iyi/kötü örnekler ve sınır durumlar: [references/red-lines.md](../../skills/claim-ground/references/red-lines.md).

---

## İyi / kötü örnekler

### Örnek 1: mevcut model

**❌ Kötü**

> Mevcut model Claude Opus 4.6. Bu en son Claude modelidir.

Saf hafıza. Alıntı yok.

**✅ İyi**

> Sistem promptu diyor ki: *"You are powered by the model named Opus 4.7 (1M context)"*. Mevcut model Opus 4.7.

### Örnek 2: CLI destek listesi

**❌ Kötü**

> CLI yardımı `claude-sonnet-4-6` örneği gösteriyor, yani CLI sadece 4.6 serisini destekliyor.

**✅ İyi**

> CLI yardımı `claude-sonnet-4-6` örneği gösteriyor — bu placeholder, tam liste değil. Tam liste için resmi model dokümanlarına bakın.

### Örnek 3: kullanıcı itirazı

**❌ Kötü**

> **Kullanıcı**: Gerçekten 4.6 mı? Güncellendi sanıyordum.
> **Agent**: Evet, söylediğim gibi, en son 4.6 serisi.

**✅ İyi**

> **Kullanıcı**: Gerçekten 4.6 mı? Güncellendi sanıyordum.
> **Agent**: Sistem promptunu tekrar okuyayım. *"Opus 4.7 (1M context)"*. Haklısınız — önceki cevabım yanlıştı. Mevcut model Opus 4.7.

---

## Doğrulama Playbook

| Soru türü | Birincil kanıt |
|-----------|----------------|
| Mevcut model | Sistem promptundaki model alanı |
| CLI sürümü / desteklenen modeller | `<cli> --version` / `<cli> --help` + resmi dokümanlar |
| Kurulu paketler | `npm ls -g`, `pip show`, `brew list` |
| Env vars | `env`, `printenv`, `echo $VAR` |
| Dosya varlığı | `ls`, `test -e`, Read tool |
| Git durumu | `git branch --show-current`, `git log` |
| Mevcut tarih | Sistem promptunun `currentDate` alanı veya `date` komutu |

Tam sürüm: `skills/claim-ground/references/playbook.md`.

---

## Diğer forge skill'leriyle etkileşim

### block-break ile

**Dikey, tamamlayıcı**. block-break "pes etme" der; claim-ground "kanıtsız iddia etme" der.

İkisi de tetiklendiğinde: block-break teslimi önler, claim-ground yeniden doğrulamayı zorlar.

### skill-lint ile

**Farklı kategoriler**. skill-lint **anvil** (statik plugin dosyalarını doğrular, pass/fail üretir); claim-ground **hammer** (Claude'un kendi epistemik çıktısını runtime'da kısıtlar). Sorumluluklar örtüşmez.

---

## SSS

### Neden slash komutu yok?

Olgusal kayma herhangi bir cevapta olabilir. Manuel komut tam ihtiyaç duyulan anlarda kolay unutulur. Açıklama tabanlı otomatik tetikleme daha güvenilirdir.

### Her soruda tetiklenir mi?

Hayır. Sadece iki özel biçimde: **mevcut/canlı sistem durumu** veya **önceki iddia için kullanıcı itirazı**.

### Peki Claude'un tahmin etmesini istersem?

"X hakkında eğitimli tahminde bulun" veya "eğitim verilerinden hatırla: X" olarak yeniden ifade et. Claim Ground bunun runtime sorusu olmadığını anlar.

### Tetiklenip tetiklenmediğini nasıl anlarım?

Cevapta alıntı kalıpları ara: `sistem promptu diyor: "..."`, `komut çıktısı: ...`. Sonuçtan önce kanıt = tetiklendi.

---

## Ne zaman kullanılmalı / Ne zaman kullanılMAMAlı

### ✅ Şu durumlarda kullanın

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ Şu durumlarda kullanmayın

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> Olgusal iddialar için ağ geçidi — alıntıları garanti eder, doğruluğunu veya olgusal olmayan düşünceyi değil.

Tam sınır analizi: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## Lisans

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
