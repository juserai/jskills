# Guia do Usuário do News Fetch

> Comece em 3 minutos — deixe a IA buscar seu resumo de notícias

Esgotado de depurar? Tire 2 minutos, acompanhe o que está acontecendo no mundo e volte renovado.

---

## Instalação

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalação universal de uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **Zero dependências** — News Fetch não requer serviços externos ou chaves de API. Instale e pronto.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/news-fetch AI` | Buscar notícias de IA desta semana | Atualização rápida do setor |
| `/news-fetch AI today` | Buscar notícias de IA de hoje | Resumo diário |
| `/news-fetch robotics month` | Buscar notícias de robótica deste mês | Revisão mensal |
| `/news-fetch climate 2026-03-01~2026-03-31` | Buscar notícias de um período específico | Pesquisa direcionada |

---

## Casos de Uso

### Resumo diário de tecnologia

```
/news-fetch AI today
```

Obtenha as últimas notícias de IA do dia, classificadas por relevância. Escaneie manchetes e resumos em segundos.

### Pesquisa do setor

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Extraia notícias de um período específico para apoiar análise de mercado e pesquisa competitiva.

### Notícias multilíngues

Tópicos em chinês recebem automaticamente buscas complementares em inglês para maior cobertura, e vice-versa. Você obtém o melhor dos dois mundos sem esforço extra.

---

## Exemplo de Saída Esperada

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## Fallback de Rede de 3 Camadas

News Fetch possui uma estratégia de fallback integrada para garantir que a busca de notícias funcione em diferentes condições de rede:

| Camada | Ferramenta | Fonte de Dados | Gatilho |
|--------|-----------|----------------|---------|
| **L1** | WebSearch | Google/Bing | Padrão (preferido) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 falha |
| **L3** | Bash curl | Mesmas fontes do L2 | L2 também falha |

Quando todas as camadas falham, um relatório de falha estruturado é produzido listando o motivo da falha para cada fonte.

---

## Recursos de Saída

| Recurso | Descrição |
|---------|-----------|
| **Deduplicação** | Quando múltiplas fontes cobrem o mesmo evento, a entrada com maior pontuação é mantida; as demais são agrupadas em "Cobertura relacionada" |
| **Complementação de resumo** | Se os resultados de busca não possuem resumo, o corpo do artigo é buscado e um resumo é gerado |
| **Pontuação de relevância** | A IA pontua cada resultado por relevância temática — maior significa mais relevante |
| **Links clicáveis** | Formato de link Markdown — clicável em IDEs e terminais |

---

## Pontuação de Relevância

Cada artigo é pontuado de 0 a 300 com base em quão bem seu título e resumo correspondem ao tópico solicitado:

| Faixa de Pontuação | Significado |
|--------------------|-------------|
| 200-300 | Altamente relevante — o tópico é o assunto principal |
| 100-199 | Moderadamente relevante — o tópico é mencionado significativamente |
| 0-99 | Tangencialmente relevante — o tópico aparece de passagem |

Os artigos são ordenados por pontuação em ordem decrescente. A pontuação é heurística e baseada em densidade de palavras-chave, correspondência de título e relevância contextual.

## Solução de Problemas de Fallback de Rede

| Sintoma | Causa Provável | Solução |
|---------|---------------|---------|
| L1 retorna 0 resultados | Ferramenta WebSearch indisponível ou consulta muito específica | Ampliar a palavra-chave do tópico |
| L2 todas as fontes falham | Sites de notícias nacionais bloqueando acesso automatizado | Aguardar e tentar novamente, ou verificar se `curl` funciona manualmente |
| L3 curl tempo esgotado | Problema de conectividade de rede | Verificar `curl -I https://news.baidu.com` |
| Todas as camadas falham | Sem acesso à internet ou todas as fontes fora do ar | Verificar rede; o relatório de falhas lista o erro de cada fonte |

---

## Perguntas Frequentes

### Preciso de uma chave de API?

Não. News Fetch depende inteiramente de WebSearch e web scraping público. Nenhuma configuração necessária.

### Ele pode buscar notícias em inglês?

Com certeza. Tópicos em chinês incluem automaticamente buscas complementares em inglês, e tópicos em inglês funcionam nativamente. A cobertura abrange ambos os idiomas.

### E se minha rede for restrita?

A estratégia de fallback de 3 camadas lida com isso automaticamente. Mesmo que o WebSearch esteja indisponível, News Fetch recorre a fontes de notícias nacionais.

### Quantos artigos são retornados?

Até 20 (após deduplicação). A contagem real depende do que as fontes de dados retornam.

---

## Quando usar / Quando NÃO usar

### ✅ Use quando

- You want a quick news brief between coding sessions
- Bilingual aggregation (English + domestic sources)
- Network-restricted environments (3-tier fallback handles blocked sources)

### ❌ Não use quando

- You need synthesized research (use `insight-fuse` instead)
- Targeted source monitoring (use an RSS reader)
- Translation tasks (news-fetch returns source language as-is)

> Resumo de notícias para pausas de código — scan de 2 minutos, sem análise profunda ou tradução.

Análise completa de limites: [references/scope-boundaries.md](../../../skills/news-fetch/references/scope-boundaries.md)

---

## Licença

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
