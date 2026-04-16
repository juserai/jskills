# Ralph Boost 사용자 가이드

> 5분 안에 시작하기 — AI 자율 개발 루프가 멈추는 것을 방지하세요

---

## 설치

### Claude Code (권장)

```bash
claude plugin add juserai/forge
```

### 범용 원라인 설치

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **의존성 제로** — Ralph Boost는 ralph-claude-code, block-break 또는 외부 서비스에 의존하지 않습니다. 기본 경로(Agent 루프)는 외부 의존성이 없으며, 폴백 경로에는 `jq` 또는 `python`과 `claude` CLI가 필요합니다.

---

## 명령어

| 명령어 | 기능 | 사용 시점 |
|--------|------|----------|
| `/ralph-boost setup` | 프로젝트에서 자율 루프 초기화 | 최초 설정 |
| `/ralph-boost run` | 현재 세션에서 자율 루프 시작 | 초기화 후 |
| `/ralph-boost status` | 현재 루프 상태 확인 | 진행 상황 모니터링 |
| `/ralph-boost clean` | 루프 파일 제거 | 정리 |

---

## 빠른 시작

### 1. 프로젝트 초기화

```text
/ralph-boost setup
```

Claude가 안내합니다:
- 프로젝트 이름 감지
- 작업 목록 생성 (fix_plan.md)
- `.ralph-boost/` 디렉토리 및 모든 설정 파일 생성

### 2. 루프 시작

```text
/ralph-boost run
```

Claude는 현재 세션 내에서 직접 자율 루프를 구동합니다(Agent 루프 모드). 각 반복은 작업을 실행할 서브 에이전트를 생성하고, 메인 세션은 상태를 관리하는 루프 컨트롤러로 작동합니다.

**폴백** (헤드리스 / 무인 환경):

```bash
# 포그라운드
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# 백그라운드
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. 상태 모니터링

```text
/ralph-boost status
```

출력 예시:

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

## 작동 방식

### 자율 루프

Ralph Boost는 두 가지 실행 경로를 제공합니다:

**기본 경로 (Agent 루프)**: Claude가 현재 세션 내에서 루프 컨트롤러로 작동하며, 각 반복마다 작업을 실행할 서브 에이전트를 생성합니다. 메인 세션은 상태, circuit breaker, 압력 에스컬레이션을 관리합니다. 외부 의존성 제로.

**폴백 (bash 스크립트)**: `boost-loop.sh`가 백그라운드에서 루프로 `claude -p` 호출을 실행합니다. JSON 엔진으로 jq와 python을 모두 지원하며, 런타임에 자동 감지됩니다. 반복 간 기본 대기 시간은 1시간(설정 가능)입니다.

두 경로 모두 동일한 상태 관리(state.json), 압력 에스컬레이션 로직, BOOST_STATUS 프로토콜을 공유합니다.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### 강화된 Circuit Breaker (ralph-claude-code 대비)

ralph-claude-code의 circuit breaker: 진행 없는 연속 3회 루프 후 포기합니다.

ralph-boost의 circuit breaker: 막혔을 때 **점진적으로 압력을 에스컬레이션**하며, 중지 전 6-7회 루프의 자가 복구를 수행합니다.

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

## 예상 출력 예시

### L0 — 정상 실행

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

### L1 — 접근법 전환

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude는 이전 접근법을 포기하고 **근본적으로 다른** 방법을 시도하도록 강제됩니다. 파라미터 조정은 인정되지 않습니다.

### L2 — 검색 및 가설 수립

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude는 다음을 수행해야 합니다: 오류를 단어별로 읽기 → 50줄 이상의 컨텍스트 검색 → 3가지 다른 가설 나열.

### L3 — 체크리스트

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude는 7포인트 체크리스트를 완료해야 합니다(오류 신호 읽기, 핵심 문제 검색, 소스 코드 읽기, 가정 검증, 역가설, 최소 재현, 도구/방법 전환). 완료된 각 항목은 state.json에 기록됩니다.

### L4 — 질서 있는 인수인계

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude는 최소 PoC를 구축한 후 인수인계 보고서를 생성합니다:

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

인수인계가 완료되면 루프는 질서 있게 종료됩니다. 이것은 "할 수 없습니다"가 아니라 "여기가 경계입니다."

---

## 설정

`.ralph-boost/config.json`:

| 필드 | 기본값 | 설명 |
|------|--------|------|
| `max_calls_per_hour` | 100 | 시간당 최대 Claude API 호출 수 |
| `claude_timeout_minutes` | 15 | 개별 호출당 타임아웃 |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claude에서 사용 가능한 도구 |
| `claude_model` | "" | 모델 오버라이드 (비어있음 = 기본값) |
| `session_expiry_hours` | 24 | 세션 만료 시간 |
| `no_progress_threshold` | 7 | 종료 전 진행 없음 임계값 |
| `same_error_threshold` | 8 | 종료 전 동일 오류 임계값 |
| `sleep_seconds` | 3600 | 반복 간 대기 시간 (초) |

### 일반적인 설정 조정

**루프 속도 높이기** (테스트용):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**도구 권한 제한**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**특정 모델 사용**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## 프로젝트 디렉토리 구조

```
.ralph-boost/
├── PROMPT.md           # 개발 지침 (block-break 프로토콜 포함)
├── fix_plan.md         # 작업 목록 (Claude가 자동 업데이트)
├── config.json         # 설정
├── state.json          # 통합 상태 (circuit breaker + 압력 + 세션)
├── handoff-report.md   # L4 인수인계 보고서 (정상 종료 시 생성)
├── logs/
│   ├── boost.log       # 루프 로그
│   └── claude_output_*.log  # 반복별 출력
└── .gitignore          # 상태 및 로그 무시
```

모든 파일은 `.ralph-boost/` 내에 유지됩니다 — 프로젝트 루트는 절대 건드리지 않습니다.

---

## ralph-claude-code와의 관계

Ralph Boost는 [ralph-claude-code](https://github.com/frankbria/ralph-claude-code)의 **독립적인 대체품**이며, 개선 플러그인이 아닙니다.

| 측면 | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| 형태 | 독립형 Bash 도구 | Claude Code skill (Agent 루프) |
| 설치 | `npm install` | Claude Code 플러그인 |
| 코드 크기 | 2000줄 이상 | 약 400줄 |
| 외부 의존성 | jq (필수) | 기본 경로: 제로; 폴백: jq 또는 python |
| 디렉토리 | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | 수동적 (3회 루프 후 포기) | 능동적 (L0-L4, 6-7회 루프 자가 복구) |
| 공존 | 가능 | 가능 (파일 충돌 제로) |

두 가지 모두 동일 프로젝트에 동시 설치 가능합니다 — 별도의 디렉토리를 사용하며 서로 간섭하지 않습니다.

---

## Block Break와의 관계

Ralph Boost는 Block Break의 핵심 메커니즘(압력 에스컬레이션, 5단계 방법론, 체크리스트)을 자율 루프 시나리오에 맞게 적용합니다:

| 측면 | block-break | ralph-boost |
|------|-------------|-------------|
| 시나리오 | 대화형 세션 | 자율 루프 |
| 활성화 | 훅이 자동 트리거 | Agent 루프 / 루프 스크립트에 내장 |
| 감지 | PostToolUse 훅 | Agent 루프 진행 감지 / 스크립트 진행 감지 |
| 제어 | 훅 주입 프롬프트 | Agent 프롬프트 주입 / --append-system-prompt |
| 상태 | `~/.forge/` | `.ralph-boost/state.json` |

코드는 완전히 독립적이며, 개념은 공유됩니다.

> **참조**: Block Break의 압력 에스컬레이션(L0-L4), 5단계 방법론, 7포인트 체크리스트는 ralph-boost circuit breaker의 개념적 기반을 형성합니다. 자세한 내용은 [Block Break 사용자 가이드](block-break-guide.md)를 참조하세요.

---

## FAQ

### 기본 경로와 폴백 중 어떻게 선택하나요?

`/ralph-boost run`은 기본적으로 Agent 루프(기본 경로)를 사용하며, 현재 Claude Code 세션 내에서 직접 실행됩니다. 헤드리스 또는 무인 실행이 필요할 때 폴백 bash 스크립트를 사용하세요.

### 루프 스크립트는 어디에 있나요?

forge 플러그인 설치 후, 폴백 스크립트는 `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`에 있습니다. 아무 곳에나 복사하여 실행할 수도 있습니다. 스크립트는 jq 또는 python을 JSON 엔진으로 자동 감지합니다.

### 루프 로그를 보려면?

```bash
tail -f .ralph-boost/logs/boost.log
```

### 압력 수준을 수동으로 재설정하려면?

`.ralph-boost/state.json`을 편집하여 `pressure.level`을 0으로, `circuit_breaker.consecutive_no_progress`를 0으로 설정합니다. 또는 state.json을 삭제하고 다시 초기화합니다.

### 작업 목록을 수정하려면?

`.ralph-boost/fix_plan.md`를 직접 편집하고 `- [ ] 작업` 형식을 사용합니다. Claude는 각 반복 시작 시 이를 읽습니다.

### Circuit breaker가 열린 후 복구하려면?

`state.json`을 편집하여 `circuit_breaker.state`를 `"CLOSED"`로 설정하고, 관련 카운터를 재설정한 후 스크립트를 다시 실행합니다.

### ralph-claude-code가 필요한가요?

아니요. Ralph Boost는 완전히 독립적이며 어떤 Ralph 파일에도 의존하지 않습니다.

### 어떤 플랫폼이 지원되나요?

현재 Claude Code(기본 경로로 Agent 루프)를 지원합니다. 폴백 bash 스크립트에는 bash 4+, jq 또는 python, claude CLI가 필요합니다.

### ralph-boost의 skill 파일을 검증하려면?

[Skill Lint](skill-lint-guide.md)를 사용하세요: `/skill-lint .`

---

## 라이선스

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
