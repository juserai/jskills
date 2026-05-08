# Peer Fuse v0.1.0 मार्गदर्शिका

> अनुसंधान कलाकृतियों के लिए सामान्य peer-reviewer — **8-चरण पाइपलाइन (Stage 7 KB संग्रहण अनिवार्य + observable, `--no-save` के माध्यम से opt-out) + 10-फॉर्मेट इनपुट adapter (md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html, 3-स्तरीय dispatch) + 6 अनुसंधान-प्रकार प्रीसेट (auto-classified) + 8-आयामी weighted rubric + 18-flag taxonomy + 3-दृष्टिकोण panel + § Document Reading freeze (review-isolation hard constraint)**।

Peer-Fuse किसी भी markdown / PDF / Office दस्तावेज़ को लेता है और A+/A−/.../D ग्रेड, गुणवत्ता flags की tiered सूची, बहु-दृष्टिकोण panel synthesis, और patch-style diff सुझावों के साथ एक peer-review markdown रिपोर्ट तैयार करता है। यह [insight-fuse Stage 6.5 reviewer](insight-fuse-guide.md) के साथ सह-अस्तित्व में रहता है — Stage 6.5 IF-internal समान-स्रोत समीक्षा है; peer-fuse **cross-skill external reviewer** है जो उन फॉर्मेट और skills को संभालता है जिन्हें Stage 6.5 नहीं संभाल सकता।

## त्वरित प्रारंभ

```bash
# प्रकार auto-classify, default depth, KB में संग्रहित करें
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# PDF अकादमिक पेपर (प्रकार arXiv/IEEE/Nature header से auto-detect)
/peer-fuse papers/transformer-2017.pdf

# स्पष्ट प्रकार के साथ PPTX deck
/peer-fuse decks/q4-roadmap.pptx --type product

# Quick depth (Stage 4 panel + Stage 5.5 holistic skip करें) + KB संग्रह skip करें
/peer-fuse handbook.docx --depth quick --no-save

# सहायता दिखाएँ
/peer-fuse help
# या no-args
/peer-fuse
```

## Defaults & flags

| Flag | Default | मान |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | flag — Stage 7 KB संग्रह skip करता है, केवल console output |

`--type=auto` peer-fuse को heuristics के माध्यम से दस्तावेज़ पढ़ने के बाद वर्गीकृत करने देता है (frontmatter type field → section pattern → citation density → format/title hints → fallback overview)। प्राथमिकता श्रृंखला के लिए [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) देखें।

## समर्थित फॉर्मेट

| Tier | Tool requirement | Formats |
|:-:|---|---|
| 1 | none (native) | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice` (+ `pandoc` for `.doc`) | `.doc`, `.ppt`, `.pptx`, `.odp` |

Tool अनुपस्थित → ठोस install संकेत (`brew install pandoc`, `apt install libreoffice`, आदि) के साथ fail-soft और Stage 1 से पहले exit। देखें [skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md)।

## आपको क्या मिलता है

दो समानांतर deliverables:

1. **Inline rendered review** आपकी बातचीत में, इस संरचना के साथ:
   - § Document Reading — descriptive narrative (दस्तावेज़ क्या कहता है), 3-5 paragraphs, 300-600 शब्द
   - § Holistic Assessment — evaluative narrative (methodology / strengths / concerns / recommendation), 4 paragraphs, 400-700 शब्द
   - § Score Matrix — 8-dim weighted scores → letter grade
   - § Flag List — 18-taxonomy से flag codes स्थानों के साथ
   - § Multi-Perspective Panel — methodologist / adversarial / practitioner verdicts
   - § Diff Suggestions — प्रत्येक demerit के लिए patch-style rewrites
   - § Reconciliation — target self-grade बनाम review_grade Δ

2. **KB archive** `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md` पर (`--no-save` के साथ skip)। Archive log line `Archived to KB: <path>` हमेशा user-visible response में दिखाई देती है।

## Hard constraint: § Document Reading review-isolated है

peer-fuse में सबसे महत्वपूर्ण architectural निर्णय:

**§ Document Reading को review verdicts द्वारा प्रदूषित नहीं किया जाना चाहिए।** यह दस्तावेज़ का reviewer का विश्वसनीय, descriptive reading है — frontmatter, structure, claims, evidence, scope। यह Stage 3.5 पर चलता है, Stage 4 panel और Stage 5 scoring **से पहले**, और input boundary सख्त है:

- ✅ स्वीकार करता है: मूल दस्तावेज़, Stage 1-3 तथ्यात्मक scan results
- ❌ अस्वीकार करता है: panel verdicts, scores, flag hits

यह section Stage 3.5 के बाद **frozen** है: Stage 4 से पहले SHA-256 hash लिया जाता है, और Stage 7 archive से पहले hash सत्यापित करता है। कोई भी संशोधन → fail-closed। Lint भी इस section से evaluative शब्दावली (`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`) और letter-grade literals को निषिद्ध करता है।

यह user-stated hard constraint है और तीन स्तरों पर लागू किया जाता है: architectural isolation + write-once freeze + forbidden-word lint।

## अन्य forge skills के साथ अंतःक्रिया

| Skill | संबंध |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | सह-अस्तित्व — Stage 6.5 IF-internal समान-स्रोत समीक्षा है (समान rubric, समान heuristics, केवल IF markdown)। peer-fuse व्यापक 8-dim rubric, 18 flags, 10 formats, 3-agent panel के साथ **cross-skill external review** है। महत्वपूर्ण IF रिपोर्ट के लिए दोनों चलने चाहिए। |
| **council-fuse** | Sibling crucible — peer-fuse council-fuse के parallel sub-agent dispatch pattern का पुनः उपयोग करता है (Stage 4 panel council-fuse Stage 1 को mirror करता है)। |
| **tome-forge** | Archive backend — peer-fuse Stage 7 tome-forge के report-archival-protocol को कॉल करता है; KB write logic को पुनः कार्यान्वित नहीं करता। |
| **skill-lint** | Sibling-by-pattern (अलग category, anvil) — दोनों कलाकृतियों का मूल्यांकन करते हैं और diagnostics उत्पन्न करते हैं, लेकिन skill-lint ephemeral console diagnostic output करता है जबकि peer-fuse persistent markdown peer-review कलाकृति output करता है। |

## peer-fuse बनाम IF Stage 6.5 कब उपयोग करें

| परिदृश्य | उपयोग करें |
|---|:-:|
| आपने अभी `/insight-fuse <topic>` चलाया है और IF रिपोर्ट पर दूसरी राय चाहते हैं | IF Stage 6.5 पहले से inline चला है; यदि आप cross-format readiness के साथ second-layer external review चाहते हैं, तो `/peer-fuse <if-output-path>` चलाएँ |
| आपके पास मूल्यांकन के लिए third-party PDF अनुसंधान पेपर है | peer-fuse |
| आपके पास PPTX business deck है जिसे आप ग्रेड कराना चाहते हैं | peer-fuse |
| आपके पास council-fuse synthesis output है जिसे आप ग्रेड कराना चाहते हैं | peer-fuse |
| आप समान rubric पर कई कलाकृतियों की तुलना करना चाहते हैं | peer-fuse (कलाकृतियों के बीच लगातार scoring) |

## ठोस उदाहरण

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 detection
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 § Document Reading उत्पन्न करता है (frozen)
# Stage 4 panel 3 sub-agents समानांतर में चलाता है
# Stage 5 scoring → 8.6 / A-
# Stage 5.5 holistic assessment
# Stage 6 diff suggestions: 5 blocks
# Stage 7 archive

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

Console पूर्ण review inline render करता है; KB archive persistent canonical संस्करण है।

## सत्यापन

```bash
# Static check
bash skills/skill-lint/scripts/skill-lint.sh .

# Trigger test
bash evals/peer-fuse/run-trigger-test.sh

# Hash lockstep
bash scripts/recalc-all-hashes.sh
```

## यह भी देखें

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — runtime skill परिभाषा
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — architectural निर्णय + 4-category rationale
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC (merge के बाद)
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — sibling crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — sibling crucible (panel pattern source)
