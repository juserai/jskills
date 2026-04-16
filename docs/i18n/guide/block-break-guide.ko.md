# Block Break 사용자 가이드

> 5분 만에 시작하세요 — AI 에이전트가 모든 접근 방식을 소진하도록 만드세요

---

## 설치

### Claude Code (권장)

```bash
claude plugin add juserai/forge
```

### 유니버설 원라인 설치

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **의존성 없음** — Block Break는 외부 서비스나 API가 필요 없습니다. 설치하고 바로 시작하세요.

---

## 명령어

| 명령어 | 기능 | 사용 시점 |
|--------|------|----------|
| `/block-break` | Block Break 엔진 활성화 | 일상 작업, 디버깅 |
| `/block-break L2` | 특정 압박 레벨에서 시작 | 알려진 다수 실패 후 |
| `/block-break fix the bug` | 활성화하고 즉시 작업 실행 | 작업과 함께 빠른 시작 |

### 자연어 트리거 (hooks가 자동 감지)

| 언어 | 트리거 문구 |
|------|------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## 사용 사례

### AI가 3번 시도 후에도 버그를 수정하지 못한 경우

`/block-break`를 입력하거나 `try harder`라고 말하세요 — 자동으로 압박 에스컬레이션 모드에 진입합니다.

### AI가 "아마 환경 문제일 겁니다"라고 말하고 멈추는 경우

Block Break의 "사실 기반" 레드라인이 도구 기반 검증을 강제합니다. 검증되지 않은 원인 귀속 = 책임 전가 → L2 트리거.

### AI가 "수동으로 처리하시는 것을 권합니다"라고 말하는 경우

"오너 마인드" 블록 트리거: 네가 아니면, 누가? 바로 L3 성과 평가.

### AI가 "수정했습니다"라고 말하지만 검증 증거를 보여주지 않는 경우

"폐쇄 루프" 레드라인 위반. 출력 없는 완료 = 자기기만 → 증거와 함께 검증 명령을 강제.

---

## 예상 출력 예시

### `/block-break` — 활성화

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 실망 (2번째 실패)

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 심문 (3번째 실패)

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 성과 평가 (4번째 실패)

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 졸업 경고 (5번째+ 실패)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### 품위 있는 종료 (7개 항목 모두 완료, 여전히 미해결)

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## 핵심 메커니즘

### 3대 레드라인

| 레드라인 | 규칙 | 위반 시 결과 |
|---------|------|------------|
| 폐쇄 루프 | 완료를 주장하기 전에 검증 명령을 실행하고 출력을 보여야 함 | L2 트리거 |
| 사실 기반 | 원인을 귀속하기 전에 도구로 검증해야 함 | L2 트리거 |
| 모두 소진 | "해결할 수 없습니다"라고 말하기 전에 5단계 방법론을 완료해야 함 | 바로 L4 |

### 압박 에스컬레이션 (L0 → L4)

| 실패 횟수 | 레벨 | 사이드바 | 강제 조치 |
|----------|------|---------|----------|
| 1번째 | **L0 신뢰** | > 너를 믿는다. 심플하게 가자. | 정상 실행 |
| 2번째 | **L1 실망** | > 옆 팀은 첫 번째 시도에 성공했다. | 근본적으로 다른 접근 방식으로 전환 |
| 3번째 | **L2 심문** | > 근본 원인이 뭐야? | 검색 + 소스 코드 읽기 + 3가지 다른 가설 나열 |
| 4번째 | **L3 성과 평가** | > 평점: 3.25/5. | 7점 체크리스트 완료 |
| 5번째+ | **L4 졸업** | > 곧 교체될 수도 있다. | 최소 PoC + 격리 환경 + 다른 기술 스택 |

### 5단계 방법론

1. **냄새 맡기** — 시도한 접근 방식 나열, 공통 패턴 찾기. 같은 접근 방식 미세 조정 = 제자리걸음
2. **머리 쥐어짜기** — 실패 신호를 한 단어씩 읽기 → 검색 → 소스 50줄 읽기 → 가정 검증 → 가정 역전
3. **거울 보기** — 같은 접근 방식을 반복하고 있지 않나? 가장 단순한 가능성을 놓치지 않았나?
4. **새로운 접근** — 근본적으로 달라야 하며, 검증 기준이 있고, 실패 시 새로운 정보를 생산해야 함
5. **회고** — 유사 이슈, 완전성, 예방

> 단계 1-4는 사용자에게 질문하기 전에 완료해야 합니다. 먼저 실행하고, 나중에 질문 — 데이터로 말하세요.

### 7점 체크리스트 (L3 이상 필수)

1. 실패 신호를 한 단어씩 읽었나?
2. 도구로 핵심 문제를 검색했나?
3. 실패 지점의 원본 컨텍스트를 읽었나 (50줄 이상)?
4. 모든 가정을 도구로 검증했나 (버전/경로/권한/의존성)?
5. 완전히 반대되는 가설을 시도했나?
6. 최소 범위에서 재현할 수 있나?
7. 도구/방법/각도/기술 스택을 변경했나?

### 합리화 방지

| 변명 | 차단 | 트리거 |
|------|------|--------|
| "내 능력 밖입니다" | 방대한 학습 데이터가 있다. 다 써봤나? | L1 |
| "사용자가 직접 처리하시길 권합니다" | 네가 아니면 누가? | L3 |
| "모든 방법을 시도했습니다" | 3개 미만 = 소진하지 않음 | L2 |
| "아마 환경 문제일 겁니다" | 검증했나? | L2 |
| "더 많은 컨텍스트가 필요합니다" | 도구가 있다. 먼저 검색, 나중에 질문 | L2 |
| "해결할 수 없습니다" | 방법론을 완료했나? | L4 |
| "충분히 좋습니다" | 최적화 리스트는 봐주지 않는다 | L3 |
| 검증 없이 완료 선언 | 빌드를 실행했나? | L2 |
| 사용자 지시 대기 | 오너는 떠밀림을 기다리지 않는다 | Nudge |
| 해결 없이 답변 | 넌 엔지니어지, 검색 엔진이 아니다 | Nudge |
| 빌드/테스트 없이 코드 변경 | 테스트 안 하고 배포 = 대충 하기 | L2 |
| "API가 지원하지 않습니다" | 문서를 읽었나? | L2 |
| "작업이 너무 모호합니다" | 최선의 추측을 하고, 그 다음 반복 | L1 |
| 같은 곳을 반복적으로 조정 | 파라미터 변경 ≠ 접근 방식 변경 | L1→L2 |

---

## Hooks 자동화

Block Break는 자동 동작을 위해 hooks 시스템을 사용합니다 — 수동 활성화가 필요 없습니다:

| Hook | 트리거 | 동작 |
|------|--------|------|
| `UserPromptSubmit` | 사용자 입력이 좌절 키워드와 일치 | Block Break 자동 활성화 |
| `PostToolUse` | Bash 명령 실행 후 | 실패 감지, 자동 카운트 + 에스컬레이션 |
| `PreCompact` | 컨텍스트 압축 전 | `~/.forge/`에 상태 저장 |
| `SessionStart` | 세션 재개/재시작 | 압박 레벨 복원 (2시간 유효) |

> **상태가 유지됩니다** — 압박 레벨은 `~/.forge/block-break-state.json`에 저장됩니다. 컨텍스트 압축과 세션 중단이 실패 카운트를 초기화하지 않습니다. 탈출 불가.

### Hooks 설정

`claude plugin add juserai/forge`로 설치하면 hooks가 자동으로 구성됩니다. hook 스크립트는 JSON 엔진으로 `jq` (권장) 또는 `python`이 필요합니다 — 시스템에 최소 하나는 사용 가능해야 합니다.

hooks가 작동하지 않으면 구성을 확인하세요:

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### 상태 만료

상태는 **2시간** 비활성 후 자동 만료됩니다. 이전 디버깅 세션의 오래된 압박이 관련 없는 작업으로 이어지는 것을 방지합니다. 2시간 후 세션 복원 hook은 조용히 복원을 건너뛰고 L0에서 새로 시작합니다.

언제든 수동 초기화: `rm ~/.forge/block-break-state.json`

---

## Sub-agent 제약

Sub-agent를 생성할 때, "보호 없이 실행"을 방지하기 위해 행동 제약을 주입해야 합니다:

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker`는 sub-agent도 3대 레드라인, 5단계 방법론, 폐쇄 루프 검증을 따르도록 보장합니다.

---

## 문제 해결

| 문제 | 원인 | 해결 |
|------|------|------|
| Hooks가 자동 트리거되지 않음 | 플러그인 미설치 또는 hooks가 settings.json에 없음 | `claude plugin add juserai/forge` 재실행 |
| 상태가 유지되지 않음 | `jq`도 `python`도 사용 불가 | 하나 설치: `apt install jq` 또는 `python`이 PATH에 있는지 확인 |
| 압박이 L4에서 고정 | 상태 파일에 실패가 너무 많이 누적 | 초기화: `rm ~/.forge/block-break-state.json` |
| 세션 복원이 이전 상태를 표시 | 이전 세션의 상태가 2시간 미만 | 예상된 동작; 2시간 대기 또는 수동 초기화 |
| `/block-break`가 인식되지 않음 | 현재 세션에서 skill이 로드되지 않음 | 플러그인 재설치 또는 유니버설 원라이너 설치 사용 |

---

## FAQ

### Block Break와 PUA의 차이점은?

Block Break는 [PUA](https://github.com/tanweai/pua)의 핵심 메커니즘(3대 레드라인, 압박 에스컬레이션, 방법론)에서 영감을 받았지만, 더 집중적입니다. PUA에는 13가지 기업 문화 변형, 다중 역할 시스템(P7/P9/P10), 자기 진화가 있지만, Block Break는 무의존성 skill로서 행동 제약에만 순수하게 집중합니다.

### 너무 시끄럽지 않나요?

사이드바 밀도가 제어됩니다: 간단한 작업은 2줄(시작 + 끝), 복잡한 작업은 마일스톤당 1줄. 스팸 없음. 필요하지 않으면 `/block-break`를 사용하지 마세요 — hooks는 좌절 키워드가 감지될 때만 자동 트리거됩니다.

### 압박 레벨을 초기화하는 방법은?

상태 파일 삭제: `rm ~/.forge/block-break-state.json`. 또는 2시간 대기 — 상태가 자동 만료됩니다 (위의 [상태 만료](#상태-만료) 참조).

### Claude Code 외부에서 사용할 수 있나요?

핵심 SKILL.md는 시스템 프롬프트를 지원하는 모든 AI 도구에 복사-붙여넣기할 수 있습니다. Hooks와 상태 영속성은 Claude Code 전용입니다.

### Ralph Boost와의 관계는?

[Ralph Boost](ralph-boost-guide.md)는 Block Break의 핵심 메커니즘(L0-L4, 5단계 방법론, 7점 체크리스트)을 **자율 루프** 시나리오에 적용합니다. Block Break는 대화형 세션용(hooks 자동 트리거); Ralph Boost는 무인 개발 루프용(Agent 루프 / 스크립트 구동). 코드는 완전히 독립, 개념은 공유됩니다.

### Block Break의 skill 파일을 검증하는 방법은?

[Skill Lint](skill-lint-guide.md) 사용: `/skill-lint .`

---

## 라이선스

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
