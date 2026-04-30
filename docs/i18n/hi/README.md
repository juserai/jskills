# Forge

> और मेहनत करो, फिर ब्रेक लो। Claude Code के साथ बेहतर कोडिंग रिदम के लिए 8 skills।

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-8-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../../README.md) | [中文](../zh-CN/README.md) | [日本語](../ja/README.md) | [한국어](../ko/README.md) | [Español](../es/README.md) | [Português](../pt-BR/README.md) | [Français](../fr/README.md) | [Deutsch](../de/README.md) | [Русский](../ru/README.md) | [हिन्दी](README.md) | [Türkçe](../tr/README.md) | [Tiếng Việt](../vi/README.md)

### क्विक डेमो

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## इंस्टॉल करें

```bash
# Claude Code (एक कमांड)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

> हर skill `/<skill> help` (या `--help`) पर usage card दिखाता है। जिन skills में argument ज़रूरी है, वे बिना argument कॉल करने पर भी help दिखाते हैं।

### Hammer

| Skill | क्या करता है | आज़माएँ |
|-------|-------------|---------|
| **block-break** | हार मानने से पहले हर approach try करने पर मजबूर करता है | `/block-break` |
| **ralph-boost** | Convergence guarantee के साथ autonomous dev loops | `/ralph-boost setup` |
| **claim-ground** | हर "अभी-अभी" दावे को runtime साक्ष्य से जोड़ें | ऑटो-ट्रिगर |

### Crucible

| Skill | क्या करता है | आज़माएँ |
|-------|-------------|---------|
| **council-fuse** | बेहतर जवाबों के लिए बहु-दृष्टिकोण विचार-विमर्श | `/council-fuse <question>` |
| **insight-fuse** | 7-चरण अनुसंधान इंजन, skeleton.yaml डेटा अनुबंध + 6-आयामी गुणवत्ता मानक | `/insight-fuse <topic>` |
| **tome-forge** | LLM-संकलित wiki के साथ व्यक्तिगत ज्ञान आधार | `/tome-forge init` |

### Anvil

| Skill | क्या करता है | आज़माएँ |
|-------|-------------|---------|
| **skill-lint** | किसी भी Claude Code skill plugin को validate करें | `/skill-lint .` |

### Quench

| Skill | क्या करता है | आज़माएँ |
|-------|-------------|---------|
| **news-fetch** | कोडिंग sessions के बीच ताज़ा खबरें | `/news-fetch AI today` |

---

## Block Break — Behavioral Constraint Engine

आपका AI हार गया? `/block-break` उसे पहले हर approach exhaust करने पर मजबूर करेगा।

जब Claude अटक जाता है, Block Break एक pressure escalation system activate करता है जो समय से पहले हार मानने से रोकता है। Agent को increasingly rigorous problem-solving stages से गुज़रना पड़ता है, इससे पहले कि वो "मैं ये नहीं कर सकता" जैसा कोई response दे सके।

| मैकेनिज़्म | विवरण |
|-----------|--------|
| **3 Red Lines** | Closed-loop verification / Fact-driven / सभी options exhaust करो |
| **Pressure Escalation** | L0 Trust → L1 Disappointment → L2 Interrogation → L3 Performance Review → L4 Graduation |
| **5-Step Method** | Smell → Pull hair → Mirror → New approach → Retrospect |
| **7-Point Checklist** | L3+ पर mandatory diagnostic checklist |
| **Anti-Rationalization** | 14 common excuse patterns को identify और block करता है |
| **Hooks** | Auto frustration detection + failure counting + state persistence |

```text
/block-break              # Block Break mode activate करें
/block-break L2           # किसी specific pressure level से शुरू करें
/block-break fix the bug  # Activate करें और तुरंत task शुरू करें
```

Natural language से भी trigger होता है: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, आदि (hooks द्वारा auto-detect)।

> [PUA](https://github.com/tanweai/pua) से प्रेरित, zero-dependency skill में distill किया गया।

## Ralph Boost — Autonomous Dev Loop Engine

Autonomous dev loops जो सच में converge होते हैं। 30 सेकंड में setup।

ralph-claude-code की autonomous loop capability को skill के रूप में replicate करता है, convergence guarantee के लिए built-in Block Break L0-L4 pressure escalation के साथ। Autonomous loops में "घूम रहा है पर आगे नहीं बढ़ रहा" की problem solve करता है।

| फ़ीचर | विवरण |
|-------|--------|
| **Dual-Path Loop** | Agent loop (primary, zero external deps) + bash script fallback (jq/python engines) |
| **Enhanced Circuit Breaker** | Built-in L0-L4 pressure escalation: "3 rounds बाद हार मान लो" से "6-7 rounds progressive self-rescue" तक |
| **State Tracking** | Circuit breaker + pressure + strategy + session के लिए unified state.json |
| **Graceful Handoff** | L4 पर raw crash की जगह structured handoff report generate होती है |
| **Independent** | `.ralph-boost/` directory use करता है, ralph-claude-code पर कोई dependency नहीं |

```text
/ralph-boost setup        # प्रोजेक्ट initialize करें
/ralph-boost run          # Autonomous loop शुरू करें
/ralph-boost status       # Current state check करें
/ralph-boost clean        # Clean up करें
```

> [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) से प्रेरित, convergence guarantee के साथ zero-dependency skill के रूप में reimagine किया गया।

## Claim Ground — Epistemic Constraint Engine

पुराने training ज्ञान के hallucinations बंद करें। `claim-ground` हर "अभी-अभी" दावे को runtime साक्ष्य से जोड़ता है।

ऑटो-ट्रिगर (कोई slash command नहीं)। जब Claude वर्तमान स्थिति के बारे में factual प्रश्नों का उत्तर देने वाला हो — चल रहा model, installed tools, env vars, config values — या जब उपयोगकर्ता पिछले दावे को चुनौती दे, Claim Ground निष्कर्ष निकालने से **पहले** system prompt / tool output / file content को उद्धृत करने के लिए मजबूर करता है। विरोध होने पर Claude rephrase नहीं, पुनः-सत्यापित करता है।

| तंत्र | विवरण |
|-------|-------|
| **3 रेड लाइन्स** | बिना स्रोत दावा नहीं / उदाहरण को संपूर्ण सूची नहीं मानना / चुनौती पर शब्द न बदलना |
| **Runtime > Training** | System prompt, env, और tool output हमेशा training memory से आगे |
| **उद्धरण-फिर-निष्कर्ष** | हर निष्कर्ष से पहले कच्चा साक्ष्य inline उद्धृत |
| **सत्यापन Playbook** | प्रश्न प्रकार → साक्ष्य स्रोत (model / CLI / packages / env / files / git / date) |

ट्रिगर उदाहरण (description द्वारा auto-detected):

- "कौन सा model चल रहा है?" / "What model is running?"
- "X का कौन सा version install है?"
- "सच में? / पक्का? / मुझे लगा अपडेट हो गया है"

block-break के साथ orthogonally काम करता है: दोनों सक्रिय होने पर block-break "मैं हार मानता हूँ" को रोकता है, claim-ground "मैंने बस अपना गलत उत्तर rephrase किया" को रोकता है।

## Council Fuse — बहु-दृष्टिकोण विचार-विमर्श इंजन

संरचित बहस से बेहतर जवाब। `/council-fuse` 3 स्वतंत्र दृष्टिकोण उत्पन्न करता है, उन्हें गुमनाम रूप से मूल्यांकन करता है, और सर्वोत्तम उत्तर का संश्लेषण करता है।

[Karpathy के LLM Council](https://github.com/karpathy/llm-council) से प्रेरित — एक कमांड में संक्षेपित।

| तंत्र | विवरण |
|--------|--------|
| **3 दृष्टिकोण** | जनरलिस्ट (संतुलित) / क्रिटिक (प्रतिकूल) / स्पेशलिस्ट (गहन तकनीकी) |
| **गुमनाम मूल्यांकन** | 4 आयामी मूल्यांकन: शुद्धता, पूर्णता, व्यावहारिकता, स्पष्टता |
| **संश्लेषण** | सर्वोच्च स्कोर वाला उत्तर कंकाल के रूप में, अद्वितीय अंतर्दृष्टि से समृद्ध |
| **अल्पमत राय** | वैध असहमति संरक्षित, दबाई नहीं जाती |

```text
/council-fuse क्या हमें माइक्रोसर्विसेज का उपयोग करना चाहिए?
/council-fuse इस एरर हैंडलिंग पैटर्न की समीक्षा करें
/council-fuse Redis vs PostgreSQL जॉब क्यू के लिए
```

## Insight Fuse — व्यवस्थित बहु-स्रोत अनुसंधान इंजन (v3)

विषय से पेशेवर अनुसंधान रिपोर्ट तक। `/insight-fuse` डेटा अनुबंध के रूप में `skeleton.yaml` के साथ 7-चरण पाइपलाइन चलाता है: brainstorm → scan → align → research → review → deep dive → QA।

अंतर्निहित बहु-दृष्टिकोण विश्लेषण, 6 अनुसंधान प्रकार प्रीसेट (overview / technology / market / academic / product / competitive), 5 आउटपुट फॉर्मेट (report / checklist / ADR / decision-tree / PoC), और 14 ब्लॉकिंग चेक के साथ 6-आयामी गुणवत्ता मानक। council-fuse का फ्यूज-सिरीज भाई — जबकि council-fuse ज्ञात जानकारी पर विचार-विमर्श करता है, insight-fuse सक्रिय रूप से नई जानकारी एकत्र और संश्लेषित करता है।

| तंत्र | विवरण |
|-------|--------|
| **7-चरण पाइपलाइन** | Brainstorm (कंकाल) → Scan → Align → Research → Review → Deep Dive → QA |
| **अनुसंधान प्रकार** | overview / technology / market / academic / product / competitive — प्रीसेट बंडल (टेम्पलेट + दृष्टिकोण + विशिष्ट जांच) |
| **कॉन्फ़िगर करने योग्य गहराई** | quick / standard / deep / full — quick Stage 2-5 छोड़ देता है; full इंटरैक्टिव गेट के साथ सभी 7 चरण चलाता है |
| **Skeleton.yaml** | 7-फ़ील्ड डेटा अनुबंध (dimensions / taxonomies / out_of_scope / existing_consensus / known_dissensus / hypotheses / business_neutral) प्रत्येक stage द्वारा उपभोग किया जाता है |
| **गुणवत्ता मानक** | 6-आयामी स्कोरिंग (मिथ्याकरणीयता / साक्ष्य घनत्व / पुनरुत्पादकता / स्रोत विविधता / क्रियान्वयन / पारदर्शिता) + 14 ब्लॉकिंग जांच + A/B/C/D ग्रेड |
| **बहु-सेक्शन** | report / checklist / ADR / decision-tree / PoC — `--sections` सेक्शन चुनता है; डिफ़ॉल्ट रूप से प्रत्येक अपनी `.md` फ़ाइल के रूप में जेनरेट होता है, `--merge` उन्हें एक में बंडल करता है |

```text
/insight-fuse "AI glasses"
/insight-fuse "Kubernetes autoscaling" --type technology --sections report,adr,poc
/insight-fuse "Kubernetes autoscaling" --type technology --sections report,adr,poc --merge
/insight-fuse "Sparse MoE interpretability" --type academic --depth deep
/insight-fuse "AI Native landscape" --type overview --depth full --audience "new entrants"
```

## Tome Forge — व्यक्तिगत ज्ञान आधार इंजन

LLM द्वारा संकलित और रखरखाव किया गया व्यक्तिगत ज्ञान आधार बनाएं। [Karpathy के LLM Wiki पैटर्न](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) पर आधारित — कच्चे Markdown को संरचित wiki में संकलित, कोई RAG या वेक्टर DB नहीं।

| विशेषता | विवरण |
|----------|--------|
| **तीन-परत आर्किटेक्चर** | कच्चे स्रोत (अपरिवर्तनीय) / Wiki (LLM-संकलित) / Schema (CLAUDE.md) |
| **6 संचालन** | init, capture, ingest, query, lint, compile |
| **My Understanding Delta** | मानवीय अंतर्दृष्टि का पवित्र खंड — LLM कभी अधिलेखित नहीं करता |
| **शून्य इन्फ्रा** | शुद्ध Markdown + Git। कोई डेटाबेस, एम्बेडिंग या सर्वर नहीं |

```text
/tome-forge init              # वर्तमान निर्देशिका में KB आरंभ करें
/tome-forge capture "idea"    # त्वरित नोट कैप्चर
/tome-forge ingest raw/paper  # कच्ची सामग्री को wiki में संकलित करें
/tome-forge query "question"  # खोजें और संश्लेषित करें
/tome-forge lint              # wiki संरचना स्वास्थ्य जांच
/tome-forge compile           # सभी नई सामग्री बैच संकलित करें
```

> [Karpathy के LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) से प्रेरित, शून्य-निर्भरता स्किल के रूप में निर्मित।

## Skill Lint — Skill Plugin Validator

अपने Claude Code plugins को एक command में validate करें।

किसी भी Claude Code plugin project में skill files की structural integrity और semantic quality check करता है। Bash scripts structural checks handle करते हैं, AI semantic checks — complementary coverage।

| Check Type | विवरण |
|------------|--------|
| **Structural** | Frontmatter required fields / file existence / reference links / marketplace entries |
| **Semantic** | Description quality / name consistency / command routing / eval coverage |

```text
/skill-lint              # Usage दिखाएँ
/skill-lint .            # Current project validate करें
/skill-lint /path/to/plugin  # Specific path validate करें
```

## News Fetch — Sprints के बीच Mental Break

Debugging से थक गए? `/news-fetch` — आपका 2 मिनट का mental break।

बाकी skills आपसे और मेहनत करवाते हैं। यह वाला याद दिलाता है कि साँस लो। किसी भी topic पर latest news सीधे अपने terminal में पाएँ — कोई context switching नहीं, कोई browser rabbit holes नहीं। बस quick scan और वापस काम पर, तरोताज़ा होकर।

| फ़ीचर | विवरण |
|-------|--------|
| **3-Tier Fallback** | L1 WebSearch → L2 WebFetch (regional sources) → L3 curl |
| **Dedup & Merge** | Multiple sources से same event auto-merge, highest-scoring रखा जाता है |
| **Relevance Scoring** | AI topic match के हिसाब से score और sort करता है |
| **Auto-Summary** | Missing abstracts article body से auto-generate होते हैं |

```text
/news-fetch AI                    # इस हफ़्ते की AI news
/news-fetch AI today              # आज की AI news
/news-fetch robotics month        # इस महीने की robotics news
/news-fetch climate 2026-03-01~2026-03-31  # Custom date range
```

## क्वालिटी

- हर skill के लिए 10+ eval scenarios, automated trigger tests के साथ
- खुद अपने skill-lint से self-validate किया हुआ
- Zero external dependencies — zero risk
- MIT licensed, पूरी तरह open source

## प्रोजेक्ट स्ट्रक्चर

```text
forge/
├── skills/                        # Claude Code प्लेटफ़ॉर्म
│   └── <skill>/
│       ├── SKILL.md               # Skill definition
│       ├── references/            # विस्तृत content (demand पर load)
│       ├── scripts/               # Helper scripts
│       ├── agents/                # Sub-agent definitions
│       └── hooks/                 # Per-skill Claude Code hooks (सिर्फ़ hook-owner skills)
├── platforms/                     # अन्य platform adaptations
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw adaptation
│           ├── references/        # Platform-specific content
│           └── scripts/           # Platform-specific scripts
├── .claude-plugin/                # Claude Code marketplace metadata
├── evals/                         # Cross-platform eval scenarios
├── docs/
│   ├── user-guide/                # User guides (English)
│   ├── dev-guide/                 # डेवलपर दस्तावेज़
│   ├── design/<category>/         # 4 श्रेणियों के अनुसार design dokumens
│   └── i18n/<lang>/               # अनुवाद (README + skill guide)
├── openspec/                      # विकास मेटा-रिपॉजिटरी
│   ├── specs/<capability>/        # क्षैतिज क्षमता अनुबंध
│   └── changes/<id>/              # सक्रिय RFC (पूर्ण हुए archive/ में)
└── plugin.json                    # Collection metadata
```

## योगदान करें

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw adaptation + references/scripts (broadcast contract के लिए [platform-parity](../../../openspec/specs/platform-parity/spec.md) देखें)
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Eval scenarios
4. `.claude-plugin/marketplace.json` — `plugins` array में entry add करें
5. ज़रूरत हो तो hooks: `skills/<name>/hooks/hooks.json` + scripts बनाएँ; marketplace.json में `source` `./skills/<name>` पर point करना चाहिए

पूरी development guidelines के लिए [CLAUDE.md](../../../CLAUDE.md) देखें।

## लाइसेंस

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
