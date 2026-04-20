# News Fetch Kullanıcı Kılavuzu

> 3 dakikada başlayın — AI'ın haber özetinizi getirmesine izin verin

Hata ayıklamaktan tükendiniz mi? 2 dakika ayırın, dünyada neler olduğunu öğrenin ve tazelenmiş olarak geri dönün.

---

## Kurulum

### Claude Code (önerilen)

```bash
claude plugin add juserai/forge
```

### Evrensel tek satır kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **Sıfır bağımlılık** — News Fetch harici hizmetler veya API anahtarları gerektirmez. Kurun ve başlayın.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanılır |
|-------|----------|---------------------|
| `/news-fetch AI` | Bu haftanın yapay zeka haberlerini getir | Hızlı sektör güncellemesi |
| `/news-fetch AI today` | Bugünün yapay zeka haberlerini getir | Günlük brifing |
| `/news-fetch robotics month` | Bu ayın robotik haberlerini getir | Aylık değerlendirme |
| `/news-fetch climate 2026-03-01~2026-03-31` | Belirli bir tarih aralığı için haberleri getir | Hedefli araştırma |

---

## Kullanım Senaryoları

### Günlük teknoloji brifing

```
/news-fetch AI today
```

Günün en son yapay zeka haberlerini alaka düzeyine göre sıralanmış olarak alın. Başlıkları ve özetleri saniyeler içinde tarayın.

### Sektör araştırması

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Pazar analizi ve rekabet araştırmasını desteklemek için belirli bir zaman diliminin haberlerini çekin.

### Diller arası haberler

Çince konular daha geniş kapsam için otomatik olarak tamamlayıcı İngilizce aramalar alır ve bunun tersi de geçerlidir. Ekstra çaba harcamadan her iki dünyanın en iyisini elde edersiniz.

---

## Beklenen Çıktı Örneği

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

## 3 Katmanlı Ağ Yedekleme

News Fetch, farklı ağ koşullarında haber alımının çalışmasını sağlamak için yerleşik bir yedekleme stratejisine sahiptir:

| Katman | Araç | Veri Kaynağı | Tetikleyici |
|--------|------|-------------|-------------|
| **L1** | WebSearch | Google/Bing | Varsayılan (tercih edilen) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 başarısız |
| **L3** | Bash curl | L2 ile aynı kaynaklar | L2 de başarısız |

Tüm katmanlar başarısız olduğunda, her kaynak için başarısızlık nedenini listeleyen yapılandırılmış bir hata raporu üretilir.

---

## Çıktı Özellikleri

| Özellik | Açıklama |
|---------|----------|
| **Tekrar kaldırma** | Birden fazla kaynak aynı olayı kapsadığında, en yüksek puanlı giriş korunur; diğerleri "İlgili kapsam" altında birleştirilir |
| **Özet tamamlama** | Arama sonuçlarında özet yoksa, makale gövdesi alınır ve bir özet oluşturulur |
| **Alaka puanlama** | AI her sonucu konu alakasına göre puanlar — yüksek puan daha alakalı demektir |
| **Tıklanabilir bağlantılar** | Markdown bağlantı formatı — IDE'lerde ve terminallerde tıklanabilir |

---

## Alaka Puanlama

Her makale, başlığının ve özetinin istenen konuyla ne kadar eşleştiğine göre 0-300 arasında puanlanır:

| Puan Aralığı | Anlamı |
|-------------|--------|
| 200-300 | Yüksek alaka — konu ana konu |
| 100-199 | Orta alaka — konu önemli ölçüde bahsedilmiş |
| 0-99 | Teğetsel alaka — konu geçerken bahsedilmiş |

Makaleler puana göre azalan sırada sıralanır. Puanlama sezgiseldir ve anahtar kelime yoğunluğu, başlık eşleşmesi ve bağlamsal alaka düzeyine dayanır.

## Ağ Yedekleme Sorun Giderme

| Belirti | Olası Neden | Çözüm |
|---------|-----------|-------|
| L1, 0 sonuç döndürüyor | WebSearch aracı kullanılamıyor veya sorgu çok spesifik | Konu anahtar kelimesini genişletin |
| L2 tüm kaynaklar başarısız | Yerel haber siteleri otomatik erişimi engelliyor | Bekleyip tekrar deneyin veya `curl`'ün manuel olarak çalışıp çalışmadığını kontrol edin |
| L3 curl zaman aşımı | Ağ bağlantısı sorunu | `curl -I https://news.baidu.com` kontrol edin |
| Tüm katmanlar başarısız | İnternet erişimi yok veya tüm kaynaklar çökmüş | Ağı doğrulayın; hata raporu her kaynağın hatasını listeler |

---

## SSS

### Bir API anahtarına ihtiyacım var mı?

Hayır. News Fetch tamamen WebSearch ve açık web kazımaya dayanır. Sıfır yapılandırma gerekir.

### İngilizce haberleri getirebilir mi?

Kesinlikle. Çince konular otomatik olarak tamamlayıcı İngilizce aramalar içerir ve İngilizce konular doğal olarak çalışır. Kapsam her iki dili de kapsar.

### Ağım kısıtlıysa ne olur?

3 katmanlı yedekleme stratejisi bunu otomatik olarak yönetir. WebSearch kullanılamasa bile News Fetch yerel haber kaynaklarına geri döner.

### Kaç makale döndürür?

20'ye kadar (tekrar kaldırma sonrası). Gerçek sayı, veri kaynaklarının ne döndürdüğüne bağlıdır.

---

## Ne zaman kullanılmalı / Ne zaman kullanılMAMAlı

### ✅ Şu durumlarda kullanın

- You want a quick news brief between coding sessions
- Bilingual aggregation (English + domestic sources)
- Network-restricted environments (3-tier fallback handles blocked sources)

### ❌ Şu durumlarda kullanmayın

- You need synthesized research (use `insight-fuse` instead)
- Targeted source monitoring (use an RSS reader)
- Translation tasks (news-fetch returns source language as-is)

> Kodlama molaları için haber özeti — 2 dakikalık tarama, derin analiz veya çeviri yok.

Tam sınır analizi: [references/scope-boundaries.md](../../../skills/news-fetch/references/scope-boundaries.md)

---

## Lisans

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
