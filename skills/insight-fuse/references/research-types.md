# Research Types — 6 类调研预设

`--type <name>` 参数激活一个预设包。预设声明默认模板、perspectives、来源权重、特有 checks。**显式传入的 `--template` / `--perspectives` / `--sections` 覆盖预设对应字段，其余继承**。

## 决策树

| 用户问的是什么 | 选哪个 type |
|---------------|------------|
| "…怎么看 / 全景 / 判别框架" | `overview` |
| "…选型 / 架构对比 / 性能" | `technology` |
| "…市场规模 / 趋势 / 增长" | `market` |
| "…peer-reviewed / 方法学 / 学术" | `academic` |
| "…产品机会 / user job / PMF" | `product` |
| "…竞品 / SWOT / 定位" | `competitive` |

默认 `overview`（最安全的通用型）。

## 预设矩阵

| type | 默认 template | 默认 perspectives | Source 权重倾斜 | 特有 check | 默认 `--sections` |
|------|-------------|------------------|----------------|----------|-----------------|
| `overview` | meta-overview | generalist+critic+specialist | 均衡，加 meta-critic stance | skeleton-anchoring + multi-angle coverage | report,checklist |
| `technology` | technology | generalist+critic+specialist | 官方 docs×2 / arxiv×1 / GitHub×1 | 学习/迁移/维护成本 + 锁定风险 | report,adr,checklist |
| `market` | market | generalist+specialist+futurist | 行业报告×2 / 财报×2 / SEC×1 | 市场规模+增长+驱动 | report,decision-tree,checklist |
| `academic` | academic | generalist+critic+methodologist | peer-reviewed×3 / preprint×2 | 每断言溯源到一手论文 + pre-registration | report,checklist |
| `product` | product | user+designer+business | 用户研究×2 / 评测×1 / case×2 | user quote / journey / JTBD | report,checklist,poc |
| `competitive` | competitive | generalist+critic+strategist | 财报×2 / 竞品官网×2 / 分析师报告×1 | SWOT + 定位矩阵 + 护城河 | report,decision-tree |

## 详细说明

### overview — 总纲/全景调研

适用：跨行业、跨维度的"认知图景"类话题（AI Native、AI 眼镜、Agent 化、能源转型）。

- **Template**：`templates/meta-overview.md` — 定义/判别 + 范式变迁 + 全景图谱 + 代表玩家 + 路线图
- **Perspectives**：generalist（广度）+ critic（反叙事）+ specialist（技术/数据锚点）
- **特有行为**：Stage 0 骨架支持 7 字段全开（dimensions + taxonomies + known_dissensus 等），Stage 5 自动激活 Disagreement Preservation
- **Check 强化**：Check 12（Framework preservation）对所有 `known_dissensus` 项生效

### technology — 技术选型调研

适用：技术栈对比、架构评估、性能/生态评测（WebAssembly、Kubernetes、向量数据库）。

- **Template**：`templates/technology.md` — 背景与目标 10% + 方案对比 30% + 深度分析 35% + 风险评估 15% + 结论建议 10%
- **Perspectives**：generalist + critic + specialist（specialist 强制 ≥1 comparison matrix / data table）
- **特有 check**：
  - 学习成本：评估团队上手时间
  - 迁移成本：从旧方案迁移的工作量估算
  - 维护成本：长期运维负担
  - 锁定风险：专有特性、供应商绑定
- **默认 `--sections`**：加 `adr`（Architecture Decision Record）便于决策落地

### market — 市场调研

适用：市场规模、行业趋势、玩家分布、增长驱动力（AI Agent 市场、SaaS 增长、xR 硬件）。

- **Template**：`templates/market.md` — 市场背景 15-20% + 竞品分析 30-40% + 用户/需求 15-20% + 定价/变现 10-15% + 趋势/展望 10-15%
- **Perspectives**：generalist + specialist（行业数据）+ futurist（3-5 年趋势）
- **源权重**：行业报告（Gartner/IDC/Counterpoint）×2 + 上市公司财报 ×2 + SEC 披露 ×1
- **特有 check**：
  - 市场规模必须含 TAM/SAM/SOM 至少一个
  - 增长率必须含 CAGR
  - 驱动力必须与规模相互印证（不能只有规模没有驱动）

### academic — 学术/方法学调研

适用：同行评审文献综述、方法论评估、证据链回溯（模型可解释性、实验设计）。

- **Template**：`templates/academic.md` — abstract / methods / results / discussion / limitations
- **Perspectives**：generalist + critic + methodologist（方法学审查）
- **源权重**：peer-reviewed（Nature/Science/PNAS/ACM 期刊）×3 + preprint（arXiv/bioRxiv）×2；news 权重降为 0.2
- **特有 check**：
  - 每断言溯源到一手论文（不接受二手博客/综述）
  - Pre-registration 友好：对实证主张标注"事前声明"或"事后观察"
  - DOI / arXiv ID 必填
  - 引用格式偏好 APA 7 或 Chicago Notes-Bibliography

### product — 产品研究

适用：User job / PMF / 产品机会识别（AI 副驾、笔记应用、工具链）。

- **Template**：`templates/product.md` — user job / solution fit / competitive wedge / moat / go-to-market
- **Perspectives**：user（需求方）+ designer（体验）+ business（商业化）
  - 非文件化 stance，由 generalist 注入对应描述
- **源权重**：用户研究报告 ×2 + 产品评测 ×1 + 落地 case ×2
- **特有 check**：
  - 必须含 user quote 或 journey map
  - JTBD（Jobs-to-be-Done）框架落地
  - `--sections` 默认加 `poc` 便于验证

### competitive — 竞品分析

适用：竞品梳理、护城河、定位战（AI Coding 赛道、搜索引擎、云厂商）。

- **Template**：`templates/competitive.md` — 玩家地图 + 核心能力对比 + SWOT + 定位矩阵 + 护城河分析
- **Perspectives**：generalist + critic + strategist
- **源权重**：对标公司财报 ×2 + 官网/产品页 ×2 + 第三方分析师 ×1
- **特有 check**：
  - SWOT 四象限齐全
  - 定位矩阵至少 2 轴（价格×性能 / 开放×封闭 / toB×toC）
  - 护城河至少识别 2 类（技术/数据/网络/品牌/切换成本）

## Perspective stance-override 机制

非 generalist/critic/specialist/methodologist 的 perspective（futurist / strategist / user / designer / business / optimist / pessimist / pragmatist / domestic / international / regulatory）**不单独建 agent 文件**，而是通过 generalist + stance prompt 注入：

```
You are acting as a <stance> perspective. Your investigation must emphasize:
<stance_description — 1-3 句>

Your output structure follows agents/insight-generalist.md, but all findings
are framed through the <stance> lens.
```

stance_description 示例（可扩展到 `perspectives.md` 的 stance registry）：

- **futurist**：聚焦 3-5 年不可逆拐点（技术成熟度 / 成本曲线 / 监管窗口）
- **strategist**：护城河、平台效应、不可复制的资源结构
- **user**：job-to-be-done、workflow 摩擦点、替代方案的切换成本
- **designer**：交互成本、认知负荷、可用性启发
- **business**：单位经济、变现路径、渠道结构
- **optimist / pessimist / pragmatist**：同一事实的三种基准假设
- **domestic / international / regulatory**：政策视角的地域分层

## 源可靠性分档（v3.1）

Check 15-17（Primary-source binding / Verbatim snippet / Numeric reconciliation）按 `--depth` × `--type` 组合决定执行模式：

- **blocking**：失败 → 重写或 reject；Grade 封顶 D
- **advisory**：失败 → 在 `QA-FAILED` header 标 `<id>-ADVISORY` 但不封顶 Grade，只扣对应维度分数

| `--type` / `--depth` | quick | standard | deep | full |
|---|---|---|---|---|
| `overview` | adv / adv / adv | **block** / adv / adv | **block** / **block** / **block** | **block** / **block** / **block** |
| `technology` | adv / adv / adv | **block** / adv / adv | **block** / **block** / **block** | **block** / **block** / **block** |
| `market` | **block** / **block** / **block** | **block** / **block** / **block** | **block** / **block** / **block** | **block** / **block** / **block** |
| `academic` | **block** / **block** / **block** | **block** / **block** / **block** | **block** / **block** / **block** | **block** / **block** / **block** |
| `product` | adv / adv / adv | **block** / adv / adv | **block** / **block** / **block** | **block** / **block** / **block** |
| `competitive` | adv / adv / adv | **block** / adv / adv | **block** / **block** / **block** | **block** / **block** / **block** |

单元格三项按 C15 / C16 / C17 顺序，`block` = blocking，`adv` = advisory。

**设计原则**：

1. `market` / `academic` 一律严：前者是钱流的数字、后者是学术声明的原始文献，口径错成本极高
2. `quick` 对非 market/academic 全 advisory：快速探索不应被源刚性拖慢
3. `standard` 对 C15（白名单）刚性起步：最廉价的一道闸，基本不增加 WebFetch 次数
4. `deep` / `full` 全刚性：用户已主动投入深度预算，质量阈值拉满
5. 白名单未命中不立即 reject——降一级并标 `tier-uncertain`，防止封闭白名单冻结新源

**用户强制切换**（可选未来扩展）：`--source-strict` / `--source-lenient` 参数覆盖本表；当前版本未实现，预留 flag。

## 覆盖与叠加

- **显式 `--template X`** 覆盖预设 template
- **显式 `--perspectives a,b,c`** 覆盖预设 perspectives（fallback 机制仍生效）
- **显式 `--sections a,b`** 覆盖预设 sections
- 未显式指定的字段全部继承预设
- 未指定 `--type` → 默认 `overview`

## 扩展新 type

1. 在本文件新增预设行（表格 + 详细说明段）
2. 创建对应 `templates/<type>.md`（参考 [custom-example.md](templates/custom-example.md) 结构）
3. 在 [research-protocol.md](research-protocol.md) 的 Auto-Structure Algorithm 添加该 type 的分支
4. 在 `evals/insight-fuse/scenarios.md` 添加一条场景
5. 若需特有 check，在 [quality-standards.md](quality-standards.md) 追加 Check 编号（从 15 起）
