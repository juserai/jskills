# Capability: platform-parity

## Purpose

定义 forge 的"平台 × skill"笛卡尔积广播契约：每加一个 skill MUST
广播到所有现有平台；每加一个平台 MUST 为所有现有 skill 创建适配。
本 spec 把 `skill-lint` 中已有的 `verify-platform-subdirs` 隐式实现
升级为显式契约。

## Behavior

### 平台 × skill 笛卡尔积

设当前 skill 集合为 $S$，平台集合为 $P$，则下列目录 MUST 全部存在：

```
∀ s ∈ S, ∀ p ∈ P:
  skills/<s>/SKILL.md           # 规范版（Claude Code）
  platforms/<p>/<s>/SKILL.md    # 平台适配版
```

当前（截至 2026-04-29）：

- $S = \{$ block-break, claim-ground, council-fuse, insight-fuse, news-fetch,
  ralph-boost, skill-lint, tome-forge $\}$，$|S| = 8$
- $P = \{$ openclaw $\}$，$|P| = 1$
- 因此 `platforms/openclaw/<skill>/SKILL.md` MUST 有 8 份

### 新增 skill 时

新增 `<new-skill>` MUST 同步：

- [ ] `skills/<new-skill>/SKILL.md`（规范版）
- [ ] `platforms/<plat>/<new-skill>/SKILL.md` × 每个现有平台
- [ ] 每个平台版的 references / scripts / agents / hooks **按需镜像**
      （平台版可以精简，但不能缺失对应功能；语义 MUST 一致）
- [ ] `marketplace.json`（每个平台单独的 marketplace 入口）

详见 `skill-lifecycle` spec 场景 A 清单。

### 新增平台时

新增 platform `<new-plat>` MUST 一次性为现有所有 skill 创建适配：

- [ ] `mkdir platforms/<new-plat>/`
- [ ] 为每个现有 skill 创建 `platforms/<new-plat>/<skill>/`：
  - SKILL.md（平台适配版）
  - references/（平台特定内容，按需）
  - scripts/（平台特定脚本，按需）
  - agents/（如需 sub-agent，按需）
- [ ] 在 `README.md` 的安装章节追加该平台说明
- [ ] 在 `.skill-lint.json` 的 `platforms` 数组添加该平台名
- [ ] 若平台有自己的 marketplace 元数据格式，对应文件 MUST 创建

### 平台版与规范版的关系

- 平台版（`platforms/<plat>/<skill>/SKILL.md`）的内容**允许精简**
  （比如适配某平台不支持的字段），但**语义 MUST 一致**
- 平台版 MUST NOT 引入规范版没有的能力（避免暗藏分支行为）
- 修改规范版的 description / metadata.permissions 时 MUST 同步平台版
  （详见 `skill-lifecycle` spec 场景 B）

### Per-skill stricter policy

某 skill 的 `evals/<skill>/run-trigger-test.sh` MAY enforce **byte-identical**
mirror 作为该 skill 自身的更严策略（比本 spec 默认的"语义一致"更严），
理由 MUST 在 `docs/design/<category>/<skill>-design.md` 论证。

当前案例：

- `insight-fuse`：research 输出对内容漂移敏感（描述字段几个 token 不同
  可能影响 model 对场景的理解，进而改变 stage 编排）。trigger test 用
  `diff -rq skills/insight-fuse platforms/openclaw/insight-fuse`
  enforce byte-identical 作为 behavior fingerprint 保护。

非 byte-identical 策略的 skill 仍以本 spec 默认的"语义一致"为基线。
该机制的职责分离：

- **本 spec（platform-parity）**：定义所有 skill × 所有 platform 的
  存在性 + 语义一致底线
- **per-skill trigger test**：可以 enforce 比 spec 默认更严的策略，
  但不能放松 spec 底线

### Hook 在平台版的处理

- Claude Code 的 hook（`skills/<name>/hooks/`）是 Claude Code 平台特定
  机制，**不需要**镜像到其他平台
- 其他平台若有等价机制（如 OpenClaw 的事件钩子），平台版的 SKILL.md MUST
  说明等价实现的位置

## Rationale

- **从隐式到显式**：`verify-platform-subdirs` 已经在 skill-lint 里跑了
  几个月，但没文档说"为什么要这么做"。新人加平台时只能靠看现有代码猜，
  容易做漏
- **"一次性广播全部"是必要的纪律**：如果允许"先加一个 skill 试试，跑通
  再加其他"，长期会出现参差不齐的状态——某些 skill 在某些平台上有、
  某些没有，用户体验破碎
- **语义一致 vs 内容精简**：不要求平台版与规范版**逐字**对齐，但要求
  **能力**对齐；这是"自包含 + 不暗藏分支"的平衡

## Verification

### 自动化

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：verify-platform-subdirs 防线通过
#   - 每个 skills/<s>/ 在每个 platforms/<p>/ 下都有对应目录
#   - 每个目录都有 SKILL.md

# 笛卡尔积人工核对
SKILLS=$(ls skills/ | grep -v '^_')
PLATS=$(ls platforms/)
for s in $SKILLS; do
  for p in $PLATS; do
    test -f "platforms/$p/$s/SKILL.md" || echo "missing: platforms/$p/$s/SKILL.md"
  done
done
# 预期：零输出
```

### 新增 skill 时

- [ ] PR 描述贴出 `find platforms -name SKILL.md | wc -l` 的差值
      （应等于平台数）

### 新增平台时

- [ ] PR 描述贴出 `find platforms/<new-plat> -name SKILL.md | wc -l`
      的值（应等于当前 skill 数）
- [ ] README.md 的安装章节有该平台说明
- [ ] `.skill-lint.json` 的 `platforms` 数组已更新
