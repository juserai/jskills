# insight-fuse 设计文档

**日期**: 2026-04-16
**状态**: 已实施

## 定位

系统化多源调研熔炼引擎：从主题输入到专业调研报告输出的 5 阶段渐进式流水线。主动采集多源信息（WebSearch/WebFetch），内置多视角分析框架，支持可配置深度和可扩展报告模板。

与 council-fuse 的关系：独立并行。insight-fuse 是调研引擎（主动采集+分析），council-fuse 是思辨引擎（对已知信息做多视角分析）。两者共属 crucible 分类的 fuse 系列。

## 命名

遵循 `名词-动词` 模式：insight(洞察) + fuse(熔合)。分类为 crucible（坩埚 — 多源融合、知识沉淀）。

## 核心机制

### 5 阶段渐进式流水线

```
Stage 1: Scan       Stage 2: Align      Stage 3: Research    Stage 4: Review     Stage 5: Deep Dive
┌──────────┐       ┌──────────┐        ┌──────────┐        ┌──────────┐        ┌────────────────┐
│ WebSearch │       │ 展示简报  │        │ 并行Agent │        │ 展示报告  │        │ 3视角并行Agent  │
│ 3+查询    │──→   │ 确认范围  │──→     │ 每子问题  │──→     │ 选焦点区  │──→     │ 匿名评分综合   │
│ 5+来源    │       │ 修正方向  │        │ 衍生探索  │        │ 反馈方向  │        │ 融入报告       │
└──────────┘       └──────────┘        └──────────┘        └──────────┘        └────────────────┘
     ↓                   ↓                   ↓                   ↓                      ↓
  初步简报            确认scope           标准报告            焦点清单              最终报告
```

### 深度路由

| --depth | 执行阶段 | 交互？ | 适用场景 |
|---------|---------|--------|---------|
| quick | 1 | 否 | 快速了解一个主题 |
| standard | 1, 3 | 否 | 自动化标准调研 |
| deep | 1, 3, 5 | 否 | 自动化深度调研 |
| full（默认） | 1, 2, 3, 4, 5 | 是（2, 4） | 人机协作完整调研 |

### 参数设计

| 参数 | 必需 | 默认值 | 说明 |
|------|------|--------|------|
| topic | 是 | — | 调研主题 |
| --depth | 否 | full | quick / standard / deep / full |
| --template | 否 | 无（自适应） | technology / market / competitive / 自定义名 |
| --perspectives | 否 | generalist,critic,specialist | 逗号分隔的视角列表 |

### 模板发现逻辑

1. 有 `--template` → 读 `templates/{name}.md`，不存在则报错
2. 无 `--template` → Stage 1 完成后，根据内容自适应生成报告结构（参见 research-protocol.md 自适应算法）
3. 列出可用模板 → glob `templates/*.md`，排除 `custom-example.md`

## 多视角分析框架

### 评分维度

| 维度 | 权重 | 说明 |
|------|------|------|
| Accuracy | 0-10 | 来源质量 + 事实正确性 |
| Coverage | 0-10 | 主题广度、是否遗漏关键方面 |
| Depth | 0-10 | 技术细节深度、数据精确度 |
| Objectivity | 0-10 | 偏见检测、平衡呈现 |

区别于 council-fuse 的 Correctness/Completeness/Practicality/Clarity——调研场景更关注来源质量和客观性。

### 综合算法

1. **匿名化**：去掉 PERSPECTIVE 标签，随机分配 Response A/B/C
2. **4 维评分**：对每个匿名回答打分
3. **共识分析**：分类为强共识 / 多数+异议 / 三方分歧
4. **综合**：以最高分回答为骨架，融入其他回答的独特洞察，保留 Critic 的有效质疑作为风险/局限章节
5. **冲突解决**：Accuracy 维度高分者优先；平局时呈现双方观点

### 内置视角集

| 视角集 | 适用场景 |
|--------|---------|
| generalist, critic, specialist（默认） | 通用调研 |
| optimist, pessimist, pragmatist | 未来预测、趋势判断 |
| user, developer, business | 产品/技术调研 |
| domestic, international, regulatory | 政策/市场调研 |

### 自定义视角

创建 `agents/insight-{name}.md`，使用 `--perspectives name1,name2,name3` 激活。最少 2 个，最多 5 个。

## Agent 设计

每个 Agent 独立运行，互不可见：

| Agent | 角色 | 模型 | 设计理由 |
|-------|------|------|---------|
| Generalist | 平衡、全面、主流共识 | Sonnet | 广度覆盖，成本适中 |
| Critic | 质疑、验证来源、找反面证据 | Opus | 对抗性分析需要最强推理 |
| Specialist | 深度技术细节、一手来源 | Sonnet | 精确数据，成本适中 |

Agent 使用场景：
- **Stage 3**：每个子问题派 1 个 Generalist agent（并行跨子问题）
- **Stage 5**：每个焦点区域派 3 个 agent（Generalist + Critic + Specialist 并行）

## 输出结构

### 结构化输出块（Agent 产出）

```
---INSIGHT_RESPONSE---
PERSPECTIVE: <generalist|critic|specialist|custom>
CONFIDENCE: <1-10>
KEY_FINDINGS:
  - <finding>
SOURCES_USED:
  - [title](url) — <credibility note>
GAPS_IDENTIFIED:
  - <gap>
CONTENT:
  <完整调研内容>
---END_INSIGHT_RESPONSE---
```

### 最终报告格式

```markdown
# {topic} 调研报告

> 日期：YYYY-MM-DD | 基于多源信息综合分析

---

## 一、...（按模板或自适应结构）
## 二、...
...

## N、参考来源
### 基础调研来源
### 深度调研来源（如执行了 Stage 5）

> Researched by [forge/insight-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
```

## 质量标准

### 强制检查（不通过则报告不合格）

- 每章节至少 2 个独立来源引用
- 引用列表完整（无悬空引用）
- 单来源占比不超 40%
- 比较断言必须有数据支撑
- 报告日期行存在

### 结构要求

- 标题：`# {topic} 调研报告`
- 编号：中文数字（一、二、三...）+ 十进制子编号（1.1, 1.2）
- 对比：3+ 项对比时使用表格
- 深度章节标注视角来源
- 引用列表分两层：基础调研来源 / 深度调研来源
- 双语：中文主体，英文术语内嵌

### 反模式

- 无来源的统计数据
- "据多方来源"式模糊引用
- 单一来源的复制粘贴（须改写综合）

## 降级策略

- 1 个视角 Agent 失败：该视角评分为 0，从剩余 2 个综合
- 2 个视角 Agent 失败：直接输出唯一成功的回答，标注为单视角
- 全部失败：报告失败，建议用户直接提问
- WebSearch 无结果：尝试替代查询词，记录信息缺口

## 行为约束

### Stage 1 — 快速扫描
1. 构造 3+ 搜索查询（原文 + 改写 + 跨语言变体）
2. WebSearch 执行所有查询
3. 从结果中提取 5+ 独立来源
4. 编写初步简报：主题概述、3-5 个识别到的子问题、来源清单
5. 输出简报给用户
6. 若 `--depth quick`：直接按模板生成快速报告，结束

### Stage 2 — 交互对齐（仅 full 模式）
1. 展示初步简报
2. 请用户确认/修正：主题范围、子问题列表、排除领域
3. 记录确认后的 scope

### Stage 3 — 标准调研
1. 为每个子问题派一个 Generalist agent（并行）。子问题来源：full 模式取 Stage 2 确认后的列表；其他模式取 Stage 1 自动识别的子问题
2. 每个 agent 读取 `agents/insight-generalist.md` 角色定义
3. 每个 agent 遵循 `references/research-protocol.md` 输出格式
4. 使用 WebSearch + WebFetch 多源覆盖
5. 探索 1-2 个调研中发现的衍生主题
6. 收集所有 INSIGHT_RESPONSE 块
7. 按模板（或自适应结构）编排标准报告
8. 若 `--depth standard`：结束

### Stage 4 — 人工审阅（仅 full 模式）
1. 展示标准报告
2. 请用户指定需要深度多视角分析的焦点区域
3. 记录焦点清单

### Stage 5 — 深度调研
1. 对每个焦点区域，在**同一 response 中**发起 3 个 Agent 调用：
   - Agent 1 — Generalist：读 `agents/insight-generalist.md`，model: sonnet
   - Agent 2 — Critic：读 `agents/insight-critic.md`，model: opus
   - Agent 3 — Specialist：读 `agents/insight-specialist.md`，model: sonnet
2. 收集 3 个 INSIGHT_RESPONSE 块
3. 按 `references/perspectives.md` 执行匿名评分综合
4. 将深度分析融入标准报告的对应章节
5. 对所有焦点区域顺序执行（焦点间串行，视角内并行）
6. 按 `references/quality-standards.md` 执行质量检查
7. 输出最终报告

## 文件清单

```
skills/insight-fuse/SKILL.md                            # 核心 skill 定义（~300词）
skills/insight-fuse/agents/insight-generalist.md         # 通才角色定义（~120词）
skills/insight-fuse/agents/insight-critic.md              # 批评者角色定义（~120词）
skills/insight-fuse/agents/insight-specialist.md          # 专家角色定义（~120词）
skills/insight-fuse/references/research-protocol.md      # 结构化输出格式 + 自适应算法（~350词）
skills/insight-fuse/references/perspectives.md           # 多视角框架 + 评分综合（~300词）
skills/insight-fuse/references/quality-standards.md      # 质量标准（~200词）
skills/insight-fuse/templates/technology.md              # 技术调研模板（~150词）
skills/insight-fuse/templates/market.md                  # 市场调研模板（~150词）
skills/insight-fuse/templates/competitive.md             # 竞品分析模板（~150词）
skills/insight-fuse/templates/custom-example.md          # 自定义模板示例（~80词）
evals/insight-fuse/scenarios.md                          # 评估场景（6个）
evals/insight-fuse/run-trigger-test.sh                   # 触发测试
docs/guide/insight-fuse-guide.md                         # 使用手册
platforms/openclaw/insight-fuse/SKILL.md                 # OpenClaw 适配版
platforms/openclaw/insight-fuse/references/*.md          # OpenClaw references
platforms/openclaw/insight-fuse/agents/*.md              # OpenClaw agents
```

更新已有文件：
- `.claude-plugin/marketplace.json` — 追加 insight-fuse 条目
- `README.md` + `docs/i18n/README.*.md` — crucible 分类追加介绍

## 与现有 skill 的关系

- 零依赖，独立使用
- 与 council-fuse 独立并行（fuse 系列，不替代不依赖）
- 无 hooks（通过 `/insight-fuse` 手动触发）
- 无 scripts（纯 AI 执行）
- 可选组合：council-fuse 做纯思辨，insight-fuse 做调研

## 评估场景

| # | 输入 | 验证目标 |
|---|------|---------|
| 1 | `/insight-fuse --depth quick --template technology WebAssembly` | quick 路径 + 模板选择 + 来源收集 |
| 2 | `/insight-fuse AI Agent 安全风险` | 完整 5 阶段 + 交互门 + 自适应结构 |
| 3 | `/insight-fuse --depth standard --template market 大模型推理芯片` | standard 深度 + 市场模板 + 对比表 |
| 4 | `/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 量子计算商业化` | 自定义视角 + 优雅降级 |
| 5 | `/insight-fuse --template competitive Claude Code vs Cursor vs Windsurf` | 竞品模板 + 多实体对比 |
| 6 | `/insight-fuse Rust` | 歧义主题处理 + Stage 2 对齐价值 |

## 实现顺序

1. **Phase 1 — 核心契约**：SKILL.md + research-protocol.md + quality-standards.md
2. **Phase 2 — Agent 定义**：3 个 agent 文件
3. **Phase 3 — 视角框架**：perspectives.md
4. **Phase 4 — 报告模板**：4 个模板文件
5. **Phase 5 — 评估基础设施**：scenarios.md + run-trigger-test.sh + guide + marketplace 更新 + i18n + OpenClaw 适配
6. **Phase 6 — Lint 验证**：`/skill-lint .` 全部通过
