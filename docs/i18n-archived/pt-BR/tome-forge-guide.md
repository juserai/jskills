# Guia do Usuario do Tome Forge

> Comece em 5 minutos — base de conhecimento pessoal com wiki compilado por LLM

---

## Instalacao

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalacao universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **Zero dependencias** — Tome Forge nao requer servicos externos, banco de dados vetorial ou infraestrutura RAG. Instale e pronto.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/tome-forge init` | Inicializar uma base de conhecimento | Ao iniciar um novo KB em qualquer diretorio |
| `/tome-forge capture [text]` | Captura rapida de nota, link ou area de transferencia | Anotar pensamentos, salvar URLs, recortar conteudo |
| `/tome-forge capture clip` | Capturar da area de transferencia do sistema | Salvamento rapido de conteudo copiado |
| `/tome-forge ingest <path>` | Compilar material bruto em wiki | Apos adicionar artigos, papers ou notas ao `raw/` |
| `/tome-forge ingest <path> --dry-run` | Visualizar roteamento sem gravar | Verificar antes de confirmar alteracoes |
| `/tome-forge query <question>` | Pesquisar e sintetizar a partir do wiki | Encontrar respostas em toda a base de conhecimento |
| `/tome-forge lint` | Verificacao de saude da estrutura do wiki | Antes de commits, manutencao periodica |
| `/tome-forge compile` | Compilar em lote todos os novos materiais brutos | Atualizar apos adicionar multiplos arquivos brutos |

---

## Como Funciona

Baseado no padrao LLM Wiki de Karpathy:

```
raw materials + LLM compilation = structured Markdown wiki
```

### A Arquitetura de Duas Camadas

| Camada | Proprietario | Proposito |
|--------|-------------|-----------|
| `raw/` | Voce | Materiais-fonte imutaveis — papers, artigos, notas, links |
| `wiki/` | LLM | Paginas Markdown compiladas, estruturadas e com referencias cruzadas |

O LLM le seus materiais brutos e os compila em paginas wiki bem estruturadas. Voce nunca edita `wiki/` diretamente — voce adiciona materiais brutos e deixa o LLM manter o wiki.

### A Secao Sagrada

Cada pagina wiki tem uma secao `## Meu Delta de Compreensao`. Esta e **sua** — o LLM nunca a modificara. Escreva aqui suas percepcoes pessoais, discordancias ou intuicoes. Ela sobrevive a todas as recompilacoes.

---

## Descoberta de KB — Para Onde Vao Meus Dados?

Voce pode executar `/tome-forge` de **qualquer diretorio**. Ele encontra automaticamente o KB correto:

| Situacao | O que acontece |
|----------|---------------|
| O diretorio atual (ou pai) contem `.tome-forge.json` | Usa esse KB |
| Nenhum `.tome-forge.json` encontrado acima | Usa o padrao `~/.tome-forge/` (criado automaticamente se necessario) |

Isso significa que voce pode capturar notas de qualquer projeto sem fazer `cd` primeiro — tudo e canalizado para seu unico KB padrao.

Quer KBs separados por projeto? Use `init .` dentro do diretorio do projeto.

## Fluxo de Trabalho

### 1. Inicializar

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

Apos a inicializacao, o diretorio do KB fica assim:

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

De **qualquer diretorio**, basta executar:

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

Capturas rapidas vao para `raw/captures/{date}/`. Para materiais mais longos, coloque arquivos diretamente em `raw/papers/`, `raw/articles/`, etc.

### 3. Ingerir

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

O LLM le o arquivo bruto, direciona-o para a(s) pagina(s) wiki correta(s) e mescla novas informacoes preservando suas notas pessoais.

### 4. Consultar

```
/tome-forge query "what is the relationship between attention and transformers?"
```

Sintetiza uma resposta a partir do seu wiki, citando paginas especificas. Informa se ha informacoes faltando e qual material bruto adicionar.

### 5. Manter

```
/tome-forge lint
/tome-forge compile
```

Lint verifica a integridade estrutural. Compile ingere em lote tudo que e novo desde a ultima compilacao.

---

## Estrutura de Diretorios

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

## Formato da Pagina Wiki

Cada pagina wiki segue um modelo rigoroso:

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

Secoes obrigatorias:
- **Conceito Central** — Conhecimento mantido pelo LLM
- **Meu Delta de Compreensao** — Suas percepcoes pessoais (nunca tocadas pelo LLM)
- **Perguntas Abertas** — Perguntas nao respondidas
- **Conexoes** — Links para paginas wiki relacionadas

---

## Cadencia Recomendada

| Frequencia | Acao | Tempo |
|------------|------|-------|
| **Diario** | `capture` para pensamentos, links, area de transferencia | 2 min |
| **Semanal** | `compile` para processar em lote os materiais da semana | 15-30 min |
| **Mensal** | `lint` + revisar secoes de Meu Delta de Compreensao | 30 min |

**Evite ingestao em tempo real.** Ingestoes frequentes de arquivos individuais fragmentam a coerencia do wiki. A compilacao semanal em lote produz melhores referencias cruzadas e paginas mais consistentes.

---

## Roteiro de Escalabilidade

| Fase | Tamanho do Wiki | Estrategia |
|------|----------------|------------|
| 1. Partida a frio (semana 1-4) | < 30 paginas | Leitura de contexto completo, roteamento por index.md |
| 2. Estado estavel (mes 2-3) | 30-100 paginas | Fragmentacao por topico (wiki/ai/, wiki/systems/) |
| 3. Escala (mes 4-6) | 100-200 paginas | Consultas por fragmento, suplemento com ripgrep |
| 4. Avancado (6+ meses) | 200+ paginas | Roteamento baseado em embeddings (nao recuperacao), compilacao incremental |

---

## Riscos Conhecidos

| Risco | Impacto | Mitigacao |
|-------|---------|----------|
| **Deriva de redacao** | Multiplas compilacoes suavizam a voz pessoal | `compiled_by` rastreia o modelo; raw/ e a fonte da verdade; recompilar a partir do raw a qualquer momento |
| **Teto de escala** | Janela de contexto limita o tamanho do wiki | Fragmentar por dominio; usar roteamento por indice; camada de embeddings quando > 200 paginas |
| **Dependencia de fornecedor** | Vinculado a um provedor de LLM | Fontes brutas sao Markdown puro; trocar modelo e recompilar |
| **Corrupcao do Delta** | LLM sobrescreve percepcoes pessoais | Verificacao diff pos-ingestao restaura automaticamente o Delta original |

---

## Plataformas

| Plataforma | Como funciona |
|------------|--------------|
| Claude Code | Acesso completo ao sistema de arquivos, leituras paralelas, integracao com git |
| OpenClaw | Mesmas operacoes, adaptadas as convencoes de ferramentas do OpenClaw |

---

## Quando usar / Quando NÃO usar

### ✅ Use quando

- Building a personal knowledge base from scattered notes
- You want LLM-compiled wiki that preserves human insights
- Zero-infra solution (just Markdown + Git)

### ❌ Não use quando

- Team collaboration or real-time sync
- Ad-hoc notes (too structured — plain Markdown is fine)
- Transactional data (use a real database)

> Biblioteca pessoal compilada por LLM — preserva insights humanos, projetada para indivíduos, sem sync em tempo real nem controle de permissões.

Análise completa de limites: [references/scope-boundaries.md](../../../skills/tome-forge/references/scope-boundaries.md)

---

## FAQ

**P: Qual o tamanho maximo do wiki?**
R: Menos de 50 paginas, o LLM le tudo. De 50 a 200 paginas, usa o indice para navegar. Acima de 200, considere a fragmentacao por dominio.

**P: Posso editar paginas wiki diretamente?**
R: Apenas a secao `## Meu Delta de Compreensao`. Todo o resto sera sobrescrito na proxima ingestao/compilacao.

**P: Precisa de banco de dados vetorial?**
R: Nao. O wiki e Markdown puro. O LLM le arquivos diretamente — sem embeddings, sem RAG, sem infraestrutura.

**P: Como faco backup do meu KB?**
R: Sao todos arquivos em um repositorio git. `git push` e pronto.

**P: E se o LLM cometer um erro no wiki?**
R: Adicione uma correcao ao `raw/` e ingira novamente. O algoritmo de mesclagem prefere fontes mais autoritativas. Ou anote discordancias no seu Meu Delta de Compreensao.
