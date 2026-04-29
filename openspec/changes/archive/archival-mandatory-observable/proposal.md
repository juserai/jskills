# Archival Mandatory + Observable

> 这次 change 解决的张力：council-fuse 和 news-fetch 的 KB 自动归档**在多种 runtime 上沉默失败**——
> 主 agent 跑完综合输出后通常不会执行末尾的"可选"段落，结果用户运行后没有任何归档反馈。

## Why

用户在 OpenClaw 跑 `/council-fuse 阿联酋为什么退出opec` 后：

- 主 agent 输出 `## Council Fuse — Deliberation` + Attribution footer 即终止
- **没有任何 `Archived to KB:` 行**
- KB 目录 `~/.tome-forge/raw/reports/council-fuse/` 也无新文件

历史 logs 铁证：`~/.tome-forge/raw/reports/council-fuse/` 仅 3 个文件，mtime 全部聚集在
`Apr 21 15:22` 一次性手动批量入库——**从未有过 skill 自主归档成功**。

三个根因（按 user PR 诊断）：

1. **末尾"可选"段被自然忽略** —— `## KB 归档（可选）` 是 SKILL.md 最后一节、明确"可选"+"静默"，
   主 agent 输出主答案 + Attribution 后自然停笔
2. **静默语义掩盖故障** —— 协议要求"成功输出一行日志，跳过则无输出"，导致用户**无法分辨**
   归档成功 / 跳过 / 模型根本没跑这段
3. **Manifest 与文档不一致** —— council-fuse manifest 声明 `filesystem: none, tools: [Agent]`，
   但 SKILL.md 后文需要 Read/Write/Glob；news-fetch 同样问题。Claude Code runtime 不强制
   manifest（所以理论上可跑通），OpenClaw 等 strict runtime 直接拒绝——这是定时炸弹

对照基线：`insight-fuse` 归档段挂在主线 Stage 6 内、有 `--no-save` 开关、manifest 正确——
归档反复成功（多条 `[2026-04-22] **archive**` log 行）。

## What Changes

**6 文件改动 + version bump + 1 RFC**：

版本号提升（语义版本：MINOR——新增 `--no-save` flag + 强制可见输出契约，向后兼容）：

- `council-fuse`：1.0.0 → 1.1.0
- `news-fetch`：1.0.0 → 1.1.0
- `tome-forge`：1.0.0 → 1.1.0（协议契约 v1 → v1.1）

文件改动：


- `skills/council-fuse/SKILL.md`：manifest 修正（`filesystem` / `tools` / `argument-hint`）+
  `## KB 归档（可选）` 整段替换为 `### Stage 4 — KB 归档（必须，除非 --no-save）`
- `platforms/openclaw/council-fuse/SKILL.md`：同步 manifest + 新增 Stage 4 段（mirror 当前无归档段）
- `skills/news-fetch/SKILL.md`：manifest 修正 + 新增 argument-hint + KB 段同样升级，保留
  news-fetch 特有的"增量合并"语义
- `platforms/openclaw/news-fetch/SKILL.md`：同步 manifest + 新增 Stage 4 段
- `skills/tome-forge/references/report-archival-protocol.md`：L3 静默语义改强制可见 +
  L36 step 7 扩展为可见输出行 + 跳过原因 enum
- `platforms/openclaw/tome-forge/references/report-archival-protocol.md`：同步

新增 `--no-save` 开关，让用户显式 opt-out。

## Non-goals

继承 user PR 的 §Out of Scope：

- 不改 archival 目录结构（仍 `raw/reports/{skill}/{date}-{slug}.md`）
- 不改 frontmatter schema 字段集（只改协议步骤说明）
- 不为 council-fuse 加 `--depth` / `--no-attribution` 等开关——只加 `--no-save`
- 不改 council members（generalist/critic/specialist）的 agent 定义
- 不触碰 block-break / claim-ground 等其他 forge skill
- 不改 insight-fuse —— PR §Risk 已声明协议升级宽容兼容；后续 minor PR 同步对齐
