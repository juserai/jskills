# Insight Fuse ユーザーガイド

> 体系的マルチソース調査エンジン — テーマからプロフェッショナルな調査レポートへ

## クイックスタート

```bash
# 完全調査（5段階、手動チェックポイント付き）
/insight-fuse AI Agent セキュリティリスク

# クイックスキャン（Stage 1のみ）
/insight-fuse --depth quick 量子コンピューティング

# 特定のテンプレートを使用
/insight-fuse --template technology WebAssembly

# カスタム視点による深掘り調査
/insight-fuse --depth deep --perspectives optimist,pessimist,pragmatist 自動運転の商業化

# 調査のみ、保存はしない（tome-forge KB への保存をスキップ）
/insight-fuse --depth quick --no-save 一時的な背景調査
```

## パラメータ

| パラメータ | 説明 | 例 |
|-----------|------|-----|
| `topic` | 調査テーマ（必須） | `AI Agent セキュリティリスク` |
| `--depth` | 調査の深さ | `quick` / `standard` / `deep` / `full` |
| `--template` | レポートテンプレート | `technology` / `market` / `competitive` |
| `--perspectives` | 視点リスト | `optimist,pessimist,pragmatist` |
| `--no-save` | KB アーカイブをスキップ（tome-forge インストール時の opt-out） | デフォルト `false`；付与すると調査のみで保存しない |

## 深度モード

### quick — クイックスキャン
Stage 1 を実行。3件以上の検索クエリ、5件以上のソース、簡潔なレポートを出力。テーマの概要を素早く把握するのに最適。

### standard — 標準調査
Stage 1 + 3 を実行。サブ問題を自動識別し、並行調査、包括的にカバー。手動操作不要。

### deep — 深掘り調査
Stage 1 + 3 + 5 を実行。標準調査をベースに、すべてのサブ問題を3つの視点から深く分析。手動操作不要。

### full（デフォルト） — 完全パイプライン
全5段階を実行。Stage 2 と Stage 4 は手動チェックポイントで、方向性のずれを防止。

## レポートテンプレート

### 組み込みテンプレート

- **technology** — 技術調査：アーキテクチャ、比較、エコシステム、トレンド
- **market** — 市場調査：規模、競争、ユーザー、予測
- **competitive** — 競合分析：機能マトリクス、SWOT、価格設定

### カスタムテンプレート

1. `templates/custom-example.md` を `templates/your-name.md` としてコピー
2. 章構成を変更
3. `{topic}` と `{date}` のプレースホルダーを保持
4. 最終章は「参考ソース」にすること
5. `--template your-name` で有効化

### テンプレートなしモード

`--template` を指定しない場合、エージェントが調査内容に基づいてレポート構成を自動生成。

## マルチ視点分析

### デフォルト視点

| 視点 | 役割 | モデル |
|------|------|--------|
| Generalist | 広範なカバー、主流の合意 | Sonnet |
| Critic | 検証・疑問提起、反証の発見 | Opus |
| Specialist | 技術的深掘り、一次ソース | Sonnet |

### 代替視点セット

| シナリオ | 視点 |
|----------|------|
| トレンド予測 | `--perspectives optimist,pessimist,pragmatist` |
| プロダクト調査 | `--perspectives user,developer,business` |
| 政策調査 | `--perspectives domestic,international,regulatory` |

### カスタム視点

`agents/insight-{name}.md` を作成し、既存のエージェントファイルの構造を参考にしてください。

## 品質保証

各レポートは自動的にチェックされます：
- 各章に最低2つの独立したソース
- 孤立した参照なし
- 単一ソースの占有率が40%を超えない
- すべての比較主張がデータで裏付けられている

## 使用場面 / 不向きな場面

### ✅ 使うべきとき

- Writing a professional research report from multiple sources
- You want configurable depth (scan → deep-dive)
- Multi-perspective crossing of new information

### ❌ 使うべきでないとき

- Quick factual lookup (overkill; use `claim-ground` / WebSearch)
- Single-source deep reading
- Tasks requiring primary research (interviews, field work)

> デスクリサーチのパイプライン — 多源統合を設定可能なプロセスに変えるが、一次調査はしない。

完全な境界分析: [references/scope-boundaries.md](../../../skills/insight-fuse/references/scope-boundaries.md)

---

## KB アーカイブと opt-out

レポート出力後、ローカルに tome-forge 知識ベースがインストールされている場合、insight-fuse は tome-forge のアーカイブプロトコルに従って**自動的に**レポートを保存しようとします。tome-forge が未インストールの場合、このステップは静かにスキップされます。

単発の調査で明示的に保存を避けたい場合（tome-forge インストール時の opt-out）、`--no-save` を付けます：

```bash
/insight-fuse --depth quick --no-save 一時的な背景調査
```

`--no-save` は KB アーカイブのみに影響します。レポート本体は従来どおりコンソールに出力されます。insight-fuse の `permissions.filesystem` は `none` であり、アーカイブ経路以外でファイル書き込みは一切行われません。

## council-fuse との違い

| | insight-fuse | council-fuse |
|---|---|---|
| **用途** | 能動的な調査 + レポート生成 | 既知情報に対するマルチ視点の議論 |
| **情報源** | WebSearch/WebFetch による収集 | ユーザーが提供する質問 |
| **出力** | 完全な調査レポート | 統合された回答 |
| **段階** | 5段階の漸進式 | 3段階（召集 → 評価 → 統合） |

両者は組み合わせて使用できます：まず insight-fuse で調査・情報収集を行い、次に council-fuse で重要な意思決定について深い議論を行います。
