# Tasks

## Task 1 — protocol 文件升级（canonical + mirror）

**依赖**：无（先改协议，后面 skill 引用稳）

**做什么**：

修改 `skills/tome-forge/references/report-archival-protocol.md` 与
`platforms/openclaw/tome-forge/references/report-archival-protocol.md` 两份：

- L3：`silently skip archival` → `MUST print Archive: skipped (tome-forge not installed) and continue — silent failure is not allowed`
- L36 step 7：扩展为可见输出行 + 跳过原因 enum + Rationale 段

**验证命令**：

```bash
grep -n "silent failure is not allowed\|tome-forge not installed.*KB discovery failed.*--no-save" \
  skills/tome-forge/references/report-archival-protocol.md \
  platforms/openclaw/tome-forge/references/report-archival-protocol.md
# 预期：每份文件至少 2 行命中（L3 + L36+）
```

---

## Task 2 — council-fuse 升级（canonical + mirror）

**依赖**：Task 1 完成

**做什么**：

`skills/council-fuse/SKILL.md`：

- 修改 manifest（约 L7-12）：
  - `filesystem: none → read-write`
  - `tools: [Agent] → [Agent, Read, Write, Glob, Edit]`
  - `argument-hint: "[question or task]" → "[question or task] [--no-save]"`
- 替换 L156-163 整段 `## KB 归档（可选）` 为 `### Stage 4 — KB 归档（必须，除非 --no-save）`

`platforms/openclaw/council-fuse/SKILL.md`：

- 修改 manifest（约 L7-11）：
  - `filesystem: none → read-write`
  - `tools: [] → [Read, Write, Glob, Edit]`（无 Agent，OpenClaw 用三轮单 agent 独立推理）
  - 追加 `argument-hint: "[question or task] [--no-save]"`（mirror 当前缺该字段）
- 在 `## Attribution`（L113）之前 insert `### Stage 4 — KB 归档（必须，除非 --no-save）` 段

**验证命令**：

```bash
grep -n "Stage 4 — KB 归档" skills/council-fuse/SKILL.md platforms/openclaw/council-fuse/SKILL.md
# 预期：每份各一行命中

grep -n "filesystem: read-write" skills/council-fuse/SKILL.md platforms/openclaw/council-fuse/SKILL.md
# 预期：每份各一行
```

---

## Task 3 — news-fetch 升级（canonical + mirror）

**依赖**：Task 1 完成（可与 Task 2 并行）

**做什么**：

`skills/news-fetch/SKILL.md`：

- 修改 manifest（约 L8-11）：
  - `filesystem: none → read-write`
  - `tools: [WebSearch, WebFetch] → [WebSearch, WebFetch, Read, Write, Glob, Edit]`
  - 追加 `argument-hint: "[topic] [time-range] [--no-save]"`（当前缺）
- 替换 L162-170 整段 `## KB 归档（可选）` 为 `### 4. KB 归档（必须，除非 --no-save）`，
  保留增量合并语义（同主题同日期追加合并）

`platforms/openclaw/news-fetch/SKILL.md`：

- 修改 manifest（约 L7-11）：同 canonical
- 追加 `argument-hint: "[topic] [time-range] [--no-save]"`
- 在文件末尾（无 Attribution 段，最后是英文失败输出模板）后 append `### 4. KB 归档（必须，除非 --no-save）` 段

**验证命令**：

```bash
grep -n "4\\. KB 归档" skills/news-fetch/SKILL.md platforms/openclaw/news-fetch/SKILL.md
# 预期：每份各一行

grep -n "argument-hint" skills/news-fetch/SKILL.md platforms/openclaw/news-fetch/SKILL.md
# 预期：每份各一行
```

---

## Task 4 — Version bump + 重算 hash + skill-lint 验证

**依赖**：Task 2 + Task 3 完成

**做什么**：

Bump 3 marketplace 版本号（MINOR：1.0.0 → 1.1.0）：

```bash
python3 -c "
import json
mk = json.load(open('.claude-plugin/marketplace.json'))
bumped = {'council-fuse', 'news-fetch', 'tome-forge'}
for p in mk['plugins']:
    if p['name'] in bumped:
        p['version'] = '1.1.0'
open('.claude-plugin/marketplace.json', 'w').write(json.dumps(mk, indent=4, ensure_ascii=False) + '\n')
"
```

Recalc + lint：

```bash
bash scripts/recalc-all-hashes.sh
# 预期：2 hash(es) updated（council-fuse + news-fetch SKILL.md），6 unchanged

bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：errors 0, warnings 0

# Sanity 版本核对
python3 -c "
import json
mk = json.load(open('.claude-plugin/marketplace.json'))
for p in mk['plugins']:
    if p['name'] in {'council-fuse', 'news-fetch', 'tome-forge'}:
        print(f\"  {p['name']}: {p['version']}\")
"
# 预期：三行都是 1.1.0
```

**Sanity diff** —— 确保 manifest 在两平台间精度一致（除有意分歧）：

```bash
diff <(sed -n '1,15p' skills/council-fuse/SKILL.md) \
     <(sed -n '1,15p' platforms/openclaw/council-fuse/SKILL.md)
# 预期：仅 tools 一行差异（[Agent, ...] vs [Read, ...] —— 有意分歧）

diff <(sed -n '1,15p' skills/news-fetch/SKILL.md) \
     <(sed -n '1,15p' platforms/openclaw/news-fetch/SKILL.md)
# 预期：完全一致
```

---

## Task 5 — Archive RFC + commit

**依赖**：Task 4 全绿

**做什么**：

```bash
mv openspec/changes/archival-mandatory-observable openspec/changes/archive/archival-mandatory-observable

git add -A   # 6 文件 + RFC archive 新增
git commit -m "fix(council-fuse, news-fetch): make KB archival mandatory and observable

- Promote ## KB 归档 from optional trailing section to numbered Stage in workflow
- Require visible 'Archived to KB:' / 'Archive: skipped' output line
- Fix manifest: filesystem none→read-write, tools add Read/Write/Glob/Edit
- Add --no-save flag for explicit opt-out
- Update report-archival-protocol.md: forbid silent skip, enforce visible log line
- Sync to platforms/openclaw mirrors (per platform-parity spec)

RFC archived at openspec/changes/archive/archival-mandatory-observable/.
"
```

**验证命令**：

```bash
git log -1 --pretty=format:"%h %s"
# 预期：新 commit 出现，message 含 "fix(council-fuse, news-fetch)"

git status --short
# 预期：clean

bash skills/skill-lint/scripts/skill-lint.sh .  
# 预期：依旧 0/0/N
```

---

## Task 6 — PR Test Plan（manual verification, 不阻塞 commit）

**依赖**：Task 5 完成

**做什么**：留给用户在 home 装 tome-forge KB 后跑 PR §Test Plan 的 T1-T6（需 runtime
end-to-end 调用，不在 CI / lint 范围内）。

PR description 应贴出 T1 + T2 至少两次跑通的输出（可见 `Archived to KB:` 行 + KB 文件实际生成）。
