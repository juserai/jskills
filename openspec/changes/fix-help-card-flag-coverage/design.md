# Design — fix-help-card-flag-coverage

影响分类：**cross**（修复涉及 6 个 skill 的元数据 + 1 个 lint 规则升级，非单一 skill 改动）。

## 设计决策

### 1. 全部用 patch bump（不 minor）

- **选了什么**：所有 6 skill 都用 `X.Y.Z` 中的 Z (patch) +1
- **为什么不是 minor**：所有改动都是**文档/元数据修复**——help card 多列几行 / frontmatter 加一行 argument-hint。功能契约 0 变更：调用形式、参数语义、子 agent、KB 归档协议全部不变
- **为什么也不是仅 CHANGELOG no-bump**：文档修复改了 SKILL.md 文件 hash → S31 强制 CHANGELOG entry → entry 强制有版本号。零成本走 patch bump

### 2. block-break 的 argument-hint 选项

- **选了什么**：`"[L0|L1|L2|L3|L4] [task description...]"`
- **为什么列具体 level 而不是 `[<level>]`**：S34 启发式只识别 `--flag` 模式不会扫位置参数，但 IDE 内联提示用户能从字面量知道有哪些级别。具体值更友好
- **为什么 task 用 `[task description...]`**：自由文本场景下用占位符语法暗示这是变长字符串

### 3. claim-ground 与 skill-lint 的 argument-hint 选项

- claim-ground: `"[verify <claim>]"` —— 只列手动 mode 1 入口；hook 自动触发不在 IDE inline hint 范围
- skill-lint: `"[path]"` —— 简洁，与 help card body `/skill-lint <path>` 对齐

### 4. insight-fuse 的 11 flag 全列（不分主次）

- **选了什么**：help card "Key flags" 段列出全部 11 flag
- **为什么不分 "Key flags" + "Other flags"**：用户感知不到"Key" vs "Other"差异；分级会让用户误以为 `--no-save` / `--audience` 是次要选项
- **代价**：help card 长度从 ~22 行 → ~32 行，仍可一屏阅读

### 5. S34 warn → error 时机

- **选了什么**：本 change 同 PR 升级
- **为什么不分两步**：6 skill 修完后 S34 输出 0 warnings；如果保留 warn 级，未来回归（如再加 skill 漏列 flag）也只是 warn → 仍然不阻塞 PR → 复发风险
- **为什么不在 add-skill-lint-s34 时直接 error**：当时有 4 个 skill 漏列，error 会让所有 PR 都红包括无关工作；warn 阶段是观察期

### 6. mirror 策略：byte-identical 复制

- canonical SKILL.md 改后 `cp` 到 platforms/openclaw/<skill>/SKILL.md
- 不引入差异化 wording——6 skill 都没有 platform-aware tooling 名差异，byte-identical 最简

## 受影响清单

- **修改**：
  - 6 canonical SKILL.md（block-break / claim-ground / council-fuse / insight-fuse / news-fetch / skill-lint）
  - 6 platform mirrors
  - `.skill-lint.json`：`verify-help-card-flag-coverage` warn → error
  - `.claude-plugin/marketplace.json`：6 version bumps + 6 hash recalc
  - `CHANGELOG.md`：6 patch entries
- **不动**：
  - ralph-boost / tome-forge / peer-fuse 的 SKILL.md
  - 任何 spec.md
  - 任何 references / templates / agents / scripts
  - 任何 docs/user-guide / docs/i18n guide

## Verification

```bash
# 1. 6 个 SKILL.md 的版本号已 bump
for s in block-break claim-ground council-fuse insight-fuse news-fetch skill-lint; do
  grep "$s" .claude-plugin/marketplace.json | grep version
done

# 2. lint 0 errors / 0 warnings
bash skills/skill-lint/scripts/skill-lint.sh . > /tmp/lint.json
python3 -c "import json; d=json.load(open('/tmp/lint.json')); print('errors:', len(d['errors']), 'warnings:', len(d['warnings']))"
# 期望: errors: 0  warnings: 0

# 3. S34 在 error 级别时仍 PASS
python3 -c "import json; d=json.load(open('/tmp/lint.json')); print([p for p in d['passed'] if p.startswith('S34:')])"
# 期望: ['S34: All argument-hint --flags are documented in their help card (canonical + platforms)']
```
