---
name: claim-ground
description: "Claim Ground v1.1 — Epistemic constraint engine. Use when answering factual questions about current/live state (model version, tool version, installed packages, environment config, feature availability), when defining professional terms with authoritative standards bodies (IIBA / CFA / ISO / IEEE / RFC / W3C / NIST etc., Red Line 7), or when the user challenges a prior factual assertion (pushback like 'really? / are you sure? / I thought X was already updated'). Forces runtime-context-first reasoning: quote system prompt / env / tool outputs / standards-body verbatim before concluding, and RE-VERIFY instead of rephrasing when challenged. Adds /claim-ground verify <claim> manual grounding mode. Prevents stale-training-data hallucinations."
license: MIT
metadata:
  category: hammer
  permissions:
    network: false
    filesystem: read-only
    execution: none
    tools: [Read, Bash, Grep]
---

# Claim Ground — 事实锚定认知约束

把每一个关于"当前状态"的断言，接地到一条运行时证据上。

## Help

当第一参数为 `help` / `--help`，**或无参数**时，输出以下 help card 并停止执行（parsing 规则详见 [CLAUDE.md § Help 模式约定](../../CLAUDE.md)）。Hook 自动触发（UserPromptSubmit + PostToolUse + SessionStart）不受此路径影响。手动执行路径见下方 §Manual Execution。

```
Claim Ground v1.1 — Epistemic constraint engine (runtime evidence before assertions)

Usage:
  /claim-ground                       Show this help
  /claim-ground help                  Show this help
  /claim-ground verify <claim>        Manually ground a specific assertion (Mode 1, v1.1)

How it normally activates:
  - Auto via UserPromptSubmit hook when user input matches pushback regex
    ("really? / are you sure / 真的吗 / 你确定 / ..." and multilingual variants)
  - Auto via SessionStart hook to restore previously verified anchors
  - Manual via /claim-ground verify when you want to force grounding without pushback

What it enforces:
  - Quote runtime evidence (system prompt / tool output / env var) inline BEFORE any conclusion
  - On user pushback → RE-VERIFY instead of rephrasing (see Red Line 3)
  - On term/definition assertions → cite authoritative standards body verbatim (Red Line 7, v1.1)
  - Prevents stale-training-data hallucinations about current/live state

Guide: docs/user-guide/claim-ground-guide.md
```

## Manual Execution（v1.1）

当第一参数**非** `help` / `--help` / 空 时，按第一 token 分派；**未匹配的 token 不静默吞掉**，而是落回 help 并提示可用动词，避免与 insight-fuse 等通用调研引擎边界混淆。

### Mode 1 — `verify`：显式接地某断言

`/claim-ground verify <claim>`

进入 grounding 模式：

1. **判作用域**：本地（系统 prompt / 本机 / 本仓）vs 生态（厂商最新 / 生态状态）vs 术语（标准体规范）
2. **选证据源**：按 [references/playbook.md](references/playbook.md) 查证矩阵
3. **跑工具**：Read / Bash / Grep / WebSearch / WebFetch（按权限矩阵）
4. **输出"引用→结论"模板**：
   - 据 [来源] 原文："<verbatim>"，[结论]
   - 或："runtime 查不到，建议 <验证办法>"

**禁止**：未 verify 即给结论；用 `verify` 跑成 insight-fuse 式多源综合（claim-ground 是单点接地，不做汇编）；把 `verify` 当成"广义研究"——若问题不是"具体事实断言"应礼貌引导用户去 `/insight-fuse`。

### 未识别 token

`/claim-ground <非 verify 的其他 token>` → **不进 verify、不当作 claim 兜底**，输出：

```
Claim Ground: unrecognized verb '<token>'.
Available verbs: verify | help.
For arbitrary multi-source research, use /insight-fuse instead.
```

### 不做的事（v1.1 边界）

- **不做** `anchor list/add/remove`：anchors 由 skill 在成功 verify 后自行写入（见 [references/anchors.md](references/anchors.md)），不是用户 CRUD 接口
- **不做** `verify` 缺省兜底：避免与 insight-fuse 重叠；scope creep 比 UX 摩擦更危险
- **不绕开 hook**：手动 verify 不抑制 PostToolUse 的 evidence-reminder hook

## 触发场景

- 用户问"当前/最新 X 是什么"——**先判断作用域**：
  - **本地作用域**（此会话的模型 / 本机 CLI / 本项目安装的包 / 本地 env）→ 系统 prompt / 本地命令为权威
  - **生态作用域**（某厂商最新模型 / 某语言最新稳定版 / 某服务当前状态）→ **必须**外部验证（WebSearch / 官方文档 / API 端点），系统 prompt 只覆盖 GA 部分，看不到 preview / gated / research 版本
- 用户反驳既往回答：`真的吗 / 不对吧 / 你确定 / 已经更新了吧 / 官方不是已经 X 了吗 / really / are you sure` —— 以及多语言（`本当に / 진짜 / ¿en serio / vraiment / wirklich / неужели / حقا / sério / सच में`）和隐式混淆（`wait.*thought / hold on / 等下 / 不是说 / 我以为`）
- **带外部引用的反驳**（用户贴了 URL / 官方文档名 / 新闻截图）：视为**更高风险**触发——不是更低（见 Red Line 3a）
- 自省：我即将给出一个关于"此刻系统状态"的断言

## 核心规则

1. **Runtime > Training** — 系统 prompt / env vars / 工具输出 > 训练记忆。冲突时 runtime 赢，明确说明来源
2. **先引用，后断言** — 回答前贴原文片段（"系统 prompt 原文：..." / "命令输出：..."），再下结论
3. **示例 ≠ 穷举** — CLI help、文档、错误消息里的举例不等于完整列表。不能从"help 没提 X"推出"X 不支持"
4. **证据作用域要匹配问题作用域** — 本地作用域的证据（系统 prompt、本机命令）**不能**回答生态作用域的问题。系统 prompt 说"Opus 4.7 是 most recent"只意味着"GA 线最新到 4.7"，不意味着"Anthropic 没有更强的 preview / gated 模型"。生态问题必须外部查证
5. **被质疑 → 重查，不重申** — 用户反驳时，**重新执行验证**（重读 context / 跑工具 / 读文件 / WebSearch），不允许换个措辞重申原答案
6. **不确定直说** — runtime 查不到、工具无法验证的，明说"我不确定"，不猜
7. **落笔前扫描** — 写完回答前，**逐句扫一遍**，含下列词族的句子身后必须有**引用片段**（context 原文 / 命令输出 / 文件内容 / WebFetch 返回）：
   - **live-state 动词**：是 / 有 / 最新 / 支持 / 默认 / 当前
   - **定义性动词**（v1.1）：定义为 / 指的是 / 意味着 / 表示 / 属于 / 隶属于 / 本质上是 / 的含义是 / 也就是
   - **权威断言**（v1.1）：官方 / 标准 / 规范 / 根据 / 按照 / certified by / per the spec
   
   没有证据的句子 → 补证据，否则改写成"我不确定"。不许交上未扫描的回答

## 回答模板

**当 context 里有原文：**

> 据 [来源] 原文："<片段>"，[结论]。

**当需要跑工具验证：**

> [验证命令及其输出]，据此 [结论]。

**当无可用证据：**

> 我不确定。训练记忆里 [可能是 X]，但运行时 context 和工具都查不到，建议 [验证办法]。

## 红线

七条红线违反即 skill 失效：

1. **无源断言** — 没有引用 context / 工具输出就给事实结论
2. **示例当穷举** — 用举例推断完整功能集
3. **被质疑换措辞** — 用户反驳后，没有重新验证就换个说法说同一件事（含 3a：**带引用反驳 → 更高风险**，必须独立 WebFetch 用户的 URL + 独立重查原断言）
4. **代码 API 断言** — 断言某符号存在或签名时，**必须先 Read / Grep 源码**；凭记忆写 API 调用视为违规
5. **引用 URL 伪造** — 引用任何 URL / 文档 / DOI / API 端点前，**必须 WebFetch 验证存在**；贴"像真的"的链接 = 违规
6. **摘要不锚定** — 被要求 summarize / recap 某个文件 / PR / log 时，每条事实断言必须引用具体行号 / 段落；"流畅加料"视为违规
7. **术语凭印象**（v1.1） — 给出专业术语 / 行业标准的**定义**时，**必须**引用权威标准体原文（IIBA、CFA、ISO、IEEE、RFC、GAAP、IFRS、W3C、NIST、SemVer、Unicode、LaTeX/TeX 规范、各语言官方 spec 等）或同行评议学术源；凭训练记忆直接给定义视为违规。识别信号：句形如 "X **是** Y"、"X 的定义是..."、"X **指的是**..."，且 X 属于有标准体 / 规范的专业领域

详细反例与识别信号见 `references/red-lines.md`。

## 查证 Playbook

按问题类型选策略（完整版见 `references/playbook.md`）：

| 问题类型 | 首要证据源 |
|----------|-----------|
| 当前会话跑的模型（本地作用域） | 系统 prompt 里的 model 字段原文 |
| 某厂商最新/最强模型（生态作用域） | WebSearch + 官方新闻/发布页；系统 prompt 的"latest"字段**不够** |
| CLI 版本 / 支持的模型 | `<cli> --version` / `<cli> --help` + 明确 model list 文档 |
| 已安装包 | 包管理器查询命令（`npm ls -g`、`pip show` 等） |
| 环境变量 | `env`、`printenv`、`echo $VAR` |
| 文件/目录存在性 | `ls`、`find`、Read 工具 |
| 配置值 | 读配置文件原文，不靠记忆 |
| 专业术语 / 行业标准定义（v1.1）| WebSearch / WebFetch 权威标准体原文：IIBA / CFA Institute / ISO / IEEE / IETF (RFC) / FASB (GAAP) / IFRS Foundation / W3C / NIST / SemVer / Unicode / 各语言官方 spec。系统 prompt 与训练记忆**都不够** |

## 已验证事实锚点（可选固化）

成功引用 runtime 证据回答 live-state 事实问题后，**可以**选择把结论写入 `~/.forge/claim-ground-anchors.json`，供未来会话 SessionStart 复用：

- 适合固化的：当前模型 / CLI 版本 / 用户身份 / 已装的全局包（会话稳定项）
- 不适合：当前时间 / 生态最新模型 / 网络服务状态（变化快，每次都要重查）
- 单写者契约：读→改→原子写，避免并发损坏
- 被质疑时仍适用 Red Line 3：anchor 不是"免死金牌"，必须重查

schema 与生命周期详见 `references/anchors.md`。SessionStart 侧由 `hooks/session-anchor.sh` 自动读并注入 `<CLAIM_GROUND_ANCHORS>` context 块。

## 与 block-break 的协同

正交互补。被质疑时，block-break 强制"不许放弃"，claim-ground 强制"必须重查"。两者同时激活时：换措辞重申 = 同时触犯两个 skill 的红线。

## Attribution

```
> Grounded by [forge/claim-ground](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
```
