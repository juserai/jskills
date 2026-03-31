# News Fetch 使用手册

> 3 分钟上手，让 AI 帮你获取最新新闻简报

---

## 安装

### Claude Code（推荐）

```bash
claude plugin add juserch/juserch-skills
```

### 通用单行安装

```
Fetch and follow https://raw.githubusercontent.com/juserch/juserch-skills/main/skills/news-fetch/SKILL.md
```

> **零依赖** — News Fetch 不依赖任何外部服务或 API。安装即用。

---

## 命令一览

| 命令 | 功能 | 场景 |
|------|------|------|
| `/news-fetch AI` | 获取本周 AI 新闻 | 快速了解行业动态 |
| `/news-fetch AI today` | 获取今日 AI 新闻 | 每日早报 |
| `/news-fetch 机器人 month` | 获取本月机器人新闻 | 月度回顾 |
| `/news-fetch climate 2026-03-01~2026-03-31` | 指定时间范围 | 定向调研 |

---

## 使用场景

### 每日技术早报

```
/news-fetch AI today
```

获取今日 AI 领域最新资讯，按相关性排序，快速浏览标题和摘要。

### 行业调研

```
/news-fetch 新能源汽车 2026-03-01~2026-03-31
```

获取指定时间段的行业新闻，辅助市场分析和竞品调研。

### 跨语言新闻

中文主题会自动追加英文搜索扩大覆盖，反之亦然。

---

## 预期输出示例

```markdown
## AI资讯

2026年3月30日 星期一

TOP 5 条

### 1. OpenAI 发布 GPT-5 多模态版本

**Reuters** | 相关性得分: 223.0

OpenAI 正式发布 GPT-5，支持原生视频理解和实时语音对话，
定价较前代下降 40%。该模型在多项基准测试中超越前代...

[查看详情](https://example.com/article1)
相关报道: [新智元](https://example.com/a2) | [量子位](https://example.com/a3)

### 2. 此芯科技完成近十亿元B轮融资

**投资界** | 相关性得分: 118.0

此芯科技完成近十亿元B轮融资，发布首款智能体CPU——
CIX ClawCore螯芯系列芯片，覆盖低功耗至高性能场景...

[查看详情](https://example.com/article2)

---
共 5 条 | 数据获取: L1 WebSearch
```

---

## 三级网络降级

News Fetch 内置三级降级策略，确保不同网络环境下都能获取新闻：

| 级别 | 工具 | 数据源 | 触发条件 |
|------|------|--------|---------|
| **L1** | WebSearch | Google/Bing | 默认首选 |
| **L2** | WebFetch | 百度新闻、新浪、网易 | L1 失败 |
| **L3** | Bash curl | 同 L2 源 | L2 也失败 |

所有级别失败时输出结构化失败报告，列出每个源的失败原因。

---

## 输出特性

| 特性 | 说明 |
|------|------|
| **去重** | 同一事件多来源时，保留最高分条目，其余折叠为"相关报道" |
| **概要补全** | 搜索结果无摘要时，自动抓取正文生成概要 |
| **相关性得分** | AI 根据主题匹配度打分，越相关分越高 |
| **可点击链接** | Markdown 链接格式，IDE/终端中可点击跳转 |

---

## FAQ

### 需要 API Key 吗？

不需要。完全基于 WebSearch 和公开网页抓取，零配置。

### 能获取英文新闻吗？

可以。中文主题会自动追加英文搜索，英文主题同理。

### 网络不好怎么办？

三级降级策略自动应对。即使 WebSearch 不可用，也会尝试国内新闻源。

### 一次能获取多少条？

默认最多 20 条（去重后）。搜索结果数量取决于数据源返回。

---

## License

[MIT](LICENSE) - [juserch](https://github.com/juserch)
