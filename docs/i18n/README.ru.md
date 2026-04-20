# Forge

> Работай усерднее, потом сделай перерыв. 8 skill'ов для правильного ритма разработки с Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-8-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

### Быстрая демонстрация

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

## Установка

```bash
# Claude Code (одна команда)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

> Каждый skill поддерживает `/<skill> help` (а также `--help`) для показа карточки использования. Skills с обязательными аргументами также показывают help при вызове без аргументов.

### Hammer

| Skill | Что делает | Попробуй |
|-------|-----------|----------|
| **block-break** | Заставляет исчерпать все подходы перед тем, как сдаться | `/block-break` |
| **ralph-boost** | Автономные циклы разработки с гарантией сходимости | `/ralph-boost setup` |
| **claim-ground** | Привязывает каждое утверждение о "текущем моменте" к runtime-доказательствам | авто-триггер |

### Crucible

| Skill | Что делает | Попробуй |
|-------|-----------|----------|
| **council-fuse** | Мультиперспективное обсуждение для лучших ответов | `/council-fuse <question>` |
| **insight-fuse** | 7-этапный движок исследования с контрактом skeleton.yaml и 6-мерной шкалой качества | `/insight-fuse <topic>` |
| **tome-forge** | Персональная база знаний с wiki, компилируемой LLM | `/tome-forge init` |

### Anvil

| Skill | Что делает | Попробуй |
|-------|-----------|----------|
| **skill-lint** | Валидация любого Claude Code skill-плагина | `/skill-lint .` |

### Quench

| Skill | Что делает | Попробуй |
|-------|-----------|----------|
| **news-fetch** | Быстрые новости между сессиями кодинга | `/news-fetch AI today` |

---

## Block Break — Движок поведенческих ограничений

Твой AI сдался? `/block-break` заставит его сначала исчерпать все подходы.

Когда Claude застревает, Block Break активирует систему эскалации давления, которая не даёт сдаться преждевременно. Агент проходит через всё более жёсткие стадии решения проблемы, прежде чем ему будет позволено ответить «я не могу это сделать».

| Механизм | Описание |
|----------|----------|
| **3 Red Lines** | Замкнутый цикл верификации / Опора на факты / Исчерпать все варианты |
| **Эскалация давления** | L0 Trust → L1 Disappointment → L2 Interrogation → L3 Performance Review → L4 Graduation |
| **5-шаговый метод** | Smell → Pull hair → Mirror → New approach → Retrospect |
| **Чек-лист из 7 пунктов** | Обязательный диагностический чек-лист на уровне L3+ |
| **Анти-рационализация** | Распознаёт и блокирует 14 типичных шаблонов отговорок |
| **Hooks** | Автодетект фрустрации + подсчёт ошибок + сохранение состояния |

```text
/block-break              # Активировать режим Block Break
/block-break L2           # Начать с определённого уровня давления
/block-break fix the bug  # Активировать и сразу начать задачу
```

Также срабатывает на естественный язык: `try harder`, `stop spinning`, `figure it out`, `you keep failing` и т.д. (автодетект через hooks).

> Вдохновлено [PUA](https://github.com/tanweai/pua), переработано в skill с нулевыми зависимостями.

## Ralph Boost — Движок автономного цикла разработки

Автономные циклы разработки, которые действительно сходятся. Настройка за 30 секунд.

Воспроизводит возможности автономного цикла ralph-claude-code в формате skill, со встроенной эскалацией давления Block Break L0-L4 для гарантии сходимости. Решает проблему «крутится, но не продвигается» в автономных циклах.

| Возможность | Описание |
|------------|----------|
| **Dual-Path Loop** | Agent loop (основной, без внешних зависимостей) + bash-скрипт как fallback (движки jq/python) |
| **Улучшенный Circuit Breaker** | Встроенная эскалация давления L0-L4: от «сдаться после 3 раундов» к «6-7 раундов прогрессивного самоспасения» |
| **Отслеживание состояния** | Единый state.json для circuit breaker + давление + стратегия + сессия |
| **Graceful Handoff** | На L4 генерируется структурированный отчёт о передаче вместо сырого краша |
| **Независимость** | Использует директорию `.ralph-boost/`, не зависит от ralph-claude-code |

```text
/ralph-boost setup        # Инициализировать проект
/ralph-boost run          # Запустить автономный цикл
/ralph-boost status       # Проверить текущее состояние
/ralph-boost clean        # Очистить
```

> Вдохновлено [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), переосмыслено как skill с нулевыми зависимостями и гарантией сходимости.

## Claim Ground — Движок эпистемического ограничения

Прекрати галлюцинировать устаревшие факты. `claim-ground` привязывает каждое утверждение о "текущем моменте" к runtime-доказательствам.

Авто-триггер (без slash-команды). Когда Claude собирается ответить на фактические вопросы о текущем состоянии — работающая модель, установленные инструменты, env-переменные, значения конфигурации — или когда пользователь оспаривает предыдущее утверждение, Claim Ground заставляет цитировать системный prompt / вывод инструмента / содержимое файла **перед** выводом. При возражении Claude перепроверяет, а не перефразирует.

| Механизм | Описание |
|----------|----------|
| **3 красные линии** | Никаких утверждений без источника / пример не как исчерпание / не перефразировать при оспаривании |
| **Runtime > Training** | Системный prompt, env и вывод инструментов всегда превосходят память обучения |
| **Цитата-потом-вывод** | Сырой фрагмент доказательства цитируется inline перед любым выводом |
| **Playbook верификации** | Тип вопроса → источник доказательства (модель / CLI / пакеты / env / файлы / git / дата) |

Примеры срабатывания (авто-детекция по description):

- "Какая модель работает?" / "What model is running?"
- "Какая версия X установлена?"
- "Серьёзно? / Уверены? / Я думал уже обновлено"

Работает ортогонально с block-break: когда оба срабатывают, block-break предотвращает "я сдаюсь", claim-ground предотвращает "я просто перефразировал свой неправильный ответ".

## Council Fuse — Мультиперспективный движок обсуждений

Лучшие ответы через структурированные дебаты. `/council-fuse` генерирует 3 независимые перспективы, анонимно оценивает их и синтезирует лучший ответ.

Вдохновлён [LLM Council Карпати](https://github.com/karpathy/llm-council) — сконденсирован в одну команду.

| Механизм | Описание |
|----------|----------|
| **3 перспективы** | Генералист (сбалансированный) / Критик (оппонирующий) / Специалист (глубокий технический) |
| **Анонимная оценка** | 4-мерная оценка: Корректность, Полнота, Практичность, Ясность |
| **Синтез** | Ответ с высшим баллом как каркас, обогащённый уникальными инсайтами |
| **Мнение меньшинства** | Обоснованные возражения сохраняются, не подавляются |

```text
/council-fuse Стоит ли использовать микросервисы?
/council-fuse Проверь этот паттерн обработки ошибок
/council-fuse Redis vs PostgreSQL для очередей задач
```

## Insight Fuse — Систематический движок мультиисточникового исследования (v3)

От темы до профессионального исследовательского отчёта. `/insight-fuse` запускает 7-этапный конвейер с `skeleton.yaml` как контракт данных: brainstorm → scan → align → research → review → deep dive → QA.

Встроенный мультиперспективный анализ, 6 пресетов типов исследования (overview / technology / market / academic / product / competitive), 5 форматов вывода (report / checklist / ADR / decision-tree / PoC) и 6-мерная шкала качества с 14 блокирующими проверками. Родственный навык council-fuse — пока council-fuse обсуждает известную информацию, insight-fuse активно собирает и синтезирует новую.

| Механизм | Описание |
|----------|----------|
| **7-этапный конвейер** | Brainstorm (скелет) → Scan → Align → Research → Review → Deep Dive → QA |
| **Типы исследования** | overview / technology / market / academic / product / competitive — пресет-пакет (шаблон + перспективы + специфические проверки) |
| **Настраиваемая глубина** | quick / standard / deep / full — quick пропускает Stage 2-5; full проходит все 7 этапов с интерактивными шлюзами |
| **Skeleton.yaml** | Контракт данных из 7 полей (dimensions / taxonomies / out_of_scope / existing_consensus / known_dissensus / hypotheses / business_neutral), потребляемый каждым stage |
| **Шкала качества** | 6-мерная оценка (фальсифицируемость / плотность доказательств / воспроизводимость / разнообразие источников / действенность / прозрачность) + 14 блокирующих проверок + оценка A/B/C/D |
| **Мульти-вывод** | report / checklist / ADR / decision-tree / PoC — `--outputs` выбирает комбинации |

```text
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling" --type technology --outputs report,adr,poc
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI Native landscape" --type overview --depth full --audience "new entrants"
```

## Tome Forge — Движок персональной базы знаний

Создайте персональную базу знаний, которую LLM компилирует и поддерживает. На основе [паттерна LLM Wiki Карпати](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — сырой Markdown компилируется в структурированную wiki, без RAG или векторных БД.

| Возможность | Описание |
|-------------|----------|
| **Трёхуровневая архитектура** | Сырые источники (неизменяемые) / Wiki (LLM-компилированная) / Schema (CLAUDE.md) |
| **6 операций** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | Священный раздел для человеческих инсайтов — LLM никогда не перезаписывает |
| **Zero Infra** | Чистый Markdown + Git. Без баз данных, эмбеддингов или серверов |

```text
/tome-forge init              # Инициализировать БЗ в текущей директории
/tome-forge capture "idea"    # Быстрый захват заметки
/tome-forge ingest raw/paper  # Скомпилировать сырой материал в wiki
/tome-forge query "question"  # Поиск и синтез
/tome-forge lint              # Проверка здоровья структуры wiki
/tome-forge compile           # Пакетная компиляция всех новых материалов
```

> Вдохновлён [LLM Wiki Карпати](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), создан как навык с нулевыми зависимостями.

## Skill Lint — Валидатор skill-плагинов

Проверь свои Claude Code плагины одной командой.

Проверяет структурную целостность и семантическое качество skill-файлов в любом проекте Claude Code плагина. Bash-скрипты выполняют структурные проверки, AI — семантические. Взаимодополняющее покрытие.

| Тип проверки | Описание |
|-------------|----------|
| **Структурная** | Обязательные поля frontmatter / существование файлов / ссылки references / записи в marketplace |
| **Семантическая** | Качество описаний / консистентность имён / маршрутизация команд / покрытие eval |

```text
/skill-lint              # Показать справку
/skill-lint .            # Проверить текущий проект
/skill-lint /path/to/plugin  # Проверить конкретный путь
```

## News Fetch — Ментальная перезагрузка между спринтами

Устал от дебага? `/news-fetch` — твои 2 минуты на перезагрузку.

Остальные skill'ы заставляют тебя работать усерднее. Этот напоминает перевести дух. Получи свежие новости по любой теме прямо в терминале — без переключения контекста, без кроличьих нор в браузере. Быстрый просмотр — и обратно к работе, с новыми силами.

| Возможность | Описание |
|------------|----------|
| **3-уровневый Fallback** | L1 WebSearch → L2 WebFetch (региональные источники) → L3 curl |
| **Дедупликация и слияние** | Одно событие из нескольких источников автоматически объединяется, остаётся с наивысшим рейтингом |
| **Оценка релевантности** | AI оценивает и сортирует по соответствию теме |
| **Автосаммари** | Отсутствующие аннотации генерируются автоматически из текста статьи |

```text
/news-fetch AI                    # Новости AI за неделю
/news-fetch AI today              # Новости AI за сегодня
/news-fetch robotics month        # Новости робототехники за месяц
/news-fetch climate 2026-03-01~2026-03-31  # Произвольный диапазон дат
```

## Качество

- 10+ сценариев оценки для каждого skill'а с автоматизированными тестами
- Самопроверка собственным skill-lint
- Ноль внешних зависимостей — ноль рисков
- Лицензия MIT, полностью открытый код

## Структура проекта

```text
forge/
├── skills/                        # Платформа Claude Code
│   └── <skill>/
│       ├── SKILL.md               # Определение skill'а
│       ├── references/            # Детальный контент (загружается по запросу)
│       ├── scripts/               # Вспомогательные скрипты
│       ├── agents/                # Определения sub-agent'ов
│       └── hooks/                 # Hooks Claude Code по skill'ам (только для hook-owner skill'ов)
├── platforms/                     # Адаптации для других платформ
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # Адаптация для OpenClaw
│           ├── references/        # Контент для платформы
│           └── scripts/           # Скрипты для платформы
├── .claude-plugin/                # Метаданные для Claude Code marketplace
├── evals/                         # Кроссплатформенные сценарии оценки
├── docs/
│   ├── user-guide/                # Руководства пользователя (English)
│   ├── design/                    # Проектная документация
│   └── i18n/                      # Переводы (11 языков)
│       ├── README.*.md            # Переведённые README
│       └── (translated guides moved to docs/user-guide/i18n/)
└── plugin.json                    # Метаданные коллекции
```

## Участие в разработке

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — адаптация для OpenClaw + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — сценарии оценки
4. `.claude-plugin/marketplace.json` — добавить запись в массив `plugins`
5. Hooks при необходимости: создайте `skills/<name>/hooks/hooks.json` + скрипты; `source` в marketplace.json должен указывать на `./skills/<name>`

Подробности в [CLAUDE.md](../../CLAUDE.md).

## Лицензия

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
