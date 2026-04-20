# Forge

> Trabalhe mais, depois faça uma pausa. 8 skills para um ritmo de programação melhor com Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-8-blue.svg)]()
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

## Instalação

```bash
# Claude Code (um único comando)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

> Todo skill aceita `/<skill> help` (ou `--help`) para mostrar o cartão de uso. Skills com argumentos obrigatórios também mostram a ajuda quando invocados sem argumentos.

### Hammer

| Skill | O que faz | Experimente |
|-------|-----------|-------------|
| **block-break** | Força a resolução exaustiva antes de desistir | `/block-break` |
| **ralph-boost** | Ciclos de desenvolvimento autônomos com garantia de convergência | `/ralph-boost setup` |
| **claim-ground** | Ancora cada afirmação do "momento atual" em evidência runtime | auto-acionado |

### Crucible

| Skill | O que faz | Experimente |
|-------|-----------|-------------|
| **council-fuse** | Deliberação multiperspectiva para respostas melhores | `/council-fuse <question>` |
| **insight-fuse** | Motor de pesquisa de 7 estágios com contrato skeleton.yaml & rubrica de qualidade 6-dim | `/insight-fuse <topic>` |
| **tome-forge** | Base de conhecimento pessoal com wiki compilada por LLM | `/tome-forge init` |

### Anvil

| Skill | O que faz | Experimente |
|-------|-----------|-------------|
| **skill-lint** | Valida qualquer skill plugin do Claude Code | `/skill-lint .` |

### Quench

| Skill | O que faz | Experimente |
|-------|-----------|-------------|
| **news-fetch** | Notícias rápidas entre sessões de código | `/news-fetch AI today` |

---

## Block Break — Motor de restrição comportamental

Sua IA desistiu? `/block-break` a força a esgotar todas as abordagens primeiro.

Quando o Claude trava, o Block Break ativa um sistema de escalação de pressão que previne a desistência prematura. Força o agente a passar por estágios de resolução de problemas progressivamente mais rigorosos antes de permitir qualquer resposta do tipo "não consigo fazer isso".

| Mecanismo | Descrição |
|-----------|-----------|
| **3 Red Lines** | Verificação em loop fechado / Baseado em fatos / Esgotar todas as opções |
| **Escalação de pressão** | L0 Trust → L1 Disappointment → L2 Interrogation → L3 Performance Review → L4 Graduation |
| **Método de 5 passos** | Smell → Pull hair → Mirror → New approach → Retrospect |
| **Checklist de 7 pontos** | Checklist de diagnóstico obrigatório em L3+ |
| **Anti-racionalização** | Identifica e bloqueia 14 padrões comuns de desculpas |
| **Hooks** | Detecção automática de frustração + contagem de falhas + persistência de estado |

```text
/block-break              # Ativar modo Block Break
/block-break L2           # Começar em um nível de pressão específico
/block-break fix the bug  # Ativar e iniciar uma tarefa imediatamente
```

Também é ativado por linguagem natural: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, etc. (detectado automaticamente por hooks).

> Inspirado em [PUA](https://github.com/tanweai/pua), destilado em um skill sem dependências.

## Ralph Boost — Motor de ciclo de desenvolvimento autônomo

Ciclos de desenvolvimento autônomos que realmente convergem. Configuração em 30 segundos.

Replica a capacidade de ciclo autônomo do ralph-claude-code como skill, com escalação de pressão Block Break L0-L4 integrada para garantir a convergência. Resolve o problema de "girar sem progresso" em ciclos autônomos.

| Recurso | Descrição |
|---------|-----------|
| **Dual-Path Loop** | Ciclo de agente (principal, zero deps externas) + fallback de script bash (motores jq/python) |
| **Circuit Breaker aprimorado** | Escalação de pressão L0-L4 integrada: de "desistir após 3 rodadas" a "6-7 rodadas de auto-resgate progressivo" |
| **Rastreamento de estado** | state.json unificado para circuit breaker + pressão + estratégia + sessão |
| **Transferência ordenada** | L4 gera um relatório de transferência estruturado em vez de um crash sem formato |
| **Independente** | Usa o diretório `.ralph-boost/`, sem dependência do ralph-claude-code |

```text
/ralph-boost setup        # Inicializar projeto
/ralph-boost run          # Iniciar ciclo autônomo
/ralph-boost status       # Verificar estado atual
/ralph-boost clean        # Limpar
```

> Inspirado em [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), reimaginado como um skill sem dependências com garantia de convergência.

## Claim Ground — Motor de Restrição Epistêmica

Pare de alucinar fatos desatualizados. `claim-ground` ancora cada afirmação do "momento atual" em evidência runtime.

Auto-acionado (sem comando slash). Quando Claude está prestes a responder perguntas factuais sobre estado atual — modelo em execução, ferramentas instaladas, env vars, valores de configuração — ou quando o usuário contesta uma afirmação anterior, Claim Ground força citar o prompt do sistema / saída de ferramenta / conteúdo de arquivo *antes* de tirar conclusão. Quando contestado, Claude reverifica em vez de reformular.

| Mecanismo | Descrição |
|-----------|-----------|
| **3 linhas vermelhas** | Sem afirmação sem fonte / Sem exemplo como lista completa / Sem reformulação ao ser contestado |
| **Runtime > Training** | Prompt do sistema, env e saídas de ferramenta sempre superam a memória de treinamento |
| **Cite-e-depois-conclua** | Fragmento de evidência citado inline antes de qualquer conclusão |
| **Playbook de verificação** | Tipo de pergunta → fonte de evidência (modelo / CLI / pacotes / env / arquivos / git / data) |

Exemplos de acionamento (auto-detectados pela description):

- "Qual modelo está rodando?" / "What model is running?"
- "Qual versão de X está instalada?"
- "Sério? / Tem certeza? / Achei que já tinha atualizado"

Funciona ortogonalmente com block-break: quando ambos ativam, block-break previne "eu desisto", claim-ground previne "só reformulei minha resposta errada".

## Council Fuse — Motor de Deliberação Multiperspectiva

Melhores respostas através do debate estruturado. `/council-fuse` gera 3 perspectivas independentes, as avalia anonimamente e sintetiza a melhor resposta.

Inspirado no [LLM Council de Karpathy](https://github.com/karpathy/llm-council) — destilado em um único comando.

| Mecanismo | Descrição |
|-----------|-----------|
| **3 Perspectivas** | Generalista (equilibrado) / Crítico (adversarial) / Especialista (técnico profundo) |
| **Avaliação Anônima** | Avaliação em 4 dimensões: Correção, Completude, Praticidade, Clareza |
| **Síntese** | Resposta mais bem pontuada como esqueleto, enriquecida com insights únicos |
| **Opinião Minoritária** | Opiniões dissidentes válidas são preservadas, não silenciadas |

```text
/council-fuse Devemos usar microsserviços?
/council-fuse Revise este padrão de tratamento de erros
/council-fuse Redis vs PostgreSQL para filas de tarefas
```

## Insight Fuse — Motor de Pesquisa Multifonte Sistemática (v3)

Do tema ao relatório de pesquisa profissional. `/insight-fuse` executa um pipeline de 7 etapas com `skeleton.yaml` como contrato de dados: brainstorm → scan → align → research → review → deep dive → QA.

Análise multiperspectiva integrada, 6 presets de tipo de pesquisa (overview / technology / market / academic / product / competitive), 5 formatos de saída (report / checklist / ADR / decision-tree / PoC), e uma rubrica de qualidade de 6 dimensões com 14 verificações bloqueantes. O irmão da série fuse do council-fuse — enquanto council-fuse delibera sobre informações conhecidas, insight-fuse coleta e sintetiza ativamente novas informações.

| Mecanismo | Descrição |
|-----------|-----------|
| **Pipeline de 7 etapas** | Brainstorm (esqueleto) → Scan → Align → Research → Review → Deep Dive → QA |
| **Tipos de pesquisa** | overview / technology / market / academic / product / competitive — pacote preset (template + perspectivas + checks específicos) |
| **Profundidade configurável** | quick / standard / deep / full — quick pula Stage 2-5; full executa todos os 7 estágios com portas interativas |
| **Skeleton.yaml** | Contrato de dados de 7 campos (dimensions / taxonomies / out_of_scope / existing_consensus / known_dissensus / hypotheses / business_neutral) consumido por cada stage |
| **Rubrica de qualidade** | Pontuação 6-dim (falseabilidade / densidade de evidência / reprodutibilidade / diversidade de fontes / acionabilidade / transparência) + 14 checks bloqueantes + grau A/B/C/D |
| **Multi-saída** | report / checklist / ADR / decision-tree / PoC — `--outputs` seleciona combinações |

```text
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling" --type technology --outputs report,adr,poc
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI Native landscape" --type overview --depth full --audience "new entrants"
```

## Tome Forge — Motor de Base de Conhecimento Pessoal

Construa uma base de conhecimento pessoal que um LLM compila e mantém. Baseado no [padrão LLM Wiki de Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — Markdown bruto compilado em um wiki estruturado, sem RAG nem banco de dados vetorial.

| Recurso | Descrição |
|---------|-----------|
| **Arquitetura de Três Camadas** | Fontes brutas (imutáveis) / Wiki (compilado por LLM) / Schema (CLAUDE.md) |
| **6 Operações** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | Seção sagrada para insights humanos — LLM nunca sobrescreve |
| **Zero Infra** | Markdown puro + Git. Sem bancos de dados, embeddings nem servidores |

```text
/tome-forge init              # Inicializar KB no diretório atual
/tome-forge capture "idea"    # Captura rápida de uma nota
/tome-forge ingest raw/paper  # Compilar material bruto no wiki
/tome-forge query "question"  # Pesquisar e sintetizar
/tome-forge lint              # Verificação de saúde da estrutura wiki
/tome-forge compile           # Compilar em lote todos os novos materiais
```

> Inspirado no [LLM Wiki de Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), construído como um skill sem dependências.

## Skill Lint — Validador de skill plugins

Valide seus plugins do Claude Code em um único comando.

Verifica a integridade estrutural e a qualidade semântica dos arquivos de skill em qualquer projeto de plugin do Claude Code. Scripts bash lidam com verificações estruturais, a IA lida com verificações semânticas — cobertura complementar.

| Tipo de verificação | Descrição |
|---------------------|-----------|
| **Estrutural** | Campos obrigatórios do frontmatter / existência de arquivos / links de referência / entradas do marketplace |
| **Semântica** | Qualidade da descrição / consistência de nomes / roteamento de comandos / cobertura de avaliação |

```text
/skill-lint              # Mostrar uso
/skill-lint .            # Validar o projeto atual
/skill-lint /path/to/plugin  # Validar um caminho específico
```

## News Fetch — Seu descanso mental entre sprints

Esgotado de depurar? `/news-fetch` — seu descanso mental de 2 minutos.

Os outros skills te empurram a trabalhar mais. Este te lembra de respirar. Pegue as últimas notícias sobre qualquer assunto direto do seu terminal — sem trocar de contexto, sem cair em buracos de coelho do navegador. Só uma olhada rápida e de volta ao trabalho, renovado.

| Recurso | Descrição |
|---------|-----------|
| **Fallback de 3 níveis** | L1 WebSearch → L2 WebFetch (fontes regionais) → L3 curl |
| **Dedup e fusão** | Mesmo evento de múltiplas fontes fundido automaticamente, o de maior pontuação é mantido |
| **Pontuação de relevância** | A IA pontua e ordena por correspondência com o tópico |
| **Auto-resumo** | Resumos ausentes gerados automaticamente a partir do corpo do artigo |

```text
/news-fetch AI                    # Notícias de IA desta semana
/news-fetch AI today              # Notícias de IA de hoje
/news-fetch robotics month        # Notícias de robótica deste mês
/news-fetch climate 2026-03-01~2026-03-31  # Intervalo de datas personalizado
```

## Qualidade

- Mais de 10 cenários de avaliação por skill com testes automatizados de ativação
- Auto-validado pelo próprio skill-lint
- Zero dependências externas — zero risco
- Licença MIT, código totalmente aberto

## Estrutura do projeto

```text
forge/
├── skills/                        # Plataforma Claude Code
│   └── <skill>/
│       ├── SKILL.md               # Definição do skill
│       ├── references/            # Conteúdo detalhado (carregado sob demanda)
│       ├── scripts/               # Scripts auxiliares
│       ├── agents/                # Definições de sub-agentes
│       └── hooks/                 # Hooks do Claude Code por skill (somente hook-owner skills)
├── platforms/                     # Adaptações para outras plataformas
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # Adaptação para OpenClaw
│           ├── references/        # Conteúdo específico da plataforma
│           └── scripts/           # Scripts específicos da plataforma
├── .claude-plugin/                # Metadados do marketplace do Claude Code
├── evals/                         # Cenários de avaliação multiplataforma
├── docs/
│   ├── user-guide/                # Guias de usuário (inglês)
│   ├── design/                    # Documentos de design
│   └── i18n/                      # Traduções (11 languages)
│       ├── README.*.md            # READMEs traduzidos
│       └── (translated guides moved to docs/user-guide/i18n/)
└── plugin.json                    # Metadados da coleção
```

## Contribuir

1. `skills/<name>/SKILL.md` — Skill para Claude Code + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — Adaptação para OpenClaw + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Cenários de avaliação
4. `.claude-plugin/marketplace.json` — Adicionar entrada ao array `plugins`
5. Hooks se necessário: crie `skills/<name>/hooks/hooks.json` + scripts; o `source` em marketplace.json deve apontar para `./skills/<name>`

Consulte [CLAUDE.md](../../CLAUDE.md) para as diretrizes completas de desenvolvimento.

## Licença

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
