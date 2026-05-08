# Guia do Peer Fuse v0.1.0

> Revisor por pares genérico para artefatos de pesquisa — **pipeline de 8 etapas (Stage 7 arquivamento KB obrigatório + observável, opt-out via `--no-save`) + adaptador de entrada para 10 formatos (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, dispatch em 3 níveis) + 6 presets de tipo de pesquisa (auto-classificados) + rubrica ponderada de 8 dimensões + taxonomia de 18 flags + painel de 3 perspectivas + freeze de § Document Reading (review-isolation hard constraint)**.

Peer-Fuse recebe qualquer documento markdown / PDF / Office e produz um relatório de revisão por pares em markdown com nota A+/A−/.../D, lista hierárquica de flags de qualidade, síntese de painel multi-perspectiva e sugestões em formato de diff/patch. Coexiste com o [revisor Stage 6.5 do insight-fuse](insight-fuse-guide.md) — Stage 6.5 é revisão IF-internal de mesma fonte; peer-fuse é o **revisor externo cross-skill** que cobre formatos e skills que o Stage 6.5 não consegue.

## Início rápido

```bash
# Auto-classifica tipo, profundidade default, arquiva no KB
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Paper acadêmico em PDF (tipo auto-detectado pelo header arXiv/IEEE/Nature)
/peer-fuse papers/transformer-2017.pdf

# Deck PPTX com tipo explícito
/peer-fuse decks/q4-roadmap.pptx --type product

# Profundidade quick (pula Stage 4 panel + Stage 5.5 holistic) + sem arquivamento KB
/peer-fuse handbook.docx --depth quick --no-save

# Mostrar help
/peer-fuse help
# ou sem argumentos
/peer-fuse
```

## Defaults & flags

| Flag | Default | Valores |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — pula Stage 7 arquivamento KB, apenas saída no console |

`--type=auto` deixa o peer-fuse classificar após ler o documento via heurística (frontmatter type field → section pattern → citation density → format/title hints → fallback overview). Veja [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) para a cadeia de prioridade.

## Formatos suportados

| Tier | Requisito de ferramenta | Formatos |
|:-:|---|---|
| 1 | nenhum (nativo) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` para `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Ferramenta ausente → fail-soft com hint de instalação concreto (`brew install pandoc`, `apt install libreoffice`, etc.) e sai antes do Stage 1. Veja [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md).

## O que você recebe de volta

Dois deliverables paralelos:

1. **Revisão renderizada inline** na sua conversa, estruturada como:
   - § Document Reading — narrativa descritiva (o que o documento diz), 3-5 parágrafos, 300-600 palavras
   - § Holistic Assessment — narrativa avaliativa (metodologia / pontos fortes / preocupações / recomendação), 4 parágrafos, 400-700 palavras
   - § Score Matrix — pontuação ponderada em 8 dimensões → letter grade
   - § Flag List — flag codes da taxonomia de 18 com posições
   - § Multi-Perspective Panel — vereditos de methodologist / adversarial / practitioner
   - § Diff Suggestions — reescritas em formato patch para cada demerit
   - § Reconciliation — target self-grade vs review_grade Δ

2. **Arquivo KB** em `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` (pular com `--no-save`). A linha de log de arquivamento `Archived to KB: <path>` sempre aparece na resposta visível ao usuário.

## Hard constraint: § Document Reading é review-isolated

A decisão arquitetural mais importante do peer-fuse:

**§ Document Reading não pode ser poluído por vereditos de revisão.** É a leitura fiel e descritiva do documento pelo revisor — frontmatter, estrutura, claims, evidências, escopo. Roda no Stage 3.5, **antes** do Stage 4 panel e do Stage 5 scoring, e a fronteira de entrada é estrita:

- ✅ Aceita: documento original, resultados factuais do scan dos Stages 1-3
- ❌ Rejeita: vereditos do panel, scores, flag hits

A seção é **frozen** após o Stage 3.5: um hash SHA-256 é calculado antes do Stage 4, e o Stage 7 verifica o hash antes de arquivar. Qualquer modificação → fail-closed. O lint também proíbe vocabulário avaliativo (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) e literais de letter-grade nessa seção.

Esse é o hard constraint declarado pelo usuário e é enforçado em três níveis: isolamento arquitetural + write-once freeze + lint de palavras proibidas.

## Interação com outras skills do forge

| Skill | Relacionamento |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | Coexiste — Stage 6.5 é revisão IF-internal de mesma fonte (mesma rubrica, mesma heurística, apenas markdown IF). peer-fuse é **revisão externa cross-skill** com rubrica 8-dim mais ampla, 18 flags, 10 formatos, painel de 3 agents. Ambos devem rodar para relatórios IF importantes. |
| **council-fuse** | Sibling crucible — peer-fuse reusa o padrão de dispatch paralelo de sub-agents do council-fuse (Stage 4 panel espelha o Stage 1 do council-fuse). |
| **tome-forge** | Backend de arquivamento — Stage 7 do peer-fuse chama o report-archival-protocol do tome-forge; não reimplementa lógica de escrita no KB. |
| **skill-lint** | Sibling-by-pattern (categoria diferente, anvil) — ambos julgam artefatos e emitem diagnósticos, mas skill-lint produz diagnóstico efêmero no console enquanto peer-fuse produz um artefato persistente de peer-review em markdown. |

## Quando usar peer-fuse vs IF Stage 6.5

| Cenário | Use |
|---|:-:|
| Você acabou de rodar `/insight-fuse <topic>` e quer uma segunda opinião sobre o relatório IF | IF Stage 6.5 já rodou inline; se quiser uma revisão externa de segunda camada com prontidão cross-format, rode `/peer-fuse <if-output-path>` |
| Você tem um paper de pesquisa em PDF de terceiros para avaliar | peer-fuse |
| Você tem um deck de negócios em PPTX que quer pontuar | peer-fuse |
| Você tem uma síntese de saída do council-fuse que quer pontuar | peer-fuse |
| Você quer comparar múltiplos artefatos com a mesma rubrica | peer-fuse (pontuação consistente entre artefatos) |

## Exemplo concreto

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 detection
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 produz § Document Reading (frozen)
# Stage 4 panel roda 3 sub-agents em paralelo
# Stage 5 scoring → 8.6 / A-
# Stage 5.5 holistic assessment
# Stage 6 diff suggestions: 5 blocos
# Stage 7 archive

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

O console renderiza a revisão completa inline; o arquivo KB é a versão canônica persistente.

## Verificação

```bash
# Static check
bash skills/skill-lint/scripts/skill-lint.sh .

# Trigger test
bash evals/peer-fuse/run-trigger-test.sh

# Hash lockstep
bash scripts/recalc-all-hashes.sh
```

## Veja também

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — definição da skill em runtime
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — decisões arquiteturais + racional das 4 categorias
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (após merge)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — sibling crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — sibling crucible (fonte do padrão de painel)
