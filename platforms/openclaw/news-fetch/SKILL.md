---
name: news-fetch
description: "News Fetch — Quick news between coding sessions. Take a mental break, stay informed. 3-tier network fallback."
license: MIT
metadata:
  category: quench
  permissions:
    network: true
    filesystem: read-write
    execution: none
    tools: [WebSearch, WebFetch, Read, Write, Glob, Edit]
argument-hint: "[topic] [time-range] [--no-save]"
---

# News Fetch — 新闻获取工具

获取指定主题和时间段的新闻，以结构化清单输出。

## 参数解析

从用户输入中提取：
- **主题**（必填）：新闻关键词，如 `AI`、`rust 语言`、`climate change`
- **时间段**（可选，默认 `week`）：`today` / `week` / `month` / `YYYY-MM-DD~YYYY-MM-DD`

## 工作流

按以下步骤严格执行：

### 1. 数据获取（三级降级）

**L1 — WebSearch 搜索**：
- 构造查询：`{主题} 新闻 {时间段描述}`
- 使用搜索工具搜索
- 如果中文主题，额外搜一次英文翻译版扩大覆盖
- 成功且结果 ≥ 3 条 → 跳到步骤 2

**L2 — WebFetch 国内新闻源**（L1 失败或结果不足时）：
- 依次尝试以下 URL，抓取并解析 HTML：
  - 百度新闻：`https://news.baidu.com/ns?word={主题}&pn=0&cl=2&ct=0&tn=news&rn=10&ie=utf-8`
  - 新浪新闻：`https://search.sina.com.cn/?q={主题}&c=news&range=all`
  - 网易新闻：`https://www.163.com/search?keyword={主题}`
- 任一成功 → 跳到步骤 2

**L3 — Bash curl**（L2 全部失败时）：
- 运行 `scripts/news-fallback.sh {主题}`
- 脚本依次 curl 上述三个源，超时 10 秒/源
- 返回 HTML 内容供解析
- 全部失败 → 输出结构化失败报告（列出每个源的失败原因）

### 2. 处理与去重

- 从搜索结果中提取：标题、来源媒体、发布时间、概要、URL
- **概要缺失处理**：如果搜索结果无摘要，抓取正文，取前 200 字生成概要
- **去重**：同一事件多个来源报道时，保留相关性得分最高的为主条目，其余折叠为"相关报道"
- **相关性打分**：根据标题和概要与用户指定主题的匹配程度打分（0-300），越相关分越高

### 3. 输出

按相关性得分倒序排列，使用以下格式输出：

```markdown
## {主题}资讯

{YYYY年M月D日} {星期X}

TOP {N} 条

### 1. {标题}

**{来源媒体}** | 相关性得分: {分数}

{完整段落摘要，保留关键数字和事实}

[查看详情]({url})
相关报道: [{来源2}]({url2}) | [{来源3}]({url3})

---
共 {N} 条 | 数据获取: {L1/L2/L3} {具体来源}
```

### 失败输出

```markdown
## {主题}资讯 | 获取失败

已尝试:
- L1 搜索: {失败原因}
- L2 百度新闻: {失败原因}
- L2 新浪新闻: {失败原因}
- L3 curl 百度新闻: {失败原因}

建议: 检查网络连接，或稍后重试。
```

**语言检测规则**: 如果用户输入包含中日韩字符，使用中文模板；否则使用英文模板。

### 英文失败输出 / English Failure Output

```markdown
## {Topic} News | Fetch Failed

Attempted:
- L1 WebSearch: {reason}
- L2 WebFetch: {reason}
- L3 curl: {reason}

Suggestion: Check your network connection, or try again later.
```

### 4. KB 归档（必须，除非 --no-save）

新闻清单输出后、结束之前，**必须**执行归档。这是工作流的一部分，不是事后想起来的可选项。

1. 读取 tome-forge 的归档协议文件 `platforms/openclaw/tome-forge/references/report-archival-protocol.md`
   - 文件存在 → 进入步骤 2
   - 文件不存在 → 输出 `Archive: skipped (tome-forge not installed)` 并跳过本节
2. 按协议执行 KB Discovery：
   - 命中 → 进入步骤 3
   - 未命中（CWD 既不在 KB 内、`~/.tome-forge/.tome-forge.json` 也不存在）→ 输出 `Archive: skipped (KB discovery failed)` 并跳过
3. 写新闻清单文件，frontmatter 元数据：
   - `topic`：用户原始查询主题
   - `time_range`：参数指定时间窗口（today / week / month / 自定义日期范围）
   - `item_count`：本次清单条目数
   - `fetch_tier`：实际生效的网络层级（L1 WebSearch / L2 WebFetch / L3 curl）
4. **增量更新**：同主题同日期的新闻追加合并（同一天多次获取取并集去重），不同日期各自独立文件
5. **必须输出可见日志行**（这一行须出现在用户可见的最终响应里，不能藏在 tool result 里）：
   - 成功：`Archived to KB: {absolute_filepath}`
   - 用户传 `--no-save`：`Archive: skipped (--no-save flag)`
   - 其他跳过场景：见步骤 1/2

`--no-save` 开关：用户在调用时附加（例：`/news-fetch ai today --no-save`）则整个步骤跳过并输出 skip 行。
