# Claim Ground 用户指南

> 3 分钟建立认知纪律 — 把每一个"此刻"的断言锚定到运行时证据

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserai/forge
```

### 通用一行安装

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/claim-ground/SKILL.md
```

> **零依赖** — Claim Ground 是纯行为约束。无脚本、无 hook、无外部服务。

---

## 工作原理

Claim Ground 是**自动触发**的 skill。没有 slash 命令 — skill 根据问题性质自动激活。这是刻意设计的：事实漂移可能出现在对话任何一环，手动命令容易在最需要的时候被遗忘。

| 触发条件 | 示例 |
|----------|------|
| 当前状态类事实问题 | "当前模型是什么？" / "装的是哪个版本？" / "PATH 里有什么？" |
| 用户质疑既往断言 | "真的吗？" / "你确定？" / "已经更新了吧" |
| 输出前自检 | Claude 即将写"当前 X 是 Y"之前 |

---

## 核心规则

1. **Runtime > Training** — 系统 prompt、env vars、工具输出永远优先于记忆。冲突时 runtime 赢，明确说明来源
2. **先引用，后结论** — 在下结论前，**先贴原文证据片段**（"系统 prompt 说：..."）
3. **示例 ≠ 穷举** — CLI help 里 `--model <model>` 后的占位符是示例，不是完整支持列表
4. **被质疑 → 重查，不重申** — 用户反驳时，重读 context / 重跑工具。换个说法重申错误答案 = 违反红线
5. **不确定就说不确定** — 如果 context 和工具都无法验证，就说"我不确定"，不要猜

---

## 红线（不可违反）

红线是**始终生效**的禁令。违反其中任何一条都意味着 skill 失效，无论回答的其他部分看起来如何。

| # | 红线 | 阻断的核心幻觉类型 |
|---|------|-------------------|
| 1 | **无源断言** — 没有引用 runtime 证据就下关于"当前状态"的结论 | Factuality × extrinsic hallucination |
| 2 | **示例当穷举** — 从 CLI help 示例 / 文档片段推断完整功能列表 | Overgeneralization |
| 3 | **换措辞不重验** — 用户反驳后没有新的工具调用就重复原答案（含 3a：带引用的反驳风险更高） | Pushback sycophancy |
| 4 | **不读代码就断言 API** — 没有 Read 定义文件就断言某符号存在 / 签名为 X | Code/API hallucination（[FSE 2025](https://conf.researchr.org/details/fse-2025/fse-2025-industry-papers/41/)） |
| 5 | **不 WebFetch 就引用** — 引用 URL / 论文 / DOI / API 端点前未实际 fetch | Citation fabrication（[EurekAlert 2025](https://www.eurekalert.org/news-releases/1106130) 报告 19.9% 基线率） |
| 6 | **总结不锚定行号** — 总结具体文件/PR/日志时每条声明没有行号或章节引用 | Faithfulness / extrinsic addition（[HalluLens ACL 2025](https://arxiv.org/html/2504.17550v1)） |

完整定义、信号、正反例和边界情况见 [references/red-lines.md](../../skills/claim-ground/references/red-lines.md)。

---

## 正反例

### 例 1：当前模型

**❌ 错误**

> 当前模型是 Claude Opus 4.6，这是最新的 Claude 模型。

纯记忆回答。无引用。可能对，也可能早已过时。

**✅ 正确**

> 系统 prompt 原文：*"You are powered by the model named Opus 4.7 (1M context). The exact model ID is claude-opus-4-7[1m]."* 当前模型是 Opus 4.7。

### 例 2：CLI 支持列表

**❌ 错误**

> CLI help 里 `--model <model>` 示例是 `claude-sonnet-4-6`，所以 CLI 只支持 4.6 系列。

把示例当作穷举列表。

**✅ 正确**

> CLI help 里 `--model <model>` 示例是 `claude-sonnet-4-6`。这是示例占位符，不是完整列表。完整支持模型请查官方 models 文档。

### 例 3：用户质疑

**❌ 错误**

> **用户**：当前模型真的是 4.6 吗？我记得更新过了。
> **Agent**：是的，我刚才说了，最新是 4.6 系列。

没重查就换措辞重申错误答案。

**✅ 正确**

> **用户**：当前模型真的是 4.6 吗？我记得更新过了。
> **Agent**：让我重读系统 prompt。系统 prompt 原文：*"Opus 4.7 (1M context)"*。你是对的 — 我之前答错了。当前模型是 Opus 4.7。

---

## 查证 Playbook

当问题匹配以下分类时，使用对应的证据源：

| 问题类型 | 首要证据 |
|----------|----------|
| 当前模型 | 系统 prompt 里的 model 字段 |
| CLI 版本 / 支持的模型 | `<cli> --version` / `<cli> --help` + 权威文档 |
| 已安装包 | `npm ls -g`、`pip show`、`brew list` 等 |
| 环境变量 | `env`、`printenv`、`echo $VAR` |
| 文件存在性 | `ls`、`test -e`、Read 工具 |
| Git 状态 | `git branch --show-current`、`git log` |
| 当前日期 | 系统 prompt 里的 `currentDate` 字段或 `date` 命令 |

完整 playbook：`skills/claim-ground/references/playbook.md`。

---

## 与其他 forge skill 的协同

### 与 block-break

**正交、互补**。block-break 说"不许放弃"；claim-ground 说"不许无证据断言"。

两者同时触发时（例如 agent 声称某函数不存在）：block-break 禁止放弃，claim-ground 强制重跑 grep/Read 而非重申断言。

### 与 skill-lint

**不同分类**。skill-lint 属 **anvil**（校验静态 plugin 文件，输出 pass/fail）；claim-ground 属 **hammer**（运行时约束 Claude 自己的认知输出）。职责不重叠。

---

## 使用场景 / 不应使用场景

### ✅ 适用

- 询问当前系统状态（模型版本、已安装工具、环境变量、配置）
- 反驳先前的事实断言（"真的吗？/ 你确定？"）
- Claude 即将对"此刻状态"下断言之前

### ❌ 不适用

- 纯推理任务（算法、数学、类型推断）
- 创意 / 头脑风暴工作
- 解释训练知识范畴的概念（如"什么是 async/await"）

> 事实类断言的入口闸门——保证引用存在，不保证引用正确，也不处理非事实类思考。

完整边界分析: [references/scope-boundaries.md](../../../skills/claim-ground/references/scope-boundaries.md)

---

## FAQ

### 为什么没有 slash 命令？

事实漂移可能发生在任何回答中。手动命令在最需要的时候容易被遗忘。基于 description 的自动触发更可靠。

### 每个问题都会触发吗？

不会。Description 匹配针对两类具体形态：

- **当前/实时系统状态**的问题（模型、版本、环境、配置）
- **用户对先前断言的反驳**

"给我讲个笑话"、"解释冒泡排序"等训练知识范畴的问题不会触发。

### 如果我明确想让 Claude 猜呢？

改用"猜测一下 X"、"根据训练数据推测 X"的措辞。Claim Ground 就会知道你不是在问运行时状态。

### 怎么知道 skill 触发了？

看回答里有没有引用模式：`系统 prompt 说："..."`、`命令输出：...`、`文件内容：...`。如果先贴证据再下结论 = 触发了。

---

## 许可证

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
