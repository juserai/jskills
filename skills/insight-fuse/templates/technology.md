# {topic} 技术调研报告

> 日期：{date} | 基于多源信息综合分析
> Skeleton: {skeleton_file} | dimensions: {dim_count} | known_dissensus: {dis_count} | hypotheses: {hyp_count}

<!--
  FIR legend: [F]=Fact  [I]=Inference  [R]=Recommendation（仅 Advisory Appendix 允许）
  section ratios (technology): 背景 10%, 对比 30%, 分析 35%, 风险 15%, 结论 10%
-->

---

## 一、摘要（TL;DR / 执行摘要）

[F] **核心主张**：_（Governing Thought，一句话回答"So What"）_
[F] **支撑要点**：_（3-5 条，金字塔原理第二层；数量由主题结构决定，不凑数）_
[F] **关键数据**：_（≤ 3 个最能支撑主张的数字 / 引用）_

_摘要遵循金字塔原理（Minto）：结论先行。读者只读这一段也能形成基础判断。_

## 二、背景与目标

[F] {问题量化：当前状态、痛点指标}
[F] {调研边界：包含什么、排除什么（对齐 skeleton.out_of_scope）}
[I] {成功标准：什么样的结果算"调研成功"（SMART 原则）}

## 三、方案对比

[F] {对比表：功能、成熟度、许可证、社区活跃度、性能。同维度横向对比}
[F] {筛选逻辑：从候选清单如何收敛到最终方案集}
[I] {维度一致性说明：每个维度的权重与依据}

## 四、深度分析

[F] {核心架构：关键组件、设计原则、数据流}
[F] {关键代码/接口示例（若适用）}
[F] {性能数据：QPS/TPS、P50/P90/P99、资源消耗、扩展性曲线。Benchmark 环境必须声明}
[I] {架构 trade-off：哪些设计选择导致哪些性能特征}

## 五、风险评估

[F] {技术风险矩阵：可能性 × 影响 × 缓解}
[F] {学习成本：团队上手时间，参考培训资源}
[F] {迁移成本：从旧方案迁移的工作量估算}
[F] {维护成本：长期运维负担}
[F] {供应商锁定风险：专有特性依赖、开源替代可达性}

## 六、生态系统现状

[F] {采用数据、主要用户、社区规模、文档质量}
[F] {集成和插件、标准化进展}

## 七、典型使用场景

[F] {2-3 个具体用例，附实际案例与规模数据}

## 八、发展趋势与路线图

[F] {官方路线图、即将推出的功能、行业发展方向}

## 九、格局启示（中立）

[I] {描述技术格局：路线分化、护城河在哪一层、成熟度拐点、下一步关键瓶颈、被替代风险}
[I] {scenario-conditional 分析：若 A 成立，X 类实现受益；若 B 成立，Y 类受压}

_禁止"对 X 的建议 / 给 X 的启示 / 对我们的启发 / 为 X 设计"、禁止第二人称"你/我们/读者"。如需针对性建议，请通过 --audience 参数触发 Advisory Appendix。_

## 十、参考来源

### 基础调研来源

{Stage 1 + Stage 3 使用的来源}

### 深度调研来源

{Stage 5 使用的来源，如已执行}

独立性声明：{...}

<!--
  Advisory Appendix —— 条件渲染
  仅在用户显式提供 --audience 参数（或 full 模式下交互确认受众）时，main agent 按
  references/research-protocol.md §Advisory Appendix Protocol 追加，每个受众一个 Appendix。
  [R] 段落仅允许在 Advisory Appendix 出现。
-->

---

## 质量评分

{Stage 6 自动插入的 6 维评分块 + A/B/C/D 等级}

> Researched by [forge/insight-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
