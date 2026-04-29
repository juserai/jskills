# Design

> 影响分类：cross（platform-parity 实例化执行 + 微小 spec 增补）

## 决策 1 — 同步方向：canonical → platform，不反向

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A. canonical → platform**（采纳） | 把 `skills/insight-fuse/` 的 2 文件 cp 到 `platforms/openclaw/insight-fuse/` | `skills/<skill>/` 是规范版（CLAUDE.md 早期分类已确立），platform 是适配；canonical 优先 |
| B. platform → canonical | 把 platform 版的差异迁回 canonical | **拒绝**：platform 版的 description 含 `+ 17 blocking checks` 等具体内容，更冗长但内容相对老旧（v3.1 实施后 canonical 简化了 description）；merge 方向错 |
| C. 三方合并 | 取 platform 与 canonical 的并集 | **拒绝**：会让 description 越来越长；canonical 已经精简过，是有意决策 |

**反例验证**：查看分歧具体内容——`platforms/openclaw/insight-fuse/SKILL.md`
的 description 写 `... 6-dim quality rubric + 17 blocking checks (incl.
primary-source binding / verbatim snippet / numeric reconciliation), and
unified merged report`，比 canonical 多说了 `+ 17 blocking checks` 等
具体特性。canonical 已经选择"用更紧凑的 description 适配 marketplace"，
platform 应该跟随。

## 决策 2 — Spec 增补的位置与措辞

`platform-parity/spec.md` 当前 Behavior 段说"语义一致 vs 内容精简"，
没显式承认 per-skill 可以收紧策略。增补一节：

```markdown
### Per-skill stricter policy

某 skill 的 `evals/<skill>/run-trigger-test.sh` MAY enforce byte-identical
mirror 作为该 skill 自身的更严策略，理由必须在 `docs/design/<category>/<skill>-design.md`
论证。当前案例：

- `insight-fuse`：research 输出对内容漂移敏感，
  trigger test enforce `diff -rq skills/insight-fuse/ platforms/openclaw/insight-fuse/`
  byte-identical。

非 byte-identical 策略的 skill 仍以 platform-parity spec 的"语义一致"
为基线。
```

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A. 显式增补 spec**（采纳） | 让 spec 反映现状，避免"实施 vs 契约"分裂 | 后续读者读 spec 能看见 byte-identical 例外条款 |
| B. 不动 spec | 让 trigger test 自行其是，spec 不管 | **拒绝**：留下"spec 说一致即可、trigger test 说必须 byte"的认知裂缝 |
| C. 把 byte-identical 升到 spec 默认 | 全局收紧 | **拒绝**：违反"零碎修改不引入新约束"原则；其他 skill 没有这种内容敏感性 |

## 决策 3 — Hash 处理

`marketplace.json` 当前 8 条 plugin 全部指向 `./skills/<skill>` —— 没有
为 platforms/openclaw/<skill> 独立条目。所以本次 sync **不需要**重算
任何 hash（hash 锁定的是 canonical SKILL.md，没改 canonical 就没 hash 变）。

`scripts/recalc-all-hashes.sh` 仍可跑作 sanity check，预期 0 update。

## 反例验证（确认 sync 不破坏其他东西）

- canonical SKILL.md 不变 → marketplace hash 不变 ✓
- canonical references 不变 → 用户可见行为不变 ✓
- platform 文件改动 → openclaw 用户读到的 SKILL.md 与 Claude Code 用户
  对齐（之前他们读的是更长的 description，但研究流程相同；对齐后
  description 也精简，研究流程仍相同）→ 用户可见行为对 openclaw
  用户略有变化（description 文本），但功能不变 ✓

## 不采纳的方案

1. **平台版搞文本提取，canonical 保持精简，platform 保持详细**：等于
   维护两份不同的 description ——违反 platform-parity 的"语义一致"
   底线（description 不一致是语义不一致）。
2. **删除 trigger test 的 byte-identical 检查**：把现状合理化掉。
   **拒绝**——insight-fuse 当初选择 byte-identical 是有理由的
   （内容敏感），不应为了消灭红字而放弃严格策略。
