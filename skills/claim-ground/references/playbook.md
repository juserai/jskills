# Claim Ground — 查证 Playbook

按问题类型选证据源和验证命令。找到匹配分类 → 直接执行对应动作。

---

## 1. 模型问题——先分作用域

模型类问题至少三种语义，**作用域不同，证据源不同**。答题前先归类。

### 1a. 本地作用域："当前会话跑的是哪个模型？"

**首要证据源**：系统 prompt 里的 model 描述字段。

**查找位置**：

- 系统 prompt 开头通常有"You are powered by..."/"The exact model ID is..."
- 或环境信息里的 `model` / `model_id` 字段

**标准回答模板**：

> 系统 prompt 原文："<完整引用>"。当前会话跑的是 <model_id>。

### 1b. 生态作用域："某厂商最新/最强的模型是什么？"

**首要证据源**：**WebSearch + 官方新闻页**（`anthropic.com/news/`、官方博客、Vertex/Bedrock 发布说明）。

**关键认知**：系统 prompt 的"most recent X"字段只覆盖 **GA 可列入默认的模型**。它**看不到**：

- 研究/红队 preview（如 Claude Mythos Preview，仅 Project Glasswing 合作伙伴可用）
- 限量 gated release（AWS Bedrock gated preview、Google Vertex allow-list）
- 内部未公开模型

因此：**回答"最新"前必须外部查一次**，即使系统 prompt 看起来已经给了答案。

**标准回答模板**：

> 系统 prompt 原文："<引用>"——这是 GA 线。
> WebSearch 结果（今日）：<贴链接与要点>——存在/不存在更新的 preview / gated 版本。
> 综合：GA 线最新 = <X>；生态整体最新 = <Y>（是否对外开放：<状态>）。

### 1c. 混合问题："我当前用的是最新的吗？"

这是**两个问题叠在一起**，必须拆开回答：

1. 你当前用的是什么（1a）
2. 生态整体最新是什么（1b）
3. 二者是否相同、差在哪里（preview / 可用性）

**反例**（作用域塌缩，我自己犯过）：

> 用户：当前模型是最新的吗？
> 错误回答：是，系统 prompt 说 Opus 4.7 是 most recent。
> 漏了：Mythos Preview 实际上是更新/更强的模型，只是不对外 GA。

**正例**：

> 本地（系统 prompt）：当前是 Opus 4.7，GA 线最新。
> 生态（WebSearch）：Anthropic 还有 Claude Mythos Preview（2026-04 发布，gated research preview，仅 Project Glasswing 可用）。
> 结论：你这个会话用的是 GA 线顶配，但 Anthropic 整体最新/最强是 Mythos Preview（你拿不到）。

### 通用禁忌

- 凭记忆报"最新是 X"
- 把"最近发布的模型"当"当前运行的模型"（不同概念）
- 用系统 prompt 的 "most recent" 字段回答生态范围问题（作用域不匹配）

---

## 2. CLI 版本 / CLI 支持的模型列表

**首要证据源**：

| 目标 | 命令 |
|------|------|
| CLI 版本 | `<cli> --version` |
| CLI 帮助 | `<cli> --help` |
| 具体子命令帮助 | `<cli> <sub> --help` |
| 完整支持列表 | 官方文档 / API 端点（help 举例不算） |

**陷阱**：help 里的 `--model <model>` 后的示例是占位符，不是穷举。要看完整支持列表必须查明确的 models 文档或 API。

**标准回答模板**：

> `claude --version` 输出：`<output>`。版本是 <version>。
> 若问支持模型：help 只举了 X 为示例，完整列表需查 [官方文档链接 / API]。

---

## 3. 已安装包 / 全局 CLI

**首要证据源**：

| 生态 | 命令 |
|------|------|
| npm 全局 | `npm ls -g --depth=0` 或 `ls $(npm config get prefix)/lib/node_modules` |
| pip | `pip show <pkg>` 或 `pip list` |
| brew | `brew list` / `brew list <pkg>` |
| apt | `dpkg -l \| grep <pkg>` |
| 二进制 | `which <cmd>`、`command -v <cmd>` |

**陷阱**：`which` 返回 shell 别名或第一个匹配项，不代表其他位置没有同名文件。必要时用 `type -a <cmd>` 看所有匹配。

---

## 4. 环境变量 / 配置

**首要证据源**：

| 目标 | 命令 |
|------|------|
| 单个 env | `echo $VAR` 或 `printenv VAR` |
| 全部 env | `env` 或 `printenv` |
| shell 配置 | Read `~/.zshrc` / `~/.bashrc` / `~/.profile` 等 |
| 项目配置文件 | Read 文件原文，不要凭记忆 |

**陷阱**：`.env` 可能未加载到当前 shell，`echo $VAR` 为空不等于"没配置"，要区分"文件里有 / shell 里生效"。

---

## 5. 文件 / 目录存在性

**首要证据源**：

- `ls <path>` / `ls -la <path>`
- `test -e <path> && echo exists`
- Read 工具直接读

**陷阱**：

- 符号链接可能指向不存在的目标（`ls` 显示存在，但读取失败）
- 相对路径依赖当前工作目录

**标准**：展示命令输出原文，不要总结"存在"或"不存在"。

---

## 6. Git 状态

**首要证据源**：

| 目标 | 命令 |
|------|------|
| 当前分支 | `git branch --show-current` |
| 最近提交 | `git log --oneline -5` |
| 工作区状态 | `git status` |
| 远程分支 | `git branch -r` |
| 指定文件历史 | `git log --follow -- <file>` |

**陷阱**：本地 `git log` 不等于远程最新，如问"最新版本"要 `git fetch` 后再 `git log origin/main`。

---

## 7. HTTP / 网络接口

**首要证据源**：

- `curl -s <url>`（文本接口）
- `curl -sI <url>`（只看 header）
- `ping <host>`（判断可达性，注意不能推断服务可用）

**陷阱**：`ping` 通 ≠ 服务可用；HTTP 200 ≠ 内容正确。必须读返回内容本身。

---

## 8. 时间 / 日期

**首要证据源**：

- 系统 prompt 里的 `currentDate` / `today` 字段
- `date` 命令

**陷阱**：训练数据的时间 ≠ 此刻。若问"今天是几号 / 现在最新是什么"，查系统 prompt，不要凭训练截止日期推断。

---

## 9. 代码符号存在性 / API 签名

**首要证据源**：代码库本身，不是训练记忆。

**查找顺序**：

| 目标 | 命令 |
|------|------|
| 函数 / 类 / 方法在哪个文件定义 | `rg -nS 'def <name>\|function <name>\|class <name>'` |
| 某符号是否存在（快速检查） | `rg -c '<symbol>' path/` |
| 具体签名 | Read 定义文件，贴完整函数原型 |
| 依赖库符号 | `ls node_modules/<pkg>/` + Read 具体模块 |
| 最近版本 breaking change | `CHANGELOG.md` / `CHANGES.rst` / `git log -- <file>` |

**陷阱**：

- 训练数据可能混了多个库 / 多个版本的 API。比如 `axios.defaults.timeout` 在 axios v1 有，但在旧版可能没有
- `grep` 返回结果 ≠ 符号"可调用"；可能在注释里、在测试里、在已注释掉的代码里
- 模块重导出（re-export）会让 `rg` 找不到真实定义。找不到就顺着 `import from './foo'` 递归跟过去

**标准回答模板**：

> [Grep / Read 命令 + 输出]，据此确认 `<symbol>` 定义在 `<file>:<line>`，签名是 `<proto>`。

**反例（触犯红线 4）**：

> 直接写 `axios.defaults.adapter = myAdapter` 但没 Read 过 `axios/lib/defaults/index.js` 确认 `adapter` 字段真存在于 `defaults` 对象上。

## 9.5 专业术语 / 行业标准定义（v1.1，红线 7）

被问"X 是什么 / 定义 X / X 与 Y 的区别"，且 X 是有**权威标准体 / 规范文档**的术语时，**不允许凭训练记忆给定义**——必须 WebSearch / WebFetch 标准体原文。详细识别信号与反例见 [red-lines.md §红线 7](red-lines.md#红线-7术语凭印象v11)。

### 标准体映射表

| 术语领域 | 权威源 | WebSearch 关键词 / WebFetch 入口 |
|---|---|---|
| **商业分析（BA）/ 流程 / 需求工程** | IIBA（International Institute of Business Analysis）— BABOK Guide | `IIBA BABOK definition of business analysis` / `https://www.iiba.org/career-resources/...` |
| **投资分析 / 金融** | CFA Institute Curriculum；FASB / IFRS Foundation | `CFA Institute curriculum investment analysis` / `https://www.cfainstitute.org/...` |
| **会计准则** | FASB Codification (US-GAAP) / IFRS Foundation | `FASB ASC 606 revenue recognition` / `https://www.fasb.org/...` / `https://www.ifrs.org/...` |
| **网络协议 / Web 标准** | IETF (RFC) / W3C / IANA | `RFC 9110 HTTP semantics` / `https://www.rfc-editor.org/rfc/rfcXXXX` / `https://www.w3.org/TR/...` |
| **编码 / 字符集** | Unicode Consortium / Unicode Standard | `Unicode Standard 15.0 chapter X` / `https://www.unicode.org/standard/standard.html` |
| **版本号规范** | Semantic Versioning (semver.org) | `semantic versioning 2.0.0 specification` / `https://semver.org/` |
| **管理体系 / 信息安全** | ISO / IEC（27001、9001、IEC 62443 等）| `ISO/IEC 27001:2022 definition of information security` / 通过 ISO 官网 / 或 NIST 等价文档 |
| **工程标准 / 浮点 / 网络硬件** | IEEE（754、802 系列）| `IEEE 754 floating-point definition` / `https://standards.ieee.org/...` |
| **科研方法学 / 统计** | 同行评议教科书 / 经典论文 / 期刊（Nature / NEJM / JAMA / arXiv） | `arXiv survey of <topic>` / `DOI:10....` |
| **法律 / 隐私 / 合规** | 立法原文 / 监管机构发布（EUR-Lex / federalregister.gov / 各国官方）| `GDPR Article 6 lawfulness of processing` / `https://eur-lex.europa.eu/...` |
| **排版 / 文档语言** | LaTeX/TeX 项目 / CommonMark spec / JSON RFC 8259 / YAML 1.2 spec | `CommonMark spec 0.30` / `https://spec.commonmark.org/0.30/` |
| **数据库 / 查询语言** | ANSI SQL 标准（ISO/IEC 9075）/ 各 DB 官方 docs | `ISO/IEC 9075-2 SQL language definition` |

### 标准回答模板

```
[WebSearch "<标准体 + 术语 + definition>"]
[WebFetch <标准体 URL>]
据 <标准体> 原文："<verbatim 定义>"。
[若需对比另一术语：]
[WebSearch / WebFetch 另一术语]
据 <标准体 2> 原文："<verbatim>"。
综合：<两术语区别 / 关系陈述，避免凭印象拼接>
```

### 反例 vs 正例

**❌ 反例**：

> 用户：商业分析和投资分析有什么区别？
> 错误：商业分析是研究公司业务模式的方法（SWOT / Porter），投资分析是评估投资标的的金融分析。
> 问题：未引用 IIBA BABOK，未引用 CFA Institute；两个定义都是凭训练记忆"听起来对"地拼出来的。

**✅ 正例**：

> [WebFetch https://www.iiba.org/career-resources/...] 据 IIBA 官网："Business analysis is the practice of enabling change in an enterprise by defining needs and recommending solutions that deliver value to stakeholders."
> [WebFetch https://www.cfainstitute.org/...] 据 CFA Institute Curriculum："Investment analysis is the process of evaluating an investment for its profitability and risk..."
> 综合：BA 关注组织内变革使能，IA 关注投资标的可投性评估，并非同一体系下的近义词。

### 边界

- **触发**：术语命中上表领域 + 问句形如"是什么 / 定义 / 区别 / what is / define / explain"
- **不触发**：通识词（"什么是水"）、私有术语（"我们项目里 widget 是什么意思"）、纯训练知识范畴的常识
- **模糊区**：跨领域复合术语（"AI agent 是什么"）—— 无单一权威标准体；列 ≥ 2 个有出处的并存定义（Anthropic / OpenAI / IBM 等），明示"业内多种定义并存"

---

## 10. 外部 URL / 论文 / DOI / API 端点

**首要证据源**：

| 目标 | 命令 |
|------|------|
| URL 存在性 + 内容 | `WebFetch <url>` —— 必看返回的前几百字 |
| 论文索引 | `WebSearch "author title year"` + 打开 arXiv / DOI 链接 |
| DOI 有效性 | WebFetch `https://doi.org/<doi>` |
| API 端点存在性 | WebFetch 官方 API 文档页 |

**陷阱**：

- URL 返回 200 ≠ 内容正确；必须读返回内容
- 训练数据里的 URL 可能已迁移 / 改名 / 下线
- 论文标题 + 作者 + 年份，其中任一字段错就是伪造（引用的完整性）

**标准回答模板**：

> [WebFetch <url>] 返回内容："<前 200 字>"。该资源确实存在并讨论了 X。

**反例（触犯红线 5）**：

> 写"详见 https://docs.anthropic.com/api/batches/cancel"但没 WebFetch；URL 可能根本不存在。

---

## 跨类通用原则

1. **先列证据，再下结论** — 贴命令 + 输出，再总结
2. **引用原文，不用自己的话改写** — "系统 prompt 说 X" 强于"根据我看到的信息，大概是 X"
3. **找不到就说找不到** — 不要用"训练时大概是..."填空
4. **举例不等于穷举** — 看到 help 里的 `e.g.`、`such as`、`etc.` 时警觉
5. **被质疑就重查** — 用户反驳是"我漏看了什么"的信号，不是"要说服用户"的信号
6. **代码符号先读再断言** — 红线 4：没有 Read / Grep 过就不写具体 API 调用
7. **URL 先 Fetch 再引用** — 红线 5：没有 WebFetch 过就不贴"官方文档在 X"
8. **摘要逐条锚定行号** — 红线 6：不做"流畅加料"
