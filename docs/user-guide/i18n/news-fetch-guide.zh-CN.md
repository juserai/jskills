# News Fetch 用户指南

> 3 分钟上手 — 让 AI 为你获取新闻简报

调试累了？花 2 分钟，了解世界正在发生什么，然后精神焕发地回来。

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserai/forge
```

### 通用一行安装

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **零依赖** — News Fetch 不需要任何外部服务或 API 密钥。安装即用。

---

## 命令

| 命令 | 功能 | 使用场景 |
|------|------|---------|
| `/news-fetch AI` | 获取本周 AI 新闻 | 快速行业动态 |
| `/news-fetch AI today` | 获取今天的 AI 新闻 | 每日简报 |
| `/news-fetch robotics month` | 获取本月机器人新闻 | 月度回顾 |
| `/news-fetch climate 2026-03-01~2026-03-31` | 获取特定日期范围的新闻 | 定向研究 |

---

## 使用场景

### 每日技术简报

```
/news-fetch AI today
```

获取当天最新的 AI 新闻，按相关性排序。几秒钟内扫描标题和摘要。

### 行业研究

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

拉取特定时间段的新闻，支持市场分析和竞争研究。

### 跨语言新闻

中文话题会自动补充英文搜索以获得更广泛的覆盖，反之亦然。无需额外操作即可获得两个世界的精华。

---

## 预期输出示例

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## 3 层网络回退

News Fetch 内置了回退策略，确保在不同网络条件下都能获取新闻：

| 层级 | 工具 | 数据源 | 触发条件 |
|------|------|-------|---------|
| **L1** | WebSearch | Google/Bing | 默认（首选） |
| **L2** | WebFetch | Baidu News、Sina、NetEase | L1 失败 |
| **L3** | Bash curl | 与 L2 相同的源 | L2 也失败 |

当所有层级都失败时，会生成一份结构化的失败报告，列出每个源的失败原因。

---

## 输出特性

| 特性 | 描述 |
|------|------|
| **去重** | 当多个来源报道同一事件时，保留得分最高的条目；其他条目折叠到"相关报道"中 |
| **摘要补全** | 如果搜索结果缺少摘要，则获取文章正文并生成摘要 |
| **相关性评分** | AI 按主题相关性为每个结果评分 — 分数越高越相关 |
| **可点击链接** | Markdown 链接格式 — 在 IDE 和终端中可点击 |

---

## 相关性评分

每篇文章根据其标题和摘要与请求主题的匹配程度获得 0-300 分：

| 分数范围 | 含义 |
|---------|------|
| 200-300 | 高度相关 — 主题是文章的核心 |
| 100-199 | 中度相关 — 主题被显著提及 |
| 0-99 | 边缘相关 — 主题一带而过 |

文章按分数降序排列。评分是启发式的，基于关键词密度、标题匹配度和上下文相关性。

## 网络回退故障排除

| 症状 | 可能原因 | 解决方法 |
|------|---------|---------|
| L1 返回 0 条结果 | WebSearch 工具不可用或查询过于具体 | 扩大主题关键词 |
| L2 所有源失败 | 国内新闻网站阻止自动访问 | 等待后重试，或检查 `curl` 是否可以手动工作 |
| L3 curl 超时 | 网络连接问题 | 检查 `curl -I https://news.baidu.com` |
| 所有层级失败 | 无互联网访问或所有源宕机 | 检查网络；失败报告列出了每个源的错误 |

---

## 常见问题

### 需要 API 密钥吗？

不需要。News Fetch 完全依赖 WebSearch 和公开网页抓取。零配置即可使用。

### 能获取英文新闻吗？

当然可以。中文话题自动包含补充英文搜索，英文话题原生支持。覆盖范围横跨两种语言。

### 如果网络受限怎么办？

3 层回退策略会自动处理。即使 WebSearch 不可用，News Fetch 也会回退到国内新闻源。

### 返回多少篇文章？

最多 20 篇（去重后）。实际数量取决于数据源返回的内容。

---

## 使用场景 / 不应使用场景

### ✅ 适用

- You want a quick news brief between coding sessions
- Bilingual aggregation (English + domestic sources)
- Network-restricted environments (3-tier fallback handles blocked sources)

### ❌ 不适用

- You need synthesized research (use `insight-fuse` instead)
- Targeted source monitoring (use an RSS reader)
- Translation tasks (news-fetch returns source language as-is)

> 编码间隙的新闻简报器——2 分钟扫一眼世界，不做深度分析或翻译。

完整边界分析: [references/scope-boundaries.md](../../../skills/news-fetch/references/scope-boundaries.md)

---

## 许可证

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
