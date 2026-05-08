# Руководство пользователя Ralph Boost

> Начните за 5 минут — не дайте вашему автономному циклу ИИ-разработки застопориться

---

## Установка

### Claude Code (рекомендуется)

```bash
claude plugin add juserai/forge
```

### Универсальная установка одной строкой

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **Нулевые зависимости** — Ralph Boost не зависит от ralph-claude-code, block-break или каких-либо внешних сервисов. Основной путь (цикл Agent) имеет нулевые внешние зависимости; резервный путь требует `jq` или `python` и CLI `claude`.

---

## Команды

| Команда | Функция | Когда использовать |
|---------|---------|-------------------|
| `/ralph-boost setup` | Инициализировать автономный цикл в проекте | Первоначальная настройка |
| `/ralph-boost run` | Запустить автономный цикл в текущей сессии | После инициализации |
| `/ralph-boost status` | Посмотреть текущее состояние цикла | Мониторинг прогресса |
| `/ralph-boost clean` | Удалить файлы цикла | Очистка |

---

## Быстрый старт

### 1. Инициализация проекта

```text
/ralph-boost setup
```

Claude проведёт вас через:
- Определение имени проекта
- Генерацию списка задач (fix_plan.md)
- Создание директории `.ralph-boost/` и всех файлов конфигурации

### 2. Запуск цикла

```text
/ralph-boost run
```

Claude управляет автономным циклом непосредственно в текущей сессии (режим цикла Agent). Каждая итерация порождает подагента для выполнения задачи, а основная сессия выступает контроллером цикла, управляя состоянием.

**Резервный вариант** (безголовые / автоматические среды):

```bash
# Передний план
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Фоновый режим
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Мониторинг состояния

```text
/ralph-boost status
```

Пример вывода:

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

## Как это работает

### Автономный цикл

Ralph Boost предоставляет два пути выполнения:

**Основной путь (цикл Agent)**: Claude выступает контроллером цикла в текущей сессии, порождая подагента на каждой итерации для выполнения задач. Основная сессия управляет состоянием, circuit breaker и эскалацией давления. Нулевые внешние зависимости.

**Резервный (bash-скрипт)**: `boost-loop.sh` выполняет вызовы `claude -p` в цикле в фоновом режиме. Поддерживает как jq, так и python в качестве JSON-движка, автоматически определяемого при запуске. Интервал ожидания по умолчанию между итерациями — 1 час (настраивается).

Оба пути используют одно и то же управление состоянием (state.json), логику эскалации давления и протокол BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Улучшенный Circuit Breaker (по сравнению с ralph-claude-code)

Circuit breaker ralph-claude-code: сдаётся после 3 последовательных циклов без прогресса.

Circuit breaker ralph-boost: **постепенно наращивает давление** при застревании, до 6-7 циклов самовосстановления перед остановкой.

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

## Примеры ожидаемого вывода

### L0 — Нормальное выполнение

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

### L1 — Смена подхода

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude вынужден отказаться от предыдущего подхода и попробовать что-то **принципиально иное**. Подстройка параметров не считается.

### L2 — Поиск и выдвижение гипотез

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude должен: прочитать ошибку слово за словом → найти 50+ строк контекста → перечислить 3 различные гипотезы.

### L3 — Чек-лист

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude должен выполнить чек-лист из 7 пунктов (прочитать сигналы ошибок, найти ключевую проблему, прочитать исходный код, проверить предположения, обратная гипотеза, минимальное воспроизведение, сменить инструменты/методы). Каждый выполненный пункт записывается в state.json.

### L4 — Упорядоченная передача

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude создаёт минимальный PoC, затем генерирует отчёт о передаче:

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

После завершения передачи цикл корректно завершается. Это не «я не могу» — это «вот где проходит граница».

---

## Конфигурация

`.ralph-boost/config.json`:

| Поле | По умолчанию | Описание |
|------|-------------|----------|
| `max_calls_per_hour` | 100 | Максимум вызовов API Claude в час |
| `claude_timeout_minutes` | 15 | Тайм-аут на отдельный вызов |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Инструменты, доступные Claude |
| `claude_model` | "" | Переопределение модели (пусто = по умолчанию) |
| `session_expiry_hours` | 24 | Время истечения сессии |
| `no_progress_threshold` | 7 | Порог отсутствия прогресса перед остановкой |
| `same_error_threshold` | 8 | Порог одинаковых ошибок перед остановкой |
| `sleep_seconds` | 3600 | Время ожидания между итерациями (секунды) |

### Типичные настройки

**Ускорить цикл** (для тестирования):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Ограничить права инструментов**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Использовать конкретную модель**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Структура директории проекта

```
.ralph-boost/
├── PROMPT.md           # Инструкции для разработки (включает протокол block-break)
├── fix_plan.md         # Список задач (автоматически обновляется Claude)
├── config.json         # Конфигурация
├── state.json          # Единое состояние (circuit breaker + давление + сессия)
├── handoff-report.md   # Отчёт о передаче L4 (создаётся при корректном завершении)
├── logs/
│   ├── boost.log       # Лог цикла
│   └── claude_output_*.log  # Вывод каждой итерации
└── .gitignore          # Игнорирует состояние и логи
```

Все файлы остаются внутри `.ralph-boost/` — корень вашего проекта не затрагивается.

---

## Связь с ralph-claude-code

Ralph Boost — это **независимая замена** [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), а не дополнительный плагин.

| Аспект | ralph-claude-code | ralph-boost |
|--------|-------------------|-------------|
| Форма | Автономный Bash-инструмент | Skill Claude Code (цикл Agent) |
| Установка | `npm install` | Плагин Claude Code |
| Размер кода | 2000+ строк | ~400 строк |
| Внешние зависимости | jq (обязательно) | Основной путь: нулевые; Резервный: jq или python |
| Директория | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Пассивный (сдаётся после 3 циклов) | Активный (L0-L4, 6-7 циклов самовосстановления) |
| Сосуществование | Да | Да (нулевые конфликты файлов) |

Оба могут быть установлены в одном проекте одновременно — они используют раздельные директории и не мешают друг другу.

---

## Связь с Block Break

Ralph Boost адаптирует ключевые механизмы Block Break (эскалация давления, 5-шаговая методология, чек-лист) для сценариев автономного цикла:

| Аспект | block-break | ralph-boost |
|--------|-------------|-------------|
| Сценарий | Интерактивные сессии | Автономные циклы |
| Активация | Хуки срабатывают автоматически | Встроено в цикл Agent / скрипт цикла |
| Обнаружение | Хук PostToolUse | Обнаружение прогресса цикла Agent / обнаружение прогресса скрипта |
| Управление | Промпты, внедрённые хуками | Внедрение промптов Agent / --append-system-prompt |
| Состояние | `~/.forge/` | `.ralph-boost/state.json` |

Код полностью независим; концепции общие.

> **Справка**: Эскалация давления (L0-L4), 5-шаговая методология и 7-пунктный чек-лист Block Break формируют концептуальную основу circuit breaker ralph-boost. Подробности см. в [Руководстве пользователя Block Break](block-break-guide.md).

---

## FAQ

### Как выбрать между основным путём и резервным?

`/ralph-boost run` использует цикл Agent (основной путь) по умолчанию, работая непосредственно в текущей сессии Claude Code. Используйте резервный bash-скрипт, когда нужно безголовое или автоматическое выполнение.

### Где находится скрипт цикла?

После установки плагина forge резервный скрипт находится по адресу `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`. Вы можете скопировать его куда угодно и запускать оттуда. Скрипт автоматически определяет jq или python как JSON-движок.

### Как посмотреть логи цикла?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Как вручную сбросить уровень давления?

Отредактируйте `.ralph-boost/state.json`: установите `pressure.level` в 0 и `circuit_breaker.consecutive_no_progress` в 0. Или просто удалите state.json и переинициализируйте.

### Как изменить список задач?

Отредактируйте `.ralph-boost/fix_plan.md` напрямую, используя формат `- [ ] задача`. Claude читает его в начале каждой итерации.

### Как восстановить после срабатывания circuit breaker?

Отредактируйте `state.json`, установите `circuit_breaker.state` в `"CLOSED"`, сбросьте соответствующие счётчики и перезапустите скрипт.

### Нужен ли мне ralph-claude-code?

Нет. Ralph Boost полностью независим и не зависит от каких-либо файлов Ralph.

### Какие платформы поддерживаются?

В настоящее время поддерживается Claude Code (цикл Agent как основной путь). Резервный bash-скрипт требует bash 4+, jq или python и CLI claude.

### Как проверить файлы skill ralph-boost?

Используйте [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Когда использовать / Когда НЕ использовать

### ✅ Используйте когда

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ Не используйте когда

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> Движок автономного цикла с гарантией сходимости — нужны чёткие цели и стабильная среда.

Полный анализ границ: [references/scope-boundaries.md](../../../skills/ralph-boost/references/scope-boundaries.md)

---

## Лицензия

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
