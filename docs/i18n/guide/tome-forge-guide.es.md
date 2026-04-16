# Guia del Usuario de Tome Forge

> Comienza en 5 minutos — base de conocimiento personal con wiki compilado por LLM

---

## Instalacion

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalacion universal en una linea

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **Cero dependencias** — Tome Forge no requiere servicios externos, ni base de datos vectorial, ni infraestructura RAG. Instala y listo.

---

## Comandos

| Comando | Que hace | Cuando usarlo |
|---------|----------|---------------|
| `/tome-forge init` | Inicializar una base de conocimiento | Al comenzar una nueva KB en cualquier directorio |
| `/tome-forge capture [text]` | Captura rapida de nota, enlace o portapapeles | Anotar ideas, guardar URLs, recortar contenido |
| `/tome-forge capture clip` | Capturar desde el portapapeles del sistema | Guardado rapido de contenido copiado |
| `/tome-forge ingest <path>` | Compilar material crudo en wiki | Despues de agregar articulos, papers o notas a `raw/` |
| `/tome-forge ingest <path> --dry-run` | Vista previa del enrutamiento sin escribir | Verificar antes de confirmar cambios |
| `/tome-forge query <question>` | Buscar y sintetizar desde el wiki | Encontrar respuestas en toda la base de conocimiento |
| `/tome-forge lint` | Verificacion de salud de la estructura del wiki | Antes de commits, mantenimiento periodico |
| `/tome-forge compile` | Compilar por lotes todos los materiales crudos nuevos | Ponerse al dia despues de agregar multiples archivos crudos |

---

## Como Funciona

Basado en el patron LLM Wiki de Karpathy:

```
raw materials + LLM compilation = structured Markdown wiki
```

### La Arquitectura de Dos Capas

| Capa | Propietario | Proposito |
|------|-------------|-----------|
| `raw/` | Tu | Materiales fuente inmutables — papers, articulos, notas, enlaces |
| `wiki/` | LLM | Paginas Markdown compiladas, estructuradas y con referencias cruzadas |

El LLM lee tus materiales crudos y los compila en paginas wiki bien estructuradas. Nunca editas `wiki/` directamente — agregas materiales crudos y dejas que el LLM mantenga el wiki.

### La Seccion Sagrada

Cada pagina wiki tiene una seccion `## Mi Delta de Comprension`. Esta es **tuya** — el LLM nunca la modificara. Escribe aqui tus ideas personales, desacuerdos o intuiciones. Sobrevive a todas las recompilaciones.

---

## Descubrimiento de KB — A Donde Van Mis Datos?

Puedes ejecutar `/tome-forge` desde **cualquier directorio**. Encuentra automaticamente la KB correcta:

| Situacion | Que sucede |
|-----------|-----------|
| El directorio actual (o padre) contiene `.tome-forge.json` | Usa esa KB |
| No se encontro `.tome-forge.json` hacia arriba | Usa el predeterminado `~/.tome-forge/` (se crea automaticamente si es necesario) |

Esto significa que puedes capturar notas desde cualquier proyecto sin hacer `cd` primero — todo se canaliza a tu unica KB predeterminada.

Quieres KBs separadas por proyecto? Usa `init .` dentro del directorio del proyecto.

## Flujo de Trabajo

### 1. Inicializar

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

Despues de la inicializacion, el directorio de la KB se ve asi:

```
~/.tome-forge/               # (or wherever you initialized)
├── .tome-forge.json         # KB marker (auto-generated)
├── CLAUDE.md                # KB schema and rules
├── index.md                 # Wiki page index
├── .gitignore
├── logs/                    # Operation logs (monthly rotation)
│   └── 2026-04.md           # One file per month, never grows too large
├── raw/                     # Your source materials (immutable)
└── wiki/                    # LLM-compiled wiki (auto-maintained)
```

### 2. Capturar

Desde **cualquier directorio**, simplemente ejecuta:

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

Las capturas rapidas van a `raw/captures/{date}/`. Para materiales mas largos, coloca archivos directamente en `raw/papers/`, `raw/articles/`, etc.

### 3. Ingerir

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

El LLM lee el archivo crudo, lo enruta a la(s) pagina(s) wiki correcta(s) y fusiona la nueva informacion mientras preserva tus notas personales.

### 4. Consultar

```
/tome-forge query "what is the relationship between attention and transformers?"
```

Sintetiza una respuesta desde tu wiki, citando paginas especificas. Te indica si falta informacion y que material crudo agregar.

### 5. Mantener

```
/tome-forge lint
/tome-forge compile
```

Lint verifica la integridad estructural. Compile ingiere por lotes todo lo nuevo desde la ultima compilacion.

---

## Estructura de Directorios

```
my-knowledge-base/
├── .tome-forge.json       # KB marker (auto-generated)
├── CLAUDE.md              # Schema and rules (auto-generated)
├── index.md               # Wiki page index
├── .last_compile          # Timestamp for batch compile
├── logs/                  # Operation logs (monthly rotation)
│   └── 2026-04.md
├── raw/                   # Your source materials (immutable)
│   ├── captures/          # Quick captures by date
│   ├── papers/            # Academic papers
│   ├── articles/          # Blog posts, articles
│   ├── books/             # Book notes
│   └── conversations/     # Chat logs, interviews
└── wiki/                  # LLM-compiled wiki (auto-maintained)
    ├── ai/                # Domain directories
    ├── systems/
    └── ...
```

---

## Formato de Pagina Wiki

Cada pagina wiki sigue una plantilla estricta:

```yaml
---
domain: ai
maturity: growing        # draft | growing | stable | deprecated
last_compiled: 2026-04-15
source_refs:
  - raw/papers/attention.md
confidence: medium       # low | medium | high
compiled_by: claude-opus-4-6
---
```

Secciones requeridas:
- **Concepto Central** — Conocimiento mantenido por el LLM
- **Mi Delta de Comprension** — Tus ideas personales (nunca tocadas por el LLM)
- **Preguntas Abiertas** — Preguntas sin responder
- **Conexiones** — Enlaces a paginas wiki relacionadas

---

## Cadencia Recomendada

| Frecuencia | Accion | Tiempo |
|------------|--------|--------|
| **Diario** | `capture` para ideas, enlaces, portapapeles | 2 min |
| **Semanal** | `compile` para procesar por lotes los materiales de la semana | 15-30 min |
| **Mensual** | `lint` + revisar secciones de Mi Delta de Comprension | 30 min |

**Evita la ingestion en tiempo real.** Las ingestiones frecuentes de archivos individuales fragmentan la coherencia del wiki. La compilacion semanal por lotes produce mejores referencias cruzadas y paginas mas consistentes.

---

## Hoja de Ruta de Escalabilidad

| Fase | Tamano del Wiki | Estrategia |
|------|----------------|------------|
| 1. Arranque en frio (semana 1-4) | < 30 paginas | Lectura de contexto completo, enrutamiento por index.md |
| 2. Estado estable (mes 2-3) | 30-100 paginas | Fragmentacion por temas (wiki/ai/, wiki/systems/) |
| 3. Escala (mes 4-6) | 100-200 paginas | Consultas por fragmento, suplemento con ripgrep |
| 4. Avanzado (6+ meses) | 200+ paginas | Enrutamiento basado en embeddings (no recuperacion), compilacion incremental |

---

## Riesgos Conocidos

| Riesgo | Impacto | Mitigacion |
|--------|---------|-----------|
| **Deriva de redaccion** | Multiples compilaciones suavizan la voz personal | `compiled_by` rastrea el modelo; raw/ es la fuente de verdad; recompilar desde raw en cualquier momento |
| **Techo de escala** | La ventana de contexto limita el tamano del wiki | Fragmentar por dominio; usar enrutamiento por indice; capa de embeddings cuando > 200 paginas |
| **Dependencia del proveedor** | Atado a un proveedor de LLM | Las fuentes crudas son Markdown puro; cambiar modelo y recompilar |
| **Corrupcion del Delta** | El LLM sobrescribe ideas personales | Verificacion diff post-ingestion restaura automaticamente el Delta original |

---

## Plataformas

| Plataforma | Como funciona |
|------------|--------------|
| Claude Code | Acceso completo al sistema de archivos, lecturas paralelas, integracion con git |
| OpenClaw | Mismas operaciones, adaptadas a las convenciones de herramientas de OpenClaw |

---

## FAQ

**P: Que tan grande puede ser el wiki?**
R: Menos de 50 paginas, el LLM lee todo. De 50 a 200 paginas, usa el indice para navegar. Mas de 200, considera la fragmentacion por dominio.

**P: Puedo editar paginas wiki directamente?**
R: Solo la seccion `## Mi Delta de Comprension`. Todo lo demas se sobrescribira en la proxima ingestion/compilacion.

**P: Necesita una base de datos vectorial?**
R: No. El wiki es Markdown puro. El LLM lee archivos directamente — sin embeddings, sin RAG, sin infraestructura.

**P: Como respaldo mi KB?**
R: Son todos archivos en un repositorio git. `git push` y listo.

**P: Que pasa si el LLM comete un error en el wiki?**
R: Agrega una correccion a `raw/` y vuelve a ingerir. El algoritmo de fusion prefiere fuentes mas autoritativas. O anota desacuerdos en tu Mi Delta de Comprension.
