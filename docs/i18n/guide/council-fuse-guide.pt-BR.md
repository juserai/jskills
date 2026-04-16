# Guia do Usuario do Council Fuse

> Comece em 5 minutos — deliberacao multi-perspectiva para melhores respostas

---

## Instalacao

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalacao universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **Zero dependencias** — Council Fuse nao requer servicos externos ou APIs. Instale e pronto.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/council-fuse <pergunta>` | Executar uma deliberacao completa do conselho | Decisoes importantes, perguntas complexas |

---

## Como Funciona

Council Fuse destila o padrao LLM Council de Karpathy em um unico comando:

### Estagio 1: Convocar

Tres agentes sao gerados **em paralelo**, cada um com uma perspectiva diferente:

| Agente | Papel | Modelo | Ponto forte |
|--------|-------|--------|-------------|
| Generalista | Equilibrado, pratico | Sonnet | Melhores praticas convencionais |
| Critico | Adversarial, encontra falhas | Opus | Casos extremos, riscos, pontos cegos |
| Especialista | Detalhe tecnico profundo | Sonnet | Precisao de implementacao |

Cada agente responde **independentemente** — eles nao podem ver as respostas uns dos outros.

### Estagio 2: Pontuar

O Presidente (agente principal) anonimiza todas as respostas como Resposta A/B/C e pontua cada uma em 4 dimensoes (0-10):

- **Correcao** — precisao factual, solidez logica
- **Completude** — cobertura de todos os aspectos
- **Praticidade** — aplicabilidade, utilidade no mundo real
- **Clareza** — estrutura, legibilidade

### Estagio 3: Sintetizar

A resposta com maior pontuacao se torna o esqueleto. Insights unicos das outras respostas sao integrados. As objecoes validas do critico sao preservadas como ressalvas.

---

## Casos de Uso

### Decisoes de arquitetura

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

O generalista fornece compensacoes equilibradas, o critico questiona o hype dos microsservicos e o especialista detalha padroes de migracao. A sintese oferece uma recomendacao condicional.

### Escolhas de tecnologia

```
/council-fuse Redis vs PostgreSQL for our job queue
```

Tres angulos diferentes garantem que voce nao perca preocupacoes operacionais (critico), detalhes de implementacao (especialista) ou o padrao pragmatico (generalista).

### Revisao de codigo

```
/council-fuse Is this error handling pattern correct? <paste code>
```

Obtenha validacao convencional, analise adversarial de casos extremos e verificacao tecnica profunda em uma unica passada.

---

## Estrutura de Saida

Cada deliberacao do conselho produz:

1. **Matriz de pontuacao** — pontuacao transparente de todas as tres perspectivas
2. **Analise de consenso** — onde concordam e discordam
3. **Resposta sintetizada** — a melhor resposta fusionada
4. **Opiniao minoritaria** — visoes dissidentes validas que merecem atencao

---

## Personalizacao

### Alterar perspectivas

Edite `agents/*.md` para definir membros personalizados do conselho. Triades alternativas:

- Otimista / Pessimista / Pragmatico
- Arquiteto / Implementador / Testador
- Defensor do usuario / Desenvolvedor / Especialista em seguranca

### Alterar modelos

Edite o campo `model:` em cada arquivo de agente:

- `model: haiku` — conselhos economicos
- `model: opus` — peso pesado completo para decisoes criticas

---

## Plataformas

| Plataforma | Como os membros do conselho funcionam |
|------------|--------------------------------------|
| Claude Code | 3 spawns de agentes independentes em paralelo |
| OpenClaw | Agente unico, 3 rodadas de raciocinio independentes sequenciais |

---

## Perguntas Frequentes

**P: Custa 3x mais tokens?**
R: Sim, aproximadamente. Tres respostas independentes mais sintese. Use para decisoes que justifiquem o investimento.

**P: Posso adicionar mais membros ao conselho?**
R: O framework suporta isso — adicione outro arquivo `agents/*.md` e atualize o fluxo de trabalho no SKILL.md. No entanto, 3 e o ponto ideal entre custo e diversidade.

**P: O que acontece se um agente falhar?**
R: O Presidente atribui pontuacao 0 a esse membro e sintetiza a partir das respostas restantes. Degradacao elegante, sem travamentos.
