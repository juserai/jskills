# Peer Fuse v0.1.0 ガイド

> 研究成果物向けの汎用ピアレビュアー — **8 段階パイプライン（Stage 7 KB アーカイブは必須かつ観測可能、`--no-save` でオプトアウト）+ 10 フォーマット入力アダプター（md / pdf / docx / pptx / doc / ppt / odt / odp / txt / html、3 階層ディスパッチ）+ 6 研究タイププリセット（自動分類）+ 8 次元加重ルーブリック + 18 フラグ分類体系 + 3 視点パネル + § Document Reading フリーズ（レビュー隔離のハード制約）**。

Peer-Fuse は任意の markdown / PDF / Office ドキュメントを入力として受け取り、A+/A−/.../D の評価グレード、品質フラグの階層化リスト、多視点パネル合成、patch スタイルの diff 提案を含むピアレビューの markdown レポートを生成します。[insight-fuse Stage 6.5 reviewer](insight-fuse-guide.md) と共存します — Stage 6.5 は IF 内部の同一ソースレビューであり、peer-fuse は Stage 6.5 では扱えないフォーマットや skill を担当する **クロス skill 外部レビュアー** です。

## クイックスタート

```bash
# タイプ自動分類、デフォルト深度、KB へアーカイブ
/peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# PDF 学術論文（タイプは arXiv/IEEE/Nature ヘッダから自動検出）
/peer-fuse papers/transformer-2017.pdf

# 明示的タイプ指定の PPTX デッキ
/peer-fuse decks/q4-roadmap.pptx --type product

# 高速深度（Stage 4 パネル + Stage 5.5 全体評価をスキップ）+ KB アーカイブをスキップ
/peer-fuse handbook.docx --depth quick --no-save

# ヘルプ表示
/peer-fuse help
# または引数なし
/peer-fuse
```

## デフォルトとフラグ

| フラグ | デフォルト | 値 |
|---|---|---|
| `--type` | **`auto`** | auto / overview / technology / market / academic / product / competitive |
| `--depth` | `standard` | quick / standard / deep / full |
| `--no-save` | `false` | フラグ — Stage 7 KB アーカイブをスキップ、コンソール出力のみ |

`--type=auto` の場合、peer-fuse はドキュメント読み込み後にヒューリスティックで分類します（frontmatter type フィールド → セクションパターン → 引用密度 → フォーマット/タイトルヒント → フォールバック overview）。優先順位チェーンは [skills/peer-fuse/references/type-classifier.md](../../skills/peer-fuse/references/type-classifier.md) を参照。

## サポートフォーマット

| 階層 | ツール要件 | フォーマット |
|:-:|---|---|
| 1 | なし（ネイティブ） | `.md`, `.markdown`, `.txt`, `.pdf` |
| 2 | `pandoc` | `.docx`, `.html`, `.htm`, `.rtf`, `.odt` |
| 3 | `libreoffice`（`.doc` には + `pandoc`） | `.doc`, `.ppt`, `.pptx`, `.odp` |

ツール不在 → 具体的なインストールヒント（`brew install pandoc`, `apt install libreoffice` など）と共に fail-soft し、Stage 1 前に終了します。[skills/peer-fuse/references/format-adapters.md](../../skills/peer-fuse/references/format-adapters.md) を参照。

## 得られる成果物

並列の 2 つの成果物：

1. **会話内インラインレンダリングのレビュー**、以下の構造：
   - § Document Reading — 記述的ナラティブ（ドキュメントが何を述べているか）、3-5 段落、300-600 語
   - § Holistic Assessment — 評価的ナラティブ（方法論 / 強み / 懸念 / 推奨）、4 段落、400-700 語
   - § Score Matrix — 8 次元加重スコア → 文字グレード
   - § Flag List — 18 分類体系のフラグコードと位置
   - § Multi-Perspective Panel — methodologist / adversarial / practitioner の判定
   - § Diff Suggestions — 各減点項目に対する patch スタイルの書き換え
   - § Reconciliation — target self-grade と review_grade の Δ

2. **KB アーカイブ** は `{kb_root}/raw/reports/peer-fuse/{YYYY-MM-DD}-{slug}-review.md`（`--no-save` でスキップ）。アーカイブログ行 `Archived to KB: <path>` は常にユーザー可視レスポンスに表示されます。

## ハード制約: § Document Reading はレビュー隔離

peer-fuse における最も重要なアーキテクチャ決定：

**§ Document Reading はレビュー判定で汚染されてはならない。** これはレビュアーによるドキュメントの忠実で記述的な読解 — frontmatter、構造、主張、エビデンス、スコープ。Stage 3.5 で実行され、Stage 4 パネルおよび Stage 5 採点 **より前**、入力境界は厳格：

- ✅ 受け入れ: 元ドキュメント、Stage 1-3 の事実スキャン結果
- ❌ 拒否: パネル判定、スコア、フラグヒット

このセクションは Stage 3.5 後に **フリーズ** されます: Stage 4 前に SHA-256 ハッシュが取得され、Stage 7 がアーカイブ前にハッシュを検証します。いかなる変更も → fail-closed。Lint もこのセクションから評価的語彙（`grade / score / flag / strong / weak / concern / 优点 / 缺点 / 应当 / 建议`）と文字グレードリテラルを禁止します。

これはユーザー指定のハード制約であり、3 レベルで強制されます: アーキテクチャ的隔離 + write-once フリーズ + 禁止語 lint。

## 他の forge skill との相互作用

| Skill | 関係 |
|---|---|
| **insight-fuse** Stage 6.5 reviewer | 共存 — Stage 6.5 は IF 内部の同一ソースレビュー（同じルーブリック、同じヒューリスティック、IF markdown のみ）。peer-fuse はより広い 8 次元ルーブリック、18 フラグ、10 フォーマット、3 agent パネルを持つ **クロス skill 外部レビュー**。重要な IF レポートには両方を実行すべき。 |
| **council-fuse** | 兄弟 crucible — peer-fuse は council-fuse の並列 sub-agent ディスパッチパターンを再利用（Stage 4 パネルは council-fuse Stage 1 をミラー）。 |
| **tome-forge** | アーカイブバックエンド — peer-fuse Stage 7 は tome-forge の report-archival-protocol を呼び出し、KB 書き込みロジックを再実装しません。 |
| **skill-lint** | パターン上の兄弟（カテゴリは異なる、anvil） — どちらも成果物を判定し診断を出力するが、skill-lint は一時的なコンソール診断を出力する一方、peer-fuse は永続的な markdown ピアレビュー成果物を出力。 |

## peer-fuse と IF Stage 6.5 の使い分け

| シナリオ | 使用 |
|---|:-:|
| `/insight-fuse <topic>` を実行したばかりで IF レポートにセカンドオピニオンが欲しい | IF Stage 6.5 はインラインで既に実行済み; クロスフォーマット対応のセカンドレイヤー外部レビューが欲しい場合は `/peer-fuse <if-output-path>` を実行 |
| 評価対象のサードパーティ PDF 研究論文がある | peer-fuse |
| 採点したい PPTX ビジネスデッキがある | peer-fuse |
| 採点したい council-fuse 合成出力がある | peer-fuse |
| 同一ルーブリックで複数の成果物を比較したい | peer-fuse（成果物間で一貫したスコアリング） |

## 具体例

```bash
$ /peer-fuse raw/reports/insight-fuse/2026-05-06-ai-hallucination-overview.md

# Stage 0.5 detection
target_format=md (Tier 1)
research_type=academic (auto, rule-2 section-pattern academic)
type_detection=auto

# Stage 3.5 produces § Document Reading (frozen)
# Stage 4 panel runs 3 sub-agents in parallel
# Stage 5 scoring → 8.6 / A-
# Stage 5.5 holistic assessment
# Stage 6 diff suggestions: 5 blocks
# Stage 7 archive

Archived to KB: /Users/.../raw/reports/peer-fuse/2026-05-07-ai-hallucination-overview-review.md
```

コンソールはレビュー全文をインラインでレンダリングし、KB アーカイブが永続的な正典バージョンです。

## 検証

```bash
# 静的チェック
bash skills/skill-lint/scripts/skill-lint.sh .

# トリガーテスト
bash evals/peer-fuse/run-trigger-test.sh

# ハッシュ lockstep
bash scripts/recalc-all-hashes.sh
```

## 関連項目

- [skills/peer-fuse/SKILL.md](../../skills/peer-fuse/SKILL.md) — ランタイム skill 定義
- [docs/design/crucible/peer-fuse-design.md](../design/crucible/peer-fuse-design.md) — アーキテクチャ決定 + 4 分類根拠
- [openspec/changes/archive/add-peer-fuse-skill/](../../openspec/changes/archive/add-peer-fuse-skill/) — RFC（マージ後）
- [docs/user-guide/insight-fuse-guide.md](insight-fuse-guide.md) — 兄弟 crucible
- [docs/user-guide/council-fuse-guide.md](council-fuse-guide.md) — 兄弟 crucible（パネルパターンのソース）
