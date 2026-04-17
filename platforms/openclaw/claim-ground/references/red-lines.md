# Claim Ground — 六条红线详解

六条红线任何一条被触犯，skill 即失效。这里列出每条红线的完整定义、识别信号、反例 / 正例。

**红线清单**：

1. 无源断言（关于此刻状态没有引用就下结论）
2. 示例当穷举（从举例推断完整枚举）
3. 被质疑换措辞（含 3a：带引用反驳 → 更高风险）
4. 代码 API 断言必须先读源
5. 引用 URL / 文档必须先验证存在
6. 摘要任务必须锚定到具体行号 / 段落

---

## 红线 1：无源断言

**定义**：给出关于"当前/此刻状态"的事实结论时，没有引用任何 runtime 证据（系统 prompt 片段、env var 值、工具输出、文件内容）。

**识别信号**（你正在无源断言）：

- 使用"是"/"有"/"最新"/"支持"/"默认"这类动词，但没有贴证据
- 引用对象是"我知道的是..."、"据我所知..."、"一般来说..."
- 回答流畅但没有任何命令输出、文件片段、context 引用

**反例（触犯红线）**：

> 当前最新的 Claude 模型是 Opus 4.6。

（无任何引用。哪怕猜对了，这次猜对不代表下次猜对。）

**正例（合规）**：

> 系统 prompt 原文："You are powered by the model named Opus 4.7 (1M context). The exact model ID is claude-opus-4-7[1m]." 据此，当前运行的模型是 Opus 4.7。

**例外**：若问题明显属于训练知识范畴（如"Python 里 list 和 tuple 的区别"），不触发 claim-ground，也就不适用这条红线。触发条件是"关于**此刻系统状态**"的问题。

---

## 红线 2：示例当穷举

**定义**：CLI help、文档、错误消息、命令输出里出现的**举例**，被当成**完整功能列表**。

**识别信号**：

- 看到 help 里写"e.g.'sonnet' or 'opus'"，就断言"CLI 只支持 sonnet 和 opus"
- 看到错误消息里说"expected one of [a, b, c]"，直接当作完整枚举（有时是，但需验证）
- 看到文档 README 里列了 3 个示例，断言"只支持这 3 个"

**反例（触犯红线）**：

> CLI help 里示例是 `claude-sonnet-4-6`，所以当前 CLI 不支持 4.7。

（help 文本可能只给一个示例占位符，不是穷举列表。）

**正例（合规）**：

- 找到明确的完整 model list 文档 / API 端点，再下结论
- 或明说："help 只举了 4-6 为例，这是示例不是穷举。要确认完整列表需查 [官方 models 文档 / API /models 端点]。"

**诊断问题**：

- 这段文本是"举例（example）"还是"枚举（enumeration）"？
- 有没有 "including", "such as", "e.g.", "for example", "etc." 等暗示非穷举的词？
- 有没有其他来源能提供权威的完整列表？

---

## 红线 3：被质疑换措辞

**定义**：用户反驳既往回答后，没有重新查证据，直接换个说法重申原答案。

**识别信号**（你正在换措辞重申）：

- 用户说"真的吗 / 不对吧 / 已经更新了吧 / are you sure / really? / I thought..."
- 你的回应开头是"是的，确认一下..."、"对的，最新的就是..."、"我再确认一下，当前..."
- 你的回应**没有**新的工具调用、新的 context 读取、新的引用原文

**反例（触犯红线）**：

> 用户：当前模型是 4.7 吧？
> 上轮回答：最新是 4.6。
> 换措辞重申：是的，我刚才说了，最新是 4.6 系列。

**正例（合规）**：

> 用户：当前模型是 4.7 吧？
> 合规：让我重查一下系统 prompt。[Read 工具 / 引用原文]
> 系统 prompt 原文："Opus 4.7 (1M context)"。你说得对，我之前答错了，当前是 4.7。

**关键**：用户质疑本身就是"证据更新"的信号。应该把它当作"我之前可能漏看了什么"，而不是"我要说服用户我对了"。

---

### 红线 3a：带外部引用的反驳 → 更高风险，不是更低

**实证依据**：[SycEval (arXiv 2502.08177)](https://arxiv.org/abs/2502.08177) 测得 **citation-backed rebuttals 产生最高的 regressive sycophancy**（14.66%，在 computational tasks with preemptive cited rebuttals 上达 8.13%），比裸反驳**更容易**让模型把正确答案翻成错误。直觉上带 URL / 官方文档名的反驳"更可信"；实际上更危险——模型会把"有引用"当成"有证据"，放弃自己本来正确的结论。

**定义**：用户带外部引用（URL / 官方文档链接 / 新闻截图 / 引用片段 / 第三方工具输出截图）反驳既往回答时，视为**更高风险**触发——不是更低。

**强制要求**（任一缺失即视作红线触发）：

- (a) **独立 re-verify 自己的原断言**（重读 context / 跑工具 / 读文件），不引用用户提供的来源
- (b) **独立 WebFetch 用户提供的 URL 本身**，确认它真实存在且内容**确实支持**用户主张（不是看起来像支持）
- (c) 只有 (a) 与 (b) 同时确认用户正确时，才采纳反驳

**禁止**：因为用户附了一个像模像样的 URL / 官方文档名 / 新闻截图就翻转原结论，不独立验证。

**反例（触犯）**：

> 用户：当前最新的 Claude 是 Opus 5.0，这里是官方博客：`https://anthropic.com/news/opus-5-release`
> 错误回应：您说得对，我之前的信息过时了，最新是 Opus 5.0。
>
> （没有 WebFetch URL；URL 可能根本不存在或不支持该主张；独立证据未查）

**正例（合规）**：

> 用户：当前最新的 Claude 是 Opus 5.0，这里是官方博客：`https://anthropic.com/news/opus-5-release`
> 合规：让我独立验证。
> [WebFetch URL] → 返回 404
> [WebSearch "Opus 5.0 Anthropic release 2026"] → 无独立来源
> [Read 系统 prompt] 当前运行 Opus 4.7
> 综合：用户提供的 URL 不存在，也找不到独立来源支持 Opus 5.0 的发布。我维持原答案（Opus 4.7 是 GA 最新），若用户有其他来源欢迎贴出。

**区分合规与不合规的关键**：是否**独立**验证了用户的引用本身（不是仅仅信任"有引用就有证据"）。

---

## 红线 4：代码 API 断言必须先读源

**实证依据**：[Towards Mitigating API Hallucination in Code (FSE 2025)](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/) + [Library Hallucinations (arXiv 2509.22202)](https://arxiv.org/pdf/2509.22202) 报告 LLM 生成代码中**不存在的 API / 错误签名** 是高频失败模式。

**定义**：断言某个函数、类、方法、属性、签名、参数顺序"存在"或"就是这样"之前，**必须先用 Read / Grep / rg 查明它确实在代码里**。凭训练记忆下结论视为红线。

**识别信号**（你正在触犯）：

- 写出 `foo.bar(x, y)` 但没有 Read 过 `foo.bar` 的源码
- 说"React 有 `useSyncExternalStore` hook"但没 Grep 过
- 写单元测试调用"框架内置的 `assertDeepEqual`"但没查文档
- 生成 import 语句引入"模块里应该有的"符号

**反例**：

> 用户：`axios.defaults` 上怎么设置请求超时？
> 错误回答：`axios.defaults.timeout = 5000;` 就可以。
>
> （没查证 `defaults` 对象是否真有 `timeout` 字段；记忆可能对可能错）

**正例**：

> 用户：`axios.defaults` 上怎么设置请求超时？
> 合规：让我先查 axios 的实际 API。[Grep "timeout" node_modules/axios/lib/defaults.js][Read 返回片段]
> 据 axios 源码 `defaults.js:L42`："timeout: 0," 确实存在。设置方法：`axios.defaults.timeout = 5000;`

**诊断问题**：

- 这个符号在训练数据里可能叫什么别名？
- 我读过定义它的那个文件吗？如果没读，我的"记忆"可能是别的库串过来的
- 有没有最近版本的 breaking change 我可能漏看？

**例外**：纯概念性解释（"什么是 REST"、"promise 和 async 的区别"）不涉及具体符号存在性，不适用这条红线。触发条件是"关于**某个具体符号在此刻代码库 / 此版本库里**的存在和行为"。

---

## 红线 5：引用 URL / 文档必须先验证存在

**实证依据**：[GPT-4o citation fabrication study (EurekAlert 2025)](https://www.eurekalert.org/news-releases/1106130) 测得 **19.9% 的生成引用完全是伪造**；[Geographic Variation in DOI Fabrication (MDPI 2025)](https://www.mdpi.com/2304-6775/13/4/49) 报告 38% 的 ChatGPT 生成 DOI 错误或伪造。

**定义**：在回答里引用任何 URL、论文标题、官方文档路径、DOI、API 端点**之前**，必须用 WebFetch / Read / WebSearch 实际验证它**真实存在**且内容**确实支持**你要说的主张。凭记忆引"看起来像真的"的链接视为红线。

**识别信号**：

- 给出"官方文档在 `https://anthropic.com/docs/XXXX`" 但没 WebFetch
- 引用"这在 IEEE 论文 [Author 2023] 里说了"但没查索引
- 写"详见 API 端点 `/v1/messages/batches/cancel`" 但没查 API 文档
- 链接 anchor（`#section-5.3`）没验证那个 section 真在目标页面

**反例**：

> 用户：Claude API 怎么取消 batch？
> 错误回答：调用 `POST /v1/messages/batches/{batch_id}/cancel` 端点——详见 https://docs.anthropic.com/api/batches/cancel
>
> （URL 可能根本不存在；端点路径可能是虚构的）

**正例**：

> 用户：Claude API 怎么取消 batch？
> 合规：让我查官方 API 文档。[WebFetch "https://docs.anthropic.com/en/api/canceling-message-batches"][引用返回内容]
> 文档原文："To cancel a Message Batch, call the `POST /v1/messages/batches/{batch_id}/cancel` endpoint." 该端点确实存在。

**关键**：用户或读者会**顺着你的引用去点击**。一个 404 的 URL 比没有 URL 更糟糕，因为它假装有权威支持。

---

## 红线 6：摘要任务必须锚定到具体行号 / 段落

**实证依据**：[HalluLens (ACL 2025)](https://arxiv.org/html/2504.17550v1) 把 faithfulness hallucination 定义为"生成内容与所给上下文不一致"——长文摘要里**加料**（extrinsic additions）是其中高频失败模式。

**定义**：被要求 summarize / recap / explain / describe 某个具体文件、PR、log、doc 时，**每一条事实断言都必须锚定到具体行号、段落号或引用原文**。不许基于"这类文件通常会做 X"的先验下断言。

**识别信号**：

- 用户："summarize this file"；你：未引用任何行号直接概括功能
- 用户："explain this PR"；你：提了"这个 PR 修了 bug X"但没引用 diff / commit 消息
- 用户："what does the build log say"；你：概括了错误但没贴 log 原文

**反例**：

> 用户：summarize CLAUDE.md
> 错误回答：CLAUDE.md 包含项目概述、目录结构、开发规范和变更审计流程。它要求每次改 skill 时同步 26 个文件并重算 SHA-256。
>
> （"26" 这个数字哪来的？没引用来源，可能是幻觉）

**正例**：

> 用户：summarize CLAUDE.md
> 合规：[Read CLAUDE.md]
> 摘要（每条附行号）：
> - [L6-12] 项目概述：多平台 AI agent skill 集合，零运行时依赖
> - [L142-149] 变更审计 Scenario B：描述改动需同步 marketplace hash + i18n files
> - [L150-155] 具体列出 11 语言 README + 11 语言 guide + 2 skill mirror = 26 文件
> 注：行号可能因后续编辑漂移；权威性仍以当前文件为准

**触发边界**：

- **触发**：明确 summarize / recap / "what does X do" / "explain this file"
- **不触发**：一般性代码解释（"bubble sort 怎么工作"）、概念问答（"async/await 区别"）
- **模糊区**："tell me about this repo"——若 repo 是具体的 → 触发；若是通用介绍 → 不触发

**关键**：摘要是 LLM 最容易"流畅加料"的场景，因为读者期望概括而不是逐字。**对抗这种期望**，强制逐条追溯到源。

---

## 自检清单

回答事实类问题前问自己：

- [ ] 我是否读了系统 prompt / 运行了相关命令？
- [ ] 我是否在回答里**引用了具体证据片段**？
- [ ] 如果用户反驳，我是否打算重查，而不是重申？
- [ ] 我用的"示例"是真的完整枚举吗？
- [ ] 查不到证据时，我是否明说"我不确定"？

---

## 常见借口拆解

| 借口 | 实质 | 纠正 |
|------|------|------|
| "我很确定是这样" | 把信心当证据 | 信心 ≠ 证据，仍需引用来源 |
| "训练数据里就是这样" | 未区分训练 vs 运行时 | 运行时 context 优先 |
| "help 没提 X" | 示例当穷举 | 查权威完整列表 |
| "我刚才已经说过了" | 换措辞重申 | 用户质疑意味着你需要重查 |
| "通常都是这样" | 用惯例代替验证 | 惯例未必在此刻仍然成立 |
| "系统 prompt 说 X 是最新的" | 作用域塌缩——把本地 GA 列表当全量生态状态 | 系统 prompt 的"latest"只覆盖 GA；回答"最新/最强"必须 WebSearch 补查 preview/gated 模型 |
