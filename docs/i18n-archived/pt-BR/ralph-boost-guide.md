# Guia do Usuário do Ralph Boost

> Comece em 5 minutos — evite que seu loop de desenvolvimento autônomo com IA pare

---

## Instalação

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalação universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **Zero dependências** — Ralph Boost não depende de ralph-claude-code, block-break ou qualquer serviço externo. O caminho principal (loop Agent) tem zero dependências externas; o caminho de fallback requer `jq` ou `python` e a CLI `claude`.

---

## Comandos

| Comando | Função | Quando usar |
|---------|--------|-------------|
| `/ralph-boost setup` | Inicializar o loop autônomo no seu projeto | Primeira configuração |
| `/ralph-boost run` | Iniciar o loop autônomo na sessão atual | Após a inicialização |
| `/ralph-boost status` | Ver o estado atual do loop | Monitorar progresso |
| `/ralph-boost clean` | Remover arquivos do loop | Limpeza |

---

## Início Rápido

### 1. Inicializar o projeto

```text
/ralph-boost setup
```

Claude irá guiá-lo através de:
- Detecção do nome do projeto
- Geração de uma lista de tarefas (fix_plan.md)
- Criação do diretório `.ralph-boost/` e todos os arquivos de configuração

### 2. Iniciar o loop

```text
/ralph-boost run
```

Claude conduz o loop autônomo diretamente na sessão atual (modo loop Agent). Cada iteração gera um sub-agente para executar uma tarefa, enquanto a sessão principal atua como controlador do loop gerenciando o estado.

**Fallback** (ambientes headless / não supervisionados):

```bash
# Primeiro plano
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Segundo plano
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Monitorar status

```text
/ralph-boost status
```

Exemplo de saída:

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## Como Funciona

### Loop Autônomo

Ralph Boost oferece dois caminhos de execução:

**Caminho principal (loop Agent)**: Claude atua como controlador do loop na sessão atual, gerando um sub-agente a cada iteração para executar tarefas. A sessão principal gerencia o estado, o circuit breaker e a escalação de pressão. Zero dependências externas.

**Fallback (script bash)**: `boost-loop.sh` executa chamadas `claude -p` em loop em segundo plano. Suporta tanto jq quanto python como motores JSON, auto-detectados em tempo de execução. O tempo de espera padrão entre iterações é de 1 hora (configurável).

Ambos os caminhos compartilham o mesmo gerenciamento de estado (state.json), lógica de escalação de pressão e protocolo BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Circuit Breaker Aprimorado (vs ralph-claude-code)

Circuit breaker do ralph-claude-code: desiste após 3 loops consecutivos sem progresso.

Circuit breaker do ralph-boost: **escala a pressão progressivamente** quando travado, até 6-7 loops de auto-recuperação antes de parar.

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## Exemplos de Saída Esperada

### L0 — Execução Normal

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — Mudança de Abordagem

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude é forçado a abandonar a abordagem anterior e tentar algo **fundamentalmente diferente**. Ajustar parâmetros não conta.

### L2 — Pesquisar e Formular Hipóteses

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude deve: ler o erro palavra por palavra → pesquisar 50+ linhas de contexto → listar 3 hipóteses diferentes.

### L3 — Checklist

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude deve completar o checklist de 7 pontos (ler sinais de erro, buscar problema central, ler código-fonte, verificar suposições, hipótese reversa, reprodução mínima, trocar ferramentas/métodos). Cada item completado é escrito no state.json.

### L4 — Transferência Ordenada

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude constrói um PoC mínimo e então gera um relatório de transferência:

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

Após a conclusão da transferência, o loop encerra de forma ordenada. Isso não é "não consigo" — é "aqui está o limite."

---

## Configuração

`.ralph-boost/config.json`:

| Campo | Padrão | Descrição |
|-------|--------|-----------|
| `max_calls_per_hour` | 100 | Máximo de chamadas à API Claude por hora |
| `claude_timeout_minutes` | 15 | Timeout por chamada individual |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Ferramentas disponíveis para Claude |
| `claude_model` | "" | Substituição de modelo (vazio = padrão) |
| `session_expiry_hours` | 24 | Tempo de expiração da sessão |
| `no_progress_threshold` | 7 | Limite sem progresso antes do encerramento |
| `same_error_threshold` | 8 | Limite de mesmo erro antes do encerramento |
| `sleep_seconds` | 3600 | Tempo de espera entre iterações (segundos) |

### Ajustes de configuração comuns

**Acelerar o loop** (para testes):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Restringir permissões de ferramentas**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Usar um modelo específico**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Estrutura de Diretórios do Projeto

```
.ralph-boost/
├── PROMPT.md           # Instruções de desenvolvimento (inclui protocolo block-break)
├── fix_plan.md         # Lista de tarefas (atualizada automaticamente pelo Claude)
├── config.json         # Configuração
├── state.json          # Estado unificado (circuit breaker + pressão + sessão)
├── handoff-report.md   # Relatório de transferência L4 (gerado na saída ordenada)
├── logs/
│   ├── boost.log       # Log do loop
│   └── claude_output_*.log  # Saída por iteração
└── .gitignore          # Ignora estado e logs
```

Todos os arquivos ficam dentro de `.ralph-boost/` — o diretório raiz do seu projeto nunca é tocado.

---

## Relação com ralph-claude-code

Ralph Boost é uma **substituição independente** do [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), não um plugin de melhoria.

| Aspecto | ralph-claude-code | ralph-boost |
|---------|-------------------|-------------|
| Forma | Ferramenta Bash independente | Skill do Claude Code (loop Agent) |
| Instalação | `npm install` | Plugin do Claude Code |
| Tamanho do código | 2000+ linhas | ~400 linhas |
| Dependências externas | jq (obrigatório) | Caminho principal: zero; Fallback: jq ou python |
| Diretório | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Passivo (desiste após 3 loops) | Ativo (L0-L4, 6-7 loops de auto-recuperação) |
| Coexistência | Sim | Sim (zero conflitos de arquivos) |

Ambos podem ser instalados simultaneamente no mesmo projeto — usam diretórios separados e não interferem um no outro.

---

## Relação com Block Break

Ralph Boost adapta os mecanismos centrais do Block Break (escalação de pressão, metodologia de 5 passos, checklist) para cenários de loop autônomo:

| Aspecto | block-break | ralph-boost |
|---------|-------------|-------------|
| Cenário | Sessões interativas | Loops autônomos |
| Ativação | Hooks disparam automaticamente | Integrado no loop Agent / script do loop |
| Detecção | Hook PostToolUse | Detecção de progresso do loop Agent / detecção de progresso do script |
| Controle | Prompts injetados por hooks | Injeção de prompts do Agent / --append-system-prompt |
| Estado | `~/.forge/` | `.ralph-boost/state.json` |

O código é totalmente independente; os conceitos são compartilhados.

> **Referência**: A escalação de pressão (L0-L4), a metodologia de 5 passos e o checklist de 7 pontos do Block Break formam a base conceitual do circuit breaker do ralph-boost. Veja o [Guia do Usuário do Block Break](block-break-guide.md) para detalhes.

---

## FAQ

### Como escolho entre o caminho principal e o fallback?

`/ralph-boost run` usa o loop Agent (caminho principal) por padrão, executando diretamente na sessão atual do Claude Code. Use o script bash de fallback quando precisar de execução headless ou não supervisionada.

### Onde está o script do loop?

Após instalar o plugin forge, o script de fallback está em `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`. Você também pode copiá-lo para qualquer lugar e executá-lo de lá. O script auto-detecta jq ou python como seu motor JSON.

### Como vejo os logs do loop?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Como reinicio manualmente o nível de pressão?

Edite `.ralph-boost/state.json`: defina `pressure.level` como 0 e `circuit_breaker.consecutive_no_progress` como 0. Ou simplesmente delete state.json e reinicialize.

### Como modifico a lista de tarefas?

Edite `.ralph-boost/fix_plan.md` diretamente, usando o formato `- [ ] tarefa`. Claude a lê no início de cada iteração.

### Como recupero após a abertura do circuit breaker?

Edite `state.json`, defina `circuit_breaker.state` como `"CLOSED"`, reinicie os contadores relevantes e execute o script novamente.

### Preciso do ralph-claude-code?

Não. Ralph Boost é totalmente independente e não depende de nenhum arquivo Ralph.

### Quais plataformas são suportadas?

Atualmente suporta Claude Code (loop Agent como caminho principal). O script bash de fallback requer bash 4+, jq ou python e a CLI claude.

### Como validar os arquivos de skill do ralph-boost?

Use [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Quando usar / Quando NÃO usar

### ✅ Use quando

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ Não use quando

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> Motor de loop autônomo com garantia de convergência — precisa de objetivos claros e ambiente estável.

Análise completa de limites: [references/scope-boundaries.md](../../../skills/ralph-boost/references/scope-boundaries.md)

---

## Licença

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
