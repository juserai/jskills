# Forge

> 더 열심히, 그리고 잠깐 쉬어가기. Claude Code와 함께하는 더 나은 코딩 리듬을 위한 8가지 skill.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-8-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

## 설치

```bash
# Claude Code (명령어 한 줄)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

> 모든 skill은 `/<skill> help`(또는 `--help`)로 사용 카드를 표시합니다. 필수 인자가 있는 skill은 인자 없이 호출해도 help가 표시됩니다.

### Hammer

| Skill | 기능 | 사용해 보기 |
|-------|------|-------------|
| **block-break** | 포기하기 전에 모든 방법을 소진하도록 강제합니다 | `/block-break` |
| **ralph-boost** | 수렴을 보장하는 자율 개발 루프 | `/ralph-boost setup` |
| **claim-ground** | 모든 "지금 이 순간"의 주장을 runtime 증거에 고정 | 자동 트리거 |

### Crucible

| Skill | 기능 | 사용해 보기 |
|-------|------|-------------|
| **council-fuse** | 다관점 심의로 더 나은 답변 도출 | `/council-fuse <question>` |
| **insight-fuse** | 7단계 조사 엔진, skeleton.yaml 데이터 계약 + 6차원 품질 루브릭 | `/insight-fuse <topic>` |
| **tome-forge** | LLM으로 편찬하는 개인 지식 베이스 | `/tome-forge init` |

### Anvil

| Skill | 기능 | 사용해 보기 |
|-------|------|-------------|
| **skill-lint** | Claude Code skill 플러그인 검증 | `/skill-lint .` |

### Quench

| Skill | 기능 | 사용해 보기 |
|-------|------|-------------|
| **news-fetch** | 코딩 사이 간단한 뉴스 브리핑 | `/news-fetch AI today` |

---

## Block Break — 행동 제약 엔진

AI가 또 포기했습니까? `/block-break`으로 모든 방법을 소진하도록 강제하십시오.

Claude가 막혔을 때, Block Break는 압력 상승 시스템을 작동시켜 섣부른 포기를 차단합니다. Agent가 점점 더 엄격한 문제 해결 단계를 거치도록 강제하며, "할 수 없습니다"라는 응답을 허용하지 않습니다.

| 메커니즘 | 설명 |
|----------|------|
| **3가지 레드라인** | 폐쇄형 검증 / 사실 기반 / 모든 옵션 소진 |
| **압력 상승** | L0 신뢰 → L1 실망 → L2 심문 → L3 성과 평가 → L4 졸업 |
| **5단계 방법론** | 냄새 맡기 → 머리 쥐어짜기 → 거울 보기 → 새로운 접근 → 회고 |
| **7항목 체크리스트** | L3 이상에서 필수로 수행하는 진단 체크리스트 |
| **합리화 차단** | 14가지 흔한 변명 패턴 식별 및 차단 |
| **Hooks** | 자동 좌절 감지 + 실패 횟수 추적 + 상태 영속화 |

```text
/block-break              # Block Break 모드 활성화
/block-break L2           # 특정 압력 단계에서 시작
/block-break fix the bug  # 활성화 후 즉시 작업 수행
```

자연어로도 트리거됩니다: `try harder`, `stop spinning`, `figure it out`, `you keep failing` 등 (hooks가 자동 감지).

> [PUA](https://github.com/tanweai/pua)의 핵심 메커니즘을 참고하여, 의존성 없는 skill로 정제했습니다.

## Ralph Boost — 자율 개발 루프 엔진

실제로 수렴하는 자율 개발 루프. 30초면 초기화 완료.

ralph-claude-code의 자율 루프 기능을 skill 형태로 구현했으며, Block Break L0-L4 압력 상승을 내장하여 수렴을 보장합니다. 자율 루프에서 "제자리 맴돌기" 문제를 해결합니다.

| 기능 | 설명 |
|------|------|
| **이중 경로 루프** | Agent 루프 (주 경로, 외부 의존성 없음) + bash 스크립트 Fallback (jq/python 엔진) |
| **강화된 서킷 브레이커** | L0-L4 압력 상승 기본 내장: "3라운드 후 포기"에서 "6-7라운드 점진적 자기 구제"로 |
| **상태 추적** | 서킷 브레이커 + 압력 + 전략 + 세션을 통합한 state.json |
| **안정적 핸드오프** | L4 도달 시 원시 크래시가 아닌 구조화된 인수인계 보고서 생성 |
| **독립적 운영** | `.ralph-boost/` 디렉토리 사용, ralph-claude-code에 대한 의존성 없음 |

```text
/ralph-boost setup        # 프로젝트 초기화
/ralph-boost run          # 자율 루프 시작
/ralph-boost status       # 현재 상태 확인
/ralph-boost clean        # 정리
```

> [ralph-claude-code](https://github.com/frankbria/ralph-claude-code)의 자율 루프 기능을 참고하여, 수렴 보장이 내장된 제로 의존성 skill로 재구현했습니다.

## Claim Ground — 인식 제약 엔진

오래된 훈련 지식의 환각을 멈추세요. `claim-ground` 는 모든 "지금 이 순간" 의 주장을 runtime 증거에 고정합니다.

자동 트리거 (slash 명령어 없음). Claude 가 현재 상태에 관한 사실 질문 — 실행 중인 모델, 설치된 도구, 환경 변수, 설정 값 — 에 답하려 하거나, 사용자가 이전 주장에 이의를 제기할 때, Claim Ground 는 결론을 내기 **전에** 시스템 프롬프트 / 도구 출력 / 파일 내용의 인용을 강제합니다. 반박받으면 Claude 는 재표현이 아닌 재검증을 수행합니다.

| 메커니즘 | 설명 |
|----------|------|
| **3 개의 레드 라인** | 근거 없는 단언 / 예시를 열거로 취급 / 반박에 재표현으로 응답 |
| **Runtime > Training** | 시스템 프롬프트, env, 도구 출력은 항상 훈련 기억보다 우선 |
| **인용 먼저, 결론 나중** | 결론 전 원본 증거 조각 인용 |
| **검증 플레이북** | 질문 유형 → 증거 출처 (모델 / CLI / 패키지 / env / 파일 / git / 날짜) |

트리거 예시 (description 에 의해 자동 감지):

- "현재 실행 중인 모델은?" / "What model is running?"
- "X 의 설치된 버전은?"
- "정말? / 확실? / 이미 업데이트되지 않았나?"

block-break 와 직교적으로 협업: 둘 다 활성화되면 block-break 는 "포기" 를 막고 claim-ground 는 "같은 오답 재표현" 을 막습니다.

## Council Fuse — 다관점 심의 엔진

구조화된 토론으로 더 나은 답변을. `/council-fuse`는 3개의 독립적 관점을 생성하고, 익명 평가 후 최적의 답변을 종합합니다.

[Karpathy의 LLM Council](https://github.com/karpathy/llm-council)에서 영감 — 하나의 명령으로 압축.

| 메커니즘 | 설명 |
|----------|------|
| **3개 관점** | 제너럴리스트(균형) / 크리틱(비판적) / 스페셜리스트(기술 심층) |
| **익명 평가** | 4차원 평가: 정확성, 완전성, 실용성, 명확성 |
| **종합** | 최고 점수 응답을 골격으로, 고유한 통찰 융합 |
| **소수 의견** | 유효한 반론은 보존, 무시하지 않음 |

```text
/council-fuse 마이크로서비스를 써야 할까?
/council-fuse 이 에러 처리 패턴 리뷰
/council-fuse Redis vs PostgreSQL 작업 큐용
```

## Insight Fuse — 체계적 다중 소스 조사 용광로 엔진 (v3)

주제에서 전문 조사 보고서까지. `/insight-fuse`는 `skeleton.yaml`을 데이터 계약으로 하는 7단계 파이프라인을 실행합니다: brainstorm → scan → align → research → review → deep dive → QA.

다관점 분석, 6가지 연구 유형 프리셋(overview / technology / market / academic / product / competitive), 5가지 출력물(report / checklist / ADR / decision-tree / PoC), 그리고 6차원 직교 품질 점수 + 14개 blocking check 내장. council-fuse의 자매 스킬 — council-fuse가 알려진 정보를 논의하는 반면, insight-fuse는 새로운 정보를 능동적으로 수집하고 종합합니다.

| 메커니즘 | 설명 |
|----------|------|
| **7단계 파이프라인** | Brainstorm(골격) → Scan → Align → Research → Review → Deep Dive → QA |
| **연구 유형** | overview / technology / market / academic / product / competitive — 프리셋 번들(템플릿 + 관점 + 고유 check) |
| **구성 가능한 깊이** | quick / standard / deep / full — quick은 Stage 2-5 생략; full은 7단계 전부 + 인터랙티브 gate |
| **Skeleton.yaml** | 7필드 데이터 계약(dimensions / taxonomies / out_of_scope / existing_consensus / known_dissensus / hypotheses / business_neutral)을 각 stage가 소비 |
| **품질 루브릭** | 6차원 점수(반증 가능성 / 증거 밀도 / 재현성 / 소스 다양성 / 실행 가능성 / 투명성) + 14개 blocking check + A/B/C/D 등급 |
| **멀티 출력** | report / checklist / ADR / decision-tree / PoC — `--outputs`로 조합 선택 |

```text
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling" --type technology --outputs report,adr,poc
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI Native landscape" --type overview --depth full --audience "new entrants"
```

## Tome Forge — 개인 지식 베이스 엔진

LLM이 편찬하고 유지하는 개인 지식 베이스를 구축합니다. [Karpathy의 LLM Wiki 패턴](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 기반 — 원시 Markdown을 구조화된 wiki로 컴파일, RAG나 벡터 DB 불필요.

| 특징 | 설명 |
|------|------|
| **3계층 아키텍처** | 원시 소스(불변) / Wiki(LLM 컴파일) / Schema(CLAUDE.md) |
| **6가지 작업** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | 인간 통찰 전용 섹션 — LLM이 덮어쓰지 않음 |
| **제로 인프라** | 순수 Markdown + Git. 데이터베이스, 임베딩, 서버 불필요 |

```text
/tome-forge init              # 현재 디렉토리에 KB 초기화
/tome-forge capture "idea"    # 빠른 노트 캡처
/tome-forge ingest raw/paper  # 원시 자료를 wiki로 컴파일
/tome-forge query "question"  # 검색 및 종합
/tome-forge lint              # wiki 구조 건강 검사
/tome-forge compile           # 새 자료 일괄 컴파일
```

> [Karpathy의 LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)에서 영감, 제로 의존성 스킬로 구축.

## Skill Lint — Skill 플러그인 검증 도구

명령어 한 줄로 Claude Code 플러그인을 검증합니다.

Claude Code plugin 프로젝트 내 skill 파일의 구조적 완전성과 의미적 품질을 검사합니다. Bash 스크립트가 구조 검사를, AI가 의미 검사를 담당하여 상호 보완합니다.

| 검사 유형 | 설명 |
|-----------|------|
| **구조 검사** | frontmatter 필수 필드 / 파일 존재 여부 / references 참조 / marketplace 항목 |
| **의미 검사** | description 품질 / name 일관성 / command 라우팅 / eval 커버리지 |

```text
/skill-lint              # 사용법 표시
/skill-lint .            # 현재 프로젝트 검증
/skill-lint /path/to/plugin  # 특정 경로 검증
```

## News Fetch — 스프린트 사이의 재충전

디버깅에 지치셨습니까? `/news-fetch` — 2분짜리 리프레시 타임.

나머지 skill들은 더 열심히 일하게 만듭니다. 이것은 잠시 숨을 돌리라고 알려줍니다. 터미널에서 바로 원하는 주제의 최신 뉴스를 확인하세요 — 컨텍스트 전환도, 브라우저에 빠져드는 일도 없습니다. 빠르게 훑어보고, 머리를 환기시킨 다음, 다시 코딩으로 돌아가십시오.

| 기능 | 설명 |
|------|------|
| **3단계 Fallback** | L1 WebSearch → L2 WebFetch (지역 소스) → L3 curl |
| **중복 제거 및 병합** | 여러 소스의 동일 이벤트를 자동 병합, 최고 점수 항목 유지 |
| **관련성 점수** | AI가 주제 일치도 기준으로 점수를 매기고 정렬 |
| **자동 요약** | 기사 본문에서 요약을 자동 생성 |

```text
/news-fetch AI                    # 이번 주 AI 뉴스
/news-fetch AI today              # 오늘의 AI 뉴스
/news-fetch robotics month        # 이번 달 로보틱스 뉴스
/news-fetch climate 2026-03-01~2026-03-31  # 기간 지정
```

## 품질 보증

- skill당 10개 이상의 평가 시나리오 및 자동화 트리거 테스트
- 자체 skill-lint로 스스로를 검증
- 외부 의존성 제로 — 리스크 제로
- MIT 오픈소스 라이선스

## 프로젝트 구조

```text
forge/
├── skills/                        # Claude Code 플랫폼
│   └── <skill>/
│       ├── SKILL.md               # Skill 정의
│       ├── references/            # 필요 시 로드되는 상세 내용
│       ├── scripts/               # 보조 스크립트
│       ├── agents/                # Sub-agent 정의
│       └── hooks/                 # skill별 Claude Code hooks (hook-owner skill 전용)
├── platforms/                     # 기타 플랫폼 적응 계층
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw 적응 버전
│           ├── references/        # 해당 플랫폼의 상세 내용
│           └── scripts/           # 해당 플랫폼의 보조 스크립트
├── .claude-plugin/                # Claude Code marketplace 메타데이터
├── evals/                         # 크로스 플랫폼 평가 시나리오
├── docs/                          # 크로스 플랫폼 문서
└── plugin.json                    # 컬렉션 메타데이터
```

## 기여 방법

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw 적응 버전 + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — 평가 시나리오
4. `.claude-plugin/marketplace.json` — `plugins` 배열에 항목 추가
5. hooks가 필요한 경우: `skills/<name>/hooks/hooks.json` + 스크립트 생성. marketplace.json의 `source`는 `./skills/<name>`을 가리켜야 함

자세한 개발 가이드라인은 [CLAUDE.md](../../CLAUDE.md)를 참고하십시오.

## License

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
