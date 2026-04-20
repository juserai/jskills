# Multi-Perspective Framework

Main agent 如何对多视角响应评分、共识分析、综合成统一报告段落。

## 一、Core Perspectives（4 个文件化角色）

| Perspective | Focus | Model | 唯一贡献 | 对应 agent 文件 |
|-------------|-------|-------|---------|----------|
| **Generalist** | 广度、主流共识、跨领域综合 | sonnet | 完整覆盖、易懂上下文 | `agents/insight-generalist.md` |
| **Critic** | 缺口、风险、反证、Disagreement Preservation | opus | 偏差检测、来源核验、漏项分析、证伪纪律 | `agents/insight-critic.md` |
| **Specialist** | 深度、一手来源、数据/基准 | sonnet | 技术精度、具体数字、专家细节、comparison matrix | `agents/insight-specialist.md` |
| **Methodologist** | Stage 0 骨架构造；academic 类方法学审查 | sonnet | dimensions / taxonomies / hypotheses 设计；pre-registration 习惯 | `agents/insight-methodologist.md` |

## 二、Stance Perspectives（非文件化，stance-override 机制）

非核心 perspective 通过 generalist + stance prompt 注入，不建单独 agent 文件。避免 agent 文件膨胀，同时保留预设灵活性。

### Stance Registry

| Stance | 描述（注入 generalist prompt） | 预设用途 |
|--------|----------------------------|----------|
| `futurist` | 聚焦 3-5 年不可逆拐点：技术成熟度曲线、成本趋势、监管窗口、人才结构转变 | market preset |
| `strategist` | 护城河分析、平台效应、不可复制资源、竞争格局演化 | competitive preset |
| `user` | Job-to-be-Done、workflow 摩擦点、替代方案切换成本、用户原声 | product preset |
| `designer` | 交互成本、认知负荷、可用性启发、场景识别 | product preset |
| `business` | 单位经济、变现路径、渠道结构、利润池 | product preset |
| `optimist` | 假设障碍可克服，聚焦上行情景与机会窗 | Futures set |
| `pessimist` | 假设风险放大，聚焦下行情景与结构性壁垒 | Futures set |
| `pragmatist` | 基准情景，权衡已知 trade-off，不假设极端 | Futures set |
| `domestic` | 本国政策、监管、市场分割视角 | Policy set |
| `international` | 跨境比较、国际标准、地缘博弈视角 | Policy set |
| `regulatory` | 合规路径、政策演变、执法重点视角 | Policy set |

### Stance-Override Prompt 模板

当 `--perspectives` 指定非核心 stance（如 `futurist`）时，main agent 注入：

```
You are acting as a <stance> perspective.
Your investigation of the topic must emphasize:
<stance description from Stance Registry>

Output structure follows agents/insight-generalist.md (INSIGHT_RESPONSE v2).
All findings are framed through the <stance> lens.
```

## 三、Built-in Perspective Sets

`--perspectives` 未指定时，按 `research_type` 预设（见 [research-types.md](research-types.md)）：

| Set | Perspectives | Research Type 默认 |
|-----|-------------|-------------------|
| Default | generalist, critic, specialist | overview, technology |
| Market | generalist, specialist, futurist | market |
| Academic | generalist, critic, methodologist | academic |
| Product | user, designer, business | product |
| Competitive | generalist, critic, strategist | competitive |
| Futures | optimist, pessimist, pragmatist | 用户手动指定 |
| Policy | domestic, international, regulatory | 用户手动指定 |

## 四、Scoring Dimensions

评估每条匿名 response 4 个研究专用维度，0-10 分：

| Dimension | 评估 | 0 | 5 | 10 |
|-----------|------|---|---|-----|
| **Accuracy** | 来源质量 + 事实正确性 | 无来源或可证为错 | 大多正确，部分弱源 | 全断言经权威来源验证 |
| **Coverage** | 主题广度、涵盖面 | 只触及片段 | 涵盖主要点，遗漏部分角度 | 全面，无重要缺项 |
| **Depth** | 技术细节、数据精度 | 浅表概览 | 合理细节，部分数据 | 专家级，具体数字 + 分析 |
| **Objectivity** | 偏差检测、平衡呈现 | 单一视角、营销语言 | 多数平衡，轻微偏差 | 多视角，冲突被明确承认 |

### Scoring Rules

1. **独立评分** — 每条 response 先各自打分，再跨比较
2. **惩罚未引用** — 无 inline citation 的事实主张扣 Accuracy
3. **奖励缺口识别** — 有意义的 GAPS_IDENTIFIED 改进 Coverage
4. **权衡源质量** — L1-L2 在 Accuracy 上高于 L3-L5
5. **EVIDENCE_CHAIN 完整度** — v2 新增：每 KEY_FINDING 在 EVIDENCE_CHAIN 对应条目齐全 → Accuracy +1
6. **Stance 一致性** — 自定义 stance 必须与其 Stance Registry 描述一致，漂移扣 Objectivity

### Accuracy 加权公式（L1-L5）

`SOURCES_USED` 的 credibility tag 映射到 5 级权重：

| credibility | 等级 | 权重 |
| :-: | :-: | :-: |
| `official docs` / primary / 原始数据 | L1 | 1.0 |
| `peer-reviewed` | L2 | 0.9 |
| `industry report` | L3 | 0.7 |
| `news coverage` | L4 | 0.5 |
| `blog/opinion` | L5 | 0.2 |

**Accuracy 分 = round( Σ(weight_i) / N × 10 , 0)**，N = SOURCES_USED 条数，上限 10。

**硬性封顶**：

- 全部 L5 → Accuracy ≤ 4（0.2 × 10 = 2 起步，最高 4，无论内容多好）
- 有 L1/L2 且无 Check 10 失败 → Accuracy 可达 8+
- `content_support: placeholder` 占比 > 30% → Accuracy 再扣 2 分（AI 幻觉风险）
- **academic type 下 L5 权重归零**（不允许博客作为学术论据）

**例**：SOURCES_USED = [L1, L2, L4] → Accuracy = round((1.0 + 0.9 + 0.5) / 3 × 10, 0) = 8

### Score Matrix Output

```markdown
| Dimension      | Response A (perspective) | Response B (perspective) | Response C (perspective) |
|----------------|------------------------|------------------------|------------------------|
| Accuracy       | X | X | X |
| Coverage       | X | X | X |
| Depth          | X | X | X |
| Objectivity    | X | X | X |
| **Total**      | XX | XX | XX |
```

## 五、Synthesis Algorithm

### Step 1: Anonymize

剥离 PERSPECTIVE 标签，随机分配 Response A/B/C。随机化防位置偏差。

### Step 2: Score

按 4 维评分规则。

### Step 3: Consensus Analysis

| Pattern | Condition | Action |
|---------|-----------|--------|
| **Strong consensus** | 3 个 KEY_FINDINGS 全部对齐 | 高信心。最高分作 skeleton |
| **Majority + dissent** | 2 对齐，1 分歧 | 中信心。多数派作 skeleton，显式评估异见 |
| **Three-way split** | 3 方分歧 | 低信心。最高分作 skeleton，**自动套 Disagreement Preservation Template** |

**硬约束**：若焦点命中 `skeleton.known_dissensus[i]` → 不经此路径，直接套 Disagreement Preservation Template（Check 12 blocking）。

### Step 4: Synthesize

1. **选 skeleton**：最高总分作结构基础
2. **富化**：非 skeleton response 中提取 skeleton 未含的独特 insight，验证后整合
3. **保留异议**：Critic 的 GAPS_IDENTIFIED + 反证变成 risk / limitation 段落
4. **调和冲突**：优先 Accuracy 更高者。若打平（差 ≤ 1 分）→ 两立场并呈
5. **Disagreement Preservation 优先**：对 `known_dissensus` 项和 three-way split，禁止"取平均"，强制三段式

### Step 5: Format

将综合内容整合入报告段落，Stage 5 深度段落加 perspective attribution 摘要。所有段落按 FIR 三层分隔标 `[F]` / `[I]` / `[R]`（主体禁 `[R]`）。

## 六、Custom Perspectives

1. **第 1 优先级**：在 Stance Registry（本文件 §二）追加 stance 描述，使用 stance-override 机制
2. **第 2 优先级**（必须独立建 agent 文件时）：创建 `agents/insight-<name>.md` 按 agent template（frontmatter + role + constraints + INSIGHT_RESPONSE 契约）
3. `--perspectives <name1,name2,...>` 激活（最少 2，最多 5）
4. 未命中 stance registry 也无 agent 文件 → fallback 为 generalist + `<name>` label
5. 所有自定义 perspective 使用同一 INSIGHT_RESPONSE v2 格式 + 4 维评分

## 七、Anti-Patterns

1. **Average positions** — 综合不是折中。只有合理时才 merge；对 `known_dissensus` 强制 Disagreement Template
2. **Inflate consensus** — 真分歧就说真分歧，禁粉饰
3. **Ignore the critic** — GAPS_IDENTIFIED 必须显式评估
4. **Fabricate disagreement** — 全对齐时承认共识，禁发明冲突
5. **Over-synthesize simple topics** — 研究收敛时简洁综合胜过啰嗦重复
6. **Stance drift** — 自定义 stance 必须贯彻全 response；漂移回 generalist 缺省视角扣 Objectivity
7. **FIR 滥用** — `[R]` 不得出现在主体，只在 Advisory Appendix（Check 14 blocking）
