# Scoring Rubric — 6 维正交评分 + 14 项 blocking check

v3 报告质量尺。Stage 6 QA 跑完 14 项 check 后，按 6 维公式计算总分，映射为 A/B/C/D 等级，插入报告 footer。

## 一、6 维正交框架

来源：调研方法论文献收敛的跨学术/产业/政策三大传统的 6 个正交维度。任何一维都不是充分条件；合格报告在所有 6 维都达阈值。

| 维度 | 核心判据 | 评分依据 |
|------|---------|---------|
| **falsifiability**（可证伪性） | 命题必须在原则上可经验证伪（Popper） | Critic 的 FALSIFICATION_CONDITIONS 覆盖率；hypotheses.falsifiability 填充度 |
| **evidence_density**（证据密度） | 每实证主张有可追溯一手来源 | inline citation 数 / 段落数；L1-L2 来源占比 |
| **reproducibility**（可复现性） | 方法、数据、工具可被独立复现 | 方法论披露完整度；数据/链接/版本号；timestamp 标注 |
| **source_diversity**（来源多样性） | 独立来源覆盖多库 / 多语言 / 多立场 | 来源数量；独立性链完整度（Check 10）；跨语言覆盖 |
| **actionability**（可行动性） | 结论可转化为决策或后续行动 | Outlook 段 scenario-conditional 深度；Advisory Appendix 质量（若有） |
| **transparency**（透明度） | 方法、局限、利益、AI 使用全披露 | limitations 段存在；COI 披露；AI 使用标注 |

每维 **0-10** 分，采用**分段式评分**：

| 分段 | 0-3 | 4-6 | 7-8 | 9-10 |
|------|-----|-----|-----|------|
| falsifiability | 无可证伪条件 | 部分 hypothesis 有证伪条件 | 所有 hypothesis + Critic 覆盖 | 全 claim-level 可证伪，含 pre-registration 锚 |
| evidence_density | < 1 cite/section | 1-2 cite/section | ≥ 3 cite/section，L1-L2 > 40% | ≥ 5 cite/section，L1-L2 > 60%，零未引用主张 |
| reproducibility | 无方法披露 | 工具名提及 | 版本 + 参数 + 数据源 | 全链路可复现（代码/数据/配置） |
| source_diversity | < 3 来源或单源占比 > 60% | 3-5 来源，单源占比 40-60% | 6+ 来源，单源 ≤ 30%，跨类型 | 10+ 来源，跨语言 + 跨立场，独立性链完整 |
| actionability | 仅描述现状 | 含 implications | scenario-conditional outlook | 具体 recommendation + 策略梯度（Appendix 合规） |
| transparency | 无 limitations | limitations 简述 | limitations + COI + 方法披露 | 含 AI 使用披露 + 反立场考量 + 边界声明 |

## 二、加权公式

```
total = Σ (dim_score × weight_i) / Σ weight_i × 10
```

权重按 `research_type` 分 academic vs industry 两档：

| 维度 | academic 权重 | industry 权重 |
|------|:-:|:-:|
| falsifiability | 0.25 | 0.15 |
| evidence_density | 0.20 | 0.15 |
| reproducibility | 0.20 | 0.10 |
| source_diversity | 0.15 | 0.20 |
| actionability | 0.05 | 0.25 |
| transparency | 0.15 | 0.15 |
| **Σ** | **1.00** | **1.00** |

`research_type` 属性：

- **academic**：`academic`
- **industry**：`overview` / `technology` / `market` / `product` / `competitive`

## 三、等级映射

| Grade | 区间 | 意义 |
|-------|-----|------|
| **A** | 8.5 - 10.0 | 可直接采用，达到发表/决策标准 |
| **B** | 7.0 - 8.4 | 合格，建议补充关键缺口后使用 |
| **C** | 5.5 - 6.9 | 局部可用，需针对低分维度返工 |
| **D** | < 5.5 | 不及格，建议重写或换 type |

任一 blocking check 失败（Check 1-14 中任一未过）→ Grade 封顶 D，无论 6 维得分多高。

## 四、14 项 blocking check（Stage 6 全扫）

| # | Name | 校验 | Shell 验证命令 |
|---|------|------|-----------|
| 1 | Source density | 每节 ≥ 2 citation | `grep -cE "^\\[" report.md` |
| 2 | Reference integrity | inline citation 全在 reference list | `diff <(grep -oE "\\(https?://[^)]+\\)" report.md \| sort -u) <(awk '/^### 参考来源/,/^---/' report.md \| grep -oE "https?://[^)]+" \| sort -u)` |
| 3 | Source diversity | 单源 ≤ 40% 任一 section 内 | 按 section 统计 URL 频次 |
| 4 | Evidence-backed | 比较/排序断言必带数据 | 模式扫描（`faster\|leads\|outperforms` 等关键词附近 100 字符内必有 URL） |
| 5 | Date line | header 有 `> 日期：YYYY-MM-DD` | `grep -cE "^> 日期：20[0-9]{2}" report.md` ≥ 1 |
| 6 | Attribution | footer 有 forge attribution | `grep -c "Researched by.*forge/insight-fuse" report.md` ≥ 1 |
| 7 | Environment isolation | 无未授权专名 | grep against `--audience` + `--focus` + 用户 msg 白名单 |
| 8 | Neutral body | 主体（首个 `---` 前）无"针对 X 建议" | `grep -nE "(对\|给)[^。]*(的)?(建议\|启示)\|对我们的启发\|为[^。]*(设计\|打造)" body.md` 为空 |
| 9 | Advisory Appendix integrity | 若有 Appendix，6 节结构全齐 | 按 `## Appendix` 切块，验证每块含受众画像/调研依据/推导链/策略梯度/风险与反事实/行动清单 |
| 10 | Source independence | 独立性声明存在且合理 | `grep "独立性声明：" report.md` ≥ 1 |
| 11 | Causal claim discipline | 因果断言含 ≥3 替代解释 | 因果关键词 + 后续 100 字符内含"替代解释\|confounding\|selection\|reverse causation" |
| 12 | Framework preservation | `skeleton.known_dissensus` 每项渲染三段式 | `grep -c "立场 A\|Position A" report.md` ≥ `jq -r '.known_dissensus \| length' skeleton.yaml` |
| 13 | Structure-ratio compliance | 章节字数在模板 ±30% | `awk '/^## /{sec=$0; next}{wc[sec]+=NF}END{for (s in wc) print s, wc[s]}' report.md` 与 template 声明比例对比 |
| 14 | FIR separation | 段首标 `[F]`/`[I]`/`[R]` | `grep -cE "^\\[F\\]\|^\\[I\\]\|^\\[R\\]" report.md` == 段落总数 |

Check 1-11 的详细出处、例外、失败处理见 [quality-standards.md](quality-standards.md)。

## 五、评分块模板

Stage 6 在报告 footer 自动插入：

```markdown
---

## 质量评分

| 维度 | 分数 | 权重（<type> weighting） | 贡献 |
|------|:-:|:-:|:-:|
| Falsifiability | 8 | 0.15 | 1.20 |
| Evidence density | 9 | 0.15 | 1.35 |
| Reproducibility | 6 | 0.10 | 0.60 |
| Source diversity | 8 | 0.20 | 1.60 |
| Actionability | 7 | 0.25 | 1.75 |
| Transparency | 8 | 0.15 | 1.20 |
| **Total** | | | **7.70 / 10** |

**Grade**：**B**（建议补充 reproducibility 披露：具体 WebSearch 查询词、访问日期、版本号）

**Blocking checks**：14 / 14 passed（[Check 5 失败则在此列出]）
```

## 六、失败处理

| 情形 | 行为 |
|------|------|
| Blocking check 1-14 任一失败 | 重写对应 section，重查；最多 2 轮，第 3 轮仍失败则输出并标 `QA-FAILED: <check-ids>` header |
| 6 维某维 < 4 分但 total ≥ 7 | 保留 Grade 但在评分块标"低分维度"，列补救建议 |
| 6 维某维 < 4 分且 total < 7 | Grade 降 1 档（B→C），强制给出返工方向 |
| `--no-save` + Grade D | 输出到控制台但拒绝归档到 KB |

## 七、示例

假设 overview 类报告：

- falsifiability=8, evidence_density=9, reproducibility=6, source_diversity=8, actionability=7, transparency=8
- 权重（industry）：0.15, 0.15, 0.10, 0.20, 0.25, 0.15
- 贡献：1.20 + 1.35 + 0.60 + 1.60 + 1.75 + 1.20 = **7.70**

→ Grade **B**。低分维度：reproducibility。补救建议：补上"调用时间、WebSearch 查询词、访问日期"三项；补完重跑即可升到 A。

若同样报告但 research_type=academic：

- 权重：0.25, 0.20, 0.20, 0.15, 0.05, 0.15
- 贡献：2.00 + 1.80 + 1.20 + 1.20 + 0.35 + 1.20 = **7.75**

→ 同样 B。学术语境下 reproducibility 权重更高（0.20 vs 0.10），因此补救优先级更靠前。
