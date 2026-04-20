# Tome Forge 사용자 가이드

> 5분 만에 시작하기 — LLM 컴파일 위키를 활용한 개인 지식 베이스

---

## 설치

### Claude Code (권장)

```bash
claude plugin add juserai/forge
```

### 범용 원라인 설치

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **의존성 제로** — Tome Forge는 외부 서비스, 벡터 DB, RAG 인프라가 필요 없습니다. 설치하고 바로 사용하세요.

---

## 명령어

| 명령어 | 기능 | 사용 시기 |
|--------|------|----------|
| `/tome-forge init` | 지식 베이스 초기화 | 임의의 디렉토리에서 새 KB를 시작할 때 |
| `/tome-forge capture [text]` | 메모, 링크, 클립보드 빠른 캡처 | 생각 메모, URL 저장, 클리핑 |
| `/tome-forge capture clip` | 시스템 클립보드에서 캡처 | 복사한 내용 빠르게 저장 |
| `/tome-forge ingest <path>` | 원시 자료를 위키로 컴파일 | `raw/`에 논문, 기사, 메모를 추가한 후 |
| `/tome-forge ingest <path> --dry-run` | 쓰기 없이 라우팅 미리보기 | 변경 사항을 커밋하기 전에 확인 |
| `/tome-forge query <question>` | 위키에서 검색 및 종합 | 지식 베이스 전체에서 답변 찾기 |
| `/tome-forge lint` | 위키 구조 상태 점검 | 커밋 전, 정기 유지보수 |
| `/tome-forge compile` | 모든 새로운 원시 자료 일괄 컴파일 | 여러 원시 파일 추가 후 따라잡기 |

---

## 작동 원리

Karpathy의 LLM 위키 패턴 기반:

```
raw materials + LLM compilation = structured Markdown wiki
```

### 2계층 아키텍처

| 계층 | 소유자 | 목적 |
|------|--------|------|
| `raw/` | 사용자 | 불변의 소스 자료 — 논문, 기사, 메모, 링크 |
| `wiki/` | LLM | 컴파일된, 구조화된, 상호 참조 Markdown 페이지 |

LLM이 원시 자료를 읽고 잘 구조화된 위키 페이지로 컴파일합니다. `wiki/`를 직접 편집하지 마세요 — 원시 자료를 추가하고 LLM이 위키를 관리하도록 합니다.

### 성역 섹션

모든 위키 페이지에는 `## 나의 이해 차이` 섹션이 있습니다. 이것은 **당신의 것**입니다 — LLM은 절대 이를 수정하지 않습니다. 여기에 개인적인 통찰, 이견, 직관을 작성하세요. 모든 재컴파일에서 보존됩니다.

---

## KB 탐색 — 내 데이터는 어디로 가나요?

**어떤 디렉토리**에서든 `/tome-forge`를 실행할 수 있습니다. 올바른 KB를 자동으로 찾습니다:

| 상황 | 결과 |
|------|------|
| 현재 디렉토리(또는 상위)에 `.tome-forge.json`이 있음 | 해당 KB 사용 |
| 상위로 `.tome-forge.json`을 찾지 못함 | 기본 `~/.tome-forge/` 사용 (필요시 자동 생성) |

이는 먼저 `cd`할 필요 없이 어떤 프로젝트에서든 메모를 캡처할 수 있음을 의미합니다 — 모든 것이 단일 기본 KB로 모입니다.

프로젝트별 별도 KB를 원하시나요? 해당 프로젝트 디렉토리 안에서 `init .`를 사용하세요.

## 워크플로우

### 1. 초기화

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

초기화 후 KB 디렉토리 구조:

```
~/.tome-forge/               # (or wherever you initialized)
├── .tome-forge.json         # KB marker (auto-generated)
├── CLAUDE.md                # KB schema and rules
├── index.md                 # Wiki page index
├── .gitignore
├── logs/                    # Operation logs (monthly rotation)
│   └── 2026-04.md           # One file per month, never grows too large
├── raw/                     # Your source materials (immutable)
└── wiki/                    # LLM-compiled wiki (auto-maintained)
```

### 2. 캡처

**어떤 디렉토리**에서든 다음을 실행하세요:

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

빠른 캡처는 `raw/captures/{date}/`에 저장됩니다. 더 긴 자료는 파일을 직접 `raw/papers/`, `raw/articles/` 등에 넣으세요.

### 3. 수집

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

LLM이 원시 파일을 읽고, 적절한 위키 페이지로 라우팅하며, 개인 메모를 보존하면서 새로운 정보를 병합합니다.

### 4. 질의

```
/tome-forge query "what is the relationship between attention and transformers?"
```

위키에서 답변을 종합하며 특정 페이지를 인용합니다. 정보가 부족하면 어떤 원시 자료를 추가해야 하는지 알려줍니다.

### 5. 유지보수

```
/tome-forge lint
/tome-forge compile
```

Lint는 구조적 무결성을 확인합니다. Compile은 마지막 컴파일 이후의 모든 새로운 항목을 일괄 수집합니다.

---

## 디렉토리 구조

```
my-knowledge-base/
├── .tome-forge.json       # KB marker (auto-generated)
├── CLAUDE.md              # Schema and rules (auto-generated)
├── index.md               # Wiki page index
├── .last_compile          # Timestamp for batch compile
├── logs/                  # Operation logs (monthly rotation)
│   └── 2026-04.md
├── raw/                   # Your source materials (immutable)
│   ├── captures/          # Quick captures by date
│   ├── papers/            # Academic papers
│   ├── articles/          # Blog posts, articles
│   ├── books/             # Book notes
│   └── conversations/     # Chat logs, interviews
└── wiki/                  # LLM-compiled wiki (auto-maintained)
    ├── ai/                # Domain directories
    ├── systems/
    └── ...
```

---

## 위키 페이지 형식

모든 위키 페이지는 엄격한 템플릿을 따릅니다:

```yaml
---
domain: ai
maturity: growing        # draft | growing | stable | deprecated
last_compiled: 2026-04-15
source_refs:
  - raw/papers/attention.md
confidence: medium       # low | medium | high
compiled_by: claude-opus-4-6
---
```

필수 섹션:
- **핵심 개념** — LLM이 관리하는 지식
- **나의 이해 차이** — 개인적인 통찰 (LLM이 절대 수정하지 않음)
- **열린 질문** — 미답변 질문
- **연결** — 관련 위키 페이지 링크

---

## 권장 주기

| 빈도 | 작업 | 시간 |
|------|------|------|
| **매일** | 생각, 링크, 클립보드 `capture` | 2분 |
| **매주** | 주간 원시 자료 일괄 처리 `compile` | 15-30분 |
| **매월** | `lint` + 나의 이해 차이 섹션 검토 | 30분 |

**실시간 수집을 피하세요.** 빈번한 단일 파일 수집은 위키의 일관성을 단편화합니다. 주간 일괄 컴파일이 더 나은 상호 참조와 더 일관된 페이지를 생성합니다.

---

## 확장 로드맵

| 단계 | 위키 크기 | 전략 |
|------|----------|------|
| 1. 콜드 스타트 (1-4주차) | < 30 페이지 | 전체 컨텍스트 읽기, index.md 라우팅 |
| 2. 정상 상태 (2-3개월차) | 30-100 페이지 | 주제별 샤딩 (wiki/ai/, wiki/systems/) |
| 3. 확장 (4-6개월차) | 100-200 페이지 | 샤드 범위 쿼리, ripgrep 보완 |
| 4. 고급 (6개월 이상) | 200+ 페이지 | 임베딩 기반 라우팅 (검색이 아님), 증분 컴파일 |

---

## 알려진 위험

| 위험 | 영향 | 완화 |
|------|------|------|
| **표현 드리프트** | 다중 컴파일이 개인적 문체를 평탄화 | `compiled_by`로 모델 추적; raw/가 진실의 원천; 언제든 raw에서 재컴파일 |
| **확장 한계** | 컨텍스트 윈도우가 위키 크기 제한 | 도메인별 샤드; 인덱스 라우팅 사용; > 200 페이지에서 임베딩 계층 |
| **벤더 종속** | 하나의 LLM 제공자에 종속 | 원시 소스는 순수 Markdown; 모델 전환 후 재컴파일 |
| **델타 손상** | LLM이 개인 통찰을 덮어씀 | 수집 후 diff 검증이 원본 델타를 자동 복원 |

---

## 플랫폼

| 플랫폼 | 작동 방식 |
|--------|----------|
| Claude Code | 전체 파일 시스템 접근, 병렬 읽기, git 통합 |
| OpenClaw | 동일한 작업, OpenClaw 도구 규칙에 맞게 적응 |

---

## 사용 시나리오 / 사용 금지 시나리오

### ✅ 사용해야 할 때

- Building a personal knowledge base from scattered notes
- You want LLM-compiled wiki that preserves human insights
- Zero-infra solution (just Markdown + Git)

### ❌ 사용하지 말아야 할 때

- Team collaboration or real-time sync
- Ad-hoc notes (too structured — plain Markdown is fine)
- Transactional data (use a real database)

> LLM이 편찬한 개인 도서관 — 인간의 통찰을 보존하지만, 개인용이며 실시간 동기화나 권한 제어는 하지 않는다.

전체 경계 분석: [references/scope-boundaries.md](../../../skills/tome-forge/references/scope-boundaries.md)

---

## FAQ

**Q: 위키가 얼마나 커질 수 있나요?**
A: 50페이지 미만에서는 LLM이 모든 것을 읽습니다. 50-200페이지에서는 인덱스를 사용하여 탐색합니다. 200을 넘으면 도메인 샤딩을 고려하세요.

**Q: 위키 페이지를 직접 편집할 수 있나요?**
A: `## 나의 이해 차이` 섹션만 가능합니다. 나머지는 다음 수집/컴파일 시 덮어쓰기됩니다.

**Q: 벡터 데이터베이스가 필요한가요?**
A: 아니요. 위키는 순수 Markdown입니다. LLM이 파일을 직접 읽습니다 — 임베딩 없음, RAG 없음, 인프라 없음.

**Q: KB를 어떻게 백업하나요?**
A: 모두 git 저장소의 파일입니다. `git push`하면 됩니다.

**Q: LLM이 위키에서 실수하면 어떻게 하나요?**
A: `raw/`에 수정 사항을 추가하고 다시 수집하세요. 병합 알고리즘은 더 권위 있는 소스를 우선합니다. 또는 나의 이해 차이에 이견을 기록하세요.
