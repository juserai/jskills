# Insight-Fuse Platform Mirror Resync

> 这次 change 解决的张力：`platforms/openclaw/insight-fuse/` 与
> `skills/insight-fuse/` 在 SKILL.md 与 references/output-formats.md
> 两个文件上分歧，违反该 skill 自己 trigger test 的 byte-identical 契约。

## Why

`evals/insight-fuse/run-trigger-test.sh` 的 `[9/13]` 步骤执行：

```bash
if diff -rq "$SKILL_DIR" "$OPENCLAW_DIR" > /tmp/insight-fuse-diff.out 2>&1; then
    echo "  OK: platform mirror byte-identical"
else
    echo "FAIL: platform mirror diverged"
    ERRORS=$((ERRORS + 1))
fi
```

当前 `diff -rq` 输出：

```
Files skills/insight-fuse/SKILL.md and platforms/openclaw/insight-fuse/SKILL.md differ
Files skills/insight-fuse/references/output-formats.md and platforms/openclaw/insight-fuse/references/output-formats.md differ
```

该 trigger test 的失败是**预存在**的（`bootstrap-openspec-and-restructure`
change 没有引入或恶化分歧）。但既然 trigger test 选择了 byte-identical
策略（比 platform-parity spec 的"语义一致"更严），就应该让事实匹配
契约。

insight-fuse 选择更严策略的合理性：**research 输出对内容漂移敏感**——
即使 SKILL.md description 字段几个 token 不同，可能影响 model 对场景的
理解，进而改变 stage 编排。byte-identical 是一种"behavior fingerprint"
保护。

## What Changes

**文件同步**：

- `cp skills/insight-fuse/SKILL.md platforms/openclaw/insight-fuse/SKILL.md`
- `cp skills/insight-fuse/references/output-formats.md platforms/openclaw/insight-fuse/references/output-formats.md`

**Spec 增补**（小幅）：在 `platform-parity/spec.md` 的 Behavior 段
增加一节 "Per-skill stricter policy"，显式承认 trigger test 可以
enforce 比 spec 默认更严的策略（byte-identical），并以 insight-fuse
作为 case study。

**Hash 处理**：marketplace.json 中 insight-fuse 条目的
`integrity.skill-md-sha256` 锁定 `skills/insight-fuse/SKILL.md` 的 hash
（已验证 marketplace 只有 8 个 canonical 条目，无 openclaw 独立条目），
sync 不影响 hash。

## Non-goals

- 不改 canonical 版（`skills/insight-fuse/`）任何字节
- 不改 trigger test 的 byte-identical 策略——sync 是为了让事实匹配
  现有契约，不是为了协商更宽松的策略
- 不为其他 skill 添加 byte-identical trigger test——insight-fuse 的
  严格策略由其内容敏感性证成，不是 forge 普适规则
- 不整体重写 platform-parity spec——只增补一节，主体保留"语义一致"
  作为基线
- 不在 skill-lint 加新规则——byte-identical 检查留给 per-skill trigger
  test，避免把"insight-fuse 的特化策略"误升为全局规则
