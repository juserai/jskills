# News Fetch 사용자 가이드

> 3분 만에 시작하세요 — AI가 뉴스 브리핑을 가져오게 하세요

디버깅에 지치셨나요? 2분 동안 세상에서 무슨 일이 일어나고 있는지 확인하고 새로운 마음으로 돌아오세요.

---

## 설치

### Claude Code (권장)

```bash
claude plugin add juserai/forge
```

### 범용 한 줄 설치

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **의존성 없음** — News Fetch는 외부 서비스나 API 키가 필요 없습니다. 설치하고 바로 시작하세요.

---

## 명령어

| 명령어 | 기능 | 사용 시기 |
|--------|------|----------|
| `/news-fetch AI` | 이번 주 AI 뉴스 가져오기 | 빠른 업계 업데이트 |
| `/news-fetch AI today` | 오늘의 AI 뉴스 가져오기 | 일일 브리핑 |
| `/news-fetch robotics month` | 이번 달 로보틱스 뉴스 가져오기 | 월간 리뷰 |
| `/news-fetch climate 2026-03-01~2026-03-31` | 특정 날짜 범위의 뉴스 가져오기 | 목표 연구 |

---

## 사용 사례

### 일일 기술 브리핑

```
/news-fetch AI today
```

오늘의 최신 AI 뉴스를 관련도 순으로 받아보세요. 몇 초 만에 헤드라인과 요약을 스캔할 수 있습니다.

### 업계 리서치

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

시장 분석 및 경쟁 조사를 위해 특정 기간의 뉴스를 가져옵니다.

### 교차 언어 뉴스

중국어 주제는 더 넓은 보도를 위해 자동으로 보충 영어 검색이 이루어지며, 그 반대도 마찬가지입니다. 추가 노력 없이 두 세계의 장점을 모두 얻을 수 있습니다.

---

## 예상 출력 예시

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## 3단계 네트워크 폴백

News Fetch에는 다양한 네트워크 조건에서 뉴스 검색이 작동하도록 보장하는 내장 폴백 전략이 있습니다:

| 단계 | 도구 | 데이터 소스 | 트리거 |
|------|------|-----------|--------|
| **L1** | WebSearch | Google/Bing | 기본값 (선호) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 실패 |
| **L3** | Bash curl | L2와 동일한 소스 | L2도 실패 |

모든 단계가 실패하면 각 소스의 실패 이유를 나열하는 구조화된 실패 보고서가 생성됩니다.

---

## 출력 기능

| 기능 | 설명 |
|------|------|
| **중복 제거** | 여러 소스가 동일한 이벤트를 다룰 때 가장 높은 점수의 항목이 유지되고 나머지는 "관련 보도"로 축소됩니다 |
| **요약 보완** | 검색 결과에 요약이 없으면 기사 본문을 가져와 요약을 생성합니다 |
| **관련도 점수** | AI가 주제 관련도로 각 결과를 채점합니다 — 높을수록 더 관련성이 높음 |
| **클릭 가능한 링크** | Markdown 링크 형식 — IDE 및 터미널에서 클릭 가능 |

---

## 관련도 점수

각 기사는 제목과 요약이 요청된 주제와 얼마나 잘 일치하는지에 따라 0-300점으로 채점됩니다:

| 점수 범위 | 의미 |
|----------|------|
| 200-300 | 매우 관련성 높음 — 주제가 기본 주제 |
| 100-199 | 적당히 관련됨 — 주제가 상당히 언급됨 |
| 0-99 | 부수적으로 관련됨 — 주제가 부수적으로 등장 |

기사는 점수 내림차순으로 정렬됩니다. 점수는 휴리스틱이며 키워드 밀도, 제목 일치 및 맥락적 관련성을 기반으로 합니다.

## 네트워크 폴백 문제 해결

| 증상 | 가능한 원인 | 해결 방법 |
|------|-----------|----------|
| L1이 0개 결과 반환 | WebSearch 도구를 사용할 수 없거나 쿼리가 너무 구체적임 | 주제 키워드를 넓히기 |
| L2 모든 소스 실패 | 국내 뉴스 사이트가 자동 접근을 차단 | 기다렸다가 재시도하거나 `curl`이 수동으로 작동하는지 확인 |
| L3 curl 시간 초과 | 네트워크 연결 문제 | `curl -I https://news.baidu.com` 확인 |
| 모든 단계 실패 | 인터넷 접속 불가 또는 모든 소스 다운 | 네트워크 확인; 실패 보고서가 각 소스의 오류를 나열 |

---

## 자주 묻는 질문

### API 키가 필요한가요?

아닙니다. News Fetch는 전적으로 WebSearch와 공개 웹 스크래핑에 의존합니다. 구성이 필요 없습니다.

### 영어 뉴스를 가져올 수 있나요?

물론입니다. 중국어 주제에는 자동으로 보충 영어 검색이 포함되며, 영어 주제는 기본적으로 작동합니다. 보도 범위는 두 언어에 걸쳐 있습니다.

### 네트워크가 제한되어 있으면 어떻게 되나요?

3단계 폴백 전략이 이를 자동으로 처리합니다. WebSearch를 사용할 수 없더라도 News Fetch는 국내 뉴스 소스로 폴백합니다.

### 몇 개의 기사가 반환되나요?

최대 20개 (중복 제거 후). 실제 수는 데이터 소스가 반환하는 내용에 따라 다릅니다.

---

## 사용 시나리오 / 사용 금지 시나리오

### ✅ 사용해야 할 때

- You want a quick news brief between coding sessions
- Bilingual aggregation (English + domestic sources)
- Network-restricted environments (3-tier fallback handles blocked sources)

### ❌ 사용하지 말아야 할 때

- You need synthesized research (use `insight-fuse` instead)
- Targeted source monitoring (use an RSS reader)
- Translation tasks (news-fetch returns source language as-is)

> 코딩 쉬는 시간의 뉴스 브리핑 — 2분 만에 세상을 훑어보기, 심층 분석이나 번역은 하지 않는다.

전체 경계 분석: [references/scope-boundaries.md](../../../skills/news-fetch/references/scope-boundaries.md)

---

## 라이선스

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
