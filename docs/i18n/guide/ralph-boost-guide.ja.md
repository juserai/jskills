# Ralph Boost ユーザーガイド

> 5分で始める — AI自律開発ループの停滞を防ぐ

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserai/forge
```

### ユニバーサルワンラインインストール

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/ralph-boost/SKILL.md
```

> **依存関係ゼロ** — Ralph Boostはralph-claude-code、block-break、またはいかなる外部サービスにも依存しません。プライマリパス（Agentループ）は外部依存関係ゼロ、フォールバックパスには`jq`または`python`と`claude` CLIが必要です。

---

## コマンド

| コマンド | 機能 | 使用タイミング |
|---------|------|--------------|
| `/ralph-boost setup` | プロジェクトで自律ループを初期化 | 初回セットアップ |
| `/ralph-boost run` | 現在のセッションで自律ループを開始 | 初期化後 |
| `/ralph-boost status` | 現在のループ状態を表示 | 進捗の監視 |
| `/ralph-boost clean` | ループファイルを削除 | クリーンアップ |

---

## クイックスタート

### 1. プロジェクトを初期化

```text
/ralph-boost setup
```

Claudeが以下を案内します：
- プロジェクト名の検出
- タスクリストの生成（fix_plan.md）
- `.ralph-boost/`ディレクトリとすべての設定ファイルの作成

### 2. ループを開始

```text
/ralph-boost run
```

Claudeは現在のセッション内で直接自律ループを駆動します（Agentループモード）。各イテレーションはタスクを実行するサブエージェントを生成し、メインセッションは状態を管理するループコントローラーとして機能します。

**フォールバック**（ヘッドレス/無人環境）：

```bash
# フォアグラウンド
bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# バックグラウンド
nohup bash ~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. 状態を監視

```text
/ralph-boost status
```

出力例：

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## 仕組み

### 自律ループ

Ralph Boostは2つの実行パスを提供します：

**プライマリパス（Agentループ）**：Claudeは現在のセッション内でループコントローラーとして機能し、各イテレーションでタスクを実行するサブエージェントを生成します。メインセッションは状態、circuit breaker、圧力エスカレーションを管理します。外部依存関係ゼロ。

**フォールバック（bashスクリプト）**：`boost-loop.sh`はバックグラウンドでループ内の`claude -p`呼び出しを実行します。JSONエンジンとしてjqとpythonの両方をサポートし、実行時に自動検出されます。イテレーション間のデフォルト待機時間は1時間（設定可能）。

両方のパスは同じ状態管理（state.json）、圧力エスカレーションロジック、BOOST_STATUSプロトコルを共有しています。

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### 強化されたCircuit Breaker（ralph-claude-codeとの比較）

ralph-claude-codeのcircuit breaker：進捗なしの3回連続ループ後に諦める。

ralph-boostのcircuit breaker：行き詰まった時に**段階的に圧力をエスカレート**し、停止前に6-7ループの自己回復を行う。

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## 期待される出力例

### L0 — 通常実行

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — アプローチ変更

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claudeは前のアプローチを放棄し、**根本的に異なる**方法を試すことを強制されます。パラメータの微調整は認められません。

### L2 — 検索と仮説

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claudeは以下を行う必要があります：エラーを一語一語読む → 50行以上のコンテキストを検索 → 3つの異なる仮説をリストアップ。

### L3 — チェックリスト

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claudeは7ポイントチェックリストを完了する必要があります（エラーシグナルの読み取り、コア問題の検索、ソースコードの読み取り、仮定の検証、逆仮説、最小再現、ツール/メソッドの切り替え）。完了した各項目はstate.jsonに書き込まれます。

### L4 — 秩序だった引き継ぎ

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claudeは最小限のPoCを構築し、引き継ぎレポートを生成します：

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

引き継ぎ完了後、ループは秩序だって終了します。これは「できません」ではなく、「ここが境界線です」ということです。

---

## 設定

`.ralph-boost/config.json`：

| フィールド | デフォルト | 説明 |
|-----------|----------|------|
| `max_calls_per_hour` | 100 | 1時間あたりの最大Claude API呼び出し数 |
| `claude_timeout_minutes` | 15 | 個別呼び出しのタイムアウト |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claudeが利用可能なツール |
| `claude_model` | "" | モデルオーバーライド（空 = デフォルト） |
| `session_expiry_hours` | 24 | セッション有効期限 |
| `no_progress_threshold` | 7 | シャットダウンまでの進捗なし閾値 |
| `same_error_threshold` | 8 | シャットダウンまでの同一エラー閾値 |
| `sleep_seconds` | 3600 | イテレーション間の待機時間（秒） |

### よくある設定調整

**ループを高速化**（テスト用）：

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**ツール権限を制限**：

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**特定のモデルを使用**：

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## プロジェクトディレクトリ構造

```
.ralph-boost/
├── PROMPT.md           # 開発指示書（block-breakプロトコルを含む）
├── fix_plan.md         # タスクリスト（Claudeが自動更新）
├── config.json         # 設定
├── state.json          # 統合状態（circuit breaker + 圧力 + セッション）
├── handoff-report.md   # L4引き継ぎレポート（正常終了時に生成）
├── logs/
│   ├── boost.log       # ループログ
│   └── claude_output_*.log  # イテレーションごとの出力
└── .gitignore          # 状態とログを無視
```

すべてのファイルは`.ralph-boost/`内に保持されます — プロジェクトルートは一切変更されません。

---

## ralph-claude-codeとの関係

Ralph Boostは[ralph-claude-code](https://github.com/frankbria/ralph-claude-code)の**独立した代替品**であり、拡張プラグインではありません。

| 側面 | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| 形態 | スタンドアロンBashツール | Claude Code skill（Agentループ） |
| インストール | `npm install` | Claude Codeプラグイン |
| コードサイズ | 2000行以上 | 約400行 |
| 外部依存関係 | jq（必須） | プライマリパス：ゼロ、フォールバック：jqまたはpython |
| ディレクトリ | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | パッシブ（3ループ後に諦める） | アクティブ（L0-L4、6-7ループの自己回復） |
| 共存 | 可 | 可（ファイル競合ゼロ） |

両方を同じプロジェクトに同時にインストールできます — 別々のディレクトリを使用し、互いに干渉しません。

---

## Block Breakとの関係

Ralph BoostはBlock Breakのコアメカニズム（圧力エスカレーション、5ステップ方法論、チェックリスト）を自律ループシナリオに適応させています：

| 側面 | block-break | ralph-boost |
|------|-------------|-------------|
| シナリオ | インタラクティブセッション | 自律ループ |
| 起動 | フックが自動トリガー | Agentループ/ループスクリプトに組み込み |
| 検出 | PostToolUseフック | Agentループ進捗検出/スクリプト進捗検出 |
| 制御 | フック注入プロンプト | Agentプロンプト注入 / --append-system-prompt |
| 状態 | `~/.forge/` | `.ralph-boost/state.json` |

コードは完全に独立しています。コンセプトは共有されています。

> **参照**：Block Breakの圧力エスカレーション（L0-L4）、5ステップ方法論、7ポイントチェックリストは、ralph-boostのcircuit breakerの概念的基盤を形成しています。詳細は[Block Breakユーザーガイド](block-break-guide.md)を参照してください。

---

## FAQ

### プライマリパスとフォールバックをどう選べばよいですか？

`/ralph-boost run`はデフォルトでAgentループ（プライマリパス）を使用し、現在のClaude Codeセッション内で直接実行されます。ヘッドレスまたは無人実行が必要な場合はフォールバックbashスクリプトを使用してください。

### ループスクリプトはどこにありますか？

forgeプラグインのインストール後、フォールバックスクリプトは`~/.claude/plugins/juserai_forge/skills/ralph-boost/scripts/boost-loop.sh`にあります。任意の場所にコピーしてそこから実行することもできます。スクリプトはjqまたはpythonをJSONエンジンとして自動検出します。

### ループログを表示するには？

```bash
tail -f .ralph-boost/logs/boost.log
```

### 圧力レベルを手動でリセットするには？

`.ralph-boost/state.json`を編集し、`pressure.level`を0、`circuit_breaker.consecutive_no_progress`を0に設定します。または単にstate.jsonを削除して再初期化してください。

### タスクリストを変更するには？

`.ralph-boost/fix_plan.md`を直接編集し、`- [ ] タスク`形式を使用します。Claudeは各イテレーションの開始時にこれを読み取ります。

### Circuit breakerが開いた後に回復するには？

`state.json`を編集し、`circuit_breaker.state`を`"CLOSED"`に設定し、関連するカウンターをリセットしてスクリプトを再実行します。

### ralph-claude-codeは必要ですか？

いいえ。Ralph Boostは完全に独立しており、いかなるRalphファイルにも依存しません。

### どのプラットフォームがサポートされていますか？

現在Claude Code（プライマリパスとしてAgentループ）をサポートしています。フォールバックbashスクリプトにはbash 4+、jqまたはpython、claude CLIが必要です。

### ralph-boostのskillファイルを検証するには？

[Skill Lint](skill-lint-guide.md)を使用します：`/skill-lint .`

---

## ライセンス

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
