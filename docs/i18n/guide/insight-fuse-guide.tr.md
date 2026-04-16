# Insight Fuse Kullanim Kilavuzu

> Sistematik cok kaynakli arastirma motoru — Konudan profesyonel arastirma raporuna

## Hizli Baslangic

```bash
# Tam arastirma (5 asamali, manuel kontrol noktalari ile)
/insight-fuse AI Agent guvenlik riskleri

# Hizli tarama (yalnizca Stage 1)
/insight-fuse --depth quick kuantum bilisim

# Belirli bir sablon kullanma
/insight-fuse --template technology WebAssembly

# Ozel bakis acilariyla derinlemesine arastirma
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist otonom surusun ticarilesmesi
```

## Parametreler

| Parametre | Aciklama | Ornek |
|-----------|----------|-------|
| `topic` | Arastirma konusu (zorunlu) | `AI Agent guvenlik riskleri` |
| `--depth` | Arastirma derinligi | `quick` / `standard` / `deep` / `full` |
| `--template` | Rapor sablonu | `technology` / `market` / `competitive` |
| `--perspectives` | Bakis acisi listesi | `optimist,pessimist,pragmatist` |

## Derinlik Modlari

### quick — Hizli Tarama
Stage 1'i calistirir. 3+ arama sorgusu, 5+ kaynak, kisa rapor ciktisi. Bir konuyu hizlica anlamak icin uygundur.

### standard — Standart Arastirma
Stage 1 + 3'u calistirir. Alt sorulari otomatik belirler, paralel arastirma yapar, kapsamli kapsam saglar. Manuel etkilesim yoktur.

### deep — Derinlemesine Arastirma
Stage 1 + 3 + 5'i calistirir. Standart arastirma temelinde, tum alt sorulari 3 bakis acisindan derinlemesine analiz eder. Manuel etkilesim yoktur.

### full (varsayilan) — Tam Boru Hatti
Tum 5 asamayi calistirir. Stage 2 ve Stage 4, yonun dogru kaldigindan emin olmak icin manuel kontrol noktalaridir.

## Rapor Sablonlari

### Yerlesik Sablonlar

- **technology** — Teknoloji arastirmasi: mimari, karsilastirma, ekosistem, trendler
- **market** — Pazar arastirmasi: buyukluk, rekabet, kullanicilar, tahminler
- **competitive** — Rekabet analizi: ozellik matrisi, SWOT, fiyatlandirma

### Ozel Sablonlar

1. `templates/custom-example.md` dosyasini `templates/your-name.md` olarak kopyalayin
2. Bolum yapisini degistirin
3. `{topic}` ve `{date}` yer tutucularini koruyun
4. Son bolum "Referans Kaynaklar" olmalidir
5. `--template your-name` ile etkinlestirin

### Sablonsuz Mod

`--template` belirtilmediginde, ajan arastirma icerigine gore rapor yapisini uyarlanabilir sekilde olusturur.

## Cok Bakis Acili Analiz

### Varsayilan Bakis Acilari

| Bakis Acisi | Rol | Model |
|-------------|-----|-------|
| Generalist | Genis kapsam, ana akim uzlasmasi | Sonnet |
| Critic | Sorgulama, karsi kanit arama | Opus |
| Specialist | Teknik derinlik, birincil kaynaklar | Sonnet |

### Alternatif Bakis Acisi Setleri

| Senaryo | Bakis Acilari |
|---------|--------------|
| Trend tahmini | `--perspectives optimist,pessimist,pragmatist` |
| Urun arastirmasi | `--perspectives user,developer,business` |
| Politika arastirmasi | `--perspectives domestic,international,regulatory` |

### Ozel Bakis Acilari

`agents/insight-{name}.md` olusturun, mevcut ajan dosya yapisini referans alin.

## Kalite Guvencesi

Her rapor otomatik olarak kontrol edilir:
- Her bolumde en az 2 bagimsiz kaynak
- Sahipsiz referans yok
- Tek kaynak orani %40'i asmaz
- Tum karsilastirmali iddialar verilerle desteklenir

## council-fuse ile Farki

| | insight-fuse | council-fuse |
|---|---|---|
| **Amac** | Aktif arastirma + rapor olusturma | Bilinen bilgiler uzerinde cok bakis acili muzakere |
| **Bilgi Kaynagi** | WebSearch/WebFetch ile toplama | Kullanici tarafindan saglanan sorular |
| **Cikti** | Tam arastirma raporu | Sentezlenmis yanit |
| **Asamalar** | 5 asamali kademeli | 3 asamali (toplanti → degerlendirme → sentez) |

Her ikisi birlikte kullanilabilir: once insight-fuse ile arastirma yapip bilgi toplayin, ardindan council-fuse ile onemli kararlar uzerinde derinlemesine tartisma yurutun.
