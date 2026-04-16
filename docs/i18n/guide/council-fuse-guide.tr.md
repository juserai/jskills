# Council Fuse Kullanici Kilavuzu

> 5 dakikada baslayin — daha iyi yanitlar icin cok perspektifli muzakere

---

## Kurulum

### Claude Code (onerilen)

```bash
claude plugin add juserai/forge
```

### Evrensel tek satirlik kurulum

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **Sifir bagimlilik** — Council Fuse harici hizmet veya API gerektirmez. Kurun ve baslayin.

---

## Komutlar

| Komut | Ne yapar | Ne zaman kullanilir |
|-------|----------|---------------------|
| `/council-fuse <soru>` | Tam bir konsey muzakeresi calistir | Onemli kararlar, karmasik sorular |

---

## Nasil Calisir

Council Fuse, Karpathy'nin LLM Council kalibini tek bir komuta indirger:

### Asama 1: Toplanti

Uc ajan, her biri farkli bir bakis acisiyla **paralel olarak** olusturulur:

| Ajan | Rol | Model | Guclu yonu |
|------|-----|-------|------------|
| Genelci | Dengeli, pratik | Sonnet | Yaygin en iyi uygulamalar |
| Elestirmen | Karsi taraf, kusurlari bulur | Opus | Uc durumlar, riskler, kor noktalar |
| Uzman | Derin teknik detay | Sonnet | Uygulama hassasiyeti |

Her ajan **bagimsiz olarak** yanitlar — birbirlerinin yanitlarini goremezler.

### Asama 2: Puanlama

Baskan (ana ajan) tum yanitlari Yanit A/B/C olarak anonimlestirir, ardindan her birini 4 boyutta (0-10) puanlar:

- **Dogruluk** — olgusal dogruluk, mantiksal saglamlik
- **Butunluk** — tum yonlerin kapsanmasi
- **Pratiklik** — uygulanabilirlik, gercek dunya gecerliligi
- **Aciklik** — yapi, okunabilirlik

### Asama 3: Sentez

En yuksek puanli yanit iskelet haline gelir. Diger yanitlardan benzersiz icgoruler entegre edilir. Elestirmenin gecerli itirazlari uyarilar olarak korunur.

---

## Kullanim Alanlari

### Mimari kararlar

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

Genelci dengeli odunlesmeler sunar, elestirmen mikro hizmet modasi abartisini sorgular ve uzman goc kaliplarini detaylandirir. Sentez kosullu bir oneri sunar.

### Teknoloji secimleri

```
/council-fuse Redis vs PostgreSQL for our job queue
```

Uc farkli aci, operasyonel kaygilari (elestirmen), uygulama detaylarini (uzman) veya pragmatik varsayilani (genelci) kacirmamanizi saglar.

### Kod incelemesi

```
/council-fuse Is this error handling pattern correct? <paste code>
```

Yaygin dogrulama, karsi taraf uc durum analizi ve derin teknik dogrulamayi tek seferde alin.

---

## Cikti Yapisi

Her konsey muzakeresi sunlari uretir:

1. **Puan Matrisi** — uc perspektifin tamami icin seffaf puanlama
2. **Uzlasi Analizi** — hangi konularda hemfikir, hangi konularda degiller
3. **Sentezlenmis Yanit** — kaynasmis en iyi yanit
4. **Azinlik Gorusu** — dikkate deger gecerli muhalif gorusler

---

## Ozellestirme

### Perspektifleri degistirme

Ozel konsey uyeleri tanimlamak icin `agents/*.md` dosyalarini duzenleyin. Alternatif ucluler:

- Iyimser / Kotumser / Pragmatist
- Mimar / Uygulamaci / Testci
- Kullanici Savunucusu / Gelistirici / Guvenlik Uzmani

### Modelleri degistirme

Her ajan dosyasindaki `model:` alanini duzenleyin:

- `model: haiku` — maliyet etkin konseyler
- `model: opus` — kritik kararlar icin tam agir siklet

---

## Platformlar

| Platform | Konsey uyeleri nasil calisir |
|----------|------------------------------|
| Claude Code | 3 bagimsiz Agent olusturma paralel olarak |
| OpenClaw | Tekli ajan, 3 ardisik bagimsiz akil yurutme turu |

---

## SSS

**S: 3 kat token maliyeti olur mu?**
C: Evet, yaklasik olarak. Uc bagimsiz yanit arti sentez. Yatirimi hakli kilan kararlar icin kullanin.

**S: Daha fazla konsey uyesi ekleyebilir miyim?**
C: Cerceve bunu destekler — baska bir `agents/*.md` dosyasi ekleyin ve SKILL.md is akisini guncelleyin. Ancak maliyet-cesitlilik dengesi icin 3 en uygun noktadir.

**S: Bir ajan basarisiz olursa ne olur?**
C: Baskan o uyeye 0 puan verir ve kalan yanitlardan sentezler. Zarif bozulma, cokme yok.
