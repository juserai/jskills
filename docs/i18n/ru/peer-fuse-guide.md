# Руководство по Peer Fuse v0.1.0

> Универсальный peer-reviewer для исследовательских артефактов — **8-этапный конвейер (Stage 7 архивирование в KB обязательно + наблюдаемо, отказ через `--no-save`) + адаптер ввода 10 форматов (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, 3-уровневая диспетчеризация) + 6 пресетов типов исследования (авто-классификация) + 8-мерная взвешенная шкала + таксономия из 18 флагов + 3-перспективная панель + заморозка § Document Reading (жёсткое ограничение review-isolation)**.

Peer-Fuse принимает любой markdown / PDF / Office-документ и выдаёт markdown-отчёт peer-review с оценкой A+/A−/.../D, многоуровневым списком флагов качества, синтезом мультиперспективной панели и патч-стилевыми diff-предложениями. Сосуществует с [insight-fuse Stage 6.5 reviewer](insight-fuse-guide.md) — Stage 6.5 это IF-внутренний review того же источника; peer-fuse это **межскилловый внешний reviewer**, обрабатывающий форматы и сценарии, недоступные Stage 6.5.

## Быстрый старт

```bash
# Авто-классификация типа, глубина по умолчанию, архивация в KB
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Академическая статья PDF (тип авто-определяется из заголовка arXiv/IEEE/Nature)
/peer-fuse papers/transformer-2017.pdf

# PPTX-презентация с явным типом
/peer-fuse decks/q4-roadmap.pptx --type product

# Быстрая глубина (пропуск Stage 4 panel + Stage 5.5 holistic) + пропуск архивации в KB
/peer-fuse handbook.docx --depth quick --no-save

# Показать справку
/peer-fuse help
# или без аргументов
/peer-fuse
```

## Значения по умолчанию и флаги

| Флаг | По умолчанию | Значения |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | флаг — пропускает Stage 7 архивирование в KB, только консольный вывод |

`--type=auto` позволяет peer-fuse классифицировать документ после чтения через эвристики (поле type во frontmatter → шаблон секций → плотность цитирований → подсказки формата/заголовка → fallback overview). См. [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) для цепочки приоритетов.

## Поддерживаемые форматы

| Уровень | Требования к инструменту | Форматы |
|:-:|---|---|
| 1 | нет (нативно) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` для `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Отсутствие инструмента → fail-soft с конкретной подсказкой по установке (`brew install pandoc`, `apt install libreoffice` и т.д.) и выход до Stage 1. См. [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md).

## Что вы получаете обратно

Два параллельных результата:

1. **Inline-отображение review** в вашем диалоге, со структурой:
   - § Document Reading — описательный нарратив (что говорит документ), 3-5 абзацев, 300-600 слов
   - § Holistic Assessment — оценочный нарратив (методология / сильные стороны / опасения / рекомендация), 4 абзаца, 400-700 слов
   - § Score Matrix — 8-мерные взвешенные оценки → буквенная оценка
   - § Flag List — коды флагов из 18-таксономии с позициями
   - § Multi-Perspective Panel — вердикты methodologist / adversarial / practitioner
   - § Diff Suggestions — патч-стилевые переписывания для каждого недостатка
   - § Reconciliation — целевая self-grade vs review_grade Δ

2. **Архив KB** в `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` (пропуск через `--no-save`). Строка лога архивирования `Archived to KB: <path>` всегда появляется в видимом для пользователя ответе.

## Жёсткое ограничение: § Document Reading изолирован от review

Самое важное архитектурное решение в peer-fuse:

**§ Document Reading не должен загрязняться вердиктами review.** Это добросовестное описательное чтение документа reviewer'ом — frontmatter, структура, утверждения, evidence, scope. Запускается на Stage 3.5, **до** панели Stage 4 и оценивания Stage 5, и граница входа строгая:

- ✅ Принимает: оригинальный документ, результаты фактологического сканирования Stage 1-3
- ❌ Отвергает: вердикты панели, оценки, попадания флагов

Секция **замораживается** после Stage 3.5: SHA-256 хэш снимается до Stage 4, а Stage 7 проверяет хэш перед архивированием. Любое изменение → fail-closed. Lint также запрещает оценочную лексику (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) и литералы буквенных оценок в этой секции.

Это заявленное пользователем жёсткое ограничение, обеспечиваемое на трёх уровнях: архитектурная изоляция + write-once заморозка + lint запрещённых слов.

## Взаимодействие с другими skill'ами forge

| Skill | Отношение |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | Сосуществует — Stage 6.5 это IF-внутренний review того же источника (та же шкала, те же эвристики, только IF markdown). peer-fuse это **межскилловый внешний review** с более широкой 8-мерной шкалой, 18 флагами, 10 форматами, 3-агентной панелью. Оба должны запускаться для важных IF-отчётов. |
| **council-fuse** | Sibling crucible — peer-fuse переиспользует паттерн параллельной диспетчеризации sub-agent'ов из council-fuse (панель Stage 4 зеркалирует council-fuse Stage 1). |
| **tome-forge** | Бэкенд архивирования — peer-fuse Stage 7 вызывает report-archival-protocol из tome-forge; не реимплементирует логику записи в KB. |
| **skill-lint** | Sibling по паттерну (другая категория, anvil) — оба судят артефакты и выдают диагностику, но skill-lint выводит эфемерную консольную диагностику, тогда как peer-fuse выводит постоянный markdown-артефакт peer-review. |

## Когда использовать peer-fuse vs IF Stage 6.5

| Сценарий | Использовать |
|---|:-:|
| Вы только что запустили `/insight-fuse <topic>` и хотите второе мнение по IF-отчёту | IF Stage 6.5 уже отработал inline; если хотите второй слой внешнего review с готовностью к разным форматам, запустите `/peer-fuse <if-output-path>` |
| У вас есть сторонняя PDF-исследовательская статья для оценки | peer-fuse |
| У вас есть бизнес-презентация PPTX, которую вы хотите оценить | peer-fuse |
| У вас есть результат синтеза council-fuse, который вы хотите оценить | peer-fuse |
| Вы хотите сравнить несколько артефактов по той же шкале | peer-fuse (согласованная оценка по артефактам) |

## Конкретный пример

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 detection
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 produces § Document Reading (frozen)
# Stage 4 panel runs 3 sub-agents in parallel
# Stage 5 scoring → 8.6 / A-
# Stage 5.5 holistic assessment
# Stage 6 diff suggestions: 5 blocks
# Stage 7 archive

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

Консоль отображает полный review inline; архив KB — постоянная каноническая версия.

## Верификация

```bash
# Статическая проверка
bash skills/skill-lint/scripts/skill-lint.sh .

# Тест триггера
bash evals/peer-fuse/run-trigger-test.sh

# Lockstep хэшей
bash scripts/recalc-all-hashes.sh
```

## См. также

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — runtime-определение skill
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — архитектурные решения + обоснование 4-категорийной классификации
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (после merge)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — sibling crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — sibling crucible (источник паттерна panel)
