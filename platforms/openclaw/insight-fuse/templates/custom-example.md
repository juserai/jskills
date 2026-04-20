# {topic} 调研报告

> 日期：{date} | 基于多源信息综合分析
> Skeleton: {skeleton_file} | dimensions: {dim_count} | known_dissensus: {dis_count} | hypotheses: {hyp_count}

<!--
  自定义模板指南 / Custom Template Guide:

  1. 复制此文件并重命名为 your-template-name.md
  2. 替换下方章节为你需要的结构
  3. 使用占位符：
     - {topic} / {date} — 自动替换
     - {skeleton_file} / {dim_count} / {dis_count} / {hyp_count} — 从 skeleton.yaml 注入
  4. 保持中文数字编号（一、二、三...）
  5. 每段首标 [F] / [I]；[R] 仅允许出现在 Advisory Appendix
  6. 最后必须含「参考来源」+ 独立性声明 + forge attribution
  7. 在 HTML 注释中声明 section ratios（Check 13 会按此校验）
  8. 使用 /insight-fuse --template your-template-name 激活

  FIR legend: [F]=Fact  [I]=Inference  [R]=Recommendation（仅 Appendix）
  section ratios: <声明各章节目标占比>

  Example: /insight-fuse --template custom-example "AI 伦理框架"

  Skeleton hooks:
  - 章节骨架可对齐 skeleton.dimensions（每个 dimension 一个 section）
  - out_of_scope 在「范围边界」节声明
  - known_dissensus 触发 Disagreement Preservation Template（见 templates/disagreement-preservation.md）
  - hypotheses 在结论段标注"已验证 / 已证伪 / 待定"
-->

---

## 一、摘要（TL;DR / 执行摘要）

[F] **核心主张**：_（Governing Thought，一句话回答 So What）_
[F] **支撑要点**：_（3-5 条，覆盖核心发现 / 格局 / 关键变量）_
[F] **关键数据**：_（≤ 3 个最能支撑主张的数字 / 引用）_

_摘要遵循金字塔原理（Minto）：结论先行。_

## 二、背景与定义

[F] {该主题的背景介绍和核心定义}
[F] {范围边界：对齐 skeleton.out_of_scope}

## 三、现状分析

[F] {当前状态、关键数据、主要参与方}
[I] {结构性变量识别}

## 四、核心发现（对齐 skeleton.dimensions）

[F] {调研中最重要的发现，用数据支撑}
[F] {每个 skeleton.dimension 一节或一段}

## 五、已知分歧

_若 skeleton.known_dissensus 非空，本节由 Stage 5 自动渲染立场 A / 立场 B / 综合判断三段式（Check 12 blocking）。_

## 六、挑战与风险

[F] {面临的主要挑战和潜在风险}

## 七、格局启示（中立）

[I] {描述行业 / 技术 / 市场格局}
[I] {scenario-conditional 分析："若 A 成立，X 类玩家受益"}
[I] {hypotheses 验证状态}

_禁止第二人称与针对性建议；如需 advisory 请通过 --audience 参数。_

## 八、参考来源

### 基础调研来源

### 深度调研来源

独立性声明：{...}

<!-- Advisory Appendix —— 条件渲染 -->

---

## 质量评分

{Stage 6 自动插入}

> Researched by [forge/insight-fuse](https://github.com/juserai/forge) — `claude plugin add juserai/forge`
