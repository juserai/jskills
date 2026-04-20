# Ralph Boost Kullanıcı Kılavuzu

> 5 dakikada başlayın — AI otonom geliştirme döngünüzün durmasını önleyin

---

## Kurulum

### Claude Code (önerilen)

```bash
claude plugin add juserai/forge
```

### Evrensel tek satır kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **Sıfır bağımlılık** — Ralph Boost, ralph-claude-code, block-break veya herhangi bir harici servise bağımlı değildir. Birincil yol (Agent döngüsü) sıfır harici bağımlılığa sahiptir; yedek yol `jq` veya `python` ve `claude` CLI gerektirir.

---

## Komutlar

| Komut | İşlevi | Ne zaman kullanılır |
|-------|--------|---------------------|
| `/ralph-boost setup` | Projenizde otonom döngüyü başlatın | İlk kurulum |
| `/ralph-boost run` | Mevcut oturumda otonom döngüyü başlatın | Başlatma sonrası |
| `/ralph-boost status` | Mevcut döngü durumunu görüntüleyin | İlerlemeyi izleme |
| `/ralph-boost clean` | Döngü dosyalarını kaldırın | Temizlik |

---

## Hızlı Başlangıç

### 1. Projeyi başlatın

```text
/ralph-boost setup
```

Claude sizi şunlar için yönlendirecektir:
- Proje adını tespit etme
- Görev listesi oluşturma (fix_plan.md)
- `.ralph-boost/` dizini ve tüm yapılandırma dosyalarını oluşturma

### 2. Döngüyü başlatın

```text
/ralph-boost run
```

Claude, otonom döngüyü doğrudan mevcut oturum içinde yürütür (Agent döngü modu). Her iterasyon bir görevi yürütmek için bir alt ajan oluşturur, ana oturum ise durumu yöneten döngü kontrolcüsü olarak çalışır.

**Yedek** (başsız / gözetimsiz ortamlar):

```bash
# Ön plan
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Arka plan
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Durumu izleyin

```text
/ralph-boost status
```

Örnek çıktı:

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## Nasıl Çalışır

### Otonom Döngü

Ralph Boost iki yürütme yolu sunar:

**Birincil yol (Agent döngüsü)**: Claude, mevcut oturum içinde döngü kontrolcüsü olarak çalışır ve her iterasyonda görevleri yürütmek için bir alt ajan oluşturur. Ana oturum durumu, circuit breaker'ı ve basınç yükseltmeyi yönetir. Sıfır harici bağımlılık.

**Yedek (bash betiği)**: `boost-loop.sh`, arka planda bir döngüde `claude -p` çağrıları yürütür. JSON motoru olarak hem jq hem de python'u destekler, çalışma zamanında otomatik tespit edilir. İterasyonlar arasındaki varsayılan bekleme süresi 1 saattir (yapılandırılabilir).

Her iki yol da aynı durum yönetimini (state.json), basınç yükseltme mantığını ve BOOST_STATUS protokolünü paylaşır.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Geliştirilmiş Circuit Breaker (ralph-claude-code ile karşılaştırma)

ralph-claude-code'un circuit breaker'ı: ilerleme olmadan 3 ardışık döngüden sonra pes eder.

ralph-boost'un circuit breaker'ı: takıldığında **basıncı kademeli olarak yükseltir**, durmadan önce 6-7 döngü boyunca kendi kendini kurtarır.

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## Beklenen Çıktı Örnekleri

### L0 — Normal Yürütme

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — Yaklaşım Değiştirme

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude, önceki yaklaşımı terk edip **temelden farklı** bir şey denemeye zorlanır. Parametre ayarlama sayılmaz.

### L2 — Arama ve Hipotez Oluşturma

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude şunları yapmalıdır: hatayı kelime kelime okumak → 50+ satır bağlam aramak → 3 farklı hipotez listelemek.

### L3 — Kontrol Listesi

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude 7 maddelik kontrol listesini tamamlamalıdır (hata sinyallerini okuma, temel sorunu arama, kaynak kodu okuma, varsayımları doğrulama, ters hipotez, minimum yeniden üretim, araç/yöntem değiştirme). Tamamlanan her madde state.json'a yazılır.

### L4 — Düzenli Devir Teslim

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude minimal bir PoC oluşturur, ardından bir devir teslim raporu üretir:

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

Devir teslim tamamlandıktan sonra döngü düzenli bir şekilde kapanır. Bu "yapamam" değil — "sınır burada."

---

## Yapılandırma

`.ralph-boost/config.json`:

| Alan | Varsayılan | Açıklama |
|------|------------|----------|
| `max_calls_per_hour` | 100 | Saatlik maksimum Claude API çağrısı |
| `claude_timeout_minutes` | 15 | Bireysel çağrı başına zaman aşımı |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claude'un kullanabileceği araçlar |
| `claude_model` | "" | Model geçersiz kılma (boş = varsayılan) |
| `session_expiry_hours` | 24 | Oturum sona erme süresi |
| `no_progress_threshold` | 7 | Kapatma öncesi ilerleme olmama eşiği |
| `same_error_threshold` | 8 | Kapatma öncesi aynı hata eşiği |
| `sleep_seconds` | 3600 | İterasyonlar arası bekleme süresi (saniye) |

### Yaygın yapılandırma ayarları

**Döngüyü hızlandırma** (test için):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Araç izinlerini kısıtlama**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Belirli bir model kullanma**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Proje Dizin Yapısı

```
.ralph-boost/
├── PROMPT.md           # Geliştirme talimatları (block-break protokolü dahil)
├── fix_plan.md         # Görev listesi (Claude tarafından otomatik güncellenir)
├── config.json         # Yapılandırma
├── state.json          # Birleşik durum (circuit breaker + basınç + oturum)
├── handoff-report.md   # L4 devir teslim raporu (düzenli çıkışta oluşturulur)
├── logs/
│   ├── boost.log       # Döngü günlüğü
│   └── claude_output_*.log  # İterasyon başına çıktı
└── .gitignore          # Durum ve günlükleri yoksayar
```

Tüm dosyalar `.ralph-boost/` içinde kalır — proje kök dizininize dokunulmaz.

---

## ralph-claude-code ile İlişki

Ralph Boost, [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) için bir **bağımsız alternatiftir**, geliştirme eklentisi değildir.

| Boyut | ralph-claude-code | ralph-boost |
|-------|-------------------|-------------|
| Biçim | Bağımsız Bash aracı | Claude Code skill'i (Agent döngüsü) |
| Kurulum | `npm install` | Claude Code eklentisi |
| Kod boyutu | 2000+ satır | ~400 satır |
| Harici bağımlılıklar | jq (gerekli) | Birincil yol: sıfır; Yedek: jq veya python |
| Dizin | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Pasif (3 döngü sonra pes eder) | Aktif (L0-L4, 6-7 döngü kendi kendini kurtarma) |
| Birlikte var olma | Evet | Evet (sıfır dosya çakışması) |

Her ikisi aynı projede aynı anda kurulabilir — ayrı dizinler kullanırlar ve birbirlerini etkilemezler.

---

## Block Break ile İlişki

Ralph Boost, Block Break'in temel mekanizmalarını (basınç yükseltme, 5 adımlı metodoloji, kontrol listesi) otonom döngü senaryolarına uyarlar:

| Boyut | block-break | ralph-boost |
|-------|-------------|-------------|
| Senaryo | Etkileşimli oturumlar | Otonom döngüler |
| Etkinleştirme | Hook'lar otomatik tetiklenir | Agent döngüsü / döngü betiğine yerleşik |
| Tespit | PostToolUse hook'u | Agent döngü ilerleme tespiti / betik ilerleme tespiti |
| Kontrol | Hook ile enjekte edilen prompt'lar | Agent prompt enjeksiyonu / --append-system-prompt |
| Durum | `~/.forge/` | `.ralph-boost/state.json` |

Kod tamamen bağımsızdır; kavramlar paylaşılır.

> **Referans**: Block Break'in basınç yükseltmesi (L0-L4), 5 adımlı metodolojisi ve 7 maddelik kontrol listesi, ralph-boost'un circuit breaker'ının kavramsal temelini oluşturur. Ayrıntılar için [Block Break Kullanıcı Kılavuzu](block-break-guide.md)'na bakın.

---

## SSS

### Birincil yol ve yedek arasında nasıl seçim yaparım?

`/ralph-boost run` varsayılan olarak Agent döngüsünü (birincil yol) kullanır ve doğrudan mevcut Claude Code oturumunda çalışır. Başsız veya gözetimsiz yürütme gerektiğinde yedek bash betiğini kullanın.

### Döngü betiği nerede?

forge eklentisini kurduktan sonra, yedek betik `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh` konumundadır. Herhangi bir yere kopyalayıp oradan çalıştırabilirsiniz. Betik, JSON motoru olarak jq veya python'u otomatik tespit eder.

### Döngü günlüklerini nasıl görüntülerim?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Basınç seviyesini manuel olarak nasıl sıfırlarım?

`.ralph-boost/state.json` dosyasını düzenleyin: `pressure.level` değerini 0 ve `circuit_breaker.consecutive_no_progress` değerini 0 olarak ayarlayın. Veya state.json'ı silin ve yeniden başlatın.

### Görev listesini nasıl değiştiririm?

`.ralph-boost/fix_plan.md` dosyasını doğrudan düzenleyin, `- [ ] görev` formatını kullanın. Claude bunu her iterasyonun başında okur.

### Circuit breaker açıldıktan sonra nasıl kurtarırım?

`state.json` dosyasını düzenleyin, `circuit_breaker.state` değerini `"CLOSED"` olarak ayarlayın, ilgili sayaçları sıfırlayın ve betiği yeniden çalıştırın.

### ralph-claude-code'a ihtiyacım var mı?

Hayır. Ralph Boost tamamen bağımsızdır ve hiçbir Ralph dosyasına bağımlı değildir.

### Hangi platformlar destekleniyor?

Şu anda Claude Code (birincil yol olarak Agent döngüsü) desteklenmektedir. Yedek bash betiği bash 4+, jq veya python ve claude CLI gerektirir.

### ralph-boost'un skill dosyalarını nasıl doğrularım?

[Skill Lint](skill-lint-guide.md) kullanın: `/skill-lint .`

---

## Ne zaman kullanılmalı / Ne zaman kullanılMAMAlı

### ✅ Şu durumlarda kullanın

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ Şu durumlarda kullanmayın

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> Yakınsama garantili otonom döngü motoru — net hedefler ve stabil ortam gerektirir.

Tam sınır analizi: [references/scope-boundaries.md](../../../skills/ralph-boost/references/scope-boundaries.md)

---

## Lisans

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
