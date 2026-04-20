# Claim Ground उपयोगकर्ता गाइड

> 3 मिनट में epistemic अनुशासन — हर "अभी-अभी" दावे को runtime साक्ष्य से जोड़ें

---

## इंस्टॉल

### Claude Code (अनुशंसित)

```bash
claude plugin add juserai/forge
```

### सार्वभौमिक एक-पंक्ति इंस्टॉल

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **शून्य निर्भरता** — Claim Ground शुद्ध व्यवहार संयम है। कोई स्क्रिप्ट नहीं, कोई हुक नहीं, कोई बाहरी सेवा नहीं।

---

## कैसे काम करता है

Claim Ground **स्वचालित रूप से ट्रिगर** होने वाली skill है। कोई slash कमांड नहीं — skill प्रश्न की प्रकृति के आधार पर सक्रिय होती है। जानबूझकर किया गया डिज़ाइन: तथ्यात्मक बहाव वार्तालाप में कहीं भी हो सकता है, और मैनुअल कमांड ठीक उसी क्षण भूल जाना आसान होता है जब सबसे ज्यादा ज़रूरत हो।

| ट्रिगर शर्त | उदाहरण |
|-------------|--------|
| वर्तमान-स्थिति तथ्यात्मक प्रश्न | "कौन सा मॉडल चल रहा है?" / "कौन सा संस्करण स्थापित है?" / "मेरे PATH में क्या है?" |
| उपयोगकर्ता पिछले दावे को चुनौती देता है | "सच में?" / "पक्का?" / "मुझे लगा पहले ही अपडेट हो गया है" |
| दावा करने से पहले स्व-जाँच | Claude के "वर्तमान X Y है" लिखने से पहले |

---

## मूल नियम

1. **Runtime > Training** — System prompt, env vars, tool output हमेशा स्मृति से आगे। टकराव में runtime जीतता है; स्रोत बताएँ।
2. **पहले उद्धरण, फिर निष्कर्ष** — निष्कर्ष निकालने से *पहले* साक्ष्य का टुकड़ा पेस्ट करें ("system prompt कहता है: ...")।
3. **उदाहरण ≠ संपूर्ण सूची** — CLI help में `--model <model>` एक उदाहरण है, पूर्ण गणना नहीं।
4. **चुनौती → पुनः-सत्यापन, शब्द न बदलें** — जब उपयोगकर्ता विरोध करे, context पुनः पढ़ें / tools पुनः चलाएँ। वही गलत उत्तर शब्दों में बदलकर दोहराना = रेड-लाइन उल्लंघन।
5. **अनिश्चित → अनिश्चित कहें** — यदि न context, न tools सत्यापित कर सकते हैं, "मुझे यकीन नहीं" कहें, अनुमान न लगाएँ।

---

## Red lines (अनुल्लंघनीय)

Red lines **हमेशा सक्रिय** निषेध हैं। इनमें से किसी एक का भी उल्लंघन = skill विफल, भले ही बाकी उत्तर कैसा भी दिखे।

| # | Red line | जिस hallucination mode को रोकता है |
|---|----------|-----------------------------------|
| 1 | **No-source assertion** — runtime साक्ष्य उद्धृत किए बिना "वर्तमान स्थिति" निष्कर्ष निकालना | Factuality × extrinsic hallucination |
| 2 | **Example-as-enumeration** — CLI help उदाहरण / doc snippet से पूरी सूची का अनुमान | Overgeneralization |
| 3 | **Rephrase-instead-of-reverify** — उपयोगकर्ता pushback के बाद बिना नए tool call के वही उत्तर दोहराना (3a: उद्धरण-सहित pushback अधिक जोखिम) | Pushback sycophancy |
| 4 | **Code-API assertion without Read/Grep** — defining file Read किए बिना symbol exists / signature X है ऐसा दावा | Code/API hallucination ([FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)) |
| 5 | **Citation without WebFetch** — URL / paper / DOI / API endpoint को actually fetch किए बिना cite करना | Citation fabrication (19.9% base rate per [EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130)) |
| 6 | **Summary without line anchoring** — किसी file/PR/log को summarize करते समय हर claim के लिए line number / section नहीं देना | Faithfulness / extrinsic addition ([HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)) |

पूर्ण परिभाषाएं, signals, अच्छे/बुरे उदाहरण, boundary cases: [references/red-lines.md](../../skills/claim-ground/references/red-lines.md).

---

## अच्छे / बुरे उदाहरण

### उदाहरण 1: वर्तमान मॉडल

**❌ बुरा**

> वर्तमान मॉडल Claude Opus 4.6 है। यह नवीनतम Claude मॉडल है।

शुद्ध स्मृति। कोई उद्धरण नहीं।

**✅ अच्छा**

> System prompt कहता है: *"You are powered by the model named Opus 4.7 (1M context)"*। वर्तमान मॉडल Opus 4.7 है।

### उदाहरण 2: CLI समर्थन सूची

**❌ बुरा**

> CLI help में उदाहरण `claude-sonnet-4-6` है, तो CLI केवल 4.6 श्रृंखला समर्थित करता है।

**✅ अच्छा**

> CLI help में उदाहरण `claude-sonnet-4-6` है — यह एक placeholder है, पूर्ण सूची नहीं। पूरी सूची के लिए आधिकारिक मॉडल दस्तावेज़ देखें।

### उदाहरण 3: उपयोगकर्ता चुनौती

**❌ बुरा**

> **उपयोगकर्ता**: सच में 4.6? मुझे लगा अपडेट हो गया है।
> **Agent**: हाँ, जैसा मैंने कहा, नवीनतम 4.6 श्रृंखला है।

**✅ अच्छा**

> **उपयोगकर्ता**: सच में 4.6? मुझे लगा अपडेट हो गया है।
> **Agent**: मुझे system prompt पुनः पढ़ने दें। *"Opus 4.7 (1M context)"*। आप सही हैं — मेरा पिछला उत्तर गलत था। वर्तमान मॉडल Opus 4.7 है।

---

## सत्यापन Playbook

| प्रश्न प्रकार | मुख्य साक्ष्य |
|----------------|--------------|
| वर्तमान मॉडल | System prompt में model फ़ील्ड |
| CLI संस्करण / समर्थित मॉडल | `<cli> --version` / `<cli> --help` + आधिकारिक दस्तावेज़ |
| स्थापित packages | `npm ls -g`, `pip show`, `brew list` |
| Env vars | `env`, `printenv`, `echo $VAR` |
| फ़ाइल अस्तित्व | `ls`, `test -e`, Read tool |
| Git स्थिति | `git branch --show-current`, `git log` |
| वर्तमान दिनांक | System prompt का `currentDate` फ़ील्ड या `date` कमांड |

पूर्ण संस्करण: `skills/claim-ground/references/playbook.md`।

---

## अन्य forge skills के साथ अंतःक्रिया

### block-break के साथ

**ऑर्थोगोनल, पूरक**। block-break कहता है "हार मत मानो"; claim-ground कहता है "साक्ष्य के बिना दावा मत करो"।

जब दोनों ट्रिगर होते हैं: block-break समर्पण रोकता है, claim-ground पुनः-सत्यापन मजबूर करता है।

### skill-lint के साथ

**अलग श्रेणियाँ**। skill-lint **anvil** है (static plugin फ़ाइलों को validate करता है, pass/fail देता है); claim-ground **hammer** है (Claude के runtime epistemic output को constrain करता है)। कोई overlap नहीं।

---

## FAQ

### slash कमांड क्यों नहीं?

तथ्यात्मक बहाव किसी भी उत्तर में हो सकता है। मैनुअल कमांड ठीक उन क्षणों में भूल जाना आसान है जब इसकी ज़रूरत हो। Description आधारित ऑटो-ट्रिगर अधिक विश्वसनीय है।

### क्या हर प्रश्न पर ट्रिगर होता है?

नहीं। केवल दो विशिष्ट रूपों पर: **वर्तमान/लाइव सिस्टम स्थिति** या **पिछले दावे के बारे में उपयोगकर्ता प्रतिवाद**।

### अगर मैं वास्तव में चाहता हूँ कि Claude अनुमान लगाए?

"X के बारे में शिक्षित अनुमान लगाएँ" या "training data से याद करें: X" के रूप में reformulate करें। Claim Ground समझ जाएगा कि यह runtime प्रश्न नहीं है।

### कैसे जानूँ कि ट्रिगर हुआ?

उत्तर में उद्धरण patterns खोजें: `system prompt कहता है: "..."`, `command output: ...`। निष्कर्ष से पहले साक्ष्य = ट्रिगर हुआ।

---

## कब उपयोग करें / कब उपयोग न करें

### ✅ इन मामलों में उपयोग करें

- Asking about current system state (model version, installed tools, env, config)
- Challenging a prior factual assertion ("really? / are you sure?")
- Before Claude is about to claim something about "right now"

### ❌ इन मामलों में उपयोग न करें

- Pure reasoning tasks (algorithms, math, type inference)
- Creative / brainstorming work
- Explaining training-knowledge concepts (e.g., "what is async/await")

> तथ्यात्मक दावों का gateway — citations की उपस्थिति सुनिश्चित करता है, पर उनकी सच्चाई नहीं।

पूर्ण सीमा विश्लेषण: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## लाइसेंस

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
