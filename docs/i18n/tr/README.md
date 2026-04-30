# Forge

> Daha çok çalış, sonra bir mola ver. Claude Code ile daha iyi bir kodlama ritmi için 8 skill.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-8-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../../README.md) | [中文](../zh-CN/README.md) | [日本語](../ja/README.md) | [한국어](../ko/README.md) | [Español](../es/README.md) | [Português](../pt-BR/README.md) | [Français](../fr/README.md) | [Deutsch](../de/README.md) | [Русский](../ru/README.md) | [हिन्दी](../hi/README.md) | [Türkçe](README.md) | [Tiếng Việt](../vi/README.md)

### Hızlı Demo

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## Kurulum

```bash
# Claude Code (tek komut)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skill'ler

> Her skill, kullanım kartını göstermek için `/<skill> help` (ve `--help`) komutunu destekler. Zorunlu argümanı olan skill'ler, argümansız çağrıldıklarında da yardımı gösterir.

### Hammer

| Skill | Ne yapar | Dene |
|-------|----------|------|
| **block-break** | Pes etmeden önce tüm yaklaşımları denemeye zorlar | `/block-break` |
| **ralph-boost** | Yakınsama garantili otonom geliştirme döngüleri | `/ralph-boost setup` |
| **claim-ground** | Her "şu anki" iddiayı runtime kanıtına bağlar | otomatik tetikleme |

### Crucible

| Skill | Ne yapar | Dene |
|-------|----------|------|
| **council-fuse** | Daha iyi yanıtlar için çok perspektifli müzakere | `/council-fuse <question>` |
| **insight-fuse** | skeleton.yaml veri sözleşmeli 7 aşamalı araştırma motoru ve 6 boyutlu kalite rubriği | `/insight-fuse <topic>` |
| **tome-forge** | LLM derlemeli wiki ile kişisel bilgi tabanı | `/tome-forge init` |

### Anvil

| Skill | Ne yapar | Dene |
|-------|----------|------|
| **skill-lint** | Herhangi bir Claude Code skill plugin'ini doğrular | `/skill-lint .` |

### Quench

| Skill | Ne yapar | Dene |
|-------|----------|------|
| **news-fetch** | Kodlama seansları arasında hızlı haber özeti | `/news-fetch AI today` |

---

## Block Break — Davranış Kısıtlama Motoru

Yapay zekan pes mi etti? `/block-break` önce tüm yaklaşımları tüketmesini zorlar.

Claude takıldığında, Block Break erken teslimiyeti önleyen bir baskı yükseltme sistemi devreye sokar. Agent'ı herhangi bir "bunu yapamıyorum" yanıtına izin vermeden önce giderek daha sıkı problem çözme aşamalarından geçmeye zorlar.

| Mekanizma | Açıklama |
|-----------|----------|
| **3 Kırmızı Çizgi** | Kapalı döngü doğrulama / Gerçek odaklı / Tüm seçenekleri tüket |
| **Baskı Yükseltme** | L0 Güven → L1 Hayal Kırıklığı → L2 Sorgulama → L3 Performans Değerlendirmesi → L4 Mezuniyet |
| **5 Adım Yöntemi** | Koku al → Saçını yol → Ayna tut → Yeni yaklaşım → Retrospektif |
| **7 Maddelik Kontrol Listesi** | L3+ seviyesinde zorunlu tanı kontrol listesi |
| **Rasyonalizasyon Önleme** | 14 yaygın mazeret kalıbını tespit edip engeller |
| **Hook'lar** | Otomatik hayal kırıklığı tespiti + başarısızlık sayacı + durum kalıcılığı |

```text
/block-break              # Block Break modunu etkinleştir
/block-break L2           # Belirli bir baskı seviyesinden başla
/block-break fix the bug  # Etkinleştir ve hemen bir göreve başla
```

Doğal dil ile de tetiklenir: `try harder`, `stop spinning`, `figure it out`, `you keep failing` vb. (hook'lar tarafından otomatik algılanır).

> [PUA](https://github.com/tanweai/pua)'dan ilham alınmıştır, sıfır bağımlılıklı bir skill'e dönüştürülmüştür.

## Ralph Boost — Otonom Geliştirme Döngüsü Motoru

Gerçekten yakınsayan otonom geliştirme döngüleri. 30 saniyede kurulum.

ralph-claude-code'un otonom döngü yeteneğini bir skill olarak yeniden üretir; yakınsamayı garanti etmek için dahili Block Break L0-L4 baskı yükseltmesi içerir. Otonom döngülerdeki "ilerleme olmadan dönüp durma" sorununu çözer.

| Özellik | Açıklama |
|---------|----------|
| **Çift Yollu Döngü** | Agent döngüsü (birincil, sıfır harici bağımlılık) + bash script yedek (jq/python motorları) |
| **Gelişmiş Devre Kesici** | Dahili L0-L4 baskı yükseltme: "3 turda pes et"ten "6-7 tur kademeli kurtarma"ya |
| **Durum Takibi** | Devre kesici + baskı + strateji + oturum için birleşik state.json |
| **Zarif Devir Teslim** | L4, ham çökme yerine yapılandırılmış devir teslim raporu üretir |
| **Bağımsız** | `.ralph-boost/` dizinini kullanır, ralph-claude-code'a bağımlılık yok |

```text
/ralph-boost setup        # Projeyi başlat
/ralph-boost run          # Otonom döngüyü başlat
/ralph-boost status       # Mevcut durumu kontrol et
/ralph-boost clean        # Temizle
```

> [ralph-claude-code](https://github.com/frankbria/ralph-claude-code)'dan ilham alınmıştır, yakınsama garantili sıfır bağımlılıklı bir skill olarak yeniden tasarlanmıştır.

## Claim Ground — Epistemik Kısıtlama Motoru

Eski eğitim olgularından halüsinasyonu durdur. `claim-ground` her "şu anki" iddiayı runtime kanıtına bağlar.

Otomatik tetiklenir (slash komutu yok). Claude mevcut durumla ilgili olgusal sorulara cevap vermek üzereyken — çalışan model, kurulu araçlar, env vars, yapılandırma değerleri — veya kullanıcı önceki bir iddiaya itiraz ettiğinde, Claim Ground sonuç çıkarmadan **önce** sistem promptu / tool çıktısı / dosya içeriğinin alıntılanmasını zorunlu kılar. İtiraz edildiğinde Claude yeniden ifade etmek yerine yeniden doğrular.

| Mekanizma | Açıklama |
|-----------|----------|
| **3 Kırmızı Çizgi** | Kaynağı olmayan iddia yok / Örneği kapsayıcı sayma yok / İtiraza yeniden ifadeyle cevap yok |
| **Runtime > Training** | Sistem promptu, env ve tool çıktısı her zaman eğitim hafızasından üstün |
| **Önce-alıntıla-sonra-sonuçlandır** | Her sonuçtan önce ham kanıt parçası inline alıntılanır |
| **Doğrulama Playbook** | Soru türü → kanıt kaynağı (model / CLI / paketler / env / dosyalar / git / tarih) |

Tetikleme örnekleri (description tarafından otomatik tespit):

- "Hangi model çalışıyor?" / "What model is running?"
- "X'in hangi sürümü kurulu?"
- "Gerçekten mi? / Emin misin? / Güncellendi sanıyordum"

block-break ile dikey çalışır: ikisi de aktifken, block-break "pes ediyorum"u engeller, claim-ground "sadece yanlış cevabımı yeniden ifade ettim"i engeller.

## Council Fuse — Çok Perspektifli Müzakere Motoru

Yapılandırılmış tartışmalarla daha iyi yanıtlar. `/council-fuse` 3 bağımsız perspektif üretir, anonim olarak değerlendirir ve en iyi yanıtı sentezler.

[Karpathy'nin LLM Council](https://github.com/karpathy/llm-council)'ından ilham alınmıştır — tek bir komuta yoğunlaştırılmıştır.

| Mekanizma | Açıklama |
|-----------|----------|
| **3 Perspektif** | Generalist (dengeli) / Kritik (karşıt) / Uzman (derin teknik) |
| **Anonim Değerlendirme** | 4 boyutlu değerlendirme: Doğruluk, Bütünlük, Pratiklik, Netlik |
| **Sentez** | En yüksek puanlı yanıt iskelet olarak, benzersiz içgörülerle zenginleştirilmiş |
| **Azınlık Görüşü** | Geçerli itirazlar korunur, bastırılmaz |

```text
/council-fuse Mikroservisleri kullanmalı mıyız?
/council-fuse Bu hata işleme kalıbını incele
/council-fuse Redis vs PostgreSQL iş kuyruğu için
```

## Insight Fuse — Sistematik Çok Kaynaklı Araştırma Motoru (v3)

Konudan profesyonel araştırma raporuna. `/insight-fuse`, veri sözleşmesi olarak `skeleton.yaml` ile 7 aşamalı bir boru hattı çalıştırır: brainstorm → scan → align → research → review → deep dive → QA.

Yerleşik çok perspektifli analiz, 6 araştırma türü ön ayarı (overview / technology / market / academic / product / competitive), 5 çıktı formatı (report / checklist / ADR / decision-tree / PoC) ve 14 engelleyici kontrol içeren 6 boyutlu kalite rubriği. council-fuse'un fuse serisi kardeşi — council-fuse bilinen bilgiyi tartışırken, insight-fuse aktif olarak yeni bilgi toplar ve sentezler.

| Mekanizma | Açıklama |
|-----------|----------|
| **7 aşamalı boru hattı** | Brainstorm (iskelet) → Scan → Align → Research → Review → Deep Dive → QA |
| **Araştırma türleri** | overview / technology / market / academic / product / competitive — ön ayar paketi (şablon + perspektifler + özel kontroller) |
| **Yapılandırılabilir derinlik** | quick / standard / deep / full — quick Stage 2-5'i atlar; full 7 aşamayı etkileşimli kapılarla çalıştırır |
| **Skeleton.yaml** | Her stage tarafından tüketilen 7 alanlı veri sözleşmesi (dimensions / taxonomies / out_of_scope / existing_consensus / known_dissensus / hypotheses / business_neutral) |
| **Kalite rubriği** | 6 boyutlu puan (yanlışlanabilirlik / kanıt yoğunluğu / tekrarlanabilirlik / kaynak çeşitliliği / eyleme geçirilebilirlik / şeffaflık) + 14 engelleyici kontrol + A/B/C/D notu |
| **Çoklu bölüm** | report / checklist / ADR / decision-tree / PoC — `--sections` bölümleri seçer; varsayılan olarak her biri kendi `.md` dosyası olarak üretilir, `--merge` hepsini tek dosyada birleştirir |

```text
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling" --type technology --sections report,adr,poc
/insight-fuse "Kubernetes autoscaling" --type technology --sections report,adr,poc --merge
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI Native landscape" --type overview --depth full --audience "new entrants"
```

## Tome Forge — Kişisel Bilgi Tabanı Motoru

LLM tarafından derlenen ve bakımı yapılan kişisel bilgi tabanı oluşturun. [Karpathy'nin LLM Wiki kalıbına](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) dayalıdır — ham Markdown yapılandırılmış wiki'ye derlenir, RAG veya vektör veritabanı yok.

| Özellik | Açıklama |
|---------|----------|
| **Üç Katmanlı Mimari** | Ham kaynaklar (değiştirilemez) / Wiki (LLM-derlemeli) / Şema (CLAUDE.md) |
| **6 İşlem** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | İnsan içgörüleri için kutsal bölüm — LLM asla üzerine yazmaz |
| **Sıfır Altyapı** | Saf Markdown + Git. Veritabanı, gömme veya sunucu yok |

```text
/tome-forge init              # Mevcut dizinde BT başlat
/tome-forge capture "idea"    # Hızlı not yakala
/tome-forge ingest raw/paper  # Ham materyali wiki'ye derle
/tome-forge query "question"  # Ara ve sentezle
/tome-forge lint              # Wiki yapısı sağlık kontrolü
/tome-forge compile           # Tüm yeni materyalleri toplu derle
```

> [Karpathy'nin LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)'sinden ilham alınmıştır, sıfır bağımlılıklı bir skill olarak oluşturulmuştur.

## Skill Lint — Skill Plugin Doğrulayıcı

Claude Code plugin'lerini tek komutla doğrula.

Herhangi bir Claude Code plugin projesindeki skill dosyalarının yapısal bütünlüğünü ve anlamsal kalitesini kontrol eder. Bash scriptleri yapısal kontrolleri, AI anlamsal kontrolleri üstlenir — tamamlayıcı kapsam.

| Kontrol Türü | Açıklama |
|--------------|----------|
| **Yapısal** | Frontmatter zorunlu alanları / dosya varlığı / referans bağlantıları / marketplace girdileri |
| **Anlamsal** | Açıklama kalitesi / isim tutarlılığı / komut yönlendirme / eval kapsamı |

```text
/skill-lint              # Kullanımı göster
/skill-lint .            # Mevcut projeyi doğrula
/skill-lint /path/to/plugin  # Belirli bir yolu doğrula
```

## News Fetch — Sprint'ler Arasında Zihinsel Molan

Hata ayıklamaktan tükendin mi? `/news-fetch` — 2 dakikalık zihinsel molan.

Diğer skill'ler seni daha çok çalışmaya zorlar. Bu skill nefes almayı hatırlatır. Herhangi bir konudaki son haberleri doğrudan terminalden al — bağlam değişikliği yok, tarayıcı tavşan delikleri yok. Hızlı bir göz at ve tazelenmiş olarak işe geri dön.

| Özellik | Açıklama |
|---------|----------|
| **3 Kademeli Yedekleme** | L1 WebSearch → L2 WebFetch (bölgesel kaynaklar) → L3 curl |
| **Tekilleştirme ve Birleştirme** | Birden fazla kaynaktan aynı olay otomatik birleştirilir, en yüksek puanlı tutulur |
| **Alaka Puanlama** | AI konu eşleşmesine göre puanlar ve sıralar |
| **Otomatik Özet** | Eksik özetler makale gövdesinden otomatik oluşturulur |

```text
/news-fetch AI                    # Bu haftanın AI haberleri
/news-fetch AI today              # Bugünün AI haberleri
/news-fetch robotics month        # Bu ayın robotik haberleri
/news-fetch climate 2026-03-01~2026-03-31  # Özel tarih aralığı
```

## Kalite

- Skill başına 10+ değerlendirme senaryosu ve otomatik tetikleme testleri
- Kendi skill-lint'i tarafından doğrulanmıştır
- Sıfır harici bağımlılık — sıfır risk
- MIT lisanslı, tamamen açık kaynak

## Proje Yapısı

```text
forge/
├── skills/                        # Claude Code platformu
│   └── <skill>/
│       ├── SKILL.md               # Skill tanımı
│       ├── references/            # Detaylı içerik (ihtiyaç halinde yüklenir)
│       ├── scripts/               # Yardımcı scriptler
│       ├── agents/                # Sub-agent tanımları
│       └── hooks/                 # Skill başına Claude Code hook'ları (yalnızca hook-owner skill'ler)
├── platforms/                     # Diğer platform adaptasyonları
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw adaptasyonu
│           ├── references/        # Platforma özel içerik
│           └── scripts/           # Platforma özel scriptler
├── .claude-plugin/                # Claude Code marketplace meta verisi
├── evals/                         # Platformlar arası değerlendirme senaryoları
├── docs/
│   ├── user-guide/                # Kullanıcı kılavuzları (İngilizce)
│   ├── dev-guide/                 # Geliştirici dokümantasyonu
│   ├── design/<category>/         # 4 kategoriye göre tasarım belgeleri
│   └── i18n/<lang>/               # Çeviriler (README + skill kılavuzları)
├── openspec/                      # Evrim meta-deposu
│   ├── specs/<capability>/        # Yatay yetenek sözleşmeleri
│   └── changes/<id>/              # Aktif RFC'ler (tamamlananlar archive/)
└── plugin.json                    # Koleksiyon meta verisi
```

## Katkıda Bulunma

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw adaptasyonu + references/scripts (yayın sözleşmesi için [platform-parity](../../../openspec/specs/platform-parity/spec.md) bakın)
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Değerlendirme senaryoları
4. `.claude-plugin/marketplace.json` — `plugins` dizisine giriş ekle
5. Gerekirse hook ekle: `skills/<name>/hooks/hooks.json` + scriptler oluştur; marketplace.json'daki `source` `./skills/<name>`'i göstermeli

Tam geliştirme yönergeleri için [CLAUDE.md](../../../CLAUDE.md) dosyasına bak.

## Lisans

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
