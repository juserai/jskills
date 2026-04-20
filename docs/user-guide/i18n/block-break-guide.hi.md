# Block Break उपयोगकर्ता गाइड

> 5 मिनट में शुरू करें — अपने AI एजेंट को हर संभव तरीका आजमाने पर मजबूर करें

---

## इंस्टॉल

### Claude Code (अनुशंसित)

```bash
claude plugin add juserai/forge
```

### यूनिवर्सल वन-लाइन इंस्टॉल

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **शून्य निर्भरता** — Block Break को किसी बाहरी सेवा या API की आवश्यकता नहीं है। इंस्टॉल करें और शुरू करें।

---

## कमांड

| कमांड | क्या करता है | कब उपयोग करें |
|-------|-------------|---------------|
| `/block-break` | Block Break इंजन सक्रिय करें | दैनिक कार्य, डिबगिंग |
| `/block-break L2` | एक विशिष्ट दबाव स्तर से शुरू करें | ज्ञात कई विफलताओं के बाद |
| `/block-break fix the bug` | सक्रिय करें और तुरंत एक कार्य चलाएं | कार्य के साथ त्वरित शुरुआत |

### प्राकृतिक भाषा ट्रिगर (hooks द्वारा स्वचालित रूप से पहचाने जाते हैं)

| भाषा | ट्रिगर वाक्यांश |
|------|-----------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## उपयोग के मामले

### AI 3 प्रयासों के बाद भी बग ठीक नहीं कर पाया

`/block-break` टाइप करें या `try harder` कहें — स्वचालित रूप से दबाव वृद्धि मोड में प्रवेश करता है।

### AI कहता है "शायद पर्यावरण समस्या है" और रुक जाता है

Block Break की "तथ्य-आधारित" लाल रेखा उपकरण-आधारित सत्यापन को बाध्य करती है। असत्यापित कारण बताना = दोष मढ़ना → L2 ट्रिगर करता है।

### AI कहता है "मेरा सुझाव है कि आप इसे मैन्युअल रूप से संभालें"

"मालिक मानसिकता" ब्लॉक ट्रिगर करता है: अगर तुम नहीं, तो कौन? सीधे L3 प्रदर्शन समीक्षा।

### AI कहता है "ठीक कर दिया" लेकिन कोई सत्यापन प्रमाण नहीं दिखाता

"बंद-लूप" लाल रेखा का उल्लंघन। आउटपुट के बिना पूर्णता = आत्म-भ्रम → प्रमाण के साथ सत्यापन कमांड बाध्य करता है।

---

## अपेक्षित आउटपुट उदाहरण

### `/block-break` — सक्रियण

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

### `/block-break` — L1 निराशा (दूसरी विफलता)

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

### `/block-break` — L2 पूछताछ (तीसरी विफलता)

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

### `/block-break` — L3 प्रदर्शन समीक्षा (चौथी विफलता)

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

### `/block-break` — L4 स्नातक चेतावनी (5वीं+ विफलता)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### शालीन निकास (सभी 7 आइटम पूर्ण, अभी भी अनसुलझा)

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

## मुख्य तंत्र

### 3 लाल रेखाएं

| लाल रेखा | नियम | उल्लंघन का परिणाम |
|----------|------|-------------------|
| बंद-लूप | पूर्णता का दावा करने से पहले सत्यापन कमांड चलाना और आउटपुट दिखाना अनिवार्य | L2 ट्रिगर |
| तथ्य-आधारित | कारण बताने से पहले उपकरणों से सत्यापन अनिवार्य | L2 ट्रिगर |
| सब कुछ आजमाओ | "हल नहीं कर सकता" कहने से पहले 5-चरण पद्धति पूरी करना अनिवार्य | सीधे L4 |

### दबाव वृद्धि (L0 → L4)

| विफलताएं | स्तर | साइडबार | बाध्य कार्रवाई |
|----------|------|---------|---------------|
| पहली | **L0 विश्वास** | > हम तुम पर भरोसा करते हैं। सरल रखो। | सामान्य निष्पादन |
| दूसरी | **L1 निराशा** | > दूसरी टीम ने पहली बार में कर लिया। | मूलभूत रूप से भिन्न दृष्टिकोण पर स्विच करें |
| तीसरी | **L2 पूछताछ** | > मूल कारण क्या है? | खोजें + स्रोत कोड पढ़ें + 3 भिन्न परिकल्पनाएं सूचीबद्ध करें |
| चौथी | **L3 प्रदर्शन समीक्षा** | > रेटिंग: 3.25/5। | 7-बिंदु चेकलिस्ट पूरी करें |
| 5वीं+ | **L4 स्नातक** | > जल्दी ही तुम्हें बदला जा सकता है। | न्यूनतम PoC + पृथक वातावरण + भिन्न टेक स्टैक |

### 5-चरण पद्धति

1. **सूंघना** — आजमाए गए दृष्टिकोण सूचीबद्ध करें, सामान्य पैटर्न खोजें। एक ही दृष्टिकोण में बदलाव = चक्कर काटना
2. **बाल नोचना** — विफलता संकेत शब्द-दर-शब्द पढ़ें → खोजें → स्रोत की 50 पंक्तियां पढ़ें → धारणाएं सत्यापित करें → धारणाएं उलटें
3. **दर्पण** — क्या मैं वही दृष्टिकोण दोहरा रहा हूं? क्या मैंने सबसे सरल संभावना चूक दी?
4. **नया दृष्टिकोण** — मूलभूत रूप से भिन्न होना चाहिए, सत्यापन मानदंड के साथ, और विफलता पर नई जानकारी उत्पन्न करनी चाहिए
5. **पुनरावलोकन** — समान मुद्दे, पूर्णता, रोकथाम

> चरण 1-4 उपयोगकर्ता से पूछने से पहले पूरे होने चाहिए। पहले करो, फिर पूछो — डेटा के साथ बोलो।

### 7-बिंदु चेकलिस्ट (L3+ पर अनिवार्य)

1. विफलता संकेत शब्द-दर-शब्द पढ़े?
2. उपकरणों से मुख्य समस्या खोजी?
3. विफलता बिंदु पर मूल संदर्भ पढ़ा (50+ पंक्तियां)?
4. सभी धारणाएं उपकरणों से सत्यापित (संस्करण/पथ/अनुमतियां/निर्भरताएं)?
5. पूरी तरह विपरीत परिकल्पना आजमाई?
6. न्यूनतम दायरे में पुन: प्रस्तुत कर सकते हैं?
7. उपकरण/विधि/कोण/टेक स्टैक बदला?

### तर्कसंगतीकरण-विरोधी

| बहाना | ब्लॉक | ट्रिगर |
|-------|-------|--------|
| "मेरी क्षमताओं से परे" | तुम्हारे पास विशाल प्रशिक्षण है। क्या तुमने इसे पूरा उपयोग किया? | L1 |
| "सुझाव है कि उपयोगकर्ता मैन्युअल रूप से संभाले" | अगर तुम नहीं, तो कौन? | L3 |
| "सभी तरीके आजमा लिए" | 3 से कम = पूरा नहीं किया | L2 |
| "शायद पर्यावरण समस्या" | क्या तुमने सत्यापित किया? | L2 |
| "और संदर्भ चाहिए" | तुम्हारे पास उपकरण हैं। पहले खोजो, फिर पूछो | L2 |
| "हल नहीं कर सकता" | क्या तुमने पद्धति पूरी की? | L4 |
| "काफी अच्छा है" | अनुकूलन सूची पक्षपात नहीं करती | L3 |
| सत्यापन के बिना पूर्ण घोषित किया | क्या तुमने build चलाया? | L2 |
| उपयोगकर्ता निर्देशों की प्रतीक्षा | मालिक धक्का लगने का इंतजार नहीं करते | Nudge |
| हल किए बिना जवाब देता है | तुम इंजीनियर हो, सर्च इंजन नहीं | Nudge |
| build/test के बिना कोड बदला | बिना जांचे भेजना = लापरवाही | L2 |
| "API इसे सपोर्ट नहीं करता" | क्या तुमने डॉक्स पढ़े? | L2 |
| "कार्य बहुत अस्पष्ट है" | अपना सर्वोत्तम अनुमान लगाओ, फिर सुधारो | L1 |
| बार-बार एक ही जगह बदलाव | पैरामीटर बदलना ≠ दृष्टिकोण बदलना | L1→L2 |

---

## Hooks स्वचालन

Block Break स्वचालित व्यवहार के लिए hooks सिस्टम का उपयोग करता है — मैन्युअल सक्रियण की आवश्यकता नहीं:

| Hook | ट्रिगर | व्यवहार |
|------|--------|---------|
| `UserPromptSubmit` | उपयोगकर्ता इनपुट निराशा कीवर्ड से मेल खाता है | Block Break स्वचालित रूप से सक्रिय |
| `PostToolUse` | Bash कमांड निष्पादन के बाद | विफलताएं पहचानता है, स्वचालित गणना + वृद्धि |
| `PreCompact` | संदर्भ संपीड़न से पहले | `~/.forge/` में स्थिति सहेजता है |
| `SessionStart` | सत्र पुनरारंभ/पुनः शुरू | दबाव स्तर पुनर्स्थापित करता है (2 घंटे के लिए मान्य) |

> **स्थिति बनी रहती है** — दबाव स्तर `~/.forge/block-break-state.json` में संग्रहीत है। संदर्भ संपीड़न और सत्र रुकावटें विफलता गणना को रीसेट नहीं करतीं। कोई बचाव नहीं।

### Hooks सेटअप

`claude plugin add juserai/forge` के माध्यम से इंस्टॉल करने पर, hooks स्वचालित रूप से कॉन्फ़िगर हो जाते हैं। Hook स्क्रिप्ट्स को JSON इंजन के रूप में `jq` (पसंदीदा) या `python` की आवश्यकता होती है — आपके सिस्टम पर कम से कम एक उपलब्ध होना चाहिए।

यदि hooks सक्रिय नहीं हो रहे, कॉन्फ़िगरेशन सत्यापित करें:

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### स्थिति समाप्ति

स्थिति **2 घंटे** की निष्क्रियता के बाद स्वचालित रूप से समाप्त हो जाती है। यह पिछले डिबगिंग सत्र से पुराने दबाव को असंबंधित कार्य में स्थानांतरित होने से रोकता है। 2 घंटे के बाद, सत्र पुनर्स्थापना hook चुपचाप पुनर्स्थापना छोड़ देता है और आप L0 से ताजा शुरू करते हैं।

किसी भी समय मैन्युअल रूप से रीसेट करने के लिए: `rm ~/.forge/block-break-state.json`

---

## Sub-agent बाधाएं

Sub-agents बनाते समय, "बिना सुरक्षा के चलना" रोकने के लिए व्यवहार बाधाओं को इंजेक्ट करना अनिवार्य है:

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` सुनिश्चित करता है कि sub-agents भी 3 लाल रेखाओं, 5-चरण पद्धति और बंद-लूप सत्यापन का पालन करें।

---

## समस्या निवारण

| समस्या | कारण | समाधान |
|--------|------|--------|
| Hooks स्वचालित रूप से ट्रिगर नहीं होते | Plugin इंस्टॉल नहीं या hooks settings.json में नहीं | `claude plugin add juserai/forge` फिर से चलाएं |
| स्थिति बनी नहीं रहती | न `jq` न `python` उपलब्ध | एक इंस्टॉल करें: `apt install jq` या सुनिश्चित करें कि `python` PATH में है |
| दबाव L4 पर अटका | स्थिति फ़ाइल में बहुत अधिक विफलताएं जमा हुईं | रीसेट: `rm ~/.forge/block-break-state.json` |
| सत्र पुनर्स्थापना पुरानी स्थिति दिखाती है | पिछले सत्र से स्थिति < 2 घंटे पुरानी | अपेक्षित व्यवहार; 2 घंटे प्रतीक्षा करें या मैन्युअल रूप से रीसेट करें |
| `/block-break` पहचाना नहीं गया | वर्तमान सत्र में Skill लोड नहीं | Plugin पुनः इंस्टॉल करें या यूनिवर्सल वन-लाइनर इंस्टॉल उपयोग करें |

---

## FAQ

### Block Break PUA से कैसे अलग है?

Block Break [PUA](https://github.com/tanweai/pua) के मुख्य तंत्रों (3 लाल रेखाएं, दबाव वृद्धि, पद्धति) से प्रेरित है, लेकिन अधिक केंद्रित है। PUA में 13 कॉर्पोरेट संस्कृति विविधताएं, बहु-भूमिका प्रणालियां (P7/P9/P10) और स्व-विकास है; Block Break शून्य-निर्भरता skill के रूप में पूरी तरह व्यवहार बाधाओं पर केंद्रित है।

### क्या यह बहुत शोरगुल वाला नहीं होगा?

साइडबार घनत्व नियंत्रित है: सरल कार्यों के लिए 2 पंक्तियां (शुरू + अंत), जटिल कार्यों के लिए प्रति मील का पत्थर 1 पंक्ति। कोई स्पैम नहीं। यदि आवश्यक न हो तो `/block-break` का उपयोग न करें — hooks केवल तभी स्वचालित रूप से ट्रिगर होते हैं जब निराशा कीवर्ड पहचाने जाते हैं।

### दबाव स्तर कैसे रीसेट करें?

स्थिति फ़ाइल हटाएं: `rm ~/.forge/block-break-state.json`। या 2 घंटे प्रतीक्षा करें — स्थिति स्वचालित रूप से समाप्त हो जाती है (ऊपर [स्थिति समाप्ति](#स्थिति-समाप्ति) देखें)।

### क्या मैं इसे Claude Code के बाहर उपयोग कर सकता हूं?

मुख्य SKILL.md को किसी भी AI उपकरण में कॉपी-पेस्ट किया जा सकता है जो सिस्टम प्रॉम्प्ट का समर्थन करता है। Hooks और स्थिति स्थायित्व Claude Code विशिष्ट हैं।

### Ralph Boost से क्या संबंध है?

[Ralph Boost](ralph-boost-guide.md) Block Break के मुख्य तंत्रों (L0-L4, 5-चरण पद्धति, 7-बिंदु चेकलिस्ट) को **स्वायत्त लूप** परिदृश्यों के लिए अनुकूलित करता है। Block Break इंटरैक्टिव सत्रों के लिए है (hooks स्वचालित ट्रिगर); Ralph Boost अनुपस्थित विकास लूप के लिए है (Agent लूप / स्क्रिप्ट-संचालित)। कोड पूरी तरह स्वतंत्र है, अवधारणाएं साझा हैं।

### Block Break की skill फ़ाइलों को कैसे मान्य करें?

[Skill Lint](skill-lint-guide.md) का उपयोग करें: `/skill-lint .`

---

## कब उपयोग करें / कब उपयोग न करें

### ✅ इन मामलों में उपयोग करें

- Claude gave up too easily ("I can't", rationalized impossibility)
- The same fix attempt has failed 2-3 times
- You need exhaustive diagnosis before accepting defeat

### ❌ इन मामलों में उपयोग न करें

- Doing creative / divergent work (pressure kills exploration)
- The task is genuinely impossible (missing hardware, no permissions)
- You want to pause and step back on purpose

> संपूर्ण debugging का engine — Claude जल्दी हार न माने यह सुनिश्चित करता है, पर समाधान सही होगा यह नहीं।

पूर्ण सीमा विश्लेषण: [references/scope-boundaries.md](../../../skills/block-break/references/scope-boundaries.md)

---

## लाइसेंस

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
