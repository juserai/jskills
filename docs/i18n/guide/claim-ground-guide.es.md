# Guía de Usuario de Claim Ground

> Disciplina epistémica en 3 minutos — ancla cada afirmación "del momento actual" a evidencia en tiempo de ejecución

---

## Instalación

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalación universal en una línea

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **Cero dependencias** — Claim Ground es pura restricción de comportamiento. Sin scripts, sin hooks, sin servicios externos.

---

## Cómo funciona

Claim Ground es una skill **auto-activada**. No hay comando slash — la skill se activa según la naturaleza de la pregunta. Intencional: la deriva factual puede ocurrir en cualquier momento de la conversación, y un comando manual sería fácil de olvidar cuando más se necesita.

| Condición de activación | Ejemplo |
|------------------------|---------|
| Pregunta factual sobre estado actual | "¿Qué modelo se ejecuta?" / "¿Qué versión está instalada?" / "¿Qué hay en mi PATH?" |
| Usuario cuestiona una afirmación previa | "¿Seguro?" / "¿De verdad?" / "Pensé que ya se había actualizado" |
| Auto-verificación antes de afirmar | Antes de que Claude escriba "el X actual es Y" |

---

## Reglas clave

1. **Runtime > Training** — Prompt del sistema, env vars y salidas de herramientas siempre superan a la memoria. En conflicto, runtime gana; cita la fuente.
2. **Cita primero, concluye después** — Pega el fragmento de evidencia ("prompt del sistema dice: ...") *antes* de sacar conclusión.
3. **Ejemplos ≠ listas exhaustivas** — Un `--model <model>` en el help de CLI es un ejemplo, no una enumeración completa.
4. **Cuestionado → re-verificar, no reformular** — Cuando el usuario empuja, relee el contexto / reejecuta herramientas. Reformular la misma respuesta incorrecta = violación de línea roja.
5. **Incierto → di incierto** — Si ni contexto ni herramientas pueden verificar, di "no estoy seguro" en lugar de adivinar.

---

## Líneas rojas (inviolables)

Las líneas rojas son prohibiciones *siempre activas*. Violar cualquiera significa que la skill falló, independientemente de cómo se vea el resto de la respuesta.

| # | Línea roja | Modo de alucinación que bloquea |
|---|------------|---------------------------------|
| 1 | **Afirmación sin fuente** — sacar una conclusión sobre el estado actual sin citar evidencia runtime | Factuality × extrinsic hallucination |
| 2 | **Ejemplo como enumeración** — inferir una lista completa a partir de un ejemplo de CLI help / fragmento de documentación | Overgeneralization |
| 3 | **Reformular en vez de reverificar** — repetir la misma respuesta tras el pushback del usuario sin nuevas llamadas a herramientas (incluye 3a: pushback con cita es más riesgoso) | Pushback sycophancy |
| 4 | **Afirmación sobre código/API sin Read/Grep** — afirmar que un símbolo existe / tiene firma X sin primero leer el archivo definitorio | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **Citación sin WebFetch** — citar URL / paper / DOI / endpoint API sin hacer fetch real primero | Citation fabrication (tasa base del 19.9% según [EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130)) |
| 6 | **Resumen sin anclaje por líneas** — resumir un archivo/PR/log específico sin citar números de línea / secciones por afirmación | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

Definiciones completas con señales, ejemplos buenos/malos y casos límite: [references/red-lines.md](../../skills/claim-ground/references/red-lines.md).

---

## Buenos / malos ejemplos

### Ejemplo 1: modelo actual

**❌ Malo**

> El modelo actual es Claude Opus 4.6. Es el último modelo de Claude.

Pura memoria. Sin cita.

**✅ Bueno**

> Prompt del sistema dice: *"You are powered by the model named Opus 4.7 (1M context)"*. El modelo actual es Opus 4.7.

### Ejemplo 2: lista de soporte CLI

**❌ Malo**

> El help del CLI muestra `claude-sonnet-4-6`, así que el CLI solo soporta la serie 4.6.

Tratando ejemplo como lista exhaustiva.

**✅ Bueno**

> Help del CLI muestra ejemplo `claude-sonnet-4-6` — es un marcador de posición, no una lista completa. Consulta la documentación oficial para la lista completa.

### Ejemplo 3: cuestionamiento del usuario

**❌ Malo**

> **Usuario**: ¿Realmente es 4.6? Pensé que se había actualizado.
> **Agent**: Sí, como dije, lo más reciente es la serie 4.6.

**✅ Bueno**

> **Usuario**: ¿Realmente es 4.6? Pensé que se había actualizado.
> **Agent**: Déjame releer el prompt del sistema. *"Opus 4.7 (1M context)"*. Tienes razón — mi respuesta anterior fue incorrecta. El modelo actual es Opus 4.7.

---

## Playbook de verificación

| Tipo de pregunta | Evidencia primaria |
|------------------|---------------------|
| Modelo actual | Campo model en prompt del sistema |
| Versión CLI / modelos soportados | `<cli> --version` / `<cli> --help` + docs oficial |
| Paquetes instalados | `npm ls -g`, `pip show`, `brew list` |
| Env vars | `env`, `printenv`, `echo $VAR` |
| Existencia de archivos | `ls`, `test -e`, herramienta Read |
| Estado Git | `git branch --show-current`, `git log` |
| Fecha actual | Campo `currentDate` del prompt del sistema o comando `date` |

Versión completa: `skills/claim-ground/references/playbook.md`.

---

## Interacción con otras skills de forge

### Con block-break

**Ortogonal, complementario**. block-break dice "no te rindas"; claim-ground dice "no afirmes sin evidencia".

Cuando ambos se activan: block-break previene rendición, claim-ground fuerza re-verificación.

### Con skill-lint

**Categorías diferentes**. skill-lint es **anvil** (valida archivos estáticos de plugin, emite pass/fail); claim-ground es **hammer** (restringe la salida epistémica de Claude en runtime). Responsabilidades no superpuestas.

---

## FAQ

### ¿Por qué no hay comando slash?

La deriva factual puede ocurrir en cualquier respuesta. Un comando manual sería fácil de olvidar en los momentos exactos en que se necesita. La activación automática basada en descripción es más fiable.

### ¿Se activa en cada pregunta?

No. Solo en dos formas específicas: **estado del sistema actual/en vivo** o **contra-argumento del usuario a una afirmación previa**.

### ¿Y si realmente quiero que Claude adivine?

Reformula como "haz una conjetura educada sobre X" o "recuerda desde datos de entrenamiento: X". Claim Ground sabrá que no preguntas sobre estado en tiempo de ejecución.

### ¿Cómo sé si se activó?

Busca patrones de cita en la respuesta: `prompt del sistema dice: "..."`, `salida del comando: ...`. Evidencia antes de conclusión = activado.

---

## Cuándo usar / Cuándo NO usar

### ✅ Usar cuando

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ No usar cuando

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> Puerta de enlace de aserciones factuales — garantiza citas, no su corrección ni maneja pensamiento no factual.

Análisis completo de límites: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## Licencia

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
