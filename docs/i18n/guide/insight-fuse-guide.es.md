# Manual de usuario de Insight Fuse

> Motor sistematico de investigacion multi-fuente — Del tema al informe de investigacion profesional

## Inicio rapido

```bash
# Investigacion completa (5 etapas, con puntos de control manuales)
/insight-fuse AI Agent riesgos de seguridad

# Escaneo rapido (solo Stage 1)
/insight-fuse --depth quick computacion cuantica

# Usar una plantilla especifica
/insight-fuse --template technology WebAssembly

# Investigacion profunda con perspectivas personalizadas
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist comercializacion de conduccion autonoma
```

## Parametros

| Parametro | Descripcion | Ejemplo |
|-----------|-------------|---------|
| `topic` | Tema de investigacion (obligatorio) | `AI Agent riesgos de seguridad` |
| `--depth` | Profundidad de investigacion | `quick` / `standard` / `deep` / `full` |
| `--template` | Plantilla de informe | `technology` / `market` / `competitive` |
| `--perspectives` | Lista de perspectivas | `optimist,pessimist,pragmatist` |

## Modos de profundidad

### quick — Escaneo rapido
Ejecuta Stage 1. 3+ consultas de busqueda, 5+ fuentes, genera un informe breve. Ideal para obtener una vision rapida de un tema.

### standard — Investigacion estandar
Ejecuta Stage 1 + 3. Identifica automaticamente sub-preguntas, investiga en paralelo, cobertura completa. Sin interaccion manual.

### deep — Investigacion profunda
Ejecuta Stage 1 + 3 + 5. Sobre la base de la investigacion estandar, analiza todas las sub-preguntas desde 3 perspectivas en profundidad. Sin interaccion manual.

### full (predeterminado) — Pipeline completo
Ejecuta las 5 etapas. Stage 2 y Stage 4 son puntos de control manuales para asegurar que la direccion sea correcta.

## Plantillas de informe

### Plantillas integradas

- **technology** — Investigacion tecnologica: arquitectura, comparacion, ecosistema, tendencias
- **market** — Investigacion de mercado: tamano, competencia, usuarios, proyecciones
- **competitive** — Analisis competitivo: matriz de funcionalidades, SWOT, precios

### Plantillas personalizadas

1. Copie `templates/custom-example.md` como `templates/your-name.md`
2. Modifique la estructura de capitulos
3. Conserve los marcadores `{topic}` y `{date}`
4. El ultimo capitulo debe ser "Fuentes de referencia"
5. Active con `--template your-name`

### Modo sin plantilla

Cuando no se especifica `--template`, el agente genera la estructura del informe de forma adaptativa segun el contenido investigado.

## Analisis multi-perspectiva

### Perspectivas predeterminadas

| Perspectiva | Rol | Modelo |
|-------------|-----|--------|
| Generalist | Cobertura amplia, consenso general | Sonnet |
| Critic | Cuestionamiento, busqueda de evidencia contraria | Opus |
| Specialist | Profundidad tecnica, fuentes primarias | Sonnet |

### Conjuntos de perspectivas alternativos

| Escenario | Perspectivas |
|-----------|-------------|
| Prediccion de tendencias | `--perspectives optimist,pessimist,pragmatist` |
| Investigacion de productos | `--perspectives user,developer,business` |
| Investigacion de politicas | `--perspectives domestic,international,regulatory` |

### Perspectivas personalizadas

Cree `agents/insight-{name}.md`, usando como referencia la estructura de los archivos de agente existentes.

## Aseguramiento de calidad

Cada informe se verifica automaticamente:
- Al menos 2 fuentes independientes por capitulo
- Sin referencias huerfanas
- Una sola fuente no supera el 40% del total
- Todas las afirmaciones comparativas respaldadas con datos

## Diferencia con council-fuse

| | insight-fuse | council-fuse |
|---|---|---|
| **Proposito** | Investigacion activa + generacion de informes | Deliberacion multi-perspectiva sobre informacion conocida |
| **Fuente de informacion** | Recopilacion via WebSearch/WebFetch | Preguntas proporcionadas por el usuario |
| **Salida** | Informe de investigacion completo | Respuesta sintetizada |
| **Etapas** | 5 etapas progresivas | 3 etapas (convocatoria → evaluacion → sintesis) |

Ambos pueden combinarse: primero usar insight-fuse para investigar y recopilar informacion, luego usar council-fuse para deliberar en profundidad sobre decisiones clave.
