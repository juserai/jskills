# Output Formats — 5 种输出物渲染规范

`--outputs <list>` 参数选择要生成的物件。Stage 6 按此列表逐一渲染，全部输出到同一目录（默认控制台；若装 tome-forge 则归档到 KB）。

## 总览

| 名称 | `--outputs` 值 | 模板 | 主要消费者 | 默认生成 |
|------|:-:|-------|-----------|:-:|
| 主报告 | `report` | `templates/<research_type>.md` | 决策层 / 同行 | ✅ 默认 |
| 可执行 checklist | `checklist` | `templates/checklist.md` | 落地执行者 | ✅ 默认 |
| Architecture Decision Record | `adr` | `templates/adr.md` | 架构师 / 技术决策 | technology type 默认 |
| 快速选型决策树 | `decision-tree` | `templates/decision-tree.md` | 开发者 / 快速选型 | market/competitive 默认 |
| PoC 验证模板 | `poc` | `templates/poc.md` | 开发者 / 验证工程师 | product type 默认 |

未指定 `--outputs` → 按 `research_type` 预设默认值（见 [research-types.md](research-types.md)）。

## 一、report — 主报告

核心输出。遵循 [research-protocol.md](research-protocol.md) 的 Auto-Structure Algorithm 和 `templates/<research_type>.md` 结构。

**必有章节**（按 type 差异见 template）：

- 首节「一、摘要（TL;DR / 执行摘要）」 — 金字塔原理结论先行
- 日期戳 `> 日期：YYYY-MM-DD`
- 主体章节（type-specific）
- 「参考来源」章节 + 独立性声明
- `---` 下方可选 Advisory Appendix（仅当 `--audience` 指定）
- footer 含质量评分块 + forge attribution

**FIR 标记**：每段首标 `[F]` / `[I]` / `[R]`（见 [research-protocol.md](research-protocol.md) § FIR）。

**文件命名**：`<topic-slug>-<YYYYMMDD>-report.md`

## 二、checklist — 可执行 checklist

从报告中提取可行动事项，转成"今日可打勾"的清单。

**结构**（模板见 [templates/checklist.md](../templates/checklist.md)）：

```markdown
# <topic> — 可执行清单

> 基于：<report.md link>
> 生成时间：YYYY-MM-DD

## 立即可落地（本周）
- [ ] 项 1（来自主报告 §X.X）
- [ ] 项 2（来自主报告 §X.X）

## 流程化（本月）
- [ ] 项 1
- [ ] 项 2

## 需验证假设（对应 hypotheses）
- [ ] H1: <statement> — 证伪条件：<falsifiability>
- [ ] H2: ...

## 定期复查（季度）
- [ ] 项 1 — 建议周期：<时长>
- [ ] 项 2
```

**提取规则**：

1. 从报告结论章抽取 `[R]` 标记段落 → 拆解为 action items
2. 从 skeleton.hypotheses 抽取 id + statement + falsifiability
3. 按置信度分级：High（L1-L2 来源支持）/ Medium（L3）/ Low（L5 或推测）
4. 每项附来源 section 引用

**文件命名**：`<topic-slug>-<YYYYMMDD>-checklist.md`

## 三、adr — Architecture Decision Record

从 technology 类报告中提取"选了什么 / 为什么 / 后果如何"。

**结构**（模板见 [templates/adr.md](../templates/adr.md)）：

```markdown
# ADR-<NNN>: <决策标题>

> 生成时间：YYYY-MM-DD
> 基于调研：<report link>

## 状态
[提议 | 已采纳 | 已废弃 | 已替代]

## 背景
<从调研报告背景章节提取，保留 FIR 中 [F] 的部分>

## 决策
<最终推荐方案 — 报告"推荐排序"第 1 项>

## 理由
<证据链：从结论章节抽取 [I] → [R] 推导>

## 后果
### 正面
- <预期收益，量化>
### 负面
- <新增成本/复杂度>
### 风险
- <已识别风险及缓解>

## 替代方案
<方案对比章节 2-5 项，按得分降序>

## 验证
- [ ] PoC 验证通过
- [ ] 性能达标
- [ ] 团队培训完成
```

**生成规则**：

1. 仅当 `research_type == technology` 或 `--outputs` 含 `adr` 时生成
2. "决策"必须对应报告推荐排序第 1 项
3. "理由"至少 3 条，每条配 source URL
4. "后果"正负必须同时存在（无负面后果 = 不合格 ADR）
5. ADR 编号由用户提供或自动分配 `ADR-<YYYYMMDD>-<topic-slug>`

**文件命名**：`<topic-slug>-<YYYYMMDD>-adr.md`

## 四、decision-tree — 快速选型决策树

从 market / competitive 类报告中提取"如果 X 则选 A"的分支结构。

**结构**（模板见 [templates/decision-tree.md](../templates/decision-tree.md)）：

````markdown
# <topic> 选型决策树

> 基于：<report.md link>
> 生成时间：YYYY-MM-DD

```
问题：<核心问题>
│
├─ 条件 1：<判断条件>（例：QPS > 10万？）
│   ├─ 是 → 方案 A
│   │   └─ 理由：<简述 + 来源 §X>
│   │   └─ 适用边界：<场景>
│   └─ 否 → 条件 2
│       ├─ 是 → 方案 B
│       │   └─ 理由 / 边界
│       └─ 否 → 方案 C
│           └─ 理由 / 边界
```

## 使用说明
1. 从根节点开始
2. 按条件判断走向叶子节点
3. 叶子即推荐方案

## 边界情况
- 当 <特殊条件> 时，本决策树不适用 → 建议人工评估
- 当 <特殊条件> 时，可能多方案并列 → 再比较次要维度
````

**生成规则**：

1. 根问题来自 skeleton.topic + 用户的核心诉求（Stage 2 确认）
2. 每个分支至少 2 层
3. 叶子节点必须标注适用边界（Check 11 因果纪律）
4. 至少给出"本决策树不适用"的边界条件

**文件命名**：`<topic-slug>-<YYYYMMDD>-decision-tree.md`

## 五、poc — PoC 验证模板

从 product / technology 类报告中提取 hypotheses，转成可执行的 PoC 计划。

**结构**（模板见 [templates/poc.md](../templates/poc.md)）：

````markdown
# <topic> PoC 验证模板

> 目标方案：<方案名称>
> 基于：<report.md link>

## 1. 验证目标

| 假设 id | 假设 | 成功标准 | 验证方法 |
|--------|------|---------|---------|
| H1 | <skeleton.hypotheses[0].statement> | <量化标准> | <测试方法> |
| H2 | ... | ... | ... |

## 2. 测试环境

```yaml
硬件: {cpu: ..., memory: ..., disk: ...}
软件: {os: ..., runtime: ..., dependencies: [...]}
数据: {规模: ..., 类型: ..., 来源: ...}
```

## 3. 测试脚本

```bash
# 安装
<cmd>

# 启动
<cmd>

# 测试
<cmd>
```

## 4. 结果记录

| 指标 | 目标 | 实际 | 结论 |
|------|------|------|------|
| <指标1> | <目标值> | ___ | ___ |

## 5. 结论
- [ ] 所有假设验证通过
- [ ] 部分假设失败，需要调整方案
- [ ] 验证失败，需要重新评估
````

**生成规则**：

1. 优先从 `skeleton.hypotheses` 提取假设 + falsifiability 条件
2. 每条假设必须有**量化成功标准**（不接受"性能可接受"、"体验流畅"）
3. 环境必须齐全硬件 + 软件 + 数据三块
4. 测试脚本必须可执行（不接受伪代码）
5. 时间边界建议 1-2 周

**文件命名**：`<topic-slug>-<YYYYMMDD>-poc.md`

## 多输出协调

当 `--outputs` 包含多个物件时，Stage 6 按以下顺序串行渲染：

1. `report` —— 其他物件引用之
2. `checklist` —— 从 report 抽取
3. `adr` —— 从 report 的决策段 + 推荐排序抽取
4. `decision-tree` —— 从 report 的方案对比 + 推荐段抽取
5. `poc` —— 从 skeleton.hypotheses + report 的待验证清单抽取

每个物件独立文件；物件间通过相对路径链接互引（确保归档到 KB 后仍可追溯）。

## 归档行为

- `--no-save` → 输出到控制台，不归档
- tome-forge 已装 → 按 tome-forge 的 `report-archival-protocol.md` 归档，每个物件一条目
- tome-forge 未装 → 仅控制台，输出一行 `[note] tome-forge not installed; outputs printed to console only`
