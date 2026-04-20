# Disagreement Preservation Template（snippet）

此模板是 **snippet**，非独立报告模板。Stage 5 Critic agent 在焦点命中 `skeleton.known_dissensus[i]` 时，将本模板内容内联渲染到报告对应 section。Check 12（Framework preservation）扫描此结构。

## 模板

```markdown
#### <claim 核心命题>

**立场 A**：<summary 一句话>
- 持方：<proponents — 主要来源/学派/代表机构>
- 证据：
  - [F] <fact 1>（[source](url)）
  - [F] <fact 2>（[source](url)）
- 逻辑链：
  - [I] 基于 <fact>，推出 <conclusion>
  - [I] 该推论成立的前提是 <assumption>

**立场 B**：<summary 一句话>
- 持方：<proponents>
- 证据：
  - [F] <fact 1>（[source](url)）
  - [F] <fact 2>（[source](url)）
- 逻辑链：
  - [I] 基于 <fact>，推出 <conclusion>
  - [I] 该推论成立的前提是 <assumption>

**综合判断**：
- **条件式结论**：在 <条件 X> 下，立场 A 成立；在 <条件 Y> 下，立场 B 成立
- 或 **证据不足判定**："当前证据不足以决断；需观察 <Z 数据/事件> 才能倾向某一方"
- 或 **时间维度判定**："短期（1-2 年）立场 A 占优，长期（5 年+）立场 B 更可能"

**禁止**的综合判断模式：

- ❌ "两者都有道理" — 无条件的折中
- ❌ "取中间值" — 对定量分歧取平均
- ❌ 未呈现完整 A/B 就跳到"综合" — 丧失可追溯性
```

## 示例（基于 AI 眼镜的 always-on 拍摄隐私合法性）

```markdown
#### Always-on 拍摄的隐私合法边界

**立场 A**：Always-on 摄像需强制指示灯 + 显式同意，否则违反 GDPR 第 6 条合法处理基础
- 持方：欧盟数据保护委员会（EDPB）、Noyb 等消费者权益组织、德国汉堡州数据保护官 2024 函件
- 证据：
  - [F] EDPB 2024 年发布 Guidelines 05/2024 明确"无差别公共记录"属高风险处理（[EDPB Guidelines](url)）
  - [F] 汉堡州数据保护官 2024 Q3 对 Ray-Ban Meta 发起合规问询（[Reuters 报道](url)）
- 逻辑链：
  - [I] GDPR 第 6 条将合法处理基础限制为 6 种；Always-on 场景无法事先取得第三方 consent
  - [I] 该推论的前提是"公共场合录影属个人数据处理范畴"，此前提在德国 2024 判例中已被确立

**立场 B**：公共空间录影属合理使用，只要当事人不可识别即合规
- 持方：Meta Ray-Ban 法务白皮书、部分美国"一方同意州"判例（如加州外其他 38 州）
- 证据：
  - [F] Meta 2024 白皮书引用 ECHR von Hannover 案确立"公共场所合理期待"原则（[Meta Whitepaper](url)）
  - [F] 美国 38 州允许一方同意录音录影，无须全员 consent（[Reporters Committee](url)）
- 逻辑链：
  - [I] 若场景属"public with no reasonable expectation of privacy"，录影不构成隐私侵犯
  - [I] 该推论前提是"美国/部分欧洲司法辖区的个人数据框架不覆盖无个人识别的公共录影"

**综合判断**：
- **条件式结论**：在**欧盟** + **Always-on + 可个人识别** 的组合下，立场 A 占优；在**美国一方同意州** + **无个人识别** 的组合下，立场 B 占优。其他组合（欧盟 + 无个人识别 / 美国 + 明确侵权）判定依赖个案
- **时间维度**：2027-2028 有望出现首个欧盟高院判例，届时立场 A 获体系化强化；立场 B 在美国联邦层面仍缺乏统一立法
```

## 触发规则

Stage 5 Main agent 按以下顺序决定是否渲染本模板：

1. **优先**：焦点直接命中 `skeleton.known_dissensus[i].claim` → 强制渲染
2. **次级**：Stage 3 各 agent 的 KEY_FINDINGS 在某节点有显著分歧（≥ 2 个立场，每个立场有独立证据）→ Critic 自主启用
3. **不触发**：所有 agent 对某节点共识（3 个 KEY_FINDINGS 对齐）→ 使用常规综合算法（[perspectives.md](../references/perspectives.md) §五）

## 与 Check 12 的契合

Shell 校验：

```bash
count=$(yq '.known_dissensus | length' ~/.forge/insight-fuse/skeletons/<slug>.yaml)
rendered_a=$(grep -c "^\*\*立场 A\*\*\|^\*\*Position A\*\*" report.md)
rendered_b=$(grep -c "^\*\*立场 B\*\*\|^\*\*Position B\*\*" report.md)
synthesis=$(grep -c "^\*\*综合判断\*\*\|^\*\*Synthesis\*\*" report.md)

[ "$rendered_a" -ge "$count" ] && \
[ "$rendered_b" -ge "$count" ] && \
[ "$synthesis" -ge "$count" ] || echo "Check 12 FAIL"
```

任一数量少于 `known_dissensus` 数 → Check 12 fail，重写直到满足。
