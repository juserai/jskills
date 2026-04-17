# Claim Ground — 已验证事实锚点（Anchors）

`~/.forge/claim-ground-anchors.json` 保存**本会话以前已经通过 runtime 证据验证过**的事实锚点。`SessionStart` hook（`hooks/session-anchor.sh`）在新会话 / resume / clear 时把这些锚点作为 `<CLAIM_GROUND_ANCHORS>` 块注入到 context，避免跨会话 / 跨压缩再次把已验证的事实"忘掉重猜"。

## 为什么需要 anchors？

研究背景：[Drift No More? (arXiv 2510.07777)](https://arxiv.org/html/2510.07777v1) 观测 LLM 在长会话中存在 context drift——固定点提醒（goal reminders）把 KL 散度降低 6–12%、判官分数提升 0.5–0.6。Anchors 是这个机制的 Claim Ground 版：**把用户已经纠正过 / 已经确认过的事实固化下来，下次同类问题直接引用**。

## 文件位置

`~/.forge/claim-ground-anchors.json` —— 与 `block-break-state.json` 同目录，运行时创建。不在 Forge 仓库内，也不在 git 版本控制。

## Schema

```json
{
  "session_id": "string, optional — opaque session identifier from harness",
  "last_updated": "ISO-8601 timestamp — used for 7-day staleness check",
  "anchors": [
    {
      "key": "string — 短名，例如 'model' / 'cli-version' / 'repo-main-branch'",
      "value": "string — 事实值，例如 'claude-opus-4-7[1m]' / 'v2.3.1' / 'main'",
      "source": "string — 证据来源，例如 'system-prompt' / '`claude --version` output' / '`git branch --show-current`'",
      "verified_at": "ISO-8601 timestamp"
    }
  ],
  "user_corrections": [
    {
      "wrong": "string — 原来答错的表述",
      "right": "string — 纠正后的正确表述",
      "source": "string — 用户纠正时给的依据或验证命令",
      "corrected_at": "ISO-8601 timestamp"
    }
  ]
}
```

## 生命周期

### 创建
第一次在会话里成功引用 runtime 证据回答一个 live-state 事实问题时，skill **可以**选择写入 anchors：

1. 读或创建 `~/.forge/claim-ground-anchors.json`
2. `jq --arg key X --arg val Y ...` 追加一条 anchor 对象
3. 更新 `last_updated`

写入**不是强制**的——只有在"同类问题可能再次出现"且"答案在本会话窗口内稳定"时才值得固化。一次性问题（"这条命令输出了什么"）不需要。

### 读取
`SessionStart` hook 自动执行：
- startup / resume / clear 触发点都注入 anchors
- 文件不存在 → 静默跳过
- 文件存在但 `last_updated > 7 天` → 静默跳过（防止 stale）
- 文件存在但解析失败（JSON 破损）→ 静默跳过（防御性读）
- 其余 → emit `<CLAIM_GROUND_ANCHORS>` context block

### 过期 / 失效

| 情况 | 动作 |
|------|------|
| `last_updated` > 7 天 | hook 静默跳过；skill 下次 write 会刷新 |
| 用户纠正了某个 anchor（比如 CLI 升级到新版） | **追加** `user_corrections` 条目，不覆盖旧 anchor；下次同类问题以最新 correction 为准 |
| 文件破损 | hook 静默跳过；skill 发现 read 失败时应重建（覆盖写新对象） |

### 单写者契约

为了防止并发损坏：
- **同一时刻只允许一个 claim-ground 激活实例写文件**
- skill 写入时必须读→修改→原子写（写临时文件 + `mv`）
- 不支持 append-only 追加写；每次都完整重写对象

## 适合 anchor 的事实类型

| 类型 | 是否适合 | 原因 |
|------|---------|------|
| 本会话运行的模型 ID | ✅ 适合 | 会话内稳定，session 级 anchor |
| CLI 版本 | ✅ 适合 | 会话内稳定 |
| 项目当前 git branch / commit | ⚠️ 慎用 | 会话内可能变；anchor 时记录 `verified_at` 更重要 |
| 已安装的全局包列表 | ✅ 适合 | 稳定度高 |
| 环境变量值 | ⚠️ 慎用 | 用户可能 `export` 覆盖；短期有效 |
| 用户身份信息 / 邮箱 | ✅ 适合 | 跨会话稳定 |
| 网络服务状态 | ❌ 不适合 | 外部状态，变化快 |
| 当前时间 | ❌ 不适合 | 永远在变 |
| 生态最新模型 | ❌ 不适合 | 需外部查证，不是会话级事实 |

## 示例

### 初次写入

用户第一次在会话里问"当前模型？"，claim-ground 通过系统 prompt 验证了答案，然后决定固化。

```json
{
  "session_id": "abc-123",
  "last_updated": "2026-04-17T10:00:00Z",
  "anchors": [
    {
      "key": "model",
      "value": "claude-opus-4-7[1m]",
      "source": "system-prompt line 'You are powered by the model named Opus 4.7 (1M context). The exact model ID is claude-opus-4-7[1m].'",
      "verified_at": "2026-04-17T10:00:00Z"
    }
  ],
  "user_corrections": []
}
```

### 用户纠正

会话中后来用户说"其实 branch 已经切到 feature/xyz 了，不是 main"，claim-ground 跑 `git branch --show-current` 确认用户对。

```json
{
  "session_id": "abc-123",
  "last_updated": "2026-04-17T10:42:00Z",
  "anchors": [
    {
      "key": "model",
      "value": "claude-opus-4-7[1m]",
      "source": "system-prompt",
      "verified_at": "2026-04-17T10:00:00Z"
    },
    {
      "key": "git-branch",
      "value": "feature/xyz",
      "source": "`git branch --show-current` output",
      "verified_at": "2026-04-17T10:42:00Z"
    }
  ],
  "user_corrections": [
    {
      "wrong": "current branch is main",
      "right": "current branch is feature/xyz",
      "source": "`git branch --show-current` re-run",
      "corrected_at": "2026-04-17T10:42:00Z"
    }
  ]
}
```

### 新会话注入

下次同一 project 开新会话时，SessionStart hook 自动注入：

```
<CLAIM_GROUND_ANCHORS>
[Claim Ground 🎯 — 已验证事实锚点已加载]

Anchors:
  - model: "claude-opus-4-7[1m]" [system-prompt @ 2026-04-17T10:00:00Z]
  - git-branch: "feature/xyz" [`git branch --show-current` output @ 2026-04-17T10:42:00Z]

Prior user corrections (respect these):
  - was "current branch is main" → is "current branch is feature/xyz" [`git branch --show-current` re-run]
</CLAIM_GROUND_ANCHORS>
```

Skill 随后的回答可以直接引用这些 anchor 作为证据源，不必每次都重新跑命令——但当用户**质疑** anchor 时，必须 Red Line 3 重查（anchor 不是免死金牌）。

## 相关文件

- `hooks/session-anchor.sh` — 读 anchors.json、注入 context
- `hooks/session-restore.sh` — 同时运行，负责 Block Break 的压力状态
- `skills/claim-ground/references/red-lines.md` — 被质疑时的重查规则适用于 anchors
- `skills/block-break/` — 状态文件 schema pattern 的参考

## 未来扩展（不在当前 PR 范围）

- PostCompact hook 在 compaction 前也固化 anchors，防止压缩后丢失
- 每个 anchor 绑定 TTL（default 7 天 vs per-key override）
- anchors 导出/导入工具，便于跨 project 迁移
