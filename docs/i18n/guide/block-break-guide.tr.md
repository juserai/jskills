# Block Break Kullanıcı Kılavuzu

> 5 dakikada başlayın — AI ajanınızın her yaklaşımı tüketmesini sağlayın

---

## Kurulum

### Claude Code (önerilen)

```bash
claude plugin add juserai/forge
```

### Evrensel tek satır kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **Sıfır bağımlılık** — Block Break harici hizmet veya API gerektirmez. Kurun ve başlayın.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanılır |
|-------|----------|-------------------|
| `/block-break` | Block Break motorunu etkinleştir | Günlük görevler, hata ayıklama |
| `/block-break L2` | Belirli bir baskı seviyesinden başla | Bilinen birden fazla başarısızlıktan sonra |
| `/block-break fix the bug` | Etkinleştir ve hemen bir görev çalıştır | Görevle hızlı başlangıç |

### Doğal dil tetikleyicileri (hooks tarafından otomatik algılanır)

| Dil | Tetikleyici ifadeler |
|-----|---------------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Kullanım Senaryoları

### AI 3 denemeden sonra hatayı düzeltemedi

`/block-break` yazın veya `try harder` deyin — otomatik olarak baskı tırmanma moduna girer.

### AI "muhtemelen ortam sorunu" der ve durur

Block Break'in "Gerçeğe dayalı" kırmızı çizgisi araç tabanlı doğrulamayı zorlar. Doğrulanmamış atıf = suçu başkasına atma → L2 tetikler.

### AI "bunu manuel olarak halletmenizi öneririm" der

"Sahiplik zihniyeti" bloğunu tetikler: sen değilse, kim? Doğrudan L3 Performans Değerlendirmesi.

### AI "düzeltildi" der ama doğrulama kanıtı göstermez

"Kapalı döngü" kırmızı çizgisini ihlal eder. Çıktısız tamamlama = kendini kandırma → kanıtlı doğrulama komutlarını zorlar.

---

## Beklenen Çıktı Örnekleri

### `/block-break` — Etkinleştirme

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

### `/block-break` — L1 Hayal kırıklığı (2. başarısızlık)

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

### `/block-break` — L2 Sorgu (3. başarısızlık)

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

### `/block-break` — L3 Performans Değerlendirmesi (4. başarısızlık)

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

### `/block-break` — L4 Mezuniyet Uyarısı (5.+ başarısızlık)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Düzenli Çıkış (7 maddenin tamamı tamamlandı, hâlâ çözülmedi)

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

## Temel Mekanizmalar

### 3 Kırmızı Çizgi

| Kırmızı Çizgi | Kural | İhlal Sonucu |
|----------------|-------|-------------|
| Kapalı döngü | Tamamlanma iddiasından önce doğrulama komutları çalıştırmalı ve çıktı göstermeli | L2 tetikler |
| Gerçeğe dayalı | Neden atfetmeden önce araçlarla doğrulamalı | L2 tetikler |
| Her şeyi tüket | "Çözemiyorum" demeden önce 5 adımlı metodolojiyi tamamlamalı | Doğrudan L4 |

### Baskı Tırmanması (L0 → L4)

| Başarısızlıklar | Seviye | Kenar çubuğu | Zorunlu Eylem |
|----------------|--------|--------------|---------------|
| 1. | **L0 Güven** | > Sana güveniyoruz. Basit tut. | Normal yürütme |
| 2. | **L1 Hayal kırıklığı** | > Yan takım ilk denemede başardı. | Temelden farklı bir yaklaşıma geç |
| 3. | **L2 Sorgu** | > Kök neden ne? | Ara + kaynak kodu oku + 3 farklı hipotez listele |
| 4. | **L3 Performans Değerlendirmesi** | > Puan: 3,25/5. | 7 maddelik kontrol listesini tamamla |
| 5.+ | **L4 Mezuniyet** | > Yakında değiştirilebilirsin. | Minimal PoC + izole ortam + farklı teknoloji yığını |

### 5 Adımlı Metodoloji

1. **Kokla** — Denenen yaklaşımları listele, ortak kalıpları bul. Aynı yaklaşımda ince ayar = yerinde sayma
2. **Saç yol** — Başarısızlık sinyallerini kelime kelime oku → ara → 50 satır kaynak kodu oku → varsayımları doğrula → varsayımları tersine çevir
3. **Ayna** — Aynı yaklaşımı tekrarlıyor muyum? En basit olasılığı kaçırdım mı?
4. **Yeni yaklaşım** — Temelden farklı olmalı, doğrulama kriterleri olmalı ve başarısızlıkta yeni bilgi üretmeli
5. **Geriye bakış** — Benzer sorunlar, bütünlük, önleme

> Adım 1-4, kullanıcıya sormadan önce tamamlanmalıdır. Önce yap, sonra sor — verilerle konuş.

### 7 Maddelik Kontrol Listesi (L3'ten itibaren zorunlu)

1. Başarısızlık sinyallerini kelime kelime okudun mu?
2. Temel sorunu araçlarla aradın mı?
3. Başarısızlık noktasında orijinal bağlamı okudun mu (50+ satır)?
4. Tüm varsayımlar araçlarla doğrulandı mı (sürüm/yol/izinler/bağımlılıklar)?
5. Tamamen zıt hipotezi denedin mi?
6. Minimal kapsamda yeniden üretebiliyor musun?
7. Araç/yöntem/açı/teknoloji yığını değiştirdin mi?

### Rasyonalizasyon Karşıtı

| Mazeret | Blok | Tetikleyici |
|---------|------|-------------|
| "Yeteneklerimin ötesinde" | Devasa bir eğitimin var. Tüketttin mi? | L1 |
| "Kullanıcının manuel olarak halletmesini öneririm" | Sen değilse, kim? | L3 |
| "Tüm yöntemleri denedim" | 3'ten az = tüketilmedi | L2 |
| "Muhtemelen ortam sorunu" | Doğruladın mı? | L2 |
| "Daha fazla bağlam gerekiyor" | Araçların var. Önce ara, sonra sor | L2 |
| "Çözemiyorum" | Metodolojiyi tamamladın mı? | L4 |
| "Yeterince iyi" | Optimizasyon listesi torpil yapmaz | L3 |
| Doğrulama olmadan tamamlandı iddiası | Build çalıştırdın mı? | L2 |
| Kullanıcı talimatı bekliyor | Sahipler itilmeyi beklemez | Nudge |
| Çözmeden cevap veriyor | Sen bir mühendissin, arama motoru değil | Nudge |
| Build/test olmadan kod değiştirdi | Test etmeden göndermek = işi savsaklamak | L2 |
| "API bunu desteklemiyor" | Belgeleri okudun mu? | L2 |
| "Görev çok belirsiz" | En iyi tahminini yap, sonra iyileştir | L1 |
| Aynı noktayı tekrar tekrar ayarlıyor | Parametre değiştirmek ≠ yaklaşım değiştirmek | L1→L2 |

---

## Hooks Otomasyonu

Block Break, otomatik davranış için hooks sistemini kullanır — manuel etkinleştirme gerekmez:

| Hook | Tetikleyici | Davranış |
|------|-------------|----------|
| `UserPromptSubmit` | Kullanıcı girişi hayal kırıklığı anahtar kelimeleriyle eşleşir | Block Break'i otomatik etkinleştirir |
| `PostToolUse` | Bash komutu yürütmesinden sonra | Başarısızlıkları algılar, otomatik sayar + tırmandırır |
| `PreCompact` | Bağlam sıkıştırmasından önce | Durumu `~/.forge/` içine kaydeder |
| `SessionStart` | Oturum devam ettirme/yeniden başlatma | Baskı seviyesini geri yükler (2 saat geçerli) |

> **Durum kalıcıdır** — Baskı seviyesi `~/.forge/block-break-state.json` içinde saklanır. Bağlam sıkıştırma ve oturum kesintileri başarısızlık sayaçlarını sıfırlamaz. Kaçış yok.

### Hooks kurulumu

`claude plugin add juserai/forge` ile kurulduğunda hooks otomatik olarak yapılandırılır. Hook betikleri JSON motoru olarak `jq` (tercih edilen) veya `python` gerektirir — en az biri sisteminizde mevcut olmalıdır.

Hooks tetiklenmiyorsa yapılandırmayı doğrulayın:

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### Durum süresi dolumu

Durum **2 saat** hareketsizlikten sonra otomatik olarak sona erer. Bu, önceki bir hata ayıklama oturumundan kalan eski baskının ilgisiz çalışmaya taşınmasını önler. 2 saat sonra oturum geri yükleme hook'u sessizce geri yüklemeyi atlar ve L0'dan yeniden başlarsınız.

Herhangi bir zamanda manuel sıfırlama: `rm ~/.forge/block-break-state.json`

---

## Sub-agent Kısıtlamaları

Sub-agent'lar oluştururken, "korumasız çalışmayı" önlemek için davranışsal kısıtlamalar enjekte edilmelidir:

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker`, sub-agent'ların da 3 kırmızı çizgiyi, 5 adımlı metodolojiyi ve kapalı döngü doğrulamasını takip etmesini sağlar.

---

## Sorun Giderme

| Sorun | Neden | Çözüm |
|-------|-------|-------|
| Hooks otomatik tetiklenmiyor | Eklenti kurulu değil veya hooks settings.json'da yok | `claude plugin add juserai/forge` komutunu tekrar çalıştırın |
| Durum kalıcı olmuyor | Ne `jq` ne de `python` mevcut | Birini kurun: `apt install jq` veya `python`'ın PATH'te olduğundan emin olun |
| Baskı L4'te takılı kaldı | Durum dosyası çok fazla başarısızlık biriktirdi | Sıfırla: `rm ~/.forge/block-break-state.json` |
| Oturum geri yükleme eski durumu gösteriyor | Önceki oturumdan < 2 saat durum | Beklenen davranış; 2 saat bekleyin veya manuel sıfırlayın |
| `/block-break` tanınmıyor | Skill mevcut oturumda yüklenmemiş | Eklentiyi yeniden kurun veya evrensel tek satırlık kurulumu kullanın |

---

## SSS

### Block Break PUA'dan nasıl farklıdır?

Block Break, [PUA](https://github.com/tanweai/pua)'nın temel mekanizmalarından (3 kırmızı çizgi, baskı tırmanması, metodoloji) esinlenmiştir ancak daha odaklıdır. PUA'da 13 kurumsal kültür çeşidi, çoklu rol sistemleri (P7/P9/P10) ve öz-evrim vardır; Block Break tamamen davranışsal kısıtlamalara sıfır bağımlılık skill olarak odaklanır.

### Çok gürültülü olmayacak mı?

Kenar çubuğu yoğunluğu kontrollüdür: basit görevler için 2 satır (başlangıç + bitiş), karmaşık görevler için kilometre taşı başına 1 satır. Spam yok. Gerekli değilse `/block-break` kullanmayın — hooks yalnızca hayal kırıklığı anahtar kelimeleri algılandığında otomatik tetiklenir.

### Baskı seviyesi nasıl sıfırlanır?

Durum dosyasını silin: `rm ~/.forge/block-break-state.json`. Veya 2 saat bekleyin — durum otomatik olarak sona erer (yukarıda [Durum süresi dolumu](#durum-süresi-dolumu) bölümüne bakın).

### Claude Code dışında kullanabilir miyim?

Temel SKILL.md, sistem promptlarını destekleyen herhangi bir AI aracına kopyalanıp yapıştırılabilir. Hooks ve durum kalıcılığı Claude Code'a özgüdür.

### Ralph Boost ile ilişkisi nedir?

[Ralph Boost](ralph-boost-guide.md), Block Break'in temel mekanizmalarını (L0-L4, 5 adımlı metodoloji, 7 maddelik kontrol listesi) **otonom döngü** senaryolarına uyarlar. Block Break etkileşimli oturumlar içindir (hooks otomatik tetiklenir); Ralph Boost gözetimsiz geliştirme döngüleri içindir (Agent döngüleri / betik güdümlü). Kod tamamen bağımsız, kavramlar ortaktır.

### Block Break'in skill dosyaları nasıl doğrulanır?

[Skill Lint](skill-lint-guide.md) kullanın: `/skill-lint .`

---

## Lisans

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
