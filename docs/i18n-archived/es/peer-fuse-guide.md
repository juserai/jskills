# Guía de Peer Fuse v0.1.0

> Revisor por pares genérico para artefactos de investigación — **pipeline de 8 etapas (archivado en KB de Stage 7 obligatorio + observable, opt-out vía `--no-save`) + adaptador de entrada de 10 formatos (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, despacho de 3 niveles) + 6 presets de tipo de investigación (auto-clasificados) + rúbrica ponderada de 8 dimensiones + taxonomía de 18 flags + panel de 3 perspectivas + congelación de § Document Reading (restricción dura de aislamiento de revisión)**.

Peer-Fuse toma cualquier documento markdown / PDF / Office y produce un informe de revisión por pares en markdown con calificación A+/A−/.../D, una lista escalonada de flags de calidad, una síntesis de panel multiperspectiva y sugerencias de diff estilo patch. Coexiste con [el revisor Stage 6.5 de insight-fuse](insight-fuse-guide.md) — Stage 6.5 es revisión interna de IF sobre la misma fuente; peer-fuse es el **revisor externo cross-skill** que maneja formatos y skills que Stage 6.5 no puede.

## Inicio rápido

```bash
# Auto-clasificar tipo, profundidad por defecto, archivar a KB
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Paper académico PDF (tipo auto-detectado desde header arXiv/IEEE/Nature)
/peer-fuse papers/transformer-2017.pdf

# Deck PPTX con tipo explícito
/peer-fuse decks/q4-roadmap.pptx --type product

# Profundidad rápida (omitir panel Stage 4 + holístico Stage 5.5) + omitir archivado KB
/peer-fuse handbook.docx --depth quick --no-save

# Mostrar ayuda
/peer-fuse help
# o sin argumentos
/peer-fuse
```

## Defaults y flags

| Flag | Default | Valores |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — omite el archivado KB de Stage 7, salida solo por consola |

`--type=auto` permite a peer-fuse clasificar tras leer el documento mediante heurísticas (campo type del frontmatter → patrón de secciones → densidad de citas → pistas de formato/título → fallback overview). Ver [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) para la cadena de prioridad.

## Formatos soportados

| Tier | Requisito de herramienta | Formatos |
|:-:|---|---|
| 1 | ninguno (nativo) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` para `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Herramienta faltante → fail-soft con pista concreta de instalación (`brew install pandoc`, `apt install libreoffice`, etc.) y salida antes de Stage 1. Ver [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md).

## Lo que recibes de vuelta

Dos entregables paralelos:

1. **Revisión renderizada inline** en tu conversación, estructurada como:
   - § Document Reading — narrativa descriptiva (qué dice el documento), 3-5 párrafos, 300-600 palabras
   - § Holistic Assessment — narrativa evaluativa (metodología / fortalezas / preocupaciones / recomendación), 4 párrafos, 400-700 palabras
   - § Score Matrix — puntuaciones ponderadas de 8 dimensiones → calificación con letra
   - § Flag List — códigos de flag de la taxonomía-18 con posiciones
   - § Multi-Perspective Panel — veredictos de metodologista / adversarial / practitioner
   - § Diff Suggestions — reescrituras estilo patch para cada demérito
   - § Reconciliation — Δ entre auto-calificación objetivo vs review_grade

2. **Archivo KB** en `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` (omitir con `--no-save`). La línea de log de archivado `Archived to KB: <path>` siempre aparece en la respuesta visible al usuario.

## Restricción dura: § Document Reading está aislado de la revisión

La decisión arquitectónica más importante en peer-fuse:

**§ Document Reading no debe ser contaminada por veredictos de revisión.** Es la lectura fiel y descriptiva del documento por parte del revisor — frontmatter, estructura, afirmaciones, evidencia, alcance. Se ejecuta en Stage 3.5, **antes** del panel Stage 4 y la puntuación Stage 5, y la frontera de entrada es estricta:

- ✅ Acepta: documento original, resultados de escaneo factual de Stage 1-3
- ❌ Rechaza: veredictos del panel, puntuaciones, hits de flags

La sección queda **congelada** después de Stage 3.5: se toma un hash SHA-256 antes de Stage 4, y Stage 7 verifica el hash antes de archivar. Cualquier modificación → fail-closed. El lint también prohíbe vocabulario evaluativo (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) y literales de calificación con letra en esta sección.

Esta es la restricción dura declarada por el usuario y se hace cumplir en tres niveles: aislamiento arquitectónico + congelación write-once + lint de palabras prohibidas.

## Interacción con otros skills de forge

| Skill | Relación |
|---|---|
| **insight-fuse** revisor Stage 6.5 | Coexiste — Stage 6.5 es revisión interna de IF sobre la misma fuente (misma rúbrica, mismas heurísticas, solo markdown IF). peer-fuse es **revisión externa cross-skill** con rúbrica más amplia de 8 dimensiones, 18 flags, 10 formatos, panel de 3 agents. Ambos deberían ejecutarse para informes IF importantes. |
| **council-fuse** | Crucible hermano — peer-fuse reutiliza el patrón de despacho paralelo de sub-agents de council-fuse (el panel Stage 4 refleja Stage 1 de council-fuse). |
| **tome-forge** | Backend de archivado — Stage 7 de peer-fuse llama al report-archival-protocol de tome-forge; no reimplementa la lógica de escritura KB. |
| **skill-lint** | Hermano por patrón (categoría diferente, anvil) — ambos juzgan artefactos y emiten diagnósticos, pero skill-lint produce un diagnóstico efímero de consola mientras peer-fuse produce un artefacto persistente de revisión por pares en markdown. |

## Cuándo usar peer-fuse vs IF Stage 6.5

| Escenario | Usar |
|---|:-:|
| Acabas de ejecutar `/insight-fuse <topic>` y quieres una segunda opinión sobre el informe IF | IF Stage 6.5 ya se ejecutó inline; si quieres una revisión externa de segunda capa con preparación cross-formato, ejecuta `/peer-fuse <if-output-path>` |
| Tienes un paper de investigación PDF de terceros para evaluar | peer-fuse |
| Tienes un deck de negocio PPTX que quieres calificar | peer-fuse |
| Tienes una salida de síntesis de council-fuse que quieres calificar | peer-fuse |
| Quieres comparar múltiples artefactos con la misma rúbrica | peer-fuse (puntuación consistente entre artefactos) |

## Ejemplo concreto

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Detección Stage 0.5
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 produce § Document Reading (congelado)
# Stage 4 panel ejecuta 3 sub-agents en paralelo
# Puntuación Stage 5 → 8.6 / A-
# Evaluación holística Stage 5.5
# Sugerencias diff Stage 6: 5 bloques
# Archivado Stage 7

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

La consola renderiza la revisión completa inline; el archivo KB es la versión canónica persistente.

## Verificación

```bash
# Verificación estática
bash skills/skill-lint/scripts/skill-lint.sh .

# Test de trigger
bash evals/peer-fuse/run-trigger-test.sh

# Lockstep de hash
bash scripts/recalc-all-hashes.sh
```

## Ver también

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — definición runtime del skill
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — decisiones arquitectónicas + justificación de 4 categorías
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (después del merge)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — crucible hermano
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — crucible hermano (fuente del patrón panel)
