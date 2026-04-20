# Skill Lint ユーザーガイド

> 3分で始める — Claude Code skillの品質を検証

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserai/forge
```

### ユニバーサルワンライナーインストール

```
Fetch and follow https://raw.githubusercontent.com/juserai/forge/main/skills/skill-lint/SKILL.md
```

> **依存関係ゼロ** — Skill Lint は外部サービスやAPIを必要としません。インストールしてすぐに使えます。

---

## コマンド

| コマンド | 機能 | 使用タイミング |
|---------|------|--------------|
| `/skill-lint` | 使用方法を表示 | 利用可能なチェックを確認 |
| `/skill-lint .` | 現在のプロジェクトをリント | 開発中のセルフチェック |
| `/skill-lint /path/to/plugin` | 特定のパスをリント | 別のプラグインをレビュー |

---

## ユースケース

### 新しいskill作成後のセルフチェック

`skills/<name>/SKILL.md`、`commands/<name>.md`、および関連ファイルを作成した後、`/skill-lint .` を実行して、構造が完全であること、frontmatterが正しいこと、marketplaceエントリが追加されていることを確認します。

### 他の人のプラグインをレビュー

PRのレビューや別のプラグインの監査時に、`/skill-lint /path/to/plugin` を使用してファイルの完全性と一貫性を素早くチェックします。

### CI統合

`scripts/skill-lint.sh` はCIパイプラインで直接実行でき、自動解析用のJSONを出力します：

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## チェック項目

### 構造チェック（Bashスクリプトで実行）

| ルール | チェック内容 | 重要度 |
|--------|-----------|--------|
| S01 | `plugin.json` がルートと `.claude-plugin/` の両方に存在する | error |
| S02 | `.claude-plugin/marketplace.json` が存在する | error |
| S03 | 各 `skills/<name>/` に `SKILL.md` が含まれている | error |
| S04 | SKILL.md の frontmatter に `name` と `description` が含まれている | error |
| S05 | 各skillに対応する `commands/<name>.md` がある | warning |
| S06 | 各skillが marketplace.json の `plugins` 配列に記載されている | warning |
| S07 | SKILL.md で参照されているファイルが実際に存在する | error |
| S08 | `evals/<name>/scenarios.md` が存在する | warning |

### セマンティックチェック（AIで実行）

| ルール | チェック内容 | 重要度 |
|--------|-----------|--------|
| M01 | 説明が目的とトリガー条件を明確に述べている | warning |
| M02 | 名前がディレクトリ名と一致し、説明がファイル間で一貫している | warning |
| M03 | コマンドルーティングロジックがskill名を正しく参照している | warning |
| M04 | リファレンスの内容がSKILL.mdと論理的に一貫している | warning |
| M05 | 評価シナリオがコア機能パスをカバーしている（最低5つ） | warning |

---

## 期待される出力例

### 全チェック合格

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### 問題が見つかった場合

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## ワークフロー

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## よくある質問

### セマンティックチェックなしで構造チェックのみ実行できますか？

はい — bashスクリプトを直接実行してください：

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

AIによるセマンティック分析なしの純粋なJSONを出力します。

### forge以外のプロジェクトでも動作しますか？

はい。標準的なClaude Codeプラグイン構造（`skills/`、`commands/`、`.claude-plugin/`）に従うどのディレクトリでも検証できます。

### エラーと警告の違いは何ですか？

- **error**：skillの読み込みや公開を妨げる構造的な問題
- **warning**：機能を壊さないが、保守性や発見性に影響する品質上の問題

### その他のforgeツール

Skill Lint はforgeコレクションの一部であり、以下のskillとうまく連携します：

- [Block Break](block-break-guide.md) — AIにあらゆるアプローチを尽くすことを強制する高エージェンシー行動制約エンジン
- [Ralph Boost](ralph-boost-guide.md) — Block Break収束保証を内蔵した自律開発ループエンジン

新しいskillを開発した後、`/skill-lint .` を実行して構造の完全性を検証し、frontmatter、marketplace.json、およびリファレンスリンクがすべて正しいことを確認してください。

---

## 使用場面 / 不向きな場面

### ✅ 使うべきとき

- Validating a Claude Code plugin's structure before release
- Checking integrity hash / convention compliance / i18n coverage
- As a CI/CD gate for plugin repositories

### ❌ 使うべきでないとき

- Non-plugin projects (rules don't apply; you'll get irrelevant errors)
- Production code quality review (not a linter / type checker / security scanner)
- License legal review (only checks the `license` field exists)

> Claude Code plugin の構造 CI — 規約準拠と hash 一貫性を保証するが、skill の実行時動作の正しさは保証しない。

完全な境界分析: [references/scope-boundaries.md](../../../skills/skill-lint/references/scope-boundaries.md)

---

## ライセンス

[MIT](../../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
