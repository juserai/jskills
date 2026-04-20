# {topic} 总纲调研报告

> 日期：{date} | 基于多源信息综合分析
> Skeleton: {skeleton_file} | dimensions: {dim_count} | known_dissensus: {dis_count} | hypotheses: {hyp_count}

<!--
  FIR legend: [F]=Fact  [I]=Inference  [R]=Recommendation（仅 Advisory Appendix）
  section ratios (meta-overview): 定义 10%, 范式变迁 15%, 全景图谱 20%, 代表玩家 15%, 判别框架 10%, 监管 10%, 演进路径 15%, 格局 5%
  硬约束：skeleton-anchored（全 dimensions 覆盖）+ 自包含（不依赖外部 design doc）+ Disagreement Preservation 自动激活
-->

---

## 一、摘要（TL;DR / 执行摘要）

[F] **核心主张**：_（Governing Thought：对主题的全景判断）_
[F] **支撑要点**：_（对齐 skeleton.dimensions 的 3-7 条核心发现）_
[F] **关键数据**：_（≤ 3 个最决定性的数字 / 趋势）_

## 二、定义与判别边界

[F] {主题的定义 / 判别标准（"是什么" + "不是什么"）}
[F] {与邻近概念的区分（对齐 skeleton.taxonomies）}
[I] {边界模糊处的 trade-off：为什么 A 算、B 不算}

## 三、驱动力与范式变迁

[F] {历史脉络：从前代范式到当前范式的转折点}
[F] {驱动力：技术 / 经济 / 社会 / 监管 四层}
[I] {范式变迁不可逆性：哪些是拐点、哪些是回摆}

## 四、全景图谱（对齐 skeleton.dimensions）

[F] {为每个 skeleton.dimension 提供一个 section，3-5 子点}
[F] {跨 dimension 的交叉表/矩阵（3+ 维度时必选）}

## 五、代表玩家 / 案例

[F] {头部玩家表：名称、切入角度、规模、独特贡献}
[F] {长尾玩家抽样：至少 2 个非头部案例，防 survivorship bias}

## 六、判别框架（诊断工具箱）

[F] {主题特有的快速诊断 checklist（Remove-it test / ACH / pre-mortem 等适用的）}
[I] {框架适用边界：哪些场景框架失效}

## 七、监管与合规

[F] {现有法规与政策}
[F] {未来 12-24 个月监管窗口}

## 八、演进路径与路线图

[F] {短期（1 年）、中期（3 年）、长期（5 年）三段式展望}
[I] {每段的关键变量 / 拐点信号（可证伪）}

## 九、已知分歧（Disagreement Preservation）

_本节自动由 Stage 5 渲染。对齐 skeleton.known_dissensus，每项以立场 A / 立场 B / 综合判断三段式呈现。禁止合成共识。Check 12 blocking。_

{对每个 known_dissensus[i]：

```markdown
#### <claim>

**立场 A**：<summary>
- 持方、证据、逻辑链 [F]→[I]

**立场 B**：<summary>
- 持方、证据、逻辑链 [F]→[I]

**综合判断**：
- 在 X 条件下 A 成立；在 Y 条件下 B 成立
- 或：证据不足，需 Z 才能决断
```

}

## 十、格局启示（中立）

[I] {产业趋势、护城河结构、赢家类型、潜在颠覆点}
[I] {scenario-conditional 分析："若 A 成立，X 类受益；若 B 成立，Y 类受压"}
[I] {hypotheses 验证状态：每条 skeleton.hypotheses 标"已验证 / 已证伪 / 待定"+ 当前置信度}

_禁止第二人称与针对性建议；如需 advisory 请通过 --audience 参数。_

## 十一、参考来源

### 基础调研来源

{Stage 1 + Stage 3 使用的来源}

### 深度调研来源

{Stage 5 使用的来源，如已执行}

独立性声明：{...}

<!-- Advisory Appendix —— 条件渲染（meta-overview 常配多个 audience Appendix） -->

---

## 质量评分

{Stage 6 自动插入：industry 权重（source_diversity 0.20, actionability 0.25）}

> Researched by [forge/insight-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
