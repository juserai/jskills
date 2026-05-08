# Guia do Usuário Claim Ground

> Disciplina epistêmica em 3 minutos — ancore cada afirmação do "momento atual" em evidência de runtime (v1.1: also anchors standards-body term definitions to authoritative evidence; adds /claim-ground verify manual mode)

---

## Instalação

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalação universal uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **Zero dependências** — Claim Ground é restrição comportamental pura. Sem scripts, sem hooks, sem serviços externos.

---

## Como funciona

Claim Ground é uma skill **auto-acionada**. Não há comando slash — a skill ativa com base na natureza da pergunta. Intencional: desvio factual pode ocorrer em qualquer ponto da conversa, e comando manual seria fácil de esquecer quando mais necessário.

| Condição de ativação | Exemplo |
|---------------------|---------|
| Pergunta factual sobre estado atual | "Qual modelo está rodando?" / "Qual versão instalada?" / "O que tem no meu PATH?" |
| Usuário questiona afirmação anterior | "Sério?" / "Tem certeza?" / "Achei que já tinha atualizado" |
| Auto-verificação antes de afirmar | Antes de Claude escrever "o X atual é Y" |

---

## Regras principais

1. **Runtime > Training** — Prompt do sistema, env vars e saídas de ferramentas sempre superam a memória. Em conflito, runtime vence; cite a fonte.
2. **Cite primeiro, conclua depois** — Cole o fragmento de evidência ("prompt do sistema diz: ...") *antes* de tirar conclusão.
3. **Exemplos ≠ listas exaustivas** — Um `--model <model>` no help do CLI é exemplo, não enumeração completa.
4. **Questionado → reverificar, não reformular** — Quando usuário contesta, releia o contexto / reexecute ferramentas. Reformular a mesma resposta errada = violação de linha vermelha.
5. **Incerto → diga incerto** — Se nem contexto nem ferramentas podem verificar, diga "não tenho certeza" em vez de adivinhar.

---

## Linhas vermelhas (invioláveis)

Linhas vermelhas são proibições *sempre ativas*. Violar qualquer uma significa que a skill falhou, independentemente de como o restante da resposta pareça.

| # | Linha vermelha | Modo de alucinação bloqueado |
|---|----------------|------------------------------|
| 1 | **Afirmação sem fonte** — tirar uma conclusão sobre o estado atual sem citar evidência runtime | Factuality × extrinsic hallucination |
| 2 | **Exemplo como enumeração** — inferir uma lista completa a partir de um exemplo de CLI help / trecho de documentação | Overgeneralization |
| 3 | **Reformular em vez de reverificar** — repetir a mesma resposta após pushback do usuário sem novas chamadas de ferramenta (inclui 3a: pushback com citação é mais arriscado) | Pushback sycophancy |
| 4 | **Afirmação sobre código/API sem Read/Grep** — afirmar que um símbolo existe / tem assinatura X sem primeiro ler o arquivo definidor | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **Citação sem WebFetch** — citar URL / paper / DOI / endpoint de API sem fazer fetch real primeiro | Citation fabrication (taxa base de 19,9% segundo [EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130)) |
| 6 | **Resumo sem ancoragem por linha** — resumir arquivo/PR/log específico sem citar números de linha / seções por afirmação | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

Definições completas com sinais, exemplos bons/ruins e casos limítrofes: [references/red-lines.md](../../skills/claim-ground/references/red-lines.md).

---

## Exemplos bons / ruins

### Exemplo 1: modelo atual

**❌ Ruim**

> O modelo atual é Claude Opus 4.6. Este é o modelo Claude mais recente.

Memória pura. Sem citação.

**✅ Bom**

> Prompt do sistema diz: *"You are powered by the model named Opus 4.7 (1M context)"*. O modelo atual é Opus 4.7.

### Exemplo 2: lista de suporte CLI

**❌ Ruim**

> O help do CLI mostra exemplo `claude-sonnet-4-6`, então o CLI só suporta a série 4.6.

**✅ Bom**

> Help do CLI mostra exemplo `claude-sonnet-4-6` — é um placeholder, não lista completa. Consulte docs oficiais para lista completa.

### Exemplo 3: questionamento do usuário

**❌ Ruim**

> **Usuário**: Realmente é 4.6? Achei que tinha atualizado.
> **Agent**: Sim, como eu disse, o mais recente é a série 4.6.

**✅ Bom**

> **Usuário**: Realmente é 4.6? Achei que tinha atualizado.
> **Agent**: Deixe-me reler o prompt do sistema. *"Opus 4.7 (1M context)"*. Você está certo — minha resposta anterior estava errada. O modelo atual é Opus 4.7.

---

## Playbook de verificação

| Tipo de pergunta | Evidência primária |
|------------------|--------------------|
| Modelo atual | Campo model no prompt do sistema |
| Versão CLI / modelos suportados | `<cli> --version` / `<cli> --help` + docs oficiais |
| Pacotes instalados | `npm ls -g`, `pip show`, `brew list` |
| Env vars | `env`, `printenv`, `echo $VAR` |
| Existência de arquivos | `ls`, `test -e`, ferramenta Read |
| Estado Git | `git branch --show-current`, `git log` |
| Data atual | Campo `currentDate` do prompt ou comando `date` |

Versão completa: `skills/claim-ground/references/playbook.md`.

---

## Interação com outras skills forge

### Com block-break

**Ortogonal, complementar**. block-break diz "não desista"; claim-ground diz "não afirme sem evidência".

Quando ambos ativam: block-break previne desistência, claim-ground força reverificação.

### Com skill-lint

**Categorias diferentes**. skill-lint é **anvil** (valida arquivos estáticos de plugin, emite pass/fail); claim-ground é **hammer** (restringe a saída epistêmica do próprio Claude em runtime). Responsabilidades não se sobrepõem.

---

## FAQ

### Por que não tem comando slash?

Desvio factual pode ocorrer em qualquer resposta. Comando manual é fácil de esquecer quando mais necessário. Ativação automática por descrição é mais confiável.

### Ativa em toda pergunta?

Não. Apenas em duas formas: **estado atual do sistema** ou **contra-argumento do usuário a afirmação prévia**.

### E se eu quiser que Claude adivinhe?

Reformule como "faça um chute educado sobre X" ou "lembre dos dados de treinamento: X". Claim Ground entenderá que não é pergunta sobre runtime.

### Como sei se ativou?

Procure padrões de citação na resposta: `prompt do sistema diz: "..."`, `saída do comando: ...`. Evidência antes de conclusão = ativado.

---

## Quando usar / Quando NÃO usar

### ✅ Use quando

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ Não use quando

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> Portal de afirmações factuais — garante citações, não a correção, nem trata pensamento não factual.

Análise completa de limites: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## Licença

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
