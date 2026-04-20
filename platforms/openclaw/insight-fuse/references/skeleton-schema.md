# Skeleton Schema — 骨架数据契约

`skeleton.yaml` 是 insight-fuse v3 的核心输入契约。Stage 0 产出骨架；Stage 1-6 各消费特定字段。**所有阶段对骨架字段只读，不修改**（Stage 2 Align 会覆盖整个骨架文件，但遵循同一 schema）。

## 存储路径

```
~/.forge/insight-fuse/skeletons/<topic-slug>-<YYYYMMDD>.yaml
```

- `<topic-slug>` = topic 全小写，非 `[a-z0-9]` 字符替换为 `-`，压缩连续 `-`，截断 60 字符
- `<YYYYMMDD>` = 创建日期
- 用户可通过 `--skeleton <absolute-path>` 导入外部骨架（团队共享场景）
- 不落 repo，避免污染工作目录

## Schema (schema_version: 1)

```yaml
schema_version: 1                           # 必需；main agent 拒绝加载未知版本

topic: string                               # 必需，verbatim 来自 --topic
research_type: overview                     # 必需，enum:
                                            #   overview | technology | market |
                                            #   academic | product | competitive
created_at: 2026-04-20                      # 必需，ISO date
source: brainstorm | imported | auto        # 必需，生成方式
business_neutral: true                      # 默认 true；显式 --audience 才 false

dimensions:                                 # 必需，≥2 条
  - name: string                            # 分析轴名称
    rationale: string                       # 为什么选这个维度（1 句话）
    weight: 0.0-1.0                         # 综合时的权重
    anchors: [string, ...]                  # Stage 1 查询关键词种子（≥2 个）

taxonomies:                                 # 可选；agent 复用的共享词表
  <term>: string                            # 定义（避免各 agent 发明术语）

out_of_scope:                               # 可选，但强推荐
  - item: string                            # 排除项
    reason: string                          # 排除理由

existing_consensus:                         # 可选；Stage 3 prior context 注入
  - claim: string                           # 已知结论
    confidence: 0.0-1.0                     # 你对该结论的信心
    sources_hint: [url, url]                # 已知的来源线索

known_dissensus:                            # 可选；Stage 5 触发 Disagreement Template
  - claim: string                           # 有争议的命题
    position_a:
      summary: string
      proponents: [string, ...]             # 持此立场的主要来源/流派
      evidence_hint: [url, ...]
    position_b:
      summary: string
      proponents: [string, ...]
      evidence_hint: [url, ...]

hypotheses:                                 # 可选；对应 Stage 3 sub-question
  - id: H1                                  # 唯一 id
    statement: string                       # 可证伪的命题
    falsifiability: string                  # 观察到什么就放弃该假设

audiences: []                               # 仅 --audience 提供时填充
                                            # 每项：{role: string, source: "user-input"}
```

## 字段 × Stage 消费矩阵

| 字段 | Stage 0 | Stage 1 | Stage 2 | Stage 3 | Stage 4 | Stage 5 | Stage 6 |
|------|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| `research_type` | 写入 | 查询模板 | — | 模板选取 | — | perspective 预设 | 权重表 |
| `dimensions` | 写入 | 查询种子 | 投影 sub-question | 每 hypothesis 绑定一维 | — | 章节骨架 | Check 12 骨架保全 |
| `taxonomies` | 写入 | 扩展词 | — | agent prompt 词表 | — | 表格骨架 | 术语一致性 |
| `out_of_scope` | 写入 | negative filter | 公告排除 | "Do not cover" 约束 | — | — | Check 13 比例 |
| `existing_consensus` | 写入 | 跳过重复扫描 | — | **prior context 块（强制）** | — | 背景引用 | — |
| `known_dissensus` | 写入 | — | 标记冲突区 | — | **默认焦点候选 P0** | **三段式自动触发** | Check 12 |
| `hypotheses` | 写入 | — | — | sub-question 源 | 焦点候选（验证型） | 结论分类 | Grade 透明度 |
| `business_neutral` | 写入 | 业务词反向过滤 | 提醒用户 | — | — | — | Check 7 环境隔离 |
| `audiences` | 写入 | — | — | — | — | Advisory Appendix 受众 | Check 9 Appendix |

## 3 个 Worked Example

### Example 1 — overview 类（AI 眼镜）

```yaml
schema_version: 1
topic: "AI 眼镜"
research_type: overview
created_at: 2026-04-20
source: brainstorm
business_neutral: true

dimensions:
  - name: 硬件形态
    rationale: 显示/摄像/音频方案未收敛，是所有叙事起点
    weight: 0.25
    anchors: ["光波导", "micro-OLED", "骨传导", "双目 vs 单目"]
  - name: 场景落地
    rationale: toB vs toC 分野决定商业模式
    weight: 0.20
    anchors: ["always-on 记录", "导航", "字幕", "工业巡检"]
  - name: 生态博弈
    rationale: 平台方（Meta/Apple/字节）vs 初创的竞合格局
    weight: 0.20
    anchors: ["Meta Ray-Ban", "Apple Vision", "字节 PICO", "Rokid"]
  - name: 监管与隐私
    rationale: always-on 摄像的法律边界是规模化前提
    weight: 0.15
    anchors: ["GDPR", "肖像权", "音视频记录合规"]

taxonomies:
  always-on: "硬件支持持续感知/记录，非交互触发"
  私域-公域: "使用环境的隐私分层"

out_of_scope:
  - item: VR 头显
    reason: 形态差异大，另立命题
  - item: 车载 HUD
    reason: 不属于随身形态

existing_consensus:
  - claim: 显示方案尚未收敛
    confidence: 0.85
    sources_hint: ["https://www.counterpointresearch.com/...", "https://www.idc.com/..."]
  - claim: 语音是主交互范式
    confidence: 0.75
    sources_hint: []

known_dissensus:
  - claim: Always-on 拍摄的隐私合法边界
    position_a:
      summary: 需强制指示灯 + 显式同意，否则违反 GDPR 第 6 条
      proponents: ["欧盟数据保护委员会", "部分消费者权益组织"]
      evidence_hint: ["https://edpb.europa.eu/..."]
    position_b:
      summary: 公共空间录影属合理使用，只要当事人不可识别
      proponents: ["Meta Ray-Ban 法务白皮书", "部分美国一方同意州判例"]
      evidence_hint: []

hypotheses:
  - id: H1
    statement: 光波导材料成本 < $50 为 AI 眼镜规模化的必要前提
    falsifiability: 2027 年前出现售价 < $300、销量 > 1M 但仍用 micro-OLED 非光波导的产品
  - id: H2
    statement: 2027-2028 年 always-on 拍摄将出现首个全球性监管裁决
    falsifiability: 2028 年底前全球无任何国家级法规或最高法院判例
```

### Example 2 — technology 类（简化）

```yaml
schema_version: 1
topic: "WebAssembly 在边缘计算的落地"
research_type: technology
created_at: 2026-04-20
source: auto
dimensions:
  - name: 运行时生态
    anchors: ["wasmtime", "wasmer", "WasmEdge"]
    weight: 0.3
  - name: 性能与冷启动
    anchors: ["cold start", "throughput", "wasi"]
    weight: 0.3
taxonomies:
  cold-start: "从 runtime 收到请求到首条响应的延迟"
out_of_scope:
  - item: 浏览器 WASM
    reason: 与边缘计算场景无关
hypotheses:
  - id: H1
    statement: WASM 冷启动 < 10ms 为边缘 FaaS 可行阈值
    falsifiability: 任一主流 runtime 冷启动中位数 > 50ms
```

### Example 3 — academic 类（简化）

```yaml
schema_version: 1
topic: "Sparse Mixture-of-Experts 的可解释性瓶颈"
research_type: academic
created_at: 2026-04-20
source: brainstorm
dimensions:
  - name: 路由可解释
    anchors: ["router attribution", "expert specialization"]
    weight: 0.4
  - name: 训练稳定性
    anchors: ["load balancing", "auxiliary loss"]
    weight: 0.3
existing_consensus:
  - claim: Expert 专业化在训练早期即显现
    confidence: 0.7
    sources_hint: ["https://arxiv.org/..."]
hypotheses:
  - id: H1
    statement: Router 决策可通过 causal intervention 复现
    falsifiability: 对 top-1 expert 做 ablation 后性能保持 ≥ 95%
```

## 版本演进

- `schema_version: 1` 是当前版本
- 新增必需字段 → 必须 bump schema_version
- 新增可选字段 / 扩展 enum → 可不 bump，但在注释里标注 `introduced in v1.x`
- 移除字段 → 必须 bump，并提供迁移脚本或文档
- main agent 遇到 unknown schema_version → 报错并拒绝加载

## 自检

Stage 0 产出骨架后，`insight-methodologist` 默认跑 4 项自检：

1. **placeholder 检测**：是否有 `TODO` / `TBD` / `<填写>` 残留？
2. **一致性**：`taxonomies` 里的术语在 `dimensions.anchors` / `known_dissensus` 中是否一致使用？
3. **范围合理**：`dimensions` 数量 3-7 之间？过少不够覆盖，过多稀释焦点
4. **歧义**：字段是否存在含糊修辞（"significant"、"many"）？替换为具体约束
