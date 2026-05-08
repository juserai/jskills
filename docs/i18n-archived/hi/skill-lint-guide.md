# Skill Lint उपयोगकर्ता गाइड

> 3 मिनट में शुरू करें — अपने Claude Code skill की गुणवत्ता को सत्यापित करें

---

## इंस्टॉल करें

### Claude Code (अनुशंसित)

```bash
claude plugin add juserai/forge
```

### यूनिवर्सल वन-लाइन इंस्टॉल

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **शून्य निर्भरताएं** — Skill Lint को किसी बाहरी सेवा या API की आवश्यकता नहीं है। इंस्टॉल करें और शुरू करें।

---

## कमांड

| कमांड | क्या करता है | कब उपयोग करें |
|-------|-------------|---------------|
| `/skill-lint` | उपयोग जानकारी दिखाएं | उपलब्ध जांच देखें |
| `/skill-lint .` | वर्तमान प्रोजेक्ट की जांच करें | विकास के दौरान स्व-जांच |
| `/skill-lint /path/to/plugin` | एक विशिष्ट पथ की जांच करें | किसी अन्य plugin की समीक्षा करें |

---

## उपयोग के मामले

### नया skill बनाने के बाद स्व-जांच

`skills/<name>/SKILL.md`, `commands/<name>.md`, और संबंधित फ़ाइलें बनाने के बाद, `/skill-lint .` चलाएं ताकि यह पुष्टि हो सके कि संरचना पूर्ण है, frontmatter सही है, और marketplace प्रविष्टि जोड़ी गई है।

### किसी और के plugin की समीक्षा करें

PR की समीक्षा या किसी अन्य plugin की ऑडिट करते समय, फ़ाइल पूर्णता और संगतता की त्वरित जांच के लिए `/skill-lint /path/to/plugin` का उपयोग करें।

### CI एकीकरण

`scripts/skill-lint.sh` सीधे CI पाइपलाइन में चल सकता है, स्वचालित पार्सिंग के लिए JSON आउटपुट देता है:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## जांच आइटम

### संरचनात्मक जांच (Bash स्क्रिप्ट द्वारा निष्पादित)

| नियम | क्या जांचा जाता है | गंभीरता |
|------|-------------------|---------|
| S01 | `plugin.json` रूट और `.claude-plugin/` दोनों में मौजूद है | error |
| S02 | `.claude-plugin/marketplace.json` मौजूद है | error |
| S03 | प्रत्येक `skills/<name>/` में एक `SKILL.md` है | error |
| S04 | SKILL.md frontmatter में `name` और `description` शामिल हैं | error |
| S05 | प्रत्येक skill का एक संबंधित `commands/<name>.md` है | warning |
| S06 | प्रत्येक skill marketplace.json `plugins` सरणी में सूचीबद्ध है | warning |
| S07 | SKILL.md में उद्धृत संदर्भ फ़ाइलें वास्तव में मौजूद हैं | error |
| S08 | `evals/<name>/scenarios.md` मौजूद है | warning |

### अर्थपरक जांच (AI द्वारा निष्पादित)

| नियम | क्या जांचा जाता है | गंभीरता |
|------|-------------------|---------|
| M01 | विवरण स्पष्ट रूप से उद्देश्य और ट्रिगर स्थितियों को बताता है | warning |
| M02 | नाम निर्देशिका नाम से मेल खाता है; विवरण फ़ाइलों में संगत है | warning |
| M03 | कमांड रूटिंग लॉजिक skill नाम को सही ढंग से संदर्भित करता है | warning |
| M04 | संदर्भ सामग्री SKILL.md के साथ तार्किक रूप से संगत है | warning |
| M05 | मूल्यांकन परिदृश्य मुख्य कार्यक्षमता पथों को कवर करते हैं (कम से कम 5) | warning |

---

## अपेक्षित आउटपुट उदाहरण

### सभी जांच पास हुईं

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### समस्याएं मिलीं

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## कार्यप्रवाह

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## अक्सर पूछे जाने वाले प्रश्न

### क्या मैं अर्थपरक जांच के बिना केवल संरचनात्मक जांच चला सकता हूं?

हां — bash स्क्रिप्ट को सीधे चलाएं:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

यह बिना AI अर्थपरक विश्लेषण के शुद्ध JSON आउटपुट देता है।

### क्या यह गैर-forge प्रोजेक्ट पर काम करता है?

हां। कोई भी निर्देशिका जो मानक Claude Code plugin संरचना (`skills/`, `commands/`, `.claude-plugin/`) का पालन करती है, सत्यापित की जा सकती है।

### त्रुटियों और चेतावनियों में क्या अंतर है?

- **error**: संरचनात्मक समस्याएं जो skill को सही ढंग से लोड या प्रकाशित होने से रोकेंगी
- **warning**: गुणवत्ता संबंधी समस्याएं जो कार्यक्षमता को नहीं तोड़ेंगी लेकिन रखरखाव और खोज क्षमता को प्रभावित करती हैं

### अन्य forge उपकरण

Skill Lint forge संग्रह का हिस्सा है और इन skills के साथ अच्छी तरह काम करता है:

- [Block Break](block-break-guide.md) — उच्च-क्षमता व्यवहारात्मक बाधा इंजन जो AI को हर दृष्टिकोण को समाप्त करने के लिए मजबूर करता है
- [Ralph Boost](ralph-boost-guide.md) — बिल्ट-इन Block Break अभिसरण गारंटी के साथ स्वायत्त विकास लूप इंजन

नया skill विकसित करने के बाद, संरचनात्मक पूर्णता सत्यापित करने और यह पुष्टि करने के लिए `/skill-lint .` चलाएं कि frontmatter, marketplace.json, और संदर्भ लिंक सभी सही हैं।

---

## कब उपयोग करें / कब उपयोग न करें

### ✅ इन मामलों में उपयोग करें

- Validating a Claude Code plugin's structure before release
- Checking integrity hash / convention compliance / i18n coverage
- As a CI/CD gate for plugin repositories

### ❌ इन मामलों में उपयोग न करें

- Non-plugin projects (rules don't apply; you'll get irrelevant errors)
- Production code quality review (not a linter / type checker / security scanner)
- License legal review (only checks the `license` field exists)

> Claude Code plugin का structural CI — convention compliance और hash consistency guarantee करता है, runtime correctness नहीं।

पूर्ण सीमा विश्लेषण: [references/scope-boundaries.md](../../../skills/skill-lint/references/scope-boundaries.md)

---

## लाइसेंस

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
