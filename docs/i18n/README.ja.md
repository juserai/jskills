# Forge

> 全力で取り組み、ひと休みする。Claude Code との開発リズムを整える 7 つの skill。

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-7-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

## インストール

```bash
# Claude Code（コマンド一発）
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Hammer

| Skill | 機能 | 試してみる |
|-------|------|------------|
| **block-break** | あらゆるアプローチを尽くすまで諦めさせない | `/block-break` |
| **ralph-boost** | 収束を保証する自律型開発ループ | `/ralph-boost setup` |

### Crucible

| Skill | 機能 | 試してみる |
|-------|------|------------|
| **council-fuse** | 多角的な議論で、より良い回答を導く | `/council-fuse <question>` |
| **insight-fuse** | 体系的なマルチソース調査で専門レポートを生成 | `/insight-fuse <topic>` |
| **tome-forge** | LLMで編纂するパーソナルナレッジベース | `/tome-forge init` |

### Anvil

| Skill | 機能 | 試してみる |
|-------|------|------------|
| **skill-lint** | Claude Code skill プラグインを検証 | `/skill-lint .` |

### Quench

| Skill | 機能 | 試してみる |
|-------|------|------------|
| **news-fetch** | コーディングの合間にサッとニュースチェック | `/news-fetch AI today` |

---

## Block Break — 行動制約エンジン

AI がまた諦めた？ `/block-break` であらゆる手段を尽くさせましょう。

Claude が行き詰まると、Block Break はプレッシャー段階的エスカレーションを発動し、早期の投降を阻止します。「もうできません」という回答を許す前に、段階的に厳しくなる問題解決プロセスを強制的に実行させます。

| 仕組み | 説明 |
|--------|------|
| **3 つのレッドライン** | 閉ループ検証 / 事実駆動 / 全選択肢の網羅 |
| **プレッシャーエスカレーション** | L0 信頼 → L1 失望 → L2 尋問 → L3 業績評価 → L4 卒業 |
| **5 ステップメソッド** | 嗅ぎ取る → 髪をかきむしる → 鏡を見る → 新アプローチ → 振り返り |
| **7 項目チェックリスト** | L3 以上で必須の診断チェックリスト |
| **言い訳ブロック** | よくある 14 パターンの言い訳を検知・遮断 |
| **Hooks** | フラストレーション自動検知 + 失敗カウント + 状態永続化 |

```text
/block-break              # Block Break モードを起動
/block-break L2           # 指定のプレッシャーレベルから開始
/block-break fix the bug  # 起動してすぐにタスクを実行
```

自然言語でもトリガーできます：`try harder`、`stop spinning`、`figure it out`、`you keep failing` など（hooks が自動検知）。

> [PUA](https://github.com/tanweai/pua) の核心メカニズムを参考に、ゼロ依存の skill として再構築。

## Ralph Boost — 自律型開発ループエンジン

本当に収束する自律型開発ループ。セットアップは 30 秒。

ralph-claude-code の自律ループ機能を skill として再現し、Block Break L0-L4 プレッシャーエスカレーションを内蔵して収束を保証します。自律ループで「堂々巡り」になる問題を解決します。

| 特徴 | 説明 |
|------|------|
| **デュアルパスループ** | Agent ループ（メイン、外部依存ゼロ）+ bash スクリプトフォールバック（jq/python エンジン） |
| **強化サーキットブレーカー** | L0-L4 プレッシャーエスカレーション内蔵：「3 ラウンドで諦め」から「6-7 ラウンドの段階的自己救済」へ |
| **状態追跡** | サーキットブレーカー + プレッシャー + 戦略 + セッションを統一 state.json で管理 |
| **グレースフルハンドオフ** | L4 到達時、クラッシュではなく構造化されたハンドオフレポートを生成 |
| **独立動作** | `.ralph-boost/` ディレクトリを使用、ralph-claude-code への依存なし |

```text
/ralph-boost setup        # プロジェクトを初期化
/ralph-boost run          # 自律ループを開始
/ralph-boost status       # 現在の状態を確認
/ralph-boost clean        # クリーンアップ
```

> [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) の自律ループ機能を参考に、ゼロ依存の skill として収束保証付きで再構築。

## Skill Lint — Skill プラグインバリデーター

コマンド一発で Claude Code プラグインを検証。

Claude Code plugin プロジェクトの skill ファイルについて、構造の整合性と意味的な品質をチェックします。Bash スクリプトが構造チェックを、AI が意味チェックを担当し、相互に補完します。

| チェック種別 | 説明 |
|-------------|------|
| **構造チェック** | frontmatter 必須フィールド / ファイル存在確認 / references 参照 / marketplace エントリ |
| **意味チェック** | description の品質 / name の一貫性 / command ルーティング / eval カバレッジ |

```text
/skill-lint              # 使い方を表示
/skill-lint .            # 現在のプロジェクトを検証
/skill-lint /path/to/plugin  # 指定パスを検証
```

## News Fetch — スプリントの合間のリフレッシュ

デバッグ疲れしていませんか？ `/news-fetch` で 2 分間の気分転換を。

他の skill はあなたを追い込みます。この skill は深呼吸を思い出させてくれます。ターミナルから直接、好きなトピックの最新ニュースを取得できます。コンテキストスイッチ不要、ブラウザの沼にハマる心配もなし。サッと目を通して、リフレッシュしたら仕事に戻りましょう。

| 特徴 | 説明 |
|------|------|
| **3 段フォールバック** | L1 WebSearch → L2 WebFetch（地域ソース）→ L3 curl |
| **重複排除・統合** | 同一イベントの複数ソースを自動統合、最高スコアを保持 |
| **関連性スコアリング** | AI がトピックとの一致度でスコア付け・ソート |
| **自動要約** | 要約がない場合、記事本文から自動生成 |

```text
/news-fetch AI                    # 今週の AI ニュース
/news-fetch AI today              # 今日の AI ニュース
/news-fetch robotics month        # 今月のロボティクスニュース
/news-fetch climate 2026-03-01~2026-03-31  # 期間を指定
```

## Council Fuse — 多角的議論エンジン

構造化された議論でより良い回答を。`/council-fuse` は3つの独立した視点を生成し、匿名で評価した後、最良の回答を統合します。

[Karpathy の LLM Council](https://github.com/karpathy/llm-council) にインスパイア — 1コマンドに凝縮。

| 仕組み | 説明 |
|--------|------|
| **3つの視点** | ジェネラリスト（バランス） / クリティック（批判的） / スペシャリスト（技術深堀） |
| **匿名評価** | 4次元評価：正確性、完全性、実用性、明確性 |
| **統合** | 最高評価の回答を骨格に、独自の洞察を融合 |
| **少数意見** | 有効な反論は保持、消さない |

```text
/council-fuse マイクロサービスにすべきか？
/council-fuse このエラーハンドリングパターンをレビュー
/council-fuse Redis vs PostgreSQL ジョブキュー用途
```

## Insight Fuse — マルチソース調査エンジン

トピックから専門的な調査レポートへ。`/insight-fuse` は5段階の漸進的パイプラインを実行：スキャン → アライメント → リサーチ → レビュー → ディープダイブ。

多角的分析（ジェネラリスト/クリティック/スペシャリスト）内蔵、拡張可能なレポートテンプレート、設定可能な深度。council-fuse の姉妹スキル — council-fuse が既知情報を議論する一方、insight-fuse は新しい情報を積極的に収集・統合します。

| 仕組み | 説明 |
|--------|------|
| **5段階パイプライン** | スキャン → アライメント → リサーチ → レビュー → ディープダイブ |
| **設定可能な深度** | quick（スキャンのみ）/ standard（自動リサーチ）/ deep（+ 多角的分析）/ full（+ 人的チェックポイント） |
| **3つの視点** | ジェネラリスト（広さ） / クリティック（検証） / スペシャリスト（精度） |
| **レポートテンプレート** | technology / market / competitive / カスタム — または自動生成 |
| **品質基準** | マルチソース必須、引用整合性、ソース多様性チェック |

```text
/insight-fuse AI Agent 安全風険
/insight-fuse --depth quick --template technology WebAssembly
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 量子コンピューティング商業化
```

## Tome Forge — パーソナルナレッジベースエンジン

LLMが編纂・維持するパーソナルナレッジベースを構築。[Karpathy の LLM Wiki パターン](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)に基づく — 生のMarkdownを構造化wikiにコンパイル、RAGやベクトルDBは不要。

| 特徴 | 説明 |
|------|------|
| **3層アーキテクチャ** | 生ソース（不変） / Wiki（LLMコンパイル） / Schema（CLAUDE.md） |
| **6つの操作** | init、capture、ingest、query、lint、compile |
| **My Understanding Delta** | 人間の洞察専用セクション — LLMは上書きしない |
| **ゼロインフラ** | 純粋なMarkdown + Git。データベース、埋め込み、サーバー不要 |

```text
/tome-forge init              # 現在のディレクトリでKBを初期化
/tome-forge capture "idea"    # クイックキャプチャ
/tome-forge ingest raw/paper  # 生素材をwikiにコンパイル
/tome-forge query "question"  # 検索と統合
/tome-forge lint              # wikiの健全性チェック
/tome-forge compile           # 新素材を一括コンパイル
```

> [Karpathy の LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) にインスパイア、ゼロ依存スキルとして構築。

## 品質保証

- skill ごとに 10 以上の評価シナリオと自動トリガーテスト
- 自前の skill-lint でセルフ検証済み
- 外部依存ゼロ — リスクゼロ
- MIT ライセンス、完全オープンソース

## プロジェクト構成

```text
forge/
├── skills/                        # Claude Code プラットフォーム
│   └── <skill>/
│       ├── SKILL.md               # Skill 定義
│       ├── references/            # オンデマンドで読み込む詳細コンテンツ
│       ├── scripts/               # ヘルパースクリプト
│       └── agents/                # Sub-agent 定義
├── platforms/                     # 他プラットフォーム対応
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw 向け適応版
│           ├── references/        # プラットフォーム固有コンテンツ
│           └── scripts/           # プラットフォーム固有スクリプト
├── .claude-plugin/                # Claude Code marketplace メタデータ
├── hooks/                         # Claude Code プラットフォーム hooks
├── evals/                         # クロスプラットフォーム評価シナリオ
├── docs/                          # クロスプラットフォームドキュメント
└── plugin.json                    # コレクションメタデータ
```

## コントリビュート

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw 向け適応版 + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — 評価シナリオ
4. `.claude-plugin/marketplace.json` — `plugins` 配列にエントリを追加
5. hooks が必要な場合は `hooks/hooks.json` に追加

開発ガイドラインの詳細は [CLAUDE.md](../../CLAUDE.md) を参照してください。

## License

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
