# 18-Flag Taxonomy

跨格式适用的 18 类质量缺陷 flag。Stage 2-3 启发式扫描 + Stage 4 panel 复核共同填充。

## 严重度

- **high**：严重影响结论可信度；通常导致维度分扣 ≥ 2
- **med**：方法学瑕疵；扣 1-2
- **low**：可读性 / 边界细节；扣 0.5-1
- **info**：信息性观察；不扣分

## 编码方案

`F-<CATEGORY>-<NN>`，category ∈ {EVD, STAT, LOGIC, SCOPE, COST, METHOD, DISAGREE, CONSTRUCT, CITE, CONF, DELTA, STRUCT}。

## Flag 详表

| Code | Flag | 严重度 | 检测方式 | 适用格式 |
|---|---|:-:|---|:-:|
| F-EVD-01 | 单源量化主张 | high | 同一定量 claim 仅 1 个 support | all |
| F-EVD-02 | 真 URL + 伪内容 | high | panel methodologist 抽样验证主张 vs 引用片段；md/html 可自动跑 link 抓取，pdf/docx/pptx 需人审 | all |
| F-EVD-03 | 缺实验元数据（model_version / prompt / n） | med | 量化 claim 缺三件套之一 | all |
| F-EVD-04 | replication-tier 缺标 | med | 每个核心发现需 preliminary/replicated/strongly_replicated 一个标注（详见 [replication-tier.md](replication-tier.md)）| all |
| F-STAT-01 | ρ / 百分比区间均化 | med | 检测 "ρ ≈ 0.3-0.4" 但未给极值 | all |
| F-STAT-02 | 跨源数值差异未协调 | med | variance > 5% 但无 reconciliation | all |
| F-LOGIC-01 | FIR 标签缺 / [R] 入正文 | low | 段落级 grep | md（IF-style only）|
| F-LOGIC-02 | 单边构念解释（不区分构念多元 vs 信度） | med | 启发式 + 子 agent 复核 | all |
| F-SCOPE-01 | OOS 邻接溢出 | med | OOS 关键词扫描 + 警示语缺失 | all |
| F-COST-01 | Eng 推荐缺成本-收益 | low | 当 actionability 维权重 ≥ 0.13 时强制 | all |
| F-METHOD-01 | 新方法缺边界条件 | med | "升级版 / 部分优于" 模式 + 缺场景维度 | all |
| F-DISAGREE-01 | 分歧被融合为单结论 | high | known_dissensus 渲染缺 Position A / B | all |
| F-DISAGREE-02 | 仅一方有 best evidence | med | Position A vs B 证据条目数差距 > 2 | all |
| F-CONSTRUCT-01 | 同构念基准对内 ρ 低未讨论 | low | benchmark 对照 + 缺 reliability 段 | all |
| F-CITE-01 | 引用密度低 | low | md/html < 2/section；pdf < 4/page；pptx < 1/slide（参考类幻灯片除外）| all |
| F-CITE-02 | source_diversity 单源占比 > 40% | med | 域名 / 作者 dedup 计数 | all |
| F-CONF-01 | 自评与实测差 ≥ 1 grade | info | 仅信息性，提示 self-eval blind spot；frontmatter 无 self_grade 字段时跳过 | all |
| F-DELTA-01 | 新版 vs 旧版主张冲突未声明 | low | tome-forge `prior_versions` 字段 + diff | all |

## 检测来源分工

| 检测 stage | 负责的 flag |
|---|---|
| Stage 1 结构审 | F-CITE-01（引用密度）|
| Stage 2 证据审 | F-EVD-01 / F-EVD-04 / F-CITE-02 |
| Stage 3 逻辑审 | F-STAT-01 / F-STAT-02 / F-LOGIC-01 / F-LOGIC-02 / F-SCOPE-01 / F-DISAGREE-01 / F-DISAGREE-02 / F-CONSTRUCT-01 |
| Stage 4 panel | F-EVD-02 / F-EVD-03 / F-COST-01 / F-METHOD-01 |
| Stage 7 归档前 | F-CONF-01 / F-DELTA-01（需 frontmatter 字段或 prior_versions）|

## 与 IF 19 check 的对照（部分重叠）

| peer-fuse flag | IF check |
|---|---|
| F-EVD-03 | C16 verbatim evidence |
| F-EVD-04 | (unique to peer-fuse) |
| F-STAT-02 | C17 数字调和 |
| F-LOGIC-01 | C14 FIR separation |
| F-DISAGREE-01 | C12 framework preservation |
| F-CITE-02 | C3 source diversity |

> 重叠不冲突——IF check 是 IF 内部 self-check，peer-fuse flag 是跨 skill 外审专用。Stage 6.5 reviewer 仍跑 IF 19 check；peer-fuse 跑自己的 18 flag。
