# {topic} 学术调研报告

> 日期：{date} | 基于多源信息综合分析
> Skeleton: {skeleton_file} | dimensions: {dim_count} | known_dissensus: {dis_count} | hypotheses: {hyp_count}

<!--
  FIR legend: [F]=Fact  [I]=Inference  [R]=Recommendation（仅 Advisory Appendix）
  section ratios (academic): Abstract 5-10%, Intro 10-15%, Methods 15-20%, Results 25-35%, Discussion 15-20%, Limitations 10%, Conclusion 5-10%
  硬约束：L5 来源权重归零；每断言溯源到一手论文；DOI / arXiv ID 必填
-->

---

## 一、Abstract（摘要）

[F] **Governing thought**：_（一句话回答研究贡献）_
[F] **Support points**：_（3-5 条核心发现）_
[F] **Key numbers**：_（效应量 / 样本量 / 显著性 ≤3 条）_

## 二、Introduction（引言）

[F] {研究问题：SCQA 开篇 — Situation, Complication, Question, Answer}
[F] {文献 gap：对齐 skeleton.dimensions 的 3-5 条 gap 声明}
[I] {贡献声明：本研究如何填补 gap（对齐 skeleton.hypotheses）}

## 三、Methods（方法论）

[F] {Research design：positivist / interpretivist / mixed}
[F] {Sampling：总体、抽样框、样本量、事前 power analysis（α / power / effect size）}
[F] {Data collection：工具、协议、时间窗口、采集日期}
[F] {Analysis：软件及版本、随机种子、代码仓库 DOI（如适用）}
[F] {Pre-registration status：OSF/AsPredicted link 或说明"未预注册"}

## 四、Results（结果）

[F] {主要发现 1：效应量 + CI + 统计检验 + p / BF 值}
[F] {主要发现 2：同上}
[F] {主要发现 3：同上}
[F] {次要结果（无论方向都披露）：_{avoid selective outcome reporting}_}
[F] {跨来源验证：每关键数据点 ≥ 2 个独立一手来源}

## 五、Discussion（讨论）

[I] {Results 对应 Introduction 的 gap 如何关闭}
[I] {与既有文献的对话：确认 / 反驳 / 调和}
[I] {对 skeleton.known_dissensus 的回应：哪些立场证据支持、哪些受压}

## 六、Limitations & Alternative Interpretations（局限与替代解释）

[F] {三步式：识别限制 → 说明影响 → 未来方向}
[F] {至少两条替代因果解释（confounding / selection / reverse causation）}
[F] {样本代表性局限}
[F] {方法学 trade-off}

## 七、Conclusion（结论）

[I] {回到 research question，给出证据权衡下的回答}
[I] {实际含义（对该学科的 implications，非具体组织建议）}

## 八、参考来源

### 基础调研来源（peer-reviewed + preprint + 官方 docs）

{APA 7 / Chicago Notes-Bibliography 格式；每条带 DOI 或 arXiv ID}

### 深度调研来源

{Stage 5 如已执行，引用独立论文与 systematic review}

独立性声明：{...}

### COI / AI 使用披露

[F] {利益披露：funding, affiliations, gifted authorship flags}
[F] {AI 使用披露：工具、版本、应用阶段、prompt（按 Nature / Science / COPE 要求）}

<!-- Advisory Appendix —— 条件渲染（学术场景下 Appendix 通常不渲染；如用 --audience 必须带 strategy=conservative） -->

---

## 质量评分

{Stage 6 自动插入：academic 权重（falsifiability 0.25, evidence_density 0.20, reproducibility 0.20, source_diversity 0.15, actionability 0.05, transparency 0.15）}

> Researched by [forge/insight-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
