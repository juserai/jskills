# Council Fuse 사용자 가이드

> 5분 만에 시작하기 — 더 나은 답변을 위한 다관점 심의

---

## 설치

### Claude Code (권장)

```bash
claude plugin add juserai/forge
```

### 범용 한 줄 설치

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/council-fuse/SKILL.md
```

> **의존성 제로** — Council Fuse는 외부 서비스나 API가 필요하지 않습니다. 설치하고 바로 시작하세요.

---

## 명령어

| 명령어 | 기능 | 사용 시점 |
|--------|------|----------|
| `/council-fuse <질문>` | 전체 평의회 심의 실행 | 중요한 결정, 복잡한 질문 |

---

## 작동 방식

Council Fuse는 Karpathy의 LLM Council 패턴을 단일 명령으로 압축합니다:

### 1단계: 소집

세 에이전트가 각각 다른 관점으로 **병렬로** 생성됩니다:

| 에이전트 | 역할 | 모델 | 강점 |
|---------|------|------|------|
| 제너럴리스트 | 균형적, 실용적 | Sonnet | 주류 모범 사례 |
| 비평가 | 대립적, 결함 발견 | Opus | 엣지 케이스, 위험, 사각지대 |
| 전문가 | 깊은 기술적 세부사항 | Sonnet | 구현 정밀도 |

각 에이전트는 **독립적으로** 응답합니다 — 서로의 응답을 볼 수 없습니다.

### 2단계: 채점

의장 (메인 에이전트)이 모든 응답을 응답 A/B/C로 익명화한 후 4가지 차원(0-10)으로 채점합니다:

- **정확성** — 사실적 정확도, 논리적 타당성
- **완전성** — 모든 측면의 포괄 범위
- **실용성** — 실행 가능성, 현실 세계 적용성
- **명확성** — 구조, 가독성

### 3단계: 종합

가장 높은 점수를 받은 응답이 골격이 됩니다. 다른 응답의 고유한 통찰이 통합됩니다. 비평가의 유효한 이의는 주의사항으로 보존됩니다.

---

## 사용 사례

### 아키텍처 결정

```
/council-fuse Should we use microservices or a monolith for our 10-person team?
```

제너럴리스트가 균형 잡힌 트레이드오프를 제공하고, 비평가가 마이크로서비스 과대광고에 도전하며, 전문가가 마이그레이션 패턴을 상세히 설명합니다. 종합 결과로 조건부 권장사항이 나옵니다.

### 기술 선택

```
/council-fuse Redis vs PostgreSQL for our job queue
```

세 가지 다른 각도를 통해 운영 관련 우려(비평가), 구현 세부사항(전문가), 실용적 기본값(제너럴리스트)을 놓치지 않습니다.

### 코드 리뷰

```
/council-fuse Is this error handling pattern correct? <paste code>
```

주류 검증, 대립적 엣지 케이스 분석, 심층 기술 검증을 한 번에 받을 수 있습니다.

---

## 출력 구조

모든 평의회 심의는 다음을 생성합니다:

1. **점수 매트릭스** — 세 가지 관점 모두의 투명한 채점
2. **합의 분석** — 동의하는 부분과 불일치하는 부분
3. **종합 답변** — 융합된 최상의 답변
4. **소수 의견** — 주목할 만한 유효한 반대 견해

---

## 커스터마이징

### 관점 변경

`agents/*.md`를 편집하여 커스텀 평의회 멤버를 정의합니다. 대안 삼인조:

- 낙관론자 / 비관론자 / 현실론자
- 아키텍트 / 구현자 / 테스터
- 사용자 옹호자 / 개발자 / 보안 전문가

### 모델 변경

각 에이전트 파일의 `model:` 필드를 편집합니다:

- `model: haiku` — 비용 효율적인 평의회
- `model: opus` — 중요한 결정을 위한 올 헤비급

---

## 플랫폼

| 플랫폼 | 평의회 멤버 작동 방식 |
|--------|---------------------|
| Claude Code | 3개의 독립적인 Agent 스폰을 병렬 실행 |
| OpenClaw | 단일 에이전트, 3회 순차적 독립 추론 라운드 |

---

## 사용 시나리오 / 사용 금지 시나리오

### ✅ 사용해야 할 때

- Architectural decisions needing multiple perspectives
- You suspect confirmation bias in your current answer
- You want dissenting views preserved, not erased

### ❌ 사용하지 말아야 할 때

- Pure factual queries (use `claim-ground` instead)
- Creative writing (synthesis flattens style)
- Speed-critical decisions (3 agents run sequentially — not fast)

> 훈련 지식 기반 토론 엔진 — 단일 관점의 맹점을 드러내지만, 결론은 훈련 지식에 제약된다.

전체 경계 분석: [references/scope-boundaries.md](../../../skills/council-fuse/references/scope-boundaries.md)

---

## 자주 묻는 질문

**Q: 토큰이 3배 소모되나요?**
A: 네, 대략 그렇습니다. 세 개의 독립적인 응답과 종합 처리가 있습니다. 투자할 가치가 있는 결정에 사용하세요.

**Q: 평의회 멤버를 더 추가할 수 있나요?**
A: 프레임워크가 지원합니다 — `agents/*.md` 파일을 추가하고 SKILL.md 워크플로를 업데이트하세요. 다만, 비용 대비 다양성에서 3이 최적입니다.

**Q: 에이전트가 실패하면 어떻게 되나요?**
A: 의장이 해당 멤버에 0점을 부여하고 나머지 응답으로 종합합니다. 우아한 성능 저하이며, 충돌하지 않습니다.
