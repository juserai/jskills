# Forge

> Trabalhe mais, depois faça uma pausa. 7 skills para um ritmo de programação melhor com Claude Code.

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

## Instalação

```bash
# Claude Code (um único comando)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Hammer

| Skill | O que faz | Experimente |
|-------|-----------|-------------|
| **block-break** | Força a resolução exaustiva antes de desistir | `/block-break` |
| **ralph-boost** | Ciclos de desenvolvimento autônomos com garantia de convergência | `/ralph-boost setup` |

### Crucible

| Skill | O que faz | Experimente |
|-------|-----------|-------------|
| **council-fuse** | Deliberação multiperspectiva para respostas melhores | `/council-fuse <question>` |
| **insight-fuse** | Pesquisa sistemática multifonte com relatórios profissionais | `/insight-fuse <topic>` |
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

## Insight Fuse — Motor de Pesquisa Multifonte

Do tema ao relatório de pesquisa profissional. `/insight-fuse` executa um pipeline progressivo de 5 etapas: varredura → alinhamento → pesquisa → revisão → análise profunda.

Análise multiperspectiva integrada (Generalista/Crítico/Especialista), modelos de relatórios extensíveis e profundidade configurável. O irmão da série fuse do council-fuse — enquanto council-fuse delibera sobre informações conhecidas, insight-fuse coleta e sintetiza ativamente novas informações.

| Mecanismo | Descrição |
|-----------|-----------|
| **Pipeline de 5 Etapas** | Varredura → Alinhamento → Pesquisa → Revisão → Análise Profunda |
| **Profundidade Configurável** | quick (apenas varredura) / standard (pesquisa automática) / deep (+ multiperspectiva) / full (+ pontos de controle humanos) |
| **3 Perspectivas** | Generalista (amplitude) / Crítico (verificação) / Especialista (precisão) |
| **Modelos de Relatórios** | technology / market / competitive / personalizado — ou estrutura autogerada |
| **Padrões de Qualidade** | Multifonte obrigatório, integridade de citações, verificação de diversidade de fontes |

```text
/insight-fuse AI Agent riscos de segurança
/insight-fuse --depth quick --template technology WebAssembly
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist comercialização de computação quântica
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
│       └── agents/                # Definições de sub-agentes
├── platforms/                     # Adaptações para outras plataformas
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # Adaptação para OpenClaw
│           ├── references/        # Conteúdo específico da plataforma
│           └── scripts/           # Scripts específicos da plataforma
├── .claude-plugin/                # Metadados do marketplace do Claude Code
├── hooks/                         # Hooks da plataforma Claude Code
├── evals/                         # Cenários de avaliação multiplataforma
├── docs/
│   ├── guide/                     # Guias de usuário (inglês)
│   ├── plans/                     # Documentos de design
│   └── i18n/                      # Traduções (11 languages)
│       ├── README.*.md            # READMEs traduzidos
│       └── guide/*-guide.*.md     # Guias traduzidos
└── plugin.json                    # Metadados da coleção
```

## Contribuir

1. `skills/<name>/SKILL.md` — Skill para Claude Code + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — Adaptação para OpenClaw + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Cenários de avaliação
4. `.claude-plugin/marketplace.json` — Adicionar entrada ao array `plugins`
5. Hooks se necessário em `hooks/hooks.json`

Consulte [CLAUDE.md](../../CLAUDE.md) para as diretrizes completas de desenvolvimento.

## Licença

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
