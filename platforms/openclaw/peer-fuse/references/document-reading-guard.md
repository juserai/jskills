# § Document Reading Review-Isolation Guard

**用户硬约束**："自成章节，不要让评审结果影响原文档的解读内容"。

本文件**集中**记录三层防御实现——架构隔离 / 写后冻结 / 禁词 lint。Stage 3.5 / 5.5 / 7 各自的实现细节散落在 [SKILL.md § Stage 3.5/5.5/7](../SKILL.md) 与 [templates/document-reading.md](../templates/document-reading.md) / [templates/holistic-assessment.md](../templates/holistic-assessment.md)；本文件作为**纵向汇总**，便于审计与未来回归测试。

## 第一层：架构隔离

Stage 3.5 § Document Reading 的**输入边界**严格管控：

| 输入类型 | 是否允许 | 说明 |
|---|:-:|---|
| 原文档 `source_view` / `canonical_view` | ✅ | reviewer 必须读 |
| Stage 1 结构审事实结果（"frontmatter 缺失"、"章节齐备"、"H1/H2/H3 hierarchy 1-2-3"）| ✅ | 中性数据 |
| Stage 2 证据审事实结果（"引用密度 = 3.2/section"、"L1 比例 = 0.6"）| ✅ | 中性数据 |
| Stage 3 逻辑审事实结果（FIR 标签出现位置 / OOS 关键词列表 / 单源 claim 列表）| ✅ | 中性数据 |
| Stage 4 panel `KEY_FINDINGS` / `FLAGS_RAISED` / `VERDICT_SUMMARY` | ❌ | 评价已成形 |
| Stage 5 任何分项分数 / 加权总分 / 字母 grade | ❌ | 评价已成形 |
| Stage 5 / 6 命中的 flag code（F-EVD-NN 等）| ❌ | 评价已成形 |
| Stage 5.5 § Holistic Assessment 任何内容 | ❌ | 评价已成形 |
| Stage 6 Diff Suggestions 任何内容 | ❌ | 评价已成形 |

**关键判别准则**：**事实**（"frontmatter 缺失"）vs **评价**（"frontmatter 不完整"）。前者描述事实可入；后者已含评价倾向不可入。

**实现位置**：[SKILL.md § Stage 3.5](../SKILL.md) "输入边界" 节（MUST 严格枚举）。

## 第二层：写后冻结

Stage 3.5 完成后立即冻结：

1. **快照**：Stage 3.5 输出节字节级 SHA-256 哈希存入主线程内存
2. **保护期**：Stage 4 / 5 / 5.5 / 6 期间 § Document Reading 节 read-only
3. **校验**：Stage 7 归档前重新计算哈希
4. **判决**：
   - 哈希一致 → 归档继续
   - 哈希不一致 → fail-closed：`Archive: blocked (Document Reading modified post-Stage 3.5)`，**不写文件**

**实现位置**：[SKILL.md § Stage 3.5 写后冻结](../SKILL.md) + [SKILL.md § Stage 7 归档前 hash 校验](../SKILL.md)。

## 第三层：禁词 lint

§ Document Reading 节内**禁止出现**：

### 评价性词汇

中文禁词：`优点 / 缺点 / 不足 / 薄弱 / 错误 / 应当改 / 建议 / 强 / 弱 / 问题 / 缺陷`
英文禁词：`grade / score / flag / strong / weak(ness) / concern / issue / problem / shortcoming / fail / violate / better / worse`

### Flag code 字面量

任何匹配 `F-[A-Z]+-\d+` 的字符串。具体覆盖 11 个 category：`F-EVD-NN / F-STAT-NN / F-LOGIC-NN / F-SCOPE-NN / F-COST-NN / F-METHOD-NN / F-DISAGREE-NN / F-CONSTRUCT-NN / F-CITE-NN / F-CONF-NN / F-DELTA-NN`。

### 字母 grade 字面量

`A+ / A / A− / A- / B+ / B / B− / B- / C+ / C / C− / C- / D` 在评分语境下不允许（exception：纯引用原文档标题如 "Section A" 不算）。

### 评价节引用

不得出现这些字符串作为节引用：
- `§ Score Matrix`
- `§ Flag List`
- `§ Multi-Perspective Panel`
- `§ Diff Suggestions`
- `§ Holistic Assessment`
- 缩写形式如 "the score matrix"、"as flagged"

**实现位置**：[evals/peer-fuse/run-trigger-test.sh § Phase H](../../evals/peer-fuse/run-trigger-test.sh) 在每次审查输出后扫描；可选迁移到 skill-lint 自定义规则。

## 三层防御缺一不可

- **架构防错**（第一层）：防的是工程错误（管道写错，把 panel verdict 灌进 Stage 3.5）
- **冻结防漂**（第二层）：防的是 LLM 幻觉/工具误用（Stage 5.5 主线程"顺手改一下"§ Document Reading）
- **禁词防污**（第三层）：防的是语言污染（即使没改章节内容，措辞含 "concerning" 这种隐蔽评价也会污染）

任何一层失守 → § Document Reading 不再"纯描述"。三层共同保证用户硬约束的实质满足。

## 与 IF Stage 6.5 reviewer 的对比

IF Stage 6.5 `insight-reviewer` 也有"隔离输入"：reviewer 仅读最终报告 + 19 checks 定义 + 6 dims rubric + `--type` / `--depth` 参数，**禁读** `skeleton.yaml` / `SOURCES_USED` / `EVIDENCE_CHAIN` / Stage 5 草稿 / Stage 6 author 6-dim 自评分（[skills/insight-fuse/SKILL.md:193](../../insight-fuse/SKILL.md#L193)）。

peer-fuse Stage 3.5 的隔离方向**相反**：IF Stage 6.5 隔离的是 reviewer **输入侧**（防 reviewer 被作者 self-eval 污染），peer-fuse Stage 3.5 隔离的是 reviewer **某一节内部**（防同一 reviewer 在写解读时被自己后续要写的评审污染）。两者都解决"评价侧污染描述侧"问题，但作用域不同。
