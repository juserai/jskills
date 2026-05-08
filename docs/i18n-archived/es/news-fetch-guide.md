# Guía de Usuario de News Fetch

> Comienza en 3 minutos — deja que la IA obtenga tu resumen de noticias

¿Agotado de depurar? Tómate 2 minutos, ponte al día con lo que pasa en el mundo y vuelve renovado.

---

## Instalación

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalación universal de una línea

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **Sin dependencias** — News Fetch no requiere servicios externos ni claves API. Instala y listo.

---

## Comandos

| Comando | Qué hace | Cuándo usarlo |
|---------|----------|---------------|
| `/news-fetch AI` | Obtener noticias de IA de esta semana | Actualización rápida del sector |
| `/news-fetch AI today` | Obtener noticias de IA de hoy | Resumen diario |
| `/news-fetch robotics month` | Obtener noticias de robótica de este mes | Revisión mensual |
| `/news-fetch climate 2026-03-01~2026-03-31` | Obtener noticias de un rango de fechas específico | Investigación dirigida |

---

## Casos de Uso

### Resumen diario de tecnología

```
/news-fetch AI today
```

Obtén las últimas noticias de IA del día, clasificadas por relevancia. Escanea titulares y resúmenes en segundos.

### Investigación del sector

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Extrae noticias de un período específico para apoyar análisis de mercado e investigación competitiva.

### Noticias multilingües

Los temas en chino obtienen automáticamente búsquedas complementarias en inglés para una cobertura más amplia, y viceversa. Obtienes lo mejor de ambos mundos sin esfuerzo adicional.

---

## Ejemplo de Salida Esperada

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

## Respaldo de Red de 3 Niveles

News Fetch tiene una estrategia de respaldo integrada para garantizar que la obtención de noticias funcione en diferentes condiciones de red:

| Nivel | Herramienta | Fuente de Datos | Activador |
|-------|-------------|-----------------|-----------|
| **L1** | WebSearch | Google/Bing | Por defecto (preferido) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 falla |
| **L3** | Bash curl | Mismas fuentes que L2 | L2 también falla |

Cuando todos los niveles fallan, se produce un informe de fallo estructurado que lista la razón del fallo para cada fuente.

---

## Características de la Salida

| Característica | Descripción |
|----------------|-------------|
| **Deduplicación** | Cuando múltiples fuentes cubren el mismo evento, se mantiene la entrada con mayor puntuación; las demás se agrupan en "Cobertura relacionada" |
| **Completado de resumen** | Si los resultados de búsqueda carecen de resumen, se obtiene el cuerpo del artículo y se genera un resumen |
| **Puntuación de relevancia** | La IA puntúa cada resultado por relevancia temática — mayor significa más relevante |
| **Enlaces clicables** | Formato de enlace Markdown — clicable en IDEs y terminales |

---

## Puntuación de Relevancia

Cada artículo se puntúa de 0-300 basándose en qué tan bien su título y resumen coinciden con el tema solicitado:

| Rango de Puntuación | Significado |
|---------------------|-------------|
| 200-300 | Altamente relevante — el tema es el sujeto principal |
| 100-199 | Moderadamente relevante — el tema se menciona significativamente |
| 0-99 | Tangencialmente relevante — el tema aparece de pasada |

Los artículos se ordenan por puntuación en orden descendente. La puntuación es heurística y se basa en densidad de palabras clave, coincidencia de título y relevancia contextual.

## Solución de Problemas de Respaldo de Red

| Síntoma | Causa Probable | Solución |
|---------|---------------|----------|
| L1 devuelve 0 resultados | Herramienta WebSearch no disponible o consulta demasiado específica | Ampliar la palabra clave del tema |
| L2 todas las fuentes fallan | Sitios de noticias nacionales bloqueando acceso automatizado | Esperar y reintentar, o verificar si `curl` funciona manualmente |
| L3 curl tiempos de espera agotados | Problema de conectividad de red | Verificar `curl -I https://news.baidu.com` |
| Todos los niveles fallan | Sin acceso a internet o todas las fuentes caídas | Verificar red; el informe de fallos lista el error de cada fuente |

---

## Preguntas Frecuentes

### ¿Necesito una clave API?

No. News Fetch se basa completamente en WebSearch y scraping web público. No requiere configuración.

### ¿Puede obtener noticias en inglés?

Por supuesto. Los temas en chino incluyen automáticamente búsquedas complementarias en inglés, y los temas en inglés funcionan nativamente. La cobertura abarca ambos idiomas.

### ¿Qué pasa si mi red está restringida?

La estrategia de respaldo de 3 niveles maneja esto automáticamente. Incluso si WebSearch no está disponible, News Fetch recurre a fuentes de noticias nacionales.

### ¿Cuántos artículos devuelve?

Hasta 20 (después de la deduplicación). La cantidad real depende de lo que devuelvan las fuentes de datos.

---

## Cuándo usar / Cuándo NO usar

### ✅ Usar cuando

- You want a quick news brief between coding sessions
- Bilingual aggregation (English + domestic sources)
- Network-restricted environments (3-tier fallback handles blocked sources)

### ❌ No usar cuando

- You need synthesized research (use `insight-fuse` instead)
- Targeted source monitoring (use an RSS reader)
- Translation tasks (news-fetch returns source language as-is)

> Resumen de noticias para pausas de codificación — escaneo de 2 minutos, no análisis profundo ni traducción.

Análisis completo de límites: [references/scope-boundaries.md](../../../skills/news-fetch/references/scope-boundaries.md)

---

## Licencia

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
