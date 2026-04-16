# Skill Lint Kullanıcı Kılavuzu

> 3 dakikada başlayın — Claude Code skill kalitesini doğrulayın

---

## Kurulum

### Claude Code (önerilen)

```bash
claude plugin add juserai/forge
```

### Evrensel tek satır kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **Sıfır bağımlılık** — Skill Lint harici servis veya API gerektirmez. Kurun ve başlayın.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanılır |
|-------|----------|-------------------|
| `/skill-lint` | Kullanım bilgilerini göster | Mevcut kontrolleri görüntüle |
| `/skill-lint .` | Mevcut projeyi kontrol et | Geliştirme sırasında öz-kontrol |
| `/skill-lint /path/to/plugin` | Belirli bir yolu kontrol et | Başka bir eklentiyi incele |

---

## Kullanım Senaryoları

### Yeni skill oluşturduktan sonra öz-kontrol

`skills/<name>/SKILL.md`, `commands/<name>.md` ve ilgili dosyaları oluşturduktan sonra, yapının eksiksiz olduğunu, frontmatter'ın doğru olduğunu ve marketplace kaydının eklendiğini onaylamak için `/skill-lint .` çalıştırın.

### Başka birinin eklentisini inceleme

Bir PR'ı incelerken veya başka bir eklentiyi denetlerken, dosya eksiksizliği ve tutarlılığı için hızlı bir kontrol yapmak üzere `/skill-lint /path/to/plugin` kullanın.

### CI entegrasyonu

`scripts/skill-lint.sh` doğrudan bir CI pipeline'ında çalıştırılabilir ve otomatik ayrıştırma için JSON çıktısı verir:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Kontrol Öğeleri

### Yapısal Kontroller (Bash betiği tarafından yürütülür)

| Kural | Neyi kontrol eder | Önem derecesi |
|-------|-------------------|--------------|
| S01 | `plugin.json` hem kök dizinde hem de `.claude-plugin/` içinde mevcut | error |
| S02 | `.claude-plugin/marketplace.json` mevcut | error |
| S03 | Her `skills/<name>/` bir `SKILL.md` içeriyor | error |
| S04 | SKILL.md frontmatter'ı `name` ve `description` içeriyor | error |
| S05 | Her skill'in karşılık gelen bir `commands/<name>.md` dosyası var | warning |
| S06 | Her skill marketplace.json `plugins` dizisinde listelenmiş | warning |
| S07 | SKILL.md'de atıfta bulunulan referans dosyaları gerçekten mevcut | error |
| S08 | `evals/<name>/scenarios.md` mevcut | warning |

### Anlamsal Kontroller (AI tarafından yürütülür)

| Kural | Neyi kontrol eder | Önem derecesi |
|-------|-------------------|--------------|
| M01 | Açıklama amacı ve tetikleme koşullarını açıkça belirtiyor | warning |
| M02 | Ad, dizin adıyla eşleşiyor; açıklama dosyalar arasında tutarlı | warning |
| M03 | Komut yönlendirme mantığı skill adını doğru referans ediyor | warning |
| M04 | Referans içeriği SKILL.md ile mantıksal olarak tutarlı | warning |
| M05 | Değerlendirme senaryoları temel işlevsellik yollarını kapsıyor (en az 5) | warning |

---

## Beklenen Çıktı Örnekleri

### Tüm kontroller geçti

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### Sorunlar bulundu

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## İş Akışı

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## SSS

### Anlamsal kontroller olmadan sadece yapısal kontrolleri çalıştırabilir miyim?

Evet — bash betiğini doğrudan çalıştırın:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Bu, AI anlamsal analizi olmadan saf JSON çıktısı verir.

### forge olmayan projelerde çalışır mı?

Evet. Standart Claude Code eklenti yapısını (`skills/`, `commands/`, `.claude-plugin/`) takip eden herhangi bir dizin doğrulanabilir.

### Hatalar ve uyarılar arasındaki fark nedir?

- **error**: Skill'in doğru şekilde yüklenmesini veya yayınlanmasını engelleyecek yapısal sorunlar
- **warning**: İşlevselliği bozmayan ancak sürdürülebilirliği ve keşfedilebilirliği etkileyen kalite sorunları

### Diğer forge araçları

Skill Lint, forge koleksiyonunun bir parçasıdır ve bu skill'lerle iyi çalışır:

- [Block Break](block-break-guide.md) — AI'ı her yaklaşımı tüketmeye zorlayan yüksek etkenlikli davranışsal kısıtlama motoru
- [Ralph Boost](ralph-boost-guide.md) — Yerleşik Block Break yakınsama garantileri ile otonom geliştirme döngüsü motoru

Yeni bir skill geliştirdikten sonra, yapısal eksiksizliği doğrulamak ve frontmatter, marketplace.json ve referans bağlantılarının tümünün doğru olduğunu onaylamak için `/skill-lint .` çalıştırın.

---

## Lisans

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
