# Insight Fuse 사용자 가이드

> 체계적 다중 소스 조사 융합 엔진 — 주제에서 전문 조사 보고서까지

## 빠른 시작

```bash
# 전체 조사 (5단계, 수동 체크포인트 포함)
/insight-fuse AI Agent 보안 위험

# 빠른 스캔 (Stage 1만)
/insight-fuse --depth quick 양자 컴퓨팅

# 특정 템플릿 사용
/insight-fuse --template technology WebAssembly

# 사용자 정의 관점으로 심층 조사
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 자율주행 상용화
```

## 매개변수

| 매개변수 | 설명 | 예시 |
|---------|------|------|
| `topic` | 조사 주제 (필수) | `AI Agent 보안 위험` |
| `--depth` | 조사 깊이 | `quick` / `standard` / `deep` / `full` |
| `--template` | 보고서 템플릿 | `technology` / `market` / `competitive` |
| `--perspectives` | 관점 목록 | `optimist,pessimist,pragmatist` |

## 깊이 모드

### quick — 빠른 스캔
Stage 1을 실행합니다. 3개 이상의 검색 쿼리, 5개 이상의 소스, 간략한 보고서를 출력합니다. 주제를 빠르게 파악하기에 적합합니다.

### standard — 표준 조사
Stage 1 + 3을 실행합니다. 하위 질문을 자동 식별하고, 병렬 조사, 포괄적 커버리지를 제공합니다. 수동 상호작용이 없습니다.

### deep — 심층 조사
Stage 1 + 3 + 5를 실행합니다. 표준 조사를 기반으로 모든 하위 질문을 3가지 관점에서 심층 분석합니다. 수동 상호작용이 없습니다.

### full (기본값) — 전체 파이프라인
전체 5단계를 실행합니다. Stage 2와 Stage 4는 방향이 올바른지 확인하는 수동 체크포인트입니다.

## 보고서 템플릿

### 내장 템플릿

- **technology** — 기술 조사: 아키텍처, 비교, 생태계, 트렌드
- **market** — 시장 조사: 규모, 경쟁, 사용자, 전망
- **competitive** — 경쟁 분석: 기능 매트릭스, SWOT, 가격 책정

### 사용자 정의 템플릿

1. `templates/custom-example.md`를 `templates/your-name.md`로 복사
2. 장 구조 수정
3. `{topic}` 및 `{date}` 플레이스홀더 유지
4. 마지막 장은 반드시 "참고 출처"로 설정
5. `--template your-name`으로 활성화

### 템플릿 없는 모드

`--template`을 지정하지 않으면 에이전트가 조사 내용에 따라 보고서 구조를 자동으로 생성합니다.

## 다중 관점 분석

### 기본 관점

| 관점 | 역할 | 모델 |
|------|------|------|
| Generalist | 폭넓은 커버리지, 주류 합의 | Sonnet |
| Critic | 검증 질의, 반대 증거 탐색 | Opus |
| Specialist | 기술적 심층 분석, 1차 출처 | Sonnet |

### 대체 관점 세트

| 시나리오 | 관점 |
|---------|------|
| 트렌드 예측 | `--perspectives optimist,pessimist,pragmatist` |
| 제품 조사 | `--perspectives user,developer,business` |
| 정책 조사 | `--perspectives domestic,international,regulatory` |

### 사용자 정의 관점

`agents/insight-{name}.md`를 생성하고 기존 에이전트 파일 구조를 참고하세요.

## 품질 보증

각 보고서는 자동으로 검사됩니다:
- 각 장에 최소 2개의 독립적인 출처
- 고아 참조 없음
- 단일 출처 비율이 40%를 초과하지 않음
- 모든 비교 주장이 데이터로 뒷받침됨

## council-fuse와의 차이점

| | insight-fuse | council-fuse |
|---|---|---|
| **용도** | 능동적 조사 + 보고서 생성 | 알려진 정보에 대한 다중 관점 심의 |
| **정보 출처** | WebSearch/WebFetch 수집 | 사용자가 제공한 질문 |
| **출력** | 완전한 조사 보고서 | 종합 답변 |
| **단계** | 5단계 점진식 | 3단계 (소집 → 평가 → 종합) |

둘을 조합하여 사용할 수 있습니다: 먼저 insight-fuse로 조사하여 정보를 수집한 다음, council-fuse로 주요 의사결정에 대해 심층 토론을 진행합니다.
