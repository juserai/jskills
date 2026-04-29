# Design

> 影响分类：cross（跨 council-fuse / news-fetch / tome-forge protocol，不归属任何单一 forge 4 分类）

## 决策 1 — Heading 级别 H2 → H3 (Stage 同级)

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A（采纳）** | `### Stage 4` 与 Stage 1/2/3 同级 H3 | 模型按编号顺序执行的概率远高于"末尾可选段"；Stage 编号是 LLM 强信号 |
| B | 保留 `## KB 归档` H2 | **拒绝**：H2 节标题"可选"信号难以根除；模型容易把末尾 H2 视作"附录"而跳过 |

证据：grep 确认 council-fuse Stage 1/2/3 在 L60/93/101 皆 H3；news-fetch Stage 1/2/3 在
L71/92/99 皆 H3。`### Stage 4` 与现有 stage 序号无缝衔接。

**反例验证**：claim-ground 一个 H3 误判事件、insight-fuse 反复归档成功的对比——可见
"在工作流序号内"是激活该步骤的有力信号。把归档塞进 stage 序列 ≈ 强迫主 agent 按顺序执行。

## 决策 2 — 强制可见输出行 + 跳过原因 enum

PR 提出 4 种跳过场景：

```
{tome-forge not installed, KB discovery failed, --no-save flag, protocol read failed}
```

**采纳**：在 protocol §3.2 显式列举 enum，让 council-fuse / news-fetch 引用同一字符串。

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A（采纳）** | enum 列在 protocol 单一来源 | grep 时关键词唯一；将来加新原因只在 protocol 改一次 |
| B | 各调用 skill 自己造跳过原因短语 | **拒绝**：将来 grep "Archive: skipped" 看不到完整 mapping；同样故障各 skill 表达不一致 |

**反例验证**：current 协议 step 7 只规定 `Archived to KB: {filepath}`，没规定跳过场景的输出
格式——这就是 bug 1 的语义层来源。enum 化把"跳过"提到与"成功"同等可见性。

## 决策 3 — Platform sync 必须包含

per platform-parity spec 的"语义一致"基线，3 文件改动必须 broadcast 到 openclaw 镜像（共 6 文件）。

**取舍**：

- **A（采纳）**：sync 全部 6 文件
- B：仅 canonical，留 mirror 旧状态 → **拒绝**：制造新分歧；strict-runtime（如 OpenClaw 强制 manifest）
  的用户拿不到修复，反而踩 bug 3 更严重

注意：openclaw council-fuse mirror **当前没有 KB 归档段**（grep 验证），需要 ADD 而不是 modify；
news-fetch mirror 同样无该段。这是历史 stale 而非有意精简——openclaw mirror 的"intentional 分歧"
仅记录于 council-fuse 的 `## 与 Claude Code 版的区别` 段（关于 Agent spawning 机制），不涉及归档。

## 决策 4 — 保留 news-fetch 特有的"增量合并"语义

news-fetch 现 KB 段 step 4 是"增量更新：同主题同日期追加合并（同一天多次获取取并集去重）"。

**保留**——PR §2.2 显式要求"逻辑改动与 council-fuse §1.2 完全对称但保留 news-fetch metadata
字段"，没要求删合并语义。news-fetch 是 quench 类，单日多次拉取是常见用法，合并比版本化更对路。

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A（采纳）** | news-fetch 保持增量合并；council-fuse 沿用 protocol 默认（版本化） | 各 skill 选择最适合自己使用模式的归档语义 |
| B | 全部统一为版本化（council-fuse 协议默认） | **拒绝**：news-fetch 同日多次会产生大量近似版本，污染 KB |

## 决策 5 — 不动 insight-fuse

PR §3.2 升级 protocol 后，insight-fuse 现行实现可能不打印 `Archived to KB:` 行（历史 logs 显示
insight-fuse 反复成功归档但没有可见输出行约束）。

**采纳 PR §Risk 缓解**：协议升级是宽容的（多出输出行只是更好，不是不兼容），本次不强制
insight-fuse 立即同步。后续 minor PR 同步对齐。

## 决策 6 — manifest tools 字段在两平台间的差异

| Skill | canonical (Claude Code) | mirror (OpenClaw) |
|-------|------------------------|-------------------|
| council-fuse | `[Agent, Read, Write, Glob, Edit]`（Agent 给 Stage 1 并行议员） | `[Read, Write, Glob, Edit]`（OpenClaw 用三轮独立推理，无 Agent spawn） |
| news-fetch | `[WebSearch, WebFetch, Read, Write, Glob, Edit]` | 同 canonical |

council-fuse 的 mirror 不需要 `Agent` —— 这是 mirror 已记录的有意分歧（`## 与 Claude Code 版的区别`
说明 OpenClaw "单 agent 内三轮独立推理"），与本次修复的 manifest 工具集差异是连贯的。

## 不采纳的方案

1. **完全删除 KB 归档段，让用户手动调 `/tome-forge ingest`**：违反"自动归档"产品诉求；
   修复策略相反，是要让自动归档**真正自动**起来
2. **trigger test enforce 归档 mock 验证**：单测用 mock 文件系统验证归档调用流程。
   **拒绝**：本次 fix 是文档 + manifest 层修改，无运行时代码改动；mock 测试有限的覆盖度
   抵不过维护成本——交给 PR Test Plan T1-T6 的 runtime 端到端测试足够
3. **统一两个 KB heading 风格（council-fuse 改 `### 4. KB 归档`、news-fetch 改 `### Stage 4`）**：
   各 skill 自己 stage 风格不同（council-fuse 用 `Stage N — 标题`、news-fetch 用 `N. 标题`），
   保留各自风格更尊重既存约定
