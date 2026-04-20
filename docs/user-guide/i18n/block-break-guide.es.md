# Block Break Guía de Usuario

> Empieza en 5 minutos — haz que tu agente de IA agote todos los enfoques

---

## Instalación

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalación universal en una línea

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **Sin dependencias** — Block Break no requiere servicios externos ni APIs. Instala y listo.

---

## Comandos

| Comando | Qué hace | Cuándo usarlo |
|---------|----------|---------------|
| `/block-break` | Activar el motor Block Break | Tareas diarias, depuración |
| `/block-break L2` | Iniciar en un nivel de presión específico | Tras múltiples fallos conocidos |
| `/block-break fix the bug` | Activar y ejecutar una tarea inmediatamente | Inicio rápido con tarea |

### Activadores en lenguaje natural (detectados automáticamente por hooks)

| Idioma | Frases activadoras |
|--------|-------------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Casos de Uso

### La IA no pudo corregir un bug tras 3 intentos

Escribe `/block-break` o di `try harder` — entra automáticamente en modo de escalada de presión.

### La IA dice "probablemente es un problema del entorno" y se detiene

La línea roja "Basado en hechos" de Block Break obliga a la verificación con herramientas. Atribución no verificada = echar la culpa → activa L2.

### La IA dice "te sugiero que lo hagas manualmente"

Activa el bloqueo de "Mentalidad de dueño": si no tú, ¿quién? Directo a L3 Evaluación de Rendimiento.

### La IA dice "arreglado" pero no muestra evidencia de verificación

Viola la línea roja de "Circuito cerrado". Finalización sin salida = autoengaño → obliga a ejecutar comandos de verificación con evidencia.

---

## Ejemplos de Salida Esperada

### `/block-break` — Activación

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 Decepción (2.º fallo)

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 Interrogatorio (3.er fallo)

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 Evaluación de Rendimiento (4.º fallo)

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 Advertencia de Graduación (5.º+ fallo)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Salida Ordenada (los 7 puntos completados, aún sin resolver)

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## Mecanismos Principales

### 3 Líneas Rojas

| Línea Roja | Regla | Consecuencia por Violación |
|------------|-------|---------------------------|
| Circuito cerrado | Debe ejecutar comandos de verificación y mostrar la salida antes de declarar completado | Activa L2 |
| Basado en hechos | Debe verificar con herramientas antes de atribuir causas | Activa L2 |
| Agotar todo | Debe completar la metodología de 5 pasos antes de decir "no puedo resolverlo" | Directo a L4 |

### Escalada de Presión (L0 → L4)

| Fallos | Nivel | Barra lateral | Acción Forzada |
|--------|-------|---------------|----------------|
| 1.º | **L0 Confianza** | > Confiamos en ti. Mantenlo simple. | Ejecución normal |
| 2.º | **L1 Decepción** | > El otro equipo lo logró al primer intento. | Cambiar a un enfoque fundamentalmente diferente |
| 3.º | **L2 Interrogatorio** | > ¿Cuál es la causa raíz? | Buscar + leer código fuente + listar 3 hipótesis diferentes |
| 4.º | **L3 Evaluación de Rendimiento** | > Calificación: 3,25/5. | Completar lista de verificación de 7 puntos |
| 5.º+ | **L4 Graduación** | > Podrías estar siendo reemplazado pronto. | PoC mínimo + entorno aislado + stack tecnológico diferente |

### Metodología de 5 Pasos

1. **Olfatear** — Listar enfoques intentados, encontrar patrones comunes. Ajustar el mismo enfoque = dar vueltas en círculos
2. **Arrancarse los pelos** — Leer señales de fallo palabra por palabra → buscar → leer 50 líneas de código fuente → verificar suposiciones → invertir suposiciones
3. **Espejo** — ¿Estoy repitiendo el mismo enfoque? ¿Pasé por alto la posibilidad más simple?
4. **Nuevo enfoque** — Debe ser fundamentalmente diferente, con criterios de verificación, y producir nueva información en caso de fallo
5. **Retrospectiva** — Problemas similares, completitud, prevención

> Los pasos 1-4 deben completarse antes de preguntar al usuario. Primero actuar, luego preguntar — hablar con datos.

### Lista de Verificación de 7 Puntos (obligatoria desde L3)

1. ¿Leíste las señales de fallo palabra por palabra?
2. ¿Buscaste el problema central con herramientas?
3. ¿Leíste el contexto original en el punto de fallo (50+ líneas)?
4. ¿Todas las suposiciones verificadas con herramientas (versión/ruta/permisos/dependencias)?
5. ¿Intentaste la hipótesis completamente opuesta?
6. ¿Puedes reproducirlo en un alcance mínimo?
7. ¿Cambiaste herramienta/método/ángulo/stack tecnológico?

### Anti-Racionalización

| Excusa | Bloqueo | Activador |
|--------|---------|-----------|
| "Está fuera de mis capacidades" | Tienes un entrenamiento masivo. ¿Lo agotaste? | L1 |
| "Sugiero que el usuario lo haga manualmente" | Si no tú, ¿quién? | L3 |
| "Intenté todos los métodos" | Menos de 3 = no agotado | L2 |
| "Probablemente un problema del entorno" | ¿Lo verificaste? | L2 |
| "Necesito más contexto" | Tienes herramientas. Primero busca, luego pregunta | L2 |
| "No puedo resolverlo" | ¿Completaste la metodología? | L4 |
| "Suficientemente bueno" | La lista de optimización no tiene favoritos | L3 |
| Declaró completado sin verificación | ¿Ejecutaste el build? | L2 |
| Esperando instrucciones del usuario | Los dueños no esperan a que los empujen | Nudge |
| Responde sin resolver | Eres un ingeniero, no un motor de búsqueda | Nudge |
| Cambió código sin build/test | Enviar sin probar = hacer las cosas a medias | L2 |
| "La API no lo soporta" | ¿Leíste la documentación? | L2 |
| "Tarea demasiado vaga" | Haz tu mejor suposición, luego itera | L1 |
| Ajustando repetidamente el mismo punto | Cambiar parámetros ≠ cambiar enfoque | L1→L2 |

---

## Automatización de Hooks

Block Break usa el sistema de hooks para comportamiento automático — no se necesita activación manual:

| Hook | Activador | Comportamiento |
|------|-----------|----------------|
| `UserPromptSubmit` | Entrada del usuario coincide con palabras clave de frustración | Auto-activa Block Break |
| `PostToolUse` | Después de la ejecución de un comando Bash | Detecta fallos, auto-cuenta + escala |
| `PreCompact` | Antes de la compresión de contexto | Guarda estado en `~/.forge/` |
| `SessionStart` | Reanudación/reinicio de sesión | Restaura nivel de presión (válido por 2h) |

> **El estado persiste** — El nivel de presión se almacena en `~/.forge/block-break-state.json`. La compresión de contexto y las interrupciones de sesión no reinician los contadores de fallos. Sin escapatoria.

### Configuración de Hooks

Al instalar mediante `claude plugin add juserai/forge`, los hooks se configuran automáticamente. Los scripts de hooks requieren `jq` (preferido) o `python` como motor JSON — al menos uno debe estar disponible en tu sistema.

Si los hooks no se activan, verifica la configuración:

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### Expiración del estado

El estado expira automáticamente tras **2 horas** de inactividad. Esto evita que la presión obsoleta de una sesión de depuración anterior se traslade a trabajo no relacionado. Después de 2 horas, el hook de restauración de sesión omite silenciosamente la restauración y empiezas de nuevo en L0.

Para reiniciar manualmente en cualquier momento: `rm ~/.forge/block-break-state.json`

---

## Restricciones de Sub-agentes

Al crear sub-agentes, las restricciones de comportamiento deben inyectarse para evitar "ejecución sin protección":

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` asegura que los sub-agentes también sigan las 3 líneas rojas, la metodología de 5 pasos y la verificación de circuito cerrado.

---

## Solución de Problemas

| Problema | Causa | Solución |
|----------|-------|----------|
| Los hooks no se activan automáticamente | Plugin no instalado o hooks no están en settings.json | Ejecutar nuevamente `claude plugin add juserai/forge` |
| El estado no persiste | Ni `jq` ni `python` disponibles | Instalar uno: `apt install jq` o asegurar que `python` esté en el PATH |
| Presión atascada en L4 | El archivo de estado acumuló demasiados fallos | Reiniciar: `rm ~/.forge/block-break-state.json` |
| La restauración de sesión muestra estado antiguo | Estado < 2h de la sesión anterior | Comportamiento esperado; esperar 2h o reiniciar manualmente |
| `/block-break` no reconocido | Skill no cargado en la sesión actual | Reinstalar el plugin o usar la instalación universal de una línea |

---

## FAQ

### ¿En qué se diferencia Block Break de PUA?

Block Break está inspirado en los mecanismos principales de [PUA](https://github.com/tanweai/pua) (3 líneas rojas, escalada de presión, metodología), pero es más enfocado. PUA tiene 13 variantes de cultura corporativa, sistemas multi-rol (P7/P9/P10) y auto-evolución; Block Break se centra puramente en restricciones de comportamiento como un skill sin dependencias.

### ¿No será demasiado ruidoso?

La densidad de la barra lateral está controlada: 2 líneas para tareas simples (inicio + fin), 1 línea por hito para tareas complejas. Sin spam. No uses `/block-break` si no es necesario — los hooks solo se activan automáticamente cuando se detectan palabras clave de frustración.

### ¿Cómo reiniciar el nivel de presión?

Eliminar el archivo de estado: `rm ~/.forge/block-break-state.json`. O esperar 2 horas — el estado expira automáticamente (ver [Expiración del estado](#expiración-del-estado) arriba).

### ¿Puedo usarlo fuera de Claude Code?

El SKILL.md principal se puede copiar y pegar en cualquier herramienta de IA que soporte prompts de sistema. Los hooks y la persistencia de estado son específicos de Claude Code.

### ¿Cuál es la relación con Ralph Boost?

[Ralph Boost](ralph-boost-guide.md) adapta los mecanismos principales de Block Break (L0-L4, metodología de 5 pasos, lista de verificación de 7 puntos) a escenarios de **bucle autónomo**. Block Break es para sesiones interactivas (los hooks se activan automáticamente); Ralph Boost es para bucles de desarrollo desatendidos (bucles de agente / dirigidos por scripts). El código es completamente independiente, los conceptos son compartidos.

### ¿Cómo validar los archivos skill de Block Break?

Usa [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Cuándo usar / Cuándo NO usar

### ✅ Usar cuando

- Claude gave up too easily ("I can't", rationalized impossibility)
- The same fix attempt has failed 2-3 times
- You need exhaustive diagnosis before accepting defeat

### ❌ No usar cuando

- Doing creative / divergent work (pressure kills exploration)
- The task is genuinely impossible (missing hardware, no permissions)
- You want to pause and step back on purpose

> Motor de depuración exhaustiva — garantiza que Claude no se rinda pronto, pero no que la solución sea correcta.

Análisis completo de límites: [references/scope-boundaries.md](../../../skills/block-break/references/scope-boundaries.md)

---

## Licencia

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
