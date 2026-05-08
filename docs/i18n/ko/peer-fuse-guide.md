# Peer Fuse v0.1.0 가이드

> 연구 산출물을 위한 범용 peer-reviewer — **8단계 파이프라인 (Stage 7 KB 아카이빙 필수 + 관측 가능, `--no-save`로 opt-out) + 10가지 형식 입력 어댑터 (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, 3-tier dispatch) + 6가지 연구 유형 프리셋 (자동 분류) + 8차원 가중 rubric + 18-flag taxonomy + 3-perspective panel + § Document Reading freeze (review-isolation 하드 제약)**.

Peer-Fuse는 모든 markdown / PDF / Office 문서를 입력받아 A+/A−/.../D 등급, 품질 flag의 계층화된 목록, 다관점 panel 합성, patch 형식의 diff 제안을 포함하는 peer-review markdown 보고서를 생성합니다. [insight-fuse Stage 6.5 reviewer](insight-fuse-guide.md)와 공존합니다 — Stage 6.5는 IF 내부 동일 소스 review이고, peer-fuse는 Stage 6.5가 처리할 수 없는 형식과 skill을 다루는 **cross-skill 외부 reviewer**입니다.

## 빠른 시작

```bash
# 유형 자동 분류, 기본 depth, KB로 아카이빙
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# PDF 학술 논문 (유형은 arXiv/IEEE/Nature 헤더에서 자동 감지)
/peer-fuse papers/transformer-2017.pdf

# 명시적 유형이 지정된 PPTX deck
/peer-fuse decks/q4-roadmap.pptx --type product

# Quick depth (Stage 4 panel + Stage 5.5 holistic 건너뜀) + KB 아카이브 건너뜀
/peer-fuse handbook.docx --depth quick --no-save

# 도움말 표시
/peer-fuse help
# 또는 인자 없이
/peer-fuse
```

## 기본값 및 플래그

| Flag | Default | Values |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — Stage 7 KB 아카이브를 건너뛰고 콘솔 출력만 |

`--type=auto`를 사용하면 peer-fuse가 문서를 읽은 후 휴리스틱(frontmatter type field → section pattern → citation density → format/title hints → fallback overview)을 통해 분류합니다. 우선순위 체인은 [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md)를 참고하세요.

## 지원 형식

| Tier | Tool requirement | Formats |
|:-:|---|---|
| 1 | none (native) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` for `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

도구 누락 → 구체적인 설치 힌트(`brew install pandoc`, `apt install libreoffice` 등)와 함께 fail-soft하고 Stage 1 이전에 종료. [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md)를 참고하세요.

## 결과물

두 가지 병렬 산출물:

1. **인라인 렌더링 review** — 대화창에 다음과 같이 구조화되어 표시:
   - § Document Reading — 서술적 narrative (문서가 말하는 내용), 3-5 문단, 300-600 단어
   - § Holistic Assessment — 평가적 narrative (방법론 / 강점 / 우려 사항 / 권고), 4 문단, 400-700 단어
   - § Score Matrix — 8차원 가중 점수 → 문자 등급
   - § Flag List — 18-taxonomy의 flag 코드 + 위치
   - § Multi-Perspective Panel — methodologist / adversarial / practitioner 평결
   - § Diff Suggestions — 각 감점 항목에 대한 patch 형식 재작성
   - § Reconciliation — target self-grade vs review_grade Δ

2. **KB 아카이브** — `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` (`--no-save`로 건너뛰기). 아카이브 로그 라인 `Archived to KB: <path>`는 항상 사용자에게 표시되는 응답에 포함됩니다.

## 하드 제약: § Document Reading은 review-isolated

peer-fuse에서 가장 중요한 아키텍처 결정:

**§ Document Reading은 review 평결로 오염되어서는 안 됩니다.** 이는 reviewer가 문서를 충실하게 서술적으로 읽은 결과입니다 — frontmatter, 구조, 주장, 증거, 범위. Stage 3.5에서 실행되며, **Stage 4 panel과 Stage 5 scoring 이전**에 수행되고, 입력 경계는 엄격합니다:

- 허용: 원본 문서, Stage 1-3 사실 스캔 결과
- 거부: panel 평결, 점수, flag hits

이 섹션은 Stage 3.5 이후 **freeze**됩니다: Stage 4 이전에 SHA-256 해시가 계산되고, Stage 7은 아카이브 전에 해시를 검증합니다. 어떤 수정이라도 → fail-closed. Lint 또한 평가적 어휘(`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) 와 문자 등급 리터럴을 이 섹션에서 금지합니다.

이는 사용자가 명시한 하드 제약이며 세 가지 수준에서 강제됩니다: 아키텍처적 격리 + write-once freeze + forbidden-word lint.

## 다른 forge skill과의 상호작용

| Skill | Relationship |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | 공존 — Stage 6.5는 IF 내부 동일 소스 review (동일 rubric, 동일 휴리스틱, IF markdown만). peer-fuse는 더 넓은 8차원 rubric, 18 flags, 10 형식, 3-agent panel을 갖춘 **cross-skill 외부 review**. 중요한 IF 보고서에는 둘 다 실행되어야 함. |
| **council-fuse** | 형제 crucible — peer-fuse는 council-fuse의 parallel sub-agent dispatch 패턴을 재사용 (Stage 4 panel은 council-fuse Stage 1을 미러링). |
| **tome-forge** | 아카이브 백엔드 — peer-fuse Stage 7은 tome-forge의 report-archival-protocol을 호출; KB 쓰기 로직을 재구현하지 않음. |
| **skill-lint** | 패턴상 형제 (다른 분류, anvil) — 둘 다 산출물을 판정하고 진단을 발행하지만, skill-lint는 일시적 콘솔 진단을 출력하고 peer-fuse는 영구적인 markdown peer-review 산출물을 출력. |

## peer-fuse vs IF Stage 6.5 사용 시기

| Scenario | Use |
|---|:-:|
| `/insight-fuse <topic>`을 방금 실행했고 IF 보고서에 대한 second opinion을 원할 때 | IF Stage 6.5가 이미 인라인으로 실행됨; cross-format readiness가 있는 second-layer 외부 review를 원하면 `/peer-fuse <if-output-path>` 실행 |
| 평가할 third-party PDF 연구 논문이 있을 때 | peer-fuse |
| 등급을 매기고 싶은 PPTX 비즈니스 deck이 있을 때 | peer-fuse |
| 등급을 매기고 싶은 council-fuse 합성 출력이 있을 때 | peer-fuse |
| 동일 rubric으로 여러 산출물을 비교하고 싶을 때 | peer-fuse (산출물 간 일관된 점수 부여) |

## 구체적인 예시

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

콘솔은 전체 review를 인라인으로 렌더링하고, KB 아카이브는 영구적인 정본 버전입니다.

## 검증

```bash
# 정적 검사
bash skills/skill-lint/scripts/skill-lint.sh .

# Trigger 테스트
bash evals/peer-fuse/run-trigger-test.sh

# Hash lockstep
bash scripts/recalc-all-hashes.sh
```

## 참고자료

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — 런타임 skill 정의
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — 아키텍처 결정 + 4분류 근거
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (merge 후)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — 형제 crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — 형제 crucible (panel 패턴 출처)
