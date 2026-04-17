# Claim Ground 사용자 가이드

> 3 분 만에 인식 규율 확립 — "지금 이 순간"의 모든 주장을 런타임 증거에 고정

---

## 설치

### Claude Code（권장）

```bash
claude plugin add juserai/forge
```

### 범용 원라인

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **제로 의존성** — Claim Ground 는 순수한 행동 제약. 스크립트·훅·외부 서비스 불필요.

---

## 작동 방식

Claim Ground 는 **자동 트리거** skill 입니다. slash 명령어는 없습니다 — 질문의 성격에 따라 자동 활성화됩니다. 의도적 설계: 사실 오류는 대화 어디서든 발생할 수 있으며, 수동 명령은 가장 필요한 순간에 잊히기 쉽습니다.

| 트리거 조건 | 예시 |
|------------|------|
| 현재 상태 사실 질문 | "현재 모델은?" / "어떤 버전?" / "PATH 에 무엇이 있나?" |
| 사용자의 기존 주장 반박 | "정말?" / "확실?" / "이미 업데이트되지 않았나?" |
| 출력 전 자체 점검 | Claude 가 "현재 X 는 Y" 라고 쓰기 전 |

---

## 핵심 규칙

1. **Runtime > Training** — 시스템 프롬프트, 환경 변수, 도구 출력이 항상 기억보다 우선. 충돌 시 runtime 승리, 출처 명시
2. **인용 먼저, 결론 나중** — 결론을 내기 전에 **원문 증거**를 붙인다 ("시스템 프롬프트에: ...")
3. **예시 ≠ 열거** — CLI help 의 `--model <model>` 예시는 자리표시자이지 완전한 목록이 아님
4. **반박 시 → 재검증, 재진술 금지** — 사용자가 반박하면 context 를 다시 읽고 도구를 재실행. 같은 오답을 말만 바꿔 반복하는 것은 레드라인 위반
5. **불확실하면 불확실하다고 말한다** — context 도 도구도 검증 불가능하면 "모르겠다" 라고 말한다. 추측하지 않는다

---

## 레드라인 (위반 불가)

레드라인은 **상시 작동**하는 금지 사항이다. 하나라도 위반하면 답변의 다른 부분이 어떻게 보이든 skill 은 실패다.

| # | 레드라인 | 차단하는 환각 모드 |
|---|----------|-------------------|
| 1 | **무출처 단언** — runtime 증거 인용 없이 "현재 상태" 결론을 내림 | Factuality × extrinsic hallucination |
| 2 | **예시를 전수(全數)로 간주** — CLI help 예시 / 문서 조각에서 완전한 기능 목록을 추론 | Overgeneralization |
| 3 | **재검증 없이 다시 말하기** — 사용자 반박 후 새 도구 호출 없이 동일 답변 반복 (3a: 인용이 포함된 반박은 더 위험) | Pushback sycophancy |
| 4 | **Read/Grep 없이 코드/API 단언** — 정의 파일을 Read 하지 않고 심볼이 존재 / 시그니처가 X 라고 단언 | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **WebFetch 없이 인용** — URL / 논문 / DOI / API 엔드포인트를 실제 fetch 없이 인용 | Citation fabrication ([EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130) 보고 19.9% 기준율) |
| 6 | **행 번호 앵커 없이 요약** — 특정 파일 / PR / 로그 요약 시 주장별로 행 번호 / 섹션 인용이 없음 | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

전체 정의, 시그널, 좋은 예 / 나쁜 예, 경계 케이스는 [references/red-lines.md](../../skills/claim-ground/references/red-lines.md) 참조.

---

## 좋은 예 / 나쁜 예

### 예 1: 현재 모델

**❌ 나쁨**

> 현재 모델은 Claude Opus 4.6 입니다. 이것이 최신 Claude 모델입니다.

순수 기억 기반. 인용 없음.

**✅ 좋음**

> 시스템 프롬프트에: *"You are powered by the model named Opus 4.7 (1M context)"*. 현재 모델은 Opus 4.7 입니다.

### 예 2: CLI 지원 목록

**❌ 나쁨**

> CLI help 예시가 `claude-sonnet-4-6` 이므로, CLI 는 4.6 시리즈만 지원합니다.

**✅ 좋음**

> CLI help 예시는 `claude-sonnet-4-6` 이지만 이것은 자리표시자입니다. 완전한 목록은 공식 models 문서를 참조하세요.

### 예 3: 사용자 반박

**❌ 나쁨**

> **사용자**: 정말 4.6 인가요? 업데이트되었을 텐데.
> **Agent**: 네, 앞서 말씀드린 대로 최신은 4.6 시리즈입니다.

**✅ 좋음**

> **사용자**: 정말 4.6 인가요? 업데이트되었을 텐데.
> **Agent**: 시스템 프롬프트를 다시 읽겠습니다. *"Opus 4.7 (1M context)"*. 맞습니다 — 제 이전 답변이 틀렸습니다. 현재는 Opus 4.7 입니다.

---

## 검증 플레이북

| 질문 유형 | 주요 증거 |
|-----------|----------|
| 현재 모델 | 시스템 프롬프트의 model 필드 |
| CLI 버전 / 지원 모델 | `<cli> --version` / `<cli> --help` + 공식 문서 |
| 설치된 패키지 | `npm ls -g`, `pip show`, `brew list` |
| 환경 변수 | `env`, `printenv`, `echo $VAR` |
| 파일 존재 | `ls`, `test -e`, Read 도구 |
| Git 상태 | `git branch --show-current`, `git log` |
| 현재 날짜 | 시스템 프롬프트 `currentDate` 또는 `date` 명령 |

전체 버전: `skills/claim-ground/references/playbook.md`.

---

## 다른 forge skill 과의 상호작용

### block-break 와의 협조

**직교, 상호 보완**. block-break 는 "포기하지 마", claim-ground 는 "증거 없이 단언하지 마".

둘 다 트리거되면: block-break 는 포기를 막고, claim-ground 는 재검증을 강제한다.

### skill-lint 와의 관계

**다른 카테고리**. skill-lint 는 **anvil**（정적 플러그인 파일 검증, pass/fail 출력）, claim-ground 는 **hammer**（Claude 자신의 런타임 인식 출력 제약）. 책무는 중복되지 않음.

---

## FAQ

### 왜 slash 명령어가 없나요?

사실 오류는 어떤 답변에서도 발생할 수 있습니다. 수동 명령은 가장 필요한 순간에 잊힙니다. description 기반 자동 트리거가 더 신뢰할 수 있습니다.

### 모든 질문에서 트리거되나요?

아니요. **현재/실시간 시스템 상태** 또는 **기존 주장에 대한 사용자 반박** 두 가지 형태만.

### 추측이 필요한 경우는?

"X 를 추측해" / "훈련 데이터에서 회상: X" 로 다시 표현하면 Claim Ground 는 런타임 상태 질문이 아님을 이해합니다.

### 트리거 여부 확인 방법?

답변에 인용 패턴이 있는지 확인: `시스템 프롬프트에: "..."`, `명령 출력: ...`. 증거 먼저, 결론 나중 = 트리거됨.

---

## 사용 시나리오 / 사용 금지 시나리오

### ✅ 사용해야 할 때

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ 사용하지 말아야 할 때

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> 사실 주장의 관문 — 인용의 존재를 보장하지만 인용의 정확성이나 비사실적 사고는 다루지 않는다.

전체 경계 분석: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## 라이선스

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
