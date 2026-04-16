# Insight Fuse 使用手册

> 系统化多源调研熔炼引擎 — 从主题到专业调研报告

## 快速开始

```bash
# 完整调研（5 阶段，含人工检查点）
/insight-fuse AI Agent 安全风险

# 快速扫描（仅 Stage 1）
/insight-fuse --depth quick 量子计算

# 使用特定模板
/insight-fuse --template technology WebAssembly

# 自定义视角深度调研
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 自动驾驶商业化
```

## 参数说明

| 参数 | 说明 | 示例 |
|------|------|------|
| `topic` | 调研主题（必需） | `AI Agent 安全风险` |
| `--depth` | 调研深度 | `quick` / `standard` / `deep` / `full` |
| `--template` | 报告模板 | `technology` / `market` / `competitive` |
| `--perspectives` | 视角列表 | `optimist,pessimist,pragmatist` |

## 深度模式

### quick — 快速扫描
执行 Stage 1。3+ 搜索查询，5+ 来源，输出简要报告。适合快速了解一个主题。

### standard — 标准调研
执行 Stage 1 + 3。自动识别子问题，并行调研，全面覆盖。无人工交互。

### deep — 深度调研
执行 Stage 1 + 3 + 5。标准调研基础上，对所有子问题进行 3 视角深度分析。无人工交互。

### full（默认） — 完整流水线
执行全部 5 个阶段。Stage 2 和 Stage 4 为人工检查点，确保方向不偏离。

## 报告模板

### 内置模板

- **technology** — 技术调研：架构、对比、生态、趋势
- **market** — 市场调研：规模、竞争、用户、预测
- **competitive** — 竞品分析：功能矩阵、SWOT、定价

### 自定义模板

1. 复制 `templates/custom-example.md` 为 `templates/your-name.md`
2. 修改章节结构
3. 保留 `{topic}` 和 `{date}` 占位符
4. 最后一章必须是「参考来源」
5. 使用 `--template your-name` 激活

### 无模板模式

不指定 `--template` 时，agent 根据调研内容自适应生成报告结构。

## 多视角分析

### 默认视角

| 视角 | 角色 | 模型 |
|------|------|------|
| Generalist | 广度覆盖、主流共识 | Sonnet |
| Critic | 质疑验证、找反面证据 | Opus |
| Specialist | 深度技术、一手来源 | Sonnet |

### 备选视角集

| 场景 | 视角 |
|------|------|
| 趋势预测 | `--perspectives optimist,pessimist,pragmatist` |
| 产品研究 | `--perspectives user,developer,business` |
| 政策研究 | `--perspectives domestic,international,regulatory` |

### 自定义视角

创建 `agents/insight-{name}.md`，参考现有 agent 文件结构。

## 质量保证

每份报告自动检查：
- 每章节至少 2 个独立来源
- 无悬空引用
- 单来源占比不超 40%
- 所有对比断言有数据支撑

## 与 council-fuse 的区别

| | insight-fuse | council-fuse |
|---|---|---|
| **用途** | 主动调研 + 报告生成 | 对已知信息做多视角思辨 |
| **信息来源** | WebSearch/WebFetch 采集 | 用户提供的问题 |
| **输出** | 完整调研报告 | 综合答案 |
| **阶段** | 5 阶段渐进式 | 3 阶段（召集→评分→综合） |

两者可组合使用：先用 insight-fuse 调研收集信息，再用 council-fuse 对关键决策做深度思辨。
