# Forge

> 张弛有度。7 个 skill，让你和 AI 的编码节奏更好。

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-7-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

## 安装

```bash
# Claude Code（一条命令）
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Hammer

| Skill | 功能 | 试试看 |
|-------|------|--------|
| **block-break** | 强制穷尽一切方案，不轻言放弃 | `/block-break` |
| **ralph-boost** | 自主开发循环，保证收敛 | `/ralph-boost setup` |

### Crucible

| Skill | 功能 | 试试看 |
|-------|------|--------|
| **council-fuse** | 多视角议会蒸馏，获得更好的答案 | `/council-fuse <question>` |
| **insight-fuse** | 系统化多源调研，生成专业报告 | `/insight-fuse <topic>` |
| **tome-forge** | 个人知识库，LLM 编纂的 wiki | `/tome-forge init` |

### Anvil

| Skill | 功能 | 试试看 |
|-------|------|--------|
| **skill-lint** | 校验任意 Claude Code skill 插件 | `/skill-lint .` |

### Quench

| Skill | 功能 | 试试看 |
|-------|------|--------|
| **news-fetch** | 编码间隙快速刷新闻 | `/news-fetch AI today` |

---

## Block Break — 高能动性行为约束引擎

AI 又放弃了？`/block-break` 强制它穷尽一切方案。

当 Claude 卡住时，Block Break 激活压力升级系统，阻止过早投降。它迫使 agent 经历越来越严格的问题解决阶段，不允许任何 "我做不到" 的回应。

| 机制 | 说明 |
|------|------|
| **三条红线** | 闭环验证 / 事实驱动 / 穷尽一切 |
| **压力升级** | L0 信任 → L1 失望 → L2 拷问 → L3 绩效 → L4 毕业 |
| **五步方法论** | 闻味道 → 揪头发 → 照镜子 → 新方案 → 复盘 |
| **7项检查清单** | L3+ 强制完成的诊断清单 |
| **抗合理化表** | 14 种常见借口的识别与封堵 |
| **Hooks** | 自动挫败检测 + 失败计数 + 状态持久化 |

```text
/block-break              # 激活 Block Break 模式
/block-break L2           # 从指定压力等级启动
/block-break fix the bug  # 激活后立即执行任务
```

也可通过自然语言触发：`try harder`、`别偷懒`、`又错了`、`stop spinning` 等（由 hooks 自动检测）。

> 参考 [PUA](https://github.com/tanweai/pua) 核心机制，精简为零依赖 skill。

## Ralph Boost — 自主开发循环引擎

真正能收敛的自主开发循环。30 秒完成初始化。

以 skill 形式复刻 ralph-claude-code 的自主循环能力，内建 Block Break L0-L4 压力升级保证收敛。解决自主循环 "原地打转" 的问题。

| 特性 | 说明 |
|------|------|
| **双路径循环** | Agent 循环（主路径，零外部依赖）+ bash 脚本 Fallback（jq/python 双引擎） |
| **增强断路器** | L0-L4 压力升级原生内建，从 "3 轮放弃" 到 "6-7 轮渐进自救" |
| **状态追踪** | 统一 state.json 持久化断路器 + 压力 + 策略 + 会话 |
| **优雅交接** | L4 后生成结构化交接报告，而非裸停机 |
| **与 Ralph 独立** | 使用 `.ralph-boost/` 目录，不依赖不修改 ralph-claude-code |

```text
/ralph-boost setup        # 初始化项目
/ralph-boost run          # 启动自主循环
/ralph-boost status       # 查看当前状态
/ralph-boost clean        # 清理
```

> 参考 [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) 核心循环能力，重构为零依赖 skill 并增加收敛保证。

## Skill Lint — Skill 插件校验工具

一条命令校验你的 Claude Code 插件。

校验 Claude Code plugin 项目中 skill 文件的结构完整性和语义质量。Bash 脚本做结构检查，AI 做语义检查，互补覆盖。

| 检查类型 | 说明 |
|----------|------|
| **结构检查** | frontmatter 必填字段 / 文件存在性 / references 引用 / marketplace 条目 |
| **语义检查** | description 质量 / name 一致性 / command 路由 / eval 覆盖度 |

```text
/skill-lint              # 显示用法
/skill-lint .            # 校验当前项目
/skill-lint /path/to/plugin  # 校验指定路径
```

## News Fetch — 冲刺间隙的放松时刻

debug 累了？`/news-fetch` — 2 分钟的合法摸鱼。

其他 skill 让你更拼命。这个提醒你该喘口气了。在终端里直接抓取任意主题的最新新闻——不用切换上下文，不会掉进浏览器兔子洞。快速扫一眼，刷新大脑，然后回去干活。

| 特性 | 说明 |
|------|------|
| **三级降级** | L1 WebSearch → L2 WebFetch 国内源 → L3 curl |
| **去重合并** | 同一事件多来源自动合并，保留最高分条目 |
| **相关性打分** | AI 根据主题匹配度打分排序 |
| **概要补全** | 无摘要时自动抓取正文生成 |

```text
/news-fetch AI                    # 本周 AI 新闻
/news-fetch AI today              # 今日 AI 新闻
/news-fetch 机器人 month          # 本月机器人新闻
/news-fetch climate 2026-03-01~2026-03-31  # 指定时间段
```

## Council Fuse — 多视角议会蒸馏引擎

通过结构化辩论获得更好的答案。`/council-fuse` 生成 3 个独立视角，匿名评分后综合最优解。

灵感来源：[Karpathy 的 LLM Council](https://github.com/karpathy/llm-council) — 精简为一条命令。

| 机制 | 说明 |
|------|------|
| **三视角** | 通才（平衡） / 批评者（对抗） / 专家（深度技术） |
| **匿名评分** | 4 维评估：正确性、完整性、实用性、清晰度 |
| **综合** | 最高分回答为骨架，融入独特洞察 |
| **少数意见** | 有效异议保留，不被消音 |

```text
/council-fuse 该不该用微服务？
/council-fuse 审查这段错误处理模式
/council-fuse Redis vs PostgreSQL 做任务队列
```

## Insight Fuse — 系统化多源调研熔炼引擎

从主题到专业调研报告。`/insight-fuse` 运行 5 阶段渐进式流水线：扫描 → 对齐 → 调研 → 审阅 → 深挖。

内置多视角分析（通才/批评者/专家），可扩展报告模板，可配置调研深度。与 council-fuse 互为姊妹 — council-fuse 对已知信息做思辨，insight-fuse 主动采集并综合新信息。

| 机制 | 说明 |
|------|------|
| **5 阶段流水线** | 扫描 → 对齐 → 调研 → 审阅 → 深挖 |
| **可配置深度** | quick（仅扫描）/ standard（自动调研）/ deep（+ 多视角）/ full（+ 人工检查点） |
| **3 视角** | 通才（广度） / 批评者（验证） / 专家（精度） |
| **报告模板** | technology / market / competitive / 自定义 — 或自适应生成 |
| **质量标准** | 多源强制、引用完整性、来源多样性检查 |

```text
/insight-fuse AI Agent 安全风险
/insight-fuse --depth quick --template technology WebAssembly
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 量子计算商业化
```

## Tome Forge — 个人知识库引擎

构建由 LLM 编纂和维护的个人知识库。基于 [Karpathy 的 LLM Wiki 模式](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — 原始 Markdown 编译为结构化 wiki，无需 RAG 或向量数据库。

| 特性 | 说明 |
|------|------|
| **三层架构** | 原始素材（不可变） / Wiki（LLM 编纂） / Schema（CLAUDE.md） |
| **6 种操作** | init、capture、ingest、query、lint、compile |
| **My Understanding Delta** | 人类洞察专区 — LLM 永不覆写 |
| **零基础设施** | 纯 Markdown + Git，无数据库、无嵌入、无服务器 |

```text
/tome-forge init              # 在当前目录初始化知识库
/tome-forge capture "idea"    # 快速捕获笔记
/tome-forge ingest raw/paper  # 将原始素材编译进 wiki
/tome-forge query "question"  # 搜索并综合
/tome-forge lint              # 健康检查 wiki 结构
/tome-forge compile           # 批量编译所有新素材
```

> 灵感来源：[Karpathy 的 LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)，构建为零依赖 skill。

## 质量保证

- 每个 skill 10+ 评估场景，含自动化触发测试
- 用自己的 skill-lint 自我校验
- 零外部依赖 — 零风险
- MIT 开源

## 项目结构

```text
forge/
├── skills/                        # Claude Code 平台
│   └── <skill>/
│       ├── SKILL.md               # Skill 定义
│       ├── references/            # 按需加载的详细内容
│       ├── scripts/               # 辅助脚本
│       └── agents/                # Sub-agent 定义
├── platforms/                     # 其他平台适配层
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw 适配版
│           ├── references/        # 该平台的详细内容
│           └── scripts/           # 该平台的辅助脚本
├── .claude-plugin/                # Claude Code marketplace 元数据
├── hooks/                         # Claude Code 平台 hooks
├── evals/                         # 跨平台评估场景
├── docs/                          # 跨平台文档
└── plugin.json                    # 集合级元数据
```

## 贡献

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw 适配版 + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — 评估场景
4. `.claude-plugin/marketplace.json` — 在 `plugins` 数组追加条目
5. 如需 hooks，在 `hooks/hooks.json` 中添加

详见 [CLAUDE.md](../../CLAUDE.md) 开发规范。

## License

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
