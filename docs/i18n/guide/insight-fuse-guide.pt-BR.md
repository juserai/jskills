# Guia do Usuario Insight Fuse

> Motor sistematico de pesquisa multi-fonte — Do tema ao relatorio de pesquisa profissional

## Inicio rapido

```bash
# Pesquisa completa (5 estagios, com checkpoints manuais)
/insight-fuse AI Agent riscos de seguranca

# Varredura rapida (apenas Stage 1)
/insight-fuse --depth quick computacao quantica

# Usar um template especifico
/insight-fuse --template technology WebAssembly

# Pesquisa profunda com perspectivas personalizadas
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist comercializacao de direcao autonoma
```

## Parametros

| Parametro | Descricao | Exemplo |
|-----------|-----------|---------|
| `topic` | Tema de pesquisa (obrigatorio) | `AI Agent riscos de seguranca` |
| `--depth` | Profundidade da pesquisa | `quick` / `standard` / `deep` / `full` |
| `--template` | Template de relatorio | `technology` / `market` / `competitive` |
| `--perspectives` | Lista de perspectivas | `optimist,pessimist,pragmatist` |

## Modos de profundidade

### quick — Varredura rapida
Executa Stage 1. 3+ consultas de busca, 5+ fontes, gera um relatorio breve. Ideal para obter uma visao rapida sobre um tema.

### standard — Pesquisa padrao
Executa Stage 1 + 3. Identifica automaticamente sub-questoes, pesquisa em paralelo, cobertura abrangente. Sem interacao manual.

### deep — Pesquisa profunda
Executa Stage 1 + 3 + 5. Com base na pesquisa padrao, analisa todas as sub-questoes a partir de 3 perspectivas em profundidade. Sem interacao manual.

### full (padrao) — Pipeline completo
Executa todos os 5 estagios. Stage 2 e Stage 4 sao checkpoints manuais para garantir que a direcao esteja correta.

## Templates de relatorio

### Templates integrados

- **technology** — Pesquisa tecnologica: arquitetura, comparacao, ecossistema, tendencias
- **market** — Pesquisa de mercado: tamanho, concorrencia, usuarios, previsoes
- **competitive** — Analise competitiva: matriz de funcionalidades, SWOT, precificacao

### Templates personalizados

1. Copie `templates/custom-example.md` como `templates/your-name.md`
2. Modifique a estrutura dos capitulos
3. Mantenha os marcadores `{topic}` e `{date}`
4. O ultimo capitulo deve ser "Fontes de referencia"
5. Ative com `--template your-name`

### Modo sem template

Quando `--template` nao e especificado, o agente gera a estrutura do relatorio de forma adaptativa com base no conteudo pesquisado.

## Analise multi-perspectiva

### Perspectivas padrao

| Perspectiva | Papel | Modelo |
|-------------|-------|--------|
| Generalist | Cobertura ampla, consenso geral | Sonnet |
| Critic | Questionamento, busca de evidencias contrarias | Opus |
| Specialist | Profundidade tecnica, fontes primarias | Sonnet |

### Conjuntos de perspectivas alternativos

| Cenario | Perspectivas |
|---------|-------------|
| Previsao de tendencias | `--perspectives optimist,pessimist,pragmatist` |
| Pesquisa de produto | `--perspectives user,developer,business` |
| Pesquisa de politicas | `--perspectives domestic,international,regulatory` |

### Perspectivas personalizadas

Crie `agents/insight-{name}.md`, usando como referencia a estrutura dos arquivos de agente existentes.

## Garantia de qualidade

Cada relatorio e verificado automaticamente:
- Pelo menos 2 fontes independentes por capitulo
- Sem referencias orfas
- Uma unica fonte nao ultrapassa 40% do total
- Todas as afirmacoes comparativas sustentadas por dados

## Diferenca em relacao ao council-fuse

| | insight-fuse | council-fuse |
|---|---|---|
| **Finalidade** | Pesquisa ativa + geracao de relatorios | Deliberacao multi-perspectiva sobre informacoes conhecidas |
| **Fonte de informacao** | Coleta via WebSearch/WebFetch | Perguntas fornecidas pelo usuario |
| **Saida** | Relatorio de pesquisa completo | Resposta sintetizada |
| **Estagios** | 5 estagios progressivos | 3 estagios (convocacao → avaliacao → sintese) |

Ambos podem ser combinados: primeiro use insight-fuse para pesquisar e coletar informacoes, depois use council-fuse para deliberar em profundidade sobre decisoes-chave.
