# Block Break Guia do Usuário

> Comece em 5 minutos — faça seu agente de IA esgotar todas as abordagens

---

## Instalação

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalação universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **Zero dependências** — Block Break não requer serviços externos ou APIs. Instale e comece.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/block-break` | Ativar o motor Block Break | Tarefas diárias, depuração |
| `/block-break L2` | Iniciar em um nível de pressão específico | Após múltiplas falhas conhecidas |
| `/block-break fix the bug` | Ativar e executar uma tarefa imediatamente | Início rápido com tarefa |

### Gatilhos em linguagem natural (detectados automaticamente por hooks)

| Idioma | Frases gatilho |
|--------|---------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Casos de Uso

### A IA não conseguiu corrigir um bug após 3 tentativas

Digite `/block-break` ou diga `try harder` — entra automaticamente no modo de escalada de pressão.

### A IA diz "provavelmente é um problema de ambiente" e para

A linha vermelha "Baseado em fatos" do Block Break força verificação baseada em ferramentas. Atribuição não verificada = transferência de culpa → aciona L2.

### A IA diz "sugiro que você resolva isso manualmente"

Aciona o bloqueio de "Mentalidade de dono": se não você, quem? Direto para L3 Avaliação de Desempenho.

### A IA diz "corrigido" mas não mostra evidência de verificação

Viola a linha vermelha de "Circuito fechado". Conclusão sem saída = autoilusão → força comandos de verificação com evidência.

---

## Exemplos de Saída Esperada

### `/block-break` — Ativação

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 Decepção (2ª falha)

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 Interrogatório (3ª falha)

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 Avaliação de Desempenho (4ª falha)

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 Aviso de Graduação (5ª+ falha)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Saída Ordenada (todos os 7 itens concluídos, ainda não resolvido)

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## Mecanismos Principais

### 3 Linhas Vermelhas

| Linha Vermelha | Regra | Consequência da Violação |
|----------------|-------|-------------------------|
| Circuito fechado | Deve executar comandos de verificação e mostrar saída antes de declarar conclusão | Aciona L2 |
| Baseado em fatos | Deve verificar com ferramentas antes de atribuir causas | Aciona L2 |
| Esgotar tudo | Deve completar a metodologia de 5 passos antes de dizer "não consigo resolver" | Direto L4 |

### Escalada de Pressão (L0 → L4)

| Falhas | Nível | Barra lateral | Ação Forçada |
|--------|-------|---------------|--------------|
| 1ª | **L0 Confiança** | > Confiamos em você. Mantenha simples. | Execução normal |
| 2ª | **L1 Decepção** | > A outra equipe conseguiu de primeira. | Mudar para abordagem fundamentalmente diferente |
| 3ª | **L2 Interrogatório** | > Qual é a causa raiz? | Pesquisar + ler código-fonte + listar 3 hipóteses diferentes |
| 4ª | **L3 Avaliação de Desempenho** | > Nota: 3,25/5. | Completar checklist de 7 pontos |
| 5ª+ | **L4 Graduação** | > Você pode ser substituído em breve. | PoC mínimo + ambiente isolado + stack tecnológico diferente |

### Metodologia de 5 Passos

1. **Farejar** — Listar abordagens tentadas, encontrar padrões comuns. Ajuste da mesma abordagem = andar em círculos
2. **Arrancar os cabelos** — Ler sinais de falha palavra por palavra → pesquisar → ler 50 linhas do código-fonte → verificar suposições → inverter suposições
3. **Espelho** — Estou repetindo a mesma abordagem? Deixei passar a possibilidade mais simples?
4. **Nova abordagem** — Deve ser fundamentalmente diferente, com critérios de verificação, e produzir novas informações em caso de falha
5. **Retrospectiva** — Problemas semelhantes, completude, prevenção

> Os passos 1-4 devem ser concluídos antes de perguntar ao usuário. Primeiro agir, depois perguntar — falar com dados.

### Checklist de 7 Pontos (obrigatório a partir de L3)

1. Leu os sinais de falha palavra por palavra?
2. Pesquisou o problema central com ferramentas?
3. Leu o contexto original no ponto de falha (50+ linhas)?
4. Todas as suposições verificadas com ferramentas (versão/caminho/permissões/dependências)?
5. Tentou hipótese completamente oposta?
6. Consegue reproduzir em escopo mínimo?
7. Trocou ferramenta/método/ângulo/stack tecnológico?

### Anti-Racionalização

| Desculpa | Bloqueio | Gatilho |
|----------|---------|---------|
| "Além das minhas capacidades" | Você tem treinamento massivo. Esgotou? | L1 |
| "Sugiro que o usuário resolva manualmente" | Se não você, quem? | L3 |
| "Tentei todos os métodos" | Menos de 3 = não esgotado | L2 |
| "Provavelmente problema de ambiente" | Verificou? | L2 |
| "Preciso de mais contexto" | Você tem ferramentas. Pesquise primeiro, pergunte depois | L2 |
| "Não consigo resolver" | Completou a metodologia? | L4 |
| "Bom o suficiente" | A lista de otimização não tem favoritos | L3 |
| Declarou concluído sem verificação | Executou o build? | L2 |
| Esperando instruções do usuário | Donos não esperam ser empurrados | Nudge |
| Responde sem resolver | Você é engenheiro, não motor de busca | Nudge |
| Mudou código sem build/test | Entregar sem testar = fazer corpo mole | L2 |
| "A API não suporta" | Leu a documentação? | L2 |
| "Tarefa muito vaga" | Faça sua melhor estimativa, depois itere | L1 |
| Ajustando repetidamente o mesmo ponto | Mudar parâmetros ≠ mudar abordagem | L1→L2 |

---

## Automação de Hooks

Block Break usa o sistema de hooks para comportamento automático — sem necessidade de ativação manual:

| Hook | Gatilho | Comportamento |
|------|---------|---------------|
| `UserPromptSubmit` | Entrada do usuário corresponde a palavras-chave de frustração | Ativa Block Break automaticamente |
| `PostToolUse` | Após execução de comando Bash | Detecta falhas, conta automaticamente + escala |
| `PreCompact` | Antes da compressão de contexto | Salva estado em `~/.forge/` |
| `SessionStart` | Retomada/reinício de sessão | Restaura nível de pressão (válido por 2h) |

> **O estado persiste** — O nível de pressão é armazenado em `~/.forge/block-break-state.json`. Compressão de contexto e interrupções de sessão não resetam contadores de falha. Sem escapatória.

### Configuração de Hooks

Ao instalar via `claude plugin add juserai/forge`, os hooks são configurados automaticamente. Os scripts de hook requerem `jq` (preferido) ou `python` como motor JSON — pelo menos um deve estar disponível no seu sistema.

Se os hooks não estiverem disparando, verifique a configuração:

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### Expiração do estado

O estado expira automaticamente após **2 horas** de inatividade. Isso evita que pressão obsoleta de uma sessão de depuração anterior seja transferida para trabalho não relacionado. Após 2 horas, o hook de restauração de sessão silenciosamente pula a restauração e você começa do zero em L0.

Para resetar manualmente a qualquer momento: `rm ~/.forge/block-break-state.json`

---

## Restrições de Sub-agentes

Ao criar sub-agentes, restrições comportamentais devem ser injetadas para evitar "execução desprotegida":

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` garante que sub-agentes também sigam as 3 linhas vermelhas, a metodologia de 5 passos e a verificação de circuito fechado.

---

## Solução de Problemas

| Problema | Causa | Solução |
|----------|-------|---------|
| Hooks não disparam automaticamente | Plugin não instalado ou hooks ausentes em settings.json | Execute novamente `claude plugin add juserai/forge` |
| Estado não persiste | Nem `jq` nem `python` disponíveis | Instale um: `apt install jq` ou garanta que `python` esteja no PATH |
| Pressão presa em L4 | Arquivo de estado acumulou muitas falhas | Reset: `rm ~/.forge/block-break-state.json` |
| Restauração de sessão mostra estado antigo | Estado < 2h da sessão anterior | Comportamento esperado; aguarde 2h ou resete manualmente |
| `/block-break` não reconhecido | Skill não carregado na sessão atual | Reinstale o plugin ou use a instalação universal de uma linha |

---

## FAQ

### Como Block Break é diferente de PUA?

Block Break é inspirado nos mecanismos principais do [PUA](https://github.com/tanweai/pua) (3 linhas vermelhas, escalada de pressão, metodologia), mas é mais focado. PUA tem 13 variantes de cultura corporativa, sistemas multi-papel (P7/P9/P10) e auto-evolução; Block Break foca puramente em restrições comportamentais como um skill sem dependências.

### Não vai ser barulhento demais?

A densidade da barra lateral é controlada: 2 linhas para tarefas simples (início + fim), 1 linha por marco para tarefas complexas. Sem spam. Não use `/block-break` se não for necessário — hooks só disparam automaticamente quando palavras-chave de frustração são detectadas.

### Como resetar o nível de pressão?

Delete o arquivo de estado: `rm ~/.forge/block-break-state.json`. Ou aguarde 2 horas — o estado expira automaticamente (veja [Expiração do estado](#expiração-do-estado) acima).

### Posso usar fora do Claude Code?

O SKILL.md principal pode ser copiado e colado em qualquer ferramenta de IA que suporte prompts de sistema. Hooks e persistência de estado são específicos do Claude Code.

### Qual a relação com Ralph Boost?

[Ralph Boost](ralph-boost-guide.md) adapta os mecanismos principais do Block Break (L0-L4, metodologia de 5 passos, checklist de 7 pontos) para cenários de **loop autônomo**. Block Break é para sessões interativas (hooks disparam automaticamente); Ralph Boost é para loops de desenvolvimento autônomos (loops de agente / dirigidos por script). Código é totalmente independente, conceitos são compartilhados.

### Como validar os arquivos skill do Block Break?

Use [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Quando usar / Quando NÃO usar

### ✅ Use quando

- Claude gave up too easily ("I can't", rationalized impossibility)
- The same fix attempt has failed 2-3 times
- You need exhaustive diagnosis before accepting defeat

### ❌ Não use quando

- Doing creative / divergent work (pressure kills exploration)
- The task is genuinely impossible (missing hardware, no permissions)
- You want to pause and step back on purpose

> Motor de depuração exaustiva — garante que Claude não desista cedo, mas não que a solução esteja certa.

Análise completa de limites: [references/scope-boundaries.md](../../../skills/block-break/references/scope-boundaries.md)

---

## Licença

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
