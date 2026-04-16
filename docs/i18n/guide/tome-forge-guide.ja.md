# Tome Forge ユーザーガイド

> 5分で始めよう — LLMコンパイル型ウィキによる個人ナレッジベース

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserai/forge
```

### ユニバーサルワンライナーインストール

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/tome-forge/SKILL.md
```

> **依存関係ゼロ** — Tome Forgeは外部サービス、ベクトルDB、RAGインフラを一切必要としません。インストールしてすぐに使えます。

---

## コマンド

| コマンド | 機能 | 使用するタイミング |
|---------|------|-----------------|
| `/tome-forge init` | ナレッジベースを初期化 | 任意のディレクトリで新しいKBを開始するとき |
| `/tome-forge capture [text]` | メモ、リンク、クリップボードのクイックキャプチャ | 思いつきのメモ、URL保存、クリッピング |
| `/tome-forge capture clip` | システムクリップボードからキャプチャ | コピーした内容のクイック保存 |
| `/tome-forge ingest <path>` | 生素材をウィキにコンパイル | `raw/`に論文、記事、メモを追加した後 |
| `/tome-forge ingest <path> --dry-run` | 書き込みなしでルーティングをプレビュー | 変更をコミットする前に確認 |
| `/tome-forge query <question>` | ウィキから検索・統合 | ナレッジベース全体から回答を見つける |
| `/tome-forge lint` | ウィキ構造のヘルスチェック | コミット前、定期メンテナンス |
| `/tome-forge compile` | すべての新しい生素材を一括コンパイル | 複数の生ファイルを追加した後のキャッチアップ |

---

## 仕組み

KarpathyのLLMウィキパターンに基づいています：

```
raw materials + LLM compilation = structured Markdown wiki
```

### 二層アーキテクチャ

| レイヤー | 所有者 | 目的 |
|---------|--------|------|
| `raw/` | あなた | 不変のソース素材 — 論文、記事、メモ、リンク |
| `wiki/` | LLM | コンパイルされた、構造化された、相互参照付きMarkdownページ |

LLMがあなたの生素材を読み取り、適切に構造化されたウィキページにコンパイルします。`wiki/`を直接編集することはありません — 生素材を追加し、LLMにウィキの管理を任せます。

### 聖域セクション

すべてのウィキページに`## 私の理解の差分`セクションがあります。これは**あなたのもの**です — LLMは決してこれを変更しません。個人的な洞察、異論、直感をここに書いてください。すべての再コンパイルを通じて保持されます。

---

## KBディスカバリー — データはどこに行く？

**任意のディレクトリ**から`/tome-forge`を実行できます。適切なKBが自動的に検出されます：

| 状況 | 何が起こるか |
|------|------------|
| 現在のディレクトリ（または親）に`.tome-forge.json`がある | そのKBを使用 |
| 上方に`.tome-forge.json`が見つからない | デフォルトの`~/.tome-forge/`を使用（必要に応じて自動作成） |

これは、最初に`cd`することなく任意のプロジェクトからメモをキャプチャできることを意味します — すべてがデフォルトの単一KBに集約されます。

プロジェクトごとに別々のKBが必要ですか？そのプロジェクトディレクトリ内で`init .`を使用してください。

## ワークフロー

### 1. 初期化

```
/tome-forge init                  # Create default KB at ~/.tome-forge/
/tome-forge init .                # Create KB in current directory
/tome-forge init ~/research-kb    # Create KB at a specific path
```

初期化後、KBディレクトリは以下のようになります：

```
~/.tome-forge/               # (or wherever you initialized)
├── .tome-forge.json         # KB marker (auto-generated)
├── CLAUDE.md                # KB schema and rules
├── index.md                 # Wiki page index
├── .gitignore
├── logs/                    # Operation logs (monthly rotation)
│   └── 2026-04.md           # One file per month, never grows too large
├── raw/                     # Your source materials (immutable)
└── wiki/                    # LLM-compiled wiki (auto-maintained)
```

### 2. キャプチャ

**任意のディレクトリ**から実行するだけです：

```
/tome-forge capture "attention is fundamentally a soft dictionary lookup"
/tome-forge capture https://arxiv.org/abs/1706.03762
```

クイックキャプチャは`raw/captures/{date}/`に保存されます。長い素材の場合は、ファイルを直接`raw/papers/`、`raw/articles/`などに配置してください。

### 3. 取り込み

```
/tome-forge ingest raw/papers/attention-is-all-you-need.md
```

LLMが生ファイルを読み取り、適切なウィキページにルーティングし、個人的なメモを保持しながら新しい情報をマージします。

### 4. クエリ

```
/tome-forge query "what is the relationship between attention and transformers?"
```

ウィキから回答を統合し、具体的なページを引用します。情報が不足している場合は、追加すべき生素材を教えてくれます。

### 5. メンテナンス

```
/tome-forge lint
/tome-forge compile
```

Lintは構造的な整合性をチェックします。Compileは前回のコンパイル以降の新しいものをすべて一括取り込みします。

---

## ディレクトリ構造

```
my-knowledge-base/
├── .tome-forge.json       # KB marker (auto-generated)
├── CLAUDE.md              # Schema and rules (auto-generated)
├── index.md               # Wiki page index
├── .last_compile          # Timestamp for batch compile
├── logs/                  # Operation logs (monthly rotation)
│   └── 2026-04.md
├── raw/                   # Your source materials (immutable)
│   ├── captures/          # Quick captures by date
│   ├── papers/            # Academic papers
│   ├── articles/          # Blog posts, articles
│   ├── books/             # Book notes
│   └── conversations/     # Chat logs, interviews
└── wiki/                  # LLM-compiled wiki (auto-maintained)
    ├── ai/                # Domain directories
    ├── systems/
    └── ...
```

---

## ウィキページフォーマット

すべてのウィキページは厳格なテンプレートに従います：

```yaml
---
domain: ai
maturity: growing        # draft | growing | stable | deprecated
last_compiled: 2026-04-15
source_refs:
  - raw/papers/attention.md
confidence: medium       # low | medium | high
compiled_by: claude-opus-4-6
---
```

必須セクション：
- **コアコンセプト** — LLMが管理するナレッジ
- **私の理解の差分** — あなたの個人的な洞察（LLMは決して触れません）
- **未解決の質問** — 未回答の質問
- **関連ページ** — 関連するウィキページへのリンク

---

## 推奨ペース

| 頻度 | アクション | 時間 |
|------|----------|------|
| **毎日** | 思いつき、リンク、クリップボードの`capture` | 2分 |
| **毎週** | 週の生素材を一括処理する`compile` | 15〜30分 |
| **毎月** | `lint` + 私の理解の差分セクションのレビュー | 30分 |

**リアルタイム取り込みは避けてください。** 頻繁な単一ファイルの取り込みはウィキの一貫性を断片化します。週次の一括コンパイルの方が、より良い相互参照とより一貫性のあるページを生成します。

---

## スケーリングロードマップ

| フェーズ | ウィキサイズ | 戦略 |
|---------|-----------|------|
| 1. コールドスタート（1〜4週目） | < 30ページ | フルコンテキスト読み取り、index.mdルーティング |
| 2. 定常状態（2〜3ヶ月目） | 30〜100ページ | トピックシャーディング（wiki/ai/、wiki/systems/） |
| 3. スケール（4〜6ヶ月目） | 100〜200ページ | シャードスコープクエリ、ripgrep補完 |
| 4. アドバンスド（6ヶ月以上） | 200+ページ | エンベディングベースルーティング（検索ではなく）、インクリメンタルコンパイル |

---

## 既知のリスク

| リスク | 影響 | 緩和策 |
|--------|------|--------|
| **表現のドリフト** | 複数回のコンパイルで個人的な文体が平滑化される | `compiled_by`でモデルを追跡; raw/が真実の源; いつでもrawから再コンパイル可能 |
| **スケール上限** | コンテキストウィンドウがウィキサイズを制限 | ドメイン別にシャード; インデックスルーティングを使用; > 200ページでエンベディング層 |
| **ベンダーロックイン** | 一つのLLMプロバイダーに依存 | 生ソースはプレーンMarkdown; モデルを切り替えて再コンパイル |
| **デルタの破損** | LLMが個人的な洞察を上書き | 取り込み後のdiff検証が元のデルタを自動復元 |

---

## プラットフォーム

| プラットフォーム | 動作方法 |
|----------------|---------|
| Claude Code | 完全なファイルシステムアクセス、並列読み取り、git統合 |
| OpenClaw | 同じ操作、OpenClawツール規約に適応 |

---

## FAQ

**Q: ウィキはどのくらい大きくなれますか？**
A: 50ページ未満ではLLMがすべてを読みます。50〜200ページではインデックスを使ってナビゲートします。200を超えたらドメインシャーディングを検討してください。

**Q: ウィキページを直接編集できますか？**
A: `## 私の理解の差分`セクションのみ可能です。それ以外はすべて次回の取り込み/コンパイルで上書きされます。

**Q: ベクトルデータベースは必要ですか？**
A: いいえ。ウィキはプレーンMarkdownです。LLMはファイルを直接読みます — エンベディングなし、RAGなし、インフラなし。

**Q: KBのバックアップ方法は？**
A: すべてgitリポジトリ内のファイルです。`git push`で完了です。

**Q: LLMがウィキで間違いを犯した場合は？**
A: `raw/`に修正を追加して再取り込みしてください。マージアルゴリズムはより権威あるソースを優先します。または、私の理解の差分に異論を記録してください。
