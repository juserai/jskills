# Guia do Usuário do Skill Lint

> Comece em 3 minutos — valide a qualidade do seu skill do Claude Code

---

## Instalação

### Claude Code (recomendado)

```bash
claude plugin add juserai/forge
```

### Instalação universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **Zero dependências** — Skill Lint não requer serviços externos ou APIs. Instale e use.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/skill-lint` | Mostrar informações de uso | Ver verificações disponíveis |
| `/skill-lint .` | Verificar o projeto atual | Autoaverificação durante o desenvolvimento |
| `/skill-lint /path/to/plugin` | Verificar um caminho específico | Revisar outro plugin |

---

## Casos de Uso

### Autoaverificação após criar um novo skill

Após criar `skills/<name>/SKILL.md`, `commands/<name>.md` e arquivos relacionados, execute `/skill-lint .` para confirmar que a estrutura está completa, o frontmatter está correto e a entrada do marketplace foi adicionada.

### Revisar o plugin de outra pessoa

Ao revisar um PR ou auditar outro plugin, use `/skill-lint /path/to/plugin` para uma verificação rápida da completude e consistência dos arquivos.

### Integração com CI

`scripts/skill-lint.sh` pode ser executado diretamente em um pipeline de CI, gerando JSON para análise automatizada:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Itens de Verificação

### Verificações Estruturais (executadas por script Bash)

| Regra | O que verifica | Severidade |
|-------|---------------|------------|
| S01 | `plugin.json` existe tanto na raiz quanto em `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` existe | error |
| S03 | Cada `skills/<name>/` contém um `SKILL.md` | error |
| S04 | O frontmatter do SKILL.md inclui `name` e `description` | error |
| S05 | Cada skill tem um `commands/<name>.md` correspondente | warning |
| S06 | Cada skill está listado no array `plugins` do marketplace.json | warning |
| S07 | Os arquivos de referência citados no SKILL.md realmente existem | error |
| S08 | `evals/<name>/scenarios.md` existe | warning |

### Verificações Semânticas (executadas por IA)

| Regra | O que verifica | Severidade |
|-------|---------------|------------|
| M01 | A descrição indica claramente o propósito e as condições de ativação | warning |
| M02 | O nome corresponde ao nome do diretório; a descrição é consistente entre os arquivos | warning |
| M03 | A lógica de roteamento de comandos referencia corretamente o nome do skill | warning |
| M04 | O conteúdo das referências é logicamente consistente com SKILL.md | warning |
| M05 | Os cenários de avaliação cobrem os caminhos de funcionalidade principal (pelo menos 5) | warning |

---

## Exemplos de Saída Esperada

### Todas as verificações aprovadas

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### Problemas encontrados

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Fluxo de Trabalho

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## Perguntas Frequentes

### Posso executar apenas as verificações estruturais, sem as semânticas?

Sim — execute o script bash diretamente:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Isso gera JSON puro sem análise semântica de IA.

### Funciona em projetos que não são forge?

Sim. Qualquer diretório que siga a estrutura padrão de plugin do Claude Code (`skills/`, `commands/`, `.claude-plugin/`) pode ser validado.

### Qual é a diferença entre erros e avisos?

- **error**: Problemas estruturais que impedirão o skill de carregar ou publicar corretamente
- **warning**: Problemas de qualidade que não afetarão a funcionalidade, mas impactam a manutenibilidade e a descobribilidade

### Outras ferramentas do forge

Skill Lint faz parte da coleção forge e funciona bem em conjunto com estes skills:

- [Block Break](block-break-guide.md) — Motor de restrição comportamental de alta capacidade que força a IA a esgotar cada abordagem
- [Ralph Boost](ralph-boost-guide.md) — Motor de loop de desenvolvimento autônomo com garantias de convergência Block Break integradas

Após desenvolver um novo skill, execute `/skill-lint .` para verificar a completude estrutural e confirmar que o frontmatter, marketplace.json e os links de referência estão todos corretos.

---

## Licença

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
