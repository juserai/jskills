# Ralph Boost उपयोगकर्ता गाइड

> 5 मिनट में शुरू करें — अपने AI स्वायत्त विकास लूप को रुकने से बचाएं

---

## इंस्टॉल करें

### Claude Code (अनुशंसित)

```bash
claude plugin add juserai/forge
```

### सार्वभौमिक एक-पंक्ति इंस्टॉलेशन

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **शून्य निर्भरता** — Ralph Boost ralph-claude-code, block-break, या किसी बाहरी सेवा पर निर्भर नहीं है। प्राथमिक पथ (Agent लूप) की शून्य बाहरी निर्भरताएं हैं; फ़ॉलबैक पथ को `jq` या `python` और `claude` CLI की आवश्यकता है।

---

## कमांड

| कमांड | क्या करता है | कब उपयोग करें |
|-------|-------------|---------------|
| `/ralph-boost setup` | अपने प्रोजेक्ट में स्वायत्त लूप शुरू करें | पहली बार सेटअप |
| `/ralph-boost run` | वर्तमान सत्र में स्वायत्त लूप शुरू करें | प्रारंभीकरण के बाद |
| `/ralph-boost status` | वर्तमान लूप स्थिति देखें | प्रगति की निगरानी |
| `/ralph-boost clean` | लूप फ़ाइलें हटाएं | सफ़ाई |

---

## त्वरित शुरुआत

### 1. प्रोजेक्ट प्रारंभ करें

```text
/ralph-boost setup
```

Claude आपका मार्गदर्शन करेगा:
- प्रोजेक्ट नाम का पता लगाना
- कार्य सूची बनाना (fix_plan.md)
- `.ralph-boost/` डायरेक्टरी और सभी कॉन्फ़िगरेशन फ़ाइलें बनाना

### 2. लूप शुरू करें

```text
/ralph-boost run
```

Claude वर्तमान सत्र में सीधे स्वायत्त लूप चलाता है (Agent लूप मोड)। प्रत्येक पुनरावृत्ति एक कार्य निष्पादित करने के लिए एक उप-एजेंट बनाती है, जबकि मुख्य सत्र स्थिति प्रबंधन करने वाले लूप नियंत्रक के रूप में कार्य करता है।

**फ़ॉलबैक** (हेडलेस / अनुपस्थित वातावरण):

```bash
# अग्रभूमि
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# पृष्ठभूमि
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. स्थिति की निगरानी करें

```text
/ralph-boost status
```

उदाहरण आउटपुट:

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

## यह कैसे काम करता है

### स्वायत्त लूप

Ralph Boost दो निष्पादन पथ प्रदान करता है:

**प्राथमिक पथ (Agent लूप)**: Claude वर्तमान सत्र में लूप नियंत्रक के रूप में कार्य करता है, प्रत्येक पुनरावृत्ति में कार्य निष्पादित करने के लिए एक उप-एजेंट बनाता है। मुख्य सत्र स्थिति, circuit breaker और दबाव वृद्धि का प्रबंधन करता है। शून्य बाहरी निर्भरताएं।

**फ़ॉलबैक (bash स्क्रिप्ट)**: `boost-loop.sh` पृष्ठभूमि में एक लूप में `claude -p` कॉल चलाता है। JSON इंजन के रूप में jq और python दोनों का समर्थन करता है, रनटाइम पर स्वचालित रूप से पहचाना जाता है। पुनरावृत्तियों के बीच डिफ़ॉल्ट प्रतीक्षा समय 1 घंटा है (कॉन्फ़िगर करने योग्य)।

दोनों पथ एक ही स्थिति प्रबंधन (state.json), दबाव वृद्धि तर्क और BOOST_STATUS प्रोटोकॉल साझा करते हैं।

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### उन्नत Circuit Breaker (ralph-claude-code की तुलना में)

ralph-claude-code का circuit breaker: बिना प्रगति के 3 लगातार लूप के बाद हार मान लेता है।

ralph-boost का circuit breaker: अटकने पर **क्रमशः दबाव बढ़ाता है**, रुकने से पहले 6-7 लूप तक स्व-पुनर्प्राप्ति।

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

## अपेक्षित आउटपुट उदाहरण

### L0 — सामान्य निष्पादन

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

### L1 — दृष्टिकोण बदलना

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude को पिछला दृष्टिकोण छोड़कर कुछ **मौलिक रूप से भिन्न** प्रयास करने के लिए बाध्य किया जाता है। पैरामीटर समायोजन मान्य नहीं है।

### L2 — खोज और परिकल्पना

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude को करना होगा: त्रुटि को शब्द-दर-शब्द पढ़ना → 50+ पंक्तियों का संदर्भ खोजना → 3 विभिन्न परिकल्पनाएं सूचीबद्ध करना।

### L3 — चेकलिस्ट

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude को 7-बिंदु चेकलिस्ट पूरी करनी होगी (त्रुटि संकेत पढ़ना, मूल समस्या खोजना, स्रोत कोड पढ़ना, धारणाएं सत्यापित करना, विपरीत परिकल्पना, न्यूनतम पुनरुत्पादन, उपकरण/विधियां बदलना)। प्रत्येक पूर्ण आइटम state.json में लिखा जाता है।

### L4 — व्यवस्थित हस्तांतरण

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude एक न्यूनतम PoC बनाता है, फिर एक हस्तांतरण रिपोर्ट तैयार करता है:

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

हस्तांतरण पूर्ण होने के बाद, लूप व्यवस्थित रूप से बंद हो जाता है। यह "मैं नहीं कर सकता" नहीं है — यह "यहां सीमा है।"

---

## कॉन्फ़िगरेशन

`.ralph-boost/config.json`:

| फ़ील्ड | डिफ़ॉल्ट | विवरण |
|--------|---------|--------|
| `max_calls_per_hour` | 100 | प्रति घंटा अधिकतम Claude API कॉल |
| `claude_timeout_minutes` | 15 | प्रति व्यक्तिगत कॉल का टाइमआउट |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claude के लिए उपलब्ध उपकरण |
| `claude_model` | "" | मॉडल ओवरराइड (खाली = डिफ़ॉल्ट) |
| `session_expiry_hours` | 24 | सत्र समाप्ति समय |
| `no_progress_threshold` | 7 | बंद होने से पहले बिना प्रगति की सीमा |
| `same_error_threshold` | 8 | बंद होने से पहले समान त्रुटि की सीमा |
| `sleep_seconds` | 3600 | पुनरावृत्तियों के बीच प्रतीक्षा समय (सेकंड) |

### सामान्य कॉन्फ़िगरेशन समायोजन

**लूप तेज़ करें** (परीक्षण के लिए):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**उपकरण अनुमतियां प्रतिबंधित करें**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**एक विशिष्ट मॉडल का उपयोग करें**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## प्रोजेक्ट डायरेक्टरी संरचना

```
.ralph-boost/
├── PROMPT.md           # विकास निर्देश (block-break प्रोटोकॉल शामिल)
├── fix_plan.md         # कार्य सूची (Claude द्वारा स्वचालित रूप से अपडेट)
├── config.json         # कॉन्फ़िगरेशन
├── state.json          # एकीकृत स्थिति (circuit breaker + दबाव + सत्र)
├── handoff-report.md   # L4 हस्तांतरण रिपोर्ट (व्यवस्थित निकास पर उत्पन्न)
├── logs/
│   ├── boost.log       # लूप लॉग
│   └── claude_output_*.log  # प्रति-पुनरावृत्ति आउटपुट
└── .gitignore          # स्थिति और लॉग को अनदेखा करता है
```

सभी फ़ाइलें `.ralph-boost/` के अंदर रहती हैं — आपकी प्रोजेक्ट रूट डायरेक्टरी कभी नहीं छुई जाती।

---

## ralph-claude-code के साथ संबंध

Ralph Boost [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) का एक **स्वतंत्र प्रतिस्थापन** है, न कि एक एन्हांसमेंट प्लगइन।

| पहलू | ralph-claude-code | ralph-boost |
|-------|-------------------|-------------|
| रूप | स्वतंत्र Bash उपकरण | Claude Code skill (Agent लूप) |
| इंस्टॉल | `npm install` | Claude Code प्लगइन |
| कोड आकार | 2000+ पंक्तियां | ~400 पंक्तियां |
| बाहरी निर्भरताएं | jq (आवश्यक) | प्राथमिक पथ: शून्य; फ़ॉलबैक: jq या python |
| डायरेक्टरी | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | निष्क्रिय (3 लूप के बाद हार मान लेता है) | सक्रिय (L0-L4, 6-7 लूप स्व-पुनर्प्राप्ति) |
| सह-अस्तित्व | हां | हां (शून्य फ़ाइल विवाद) |

दोनों एक ही प्रोजेक्ट में एक साथ इंस्टॉल किए जा सकते हैं — वे अलग-अलग डायरेक्टरी का उपयोग करते हैं और एक-दूसरे में हस्तक्षेप नहीं करते।

---

## Block Break के साथ संबंध

Ralph Boost स्वायत्त लूप परिदृश्यों के लिए Block Break के मूल तंत्र (दबाव वृद्धि, 5-चरण कार्यप्रणाली, चेकलिस्ट) को अनुकूलित करता है:

| पहलू | block-break | ralph-boost |
|-------|-------------|-------------|
| परिदृश्य | इंटरैक्टिव सत्र | स्वायत्त लूप |
| सक्रियण | Hooks स्वचालित रूप से ट्रिगर होते हैं | Agent लूप / लूप स्क्रिप्ट में अंतर्निहित |
| पहचान | PostToolUse hook | Agent लूप प्रगति पहचान / स्क्रिप्ट प्रगति पहचान |
| नियंत्रण | Hook-इंजेक्टेड प्रॉम्प्ट | Agent प्रॉम्प्ट इंजेक्शन / --append-system-prompt |
| स्थिति | `~/.forge/` | `.ralph-boost/state.json` |

कोड पूरी तरह से स्वतंत्र है; अवधारणाएं साझा हैं।

> **संदर्भ**: Block Break की दबाव वृद्धि (L0-L4), 5-चरण कार्यप्रणाली और 7-बिंदु चेकलिस्ट ralph-boost के circuit breaker की वैचारिक नींव बनाती हैं। विवरण के लिए [Block Break उपयोगकर्ता गाइड](block-break-guide.md) देखें।

---

## अक्सर पूछे जाने वाले प्रश्न

### मैं प्राथमिक पथ और फ़ॉलबैक के बीच कैसे चुनूं?

`/ralph-boost run` डिफ़ॉल्ट रूप से Agent लूप (प्राथमिक पथ) का उपयोग करता है, सीधे वर्तमान Claude Code सत्र में चलता है। जब आपको हेडलेस या अनुपस्थित निष्पादन की आवश्यकता हो तो फ़ॉलबैक bash स्क्रिप्ट का उपयोग करें।

### लूप स्क्रिप्ट कहां स्थित है?

forge प्लगइन इंस्टॉल करने के बाद, फ़ॉलबैक स्क्रिप्ट `~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh` पर है। आप इसे कहीं भी कॉपी करके वहां से चला सकते हैं। स्क्रिप्ट स्वचालित रूप से jq या python को अपने JSON इंजन के रूप में पहचानती है।

### मैं लूप लॉग कैसे देखूं?

```bash
tail -f .ralph-boost/logs/boost.log
```

### मैं दबाव स्तर को मैन्युअल रूप से कैसे रीसेट करूं?

`.ralph-boost/state.json` संपादित करें: `pressure.level` को 0 और `circuit_breaker.consecutive_no_progress` को 0 पर सेट करें। या बस state.json हटा दें और पुनः प्रारंभ करें।

### मैं कार्य सूची कैसे संशोधित करूं?

`.ralph-boost/fix_plan.md` को सीधे संपादित करें, `- [ ] कार्य` प्रारूप का उपयोग करें। Claude इसे प्रत्येक पुनरावृत्ति की शुरुआत में पढ़ता है।

### Circuit breaker खुलने के बाद मैं कैसे पुनर्प्राप्त करूं?

`state.json` संपादित करें, `circuit_breaker.state` को `"CLOSED"` पर सेट करें, संबंधित काउंटर रीसेट करें और स्क्रिप्ट पुनः चलाएं।

### क्या मुझे ralph-claude-code की आवश्यकता है?

नहीं। Ralph Boost पूरी तरह से स्वतंत्र है और किसी भी Ralph फ़ाइलों पर निर्भर नहीं है।

### कौन से प्लेटफ़ॉर्म समर्थित हैं?

वर्तमान में Claude Code (प्राथमिक पथ के रूप में Agent लूप) का समर्थन करता है। फ़ॉलबैक bash स्क्रिप्ट को bash 4+, jq या python और claude CLI की आवश्यकता है।

### ralph-boost की skill फ़ाइलों को कैसे मान्य करें?

[Skill Lint](skill-lint-guide.md) का उपयोग करें: `/skill-lint .`

---

## कब उपयोग करें / कब उपयोग न करें

### ✅ इन मामलों में उपयोग करें

- You have a well-defined task and want Claude to loop on it unattended
- Previous autonomous attempts spun forever without progress
- You need a graceful handoff report if the loop can't finish

### ❌ इन मामलों में उपयोग न करें

- Interactive debugging (use `/block-break` directly — lighter weight)
- One-shot tasks (setup/run/clean overhead exceeds benefit)
- Work requiring frequent human checkpoints

> Convergence guarantee के साथ autonomous loop engine — स्पष्ट लक्ष्य और स्थिर environment चाहिए।

पूर्ण सीमा विश्लेषण: [references/scope-boundaries.md](../../../skills/ralph-boost/references/scope-boundaries.md)

---

## लाइसेंस

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
