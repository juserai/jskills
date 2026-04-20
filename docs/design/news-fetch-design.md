# news-fetch 设计文档

**日期**: 2026-03-31
**状态**: 已批准

## 定位

通过 WebSearch + WebFetch 获取指定时间段、指定主题的新闻，以 Markdown 清单格式输出。支持三级网络降级策略，确保在不同网络环境下都能获取新闻。

## 覆盖与边界

> news-fetch 是**编码间隙的新闻简报器**——它让你 2 分钟扫一眼世界不用离开终端，但不做深度分析、不做翻译、也不取代 RSS 或专业调研工具。

完整分析（能解决 / 不能解决 / 不应使用）：[references/scope-boundaries.md](../../skills/news-fetch/references/scope-boundaries.md)

## 命名

遵循 `名称-动词` 模式：news(新闻) + fetch(获取)。

## 参数解析

| 参数 | 格式 | 默认值 | 示例 |
|------|------|--------|------|
| 主题 | 自由文本 | 必填 | `AI`、`rust 语言`、`climate change` |
| 时间段 | `today`/`week`/`month`/`YYYY-MM-DD~YYYY-MM-DD` | `week` | `today`、`2026-03-01~2026-03-31` |

命令示例：
```
/news-fetch AI                          # 本周 AI 新闻
/news-fetch rust语言 today              # 今日 Rust 新闻
/news-fetch climate change 2026-03-01~2026-03-31
```

## 数据获取策略（三级降级）

```
L1: WebSearch 搜索新闻
    │
    ├─ 成功 → 提取结果
    │
    └─ 失败/无结果 → L2: WebFetch 国内新闻源
                       │
                       ├─ 成功 → 解析 HTML 提取新闻
                       │
                       └─ 全部失败 → L3: Bash curl 直接抓取
                                       │
                                       ├─ 成功 → 解析结果
                                       │
                                       └─ 全部失败 → 结构化失败报告
```

| 级别 | 工具 | 数据源 | 触发条件 |
|------|------|--------|---------|
| L1 | WebSearch | Google/Bing 新闻搜索 | 默认首选 |
| L2 | WebFetch | 百度新闻、新浪新闻、网易新闻搜索页 | L1 失败或返回空 |
| L3 | Bash curl | 同 L2 源，curl 直接请求 | L2 WebFetch 也失败 |

### L2 国内新闻源 URL 模板

```
百度新闻: https://news.baidu.com/ns?word={主题}&pn=0&cl=2&ct=0&tn=news&rn=10&ie=utf-8
新浪新闻: https://search.sina.com.cn/?q={主题}&c=news&range=all
网易新闻: https://www.163.com/search?keyword={主题}
```

## 输出格式

```markdown
## {主题}资讯

{YYYY年M月D日} {星期X}

TOP {N} 条

### 1. {标题}

**{来源}** | 相关性得分: {分数}

{完整段落摘要，保留关键数字和事实}

[查看详情]({url})
相关报道: [{来源2}]({url2}) | [{来源3}]({url3})

### 2. {标题}

...

---
共 {N} 条 | 数据获取: {L1/L2/L3} {具体来源}
```

### 去重策略

同一事件多个来源时：
- 保留相关性得分最高的作为主条目
- 其余来源折叠为"相关报道"链接行

### 概要缺失处理

WebSearch 结果无摘要时，用 WebFetch 抓取正文前 200 字生成概要，而非留空。

### 失败输出

```markdown
## {主题}资讯 | 获取失败

已尝试:
- L1 WebSearch: {失败原因}
- L2 WebFetch 百度新闻: {失败原因}
- L2 WebFetch 新浪新闻: {失败原因}
- L3 curl 百度新闻: {失败原因}

建议: 检查网络连接，或稍后重试。
```

## 行为约束

1. 解析用户参数，提取主题和时间段
2. L1: WebSearch 搜索 `{主题} news {时间段}`
3. 如果 L1 成功且结果充分 → 跳到步骤 7
4. L2: WebFetch 依次抓取国内新闻源搜索页，解析 HTML
5. 如果 L2 成功 → 跳到步骤 7
6. L3: 运行 `scripts/news-fallback.sh {主题}`，curl 抓取
7. 去重（同一事件保留最高分，其余折叠为相关报道）
8. 概要缺失时 WebFetch 正文前 200 字生成
9. AI 根据主题匹配度打相关性得分
10. 按相关性得分倒序排列
11. 输出 Markdown 清单，标注数据来源级别

## 文件清单

```
skills/news-fetch/SKILL.md                 # 核心 skill 定义
skills/news-fetch/scripts/news-fallback.sh # L3 curl 降级脚本
commands/news-fetch.md                     # /news-fetch 入口
evals/news-fetch/scenarios.md              # 评估场景
evals/news-fetch/run-trigger-test.sh       # 触发测试
docs/user-guide/news-fetch.md                   # 使用手册
```

## 与现有 skill 的关系

- 零依赖，独立使用
- 无 hooks（手动触发，无自动触发需求）
- 无 references 目录（规则精简，无需拆分）
- 无 agents（无 sub-agent 需求）
