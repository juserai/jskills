# Guía de usuario de Ralph Boost

> Comienza en 5 minutos — evita que tu bucle de desarrollo autónomo con IA se detenga

---

## Instalación

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalación universal en una línea

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **Sin dependencias** — Ralph Boost no depende de ralph-claude-code, block-break ni de ningún servicio externo. La ruta principal (bucle de Agent) tiene cero dependencias externas; la ruta de respaldo requiere `jq` o `python` y la CLI `claude`.

---

## Comandos

| Comando | Función | Cuándo usar |
|---------|---------|-------------|
| `/ralph-boost setup` | Inicializar el bucle autónomo en tu proyecto | Primera configuración |
| `/ralph-boost run` | Iniciar el bucle autónomo en la sesión actual | Después de la inicialización |
| `/ralph-boost status` | Ver el estado actual del bucle | Monitorear progreso |
| `/ralph-boost clean` | Eliminar archivos del bucle | Limpieza |

---

## Inicio rápido

### 1. Inicializar el proyecto

```text
/ralph-boost setup
```

Claude te guiará a través de:
- Detección del nombre del proyecto
- Generación de una lista de tareas (fix_plan.md)
- Creación del directorio `.ralph-boost/` y todos los archivos de configuración

### 2. Iniciar el bucle

```text
/ralph-boost run
```

Claude ejecuta el bucle autónomo directamente dentro de la sesión actual (modo bucle de Agent). Cada iteración genera un sub-agente para ejecutar una tarea, mientras que la sesión principal actúa como controlador del bucle gestionando el estado.

**Respaldo** (entornos sin interfaz / desatendidos):

```bash
# Primer plano
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Segundo plano
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Monitorear estado

```text
/ralph-boost status
```

Ejemplo de salida:

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

## Cómo funciona

### Bucle autónomo

Ralph Boost ofrece dos rutas de ejecución:

**Ruta principal (bucle de Agent)**: Claude actúa como controlador del bucle dentro de la sesión actual, generando un sub-agente en cada iteración para ejecutar tareas. La sesión principal gestiona el estado, el circuit breaker y la escalación de presión. Sin dependencias externas.

**Respaldo (script bash)**: `boost-loop.sh` ejecuta llamadas `claude -p` en un bucle en segundo plano. Soporta tanto jq como python como motores JSON, auto-detectados en tiempo de ejecución. La espera predeterminada entre iteraciones es de 1 hora (configurable).

Ambas rutas comparten la misma gestión de estado (state.json), lógica de escalación de presión y protocolo BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Circuit Breaker mejorado (vs ralph-claude-code)

Circuit breaker de ralph-claude-code: se rinde después de 3 bucles consecutivos sin progreso.

Circuit breaker de ralph-boost: **escala la presión progresivamente** cuando se atasca, hasta 6-7 bucles de auto-recuperación antes de detenerse.

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

## Ejemplos de salida esperada

### L0 — Ejecución normal

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

### L1 — Cambio de enfoque

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude se ve obligado a abandonar el enfoque anterior e intentar algo **fundamentalmente diferente**. Ajustar parámetros no cuenta.

### L2 — Buscar y formular hipótesis

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude debe: leer el error palabra por palabra → buscar 50+ líneas de contexto → listar 3 hipótesis diferentes.

### L3 — Lista de verificación

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude debe completar la lista de verificación de 7 puntos (leer señales de error, buscar problema central, leer código fuente, verificar suposiciones, hipótesis inversa, reproducción mínima, cambiar herramientas/métodos). Cada punto completado se escribe en state.json.

### L4 — Transferencia ordenada

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude construye un PoC mínimo y luego genera un informe de transferencia:

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

Después de completar la transferencia, el bucle se cierra de forma ordenada. Esto no es "no puedo" — es "aquí está el límite."

---

## Configuración

`.ralph-boost/config.json`:

| Campo | Predeterminado | Descripción |
|-------|----------------|-------------|
| `max_calls_per_hour` | 100 | Máximo de llamadas a la API de Claude por hora |
| `claude_timeout_minutes` | 15 | Tiempo de espera por llamada individual |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Herramientas disponibles para Claude |
| `claude_model` | "" | Anulación del modelo (vacío = predeterminado) |
| `session_expiry_hours` | 24 | Tiempo de expiración de la sesión |
| `no_progress_threshold` | 7 | Umbral sin progreso antes del apagado |
| `same_error_threshold` | 8 | Umbral de mismo error antes del apagado |
| `sleep_seconds` | 3600 | Tiempo de espera entre iteraciones (segundos) |

### Ajustes de configuración comunes

**Acelerar el bucle** (para pruebas):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Restringir permisos de herramientas**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Usar un modelo específico**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Estructura del directorio del proyecto

```
.ralph-boost/
├── PROMPT.md           # Instrucciones de desarrollo (incluye protocolo block-break)
├── fix_plan.md         # Lista de tareas (actualizada automáticamente por Claude)
├── config.json         # Configuración
├── state.json          # Estado unificado (circuit breaker + presión + sesión)
├── handoff-report.md   # Informe de transferencia L4 (generado al salir ordenadamente)
├── logs/
│   ├── boost.log       # Registro del bucle
│   └── claude_output_*.log  # Salida por iteración
└── .gitignore          # Ignora estado y registros
```

Todos los archivos permanecen dentro de `.ralph-boost/` — el directorio raíz de tu proyecto no se modifica.

---

## Relación con ralph-claude-code

Ralph Boost es un **reemplazo independiente** de [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), no un plugin de mejora.

| Aspecto | ralph-claude-code | ralph-boost |
|---------|-------------------|-------------|
| Forma | Herramienta Bash independiente | Skill de Claude Code (bucle de Agent) |
| Instalación | `npm install` | Plugin de Claude Code |
| Tamaño del código | 2000+ líneas | ~400 líneas |
| Dependencias externas | jq (requerido) | Ruta principal: cero; Respaldo: jq o python |
| Directorio | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Pasivo (se rinde después de 3 bucles) | Activo (L0-L4, 6-7 bucles de auto-recuperación) |
| Coexistencia | Sí | Sí (sin conflictos de archivos) |

Ambos pueden instalarse simultáneamente en el mismo proyecto — usan directorios separados y no interfieren entre sí.

---

## Relación con Block Break

Ralph Boost adapta los mecanismos centrales de Block Break (escalación de presión, metodología de 5 pasos, lista de verificación) a escenarios de bucle autónomo:

| Aspecto | block-break | ralph-boost |
|---------|-------------|-------------|
| Escenario | Sesiones interactivas | Bucles autónomos |
| Activación | Los hooks se activan automáticamente | Integrado en bucle de Agent / script del bucle |
| Detección | Hook PostToolUse | Detección de progreso del bucle de Agent / detección de progreso del script |
| Control | Prompts inyectados por hooks | Inyección de prompts del Agent / --append-system-prompt |
| Estado | `~/.forge/` | `.ralph-boost/state.json` |

El código es completamente independiente; los conceptos son compartidos.

> **Referencia**: La escalación de presión (L0-L4), la metodología de 5 pasos y la lista de verificación de 7 puntos de Block Break forman la base conceptual del circuit breaker de ralph-boost. Consulta la [Guía de usuario de Block Break](block-break-guide.md) para más detalles.

---

## Preguntas frecuentes

### ¿Cómo elijo entre la ruta principal y el respaldo?

`/ralph-boost run` usa el bucle de Agent (ruta principal) por defecto, ejecutándose directamente en la sesión actual de Claude Code. Usa el script bash de respaldo cuando necesites ejecución sin interfaz o desatendida.

### ¿Dónde está el script del bucle?

Después de instalar el plugin forge, el script de respaldo está en `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`. También puedes copiarlo a cualquier lugar y ejecutarlo desde ahí. El script auto-detecta jq o python como su motor JSON.

### ¿Cómo veo los registros del bucle?

```bash
tail -f .ralph-boost/logs/boost.log
```

### ¿Cómo reinicio manualmente el nivel de presión?

Edita `.ralph-boost/state.json`: establece `pressure.level` en 0 y `circuit_breaker.consecutive_no_progress` en 0. O simplemente elimina state.json y reinicializa.

### ¿Cómo modifico la lista de tareas?

Edita `.ralph-boost/fix_plan.md` directamente, usando el formato `- [ ] tarea`. Claude la lee al inicio de cada iteración.

### ¿Cómo recupero después de que se abra el circuit breaker?

Edita `state.json`, establece `circuit_breaker.state` en `"CLOSED"`, reinicia los contadores relevantes y vuelve a ejecutar el script.

### ¿Necesito ralph-claude-code?

No. Ralph Boost es completamente independiente y no depende de ningún archivo de Ralph.

### ¿Qué plataformas son compatibles?

Actualmente soporta Claude Code (bucle de Agent como ruta principal). El script bash de respaldo requiere bash 4+, jq o python y la CLI claude.

### ¿Cómo valido los archivos de skill de ralph-boost?

Usa [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Cuándo usar / Cuándo NO usar

### ✅ Usar cuando

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ No usar cuando

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> Motor de bucle autónomo con garantía de convergencia — necesita objetivos claros y entorno estable.

Análisis completo de límites: [references/scope-boundaries.md](../../../skills/ralph-boost/references/scope-boundaries.md)

---

## Licencia

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
