# News Fetch ユーザーガイド

> 3分で始めよう — AIにニュースブリーフィングを取得させましょう

デバッグで疲れましたか？2分休憩して、世界で何が起きているかチェックして、リフレッシュして戻りましょう。

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserai/forge
```

### ユニバーサルワンライナーインストール

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/news-fetch/SKILL.md
```

> **依存関係ゼロ** — News Fetch は外部サービスやAPIキーを必要としません。インストールしてすぐに使えます。

---

## コマンド

| コマンド | 機能 | 使用タイミング |
|---------|------|--------------|
| `/news-fetch AI` | 今週のAIニュースを取得 | 業界の素早いアップデート |
| `/news-fetch AI today` | 今日のAIニュースを取得 | デイリーブリーフィング |
| `/news-fetch robotics month` | 今月のロボティクスニュースを取得 | 月次レビュー |
| `/news-fetch climate 2026-03-01~2026-03-31` | 特定の日付範囲のニュースを取得 | ターゲットリサーチ |

---

## ユースケース

### デイリーテックブリーフィング

```
/news-fetch AI today
```

今日の最新AIニュースを関連度順に取得。見出しと要約を数秒でスキャンできます。

### 業界リサーチ

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

市場分析や競合調査をサポートするために、特定の期間のニュースを取得します。

### クロスランゲージニュース

中国語のトピックは、より広範なカバレッジのために自動的に補足的な英語検索が行われ、その逆も同様です。追加の手間なく、両方の世界の最良のものが得られます。

---

## 期待される出力例

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## 3段階ネットワークフォールバック

News Fetch には、さまざまなネットワーク状況でニュース取得が機能するようにするためのフォールバック戦略が組み込まれています：

| 段階 | ツール | データソース | トリガー |
|------|--------|-----------|---------|
| **L1** | WebSearch | Google/Bing | デフォルト（推奨） |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1が失敗 |
| **L3** | Bash curl | L2と同じソース | L2も失敗 |

すべての段階が失敗した場合、各ソースの失敗理由をリストした構造化された失敗レポートが生成されます。

---

## 出力機能

| 機能 | 説明 |
|------|------|
| **重複排除** | 複数のソースが同じイベントをカバーしている場合、最高スコアのエントリが保持され、他は「関連報道」にまとめられます |
| **要約補完** | 検索結果に要約がない場合、記事本文を取得して要約を生成します |
| **関連度スコアリング** | AIがトピックの関連度で各結果をスコアリング — 高いほど関連性が高い |
| **クリック可能なリンク** | Markdownリンク形式 — IDEやターミナルでクリック可能 |

---

## 関連度スコアリング

各記事は、タイトルと要約がリクエストされたトピックにどの程度一致するかに基づいて0-300でスコアリングされます：

| スコア範囲 | 意味 |
|-----------|------|
| 200-300 | 非常に関連性が高い — トピックが主題 |
| 100-199 | 中程度に関連性がある — トピックが大きく言及されている |
| 0-99 | 接線的に関連性がある — トピックが付随的に登場 |

記事はスコアの降順でソートされます。スコアリングはヒューリスティックで、キーワード密度、タイトル一致、文脈的関連性に基づいています。

## ネットワークフォールバックのトラブルシューティング

| 症状 | 考えられる原因 | 対処法 |
|------|-------------|--------|
| L1が0件を返す | WebSearchツールが利用できないかクエリが具体的すぎる | トピックキーワードを広げる |
| L2のすべてのソースが失敗 | 国内ニュースサイトが自動アクセスをブロック | 待ってから再試行するか、`curl` が手動で動作するか確認 |
| L3 curlタイムアウト | ネットワーク接続の問題 | `curl -I https://news.baidu.com` を確認 |
| すべての段階が失敗 | インターネットアクセスなしまたはすべてのソースがダウン | ネットワークを確認；失敗レポートが各ソースのエラーをリスト |

---

## よくある質問

### APIキーは必要ですか？

いいえ。News Fetch は WebSearch と公開ウェブスクレイピングのみに依存しています。設定は不要です。

### 英語のニュースを取得できますか？

もちろんです。中国語のトピックには自動的に補足的な英語検索が含まれ、英語のトピックはネイティブに動作します。カバレッジは両言語に及びます。

### ネットワークが制限されている場合はどうなりますか？

3段階フォールバック戦略がこれを自動的に処理します。WebSearch が利用できなくても、News Fetch は国内のニュースソースにフォールバックします。

### 何件の記事が返されますか？

最大20件（重複排除後）。実際の件数はデータソースが返す内容に依存します。

---

## ライセンス

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
