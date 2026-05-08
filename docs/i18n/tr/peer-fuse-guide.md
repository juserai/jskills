# Peer Fuse v0.1.0 Kılavuzu

> Araştırma yapıtları için genel amaçlı peer-reviewer — **8 aşamalı boru hattı (Stage 7 KB arşivlemesi zorunlu + gözlemlenebilir, `--no-save` ile devre dışı bırakılabilir) + 10 formatlı girdi adaptörü (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, 3 katmanlı dağıtım) + 6 araştırma türü ön ayarı (otomatik sınıflandırma) + 8 boyutlu ağırlıklı rubrik + 18 flag taksonomisi + 3 perspektifli panel + § Document Reading dondurma (review-isolation katı kısıtı)**.

Peer-Fuse herhangi bir markdown / PDF / Office belgesini alır ve A+/A−/.../D notu, kademeli kalite flag listesi, çok perspektifli panel sentezi ve patch tarzı diff önerilerinden oluşan bir peer-review markdown raporu üretir. [insight-fuse Stage 6.5 reviewer](insight-fuse-guide.md) ile birlikte var olur — Stage 6.5, IF içi aynı kaynaklı incelemedir; peer-fuse ise Stage 6.5'in ele alamadığı format ve becerileri kapsayan **çapraz-skill harici reviewer**'dır.

## Hızlı başlangıç

```bash
# Türü otomatik sınıflandır, varsayılan derinlik, KB'ye arşivle
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# PDF akademik makale (tür arXiv/IEEE/Nature başlığından otomatik algılanır)
/peer-fuse papers/transformer-2017.pdf

# Açık türle PPTX sunum
/peer-fuse decks/q4-roadmap.pptx --type product

# Hızlı derinlik (Stage 4 panel + Stage 5.5 holistik atlanır) + KB arşivini atla
/peer-fuse handbook.docx --depth quick --no-save

# Yardım göster
/peer-fuse help
# veya argümansız
/peer-fuse
```

## Varsayılanlar ve flag'ler

| Flag | Default | Values |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — Stage 7 KB arşivini atlar, yalnızca konsol çıktısı |

`--type=auto`, peer-fuse'un belgeyi okuduktan sonra sezgisel kurallarla sınıflandırmasına izin verir (frontmatter type alanı → bölüm deseni → atıf yoğunluğu → format/başlık ipuçları → fallback overview). Öncelik zinciri için bkz. [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md).

## Desteklenen formatlar

| Tier | Tool requirement | Formats |
|:-:|---|---|
| 1 | none (native) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` for `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Eksik araç → somut kurulum ipucuyla (`brew install pandoc`, `apt install libreoffice`, vb.) fail-soft ve Stage 1 öncesi çıkış. Bkz. [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md).

## Geri alacaklarınız

İki paralel teslimat:

1. Konuşmanızda **satır içi render edilmiş inceleme**, şu yapıda:
   - § Document Reading — betimleyici anlatı (belgenin ne söylediği), 3-5 paragraf, 300-600 kelime
   - § Holistic Assessment — değerlendirici anlatı (yöntem / güçlü yönler / endişeler / öneri), 4 paragraf, 400-700 kelime
   - § Score Matrix — 8 boyutlu ağırlıklı puanlar → harf notu
   - § Flag List — 18 taksonomisinden flag kodları ve konumları
   - § Multi-Perspective Panel — methodologist / adversarial / practitioner verdict'leri
   - § Diff Suggestions — her demerit için patch tarzı yeniden yazımlar
   - § Reconciliation — hedef self-grade vs review_grade Δ

2. **KB arşivi** `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` konumunda (`--no-save` ile atlanır). Arşiv log satırı `Archived to KB: <path>` her zaman kullanıcıya görünen yanıtta belirir.

## Katı kısıt: § Document Reading review-isolated'dır

Peer-fuse'taki en önemli mimari karar:

**§ Document Reading review verdict'leri tarafından kirletilemez.** Bu, reviewer'ın belgenin sadık, betimleyici okumasıdır — frontmatter, yapı, iddialar, kanıt, kapsam. Stage 3.5'te, Stage 4 panel ve Stage 5 puanlamasının **öncesinde** çalışır ve girdi sınırı katıdır:

- ✅ Kabul eder: orijinal belge, Stage 1-3 olgusal tarama sonuçları
- ❌ Reddeder: panel verdict'leri, puanlar, flag isabetleri

Bölüm Stage 3.5'ten sonra **dondurulur**: Stage 4 öncesi SHA-256 hash alınır ve Stage 7 arşivden önce hash'i doğrular. Herhangi bir değişiklik → fail-closed. Lint ayrıca bu bölümden değerlendirici sözcükleri (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) ve harf-notu literal'larını yasaklar.

Bu, kullanıcı tarafından belirtilen katı kısıttır ve üç düzeyde uygulanır: mimari izolasyon + write-once dondurma + yasaklı kelime lint'i.

## Diğer forge skill'leri ile etkileşim

| Skill | İlişki |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | Birlikte var olur — Stage 6.5, IF içi aynı kaynaklı incelemedir (aynı rubrik, aynı sezgiseller, yalnızca IF markdown). peer-fuse ise daha geniş 8 boyutlu rubrik, 18 flag, 10 format, 3 agent panel ile **çapraz-skill harici inceleme**dir. Önemli IF raporları için her ikisi de çalıştırılmalıdır. |
| **council-fuse** | Kardeş crucible — peer-fuse, council-fuse'un paralel sub-agent dağıtım desenini yeniden kullanır (Stage 4 panel, council-fuse Stage 1'i yansıtır). |
| **tome-forge** | Arşiv backend'i — peer-fuse Stage 7, tome-forge'un report-archival-protocol'ünü çağırır; KB yazma mantığını yeniden uygulamaz. |
| **skill-lint** | Desen olarak kardeş (farklı kategori, anvil) — her ikisi de yapıtları yargılar ve diagnostic yayar, ancak skill-lint geçici konsol diagnostic'i çıkarır, peer-fuse ise kalıcı bir markdown peer-review yapıtı çıkarır. |

## Peer-fuse vs IF Stage 6.5 ne zaman kullanılır

| Senaryo | Kullanılan |
|---|:-:|
| `/insight-fuse <topic>`'i yeni çalıştırdınız ve IF raporu hakkında ikinci görüş istiyorsunuz | IF Stage 6.5 satır içi olarak zaten çalıştı; çapraz-format hazır ikinci katman harici inceleme istiyorsanız `/peer-fuse <if-output-path>` çalıştırın |
| Değerlendirilecek üçüncü taraf bir PDF araştırma makaleniz var | peer-fuse |
| Notlandırılmasını istediğiniz bir PPTX iş sunumunuz var | peer-fuse |
| Notlandırılmasını istediğiniz bir council-fuse sentez çıktınız var | peer-fuse |
| Aynı rubrikte birden fazla yapıtı karşılaştırmak istiyorsunuz | peer-fuse (yapıtlar arasında tutarlı puanlama) |

## Somut örnek

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 detection
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 produces § Document Reading (frozen)
# Stage 4 panel runs 3 sub-agents in parallel
# Stage 5 scoring → 8.6 / A-
# Stage 5.5 holistic assessment
# Stage 6 diff suggestions: 5 blocks
# Stage 7 archive

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

Konsol tam incelemeyi satır içi render eder; KB arşivi kalıcı kanonik versiyondur.

## Doğrulama

```bash
# Statik kontrol
bash skills/skill-lint/scripts/skill-lint.sh .

# Tetikleyici testi
bash evals/peer-fuse/run-trigger-test.sh

# Hash lockstep
bash scripts/recalc-all-hashes.sh
```

## Ayrıca bakınız

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — runtime skill tanımı
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — mimari kararlar + 4 kategori gerekçesi
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (merge sonrası)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — kardeş crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — kardeş crucible (panel deseni kaynağı)
