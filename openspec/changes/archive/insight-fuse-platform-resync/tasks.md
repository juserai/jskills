# Tasks

## Task 1 — 同步 2 个分歧文件 canonical → platform

**依赖**：无

**做什么**：

```bash
cp skills/insight-fuse/SKILL.md \
   platforms/openclaw/insight-fuse/SKILL.md

cp skills/insight-fuse/references/output-formats.md \
   platforms/openclaw/insight-fuse/references/output-formats.md
```

**验证命令**：

```bash
diff -rq skills/insight-fuse platforms/openclaw/insight-fuse
# 预期：零输出（byte-identical）

bash evals/insight-fuse/run-trigger-test.sh 2>&1 | grep -E "platform mirror|FAIL"
# 预期：
#   OK: platform mirror byte-identical
#   （无 FAIL）

bash evals/insight-fuse/run-trigger-test.sh 2>&1 | tail -2
# 预期：=== ALL CHECKS PASSED === 之类（不再报 FAILED）
```

---

## Task 2 — 增补 platform-parity spec 的 "Per-skill stricter policy" 段

**依赖**：无

**做什么**：

在 `openspec/specs/platform-parity/spec.md` 的 `## Behavior` 段
（具体在 "Hook 在平台版的处理" 之前）插入新小节：

```markdown
### Per-skill stricter policy

某 skill 的 `evals/<skill>/run-trigger-test.sh` MAY enforce byte-identical
mirror 作为自身更严策略，理由 MUST 在
`docs/design/<category>/<skill>-design.md` 论证。

当前 case：
- `insight-fuse`：research 输出对内容漂移敏感，trigger test 用
  `diff -rq skills/insight-fuse platforms/openclaw/insight-fuse`
  enforce byte-identical。

非 byte-identical 策略的 skill 以本 spec 默认的"语义一致"为基线。
```

**验证命令**：

```bash
grep -n "Per-skill stricter policy" openspec/specs/platform-parity/spec.md
# 预期：找到一行

bash skills/skill-lint/scripts/skill-lint.sh . 2>&1 | python3 -c "
import json, sys
d = json.loads(sys.stdin.read())
print(f'errors: {len(d[\"errors\"])}, warnings: {len(d[\"warnings\"])}')
"
# 预期：errors 0, warnings 0（spec 改动不影响 skill-lint）
```

---

## Task 3 — Hash sanity check（应为 no-op）

**依赖**：Task 1/2 完成

**做什么**：

```bash
bash scripts/recalc-all-hashes.sh 2>&1 | grep -v "unchanged"
# 预期：仅 "0 hash(es) updated; 8 unchanged." 等总结行
#       canonical SKILL.md 没改，hash 应当全部 unchanged
```

如果 hash 报有更新，说明 canonical 也被意外改动了——回滚检查。

---

## Task 4 — 收尾

**依赖**：Task 1/2/3 完成

**做什么**：

- [ ] `git status --short` 应当只有 platform sync + spec 改动
- [ ] commit message 风格：`fix: insight-fuse platform mirror resync to canonical + platform-parity spec amend`
- [ ] PR 描述贴出 `bash evals/insight-fuse/run-trigger-test.sh 2>&1 | tail -3` 输出，
      证明 13/13 全过

**验证命令**：

```bash
git status --short | wc -l
# 预期：3-4（2 platform 文件 + spec.md + 可能 marketplace 改动若有）

bash evals/insight-fuse/run-trigger-test.sh 2>&1 | tail -3
# 预期：=== ALL CHECKS PASSED === 或类似全绿信息
```
