# Guía de Usuario de Skill Lint

> Comienza en 3 minutos — valida la calidad de tu skill de Claude Code

---

## Instalación

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalación universal en una línea

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **Sin dependencias** — Skill Lint no requiere servicios externos ni APIs. Instala y listo.

---

## Comandos

| Comando | Qué hace | Cuándo usar |
|---------|----------|-------------|
| `/skill-lint` | Mostrar información de uso | Ver verificaciones disponibles |
| `/skill-lint .` | Verificar el proyecto actual | Auto-verificación durante el desarrollo |
| `/skill-lint /path/to/plugin` | Verificar una ruta específica | Revisar otro plugin |

---

## Casos de Uso

### Auto-verificación después de crear un nuevo skill

Después de crear `skills/<name>/SKILL.md`, `commands/<name>.md` y archivos relacionados, ejecuta `/skill-lint .` para confirmar que la estructura está completa, el frontmatter es correcto y la entrada del marketplace ha sido añadida.

### Revisar el plugin de otra persona

Al revisar un PR o auditar otro plugin, usa `/skill-lint /path/to/plugin` para una verificación rápida de completitud de archivos y consistencia.

### Integración con CI

`scripts/skill-lint.sh` puede ejecutarse directamente en un pipeline de CI, generando JSON para análisis automatizado:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Elementos de Verificación

### Verificaciones Estructurales (ejecutadas por script Bash)

| Regla | Qué verifica | Severidad |
|-------|-------------|-----------|
| S01 | `plugin.json` existe tanto en la raíz como en `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` existe | error |
| S03 | Cada `skills/<name>/` contiene un `SKILL.md` | error |
| S04 | El frontmatter de SKILL.md incluye `name` y `description` | error |
| S05 | Cada skill tiene un `commands/<name>.md` correspondiente | warning |
| S06 | Cada skill está listado en el array `plugins` de marketplace.json | warning |
| S07 | Los archivos de referencias citados en SKILL.md realmente existen | error |
| S08 | `evals/<name>/scenarios.md` existe | warning |

### Verificaciones Semánticas (ejecutadas por IA)

| Regla | Qué verifica | Severidad |
|-------|-------------|-----------|
| M01 | La descripción indica claramente el propósito y las condiciones de activación | warning |
| M02 | El nombre coincide con el nombre del directorio; la descripción es consistente entre archivos | warning |
| M03 | La lógica de enrutamiento de comandos referencia correctamente el nombre del skill | warning |
| M04 | El contenido de las referencias es lógicamente consistente con SKILL.md | warning |
| M05 | Los escenarios de evaluación cubren las rutas de funcionalidad principal (al menos 5) | warning |

---

## Ejemplos de Salida Esperada

### Todas las verificaciones pasaron

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### Problemas encontrados

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Flujo de Trabajo

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## Preguntas Frecuentes

### ¿Puedo ejecutar solo las verificaciones estructurales, sin las semánticas?

Sí — ejecuta el script bash directamente:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Esto genera JSON puro sin análisis semántico de IA.

### ¿Funciona en proyectos que no son forge?

Sí. Cualquier directorio que siga la estructura estándar de plugins de Claude Code (`skills/`, `commands/`, `.claude-plugin/`) puede ser validado.

### ¿Cuál es la diferencia entre errores y advertencias?

- **error**: Problemas estructurales que impedirán que el skill se cargue o publique correctamente
- **warning**: Problemas de calidad que no afectarán la funcionalidad pero impactan la mantenibilidad y la descubribilidad

### Otras herramientas de forge

Skill Lint es parte de la colección forge y funciona bien junto con estos skills:

- [Block Break](block-break-guide.md) — Motor de restricción de comportamiento de alta capacidad que obliga a la IA a agotar cada enfoque
- [Ralph Boost](ralph-boost-guide.md) — Motor de bucle de desarrollo autónomo con garantías de convergencia Block Break integradas

Después de desarrollar un nuevo skill, ejecuta `/skill-lint .` para verificar la completitud estructural y confirmar que el frontmatter, marketplace.json y los enlaces de referencia son todos correctos.

---

## Licencia

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
