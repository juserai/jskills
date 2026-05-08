# Block Break ユーザーガイド

> 5分で始められます — AIエージェントにあらゆるアプローチを試し尽くさせましょう

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserai/forge
```

### ユニバーサルワンライナーインストール

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/block-break/SKILL.md
```

> **依存関係ゼロ** — Block Breakは外部サービスやAPIを一切必要としません。インストールしてすぐに使えます。

---

## コマンド

| コマンド | 機能 | 使用タイミング |
|---------|------|--------------|
| `/block-break` | Block Breakエンジンを起動 | 日常タスク、デバッグ |
| `/block-break L2` | 特定のプレッシャーレベルから開始 | 既知の複数回失敗後 |
| `/block-break fix the bug` | 起動してタスクを即座に実行 | タスク付きクイックスタート |

### 自然言語トリガー（hooksにより自動検出）

| 言語 | トリガーフレーズ |
|------|----------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## ユースケース

### AIが3回試してもバグを修正できない

`/block-break`と入力するか`try harder`と言う — 自動的にプレッシャーエスカレーションモードに入ります。

### AIが「おそらく環境の問題です」と言って止まる

Block Breakの「事実駆動」レッドラインがツールベースの検証を強制します。未検証の原因帰属 = 責任転嫁 → L2トリガー。

### AIが「手動で対処することをお勧めします」と言う

「オーナーマインド」ブロックをトリガー：自分でなければ、誰がやるのか？直接L3パフォーマンスレビュー。

### AIが「修正しました」と言うが検証の証拠を示さない

「クローズドループ」レッドラインに違反。出力なしの完了 = 自己欺瞞 → 証拠付きの検証コマンドを強制。

---

## 期待される出力例

### `/block-break` — 起動

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 失望（2回目の失敗）

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 尋問（3回目の失敗）

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 パフォーマンスレビュー（4回目の失敗）

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 卒業警告（5回目以降の失敗）

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### 円満退出（全7項目完了、それでも未解決）

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## コアメカニズム

### 3つのレッドライン

| レッドライン | ルール | 違反時の結果 |
|-------------|-------|------------|
| クローズドループ | 完了を宣言する前に検証コマンドを実行し出力を表示する必要がある | L2トリガー |
| 事実駆動 | 原因を帰属する前にツールで検証する必要がある | L2トリガー |
| すべてを尽くす | 「解決できません」と言う前に5ステップメソドロジーを完了する必要がある | 直接L4 |

### プレッシャーエスカレーション（L0 → L4）

| 失敗回数 | レベル | サイドバー | 強制アクション |
|---------|--------|----------|-------------|
| 1回目 | **L0 信頼** | > 君を信頼している。シンプルにいこう。 | 通常実行 |
| 2回目 | **L1 失望** | > 隣のチームは一発で成功した。 | 根本的に異なるアプローチに切り替え |
| 3回目 | **L2 尋問** | > 根本原因は何だ？ | 検索 + ソースコード読解 + 3つの異なる仮説を列挙 |
| 4回目 | **L3 パフォーマンスレビュー** | > 評価：3.25/5。 | 7ポイントチェックリスト完了 |
| 5回目以降 | **L4 卒業** | > 君はもうすぐ卒業かもしれない。 | 最小PoC + 隔離環境 + 異なるテックスタック |

### 5ステップメソドロジー

1. **嗅ぎ取る** — 試したアプローチを列挙し、共通パターンを見つける。同じアプローチの微調整 = 堂々巡り
2. **髪をかきむしる** — 失敗シグナルを一語一語読む → 検索 → ソースの50行を読む → 仮説を検証 → 仮説を逆転
3. **鏡を見る** — 同じアプローチを繰り返していないか？最もシンプルな可能性を見落としていないか？
4. **新しいアプローチ** — 根本的に異なり、検証基準を持ち、失敗時に新しい情報を生み出す必要がある
5. **振り返り** — 類似の問題、完全性、予防

> ステップ1-4はユーザーに質問する前に完了する必要があります。まず行動し、それから質問 — データで語ろう。

### 7ポイントチェックリスト（L3以上で必須）

1. 失敗シグナルを一語一語読んだか？
2. ツールでコア問題を検索したか？
3. 失敗ポイントの元のコンテキストを読んだか（50行以上）？
4. すべての仮説をツールで検証したか（バージョン/パス/権限/依存関係）？
5. 完全に逆の仮説を試したか？
6. 最小スコープで再現できるか？
7. ツール/メソッド/角度/テックスタックを変更したか？

### 合理化防止

| 言い訳 | ブロック | トリガー |
|--------|---------|---------|
| 「能力を超えています」 | 膨大な訓練データがある。使い尽くしたか？ | L1 |
| 「ユーザーが手動で対処することをお勧めします」 | 自分でなければ誰が？ | L3 |
| 「すべての方法を試しました」 | 3つ未満 = 尽くしていない | L2 |
| 「おそらく環境の問題です」 | 検証したか？ | L2 |
| 「もっとコンテキストが必要です」 | ツールがある。まず検索、それから質問 | L2 |
| 「解決できません」 | メソドロジーを完了したか？ | L4 |
| 「十分良い」 | 最適化リストは忖度しない | L3 |
| 検証なしで完了を宣言 | ビルドを実行したか？ | L2 |
| ユーザーの指示を待っている | オーナーは催促を待たない | Nudge |
| 解決せずに回答 | 君はエンジニアだ、検索エンジンではない | Nudge |
| ビルド/テストなしでコード変更 | テストなしの出荷 = 手抜き | L2 |
| 「APIがサポートしていません」 | ドキュメントを読んだか？ | L2 |
| 「タスクが曖昧すぎます」 | ベストな推測をして、それからイテレーション | L1 |
| 同じ場所を繰り返し調整 | パラメータ変更 ≠ アプローチ変更 | L1→L2 |

---

## Hooks自動化

Block Breakは自動動作のためにhooksシステムを使用します — 手動起動は不要です：

| Hook | トリガー | 動作 |
|------|---------|------|
| `UserPromptSubmit` | ユーザー入力がフラストレーションキーワードに一致 | Block Breakを自動起動 |
| `PostToolUse` | Bashコマンド実行後 | 失敗を検出、自動カウント + エスカレーション |
| `PreCompact` | コンテキスト圧縮前 | `~/.forge/`に状態を保存 |
| `SessionStart` | セッション再開/リスタート | プレッシャーレベルを復元（2時間有効） |

> **状態は永続化されます** — プレッシャーレベルは`~/.forge/block-break-state.json`に保存されます。コンテキスト圧縮やセッション中断によって失敗カウントはリセットされません。逃げ場なし。

### Hooksセットアップ

`claude plugin add juserai/forge`でインストールすると、hooksは自動的に設定されます。hookスクリプトにはJSONエンジンとして`jq`（推奨）または`python`が必要です — 少なくとも一つがシステムで利用可能である必要があります。

hooksが起動しない場合は、設定を確認してください：

```bash
cat ~/.claude/settings.json  # Should contain hooks entries referencing forge plugin
```

### 状態の有効期限

状態は**2時間**の非アクティブ後に自動的に期限切れになります。これにより、前回のデバッグセッションからの古いプレッシャーが無関係な作業に持ち越されることを防ぎます。2時間後、セッション復元hookは静かに復元をスキップし、L0から新たに開始します。

いつでも手動でリセット：`rm ~/.forge/block-break-state.json`

---

## Sub-agent制約

Sub-agentを生成する際、「無防備な実行」を防ぐために行動制約を注入する必要があります：

```javascript
Agent({
  subagent_type: "forge:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker`は、sub-agentも3つのレッドライン、5ステップメソドロジー、クローズドループ検証に従うことを保証します。

---

## トラブルシューティング

| 問題 | 原因 | 修正 |
|------|------|------|
| Hooksが自動トリガーしない | プラグイン未インストールまたはhooksがsettings.jsonにない | `claude plugin add juserai/forge`を再実行 |
| 状態が永続化しない | `jq`も`python`も利用不可 | いずれかをインストール：`apt install jq`または`python`がPATHにあることを確認 |
| プレッシャーがL4で固定 | 状態ファイルに失敗が蓄積しすぎ | リセット：`rm ~/.forge/block-break-state.json` |
| セッション復元が古い状態を表示 | 前回のセッションからの状態が2時間未満 | 想定通りの動作；2時間待つか手動でリセット |
| `/block-break`が認識されない | 現在のセッションでskillが読み込まれていない | プラグインを再インストールまたはユニバーサルワンライナーインストールを使用 |

---

## FAQ

### Block BreakとPUAの違いは？

Block Breakは[PUA](https://github.com/tanweai/pua)のコアメカニズム（3つのレッドライン、プレッシャーエスカレーション、メソドロジー）に着想を得ていますが、より集中しています。PUAには13種の企業文化フレーバー、マルチロールシステム（P7/P9/P10）、自己進化がありますが、Block Breakは依存関係ゼロのskillとして行動制約に純粋に焦点を当てています。

### うるさくないですか？

サイドバーの密度は制御されています：シンプルなタスクには2行（開始 + 終了）、複雑なタスクにはマイルストーンごとに1行。スパムなし。必要なければ`/block-break`を使わないでください — hooksはフラストレーションキーワードが検出された時のみ自動トリガーされます。

### プレッシャーレベルのリセット方法は？

状態ファイルを削除：`rm ~/.forge/block-break-state.json`。または2時間待つ — 状態は自動的に期限切れになります（上記の[状態の有効期限](#状態の有効期限)を参照）。

### Claude Code以外でも使えますか？

コアのSKILL.mdはシステムプロンプトをサポートするあらゆるAIツールにコピー＆ペーストできます。Hooksと状態の永続化はClaude Code固有です。

### Ralph Boostとの関係は？

[Ralph Boost](ralph-boost-guide.md)はBlock Breakのコアメカニズム（L0-L4、5ステップメソドロジー、7ポイントチェックリスト）を**自律ループ**シナリオに適応させたものです。Block Breakはインタラクティブセッション用（hooks自動トリガー）；Ralph Boostは無人開発ループ用（Agentループ / スクリプト駆動）。コードは完全に独立、コンセプトは共有です。

### Block Breakのskillファイルの検証方法は？

[Skill Lint](skill-lint-guide.md)を使用：`/skill-lint .`

---

## 使用場面 / 不向きな場面

### ✅ 使うべきとき

- Claude gave up too easily ("I can't", rationalized impossibility)
- The same fix attempt has failed 2-3 times
- You need exhaustive diagnosis before accepting defeat

### ❌ 使うべきでないとき

- Doing creative / divergent work (pressure kills exploration)
- The task is genuinely impossible (missing hardware, no permissions)
- You want to pause and step back on purpose

> 徹底的デバッグのエンジン — agent が早く諦めないことを保証するが、出力される解決策が正しいとは限らない。

完全な境界分析: [references/scope-boundaries.md](../../../skills/block-break/references/scope-boundaries.md)

---

## ライセンス

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
