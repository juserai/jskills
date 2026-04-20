# Guia de usuario de Council Fuse

> Comienza en 5 minutos — deliberacion multi-perspectiva para mejores respuestas

---

## Instalacion

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalacion universal en una linea

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **Sin dependencias** — Council Fuse no requiere servicios externos ni APIs. Instala y listo.

---

## Comandos

| Comando | Que hace | Cuando usarlo |
|---------|----------|---------------|
| `/council-fuse <pregunta>` | Ejecutar una deliberacion completa del consejo | Decisiones importantes, preguntas complejas |

---

## Como funciona

Council Fuse destila el patron LLM Council de Karpathy en un solo comando:

### Etapa 1: Convocar

Tres agentes se generan **en paralelo**, cada uno con una perspectiva diferente:

| Agente | Rol | Modelo | Fortaleza |
|--------|-----|--------|-----------|
| Generalista | Equilibrado, practico | Sonnet | Mejores practicas convencionales |
| Critico | Adversarial, encuentra fallos | Opus | Casos limite, riesgos, puntos ciegos |
| Especialista | Detalle tecnico profundo | Sonnet | Precision en la implementacion |

Cada agente responde **independientemente** — no pueden ver las respuestas de los demas.

### Etapa 2: Puntuar

El Presidente (agente principal) anonimiza todas las respuestas como Respuesta A/B/C, luego puntua cada una en 4 dimensiones (0-10):

- **Correccion** — precision factual, solidez logica
- **Completitud** — cobertura de todos los aspectos
- **Practicidad** — aplicabilidad, utilidad en el mundo real
- **Claridad** — estructura, legibilidad

### Etapa 3: Sintetizar

La respuesta con mayor puntuacion se convierte en el esqueleto. Las ideas unicas de las otras respuestas se integran. Las objeciones validas del critico se conservan como advertencias.

---

## Casos de uso

### Decisiones de arquitectura

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

El generalista proporciona compensaciones equilibradas, el critico cuestiona la moda de los microservicios y el especialista detalla los patrones de migracion. La sintesis ofrece una recomendacion condicional.

### Elecciones tecnologicas

```
/council-fuse Redis vs PostgreSQL for our job queue
```

Tres angulos diferentes aseguran que no pases por alto preocupaciones operativas (critico), detalles de implementacion (especialista) o la opcion pragmatica por defecto (generalista).

### Revision de codigo

```
/council-fuse Is this error handling pattern correct? <paste code>
```

Obtiene validacion convencional, analisis adversarial de casos limite y verificacion tecnica profunda en una sola pasada.

---

## Estructura de salida

Cada deliberacion del consejo produce:

1. **Matriz de puntuacion** — puntuacion transparente de las tres perspectivas
2. **Analisis de consenso** — donde coinciden y donde discrepan
3. **Respuesta sintetizada** — la mejor respuesta fusionada
4. **Opinion minoritaria** — opiniones disidentes validas que vale la pena notar

---

## Personalizacion

### Cambiar perspectivas

Edita `agents/*.md` para definir miembros personalizados del consejo. Triadas alternativas:

- Optimista / Pesimista / Pragmatico
- Arquitecto / Implementador / Tester
- Defensor del usuario / Desarrollador / Experto en seguridad

### Cambiar modelos

Edita el campo `model:` en cada archivo de agente:

- `model: haiku` — consejos economicos
- `model: opus` — peso pesado completo para decisiones criticas

---

## Plataformas

| Plataforma | Como funcionan los miembros del consejo |
|------------|----------------------------------------|
| Claude Code | 3 spawns de agentes independientes en paralelo |
| OpenClaw | Agente unico, 3 rondas de razonamiento independientes secuenciales |

---

## Cuándo usar / Cuándo NO usar

### ✅ Usar cuando

- Architectural decisions needing multiple perspectives
- You suspect confirmation bias in your current answer
- You want dissenting views preserved, not erased

### ❌ No usar cuando

- Pure factual queries (use `claim-ground` instead)
- Creative writing (synthesis flattens style)
- Speed-critical decisions (3 agents run sequentially — not fast)

> Motor de debate basado en conocimiento de entrenamiento — revela puntos ciegos de una sola perspectiva, pero las conclusiones siguen limitadas.

Análisis completo de límites: [references/scope-boundaries.md](../../../skills/council-fuse/references/scope-boundaries.md)

---

## Preguntas frecuentes

**P: Cuesta 3 veces mas tokens?**
R: Si, aproximadamente. Tres respuestas independientes mas la sintesis. Usalo para decisiones que justifiquen la inversion.

**P: Puedo agregar mas miembros al consejo?**
R: El framework lo soporta — agrega otro archivo `agents/*.md` y actualiza el flujo de trabajo en SKILL.md. Sin embargo, 3 es el punto optimo entre costo y diversidad.

**P: Que pasa si un agente falla?**
R: El Presidente puntua a ese miembro con 0 y sintetiza a partir de las respuestas restantes. Degradacion elegante, sin fallos.
