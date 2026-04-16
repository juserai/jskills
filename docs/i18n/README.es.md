# Forge

> Trabaja más duro, luego tómate un descanso. 7 skills para un mejor ritmo de programación con Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-7-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

### Demo rápido

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

## Instalación

```bash
# Claude Code (un solo comando)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Hammer

| Skill | Qué hace | Pruébalo |
|-------|----------|----------|
| **block-break** | Fuerza una resolución exhaustiva antes de rendirse | `/block-break` |
| **ralph-boost** | Ciclos de desarrollo autónomos con garantía de convergencia | `/ralph-boost setup` |

### Crucible

| Skill | Qué hace | Pruébalo |
|-------|----------|----------|
| **council-fuse** | Deliberación multiperspectiva para mejores respuestas | `/council-fuse <question>` |
| **insight-fuse** | Investigación sistemática multifuente con informes profesionales | `/insight-fuse <topic>` |
| **tome-forge** | Base de conocimiento personal con wiki compilada por LLM | `/tome-forge init` |

### Anvil

| Skill | Qué hace | Pruébalo |
|-------|----------|----------|
| **skill-lint** | Valida cualquier skill plugin de Claude Code | `/skill-lint .` |

### Quench

| Skill | Qué hace | Pruébalo |
|-------|----------|----------|
| **news-fetch** | Noticias rápidas entre sesiones de código | `/news-fetch AI today` |

---

## Block Break — Motor de restricción de comportamiento

¿Tu IA se rindió? `/block-break` la obliga a agotar todos los enfoques primero.

Cuando Claude se atasca, Block Break activa un sistema de escalamiento de presión que previene la rendición prematura. Fuerza al agente a pasar por etapas de resolución de problemas progresivamente más rigurosas antes de permitir cualquier respuesta tipo "no puedo hacerlo".

| Mecanismo | Descripción |
|-----------|-------------|
| **3 Red Lines** | Verificación en bucle cerrado / Basado en hechos / Agotar todas las opciones |
| **Escalamiento de presión** | L0 Trust → L1 Disappointment → L2 Interrogation → L3 Performance Review → L4 Graduation |
| **Método de 5 pasos** | Smell → Pull hair → Mirror → New approach → Retrospect |
| **Checklist de 7 puntos** | Checklist de diagnóstico obligatorio en L3+ |
| **Anti-racionalización** | Identifica y bloquea 14 patrones comunes de excusas |
| **Hooks** | Detección automática de frustración + conteo de fallos + persistencia de estado |

```text
/block-break              # Activar modo Block Break
/block-break L2           # Comenzar en un nivel de presión específico
/block-break fix the bug  # Activar e iniciar una tarea inmediatamente
```

También se activa con lenguaje natural: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, etc. (detectado automáticamente por hooks).

> Inspirado en [PUA](https://github.com/tanweai/pua), destilado en un skill sin dependencias.

## Ralph Boost — Motor de ciclo de desarrollo autónomo

Ciclos de desarrollo autónomos que realmente convergen. Configuración en 30 segundos.

Replica la capacidad de ciclo autónomo de ralph-claude-code como skill, con escalamiento de presión Block Break L0-L4 integrado para garantizar la convergencia. Resuelve el problema de "girar sin avanzar" en ciclos autónomos.

| Característica | Descripción |
|----------------|-------------|
| **Dual-Path Loop** | Ciclo de agente (principal, cero deps externas) + fallback de script bash (motores jq/python) |
| **Circuit Breaker mejorado** | Escalamiento de presión L0-L4 integrado: de "rendirse tras 3 rondas" a "6-7 rondas de auto-rescate progresivo" |
| **Seguimiento de estado** | state.json unificado para circuit breaker + presión + estrategia + sesión |
| **Traspaso ordenado** | L4 genera un informe de traspaso estructurado en lugar de un crash sin formato |
| **Independiente** | Usa el directorio `.ralph-boost/`, sin dependencia de ralph-claude-code |

```text
/ralph-boost setup        # Inicializar proyecto
/ralph-boost run          # Iniciar ciclo autónomo
/ralph-boost status       # Consultar estado actual
/ralph-boost clean        # Limpiar
```

> Inspirado en [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), reimaginado como un skill sin dependencias con garantía de convergencia.

## Skill Lint — Validador de skill plugins

Valida tus plugins de Claude Code en un solo comando.

Comprueba la integridad estructural y la calidad semántica de los archivos de skill en cualquier proyecto de plugin de Claude Code. Los scripts bash manejan las comprobaciones estructurales, la IA maneja las comprobaciones semánticas — cobertura complementaria.

| Tipo de comprobación | Descripción |
|----------------------|-------------|
| **Estructural** | Campos requeridos del frontmatter / existencia de archivos / enlaces de referencia / entradas del marketplace |
| **Semántica** | Calidad de la descripción / consistencia de nombres / enrutamiento de comandos / cobertura de evaluación |

```text
/skill-lint              # Mostrar uso
/skill-lint .            # Validar el proyecto actual
/skill-lint /path/to/plugin  # Validar una ruta específica
```

## News Fetch — Tu descanso mental entre sprints

¿Agotado de depurar? `/news-fetch` — tu descanso mental de 2 minutos.

Los otros skills te empujan a trabajar más duro. Este te recuerda respirar. Obtén las últimas noticias sobre cualquier tema directamente desde tu terminal — sin cambiar de contexto, sin caer en agujeros de conejo del navegador. Solo un vistazo rápido y de vuelta al trabajo, renovado.

| Característica | Descripción |
|----------------|-------------|
| **Fallback de 3 niveles** | L1 WebSearch → L2 WebFetch (fuentes regionales) → L3 curl |
| **Dedup y fusión** | Mismo evento de múltiples fuentes fusionado automáticamente, se conserva el de mayor puntuación |
| **Puntuación de relevancia** | La IA puntúa y ordena por coincidencia con el tema |
| **Auto-resumen** | Resúmenes faltantes generados automáticamente desde el cuerpo del artículo |

```text
/news-fetch AI                    # Noticias de IA de esta semana
/news-fetch AI today              # Noticias de IA de hoy
/news-fetch robotics month        # Noticias de robótica de este mes
/news-fetch climate 2026-03-01~2026-03-31  # Rango de fechas personalizado
```

## Council Fuse — Motor de Deliberación Multiperspectiva

Mejores respuestas a través del debate estructurado. `/council-fuse` genera 3 perspectivas independientes, las evalúa anónimamente y sintetiza la mejor respuesta.

Inspirado en [LLM Council de Karpathy](https://github.com/karpathy/llm-council) — destilado en un solo comando.

| Mecanismo | Descripción |
|-----------|-------------|
| **3 Perspectivas** | Generalista (equilibrado) / Crítico (adversarial) / Especialista (técnico profundo) |
| **Evaluación Anónima** | Evaluación en 4 dimensiones: Corrección, Completitud, Practicidad, Claridad |
| **Síntesis** | Respuesta mejor puntuada como esqueleto, enriquecida con insights únicos |
| **Opinión Minoritaria** | Las opiniones disidentes válidas se preservan, no se silencian |

```text
/council-fuse ¿Deberíamos usar microservicios?
/council-fuse Revisa este patrón de manejo de errores
/council-fuse Redis vs PostgreSQL para colas de trabajo
```

## Insight Fuse — Motor de Investigación Multifuente

Del tema al informe de investigación profesional. `/insight-fuse` ejecuta un pipeline progresivo de 5 etapas: escaneo → alineación → investigación → revisión → análisis profundo.

Análisis multiperspectiva integrado (Generalista/Crítico/Especialista), plantillas de informes extensibles y profundidad configurable. El hermano de la serie fuse de council-fuse — mientras council-fuse delibera sobre información conocida, insight-fuse recopila y sintetiza activamente nueva información.

| Mecanismo | Descripción |
|-----------|-------------|
| **Pipeline de 5 Etapas** | Escaneo → Alineación → Investigación → Revisión → Análisis Profundo |
| **Profundidad Configurable** | quick (solo escaneo) / standard (investigación automática) / deep (+ multiperspectiva) / full (+ puntos de control humanos) |
| **3 Perspectivas** | Generalista (amplitud) / Crítico (verificación) / Especialista (precisión) |
| **Plantillas de Informes** | technology / market / competitive / personalizado — o estructura autogenerada |
| **Estándares de Calidad** | Multifuente obligatorio, integridad de citas, verificación de diversidad de fuentes |

```text
/insight-fuse AI Agent riesgos de seguridad
/insight-fuse --depth quick --template technology WebAssembly
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist comercialización de computación cuántica
```

## Tome Forge — Motor de Base de Conocimiento Personal

Construye una base de conocimiento personal que un LLM compila y mantiene. Basado en el [patrón LLM Wiki de Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — Markdown sin procesar compilado en un wiki estructurado, sin RAG ni base de datos vectorial.

| Característica | Descripción |
|----------------|-------------|
| **Arquitectura de Tres Capas** | Fuentes sin procesar (inmutables) / Wiki (compilado por LLM) / Schema (CLAUDE.md) |
| **6 Operaciones** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | Sección sagrada para insights humanos — LLM nunca sobreescribe |
| **Zero Infra** | Markdown puro + Git. Sin bases de datos, embeddings ni servidores |

```text
/tome-forge init              # Inicializar KB en el directorio actual
/tome-forge capture "idea"    # Captura rápida de una nota
/tome-forge ingest raw/paper  # Compilar material crudo al wiki
/tome-forge query "question"  # Buscar y sintetizar
/tome-forge lint              # Verificación de salud de la estructura wiki
/tome-forge compile           # Compilar por lotes todos los nuevos materiales
```

> Inspirado en [LLM Wiki de Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), construido como skill sin dependencias.

## Calidad

- Más de 10 escenarios de evaluación por skill con pruebas automatizadas de activación
- Auto-validado por su propio skill-lint
- Cero dependencias externas — cero riesgo
- Licencia MIT, código completamente abierto

## Estructura del proyecto

```text
forge/
├── skills/                        # Plataforma Claude Code
│   └── <skill>/
│       ├── SKILL.md               # Definición del skill
│       ├── references/            # Contenido detallado (carga bajo demanda)
│       ├── scripts/               # Scripts auxiliares
│       └── agents/                # Definiciones de sub-agentes
├── platforms/                     # Adaptaciones para otras plataformas
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # Adaptación para OpenClaw
│           ├── references/        # Contenido específico de la plataforma
│           └── scripts/           # Scripts específicos de la plataforma
├── .claude-plugin/                # Metadatos del marketplace de Claude Code
├── hooks/                         # Hooks de la plataforma Claude Code
├── evals/                         # Escenarios de evaluación multiplataforma
├── docs/
│   ├── guide/                     # Guías de usuario (inglés)
│   ├── plans/                     # Documentos de diseño
│   └── i18n/                      # Traducciones (11 languages)
│       ├── README.*.md            # READMEs traducidos
│       └── guide/*-guide.*.md     # Guías traducidas
└── plugin.json                    # Metadatos de la colección
```

## Contribuir

1. `skills/<name>/SKILL.md` — Skill para Claude Code + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — Adaptación para OpenClaw + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Escenarios de evaluación
4. `.claude-plugin/marketplace.json` — Agregar entrada al array `plugins`
5. Hooks si es necesario en `hooks/hooks.json`

Consulta [CLAUDE.md](../../CLAUDE.md) para las directrices completas de desarrollo.

## Licencia

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
